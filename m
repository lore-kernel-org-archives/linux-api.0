From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Thu, 24 Jan 2019 16:14:43 +0000
Message-ID: <20190124161443.lv2pw5fsspyelckq@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-10-patrick.bellasi@arm.com>
 <20190123104944.GX27931@hirez.programming.kicks-ass.net>
 <20190123144011.iid3avb63r5v4r2c@e110439-lin>
 <20190123201146.GH17749@hirez.programming.kicks-ass.net>
 <20190124123009.2yulcf25ld66popd@e110439-lin>
 <20190124153106.GQ13777@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190124153106.GQ13777@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 24-Jan 16:31, Peter Zijlstra wrote:
> On Thu, Jan 24, 2019 at 12:30:09PM +0000, Patrick Bellasi wrote:
> > > So I'll have to go over the code again, but I'm wondering why you're
> > > changing uclamp_se::bucket_id on a runnable task.
> > 
> > We change only the "requested" value, not the "effective" one.
> > 
> > > Ideally you keep bucket_id invariant between enqueue and dequeue; then
> > > dequeue knows where we put it.
> > 
> > Right, that's what we do for the "effective" value.
> 
> So the problem I have is that you first introduce uclamp_se::value and
> use that all over the code, and then introduce effective and change all
> the usage sites.

Right, because the moment we introduce the combination/aggregation mechanism
is the moment "effective" value makes sense to have. That's when the
code show that:

   a task cannot always get what it "request", an "effective" value is
   computed by aggregation and that's the value we use now for actual
   clamp enforcing.

> That seems daft. Why not keep all the code as-is and add orig_value.

If you prefer, I can use effective values since the beginning and then
add the "requested" values later... but I fear the patchset will not
be more clear to parse.


> > > Now I suppose actually determining bucket_id is 'expensive' (it
> > > certainly is with the whole mapping scheme, but even that integer
> > > division is not nice), so we'd like to precompute the bucket_id.
> > 
> > Yes, although the complexity is mostly in the composition logic
> > described above not on mapping at all. We have "mapping" overheads
> > only when we change a "request" value and that's from slow-paths.
> 
> It's weird though. Esp. when combined with that mapping logic, because
> then you get to use additional maps that are not in fact ever used.

Mmm... don't get this point...

AFAICS "mapping" and "effective" are two different concepts, that's
why I can probably get rid of the first by I would prefer to keep the
second.

> > > We can update uclamp_se::value and set uclamp_se::changed, and then the
> > > next enqueue will (unlikely) test-and-clear changed and recompute the
> > > bucket_id.
> > 
> > This mean will lazy update the "requested" bucket_id by deferring its
> > computation at enqueue time. Which saves us a copy of the bucket_id,
> > i.e. we will have only the "effective" value updated at enqueue time.
> > 
> > But...
> > 
> > > Would that not be simpler?
> > 
> > ... although being simpler it does not fully exploit the slow-path,
> > a syscall which is usually running from a different process context
> > (system management software).
> > 
> > It also fits better for lazy updates but, in the cgroup case, where we
> > wanna enforce an update ASAP for RUNNABLE tasks, we will still have to
> > do the updates from the slow-path.
> > 
> > Will look better into this simplification while working on v7, perhaps
> > the linear mapping can really help in that too.
> 
> OK. So mostly my complaint is that it seems to do things odd for ill
> explained reasons.

:( I'm really sorry I'm not able to convey the overall design idea.

TBH however, despite being a quite "limited" feature it has many
different viewpoints: task-specific, cgroups and system defaults.

I've really tried my best to come up with something reasonable but I
understand that, looking at the single patches, the overall design
could be difficult to grasp... without considering that optimizations
are always possible of course.

If you like better, I can try to give a respin by just removing the
mapping part and then we go back and see if the reaming bits makes
more sense ?

-- 
#include <best/regards.h>

Patrick Bellasi
