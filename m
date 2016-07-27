From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Wed, 27 Jul 2016 10:31:31 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607271030020.25729@east.gentwo.org>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com> <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org> <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com> <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org> <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org> <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org> <f8d72e47-7e84-cbd0-869f-69bf452a8bfb@mellanox.com> <alpine.DEB.2.20.1607271022130.25729@east.gentwo.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607271022130.25729-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Ok here is a possible patch that explicitly checks for housekeeping cpus:

Subject: clocksource: Do not schedule watchdog on isolated or NOHZ cpus

watchdog checks can only run on housekeeping capable cpus. Otherwise
we will be generating noise that we would like to avoid on the isolated
processors.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c	2016-07-27 08:41:17.109862517 -0500
+++ linux/kernel/time/clocksource.c	2016-07-27 10:28:31.172447732 -0500
@@ -269,9 +269,12 @@ static void clocksource_watchdog(unsigne
 	 * Cycle through CPUs to check if the CPUs stay synchronized
 	 * to each other.
 	 */
-	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
-	if (next_cpu >= nr_cpu_ids)
-		next_cpu = cpumask_first(cpu_online_mask);
+	do {
+		next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
+		if (next_cpu >= nr_cpu_ids)
+			next_cpu = cpumask_first(cpu_online_mask);
+	} while (!is_housekeeping_cpu(next_cpu));
+
 	watchdog_timer.expires += WATCHDOG_INTERVAL;
 	add_timer_on(&watchdog_timer, next_cpu);
 out:
