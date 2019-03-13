From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Wed, 13 Mar 2019 15:59:54 +0000
Message-ID: <20190313155954.jse2tyn5iqxm6wle@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313135238.GC5922@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313135238.GC5922@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 14:52, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:40AM +0000, Patrick Bellasi wrote:
> > +/*
> > + * When a task is enqueued on a rq, the clamp bucket currently defined by the
> > + * task's uclamp::bucket_id is reference counted on that rq. This also
> > + * immediately updates the rq's clamp value if required.
> > + *
> > + * Since tasks know their specific value requested from user-space, we track
> > + * within each bucket the maximum value for tasks refcounted in that bucket.
> > + * This provide a further aggregation (local clamping) which allows to track
> > + * within each bucket the exact "requested" clamp value whenever all tasks
> > + * RUNNABLE in that bucket require the same clamp.
> > + */
> > +static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
> > +				    unsigned int clamp_id)
> > +{
> > +	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> > +	unsigned int rq_clamp, bkt_clamp, tsk_clamp;
> > +
> > +	rq->uclamp[clamp_id].bucket[bucket_id].tasks++;
> > +
> > +	/*
> > +	 * Local clamping: rq's buckets always track the max "requested"
> > +	 * clamp value from all RUNNABLE tasks in that bucket.
> > +	 */
> > +	tsk_clamp = p->uclamp[clamp_id].value;
> > +	bkt_clamp = rq->uclamp[clamp_id].bucket[bucket_id].value;
> > +	rq->uclamp[clamp_id].bucket[bucket_id].value = max(bkt_clamp, tsk_clamp);
> 
> So, if I read this correct:
> 
>  - here we track a max value in a bucket,
> 
> > +	rq_clamp = READ_ONCE(rq->uclamp[clamp_id].value);
> > +	WRITE_ONCE(rq->uclamp[clamp_id].value, max(rq_clamp, tsk_clamp));
> > +}
> > +
> > +/*
> > + * When a task is dequeued from a rq, the clamp bucket reference counted by
> > + * the task is released. If this is the last task reference counting the rq's
> > + * max active clamp value, then the rq's clamp value is updated.
> > + * Both the tasks reference counter and the rq's cached clamp values are
> > + * expected to be always valid, if we detect they are not we skip the updates,
> > + * enforce a consistent state and warn.
> > + */
> > +static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
> > +				    unsigned int clamp_id)
> > +{
> > +	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> > +	unsigned int rq_clamp, bkt_clamp;
> > +
> > +	SCHED_WARN_ON(!rq->uclamp[clamp_id].bucket[bucket_id].tasks);
> > +	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> > +		rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
> > +
> > +	/*
> > +	 * Keep "local clamping" simple and accept to (possibly) overboost
> > +	 * still RUNNABLE tasks in the same bucket.
> > +	 */
> > +	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> > +		return;
> 
> (Oh man, I hope that generates semi sane code; long live CSE passes I
> suppose)

What do you mean ?

> But we never decrement that bkt_clamp value on dequeue.

We decrement the bkt_clamp value only when the bucket becomes empty
and thus we pass the condition above. That's what the comment above is
there to call out.


> > +	bkt_clamp = rq->uclamp[clamp_id].bucket[bucket_id].value;
> > +
> > +	/* The rq's clamp value is expected to always track the max */
> > +	rq_clamp = READ_ONCE(rq->uclamp[clamp_id].value);
> > +	SCHED_WARN_ON(bkt_clamp > rq_clamp);
> > +	if (bkt_clamp >= rq_clamp) {
> 
> head hurts, this reads ==, how can this ever not be so?

Never, given the current code, that's just defensive programming.

If in the future the accounting should be accidentally broken by some
refactoring we warn and fix the corrupted data structures at first
chance.

Is that so bad?

> > +		/*
> > +		 * Reset rq's clamp bucket value to its nominal value whenever
> > +		 * there are anymore RUNNABLE tasks refcounting it.
> 
> -ENOPARSE

That's related to the comment above, when you say we don't decrement
the bkt_clamp.

Because of backetization, we potentially end up tracking tasks with
different requested clamp values in the same bucket.

For example, with 20% bucket size, we can have:
  Task1: util_min=25%
  Task2: util_min=35%
accounted in the same bucket.

This ensure that while they are both running we boost 35%. If Task1
should run longer than Task2, Task1 will be "overboosted" until its
end. The bucket value will be reset to 20% (nominal value) when both
tasks are idle.


> > +		 */
> > +		rq->uclamp[clamp_id].bucket[bucket_id].value =
> > +			uclamp_bucket_value(rq_clamp);
> 
> But basically you decrement the bucket value to the nominal value.

Yes, at this point we know there are no more tasks in this bucket and
we reset its value.

> 
> > +		uclamp_rq_update(rq, clamp_id);
> > +	}
> > +}
> 
> Given all that, what is to stop the bucket value to climbing to
> uclamp_bucket_value(+1)-1 and staying there (provided there's someone
> runnable)?

Nothing... but that's an expected consequence of bucketization.

> Why are we doing this... ?

You can either decide to:

 a) always boost tasks to just the bucket nominal value
    thus always penalizing both Task1 and Task2 of the example above

 b) always boost tasks to the bucket "max" value
    thus always overboosting both Task1 and Task2 of the example above

The solution above instead has a very good property: in systems
where you have only few and well defined clamp values we always
provide the exact boost.

For example, if your system requires only 23% and 47% boost values
(totally random numbers), then you can always get the exact boost
required using just 3 bucksts or ~33% size each.

In systems where you don't know which boost values you will have, you
can still defined the maximum overboost granularity you accept for
each task by just tuning the number of clamp groups. For example, with
20 groups you can have a 5% max overboost.

-- 
#include <best/regards.h>

Patrick Bellasi
