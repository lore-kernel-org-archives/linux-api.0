From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 06/15] sched/core: uclamp: Reset uclamp values on
 RESET_ON_FORK
Date: Mon, 18 Mar 2019 12:58:44 +0000
Message-ID: <20190318125844.ajhjpaqlcgxn7qkq@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-7-patrick.bellasi@arm.com>
 <20190313205235.GX2482@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313205235.GX2482@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 21:52, Peter Zijlstra wrote:
> On Fri, Feb 08, 2019 at 10:05:45AM +0000, Patrick Bellasi wrote:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 070caa1f72eb..8b282616e9c9 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1071,7 +1071,7 @@ static void __setscheduler_uclamp(struct task_struct *p,
> >  	}
> >  }
> >  
> > -static void uclamp_fork(struct task_struct *p)
> > +static void uclamp_fork(struct task_struct *p, bool reset)
> >  {
> >  	unsigned int clamp_id;
> >  
> > @@ -1080,6 +1080,17 @@ static void uclamp_fork(struct task_struct *p)
> 
> IIRC there's an early return here if the class doesn't have uclamp
> support, which I think is wrong now. You want the reset irrespective of
> whether the class supports it, no?

Yep, actually... since in this method we are always and only resetting
certain values, it's probably better to just remove the check on class
support and unconditionally do the required ones.

> >  	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id)
> >  		p->uclamp[clamp_id].active = false;
> > +
> > +	if (likely(!reset))
> > +		return;
> > +
> > +	for (clamp_id = 0; clamp_id < UCLAMP_CNT; ++clamp_id) {
> > +		unsigned int clamp_value = uclamp_none(clamp_id);
> > +
> > +		p->uclamp[clamp_id].user_defined = false;
> > +		p->uclamp[clamp_id].value = clamp_value;
> > +		p->uclamp[clamp_id].bucket_id = uclamp_bucket_id(clamp_value);
> > +	}
> >  }
> 
> 

-- 
#include <best/regards.h>

Patrick Bellasi
