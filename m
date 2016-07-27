From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Wed, 27 Jul 2016 10:12:02 -0400
Message-ID: <f8d72e47-7e84-cbd0-869f-69bf452a8bfb@mellanox.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org>
 <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
 <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org>
 <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
 <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 7/27/2016 9:55 AM, Christoph Lameter wrote:
> The critical piece of code is this:
>
>          /*
>           * Cycle through CPUs to check if the CPUs stay synchronized
>           * to each other.
>           */
>          next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
>          if (next_cpu >= nr_cpu_ids)
>                  next_cpu = cpumask_first(cpu_online_mask);
>          watchdog_timer.expires += WATCHDOG_INTERVAL;
>          add_timer_on(&watchdog_timer, next_cpu);
>
>
> Should we just cycle through the cpus that are not isolated? Otherwise we
> need to have some means to check the clocksources for accuracy remotely
> (probably impossible for TSC etc).

That sounds like the right idea - use the housekeeping cpu mask instead of the
cpu online mask.  Should be a straightforward patch; do you want to do that
and test it in your configuration, and I'll include it in the next spin of the
patch series?

Thanks for your testing!

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
