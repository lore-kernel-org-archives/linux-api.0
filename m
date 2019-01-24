From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Thu, 24 Jan 2019 16:00:08 +0000
Message-ID: <20190124160008.x43eucgtyc62w3l3@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-10-patrick.bellasi@arm.com>
 <20190123104944.GX27931@hirez.programming.kicks-ass.net>
 <20190123144011.iid3avb63r5v4r2c@e110439-lin>
 <20190123201146.GH17749@hirez.programming.kicks-ass.net>
 <20190124123009.2yulcf25ld66popd@e110439-lin>
 <20190124123835.nliwk2onvrhe5aqf@e110439-lin>
 <20190124151212.GO13777@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190124151212.GO13777@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 24-Jan 16:12, Peter Zijlstra wrote:
> On Thu, Jan 24, 2019 at 12:38:35PM +0000, Patrick Bellasi wrote:
> > On 24-Jan 12:30, Patrick Bellasi wrote:
> > > On 23-Jan 21:11, Peter Zijlstra wrote:
> > > > On Wed, Jan 23, 2019 at 02:40:11PM +0000, Patrick Bellasi wrote:
> > > > > On 23-Jan 11:49, Peter Zijlstra wrote:
> > > > > > On Tue, Jan 15, 2019 at 10:15:06AM +0000, Patrick Bellasi wrote:
> > 
> > [...]
> > 
> > > > I'm thikning that if we haz a single bit, say:
> > > > 
> > > >   struct uclamp_se {
> > > > 	...
> > > > 	unsigned int	changed : 1;
> > > >   };
> > > > 
> > > > We can update uclamp_se::value and set uclamp_se::changed, and then the
> > > > next enqueue will (unlikely) test-and-clear changed and recompute the
> > > > bucket_id.
> > > 
> > > This mean will lazy update the "requested" bucket_id by deferring its
> > > computation at enqueue time. Which saves us a copy of the bucket_id,
> > > i.e. we will have only the "effective" value updated at enqueue time.
> > > 
> > > But...
> > > 
> > > > Would that not be simpler?
> > > 
> > > ... although being simpler it does not fully exploit the slow-path,
> > > a syscall which is usually running from a different process context
> > > (system management software).
> > > 
> > > It also fits better for lazy updates but, in the cgroup case, where we
> > > wanna enforce an update ASAP for RUNNABLE tasks, we will still have to
> > > do the updates from the slow-path.
> > > 
> > > Will look better into this simplification while working on v7, perhaps
> > > the linear mapping can really help in that too.
> > 
> > Actually, I forgot to mention that:
> > 
> >     uclamp_se::effective::{
> >         value, bucket_id
> >     }
> > 
> > will be still required to proper support the cgroup delegation model,
> > where a child group could be restricted by the parent but we want to
> > keep track of the original "requested" value for when the parent
> > should relax the restriction.
> > 
> > Thus, since effective values are already there, why not using them
> > also to pre-compute the new requested bucket_id from the slow path?
> 
> Well, we need the orig_value; but I'm still not sure why you need more
> bucket_id's. Also, retaining orig_value is already required for the
> system limits, there's nothing cgroup-y about this afaict.

Sure, the "effective" values are just a very convenient way (IMHO) to
know exactly which value/bucket_id is currently in use by a task while
keeping them well separated from the "requested" values.

So, you propose to add "orig_value"... but the end effect will be the
same... it's just that if we look at uclamp_se you have two dual
information:

 A) whatever a task or cgroup "request" is always in:

   uclamp_se::value
   uclamp_se::bucket_id

 B) whatever a task or cgroup "gets" is always in:

   uclamp_se::effective::value
   uclamp_se::effective::bucket_id

I find this partitioning useful and easy to use:

 1) the slow-path updates only data in A

 2) the fast-path updates only data in B
    by composing A data in uclamp_effective_get() @enqueue time.

-- 
#include <best/regards.h>

Patrick Bellasi
