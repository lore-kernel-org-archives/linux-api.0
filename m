From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/20] smpboot: Add common code for notification from dying CPU
Date: Tue,  3 Mar 2015 09:42:56 -0800
Message-ID: <1425404595-17816-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150303174144.GA13139@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150303174144.GA13139@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, mathieu.desnoyers@efficios.com, josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU ignores offlined CPUs, so they cannot safely run RCU read-side code.
(They -can- use SRCU, but not RCU.)  This means that any use of RCU
during or after the call to arch_cpu_idle_dead().  Unfortunately,
commit 2ed53c0d6cc99 added a complete() call, which will contain RCU
read-side critical sections if there is a task waiting to be awakened.

Which, as it turns out, there almost never is.  In my qemu/KVM testing,
the to-be-awakened task is not yet asleep more than 99.5% of the time.
In current mainline, failure is even harder to reproduce, requiring a
virtualized environment that delays the outgoing CPU by at least three
jiffies between the time it exits its stop_machine() task at CPU_DYING
time and the time it calls arch_cpu_idle_dead() from the idle loop.
However, this problem really can occur, especially in virtualized
environments, and therefore really does need to be fixed

This suggests moving back to the polling loop, but using a much shorter
wait, with gentle exponential backoff instead of the old 100-millisecond
wait.  Most of the time, the loop will exit without waiting at all,
and almost all of the remaining uses will wait only five microseconds.
If the outgoing CPU is preempted, a loop will wait one jiffy, then
increase the wait by a factor of 11/10ths, rounding up.  As before, there
is a five-second timeout.

This commit therefore provides common-code infrastructure to do the
dying-to-surviving CPU handoff in a safe manner.  This code also
provides an indication at CPU-online of whether the CPU to be onlined
previously timed out on offline.  The new cpu_check_up_prepare() function
returns -EBUSY if this CPU previously took more than five seconds to
go offline, or -EAGAIN if it has not yet managed to go offline.  The
rationale for -EAGAIN is that it might still be preempted, so an additional
wait might well find it correctly offlined.  Architecture-specific code
can decide how to handle these conditions.  Systems in which CPUs take
themselves completely offline might respond to an -EBUSY return as if
it was a zero (success) return.  Systems in which the surviving CPU must
take some action might take it at this time, or might simply mark the
other CPU as unusable.

Note that architectures that take the easy way out and simply pass the
-EBUSY and -EAGAIN upwards will change the sysfs API.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
---
 include/linux/cpu.h |  12 ++++
 kernel/smpboot.c    | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4260e8594bd7..4744ef915acd 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -95,6 +95,8 @@ enum {
 					* Called on the new cpu, just before
 					* enabling interrupts. Must not sleep,
 					* must not fail */
+#define CPU_BROKEN		0x000C /* CPU (unsigned)v did not die properly,
+					* perhaps due to preemption. */
 
 /* Used for CPU hotplug events occurring while tasks are frozen due to a suspend
  * operation in progress
@@ -271,4 +273,14 @@ void arch_cpu_idle_enter(void);
 void arch_cpu_idle_exit(void);
 void arch_cpu_idle_dead(void);
 
+DECLARE_PER_CPU(bool, cpu_dead_idle);
+
+int cpu_report_state(int cpu);
+int cpu_check_up_prepare(int cpu);
+void cpu_set_state_online(int cpu);
+#ifdef CONFIG_HOTPLUG_CPU
+bool cpu_wait_death(unsigned int cpu, int seconds);
+bool cpu_report_death(void);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 40190f28db35..065499f432ec 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/smp.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -314,3 +315,158 @@ void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread)
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);
+
+static DEFINE_PER_CPU(atomic_t, cpu_hotplug_state) = ATOMIC_INIT(CPU_POST_DEAD);
+
+/*
+ * Called to poll specified CPU's state, for example, when waiting for
+ * a CPU to come online.
+ */
+int cpu_report_state(int cpu)
+{
+	return atomic_read(&per_cpu(cpu_hotplug_state, cpu));
+}
+
+/*
+ * If CPU has died properly, set its state to CPU_UP_PREPARE and
+ * return success.  Otherwise, return -EBUSY if the CPU died after
+ * cpu_wait_death() timed out.  And yet otherwise again, return -EAGAIN
+ * if cpu_wait_death() timed out and the CPU still hasn't gotten around
+ * to dying.  In the latter two cases, the CPU might not be set up
+ * properly, but it is up to the arch-specific code to decide.
+ * Finally, -EIO indicates an unanticipated problem.
+ *
+ * Note that it is permissible to omit this call entirely, as is
+ * done in architectures that do no CPU-hotplug error checking.
+ */
+int cpu_check_up_prepare(int cpu)
+{
+	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU)) {
+		atomic_set(&per_cpu(cpu_hotplug_state, cpu), CPU_UP_PREPARE);
+		return 0;
+	}
+
+	switch (atomic_read(&per_cpu(cpu_hotplug_state, cpu))) {
+
+	case CPU_POST_DEAD:
+
+		/* The CPU died properly, so just start it up again. */
+		atomic_set(&per_cpu(cpu_hotplug_state, cpu), CPU_UP_PREPARE);
+		return 0;
+
+	case CPU_TASKS_FROZEN | CPU_DEAD:
+
+		/*
+		 * Timeout during CPU death, so let caller know.
+		 * The outgoing CPU completed its processing, but after
+		 * cpu_wait_death() timed out and reported the error. The
+		 * caller is free to proceed, in which case the state
+		 * will be reset properly by cpu_set_state_online().
+		 * Proceeding despite this -EBUSY return makes sense
+		 * for systems where the outgoing CPUs take themselves
+		 * offline, with no post-death manipulation required from
+		 * a surviving CPU.
+		 */
+		return -EBUSY;
+
+	case CPU_BROKEN:
+
+		/*
+		 * The most likely reason we got here is that there was
+		 * a timeout during CPU death, and the outgoing CPU never
+		 * did complete its processing.  This could happen on
+		 * a virtualized system if the outgoing VCPU gets preempted
+		 * for more than five seconds, and the user attempts to
+		 * immediately online that same CPU.  Trying again later
+		 * might return -EBUSY above, hence -EAGAIN.
+		 */
+		return -EAGAIN;
+
+	default:
+
+		/* Should not happen.  Famous last words. */
+		return -EIO;
+	}
+}
+
+/*
+ * Mark the specified CPU online.
+ *
+ * Note that it is permissible to omit this call entirely, as is
+ * done in architectures that do no CPU-hotplug error checking.
+ */
+void cpu_set_state_online(int cpu)
+{
+	(void)atomic_xchg(&per_cpu(cpu_hotplug_state, cpu), CPU_ONLINE);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Wait for the specified CPU to exit the idle loop and die.
+ */
+bool cpu_wait_death(unsigned int cpu, int seconds)
+{
+	int jf_left = seconds * HZ;
+	int oldstate;
+	bool ret = true;
+	int sleep_jf = 1;
+
+	might_sleep();
+
+	/* The outgoing CPU will normally get done quite quickly. */
+	if (atomic_read(&per_cpu(cpu_hotplug_state, cpu)) == CPU_DEAD)
+		goto update_state;
+	udelay(5);
+
+	/* But if the outgoing CPU dawdles, wait increasingly long times. */
+	while (atomic_read(&per_cpu(cpu_hotplug_state, cpu)) != CPU_DEAD) {
+		schedule_timeout_uninterruptible(sleep_jf);
+		jf_left -= sleep_jf;
+		if (jf_left <= 0)
+			break;
+		sleep_jf = DIV_ROUND_UP(sleep_jf * 11, 10);
+	}
+update_state:
+	oldstate = atomic_read(&per_cpu(cpu_hotplug_state, cpu));
+	if (oldstate == CPU_DEAD) {
+		/* Outgoing CPU died normally, update state. */
+		smp_mb(); /* atomic_read() before update. */
+		atomic_set(&per_cpu(cpu_hotplug_state, cpu), CPU_POST_DEAD);
+	} else {
+		/* Outgoing CPU still hasn't died, set state accordingly. */
+		if (atomic_cmpxchg(&per_cpu(cpu_hotplug_state, cpu),
+				   oldstate, CPU_BROKEN) != oldstate)
+			goto update_state;
+		ret = false;
+	}
+	return ret;
+}
+
+/*
+ * Called by the outgoing CPU to report its successful death.  Return
+ * false if this report follows the surviving CPU's timing out.
+ *
+ * A separate "CPU_TASKS_FROZEN | CPU_DEAD" is used when the surviving
+ * CPU timed out.  This approach allows architectures to omit calls to
+ * cpu_check_up_prepare() and cpu_set_state_online() without defeating
+ * the next cpu_wait_death()'s polling loop.
+ */
+bool cpu_report_death(void)
+{
+	int oldstate;
+	int newstate;
+	int cpu = smp_processor_id();
+
+	do {
+		oldstate = atomic_read(&per_cpu(cpu_hotplug_state, cpu));
+		if (oldstate == CPU_ONLINE)
+			newstate = CPU_DEAD;
+		else
+			newstate = CPU_TASKS_FROZEN | CPU_DEAD;
+	} while (atomic_cmpxchg(&per_cpu(cpu_hotplug_state, cpu),
+				oldstate, newstate) != oldstate);
+	return newstate == CPU_DEAD;
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-- 
1.8.1.5
