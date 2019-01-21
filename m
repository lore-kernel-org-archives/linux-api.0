From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 04/16] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Mon, 21 Jan 2019 15:23:11 +0000
Message-ID: <20190121152311.7u7bwbjopuptnzcy@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-5-patrick.bellasi@arm.com>
 <20190121145929.GI27931@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121145929.GI27931@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 21-Jan 15:59, Peter Zijlstra wrote:
> On Tue, Jan 15, 2019 at 10:15:01AM +0000, Patrick Bellasi wrote:
> > @@ -835,6 +954,28 @@ static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
> >  	} while (!atomic_long_try_cmpxchg(&uc_maps[bucket_id].adata,
> >  					  &uc_map_old.data, uc_map_new.data));
> >  
> > +	/*
> > +	 * Ensure each CPU tracks the correct value for this clamp bucket.
> > +	 * This initialization of per-CPU variables is required only when a
> > +	 * clamp value is requested for the first time from a slow-path.
> > +	 */
> 
> I'm confused; why is this needed?

That's a lazy initialization of the per-CPU uclamp data for a given
bucket, i.e. the clamp value assigned to a bucket, which happens only
when new clamp values are requested... usually only at system
boot/configuration time.

For example, let say we have these buckets mapped to given clamp
values:

 bucket_#0: clamp value: 10% (mapped)
 bucket_#1: clamp value: 20% (mapped)
 bucket_#2: clamp value: 30% (mapped)

and then let's assume all the users of bucket_#1 are "destroyed", i.e.
there are no more tasks, system defaults or cgroups asking for a
20% clamp value. The corresponding bucket will become free:

 bucket_#0: clamp value: 10% (mapped)
 bucket_#1: clamp value: 20% (free)
 bucket_#2: clamp value: 30% (mapped)

If, in the future, we ask for a new clamp value, let say a task ask
for a 40% clamp value, then we need to map that value into a bucket.
Since bucket_#1 is free we can use it to fill up the hold and keep all
the buckets in use at the beginning of a cache line.

However, since now bucket_#1 tracks a different clamp value (40
instead of 20) we need to walk all the CPUs and updated the cached
value:

 bucket_#0: clamp value: 10% (mapped)
 bucket_#1: clamp value: 40% (mapped)
 bucket_#2: clamp value: 30% (mapped)

Is that more clear ?


In the following code:

> 
> > +	if (unlikely(!uc_map_old.se_count)) {

            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This condition is matched by clamp buckets which needs the
initialization described above. These are buckets without a client so
fare and that have been selected to map/track a new clamp value.
That's why we have an unlikely... quite likely tasks/cgroups will keep
asking for the same (limited number of) clamp values and thus we find
a bucket already properly initialized for them.


> > +		for_each_possible_cpu(cpu) {
> > +			struct uclamp_cpu *uc_cpu =
> > +				&cpu_rq(cpu)->uclamp[clamp_id];
> > +
> > +			/* CPU's tasks count must be 0 for free buckets */
> > +			SCHED_WARN_ON(uc_cpu->bucket[bucket_id].tasks);
> > +			if (unlikely(uc_cpu->bucket[bucket_id].tasks))
> > +				uc_cpu->bucket[bucket_id].tasks = 0;

That's a safety check, we expect that (free) buckets do not refcount
any task. That's one of the conditions for a bucket to be considered
free. Here we do just a sanity check, that's because we use unlikely.
If the check matches there is a data corruption, which is reported by
the previous SCHED_WARN_ON and "fixed" by the if branch.

In my tests I have s/SCHED_WARN_ON/BUG_ON/ and never hit that bug...
thus the refcounting code should be ok and this check is there just to
be more on the safe side for future changes.

> > +
> > +			/* Minimize cache lines invalidation */
> > +			if (uc_cpu->bucket[bucket_id].value == bucket_value)
> > +				continue;

If by any chance we get a request for a new clamp value which happened
to be already used before... we can skip the initialization to avoid.

> > +			uc_cpu->bucket[bucket_id].value = bucket_value;
> > +		}
> > +	}
> > +
> >  	uc_se->value = clamp_value;
> >  	uc_se->bucket_id = bucket_id;
> >  

-- 
#include <best/regards.h>

Patrick Bellasi
