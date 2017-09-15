From: tip-bot for John Ogness <tipbot-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: [tip:core/urgent] fs/proc: Report eip/esp in /prod/PID/stat for
 coredumping
Date: Fri, 15 Sep 2017 14:36:47 -0700
Message-ID: <tip-fd7d56270b526ca3ed0c224362e3c64a0f86687a@git.kernel.org>
References: <87poatfwg6.fsf@linutronix.de>
Reply-To: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org,
          penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
          akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, marco.felsch-4vaI68m59Pc@public.gmane.org,
          john.ogness-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
          tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
          torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
          keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87poatfwg6.fsf-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-tip-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.ogness-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, marco.felsch-4vaI68m59Pc@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  fd7d56270b526ca3ed0c224362e3c64a0f86687a
Gitweb:     http://git.kernel.org/tip/fd7d56270b526ca3ed0c224362e3c64a0f86687a
Author:     John Ogness <john.ogness-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
AuthorDate: Thu, 14 Sep 2017 11:42:17 +0200
Committer:  Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CommitDate: Fri, 15 Sep 2017 23:31:16 +0200

fs/proc: Report eip/esp in /prod/PID/stat for coredumping

Commit 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in
/proc/PID/stat") stopped reporting eip/esp because it is
racy and dangerous for executing tasks. The comment adds:

    As far as I know, there are no use programs that make any
    material use of these fields, so just get rid of them.

However, existing userspace core-dump-handler applications (for
example, minicoredumper) are using these fields since they
provide an excellent cross-platform interface to these valuable
pointers. So that commit introduced a user space visible
regression.

Partially revert the change and make the readout possible for
tasks with the proper permissions and only if the target task
has the PF_DUMPCORE flag set.

Fixes: 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in> /proc/PID/stat")
Reported-by: Marco Felsch <marco.felsch-4vaI68m59Pc@public.gmane.org>
Signed-off-by: John Ogness <john.ogness-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Reviewed-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Link: http://lkml.kernel.org/r/87poatfwg6.fsf-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Signed-off-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

---
 fs/proc/array.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 88c3555..525157c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -62,6 +62,7 @@
 #include <linux/mman.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/numa_balancing.h>
+#include <linux/sched/task_stack.h>
 #include <linux/sched/task.h>
 #include <linux/sched/cputime.h>
 #include <linux/proc_fs.h>
@@ -421,7 +422,15 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		 * esp and eip are intentionally zeroed out.  There is no
 		 * non-racy way to read them without freezing the task.
 		 * Programs that need reliable values can use ptrace(2).
+		 *
+		 * The only exception is if the task is core dumping because
+		 * a program is not able to use ptrace(2) in that case. It is
+		 * safe because the task has stopped executing permanently.
 		 */
+		if (permitted && (task->flags & PF_DUMPCORE)) {
+			eip = KSTK_EIP(task);
+			esp = KSTK_ESP(task);
+		}
 	}
 
 	get_task_comm(tcomm, task);
