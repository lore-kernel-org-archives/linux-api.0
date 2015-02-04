From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH] fork: report pid reservation failure properly
Date: Wed,  4 Feb 2015 11:43:48 +0100
Message-ID: <1423046628-23638-1-git-send-email-mhocko@suse.cz>
References: <20150204102719.GB29434@dhcp22.suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150204102719.GB29434-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

copy_process will report any failure in alloc_pid as ENOMEM currently
which is misleading because the pid allocation might fail not only when
the memory is short but also when the pid space is consumed already.

The current man page even mentions this case:
"
EAGAIN

      A system-imposed limit on the number of threads was encountered.
      There are a number of limits that may trigger this error: the
      RLIMIT_NPROC soft resource limit (set via setrlimit(2)), which
      limits the number of processes and threads for a real user ID, was
      reached; the kernel's system-wide limit on the number of processes
      and threads, /proc/sys/kernel/threads-max, was reached (see
      proc(5)); or the maximum number of PIDs, /proc/sys/kernel/pid_max,
      was reached (see proc(5)).
"

so the current behavior is also incorrect wrt. documentation. POSIX man
page also suggest returing EAGAIN when the process count limit is
reached.

This patch simply propagates error code from alloc_pid and makes sure we
return -EAGAIN due to reservation failure. This will make behavior of
fork closer to both our documentation and POSIX.

alloc_pid might alsoo fail when the reaper in the pid namespace is dead
(the namespace basically disallows all new processes) and there is no
good error code which would match documented ones. We have traditionally
returned ENOMEM for this case which is misleading as well but as per
Eric W. Biederman this behavior is documented in man pid_namespaces(7)
"
If the "init" process of a PID namespace terminates, the kernel
terminates all of the processes in the namespace via a SIGKILL signal.
This behavior reflects the fact that the "init" process is essential for
the correct operation of a PID namespace.  In this case, a subsequent
fork(2) into this PID namespace will fail with the error ENOMEM; it is
not possible to create a new processes in a PID namespace whose "init"
process has terminated.
"
and introducing a new error code would be too risky so let's stick to
ENOMEM for this case.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 kernel/fork.c |  5 +++--
 kernel/pid.c  | 15 ++++++++-------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3ce8d57cff09..c37b88a162c5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1405,10 +1405,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		retval = -ENOMEM;
 		pid = alloc_pid(p->nsproxy->pid_ns_for_children);
-		if (!pid)
+		if (IS_ERR(pid)) {
+			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
+		}
 	}
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
diff --git a/kernel/pid.c b/kernel/pid.c
index 82430c858d69..bbb805ccd893 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -179,7 +179,7 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			spin_unlock_irq(&pidmap_lock);
 			kfree(page);
 			if (unlikely(!map->page))
-				break;
+				return -ENOMEM;
 		}
 		if (likely(atomic_read(&map->nr_free))) {
 			for ( ; ; ) {
@@ -207,7 +207,7 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
-	return -1;
+	return -EAGAIN;
 }
 
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last)
@@ -298,17 +298,20 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	int i, nr;
 	struct pid_namespace *tmp;
 	struct upid *upid;
+	int retval = -ENOMEM;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
-		goto out;
+		return ERR_PTR(retval);
 
 	tmp = ns;
 	pid->level = ns->level;
 	for (i = ns->level; i >= 0; i--) {
 		nr = alloc_pidmap(tmp);
-		if (nr < 0)
+		if (IS_ERR_VALUE(nr)) {
+			retval = nr;
 			goto out_free;
+		}
 
 		pid->numbers[i].nr = nr;
 		pid->numbers[i].ns = tmp;
@@ -336,7 +339,6 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	}
 	spin_unlock_irq(&pidmap_lock);
 
-out:
 	return pid;
 
 out_unlock:
@@ -348,8 +350,7 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
-	goto out;
+	return ERR_PTR(retval);
 }
 
 void disable_pid_allocation(struct pid_namespace *ns)
-- 
2.1.4
