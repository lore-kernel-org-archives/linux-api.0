From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v9 05/13] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Mon, 4 Jan 2016 14:34:43 -0500
Message-ID: <1451936091-29247-6-git-send-email-cmetcalf@ezchip.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

With task_isolation mode, the task is in principle guaranteed not to
be interrupted by the kernel, but only if it behaves.  In particular,
if it enters the kernel via system call, page fault, or any of a
number of other synchronous traps, it may be unexpectedly exposed
to long latencies.  Add a simple flag that puts the process into
a state where any such kernel entry is fatal; this is defined as
happening immediately before the SECCOMP test.

By default, the task is signalled with SIGKILL, but we add prctl()
bits to support requesting a specific signal instead.

To allow the state to be entered and exited, we ignore the prctl()
syscall so that we can clear the bit again later, and we ignore
exit/exit_group to allow exiting the task without a pointless signal
killing you as you try to do so.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/linux/isolation.h  | 25 +++++++++++++++++++
 include/uapi/linux/prctl.h |  3 +++
 kernel/isolation.c         | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/include/linux/isolation.h b/include/linux/isolation.h
index ed1bfc793c5a..69a3e4c59ab3 100644
--- a/include/linux/isolation.h
+++ b/include/linux/isolation.h
@@ -40,11 +40,36 @@ static inline void task_isolation_enter(void)
 		_task_isolation_enter();
 }
 
+extern bool task_isolation_syscall(int nr);
+extern void task_isolation_exception(const char *fmt, ...);
+extern void task_isolation_interrupt(struct task_struct *, const char *buf);
+
+static inline bool task_isolation_strict(void)
+{
+	return (task_isolation_possible(smp_processor_id()) &&
+		(current->task_isolation_flags &
+		 (PR_TASK_ISOLATION_ENABLE | PR_TASK_ISOLATION_STRICT)) ==
+		(PR_TASK_ISOLATION_ENABLE | PR_TASK_ISOLATION_STRICT));
+}
+
+static inline bool task_isolation_check_syscall(int nr)
+{
+	return task_isolation_strict() && task_isolation_syscall(nr);
+}
+
+#define task_isolation_check_exception(fmt, ...)			\
+	do {								\
+		if (task_isolation_strict())				\
+			task_isolation_exception(fmt, ## __VA_ARGS__);	\
+	} while (0)
+
 #else
 static inline bool task_isolation_possible(int cpu) { return false; }
 static inline bool task_isolation_enabled(void) { return false; }
 static inline bool task_isolation_ready(void) { return true; }
 static inline void task_isolation_enter(void) { }
+static inline bool task_isolation_check_syscall(int nr) { return false; }
+static inline void task_isolation_check_exception(const char *fmt, ...) { }
 #endif
 
 #endif
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 67224df4b559..a5582ace987f 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -201,5 +201,8 @@ struct prctl_mm_map {
 #define PR_SET_TASK_ISOLATION		48
 #define PR_GET_TASK_ISOLATION		49
 # define PR_TASK_ISOLATION_ENABLE	(1 << 0)
+# define PR_TASK_ISOLATION_STRICT	(1 << 1)
+# define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
+# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/isolation.c b/kernel/isolation.c
index 68a9f7457bc0..29ffb21ada0b 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -11,6 +11,7 @@
 #include <linux/vmstat.h>
 #include <linux/isolation.h>
 #include <linux/syscalls.h>
+#include <asm/unistd.h>
 #include "time/tick-sched.h"
 
 cpumask_var_t task_isolation_map;
@@ -103,3 +104,62 @@ void _task_isolation_enter(void)
 	/* Quieten the vmstat worker so it won't interrupt us. */
 	quiet_vmstat();
 }
+
+void task_isolation_interrupt(struct task_struct *task, const char *buf)
+{
+	siginfo_t info = {};
+	int sig;
+
+	pr_warn("%s/%d: task_isolation strict mode violated by %s\n",
+		task->comm, task->pid, buf);
+
+	/*
+	 * Turn off task isolation mode entirely to avoid spamming
+	 * the process with signals.  It can re-enable task isolation
+	 * mode in the signal handler if it wants to.
+	 */
+	task->task_isolation_flags = 0;
+
+	sig = PR_TASK_ISOLATION_GET_SIG(task->task_isolation_flags);
+	if (sig == 0)
+		sig = SIGKILL;
+	info.si_signo = sig;
+	send_sig_info(sig, &info, task);
+}
+
+/*
+ * This routine is called from any userspace exception if the _STRICT
+ * flag is set.
+ */
+void task_isolation_exception(const char *fmt, ...)
+{
+	va_list args;
+	char buf[100];
+
+	/* RCU should have been enabled prior to this point. */
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
+
+	va_start(args, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	task_isolation_interrupt(current, buf);
+}
+
+/*
+ * This routine is called from syscall entry (with the syscall number
+ * passed in) if the _STRICT flag is set.
+ */
+bool task_isolation_syscall(int syscall)
+{
+	/* Ignore prctl() syscalls or any task exit. */
+	switch (syscall) {
+	case __NR_prctl:
+	case __NR_exit:
+	case __NR_exit_group:
+		return false;
+	}
+
+	task_isolation_exception("syscall %d", syscall);
+	return true;
+}
-- 
2.1.2
