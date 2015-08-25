From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 4/6] task_isolation: provide strict mode configurable signal
Date: Tue, 25 Aug 2015 15:55:53 -0400
Message-ID: <1440532555-15492-5-git-send-email-cmetcalf@ezchip.com>
References: <1440532555-15492-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440532555-15492-1-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Allow userspace to override the default SIGKILL delivered
when a task_isolation process in STRICT mode does a syscall
or otherwise synchronously enters the kernel.

In addition to being able to set the signal, we now also
pass whether or not the interruption was from a syscall in
the si_code field of the siginfo.

Signed-off-by: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/prctl.h |  2 ++
 kernel/isolation.c         | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index e16e13911e8a..2a4ddc890e22 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -195,5 +195,7 @@ struct prctl_mm_map {
 #define PR_GET_TASK_ISOLATION		48
 # define PR_TASK_ISOLATION_ENABLE	(1 << 0)
 # define PR_TASK_ISOLATION_STRICT	(1 << 1)
+# define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
+# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/isolation.c b/kernel/isolation.c
index a89a6e9adfb4..b776aa632c8f 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -75,11 +75,20 @@ void task_isolation_enter(void)
 	}
 }
 
-static void kill_task_isolation_strict_task(void)
+static void kill_task_isolation_strict_task(int is_syscall)
 {
+	siginfo_t info = {};
+	int sig;
+
 	dump_stack();
 	current->task_isolation_flags &= ~PR_TASK_ISOLATION_ENABLE;
-	send_sig(SIGKILL, current, 1);
+
+	sig = PR_TASK_ISOLATION_GET_SIG(current->task_isolation_flags);
+	if (sig == 0)
+		sig = SIGKILL;
+	info.si_signo = sig;
+	info.si_code = is_syscall;
+	send_sig_info(sig, &info, current);
 }
 
 /*
@@ -98,7 +107,7 @@ void task_isolation_syscall(int syscall)
 
 	pr_warn("%s/%d: task_isolation strict mode violated by syscall %d\n",
 		current->comm, current->pid, syscall);
-	kill_task_isolation_strict_task();
+	kill_task_isolation_strict_task(1);
 }
 
 /*
@@ -109,5 +118,5 @@ void task_isolation_exception(void)
 {
 	pr_warn("%s/%d: task_isolation strict mode violated by exception\n",
 		current->comm, current->pid);
-	kill_task_isolation_strict_task();
+	kill_task_isolation_strict_task(0);
 }
-- 
2.1.2
