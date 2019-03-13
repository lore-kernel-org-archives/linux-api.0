From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 03/15] sched/core: uclamp: Add system default clamps
Date: Wed, 13 Mar 2019 17:09:40 +0000
Message-ID: <20190313170940.ngiafkmiijryhl2k@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-4-patrick.bellasi@arm.com>
 <20190313143240.GH5922@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313143240.GH5922@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 15:32, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:42AM +0000, Patrick Bellasi wrote:
> 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 45460e7a3eee..447261cd23ba 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -584,14 +584,32 @@ struct sched_dl_entity {
> >   * Utilization clamp for a scheduling entity
> >   * @value:		clamp value "requested" by a se
> >   * @bucket_id:		clamp bucket corresponding to the "requested" value
> > + * @effective:		clamp value and bucket actually "assigned" to the se
> > + * @active:		the se is currently refcounted in a rq's bucket
> >   *
> > + * Both bucket_id and effective::bucket_id are the index of the clamp bucket
> > + * matching the corresponding clamp value which are pre-computed and stored to
> > + * avoid expensive integer divisions from the fast path.
> > + *
> > + * The active bit is set whenever a task has got an effective::value assigned,
> > + * which can be different from the user requested clamp value. This allows to
> > + * know a task is actually refcounting the rq's effective::bucket_id bucket.
> >   */
> >  struct uclamp_se {
> > +	/* Clamp value "requested" by a scheduling entity */
> >  	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
> >  	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
> > +	unsigned int active		: 1;
> > +	/*
> > +	 * Clamp value "obtained" by a scheduling entity.
> > +	 *
> > +	 * This cache the actual clamp value, possibly enforced by system
> > +	 * default clamps, a task is subject to while enqueued in a rq.
> > +	 */
> > +	struct {
> > +		unsigned int value	: bits_per(SCHED_CAPACITY_SCALE);
> > +		unsigned int bucket_id	: bits_per(UCLAMP_BUCKETS);
> > +	} effective;
> 
> I still think that this effective thing is backwards.
> 
> The existing code already used @value and @bucket_id as 'effective' and
> you're now changing all that again. This really doesn't make sense to
> me.

With respect to the previous v6, I've now moved this concept to the
patch where we actually use it for the first time.

In this patch we add system default values, thus a task is now subject
to two possible constraints: the task specific (TS) one or the system
default (SD) one.

The most restrictive of the two must be enforced but we also want to
keep track of the task specific value, while system defaults are
enforce, to restore it when the system defaults are relaxed.

For example:

  TS:   |.............. 20 .................|
  SD:   |... 0 ....|..... 40 .....|... 0 ...|
  Time: |..........|..............|.........|
        t0         t1             t2        t3

Despite the task asking always only for a 20% boost:
 - in [t1,t2] we want to boost it to 40% but, right after...
 - in [t2,t3] we want to go back to the 20% boost.

The "effective" values allows to efficiently enforce the most
restrictive clamp value for a task at enqueue time by:
 - not loosing track of the original request
 - don't caring about updating non runnable tasks

> Also; if you don't add it inside struct uclamp_se, but add a second
> instance,
> 
> >  };
> >  #endif /* CONFIG_UCLAMP_TASK */
> >  
> 
> 
> > @@ -803,6 +811,70 @@ static inline void uclamp_rq_update(struct rq *rq, unsigned int clamp_id,
> >  	WRITE_ONCE(rq->uclamp[clamp_id].value, max_value);
> >  }
> >  
> > +/*
> > + * The effective clamp bucket index of a task depends on, by increasing
> > + * priority:
> > + * - the task specific clamp value, when explicitly requested from userspace
> > + * - the system default clamp value, defined by the sysadmin
> > + *
> > + * As a side effect, update the task's effective value:
> > + *    task_struct::uclamp::effective::value
> > + * to represent the clamp value of the task effective bucket index.
> > + */
> > +static inline void
> > +uclamp_effective_get(struct task_struct *p, unsigned int clamp_id,
> > +		     unsigned int *clamp_value, unsigned int *bucket_id)
> > +{
> > +	/* Task specific clamp value */
> > +	*bucket_id = p->uclamp[clamp_id].bucket_id;
> > +	*clamp_value = p->uclamp[clamp_id].value;
> > +
> > +	/* Always apply system default restrictions */
> > +	if (unlikely(*clamp_value > uclamp_default[clamp_id].value)) {
> > +		*clamp_value = uclamp_default[clamp_id].value;
> > +		*bucket_id = uclamp_default[clamp_id].bucket_id;
> > +	}
> > +}
> 
> you can avoid horrors like this and simply return a struct uclamp_se by
> value.

Yes, that should be possible... will look into splitting this out in
v8 to have something like:

---8<---
struct uclamp_req {
	/* Clamp value "requested" by a scheduling entity */
	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
	unsigned int active		: 1;
	unsigned int user_defined	: 1;
}

struct uclamp_eff {
	unsigned int value	        : bits_per(SCHED_CAPACITY_SCALE);
	unsigned int bucket_id	        : bits_per(UCLAMP_BUCKETS);
}

struct task_struct {
        // ...
        #ifdef CONFIG_UCLAMP_TASK
                struct uclamp_req uclamp_req[UCLAMP_CNT];
                struct uclamp_eff uclamp_eff[UCLAMP_CNT];
        #endif
        // ...
}

static inline struct uclamp_eff
uclamp_eff_get(struct task_struct *p, unsigned int clamp_id)
{
        struct uclamp_eff uc_eff = p->uclamp_eff[clamp_id];

	uc_eff.bucket_id = p->uclamp_req[clamp_id].bucket_id;
	uc_eff.clamp_value = p->uclamp_req[clamp_id].value;

	if (unlikely(uc_eff.clamp_value > uclamp_default[clamp_id].value)) {
		uc_eff.clamp_value = uclamp_default[clamp_id].value;
		uc_eff.bucket_id = uclamp_default[clamp_id].bucket_id;
	}

        return uc_eff;
}

static inline void
uclamp_eff_set(struct task_struct *p, unsigned int clamp_id)
{
        p->uclamp_eff[clamp_id] = uclamp_eff_get(p, clamp_id);
}
---8<---

Is that what you mean ?

-- 
#include <best/regards.h>

Patrick Bellasi
