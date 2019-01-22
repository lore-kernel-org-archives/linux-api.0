From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 04/16] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Tue, 22 Jan 2019 10:31:07 +0000
Message-ID: <20190122103107.vulmhrucl3vtjiop@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-5-patrick.bellasi@arm.com>
 <20190121145929.GI27931@hirez.programming.kicks-ass.net>
 <20190121152311.7u7bwbjopuptnzcy@e110439-lin>
 <20190121161237.GB13777@hirez.programming.kicks-ass.net>
 <20190121163337.6l7hkggicndtpzjs@e110439-lin>
 <20190122094507.GN27931@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122094507.GN27931@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 22-Jan 10:45, Peter Zijlstra wrote:
> On Mon, Jan 21, 2019 at 04:33:38PM +0000, Patrick Bellasi wrote:
> > On 21-Jan 17:12, Peter Zijlstra wrote:
> > > On Mon, Jan 21, 2019 at 03:23:11PM +0000, Patrick Bellasi wrote:
> 
> > > > and keep all
> > > > the buckets in use at the beginning of a cache line.
> > > 
> > > That; is that the rationale for all this? Note that per the defaults
> > > everything is in a single line already.
> > 
> > Yes, that's because of the loop in:
> > 
> >    dequeue_task()
> >      uclamp_cpu_dec()
> >        uclamp_cpu_dec_id()
> >          uclamp_cpu_update()
> > 
> > where buckets needs sometimes to be scanned to find a new max.
> > 
> > Consider also that, with mapping, we can more easily increase the
> > buckets count to 20 in order to have a finer clamping granularity if
> > needed without warring too much about performance impact especially
> > when we use anyway few different clamp values.
> > 
> > So, I agree that mapping adds (code) complexity but it can also save
> > few cycles in the fast path... do you think it's not worth the added
> > complexity?
> 
> Then maybe split this out in a separate patch? Do the trivial linear
> bucket thing first and then do this smarty pants thing on top.
> 
> One problem with the scheme is that it doesn't defrag; so if you get a
> peak usage, you can still end up with only two active buckets in
> different lines.

You right, that was saved for a later optimization. :/

Mainly in consideration of the fact that, at least for the main usage
we have in mind on Android, we will likely configure all the required
clamps once for all at boot time.

> Also; if it is it's own patch, you get a much better view of the
> additional complexity and a chance to justify it ;-)

What about ditching the mapping for the time being and see if we
get a real overhead hit in the future ?

At that point we will revamp the mapping patch with also a proper
defrag support.

> Also; would it make sense to do s/cpu/rq/ on much of this? All this
> uclamp_cpu_*() stuff really is per rq and takes rq arguments, so why
> does it have cpu in the name... no strong feelings, just noticed it and
> thought is a tad inconsistent.

The idea behind using "cpu" instead of "rq" was that we use those only at
root rq level and the clamps are aggregated per-CPU.

I remember one of the first versions used "cpu" instead of "rq" as a
parameter name and you proposed to change it as an optimization since
we call it from dequeue_task() where we already have a *rq.

... but, since we have those uclamp data within struct rq, I think you
are right: it makes more sense to rename the functions.

Will do it in v7, thanks.

-- 
#include <best/regards.h>

Patrick Bellasi
