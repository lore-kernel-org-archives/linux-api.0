From: Christoph Lameter <cl@linux.com>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Wed, 27 Jul 2016 13:56:28 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607271355320.5760@east.gentwo.org>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com> <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org> <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com> <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org> <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org> <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org> <f8d72e47-7e84-cbd0-869f-69bf452a8bfb@mellanox.com> <alpine.DEB.2.20.1607271022130.25729@east.gentwo.org> <alpine.DEB.2.20.1607271030020.25729@east.gentwo.org>
 <f7553d2a-f4ab-b218-bb93-fcb436db1770@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <f7553d2a-f4ab-b218-bb93-fcb436db1770@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 27 Jul 2016, Chris Metcalf wrote:

> How about using cpumask_next_and(raw_smp_processor_id(), cpu_online_mask,
> housekeeping_cpumask()), likewise cpumask_first_and()?  Does that work?

Ok here is V2:


Subject: clocksource: Do not schedule watchdog on isolated or NOHZ cpus V2

watchdog checks can only run on housekeeping capable cpus. Otherwise
we will be generating noise that we would like to avoid on the isolated
processors.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c
+++ linux/kernel/time/clocksource.c
@@ -269,9 +269,10 @@ static void clocksource_watchdog(unsigne
 	 * Cycle through CPUs to check if the CPUs stay synchronized
 	 * to each other.
 	 */
-	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
+	next_cpu = cpumask_next_and(raw_smp_processor_id(), cpu_online_mask, housekeeping_cpumask());
 	if (next_cpu >= nr_cpu_ids)
-		next_cpu = cpumask_first(cpu_online_mask);
+		next_cpu = cpumask_first_and(cpu_online_mask, housekeeping_cpumask());
+
 	watchdog_timer.expires += WATCHDOG_INTERVAL;
 	add_timer_on(&watchdog_timer, next_cpu);
 out:
