From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v7 01/15] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Thu, 14 Mar 2019 11:18:49 +0000
Message-ID: <20190314111849.gx6bl6myfjtaan7r@e110439-lin>
References: <20190208100554.32196-1-patrick.bellasi@arm.com>
 <20190208100554.32196-2-patrick.bellasi@arm.com>
 <20190313135238.GC5922@hirez.programming.kicks-ass.net>
 <20190313155954.jse2tyn5iqxm6wle@e110439-lin>
 <20190313193916.GQ2482@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190313193916.GQ2482@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 13-Mar 20:39, Peter Zijlstra wrote:
> On Wed, Mar 13, 2019 at 03:59:54PM +0000, Patrick Bellasi wrote:
> > On 13-Mar 14:52, Peter Zijlstra wrote:
> 
> > Because of backetization, we potentially end up tracking tasks with
> > different requested clamp values in the same bucket.
> > 
> > For example, with 20% bucket size, we can have:
> >   Task1: util_min=25%
> >   Task2: util_min=35%
> > accounted in the same bucket.
> 
> > > Given all that, what is to stop the bucket value to climbing to
> > > uclamp_bucket_value(+1)-1 and staying there (provided there's someone
> > > runnable)?
> > 
> > Nothing... but that's an expected consequence of bucketization.
> 
> No, it is not.
> 
> > > Why are we doing this... ?
> > 
> > You can either decide to:
> > 
> >  a) always boost tasks to just the bucket nominal value
> >     thus always penalizing both Task1 and Task2 of the example above
> 
> This is the expected behaviour. When was the last time your histogram
> did something like b?

Right, I see what you mean... strictly speaking histograms always do a
floor aggregation.

> >  b) always boost tasks to the bucket "max" value
> >     thus always overboosting both Task1 and Task2 of the example above
> > 
> > The solution above instead has a very good property: in systems
> > where you have only few and well defined clamp values we always
> > provide the exact boost.
> > 
> > For example, if your system requires only 23% and 47% boost values
> > (totally random numbers), then you can always get the exact boost
> > required using just 3 bucksts or ~33% size each.
> > 
> > In systems where you don't know which boost values you will have, you
> > can still defined the maximum overboost granularity you accept for
> > each task by just tuning the number of clamp groups. For example, with
> > 20 groups you can have a 5% max overboost.
> 
> Maybe, but this is not a direct concequence of buckets, but an
> additional heuristic that might work well in this case.

Right... that's the point.

We started with mapping to be able to track exact clamp values.
Then we switched to linear mapping to remove the complexity of
mapping, but we would like to still have the possibility to track
exact numbers whenever possible.

> Maybe split this out in a separate patch? So start with the trivial
> bucket, and then do this change on top with the above few paragraphs as
> changelog?

That's doable, otherwise maybe we can just add the above paragraphs to
the changelog of this patch. But give your comment above I assume you
prefer to split it out... just let me know otherwise.


-- 
#include <best/regards.h>

Patrick Bellasi
