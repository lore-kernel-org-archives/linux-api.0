From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] Adding support of RLIMIT_CPUNS
Date: Fri, 18 Aug 2017 13:46:17 +0200
Message-ID: <20170818114617.GC18513@dhcp22.suse.cz>
References: <1502999145.913410989@f459.i.mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502999145.913410989@f459.i.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?0JPRgNC40LPQvtGA0LjQuSDQoNC10LfQvdC40LrQvtCy?= <grikukan@mail.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Appart from Andrew said about the usecase make sure to CC linux-api for
any user visible interface change.

On Thu 17-08-17 22:45:45, Григорий Резников wrote:
> To set time limit for process now we can use RLIMIT_CPU.
> However, it has precision up to one second and it can be
> too big for some purposes.
> 
> This patch adds support of RLIMIT_CPUNS, which works 
> almost as RLIMIT_CPU, but has nanosecond precision.
> 
> At the moment, RLIMIT_CPU and RLIMIT_CPUNS are two
> independent values, because I don't see any nice way
> for them to be together.
> 
> Signed-off-by: Grigory Reznikov <grikukan@mail.ru>
> ---
>  fs/proc/base.c                      |  1 +
>  include/asm-generic/resource.h      |  1 +
>  include/linux/posix-timers.h        |  1 +
>  include/uapi/asm-generic/resource.h |  4 +++-
>  kernel/fork.c                       | 20 +++++++++++++----
>  kernel/sys.c                        | 11 ++++++++-
>  kernel/time/posix-cpu-timers.c      | 45 +++++++++++++++++++++++++++++++++----
>  7 files changed, 73 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 719c2e9..1e3049e 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -567,6 +567,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
>  	[RLIMIT_NICE] = {"Max nice priority", NULL},
>  	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
>  	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> +	[RLIMIT_CPUNS] = {"Max cpu time", "ns"},
>  };
>  
>  /* Display limits for a process */
> diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
> index 5e752b9..ec7b0c5 100644
> --- a/include/asm-generic/resource.h
> +++ b/include/asm-generic/resource.h
> @@ -25,6 +25,7 @@
>  	[RLIMIT_NICE]		= { 0, 0 },				\
>  	[RLIMIT_RTPRIO]		= { 0, 0 },				\
>  	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
> +	[RLIMIT_CPUNS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
>  }
>  
>  #endif
> diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> index 62839fd..0e22bde 100644
> --- a/include/linux/posix-timers.h
> +++ b/include/linux/posix-timers.h
> @@ -110,6 +110,7 @@ void posix_cpu_timers_exit_group(struct task_struct *task);
>  void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
>  			   u64 *newval, u64 *oldval);
>  
> +void update_rlimit_cpu_ns(struct task_struct *task, unsigned long rlim_new);
>  void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
>  
>  void posixtimer_rearm(struct siginfo *info);
> diff --git a/include/uapi/asm-generic/resource.h b/include/uapi/asm-generic/resource.h
> index c6d10af..a86b2f4 100644
> --- a/include/uapi/asm-generic/resource.h
> +++ b/include/uapi/asm-generic/resource.h
> @@ -45,7 +45,9 @@
>  					   0-39 for nice level 19 .. -20 */
>  #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
>  #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
> -#define RLIM_NLIMITS		16
> +#define RLIMIT_CPUNS		16	/* CPU time in ns,
> +					doesn't depend on RLIMIT_CPU */
> +#define RLIM_NLIMITS		17
>  
>  /*
>   * SuS says limits have to be unsigned.
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e075b77..33f9bbf 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1348,11 +1348,23 @@ void __cleanup_sighand(struct sighand_struct *sighand)
>   */
>  static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  {
> -	unsigned long cpu_limit;
> -
> +	unsigned long cpu_limit, cpuns_limit, total_limit;
> +	/* RLIMIT_CPU timeout, RLIMIT_CPUNS timeout and time
> +	 * to closest timeout
> +	 */
> +
>  	cpu_limit = READ_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
> -	if (cpu_limit != RLIM_INFINITY) {
> -		sig->cputime_expires.prof_exp = cpu_limit * NSEC_PER_SEC;
> +	cpuns_limit = READ_ONCE(sig->rlim[RLIMIT_CPUNS].rlim_cur);
> +
> +	total_limit = RLIM_INFINITY;
> +
> +	if (cpu_limit != RLIM_INFINITY)
> +		total_limit = cpu_limit * NSEC_PER_SEC;
> +	if (cpuns_limit != RLIM_INFINITY && cpuns_limit < total_limit)
> +		total_limit = cpuns_limit;
> +
> +	if (total_limit != RLIM_INFINITY) {
> +		sig->cputime_expires.prof_exp = total_limit;
>  		sig->cputimer.running = true;
>  	}
>  
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 2855ee7..539b110 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1504,6 +1504,8 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
>  			 */
>  			new_rlim->rlim_cur = 1;
>  		}
> +		if (resource == RLIMIT_CPUNS && new_rlim->rlim_cur == 0)
> +			new_rlim->rlim_cur = NSEC_PER_SEC;
>  	}
>  	if (!retval) {
>  		if (old_rlim)
> @@ -1519,10 +1521,17 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
>  	 * very long-standing error, and fixing it now risks breakage of
>  	 * applications, so we live with it
>  	 */
> -	 if (!retval && new_rlim && resource == RLIMIT_CPU &&
> +	if (!retval && new_rlim && resource == RIMIT_CPU &&
>  	     new_rlim->rlim_cur != RLIM_INFINITY &&
>  	     IS_ENABLED(CONFIG_POSIX_TIMERS))
>  		update_rlimit_cpu(tsk, new_rlim->rlim_cur);
> +
> +	if (!retval && new_rlim && resource == RLIMIT_CPUNS &&
> +	     new_rlim->rlim_cur != RLIM_INFINITY &&
> +	     IS_ENABLED(CONFIG_POSIX_TIMERS))
> +		update_rlimit_cpu_ns(tsk, new_rlim->rlim_cur);
> +
> +
>  out:
>  	read_unlock(&tasklist_lock);
>  	return retval;
> diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
> index a3bd5db..e4830f6 100644
> --- a/kernel/time/posix-cpu-timers.c
> +++ b/kernel/time/posix-cpu-timers.c
> @@ -19,20 +19,26 @@
>  static void posix_cpu_timer_rearm(struct k_itimer *timer);
>  
>  /*
> - * Called after updating RLIMIT_CPU to run cpu timer and update
> + * Called after updating RLIMIT_CPUNS to run cpu timer and update
>   * tsk->signal->cputime_expires expiration cache if necessary. Needs
>   * siglock protection since other code may update expiration cache as
>   * well.
>   */
> -void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
> +void update_rlimit_cpu_ns(struct task_struct *task, unsigned long rlim_new)
>  {
> -	u64 nsecs = rlim_new * NSEC_PER_SEC;
> +	u64 nsecs = rlim_new;
>  
>  	spin_lock_irq(&task->sighand->siglock);
>  	set_process_cpu_timer(task, CPUCLOCK_PROF, &nsecs, NULL);
>  	spin_unlock_irq(&task->sighand->siglock);
>  }
>  
> +/* Same function for RLIMIT_CPU */
> +void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
> +{
> +	update_rlimit_cpu(task, rlim_new * NSEC_PER_SEC);
> +}
> +
>  static int check_clock(const clockid_t which_clock)
>  {
>  	int error = 0;
> @@ -938,6 +944,9 @@ static void check_process_timers(struct task_struct *tsk,
>  			 SIGPROF);
>  	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
>  			 SIGVTALRM);
> +	/*
> +	 * RLIMIT_CPU check
> +	 */
>  	soft = READ_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
>  	if (soft != RLIM_INFINITY) {
>  		unsigned long psecs = div_u64(ptime, NSEC_PER_SEC);
> @@ -974,7 +983,35 @@ static void check_process_timers(struct task_struct *tsk,
>  		if (!prof_expires || x < prof_expires)
>  			prof_expires = x;
>  	}
> -
> +	/*
> +	 * RLIMIT_CPUNS check
> +	 */
> +	soft = READ_ONCE(sig->rlim[RLIMIT_CPUNS].rlim_cur);
> +	if (soft != RLIM_INFINITY) {
> +		unsigned long hard =
> +			READ_ONCE(sig->rlim[RLIMIT_CPUNS].rlim_max);
> +		if (ptime >= hard) {
> +			if (print_fatal_signals) {
> +				pr_info("RT Watchdog Timeout (hard): %s[%d]\n",
> +					tsk->comm, task_pid_nr(tsk));
> +			}
> +			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
> +			return;
> +		}
> +		if (ptime >= soft) {
> +			if (print_fatal_signals) {
> +				pr_info("CPU Watchdog Timeout (soft): %s[%d]\n",
> +					tsk->comm, task_pid_nr(tsk));
> +			}
> +			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
> +			if (soft < hard) {
> +				soft += NSEC_PER_SEC;
> +				sig->rlim[RLIMIT_CPUNS].rlim_cur = soft;
> +			}
> +		}
> +		if (!prof_expires || soft < prof_expires)
> +			prof_expires = soft;
> +	}
>  	sig->cputime_expires.prof_exp = prof_expires;
>  	sig->cputime_expires.virt_exp = virt_expires;
>  	sig->cputime_expires.sched_exp = sched_expires;
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
