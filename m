From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Fix /proc/stat freezes (was [PATCH v15] "task_isolation"
 mode)
Date: Wed, 28 Sep 2016 15:16:14 +0200
Message-ID: <20160928131613.GA5366@lerouge>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1608171432200.30568@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1608171432200.30568@east.gentwo.org>
Sender: linux-doc-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 17, 2016 at 02:37:46PM -0500, Christoph Lameter wrote:
> On Tue, 16 Aug 2016, Chris Metcalf wrote:
> Subject: NOHZ: Correctly display increasing cputime when processor is busy
> 
> The tick may be switched off when the processor gets busy with nohz full.
> The user time fields in /proc/stat will then no longer increase because
> the tick is not run to update the cpustat values anymore.
> 
> Compensate for the missing ticks by checking if a processor is in
> such a mode. If so then add the ticks that have passed since
> the tick was switched off to the usertime.
> 
> Note that this introduces a slight inaccuracy. The process may
> actually do syscalls without triggering a tick again but the
> processing time in those calls is negligible. Any wait or sleep
> occurrence during syscalls would activate the tick again.
> 
> Any inaccuracy is corrected once the tick is switched on again
> since the actual value where cputime aggregates is not changed.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/fs/proc/stat.c
> ===================================================================
> --- linux.orig/fs/proc/stat.c	2016-08-04 09:04:57.681480937 -0500
> +++ linux/fs/proc/stat.c	2016-08-17 14:27:37.813445675 -0500
> @@ -77,6 +77,12 @@ static u64 get_iowait_time(int cpu)
> 
>  #endif
> 
> +static unsigned long inline get_cputime_user(int cpu)
> +{
> +	return kcpustat_cpu(cpu).cpustat[CPUTIME_USER] +
> +			tick_stopped_busy_ticks(cpu);
> +}
> +
>  static int show_stat(struct seq_file *p, void *v)
>  {
>  	int i, j;
> @@ -93,7 +99,7 @@ static int show_stat(struct seq_file *p,
>  	getboottime64(&boottime);
> 
>  	for_each_possible_cpu(i) {
> -		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
> +		user += get_cputime_user(i);
>  		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
>  		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
>  		idle += get_idle_time(i);
> @@ -130,7 +136,7 @@ static int show_stat(struct seq_file *p,
> 
>  	for_each_online_cpu(i) {
>  		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
> -		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
> +		user = get_cputime_user(i);
>  		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
>  		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
>  		idle = get_idle_time(i);
> Index: linux/kernel/time/tick-sched.c
> ===================================================================
> --- linux.orig/kernel/time/tick-sched.c	2016-07-27 08:41:17.109862517 -0500
> +++ linux/kernel/time/tick-sched.c	2016-08-17 14:16:42.073835333 -0500
> @@ -990,6 +990,24 @@ ktime_t tick_nohz_get_sleep_length(void)
>  	return ts->sleep_length;
>  }
> 
> +/**
> + * tick_stopped_busy_ticks - return the ticks that did not occur while the
> + *				processor was busy and the tick was off
> + *
> + * Called from sysfs to correctly calculate cputime of nohz full processors
> + */
> +unsigned long tick_stopped_busy_ticks(int cpu)
> +{
> +#ifdef CONFIG_NOHZ_FULL
> +	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
> +
> +	if (!ts->inidle && ts->tick_stopped)
> +		return jiffies - ts->idle_jiffies;


It won't work, ts->idle_jiffies only takes care about idle time.

That said, the tick is supposed to fire once per second, the reason for the freeze is
still unknown. Now in order to get rid of the 1hz, we'll need to force updates on
cpustats like that patch intended to.

But I see only two sane ways to do so:

_ fetch the task of CPU X and deduce on top of vtime values where it is executing and
  how much delta is to be added to cpustat. The problem here is that we may need to do that
  under the rq lock to make sure the task is really in CPU X and stays there. Perhaps we could
  cheat though and add the CPU number on vtime fields then vtime_seqcount would be enough
  to get stable results.

_ have housekeeping update all those CPUs cpustat periodically. But that means we need to
  turn back vtime_seqcount into a seqlock and that would be a shame for nohz_full performance.

