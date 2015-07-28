From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v5 4/6] cpu_isolated: provide strict mode configurable signal
Date: Tue, 28 Jul 2015 15:49:38 -0400
Message-ID: <1438112980-9981-5-git-send-email-cmetcalf@ezchip.com>
References: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

Allow userspace to override the default SIGKILL delivered
when a cpu_isolated process in STRICT mode does a syscall
or otherwise synchronously enters the kernel.

In addition to being able to set the signal, we now also
pass whether or not the interruption was from a syscall in
the si_code field of the siginfo.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/uapi/linux/prctl.h |  2 ++
 kernel/time/cpu_isolated.c | 17 ++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

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
diff --git a/kernel/time/cpu_isolated.c b/kernel/time/cpu_isolated.c
index d30bf3852897..9f8fcbd97770 100644
--- a/kernel/time/cpu_isolated.c
+++ b/kernel/time/cpu_isolated.c
@@ -71,11 +71,18 @@ void cpu_isolated_enter(void)
 	}
 }
 
-static void kill_cpu_isolated_strict_task(void)
-{
+static void kill_cpu_isolated_strict_task(int is_syscall)
+ {
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
@@ -94,7 +101,7 @@ void cpu_isolated_syscall(int syscall)
 
 	pr_warn("%s/%d: cpu_isolated strict mode violated by syscall %d\n",
 		current->comm, current->pid, syscall);
-	kill_cpu_isolated_strict_task();
+	kill_cpu_isolated_strict_task(1);
 }
 
 /*
@@ -105,5 +112,5 @@ void cpu_isolated_exception(void)
 {
 	pr_warn("%s/%d: cpu_isolated strict mode violated by exception\n",
 		current->comm, current->pid);
-	kill_cpu_isolated_strict_task();
+	kill_cpu_isolated_strict_task(0);
 }
-- 
2.1.2
