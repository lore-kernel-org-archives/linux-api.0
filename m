From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 03/15] sched/core: uclamp: Add system default clamps
Date: Wed, 13 Mar 2019 15:32:40 +0100
Message-ID: <20190313143240.GH5922@hirez.programming.kicks-ass.net>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-4-patrick.bellasi@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190208100554.32196-4-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 08, 2019 at 10:05:42AM +0000, Patrick Bellasi wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 45460e7a3eee..447261cd23ba 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -584,14 +584,32 @@ struct sched_dl_entity {
>   * Utilization clamp for a scheduling entity
>   * @value:		clamp value "requested" by a se
>   * @bucket_id:		clamp bucket corresponding to the "requested" value
> + * @effective:		clamp value and bucket actually "assigned" to the se
> + * @active:		the se is currently refcounted in a rq's bucket
>   *
> + * Both bucket_id and effective::bucket_id are the index of the clamp bucket
> + * matching the corresponding clamp value which are pre-computed and stored to
> + * avoid expensive integer divisions from the fast path.
> + *
> + * The active bit is set whenever a task has got an effective::value assigned,
> + * which can be different from the user requested clamp value. This allows to
> + * know a task is actually refcounting the rq's effective::bucket_id bucket.
>   */
>  struct uclamp_se {
> +	/* Clamp value "requested" by a scheduling entity */
>  	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
>  	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
> +	unsigned int active		: 1;
> +	/*
> +	 * Clamp value "obtained" by a scheduling entity.
> +	 *
> +	 * This cache the actual clamp value, possibly enforced by system
> +	 * default clamps, a task is subject to while enqueued in a rq.
> +	 */
> +	struct {
> +		unsigned int value	: bits_per(SCHED_CAPACITY_SCALE);
> +		unsigned int bucket_id	: bits_per(UCLAMP_BUCKETS);
> +	} effective;

I still think that this effective thing is backwards.

The existing code already used @value and @bucket_id as 'effective' and
you're now changing all that again. This really doesn't make sense to
me.

Also; if you don't add it inside struct uclamp_se, but add a second
instance,

>  };
>  #endif /* CONFIG_UCLAMP_TASK */
>  


> @@ -803,6 +811,70 @@ static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id,
>  	WRITE_ONCE(rq->uclamp[clamp_id].value, max_value);
>  }
>  
> +/*
> + * The effective clamp bucket index of a task depends on, by increasing
> + * priority:
> + * - the task specific clamp value, when explicitly requested from userspace
> + * - the system default clamp value, defined by the sysadmin
> + *
> + * As a side effect, update the task's effective value:
> + *    task_struct::uclamp::effective::value
> + * to represent the clamp value of the task effective bucket index.
> + */
> +static inline void
> +uclamp_effective_get(struct task_struct *p, unsigned int clamp_id,
> +		     unsigned int *clamp_value, unsigned int *bucket_id)
> +{
> +	/* Task specific clamp value */
> +	*bucket_id = p->uclamp[clamp_id].bucket_id;
> +	*clamp_value = p->uclamp[clamp_id].value;
> +
> +	/* Always apply system default restrictions */
> +	if (unlikely(*clamp_value > uclamp_default[clamp_id].value)) {
> +		*clamp_value = uclamp_default[clamp_id].value;
> +		*bucket_id = uclamp_default[clamp_id].bucket_id;
> +	}
> +}

you can avoid horrors like this and simply return a struct uclamp_se by
value.
