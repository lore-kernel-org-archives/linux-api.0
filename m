From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH 5/6] nohz: support PR_DATAPLANE_STRICT mode
Date: Fri, 8 May 2015 13:58:46 -0400
Message-ID: <1431107927-13998-6-git-send-email-cmetcalf@ezchip.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@ezchip.com>
List-Id: linux-api@vger.kernel.org

With QUIESCE mode, the task is in principle guaranteed not to be
interrupted by the kernel, but only if it behaves.  In particular,
if it enters the kernel via system call, page fault, or any of
a number of other synchronous traps, it may be unexpectedly
exposed to long latencies.  Add a simple flag that puts the process
into a state where any such kernel entry is fatal.

To allow the state to be entered and exited, we add an internal
bit to current->dataplane_flags that is set when prctl() sets the
flags.  That way, when we are exiting the kernel after calling
prctl() to forbid future kernel exits, we don't get immediately
killed.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 include/uapi/linux/prctl.h |  2 ++
 kernel/sys.c               |  2 +-
 kernel/time/tick-sched.c   | 17 +++++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 8b735651304a..9cf79aa1e73f 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -195,5 +195,7 @@ struct prctl_mm_map {
 #define PR_GET_DATAPLANE	48
 # define PR_DATAPLANE_ENABLE	(1 << 0)
 # define PR_DATAPLANE_QUIESCE	(1 << 1)
+# define PR_DATAPLANE_STRICT	(1 << 2)
+# define PR_DATAPLANE_PRCTL	(1U << 31)	/* kernel internal */
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 930b750aefde..8102433c9edd 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2245,7 +2245,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		break;
 #ifdef CONFIG_NO_HZ_FULL
 	case PR_SET_DATAPLANE:
-		me->dataplane_flags = arg2;
+		me->dataplane_flags = arg2 | PR_DATAPLANE_PRCTL;
 		break;
 	case PR_GET_DATAPLANE:
 		error = me->dataplane_flags;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 69d908c6cef8..22ed0decb363 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -436,6 +436,20 @@ static void dataplane_quiesce(void)
 			(jiffies - start));
 		dump_stack();
 	}
+
+	/*
+	 * Kill the process if it violates STRICT mode.  Note that this
+	 * code also results in killing the task if a kernel bug causes an
+	 * irq to be delivered to this core.
+	 */
+	if ((task->dataplane_flags & (PR_DATAPLANE_STRICT|PR_DATAPLANE_PRCTL))
+	    == PR_DATAPLANE_STRICT) {
+		pr_warn("Dataplane STRICT mode violated; process killed.\n");
+		dump_stack();
+		task->dataplane_flags &= ~PR_DATAPLANE_QUIESCE;
+		local_irq_enable();
+		do_group_exit(SIGKILL);
+	}
 }
 
 /*
@@ -464,6 +478,9 @@ void tick_nohz_dataplane_enter(void)
 	if ((current->dataplane_flags & PR_DATAPLANE_QUIESCE) != 0)
 		dataplane_quiesce();
 
+	/* Clear the bit set by prctl() when it updates the flags. */
+	current->dataplane_flags &= ~PR_DATAPLANE_PRCTL;
+
 	/*
 	 * Disable interrupts again since other code running in this
 	 * function may have enabled them, and the caller expects
-- 
2.1.2
