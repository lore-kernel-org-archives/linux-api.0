From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v8 05/16] sched/core: Allow sched_setattr() to use the
 current policy
Date: Thu, 9 May 2019 10:18:07 +0100
Message-ID: <20190509091807.7d3iykkn3oj4b737@e110439-lin>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-6-patrick.bellasi@arm.com>
 <20190508192131.GD32547@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190508192131.GD32547@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 08-May 21:21, Peter Zijlstra wrote:
> On Tue, Apr 02, 2019 at 11:41:41AM +0100, Patrick Bellasi wrote:
> > diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> > index 22627f80063e..075c610adf45 100644
> > --- a/include/uapi/linux/sched.h
> > +++ b/include/uapi/linux/sched.h
> > @@ -40,6 +40,8 @@
> >  /* SCHED_ISO: reserved but not implemented yet */
> >  #define SCHED_IDLE		5
> >  #define SCHED_DEADLINE		6
> > +/* Must be the last entry: used to sanity check attr.policy values */
> > +#define SCHED_POLICY_MAX	SCHED_DEADLINE
> 
> This is a wee bit sad to put in a uapi header; but yeah, where else :/
> 
> Another option would be something like:
> 
> enum {
> 	SCHED_NORMAL = 0,
> 	SCHED_FIFO = 1,
> 	SCHED_RR = 2,
> 	SCHED_BATCH = 3,
> 	/* SCHED_ISO = 4, reserved */
> 	SCHED_IDLE = 5,
> 	SCHED_DEADLINE = 6,
> 	SCHED_POLICY_NR
> };

I just wanted to minimize the changes by keeping the same structure...
If you prefer the above I can add a refactoring patch just to update
existing definitions before adding this patch...

> 
> >  /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
> >  #define SCHED_RESET_ON_FORK     0x40000000
> > @@ -50,9 +52,11 @@
> >  #define SCHED_FLAG_RESET_ON_FORK	0x01
> >  #define SCHED_FLAG_RECLAIM		0x02
> >  #define SCHED_FLAG_DL_OVERRUN		0x04
> > +#define SCHED_FLAG_KEEP_POLICY		0x08
> >  
> >  #define SCHED_FLAG_ALL	(SCHED_FLAG_RESET_ON_FORK	| \
> >  			 SCHED_FLAG_RECLAIM		| \
> > -			 SCHED_FLAG_DL_OVERRUN)
> > +			 SCHED_FLAG_DL_OVERRUN		| \
> > +			 SCHED_FLAG_KEEP_POLICY)
> >  
> >  #endif /* _UAPI_LINUX_SCHED_H */
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index d368ac26b8aa..20efb32e1a7e 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4907,8 +4907,17 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
> >  	if (retval)
> >  		return retval;
> >  
> > -	if ((int)attr.sched_policy < 0)
> > +	/*
> > +	 * A valid policy is always required from userspace, unless
> > +	 * SCHED_FLAG_KEEP_POLICY is set and the current policy
> > +	 * is enforced for this call.
> > +	 */
> > +	if (attr.sched_policy > SCHED_POLICY_MAX &&
> > +	    !(attr.sched_flags & SCHED_FLAG_KEEP_POLICY)) {
> >  		return -EINVAL;
> > +	}
> 
> And given I just looked at those darn SCHED_* things, I now note the
> above does 'funny' things when passed: attr.policy=4.

... and maybe factor in the same refactoring patch a check on
SCHED_ISO being not yet supported.

> 
> > +	if (attr.sched_flags & SCHED_FLAG_KEEP_POLICY)
> > +		attr.sched_policy = SETPARAM_POLICY;
> >  
> >  	rcu_read_lock();
> >  	retval = -ESRCH;

-- 
#include <best/regards.h>

Patrick Bellasi
