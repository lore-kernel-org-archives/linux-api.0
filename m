From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 05/16] sched/core: uclamp: Update CPU's refcount on
 clamp changes
Date: Thu, 24 Jan 2019 13:38:14 +0100
Message-ID: <20190124123814.GM13777@hirez.programming.kicks-ass.net>
References: <20190122093704.GM27931@hirez.programming.kicks-ass.net>
 <20190122104305.6vjx37muqsxm536t@e110439-lin>
 <20190122132817.GG13777@hirez.programming.kicks-ass.net>
 <20190122140115.twtx646vewm757ca@e110439-lin>
 <20190122145742.GQ27931@hirez.programming.kicks-ass.net>
 <20190122153315.dhjl67sgpu74hmqv@e110439-lin>
 <20190123091634.GT27931@hirez.programming.kicks-ass.net>
 <20190123141426.5samtr4hl6okdypu@e110439-lin>
 <20190123185940.GF17749@hirez.programming.kicks-ass.net>
 <20190124112153.pwdsbxjynq6chmvl@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190124112153.pwdsbxjynq6chmvl@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 24, 2019 at 11:21:53AM +0000, Patrick Bellasi wrote:

> When a task-specific uclamp value is changed for a task, instead, a
> dequeue/enqueue is not needed. As long as we are doing a lazy update,
> that sounds just like not necessary overhead.

When that overhead is shown to be a problem, is when we'll look at that
:-)

> However, there could still be value in keeping code consistent and if
> you prefer it this way what should I do?
> 
> ---8<---
>     __sched_setscheduler()
>         ...
>         if (policy < 0)
>             policy = oldpolicy = p->policy;
>         ...
>         if (unlikely(policy == p->policy)) {
>             ...
>             if (uclamp_changed())         // Force dequeue/enqueue
>                 goto change;
>         }
>     change:
>         ...
> 
>         if (queued)
> 	    dequeue_task(rq, p, queue_flags);
> 	if (running)
> 	    put_prev_task(rq, p);
> 
>         __setscheduler_uclamp();
> 	__setscheduler(rq, p, attr, pi);
> 
> 	if (queued)
> 	    enqueue_task(rq, p, queue_flags);
> 	if (running)
> 	    set_curr_task(rq, p);
>         ...
> ---8<---
> 
> Could be something like that ok with you?

Yes, that's about what I was expecting.

> Not sure about side-effects on p->prio(): for CFS seems to be reset to
> NORMAL in this case :/

That's what we need KEEP_PARAM for, right?
