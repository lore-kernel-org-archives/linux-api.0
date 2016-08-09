From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v14 13/14] task_isolation: add user-settable notification signal
Date: Tue,  9 Aug 2016 16:29:55 -0400
Message-ID: <1470774596-17341-14-git-send-email-cmetcalf@mellanox.com>
References: <1470774596-17341-1-git-send-email-cmetcalf@mellanox.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470774596-17341-1-git-send-email-cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

By default, if a task in task isolation mode re-enters the kernel,
it is terminated with SIGKILL.  With this commit, the application
can choose what signal to receive on a task isolation violation
by invoking prctl() with PR_TASK_ISOLATION_ENABLE, or'ing in the
PR_TASK_ISOLATION_USERSIG bit, and setting the specific requested
signal by or'ing in PR_TASK_ISOLATION_SET_SIG(sig).

This mode allows for catching the notification signal; for example,
in a production environment, it might be helpful to log information
to the application logging mechanism before exiting.  Or, the
application might choose to re-enable task isolation and return to
continue execution.

As a special case, the user may set the signal to 0, which means
that no signal will be delivered.  In this mode, the application
may freely enter the kernel for syscalls and synchronous exceptions
such as page faults, but each time it will be held in the kernel
before returning to userspace until the kernel has quiesced timer
ticks or other potential future interruptions, just like it does
on return from the initial prctl() call.  Note that in this mode,
the task can be migrated away from its initial task_isolation core,
and if it is migrated to a non-isolated core it will lose task
isolation until it is migrated back to an isolated core.
In addition, in this mode we no longer require the affinity to
be set correctly on entry (though we warn on the console if it's
not right), and we don't bother to notify the user that the kernel
isn't ready to quiesce either (since we'll presumably be in and
out of the kernel multiple times with task isolation enabled anyway).
The PR_TASK_ISOLATION_NOSIG define is provided as a convenience
wrapper to express this semantic.

Signed-off-by: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/uapi/linux/prctl.h |  5 ++++
 kernel/isolation.c         | 62 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 2a49d0d2940a..7af6eb51c1dc 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -201,5 +201,10 @@ struct prctl_mm_map {
 #define PR_SET_TASK_ISOLATION		48
 #define PR_GET_TASK_ISOLATION		49
 # define PR_TASK_ISOLATION_ENABLE	(1 << 0)
+# define PR_TASK_ISOLATION_USERSIG	(1 << 1)
+# define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
+# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
+# define PR_TASK_ISOLATION_NOSIG \
+	(PR_TASK_ISOLATION_USERSIG | PR_TASK_ISOLATION_SET_SIG(0))
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/isolation.c b/kernel/isolation.c
index f8ccf5e67e38..d36cb3943c80 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -85,6 +85,15 @@ static bool can_stop_my_full_tick_now(void)
 	return ret;
 }
 
+/* Get the signal number that will be sent for a particular set of flag bits. */
+static int task_isolation_sig(int flags)
+{
+	if (flags & PR_TASK_ISOLATION_USERSIG)
+		return PR_TASK_ISOLATION_GET_SIG(flags);
+	else
+		return SIGKILL;
+}
+
 /*
  * This routine controls whether we can enable task-isolation mode.
  * The task must be affinitized to a single task_isolation core, or
@@ -92,16 +101,30 @@ static bool can_stop_my_full_tick_now(void)
  * stop the nohz_full tick (e.g., no other schedulable tasks currently
  * running, no POSIX cpu timers currently set up, etc.); if not, we
  * return EAGAIN.
+ *
+ * If we will not be strictly enforcing kernel re-entry with a signal,
+ * we just generate a warning printk if there is a bad affinity set
+ * on entry (since after all you can always change it again after you
+ * call prctl) and we don't bother failing the prctl with -EAGAIN
+ * since we assume you will go in and out of kernel mode anyway.
  */
 int task_isolation_set(unsigned int flags)
 {
 	if (flags != 0) {
+		int sig = task_isolation_sig(flags);
+
 		if (cpumask_weight(tsk_cpus_allowed(current)) != 1 ||
 		    !task_isolation_possible(raw_smp_processor_id())) {
 			/* Invalid task affinity setting. */
-			return -EINVAL;
+			if (sig)
+				return -EINVAL;
+			else
+				pr_warn("%s/%d: enabling non-signalling task isolation\n"
+					"and not bound to a single task isolation core\n",
+					current->comm, current->pid);
 		}
-		if (!can_stop_my_full_tick_now()) {
+
+		if (sig && !can_stop_my_full_tick_now()) {
 			/* System not yet ready for task isolation. */
 			return -EAGAIN;
 		}
@@ -160,11 +183,11 @@ void task_isolation_enter(void)
 }
 
 static void task_isolation_deliver_signal(struct task_struct *task,
-					  const char *buf)
+					  const char *buf, int sig)
 {
 	siginfo_t info = {};
 
-	info.si_signo = SIGKILL;
+	info.si_signo = sig;
 
 	/*
 	 * Report on the fact that isolation was violated for the task.
@@ -175,7 +198,10 @@ static void task_isolation_deliver_signal(struct task_struct *task,
 	pr_warn("%s/%d: task_isolation mode lost due to %s\n",
 		task->comm, task->pid, buf);
 
-	/* Turn off task isolation mode to avoid further isolation callbacks. */
+	/*
+	 * Turn off task isolation mode to avoid further isolation callbacks.
+	 * It can choose to re-enable task isolation mode in the signal handler.
+	 */
 	task_isolation_set_flags(task, 0);
 
 	send_sig_info(info.si_signo, &info, task);
@@ -190,15 +216,20 @@ void _task_isolation_quiet_exception(const char *fmt, ...)
 	struct task_struct *task = current;
 	va_list args;
 	char buf[100];
+	int sig;
 
 	/* RCU should have been enabled prior to this point. */
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
 
+	sig = task_isolation_sig(task->task_isolation_flags);
+	if (sig == 0)
+		return;
+
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	task_isolation_deliver_signal(task, buf);
+	task_isolation_deliver_signal(task, buf, sig);
 }
 
 /*
@@ -209,14 +240,19 @@ void _task_isolation_quiet_exception(const char *fmt, ...)
 int task_isolation_syscall(int syscall)
 {
 	char buf[20];
+	int sig;
 
 	if (syscall == __NR_prctl ||
 	    syscall == __NR_exit ||
 	    syscall == __NR_exit_group)
 		return 0;
 
+	sig = task_isolation_sig(current->task_isolation_flags);
+	if (sig == 0)
+		return 0;
+
 	snprintf(buf, sizeof(buf), "syscall %d", syscall);
-	task_isolation_deliver_signal(current, buf);
+	task_isolation_deliver_signal(current, buf, sig);
 
 	syscall_set_return_value(current, current_pt_regs(),
 					 -ERESTARTNOINTR, -1);
@@ -236,6 +272,7 @@ void task_isolation_debug_task(int cpu, struct task_struct *p, const char *type)
 {
 	static DEFINE_RATELIMIT_STATE(console_output, HZ, 1);
 	bool force_debug = false;
+	int sig;
 
 	/*
 	 * Our caller made sure the task was running on a task isolation
@@ -266,10 +303,13 @@ void task_isolation_debug_task(int cpu, struct task_struct *p, const char *type)
 	 * and instead just treat it as if "debug" mode was enabled,
 	 * since that's pretty much all we can do.
 	 */
-	if (in_nmi())
-		force_debug = true;
-	else
-		task_isolation_deliver_signal(p, type);
+	sig = task_isolation_sig(p->task_isolation_flags);
+	if (sig != 0) {
+		if (in_nmi())
+			force_debug = true;
+		else
+			task_isolation_deliver_signal(p, type, sig);
+	}
 
 	/*
 	 * If (for example) the timer interrupt starts ticking
-- 
2.7.2
