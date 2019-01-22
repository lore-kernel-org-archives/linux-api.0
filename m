From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 07/16] sched/core: uclamp: Add system default clamps
Date: Tue, 22 Jan 2019 15:41:29 +0000
Message-ID: <20190122154129.mxnpgaoxnccbjbch@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-8-patrick.bellasi@arm.com>
 <20190122135644.GP27931@hirez.programming.kicks-ass.net>
 <20190122144329.ziimv6fejwvky7yb@e110439-lin>
 <20190122151317.GH13777@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122151317.GH13777@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 22-Jan 16:13, Peter Zijlstra wrote:
> On Tue, Jan 22, 2019 at 02:43:29PM +0000, Patrick Bellasi wrote:
> > On 22-Jan 14:56, Peter Zijlstra wrote:
> > > On Tue, Jan 15, 2019 at 10:15:04AM +0000, Patrick Bellasi wrote:
> > > 
> > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > index 84294925d006..c8f391d1cdc5 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -625,6 +625,11 @@ struct uclamp_se {
> > > >  	unsigned int bucket_id		: bits_per(UCLAMP_BUCKETS);
> > > >  	unsigned int mapped		: 1;
> > > >  	unsigned int active		: 1;
> > > > +	/* Clamp bucket and value actually used by a RUNNABLE task */
> > > > +	struct {
> > > > +		unsigned int value	: bits_per(SCHED_CAPACITY_SCALE);
> > > > +		unsigned int bucket_id	: bits_per(UCLAMP_BUCKETS);
> > > > +	} effective;
> > > 
> > > I am confuzled by this thing..  so uclamp_se already has a value,bucket,
> > > which per the prior code is the effective one.
> > > 
> > > Now; I think I see why you want another value; you need the second to
> > > store the original value for when the system limits change and we must
> > > re-evaluate.
> > 
> > Yes, that's one reason, the other one being to properly support
> > CGroup when we add them in the following patches.
> > 
> > Effective will always track the value/bucket in which the task has
> > been refcounted at enqueue time and it depends on the aggregated
> > value.
> 
> > > Should you not update all tasks?
> > 
> > That's true, but that's also an expensive operation, that's why now
> > I'm doing only lazy updates at next enqueue time.
> 
> Aaah, so you refcount on the original value, which allows you to skip
> fixing up all tasks. I missed that bit.

Right, effective is always tracking the bucket we refcounted at
enqueue time.

We can still argue that, the moment we change a clamp, a task should
be updated without waiting for a dequeue/enqueue cycle.

IMO, that could be a limitation only for tasks which never sleep, but
that's a very special case.

Instead, as you'll see, in the cgroup integration we force update all
RUNNABLE tasks. Although that's expensive, since we are in the domain
of the "delegation model" and "containers resources control", there
it's probably more worth to pay than here.

> > Do you think that could be acceptable?
> 
> Think so, it's a sysctl poke, 'nobody' ever does that.

Cool, so... I'll keep lazy update for system default.

-- 
#include <best/regards.h>

Patrick Bellasi
