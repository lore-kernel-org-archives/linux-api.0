From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 3/3] posix timers: Add syscall that works on timer sigevent
Date: Thu, 14 Feb 2013 20:19:45 +0400
Message-ID: <511D0EA1.9060704@parallels.com>
References: <511D0E50.7090505@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511D0E50.7090505-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The intention is to make a syscall, that works like sigaction
but on a posix timer. I.e. -- puts (if provided) new sigevent
on the timer and reports the previous value (if requested).

That said, the syscall accepts timer id to work on, a pointer
to the new sigevent (may be NULL, meaning that the existing
sigevent remains intact) and pointer to memory buffer where to
put the existing sigevent (may be NULL as well, sigevent is
not reported in this case).

For how I didn't implement the new sigevent assignment, as it
requires a little bit of trickery with timer. If the proposed
idea itself is OK useful I will implement this part as well in
the v2 series.

Signed-off-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 arch/x86/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h         |    3 +++
 kernel/posix-timers.c            |   28 ++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 72b6ee6..c2c1743 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -321,6 +321,7 @@
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
 314	common	timer_list		sys_timer_list
+315	64	timer_sigevent		sys_timer_sigevent
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index dc951da..7d121c5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -312,6 +312,9 @@ asmlinkage long sys_setitimer(int which,
 asmlinkage long sys_timer_create(clockid_t which_clock,
 				 struct sigevent __user *timer_event_spec,
 				 timer_t __user * created_timer_id);
+asmlinkage long sys_timer_sigevent(timer_t timer_id,
+				struct sigevent __user *new_event,
+				struct sigevent __user *old_event);
 asmlinkage long sys_timer_gettime(timer_t timer_id,
 				struct itimerspec __user *setting);
 asmlinkage long sys_timer_getoverrun(timer_t timer_id);
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 46cee59..29de379 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -1151,3 +1151,31 @@ try_again:
 out:
 	return nr;
 }
+
+SYSCALL_DEFINE3(timer_sigevent, timer_t, timer_id, struct sigevent __user *, new_event,
+		struct sigevent __user *, old_event)
+{
+	struct k_itimer *timer;
+	unsigned long flags;
+	struct sigevent event;
+	int ret = 0;
+
+	if (new_event)
+		return -EINVAL;
+
+	timer = lock_timer(timer_id, &flags);
+	if (!timer)
+		return -EINVAL;
+
+	event.sigev_notify = timer->it_sigev_notify;
+	event.sigev_signo = timer->sigq->info.si_signo;
+	event.sigev_value = timer->sigq->info.si_value;
+	event.sigev_notify_thread_id = pid_vnr(timer->it_pid);
+
+	unlock_timer(timer, flags);
+
+	if (old_event && copy_to_user(old_event, &event, sizeof(event)))
+		ret = -EFAULT;
+
+	return ret;
+}
-- 
1.7.6.5
