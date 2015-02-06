From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH 1/2] kernel/fork: handle put_user errors for
 CLONE_CHILD_SETTID/CLEARTID
Date: Fri, 06 Feb 2015 19:23:01 +0300
Message-ID: <20150206162301.18031.32251.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Roman Gushchin <klamm@yandex-team.ru>, Nikita Vetoshkin <nekto0n@yandex-team.ru>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>
List-Id: linux-api@vger.kernel.org

Currently kernel ignores put_user() errors when it writes tid for syscall
clone flags CLONE_CHILD_SETTID and CLONE_CHILD_CLEARTID.

Unfortunately this code always worked in this way. We cannot abort syscall
if client tid pointer is invalid.

This patch adds get_user() after failed put_user(): if this address is not
even readable then we leave it alone: user-space probably don't care about
pid or error will be noticed soon. If address is readable then application
might be mislead about it's own pid. In this case CLONE_CHILD_SETTID kills
child task. In same condition failed CLONE_CHILD_CLEARTID prints warning.

Nikita found script which sometimes hangs inside glibc in function fork()
in child task right after returning from syscall some glibc assert fails:

#0  __lll_lock_wait_private () at ../nptl/sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:93
#1  0x00007fabcc699087 in _L_lock_11477 at malloc.c:5249
#2  0x00007fabcc6973ed in __GI___libc_realloc at malloc.c:3054
#3  0x00007fabcc686dbd in _IO_vasprintf at vasprintf.c:86
#4  0x00007fabcc667747 in ___asprintf at asprintf.c:37
#5  0x00007fabcc642cfb in __assert_fail_base at assert.c:59
#6  0x00007fabcc642e42 in __GI___assert_fail at assert.c:103
#7  0x00007fabcc6d40b6 in __libc_fork at ../nptl/sysdeps/unix/sysv/linux/x86_64/../fork.c:142
#8  0x00007fabccad23cd in Perl_pp_system at pp_sys.c:4143c
#9  0x00007fabcca7fcd6 in Perl_runops_standard at run.c:41
#10 0x00007fabcca2139a in S_run_body at perl.c:2350
#11 perl_run at perl.c:2268
#12 0x0000000000400db9 in main at perlmain.c:120

Assert checks (THREAD_GETMEM (self, tid) != ppid). In child task pid still
equal to the parent pid! Write for CLONE_CHILD_SETTID had failed silently.
Unfortunately this assert in glibc is flawed, some internal locks are held
at this point and task hangs when tries to print out error message.

Usually memory allocations at page-faults are either completely successful
or task is killed by out of memory killer: buddy allocator handles 0-order
allocations as GFP_NOFAIL and retries them endlessly. OOM-killer in memory
cgroup works only for faulting from user-space. If kernel hits memcg limit
inside page-fault that will be handled as ordinary "Bad address": -EFAULT.

Whole sequence looks like: task calls fork, glibc calls syscall clone with
CLONE_CHILD_SETTID and passes pointer to TLS THREAD_SELF->tid as argument.
Child task gets read-only copy of VM including TLS. Child calls put_user()
to handle CLONE_CHILD_SETTID from schedule_tail(). put_user() trigger page
fault and it fails because do_wp_page()  hits memcg limit without invoking
OOM-killer because this is page-fault from kernel-space.  Put_user returns
-EFAULT, which is ignored.  Child returns into user-space and catches here
assert (THREAD_GETMEM (self, tid) != ppid), glibc tries to print something
but hangs on deadlock on internal locks. Halt and catch fire.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reported-by: Nikita Vetoshkin <nekto0n@yandex-team.ru>
---
 kernel/fork.c       |   15 ++++++++++++---
 kernel/sched/core.c |   16 ++++++++++++++--
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 4dc2dda..f71305d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -822,11 +822,20 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 	if (tsk->clear_child_tid) {
 		if (!(tsk->flags & PF_SIGNALED) &&
 		    atomic_read(&mm->mm_users) > 1) {
+			int dummy;
+
 			/*
-			 * We don't check the error code - if userspace has
-			 * not set up a proper pointer then tough luck.
+			 * We cannot report put_user fails - if userspace has
+			 * not set up a proper pointer then tough luck. It's
+			 * much worse if it's failed for some other reason:
+			 * for example memory shortage in CoW area, somebody
+			 * will wait us forever. Let's at least print warning.
 			 */
-			put_user(0, tsk->clear_child_tid);
+			if (unlikely(put_user(0, tsk->clear_child_tid)) &&
+			    !get_user(dummy, tsk->clear_child_tid) &&
+			    !fatal_signal_pending(current))
+				WARN_ON_ONCE(dummy);
+
 			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
 					1, NULL, NULL, 0);
 		}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e628cb1..74b33ff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2312,8 +2312,20 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	post_schedule(rq);
 	preempt_enable();
 
-	if (current->set_child_tid)
-		put_user(task_pid_vnr(current), current->set_child_tid);
+	if (current->set_child_tid &&
+	    unlikely(put_user(task_pid_vnr(current), current->set_child_tid))) {
+		int dummy;
+
+		/*
+		 * If this address is unreadable then userspace has not set
+		 * proper pointer. Application either doesn't care or will
+		 * notice this soon. If this address is readable then task
+		 * will be mislead about its own tid. It's better to die.
+		 */
+		if (!get_user(dummy, current->set_child_tid) &&
+		    !fatal_signal_pending(current))
+			force_sig(SIGSEGV, current);
+	}
 }
 
 /*
