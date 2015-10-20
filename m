From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v8 06/14] task_isolation: provide strict mode configurable signal
Date: Tue, 20 Oct 2015 16:36:04 -0400
Message-ID: <1445373372-6567-7-git-send-email-cmetcalf@ezchip.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

Allow userspace to override the default SIGKILL delivered
when a task_isolation process in STRICT mode does a syscall
or otherwise synchronously enters the kernel.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/uapi/linux/prctl.h | 2 ++
 kernel/isolation.c         | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 2b8038b0d1e1..a5582ace987f 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -202,5 +202,7 @@ struct prctl_mm_map {
 #define PR_GET_TASK_ISOLATION		49
 # define PR_TASK_ISOLATION_ENABLE	(1 << 0)
 # define PR_TASK_ISOLATION_STRICT	(1 << 1)
+# define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
+# define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/isolation.c b/kernel/isolation.c
index 30db40098a35..0fa13b081bb4 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -84,8 +84,10 @@ void _task_isolation_enter(void)
  */
 bool task_isolation_exception(const char *fmt, ...)
 {
+	siginfo_t info = {};
 	va_list args;
 	char buf[100];
+	int sig;
 
 	/* RCU should have been enabled prior to this point. */
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
@@ -97,7 +99,12 @@ bool task_isolation_exception(const char *fmt, ...)
 	pr_warn("%s/%d: task_isolation strict mode violated by %s\n",
 		current->comm, current->pid, buf);
 	current->task_isolation_flags &= ~PR_TASK_ISOLATION_ENABLE;
-	send_sig(SIGKILL, current, 1);
+
+	sig = PR_TASK_ISOLATION_GET_SIG(current->task_isolation_flags);
+	if (sig == 0)
+		sig = SIGKILL;
+	info.si_signo = sig;
+	send_sig_info(sig, &info, current);
 
 	return true;
 }
-- 
2.1.2
