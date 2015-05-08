From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH 4/6] nohz: support PR_DATAPLANE_QUIESCE
Date: Fri, 8 May 2015 13:58:45 -0400
Message-ID: <1431107927-13998-5-git-send-email-cmetcalf@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

This prctl() flag for PR_SET_DATAPLANE sets a mode that requires the
kernel to quiesce any pending timer interrupts prior to returning
to userspace.  When running with this mode set, sys calls (and page
faults, etc.) can be inordinately slow.  However, user applications
that want to guarantee that no unexpected interrupts will occur
(even if they call into the kernel) can set this flag to guarantee
that semantics.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/uapi/linux/prctl.h |  1 +
 kernel/time/tick-sched.c   | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 1aa8fa8a8b05..8b735651304a 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -194,5 +194,6 @@ struct prctl_mm_map {
 #define PR_SET_DATAPLANE	47
 #define PR_GET_DATAPLANE	48
 # define PR_DATAPLANE_ENABLE	(1 << 0)
+# define PR_DATAPLANE_QUIESCE	(1 << 1)
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index fd0e6e5c931c..69d908c6cef8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -392,6 +392,53 @@ void __init tick_nohz_init(void)
 }
 
 /*
+ * We normally return immediately to userspace.
+ *
+ * The PR_DATAPLANE_QUIESCE flag causes us to wait until no more
+ * interrupts are pending.  Otherwise we nap with interrupts enabled
+ * and wait for the next interrupt to fire, then loop back and retry.
+ *
+ * Note that if you schedule two processes on the same core and both
+ * specify PR_DATAPLANE_QUIESCE, neither will ever leave the kernel,
+ * and one will have to be killed manually.  Otherwise in situations
+ * where another process is in the runqueue on this cpu, this task
+ * will just wait for that other task to go idle before returning to
+ * user space.
+ */
+static void dataplane_quiesce(void)
+{
+	struct clock_event_device *dev =
+		__this_cpu_read(tick_cpu_device.evtdev);
+	struct task_struct *task = current;
+	unsigned long start = jiffies;
+	bool warned = false;
+
+	while (ACCESS_ONCE(dev->next_event.tv64) != KTIME_MAX) {
+		if (!warned && (jiffies - start) >= (5 * HZ)) {
+			pr_warn("%s/%d: cpu %d: dataplane task blocked for %ld jiffies\n",
+				task->comm, task->pid, smp_processor_id(),
+				(jiffies - start));
+			warned = true;
+		}
+		if (should_resched())
+			schedule();
+		if (test_thread_flag(TIF_SIGPENDING))
+			break;
+
+		/* Idle with interrupts enabled and wait for the tick. */
+		set_current_state(TASK_INTERRUPTIBLE);
+		arch_cpu_idle();
+		set_current_state(TASK_RUNNING);
+	}
+	if (warned) {
+		pr_warn("%s/%d: cpu %d: dataplane task unblocked after %ld jiffies\n",
+			task->comm, task->pid, smp_processor_id(),
+			(jiffies - start));
+		dump_stack();
+	}
+}
+
+/*
  * When returning to userspace on a nohz_full core after doing
  * prctl(PR_DATAPLANE_SET,1), we come here and try more aggressively
  * to prevent this core from being interrupted later.
@@ -411,6 +458,13 @@ void tick_nohz_dataplane_enter(void)
 	lru_add_drain();
 
 	/*
+	 * Quiesce any timer ticks if requested.  On return from this
+	 * function, no timer ticks are pending.
+	 */
+	if ((current->dataplane_flags & PR_DATAPLANE_QUIESCE) != 0)
+		dataplane_quiesce();
+
+	/*
 	 * Disable interrupts again since other code running in this
 	 * function may have enabled them, and the caller expects
 	 * interrupts to be disabled on return.  Enabling them during
-- 
2.1.2
