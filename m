From: Daniel Colascione <dancol@google.com>
Subject: [RFC] Add critical process prctl
Date: Wed,  4 Sep 2019 17:53:13 -0700
Message-ID: <20190905005313.126823-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dancol@google.com, timmurray@google.com, surenb@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

A task with CAP_SYS_ADMIN can mark itself PR_SET_TASK_CRITICAL,
meaning that if the task ever exits, the kernel panics. This facility
is intended for use by low-level core system processes that cannot
gracefully restart without a reboot. This prctl allows these processes
to ensure that the system restarts when they die regardless of whether
the rest of userspace is operational.

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 include/linux/sched.h      |  5 +++++
 include/uapi/linux/prctl.h |  5 +++++
 kernel/exit.c              |  2 ++
 kernel/sys.c               | 19 +++++++++++++++++++
 4 files changed, 31 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9f51932bd543..29420b9ebb63 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1526,6 +1526,7 @@ static inline bool is_percpu_thread(void)
 #define PFA_SPEC_IB_DISABLE		5	/* Indirect branch speculation restricted */
 #define PFA_SPEC_IB_FORCE_DISABLE	6	/* Indirect branch speculation permanently restricted */
 #define PFA_SPEC_SSB_NOEXEC		7	/* Speculative Store Bypass clear on execve() */
+#define PFA_CRITICAL                    8       /* Panic system if process exits */
 
 #define TASK_PFA_TEST(name, func)					\
 	static inline bool task_##func(struct task_struct *p)		\
@@ -1568,6 +1569,10 @@ TASK_PFA_CLEAR(SPEC_IB_DISABLE, spec_ib_disable)
 TASK_PFA_TEST(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
 TASK_PFA_SET(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
 
+TASK_PFA_TEST(CRITICAL, critical)
+TASK_PFA_SET(CRITICAL, critical)
+TASK_PFA_CLEAR(CRITICAL, critical)
+
 static inline void
 current_restore_flags(unsigned long orig_flags, unsigned long flags)
 {
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 094bb03b9cc2..4964723bbd47 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -229,4 +229,9 @@ struct prctl_mm_map {
 # define PR_PAC_APDBKEY			(1UL << 3)
 # define PR_PAC_APGAKEY			(1UL << 4)
 
+/* Per-task criticality control */
+#define PR_SET_TASK_CRITICAL 55
+#define PR_CRITICAL_NOT_CRITICAL 0
+#define PR_CRITICAL_CRITICAL 1
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index 5b4a5dcce8f8..9b3d3411d935 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -788,6 +788,8 @@ void __noreturn do_exit(long code)
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
+	if (unlikely(task_critical(tsk)))
+		panic("Critical task died!");
 
 	/*
 	 * If do_exit is called because this processes oopsed, it's possible
diff --git a/kernel/sys.c b/kernel/sys.c
index 2969304c29fe..097e05ebaf94 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2269,6 +2269,20 @@ int __weak arch_prctl_spec_ctrl_set(struct task_struct *t, unsigned long which,
 	return -EINVAL;
 }
 
+int task_do_set_critical(struct task_struct *t, unsigned long opt)
+{
+	if (opt != PR_CRITICAL_NOT_CRITICAL &&
+	    opt != PR_CRITICAL_CRITICAL)
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (opt == PR_CRITICAL_NOT_CRITICAL)
+		task_clear_critical(t);
+	else
+		task_set_critical(t);
+	return 0;
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -2492,6 +2506,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			return -EINVAL;
 		error = PAC_RESET_KEYS(me, arg2);
 		break;
+	case PR_SET_TASK_CRITICAL:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = task_do_set_critical(me, arg2);
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
2.23.0.187.g17f5b7556c-goog
