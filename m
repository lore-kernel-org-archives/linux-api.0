From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Thu, 14 Mar 2019 12:22:56 +0000
Message-ID: <20190314122256.7wb3ydswpkfmntvf@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313140925.GE5922@hirez.programming.kicks-ass.net>
 <20190313152359.lkyzel7fakjoi5hu@e110439-lin>
 <20190313194619.GR2482@worktop.programming.kicks-ass.net>
 <CAJuCfpHy0+6f9mRd+cF-oQrrUWJ4m8mOQJ7XMzkDL4mhfYyj2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpHy0+6f9mRd+cF-oQrrUWJ4m8mOQJ7XMzkDL4mhfYyj2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 14:08, Suren Baghdasaryan wrote:
> On Wed, Mar 13, 2019 at 12:46 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Wed, Mar 13, 2019 at 03:23:59PM +0000, Patrick Bellasi wrote:
> > > On 13-Mar 15:09, Peter Zijlstra wrote:
> > > > On Fri, Feb 08, 2019 at 10:05:40AM +0000, Patrick Bellasi wrote:
> >
> > > > > +static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id)
> > > > > +{
> > > > > + struct uclamp_bucket *bucket = rq->uclamp[clamp_id].bucket;
> > > > > + unsigned int max_value = uclamp_none(clamp_id);
> > > >
> > > > That's 1024 for uclamp_max
> > > >
> > > > > + unsigned int bucket_id;
> > > > > +
> > > > > + /*
> > > > > +  * Both min and max clamps are MAX aggregated, thus the topmost
> > > > > +  * bucket with some tasks defines the rq's clamp value.
> > > > > +  */
> > > > > + bucket_id = UCLAMP_BUCKETS;
> > > > > + do {
> > > > > +         --bucket_id;
> > > > > +         if (!rq->uclamp[clamp_id].bucket[bucket_id].tasks)
> > > > > +                 continue;
> > > > > +         max_value = bucket[bucket_id].value;
> > > >
> > > > but this will then _lower_ it. That's not a MAX aggregate.
> > >
> > > For uclamp_max we want max_value=1024 when there are no active tasks,
> > > which means: no max clamp enforced on CFS/RT "idle" cpus.
> > >
> > > If instead there are active RT/CFS tasks then we want the clamp value
> > > of the max group, which means: MAX aggregate active clamps.
> > >
> > > That's what the code above does and the comment says.
> >
> > That's (obviously) not how I read it... maybe something like:
> >
> > static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id)
> > {
> >         struct uclamp_bucket *bucket = rq->uclamp[clamp_id].bucket;
> >         int i;
> >
> >         /*
> >          * Since both min and max clamps are max aggregated, find the
> >          * top most bucket with tasks in.
> >          */
> >         for (i = UCLMAP_BUCKETS-1; i>=0; i--) {
> >                 if (!bucket[i].tasks)
> >                         continue;
> >                 return bucket[i].value;
> >         }
> >
> >         /* No tasks -- default clamp values */
> >         return uclamp_none(clamp_id);
> > }
> >
> > would make it clearer?
> 
> This way it's also more readable/obvious when it's used inside
> uclamp_rq_dec_id, assuming uclamp_rq_update is renamed into smth like
> get_max_rq_uclamp.

Rightm, I have now something like that:

---8<---
static inline unsigned int uclamp_rq_max_value(struct rq *rq, unsigned int clamp_id)
{
	struct uclamp_bucket *bucket = rq->uclamp[clamp_id].bucket;
	int bucket_id;

	/*
	 * Since both min and max clamps are max aggregated, find the
	 * top most bucket with tasks in.
	 */
	for (bucket_id = UCLMAP_BUCKETS-1; bucket_id >= 0; bucket_id--) {
		if (!bucket[bucket_id].tasks)
			continue;
		return bucket[bucket_id].value;
	}

	/* No tasks -- default clamp value */
	return uclamp_none(clamp_id);
}

static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
				    unsigned int clamp_id)
{
        //...
	if (bucket->value >= rq_clamp) {
		/*
		 * Reset rq's clamp bucket value to its nominal value whenever
		 * there are anymore RUNNABLE tasks refcounting it.
		 */
		bucket->value = uclamp_bucket_nominal_value(rq_clamp);
		WRITE_ONCE(uc_rq->value, uclamp_rq_max_value(rq, clamp_id));
	}
}
---8<---

-- 
#include <best/regards.h>

Patrick Bellasi
