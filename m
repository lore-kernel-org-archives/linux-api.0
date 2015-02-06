From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH 2/2] kernel/fork: handle put_user errors for
 CLONE_PARENT_SETTID
Date: Fri, 06 Feb 2015 19:23:03 +0300
Message-ID: <20150206162303.18031.37408.stgit@buzz>
References: <20150206162301.18031.32251.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150206162301.18031.32251.stgit@buzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Nikita Vetoshkin <nekto0n-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Handling of flag CLONE_PARENT_SETTID has the same problem: error returned
from put_user() is ignored. Glibc completely relies on that feature and uses
value returned from syscall only for error checking.

Kernels older than v2.6.24 handled that correctly but check has been removed
in commit 30e49c263e36 ("pid namespaces: allow cloning of new namespace").
Commit message tells nothing about reason. I guess that was fix for commit
425fb2b4bf5d ("pid namespaces: move alloc_pid() lower in copy_process()")
which breaks this logic: after it kernel writes parent pid as child pid.

This patch moves related put_user() from do_fork() back into copy_process()
where it was before and where error can be handled.

Another problem is that before v2.6.24 CLONE_PARENT_SETTID stored child pid
both in parent and child memory. Documentation in man clone(2) also tells so.
In v2.6.24 put_user() was placed after copy_mm(), now only parent sees it.
LTP test which should check that is buggy too: it clones child with CLONE_VM.
It seems nobody have noticed this for seven years, probably we should leave
it as is and document existing behavior.

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
---
 kernel/fork.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f71305d..1ea2eae 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1194,6 +1194,7 @@ init_task_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
 static struct task_struct *copy_process(unsigned long clone_flags,
 					unsigned long stack_start,
 					unsigned long stack_size,
+					int __user *parent_tidptr,
 					int __user *child_tidptr,
 					struct pid *pid,
 					int trace)
@@ -1416,6 +1417,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			goto bad_fork_cleanup_io;
 	}
 
+	if (clone_flags & CLONE_PARENT_SETTID) {
+		retval = put_user(pid_vnr(pid), parent_tidptr);
+		if (retval)
+			goto bad_fork_free_pid;
+	}
+
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
 	 * Clear TID on mm_release()?
@@ -1617,7 +1624,7 @@ static inline void init_idle_pids(struct pid_link *links)
 struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
-	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0);
+	task = copy_process(CLONE_VM, 0, 0, NULL, NULL, &init_struct_pid, 0);
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1661,7 +1668,7 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace);
+			 parent_tidptr, child_tidptr, NULL, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1675,9 +1682,6 @@ long do_fork(unsigned long clone_flags,
 		pid = get_task_pid(p, PIDTYPE_PID);
 		nr = pid_vnr(pid);
 
-		if (clone_flags & CLONE_PARENT_SETTID)
-			put_user(nr, parent_tidptr);
-
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
