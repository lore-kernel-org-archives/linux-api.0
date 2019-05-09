From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 05/16] sched/core: Allow sched_setattr() to use the
 current policy
Date: Thu, 9 May 2019 13:55:17 +0200
Message-ID: <20190509115517.GT2623@hirez.programming.kicks-ass.net>
References: <20190402104153.25404-1-patrick.bellasi@arm.com>
 <20190402104153.25404-6-patrick.bellasi@arm.com>
 <20190508192131.GD32547@worktop.programming.kicks-ass.net>
 <20190509091807.7d3iykkn3oj4b737@e110439-lin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190509091807.7d3iykkn3oj4b737@e110439-lin>
Sender: linux-kernel-owner@vger.kernel.org
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 09, 2019 at 10:18:07AM +0100, Patrick Bellasi wrote:
> On 08-May 21:21, Peter Zijlstra wrote:
> > On Tue, Apr 02, 2019 at 11:41:41AM +0100, Patrick Bellasi wrote:
> > > diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> > > index 22627f80063e..075c610adf45 100644
> > > --- a/include/uapi/linux/sched.h
> > > +++ b/include/uapi/linux/sched.h
> > > @@ -40,6 +40,8 @@
> > >  /* SCHED_ISO: reserved but not implemented yet */
> > >  #define SCHED_IDLE		5
> > >  #define SCHED_DEADLINE		6
> > > +/* Must be the last entry: used to sanity check attr.policy values */
> > > +#define SCHED_POLICY_MAX	SCHED_DEADLINE
> > 
> > This is a wee bit sad to put in a uapi header; but yeah, where else :/
> > 
> > Another option would be something like:
> > 
> > enum {
> > 	SCHED_NORMAL = 0,
> > 	SCHED_FIFO = 1,
> > 	SCHED_RR = 2,
> > 	SCHED_BATCH = 3,
> > 	/* SCHED_ISO = 4, reserved */
> > 	SCHED_IDLE = 5,
> > 	SCHED_DEADLINE = 6,
> > 	SCHED_POLICY_NR
> > };
> 
> I just wanted to minimize the changes by keeping the same structure...
> If you prefer the above I can add a refactoring patch just to update
> existing definitions before adding this patch...

Right; I've no idea really. The thing that started all this was adding
that define to UAPI. Maybe we can do without it and instead put in a
comment to check sched_setattr() any time we add a new policy and just
hard code the thing.
