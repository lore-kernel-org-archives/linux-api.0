From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 03/16] sched/core: uclamp: Map TASK's clamp values
 into CPU's clamp buckets
Date: Mon, 21 Jan 2019 15:34:32 +0000
Message-ID: <20190121153432.vlhgxvd2otvu24st@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-4-patrick.bellasi@arm.com>
 <20190121150507.GJ27931@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121150507.GJ27931@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 21-Jan 16:05, Peter Zijlstra wrote:
> On Tue, Jan 15, 2019 at 10:15:00AM +0000, Patrick Bellasi wrote:
> > +static inline unsigned int uclamp_bucket_value(unsigned int clamp_value)
> > +{
> > +#define UCLAMP_BUCKET_DELTA (SCHED_CAPACITY_SCALE / CONFIG_UCLAMP_BUCKETS_COUNT)
> > +#define UCLAMP_BUCKET_UPPER (UCLAMP_BUCKET_DELTA * CONFIG_UCLAMP_BUCKETS_COUNT)
> > +
> > +	if (clamp_value >= UCLAMP_BUCKET_UPPER)
> > +		return SCHED_CAPACITY_SCALE;
> > +
> > +	return UCLAMP_BUCKET_DELTA * (clamp_value / UCLAMP_BUCKET_DELTA);
> > +}
> 
> > +static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
> > +			      unsigned int clamp_value)
> > +{
> > +	union uclamp_map *uc_maps = &uclamp_maps[clamp_id][0];
> > +	unsigned int prev_bucket_id = uc_se->bucket_id;
> > +	union uclamp_map uc_map_old, uc_map_new;
> > +	unsigned int free_bucket_id;
> > +	unsigned int bucket_value;
> > +	unsigned int bucket_id;
> > +
> > +	bucket_value = uclamp_bucket_value(clamp_value);
> 
> Aahh!!
> 
> So why don't you do:
> 
> 	bucket_id = clamp_value / UCLAMP_BUCKET_DELTA;
> 	bucket_value = bucket_id * UCLAMP_BUCKET_DELTA;

The mapping done here is meant to keep at the beginning of the cache
line all and only the buckets we use. Let say we have configured the
system to track 20 buckets, to have a 5% clamping resolution, but then
we use only two values at run-time, e.g. 13% and 87%.

With the mapping done here the per-CPU variables will have to consider
only 2 buckets:

 bucket_#00: clamp value: 10% (mapped)
 bucket_#01: clamp value: 85% (mapped)
 bucket_#02: (free)
 ...
 bucket_#20: (free)

While without the mapping we will have:

 bucket_#00: (free)
 bucket_#01: clamp value: 10 (mapped)
 bucket_#02: (free)
 ... big hole crossing a cache line ....
 bucket_#16: (free)
 bucket_#17: clamp value: 85 (mapped)
 bucket_#18: (free)
 ...
 bucket_#20: (free)

Addressing is simple without mapping but we can have performance
issues in the hot-path, since sometimes we need to scan all the
buckets to figure out the new max.

The mapping done here is meant to keep all the used slots at the very
beginning of a cache line to speed up that max computation when
required.

> 
> > +	do {
> > +		/* Find the bucket_id of an already mapped clamp bucket... */
> > +		free_bucket_id = UCLAMP_BUCKETS;
> > +		for (bucket_id = 0; bucket_id < UCLAMP_BUCKETS; ++bucket_id) {
> > +			uc_map_old.data = atomic_long_read(&uc_maps[bucket_id].adata);
> > +			if (free_bucket_id == UCLAMP_BUCKETS && !uc_map_old.se_count)
> > +				free_bucket_id = bucket_id;
> > +			if (uc_map_old.value == bucket_value)
> > +				break;
> > +		}
> > +
> > +		/* ... or allocate a new clamp bucket */
> > +		if (bucket_id >= UCLAMP_BUCKETS) {
> > +			/*
> > +			 * A valid clamp bucket must always be available.
> > +			 * If we cannot find one: refcounting is broken and we
> > +			 * warn once. The sched_entity will be tracked in the
> > +			 * fast-path using its previous clamp bucket, or not
> > +			 * tracked at all if not yet mapped (i.e. it's new).
> > +			 */
> > +			if (unlikely(free_bucket_id == UCLAMP_BUCKETS)) {
> > +				SCHED_WARN_ON(free_bucket_id == UCLAMP_BUCKETS);
> > +				return;
> > +			}
> > +			bucket_id = free_bucket_id;
> > +			uc_map_old.data = atomic_long_read(&uc_maps[bucket_id].adata);
> > +		}
> 
> And then skip all this?
> > +
> > +		uc_map_new.se_count = uc_map_old.se_count + 1;
> > +		uc_map_new.value = bucket_value;
> > +
> > +	} while (!atomic_long_try_cmpxchg(&uc_maps[bucket_id].adata,
> > +					  &uc_map_old.data, uc_map_new.data));
> > +
> > +	uc_se->value = clamp_value;
> > +	uc_se->bucket_id = bucket_id;
> > +
> > +	if (uc_se->mapped)
> > +		uclamp_bucket_dec(clamp_id, prev_bucket_id);
> > +
> > +	/*
> > +	 * Task's sched_entity are refcounted in the fast-path only when they
> > +	 * have got a valid clamp_bucket assigned.
> > +	 */
> > +	uc_se->mapped = true;
> > +}

-- 
#include <best/regards.h>

Patrick Bellasi
