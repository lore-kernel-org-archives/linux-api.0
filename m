From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Wed, 13 Mar 2019 20:30:56 +0100
Message-ID: <20190313193056.GP2482@worktop.programming.kicks-ass.net>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313135238.GC5922@hirez.programming.kicks-ass.net>
 <20190313155954.jse2tyn5iqxm6wle@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313155954.jse2tyn5iqxm6wle@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 13, 2019 at 03:59:54PM +0000, Patrick Bellasi wrote:
> On 13-Mar 14:52, Peter Zijlstra wrote:
> > > +static inline void uclamp_rq_dec_id(struct task_struct *p, struct rq *rq,
> > > +				    unsigned int clamp_id)
> > > +{
> > > +	unsigned int bucket_id = p->uclamp[clamp_id].bucket_id;
> > > +	unsigned int rq_clamp, bkt_clamp;
> > > +
> > > +	SCHED_WARN_ON(!rq->uclamp[clamp_id].bucket[bucket_id].tasks);
> > > +	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> > > +		rq->uclamp[clamp_id].bucket[bucket_id].tasks--;
> > > +
> > > +	/*
> > > +	 * Keep "local clamping" simple and accept to (possibly) overboost
> > > +	 * still RUNNABLE tasks in the same bucket.
> > > +	 */
> > > +	if (likely(rq->uclamp[clamp_id].bucket[bucket_id].tasks))
> > > +		return;
> > 
> > (Oh man, I hope that generates semi sane code; long live CSE passes I
> > suppose)
> 
> What do you mean ?

that does: 'rq->uclamp[clamp_id].bucket[bucket_id].tasks' three times in
a row. And yes the compiler _should_ dtrt, but....
