From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v7 04/11] task_isolation: provide strict mode configurable signal
Date: Mon, 28 Sep 2015 11:17:19 -0400
Message-ID: <1443453446-7827-5-git-send-email-cmetcalf@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

Allow userspace to override the default SIGKILL delivered
when a task_isolation process in STRICT mode does a syscall
or otherwise synchronously enters the kernel.

In addition to being able to set the signal, we now also
pass whether or not the interruption was from a syscall in
the si_code field of the siginfo.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/uapi/linux/prctl.h |  2 ++
 kernel/isolation.c         | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

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
index 3779ba670472..44bafcd08bca 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -77,14 +77,23 @@ void task_isolation_enter(void)
 	}
 }
 
-static void kill_task_isolation_strict_task(void)
+static void kill_task_isolation_strict_task(int is_syscall)
 {
+	siginfo_t info = {};
+	int sig;
+
 	/* RCU should have been enabled prior to this point. */
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "kernel entry without RCU");
 
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
@@ -103,7 +112,7 @@ void task_isolation_syscall(int syscall)
 
 	pr_warn("%s/%d: task_isolation strict mode violated by syscall %d\n",
 		current->comm, current->pid, syscall);
-	kill_task_isolation_strict_task();
+	kill_task_isolation_strict_task(1);
 }
 
 /*
@@ -114,5 +123,5 @@ void task_isolation_exception(void)
 {
 	pr_warn("%s/%d: task_isolation strict mode violated by exception\n",
 		current->comm, current->pid);
-	kill_task_isolation_strict_task();
+	kill_task_isolation_strict_task(0);
 }
-- 
2.1.2

