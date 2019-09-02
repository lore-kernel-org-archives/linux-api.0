From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 5/6] sched/core: uclamp: Update CPU's refcount on
 TG's clamp changes
Date: Mon, 2 Sep 2019 09:38:36 +0200
Message-ID: <20190902073836.GO2369@hirez.programming.kicks-ass.net>
References: <20190822132811.31294-1-patrick.bellasi@arm.com>
 <20190822132811.31294-6-patrick.bellasi@arm.com>
 <20190830094834.GB2369@hirez.programming.kicks-ass.net>
 <87woernqnb.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87woernqnb.fsf@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 02, 2019 at 07:44:40AM +0100, Patrick Bellasi wrote:
> On Fri, Aug 30, 2019 at 09:48:34 +0000, Peter Zijlstra wrote...
> > On Thu, Aug 22, 2019 at 02:28:10PM +0100, Patrick Bellasi wrote:

> >> +	rq = task_rq_lock(p, &rf);
> >
> > Since modifying cgroup parameters is priv only, this should be OK I
> > suppose. Priv can already DoS the system anyway.
> 
> Are you referring to the possibility to DoS the scheduler by keep
> writing cgroup attributes?

Yep.

> Because, in that case I think cgroup attributes could be written also by
> non priv users. It all depends on how they are mounted and permissions
> are set. Isn't it?
> 
> Anyway, I'm not sure we can fix that here... and in principle we could
> have that DoS by setting CPUs affinities, which is user exposed.
> Isn't it?

Only for a single task; by using the cgroup thing we have that in-kernel
iteration of tasks.

The thing I worry about is bouncing rq->lock around the system; but
yeah, I suppose a normal user could achieve something similar with
enough tasks.

> >> +	/*
> >> +	 * Setting the clamp bucket is serialized by task_rq_lock().
> >> +	 * If the task is not yet RUNNABLE and its task_struct is not
> >> +	 * affecting a valid clamp bucket, the next time it's enqueued,
> >> +	 * it will already see the updated clamp bucket value.
> >> +	 */
> >> +	if (!p->uclamp[clamp_id].active)
> >> +		goto done;
> >> +
> >> +	uclamp_rq_dec_id(rq, p, clamp_id);
> >> +	uclamp_rq_inc_id(rq, p, clamp_id);
> >> +
> >> +done:
> >
> > I'm thinking that:
> >
> > 	if (p->uclamp[clamp_id].active) {
> > 		uclamp_rq_dec_id(rq, p, clamp_id);
> > 		uclamp_rq_inc_id(rq, p, clamp_id);
> > 	}
> >
> > was too obvious? ;-)
> 
> Yep, right... I think there was some more code in prev versions but I
> forgot to get rid of that "goto" pattern after some change.

OK, already fixed that.
