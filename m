From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Thu, 14 Mar 2019 15:00:48 +0000
Message-ID: <20190314150048.td6o3g7ucb7fg2yy@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <21171fa0-7fd5-ebbf-dd48-d6668ed563af@arm.com>
 <20190313151535.q5ivsuywvwkewrk5@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313151535.q5ivsuywvwkewrk5@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 15:15, Patrick Bellasi wrote:
> On 12-Mar 13:52, Dietmar Eggemann wrote:
> > On 2/8/19 11:05 AM, Patrick Bellasi wrote:

[...]

> > > + * within each bucket the exact "requested" clamp value whenever all tasks
> > > + * RUNNABLE in that bucket require the same clamp.
> > > + */
> > > +static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
> > > +				    unsigned int clamp_id)
> > > +{
> > > +	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> > > +	unsigned int rq_clamp, bkt_clamp, tsk_clamp;
> > 
> > Wouldn't it be easier to have a pointer to the task's and rq's uclamp
> > structure as well to the bucket?
> > 
> > -       unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> > +       struct uclamp_se *uc_se = &p->uclamp[clamp_id];
> > +       struct uclamp_rq *uc_rq = &rq->uclamp[clamp_id];
> > +       struct uclamp_bucket *bucket = &uc_rq->bucket[uc_se->bucket_id];
> 
> I think I went back/forth a couple of times in using pointer or the
> extended version, which both have pros and cons.
> 
> I personally prefer the pointers as you suggest but I've got the
> impression in the past that since everybody cleared "basic C trainings"
> it's not so difficult to read the code above too.
> 
> > The code in uclamp_rq_inc_id() and uclamp_rq_dec_id() for example becomes
> > much more readable.
> 
> Agree... let's try to switch once again in v8 and see ;)

This is not as straightforward as I thought.

We either still need local variables to use with max(), which does not
play well with bitfields values, or we have to avoid using it and go
back to conditional updates:

---8<---
static inline void uclamp_rq_inc_id(struct task_struct *p, struct rq *rq,
				    unsigned int clamp_id)
{
	struct uclamp_rq *uc_rq = &rq->uclamp[clamp_id];
	struct uclamp_req *uc_se = &p->uclamp_se[clamp_id];
	struct uclamp_bucket *bucket = &uc_rq->bucket[uc_se->bucket_id];

	bucket->tasks++;

	/*
	 * Local clamping: rq's buckets always track the max "requested"
	 * clamp value from all RUNNABLE tasks in that bucket.
	 */
	if (uc_se->value > bucket->value)
		bucket->value = uc_se->value;

	if (uc_se->value > READ_ONCE(uc_rq->value))
		WRITE_ONCE(uc_rq->value, uc_se->value);
}
---8<---

I remember Peter asking for max() in one of the past reviews.. but the
code above looks simpler to me too... let see if this time it can be
accepted. :)

-- 
#include <best/regards.h>

Patrick Bellasi
