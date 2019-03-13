From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Wed, 13 Mar 2019 16:12:29 +0000
Message-ID: <20190313161229.pkib2tmjass5chtb@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313134022.GB5922@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313134022.GB5922@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 14:40, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:40AM +0000, Patrick Bellasi wrote:
> > +static inline unsigned int uclamp_bucket_id(unsigned int clamp_value)
> > +{
> > +	return clamp_value / UCLAMP_BUCKET_DELTA;
> > +}
> > +
> > +static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
> > +{
> > +	return UCLAMP_BUCKET_DELTA * uclamp_bucket_id(clamp_value);
> 
> 	return clamp_value - (clamp_value % UCLAMP_BUCKET_DELTA);
> 
> might generate better code; just a single division, instead of a div and
> mult.

Wondering if compilers cannot do these optimizations... but yes, looks
cool and will do it in v8, thanks.

> > +}
> > +
> > +static inline unsigned int uclamp_none(int clamp_id)
> > +{
> > +	if (clamp_id == UCLAMP_MIN)
> > +		return 0;
> > +	return SCHED_CAPACITY_SCALE;
> > +}
> > +
> > +static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id)
> > +{
> > +	struct uclamp_bucket *bucket = rq->uclamp[clamp_id].bucket;
> > +	unsigned int max_value = uclamp_none(clamp_id);
> > +	unsigned int bucket_id;
> > +
> > +	/*
> > +	 * Both min and max clamps are MAX aggregated, thus the topmost
> > +	 * bucket with some tasks defines the rq's clamp value.
> > +	 */
> > +	bucket_id = UCLAMP_BUCKETS;
> > +	do {
> > +		--bucket_id;
> > +		if (!rq->uclamp[clamp_id].bucket[bucket_id].tasks)
> > +			continue;
> > +		max_value = bucket[bucket_id].value;
> > +		break;
> 
> If you flip the if condition the code will be nicer.
> 
> > +	} while (bucket_id);
> 
> But you can also use a for loop:
> 
> 	for (i = UCLAMP_BUCKETS-1; i>=0; i--) {
> 		if (rq->uclamp[clamp_id].bucket[i].tasks) {
> 			max_value = bucket[i].value;
> 			break;
> 		}
> 	}

Yes, the for looks better, but perhaps like that:

	unsigned int bucket_id = UCLAMP_BUCKETS;

 	/*
 	 * Both min and max clamps are MAX aggregated, thus the topmost
 	 * bucket with some tasks defines the rq's clamp value.
 	 */
	for (; bucket_id >= 0; --bucket_id) {
		if (!bucket[bucket_id].tasks)
			continue;
		max_value = bucket[bucket_id].value;
		break;
	}

... just to save a {} block.


> > +	WRITE_ONCE(rq->uclamp[clamp_id].value, max_value);
> > +}

-- 
#include <best/regards.h>

Patrick Bellasi
