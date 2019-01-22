From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 07/16] sched/core: uclamp: Add system default clamps
Date: Tue, 22 Jan 2019 14:56:44 +0100
Message-ID: <20190122135644.GP27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-8-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115101513.2822-8-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 15, 2019 at 10:15:04AM +0000, Patrick Bellasi wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 84294925d006..c8f391d1cdc5 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -625,6 +625,11 @@ struct uclamp_se {
>  	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
>  	unsigned int mapped		: 1;
>  	unsigned int active		: 1;
> +	/* Clamp bucket and value actually used by a RUNNABLE task */
> +	struct {
> +		unsigned int value	: bits_per(SCHED_CAPACITY_SCALE);
> +		unsigned int bucket_id	: bits_per(UCLAMP_BUCKETS);
> +	} effective;

I am confuzled by this thing..  so uclamp_se already has a value,bucket,
which per the prior code is the effective one.

Now; I think I see why you want another value; you need the second to
store the original value for when the system limits change and we must
re-evaluate.

So why are you not adding something like:

	unsigned int orig_value : bits_per(SCHED_CAPACITY_SCALE);

> +unsigned int sysctl_sched_uclamp_util_min;

> +unsigned int sysctl_sched_uclamp_util_max = SCHED_CAPACITY_SCALE;

> +static inline void
> +uclamp_effective_get(struct task_struct *p, unsigned int clamp_id,
> +		     unsigned int *clamp_value, unsigned int *bucket_id)
> +{
> +	/* Task specific clamp value */
> +	*clamp_value = p->uclamp[clamp_id].value;
> +	*bucket_id = p->uclamp[clamp_id].bucket_id;
> +
> +	/* System default restriction */
> +	if (unlikely(*clamp_value < uclamp_default[UCLAMP_MIN].value ||
> +		     *clamp_value > uclamp_default[UCLAMP_MAX].value)) {
> +		/* Keep it simple: unconditionally enforce system defaults */
> +		*clamp_value = uclamp_default[clamp_id].value;
> +		*bucket_id = uclamp_default[clamp_id].bucket_id;
> +	}
> +}

That would then turn into something like:

	unsigned int high = READ_ONCE(sysctl_sched_uclamp_util_max);
	unsigned int low  = READ_ONCE(sysctl_sched_uclamp_util_min);

	uclamp_se->orig_value = value;
	uclamp_se->value = clamp(value, low, high);

And then determine bucket_id based on value.

> +int sched_uclamp_handler(struct ctl_table *table, int write,
> +			 void __user *buffer, size_t *lenp,
> +			 loff_t *ppos)
> +{
> +	int old_min, old_max;
> +	int result = 0;
> +
> +	mutex_lock(&uclamp_mutex);
> +
> +	old_min = sysctl_sched_uclamp_util_min;
> +	old_max = sysctl_sched_uclamp_util_max;
> +
> +	result = proc_dointvec(table, write, buffer, lenp, ppos);
> +	if (result)
> +		goto undo;
> +	if (!write)
> +		goto done;
> +
> +	if (sysctl_sched_uclamp_util_min > sysctl_sched_uclamp_util_max ||
> +	    sysctl_sched_uclamp_util_max > SCHED_CAPACITY_SCALE) {
> +		result = -EINVAL;
> +		goto undo;
> +	}
> +
> +	if (old_min != sysctl_sched_uclamp_util_min) {
> +		uclamp_bucket_inc(NULL, &uclamp_default[UCLAMP_MIN],
> +				  UCLAMP_MIN, sysctl_sched_uclamp_util_min);
> +	}
> +	if (old_max != sysctl_sched_uclamp_util_max) {
> +		uclamp_bucket_inc(NULL, &uclamp_default[UCLAMP_MAX],
> +				  UCLAMP_MAX, sysctl_sched_uclamp_util_max);
> +	}

Should you not update all tasks?
