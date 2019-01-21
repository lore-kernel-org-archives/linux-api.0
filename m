From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 05/16] sched/core: uclamp: Update CPU's refcount on
 clamp changes
Date: Mon, 21 Jan 2019 15:44:12 +0000
Message-ID: <20190121154412.fak2t2iquj3aixtu@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-6-patrick.bellasi@arm.com>
 <20190121153308.GL27931@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121153308.GL27931@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 21-Jan 16:33, Peter Zijlstra wrote:
> On Tue, Jan 15, 2019 at 10:15:02AM +0000, Patrick Bellasi wrote:
> 
> > +static inline void
> > +uclamp_task_update_active(struct task_struct *p, unsigned int clamp_id)
> > +{
> > +	struct rq_flags rf;
> > +	struct rq *rq;
> > +
> > +	/*
> > +	 * Lock the task and the CPU where the task is (or was) queued.
> > +	 *
> > +	 * We might lock the (previous) rq of a !RUNNABLE task, but that's the
> > +	 * price to pay to safely serialize util_{min,max} updates with
> > +	 * enqueues, dequeues and migration operations.
> > +	 * This is the same locking schema used by __set_cpus_allowed_ptr().
> > +	 */
> > +	rq = task_rq_lock(p, &rf);
> > +
> > +	/*
> > +	 * Setting the clamp bucket is serialized by task_rq_lock().
> > +	 * If the task is not yet RUNNABLE and its task_struct is not
> > +	 * affecting a valid clamp bucket, the next time it's enqueued,
> > +	 * it will already see the updated clamp bucket value.
> > +	 */
> > +	if (!p->uclamp[clamp_id].active)
> > +		goto done;
> > +
> > +	uclamp_cpu_dec_id(p, rq, clamp_id);
> > +	uclamp_cpu_inc_id(p, rq, clamp_id);
> > +
> > +done:
> > +	task_rq_unlock(rq, p, &rf);
> > +}
> 
> > @@ -1008,11 +1043,11 @@ static int __setscheduler_uclamp(struct task_struct *p,
> >  
> >  	mutex_lock(&uclamp_mutex);
> >  	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
> > -		uclamp_bucket_inc(&p->uclamp[UCLAMP_MIN],
> > +		uclamp_bucket_inc(p, &p->uclamp[UCLAMP_MIN],
> >  				  UCLAMP_MIN, lower_bound);
> >  	}
> >  	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MAX) {
> > -		uclamp_bucket_inc(&p->uclamp[UCLAMP_MAX],
> > +		uclamp_bucket_inc(p, &p->uclamp[UCLAMP_MAX],
> >  				  UCLAMP_MAX, upper_bound);
> >  	}
> >  	mutex_unlock(&uclamp_mutex);
> 
> 
> But.... __sched_setscheduler() actually does the whole dequeue + enqueue
> thing already ?!? See where it does __setscheduler().

This is slow-path accounting, not fast path.

There are two refcounting going on here:

  1) mapped buckets:

     clamp_value <--(M1)--> bucket_id

  2) RUNNABLE tasks:

     bucket_id <--(M2)--> RUNNABLE tasks in a bucket

What we fix here is the refcounting for the buckets mapping. If a task
does not have a task specific clamp value it does not refcount any
bucket. The moment we assign a task specific clamp value, we need to
refcount the task in the bucket corresponding to that clamp value.

This will keep the bucket in use at least as long as the task will
need that clamp value.

-- 
#include <best/regards.h>

Patrick Bellasi
