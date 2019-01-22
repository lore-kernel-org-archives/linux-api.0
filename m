From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 05/16] sched/core: uclamp: Update CPU's refcount on
 clamp changes
Date: Tue, 22 Jan 2019 15:57:42 +0100
Message-ID: <20190122145742.GQ27931@hirez.programming.kicks-ass.net>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-6-patrick.bellasi@arm.com>
 <20190121153308.GL27931@hirez.programming.kicks-ass.net>
 <20190121154412.fak2t2iquj3aixtu@e110439-lin>
 <20190122093704.GM27931@hirez.programming.kicks-ass.net>
 <20190122104305.6vjx37muqsxm536t@e110439-lin>
 <20190122132817.GG13777@hirez.programming.kicks-ass.net>
 <20190122140115.twtx646vewm757ca@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122140115.twtx646vewm757ca@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 22, 2019 at 02:01:15PM +0000, Patrick Bellasi wrote:
> On 22-Jan 14:28, Peter Zijlstra wrote:
> > On Tue, Jan 22, 2019 at 10:43:05AM +0000, Patrick Bellasi wrote:
> > > On 22-Jan 10:37, Peter Zijlstra wrote:
> > 
> > > > Sure, I get that. What I don't get is why you're adding that (2) here.
> > > > Like said, __sched_setscheduler() already does a dequeue/enqueue under
> > > > rq->lock, which should already take care of that.
> > > 
> > > Oh, ok... got it what you mean now.
> > > 
> > > With:
> > > 
> > >    [PATCH v6 01/16] sched/core: Allow sched_setattr() to use the current policy
> > >    <20190115101513.2822-2-patrick.bellasi@arm.com>
> > > 
> > > we can call __sched_setscheduler() with:
> > > 
> > >    attr->sched_flags & SCHED_FLAG_KEEP_POLICY
> > > 
> > > whenever we want just to change the clamp values of a task without
> > > changing its class. Thus, we can end up returning from
> > > __sched_setscheduler() without doing an actual dequeue/enqueue.
> > 
> > I don't see that happening.. when KEEP_POLICY we set attr.sched_policy =
> > SETPARAM_POLICY. That is then checked again in __setscheduler_param(),
> > which is in the middle of that dequeue/enqueue.
> 
> Yes, I think I've forgot a check before we actually dequeue the task.
> 
> The current code does:
> 
> ---8<---
>    SYSCALL_DEFINE3(sched_setattr)
> 
>         // A) request to keep the same policy
>         if (attr.sched_flags & SCHED_FLAG_KEEP_POLICY)
>             attr.sched_policy = SETPARAM_POLICY;
> 
>         sched_setattr()
>             // B) actually enforce the same policy
>             if (policy < 0)
>                 policy = oldpolicy = p->policy;
> 
>             // C) tune the clamp values
>             if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP)
>                 retval = __setscheduler_uclamp(p, attr);
> 
>             // D) tune attributes if policy is the same
>             if (unlikely(policy == p->policy))
>                 if (fair_policy(policy) && attr->sched_nice != task_nice(p))
>                     goto change;
>                 if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
>                     goto change;
>                 if (dl_policy(policy) && dl_param_changed(p, attr))
>                     goto change;

		  if (util_changed)
		      goto change;

?

>                 return 0;
>         change:
> 
>             // E) dequeue/enqueue task
> ---8<---
> 
> So, probably in D) I've missed a check on SCHED_FLAG_KEEP_POLICY to
> enforce a return in that case...
> 
> > Also, and this might be 'broken', SETPARAM_POLICY _does_ reset all the
> > other attributes, it only preserves policy, but it will (re)set nice
> > level for example (see that same function).
> 
> Mmm... right... my bad! :/
> 
> > So maybe we want to introduce another (few?) FLAG_KEEP flag(s) that
> > preserve the other bits; I'm thinking at least KEEP_PARAM and KEEP_UTIL
> > or something.
> 
> Yes, I would say we have two options:
> 
>  1) SCHED_FLAG_KEEP_POLICY enforces all the scheduling class specific
>     attributes, but cross class attributes (e.g. uclamp)
>
>  2) add SCHED_KEEP_NICE, SCHED_KEEP_PRIO, and SCED_KEEP_PARAMS
>     and use them in the if conditions in D)

So the current KEEP_POLICY basically provides sched_setparam(), and
given we have that as a syscall, that is supposedly a useful
functionality.

Also, NICE/PRIO/DL* is all the same thing and depends on the policy,
KEEP_PARAM should cover the lot

And I suppose the UTIL_CLAMP is !KEEP_UTIL; we could go either way
around with that flag.

> In both cases the goal should be to return from code block D).

I don't think so; we really do want to 'goto change' for util changes
too I think. Why duplicate part of that logic?
