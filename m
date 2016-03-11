From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: [PATCH v11 06/13] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Fri, 11 Mar 2016 17:10:16 -0500
Message-ID: <1457734223-26209-7-git-send-email-cmetcalf@mellanox.com>
References: <1457734223-26209-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457734223-26209-1-git-send-email-cmetcalf@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-api@vger.kernel.org

With task_isolation mode, the task is in principle guaranteed not to
be interrupted by the kernel, but only if it behaves.  In particular,
if it enters the kernel via system call, page fault, or any of a
number of other synchronous traps, it may be unexpectedly exposed
to long latencies.  Add a simple flag that puts the process into
a state where any such kernel entry generates a signal.  For system
calls, this test is performed immediately before the SECCOMP test
and causes the syscall to return immediately with ENOSYS.

By default, the task is signalled with SIGKILL, but we add prctl()
bits to support requesting a specific signal instead.

To allow the state to be entered and exited, the syscall checking
test ignores the prctl() syscall so that we can clear the bit again
later, and ignores exit/exit_group to allow exiting the task without
a pointless signal killing you as you try to do so.

Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
---
 include/linux/isolation.h  | 10 +++++++
 include/uapi/linux/prctl.h |  3 ++
 kernel/isolation.c         | 73 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/include/linux/isolation.h b/include/linux/isolation.h
index 99b909462e64..9202ced4511c 100644
--- a/include/linux/isolation.h
+++ b/include/linux/isolation.h
@@ -36,6 +36,14 @@ static inline void task_isolation_set_flags(struct task_struct *p,
 		clear_tsk_thread_flag(p, TIF_TASK_ISOLATION);
 }
 
+extern int task_isolation_syscall(int nr);
+extern void _task_isolation_exception(const char *fmt, ...);
+#define task_isolation_exception(fmt, ...)				\
+	do {								\
+		if (current_thread_info()->flags & _TIF_TASK_ISOLATION) \
+			_task_isolation_exception(fmt, ## __VA_ARGS__); \
+	} while (0)
+
 #else
 static inline void task_isolation_init(void) { }
 static inline bool task_isolation_possible(int cpu) { return false; }
@@ -43,6 +51,8 @@ static inline bool task_isolation_ready(void) { return true; }
 static inline void task_isolation_enter(void) { }
 extern inline void task_isolation_set_flags(struct task_struct *p,
 					    unsigned int flags) { }
+static inline int task_isolation_syscall(int nr) { return 0; }
+static inline void task_isolation_exception(const char *fmt, ...) { }
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
index f59dcf06ba56..e1d844b5c567 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -11,6 +11,8 @@
 #include <linux/vmstat.h>
 #include <linux/isolation.h>
 #include <linux/syscalls.h>
+#include <asm/unistd.h>
+#include <asm/syscall.h>
 #include "time/tick-sched.h"
 
 cpumask_var_t task_isolation_map;
@@ -154,3 +156,74 @@ void task_isolation_enter(void)
 	if (!tick_nohz_tick_stopped())
 		set_tsk_need_resched(current);
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
+	/* Get the signal number to use. */
+	sig = PR_TASK_ISOLATION_GET_SIG(task->task_isolation_flags);
+	if (sig == 0)
+		sig = SIGKILL;
+	info.si_signo = sig;
+
+	/*
+	 * Turn off task isolation mode entirely to avoid spamming
+	 * the process with signals.  It can re-enable task isolation
+	 * mode in the signal handler if it wants to.
+	 */
+	task_isolation_set_flags(task, 0);
+
+	send_sig_info(sig, &info, task);
+}
+
+/*
+ * This routine is called from any userspace exception that doesn't
+ * otherwise trigger a signal to the user process (e.g. simple page fault).
+ */
+void _task_isolation_exception(const char *fmt, ...)
+{
+	struct task_struct *task = current;
+
+	/* RCU should have been enabled prior to this point. */
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
+
+	if (task->task_isolation_flags & PR_TASK_ISOLATION_STRICT) {
+		va_list args;
+		char buf[100];
+
+		va_start(args, fmt);
+		vsnprintf(buf, sizeof(buf), fmt, args);
+		va_end(args);
+
+		task_isolation_interrupt(task, buf);
+	}
+}
+
+/*
+ * This routine is called from syscall entry (with the syscall number
+ * passed in), and in STRICT mode prevents most syscalls from executing
+ * and raises a signal to notify the process.
+ */
+int task_isolation_syscall(int syscall)
+{
+	struct task_struct *task = current;
+
+	if ((task->task_isolation_flags & PR_TASK_ISOLATION_STRICT) &&
+	    syscall != __NR_prctl &&
+	    syscall != __NR_exit && syscall != __NR_exit_group) {
+		char buf[20];
+
+		snprintf(buf, sizeof(buf), "syscall %d", syscall);
+		task_isolation_interrupt(task, buf);
+
+		syscall_set_return_value(task, current_pt_regs(), ENOSYS, -1);
+		return -1;
+	}
+
+	return 0;
+}
-- 
2.7.2
