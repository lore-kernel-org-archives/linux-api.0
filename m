From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: [PATCH v12 08/13] task_isolation: add PR_TASK_ISOLATION_ONE_SHOT flag
Date: Tue, 5 Apr 2016 13:38:37 -0400
Message-ID: <1459877922-15512-9-git-send-email-cmetcalf@mellanox.com>
References: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@mellanox.com>
List-Id: linux-api@vger.kernel.org

When this flag is set by the initial prctl(), the semantics of task
isolation change to be "one-shot", i.e. as soon as the kernel is
re-entered for any reason, task isolation is turned off.

During application development, use of this flag is best coupled with
STRICT mode, since otherwise any bug (e.g. an munmap from another
thread in the same task causing an IPI TLB flush) could cause the
task to fall out of task isolation mode without being aware of it.

In production it is typically still best to use STRICT mode, with
a signal handler that will report violations of task isolation
up to the application layer.  However, if you are confident the
application will never fall out of task isolation mode, you may
wish to use ONE_SHOT mode to allow switching from userspace task
isolation mode, to using the kernel freely, without the small extra
penalty of invoking prctl() explicitly to turn task isolation off
before starting to use kernel services.

Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
---
 include/uapi/linux/prctl.h | 1 +
 kernel/isolation.c         | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index a5582ace987f..1e204f1a0f4a 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -202,6 +202,7 @@ struct prctl_mm_map {
 #define PR_GET_TASK_ISOLATION		49
 # define PR_TASK_ISOLATION_ENABLE	(1 << 0)
 # define PR_TASK_ISOLATION_STRICT	(1 << 1)
+# define PR_TASK_ISOLATION_ONE_SHOT	(1 << 2)
 # define PR_TASK_ISOLATION_SET_SIG(sig)	(((sig) & 0x7f) << 8)
 # define PR_TASK_ISOLATION_GET_SIG(bits) (((bits) >> 8) & 0x7f)
 
diff --git a/kernel/isolation.c b/kernel/isolation.c
index 1c4f320a24a0..d0e94505bfac 100644
--- a/kernel/isolation.c
+++ b/kernel/isolation.c
@@ -205,7 +205,11 @@ void _task_isolation_exception(const char *fmt, ...)
 		va_end(args);
 
 		task_isolation_interrupt(task, buf);
+		return;
 	}
+
+	if (task->task_isolation_flags & PR_TASK_ISOLATION_ONE_SHOT)
+		task_isolation_set_flags(task, 0);
 }
 
 /*
@@ -229,6 +233,9 @@ int task_isolation_syscall(int syscall)
 		return -1;
 	}
 
+	if (task->task_isolation_flags & PR_TASK_ISOLATION_ONE_SHOT)
+		task_isolation_set_flags(task, 0);
+
 	return 0;
 }
 
-- 
2.7.2
