From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 04/16] sched/core: uclamp: Add CPU's clamp buckets
 refcounting
Date: Mon, 21 Jan 2019 16:33:38 +0000
Message-ID: <20190121163337.6l7hkggicndtpzjs@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-5-patrick.bellasi@arm.com>
 <20190121145929.GI27931@hirez.programming.kicks-ass.net>
 <20190121152311.7u7bwbjopuptnzcy@e110439-lin>
 <20190121161237.GB13777@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190121161237.GB13777@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 21-Jan 17:12, Peter Zijlstra wrote:
> On Mon, Jan 21, 2019 at 03:23:11PM +0000, Patrick Bellasi wrote:
> > On 21-Jan 15:59, Peter Zijlstra wrote:
> > > On Tue, Jan 15, 2019 at 10:15:01AM +0000, Patrick Bellasi wrote:
> > > > @@ -835,6 +954,28 @@ static void uclamp_bucket_inc(struct uclamp_se *uc_se, unsigned int clamp_id,
> > > >  	} while (!atomic_long_try_cmpxchg(&uc_maps[bucket_id].adata,
> > > >  					  &uc_map_old.data, uc_map_new.data));
> > > >  
> > > > +	/*
> > > > +	 * Ensure each CPU tracks the correct value for this clamp bucket.
> > > > +	 * This initialization of per-CPU variables is required only when a
> > > > +	 * clamp value is requested for the first time from a slow-path.
> > > > +	 */
> > > 
> > > I'm confused; why is this needed?
> > 
> > That's a lazy initialization of the per-CPU uclamp data for a given
> > bucket, i.e. the clamp value assigned to a bucket, which happens only
> > when new clamp values are requested... usually only at system
> > boot/configuration time.
> > 
> > For example, let say we have these buckets mapped to given clamp
> > values:
> > 
> >  bucket_#0: clamp value: 10% (mapped)
> >  bucket_#1: clamp value: 20% (mapped)
> >  bucket_#2: clamp value: 30% (mapped)
> > 
> > and then let's assume all the users of bucket_#1 are "destroyed", i.e.
> > there are no more tasks, system defaults or cgroups asking for a
> > 20% clamp value. The corresponding bucket will become free:
> > 
> >  bucket_#0: clamp value: 10% (mapped)
> >  bucket_#1: clamp value: 20% (free)
> >  bucket_#2: clamp value: 30% (mapped)
> > 
> > If, in the future, we ask for a new clamp value, let say a task ask
> > for a 40% clamp value, then we need to map that value into a bucket.
> > Since bucket_#1 is free we can use it to fill up the hold and keep all
> > the buckets in use at the beginning of a cache line.
> > 
> > However, since now bucket_#1 tracks a different clamp value (40
> > instead of 20) we need to walk all the CPUs and updated the cached
> > value:
> > 
> >  bucket_#0: clamp value: 10% (mapped)
> >  bucket_#1: clamp value: 40% (mapped)
> >  bucket_#2: clamp value: 30% (mapped)
> > 
> > Is that more clear ?
> 
> Yes, and I realized this a little while after sending this; but I'm not
> sure I have an answer to why though.
> 
> That is; why isn't the whole thing hard coded to have:
> 
>  bucket_n: clamp value: n*UCLAMP_BUCKET_DELTA
> 
> We already do that division anyway (clamp_value / UCLAMP_BUCKET_DELTA),
> and from that we instantly have the right bucket index. And that allows
> us to initialize all this beforehand.
> 
> > and keep all
> > the buckets in use at the beginning of a cache line.
> 
> That; is that the rationale for all this? Note that per the defaults
> everything is in a single line already.

Yes, that's because of the loop in:

   dequeue_task()
     uclamp_cpu_dec()
       uclamp_cpu_dec_id()
         uclamp_cpu_update()

where buckets needs sometimes to be scanned to find a new max.

Consider also that, with mapping, we can more easily increase the
buckets count to 20 in order to have a finer clamping granularity if
needed without warring too much about performance impact especially
when we use anyway few different clamp values.

So, I agree that mapping adds (code) complexity but it can also save
few cycles in the fast path... do you think it's not worth the added
complexity?

TBH I never did a proper profiling w/-w/o mapping... I'm just worried
in principle for a loop on 20 entries spanning 4 cache lines. :/

NOTE: the loop is currently going through all the entries anyway,
      but we can add later a guard to bail out once we covered the
      number of active entries.

-- 
#include <best/regards.h>

Patrick Bellasi
