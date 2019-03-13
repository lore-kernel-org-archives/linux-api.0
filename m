From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 03/15] sched/core: uclamp: Add system default clamps
Date: Wed, 13 Mar 2019 21:10:10 +0100
Message-ID: <20190313201010.GU2482@worktop.programming.kicks-ass.net>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-4-patrick.bellasi@arm.com>
 <20190313143240.GH5922@hirez.programming.kicks-ass.net>
 <20190313170940.ngiafkmiijryhl2k@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313170940.ngiafkmiijryhl2k@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 13, 2019 at 05:09:40PM +0000, Patrick Bellasi wrote:

> Yes, that should be possible... will look into splitting this out in
> v8 to have something like:
> 
> ---8<---
> struct uclamp_req {
> 	/* Clamp value "requested" by a scheduling entity */
> 	unsigned int value		: bits_per(SCHED_CAPACITY_SCALE);
> 	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
> 	unsigned int active		: 1;
> 	unsigned int user_defined	: 1;
> }
> 
> struct uclamp_eff {
> 	unsigned int value	        : bits_per(SCHED_CAPACITY_SCALE);
> 	unsigned int bucket_id	        : bits_per(UCLAMP_BUCKETS);
> }

No, have _1_ type. There is no point what so ever to splitting this.

Also, what's @user_defined about, I don't think I've seen that in the
parent patch.

> struct task_struct {
>         // ...
>         #ifdef CONFIG_UCLAMP_TASK
>                 struct uclamp_req uclamp_req[UCLAMP_CNT];
>                 struct uclamp_eff uclamp_eff[UCLAMP_CNT];

		struct uclamp_se uclamp[UCLAMP_CNT];
		struct uclamp_se uclamp_req[UCLAMP_CNT];

Where the first is the very same introduced in patch #1, and leaving it
in place avoids having to update the sites already using that (or start
#1 with the _eff name to avoid having to change things around?).

>         #endif
>         // ...
> }
> 
> static inline struct uclamp_eff
> uclamp_eff_get(struct task_struct *p, unsigned int clamp_id)
> {
>         struct uclamp_eff uc_eff = p->uclamp_eff[clamp_id];

just this ^, these lines seem like a superfluous duplication:

> 	uc_eff.bucket_id = p->uclamp_req[clamp_id].bucket_id;
> 	uc_eff.value = p->uclamp_req[clamp_id].value;


> 	if (unlikely(uc_eff.clamp_value > uclamp_default[clamp_id].value)) {
> 		uc_eff.clamp_value = uclamp_default[clamp_id].value;
> 		uc_eff.bucket_id = uclamp_default[clamp_id].bucket_id;

and:

		uc = uclamp_default[clamp_id];

> 	}
> 
>         return uc_eff;
> }
> 
> static inline void
> uclamp_eff_set(struct task_struct *p, unsigned int clamp_id)
> {
>         p->uclamp_eff[clamp_id] = uclamp_eff_get(p, clamp_id);
> }
> ---8<---
> 
> Is that what you mean ?

Getting there :-)
