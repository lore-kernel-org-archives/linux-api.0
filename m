From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/5] nohz: cpu_isolated strict mode configurable signal
Date: Fri, 15 May 2015 17:27:29 -0400
Message-ID: <1431725251-20943-3-git-send-email-cmetcalf@ezchip.com>
References: <1431725178-20876-1-git-send-email-cmetcalf@ezchip.com>
 <1431725251-20943-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431725251-20943-1-git-send-email-cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Allow userspace to override the default SIGKILL delivered
when a cpu_isolated process in STRICT mode does a syscall
or otherwise synchronously enters the kernel.

In addition to being able to set the signal, we now also
pass whether or not the interruption was from a syscall in
the si_code field of the siginfo.

Signed-off-by: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/prctl.h |  2 ++
 kernel/time/tick-sched.c   | 15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 0c11238a84fb..ab45bd3d5799 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -195,5 +195,7 @@ struct prctl_mm_map {
 #define PR_GET_CPU_ISOLATED	48
 # define PR_CPU_ISOLATED_ENABLE	(1 << 0)
 # define PR_CPU_ISOLATED_STRICT	(1 << 1)
+# define PR_CPU_ISOLATED_SET_SIG(sig)  (((sig) & 0x7f) << 8)
+# define PR_CPU_ISOLATED_GET_SIG(bits) (((bits) >> 8) & 0x7f)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 273820cd484a..772be78f926c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -441,11 +441,18 @@ void tick_nohz_cpu_isolated_enter(void)
 	}
 }
 
-static void kill_cpu_isolated_strict_task(void)
+static void kill_cpu_isolated_strict_task(int is_syscall)
 {
+	siginfo_t info = {};
+	int sig;
+
 	dump_stack();
 	current->cpu_isolated_flags &= ~PR_CPU_ISOLATED_ENABLE;
-	send_sig(SIGKILL, current, 1);
+
+	sig = PR_CPU_ISOLATED_GET_SIG(current->cpu_isolated_flags) ?: SIGKILL;
+	info.si_signo = sig;
+	info.si_code = is_syscall;
+	send_sig_info(sig, &info, current);
 }
 
 /*
@@ -464,7 +471,7 @@ void tick_nohz_cpu_isolated_syscall(int syscall)
 
 	pr_warn("%s/%d: cpu_isolated strict mode violated by syscall %d\n",
 		current->comm, current->pid, syscall);
-	kill_cpu_isolated_strict_task();
+	kill_cpu_isolated_strict_task(1);
 }
 
 /*
@@ -475,7 +482,7 @@ void tick_nohz_cpu_isolated_exception(void)
 {
 	pr_warn("%s/%d: cpu_isolated strict mode violated by exception\n",
 		current->comm, current->pid);
-	kill_cpu_isolated_strict_task();
+	kill_cpu_isolated_strict_task(0);
 }
 
 #endif
-- 
2.1.2
