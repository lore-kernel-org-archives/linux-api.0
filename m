From: Alessio Balsini <balsini@android.com>
Subject: Re: [PATCH v6 01/16] sched/core: Allow sched_setattr() to use the
 current policy
Date: Fri, 25 Jan 2019 13:56:46 +0000
Message-ID: <20190125135646.j4j2onitam4mwvcw@google.com>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-2-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-2-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

Hello Patrick,

What do you think about the following minor changes:

On Tue, Jan 15, 2019 at 10:14:58AM +0000, Patrick Bellasi wrote:
>  /* SCHED_ISO: reserved but not implemented yet */
>  #define SCHED_IDLE		5
>  #define SCHED_DEADLINE		6
> +/* Must be the last entry: used to sanity check attr.policy values */

I would remove this comment:
- the meaning of SCHED_POLICY_MAX is evident, and
- should we hint on how the value is used? That comment will be removed
  the next time SCHED_POLICY_MAX is used for something else.
  This is what should also happen to the comment of SETPARAM_POLICY:
  now sched_setparam() is no more the only code path accessing
  SETPARAM_POLICY.

> +#define SCHED_POLICY_MAX	7

+#define SCHED_POLICY_MAX    SCHED_DEADLINE

This would make it compliant with the definition of MAX.

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4560,8 +4560,17 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
>  	if (retval)
>  		return retval;
>  
> -	if ((int)attr.sched_policy < 0)
> +	/*
> +	 * A valid policy is always required from userspace, unless
> +	 * SCHED_FLAG_KEEP_POLICY is set and the current policy
> +	 * is enforced for this call.
> +	 */
> +	if (attr.sched_policy >= SCHED_POLICY_MAX &&

+	if (attr.sched_policy > SCHED_POLICY_MAX &&

In line with the previous update.

> +	    !(attr.sched_flags & SCHED_FLAG_KEEP_POLICY)) {
>  		return -EINVAL;

Thanks,
Alessio
