From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Thu, 11 Aug 2016 00:16:58 +0200
Message-ID: <20160810221656.GC19757@lerouge>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org>
 <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
 <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
 <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
 <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
Sender: linux-doc-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 27, 2016 at 08:55:28AM -0500, Christoph Lameter wrote:
> On Mon, 25 Jul 2016, Christoph Lameter wrote:
> 
> > Guess so. I will have a look at this when I get some time again.
> 
> Ok so the problem is the clocksource_watchdog() function in
> kernel/time/clocksource.c. This function is active if
> CONFIG_CLOCKSOURCE_WATCHDOG is defined. It will check the timesources of
> each processor for being within bounds and then reschedule itself on the
> next one.
> 
> The purpose of the function seems to be to determine *if* a clocksource is
> unstable. It does not mean that the clocksource *is* unstable.
> 
> The critical piece of code is this:
> 
>         /*
>          * Cycle through CPUs to check if the CPUs stay synchronized
>          * to each other.
>          */
>         next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
>         if (next_cpu >= nr_cpu_ids)
>                 next_cpu = cpumask_first(cpu_online_mask);
>         watchdog_timer.expires += WATCHDOG_INTERVAL;
>         add_timer_on(&watchdog_timer, next_cpu);
> 
> 
> Should we just cycle through the cpus that are not isolated? Otherwise we
> need to have some means to check the clocksources for accuracy remotely
> (probably impossible for TSC etc).
> 
> The WATCHDOG_INTERVAL is 1 second so this causes an interrupt every
> second.
> 
> Note that we are running with the patch that removes the 1 HZ mininum time
> tick. With an older kernel code base (redhat) we can keep the kernel quiet
> for minutes. The clocksource watchdog causes timers to fire again.

I had similar issues, this seems to happen when the tsc is considered not reliable
(which doesn't necessarily mean unstable. I think it has to do with some x86 CPU feature
flag).

IIRC, this _has_ to execute on all online CPUs because every TSCs of running CPUs
are concerned.

I personally override that with passing the tsc=reliable kernel parameter. Of course
use it at your own risk.

But eventually I don't think we can offline that to housekeeping only CPUs.
