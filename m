From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: clocksource_watchdog causing scheduling of timers every second (was
 [v13] support "task_isolation" mode)
Date: Wed, 27 Jul 2016 08:55:28 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com> <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org> <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com> <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org> <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607251133450.25354-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 25 Jul 2016, Christoph Lameter wrote:

> Guess so. I will have a look at this when I get some time again.

Ok so the problem is the clocksource_watchdog() function in
kernel/time/clocksource.c. This function is active if
CONFIG_CLOCKSOURCE_WATCHDOG is defined. It will check the timesources of
each processor for being within bounds and then reschedule itself on the
next one.

The purpose of the function seems to be to determine *if* a clocksource is
unstable. It does not mean that the clocksource *is* unstable.

The critical piece of code is this:

        /*
         * Cycle through CPUs to check if the CPUs stay synchronized
         * to each other.
         */
        next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
        if (next_cpu >= nr_cpu_ids)
                next_cpu = cpumask_first(cpu_online_mask);
        watchdog_timer.expires += WATCHDOG_INTERVAL;
        add_timer_on(&watchdog_timer, next_cpu);


Should we just cycle through the cpus that are not isolated? Otherwise we
need to have some means to check the clocksources for accuracy remotely
(probably impossible for TSC etc).

The WATCHDOG_INTERVAL is 1 second so this causes an interrupt every
second.

Note that we are running with the patch that removes the 1 HZ mininum time
tick. With an older kernel code base (redhat) we can keep the kernel quiet
for minutes. The clocksource watchdog causes timers to fire again.
