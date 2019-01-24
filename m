From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v6 09/16] sched/cpufreq: uclamp: Add utilization clamping
 for RT tasks
Date: Thu, 24 Jan 2019 12:30:09 +0000
Message-ID: <20190124123009.2yulcf25ld66popd@e110439-lin>
References: <20190115101513.2822-1-patrick.bellasi@arm.com>
 <20190115101513.2822-10-patrick.bellasi@arm.com>
 <20190123104944.GX27931@hirez.programming.kicks-ass.net>
 <20190123144011.iid3avb63r5v4r2c@e110439-lin>
 <20190123201146.GH17749@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190123201146.GH17749@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>
List-Id: linux-api@vger.kernel.org

On 23-Jan 21:11, Peter Zijlstra wrote:
> On Wed, Jan 23, 2019 at 02:40:11PM +0000, Patrick Bellasi wrote:
> > On 23-Jan 11:49, Peter Zijlstra wrote:
> > > On Tue, Jan 15, 2019 at 10:15:06AM +0000, Patrick Bellasi wrote:
> > > > @@ -858,16 +859,23 @@ static inline void
> > > >  uclamp_effective_get(struct task_struct *p, unsigned int clamp_id,
> > > >  		     unsigned int *clamp_value, unsigned int *bucket_id)
> > > >  {
> > > > +	struct uclamp_se *default_clamp;
> > > > +
> > > >  	/* Task specific clamp value */
> > > >  	*clamp_value = p->uclamp[clamp_id].value;
> > > >  	*bucket_id = p->uclamp[clamp_id].bucket_id;
> > > >  
> > > > +	/* RT tasks have different default values */
> > > > +	default_clamp = task_has_rt_policy(p)
> > > > +		? uclamp_default_perf
> > > > +		: uclamp_default;
> > > > +
> > > >  	/* System default restriction */
> > > > -	if (unlikely(*clamp_value < uclamp_default[UCLAMP_MIN].value ||
> > > > -		     *clamp_value > uclamp_default[UCLAMP_MAX].value)) {
> > > > +	if (unlikely(*clamp_value < default_clamp[UCLAMP_MIN].value ||
> > > > +		     *clamp_value > default_clamp[UCLAMP_MAX].value)) {
> > > >  		/* Keep it simple: unconditionally enforce system defaults */
> > > > -		*clamp_value = uclamp_default[clamp_id].value;
> > > > -		*bucket_id = uclamp_default[clamp_id].bucket_id;
> > > > +		*clamp_value = default_clamp[clamp_id].value;
> > > > +		*bucket_id = default_clamp[clamp_id].bucket_id;
> > > >  	}
> > > >  }
> > > 
> > > So I still don't much like the whole effective thing;
> > 
> > :/
> > 
> > I find back-annotation useful in many cases since we have different
> > sources for possible clamp values:
> > 
> >  1. task specific
> >  2. cgroup defined
> >  3. system defaults
> >  4. system power default
> 
> (I'm not sure I've seen 4 happen yet, what's that?)

Typo: that's "system s/power/perf/ default", i.e. uclamp_default_perf
introduced by this patch.

> Anyway, once you get range composition defined; that should be something
> like:
> 
> 	R_p \Compose_g R_g
> 
> Where R_p is the range of task-p, and R_g is the range of the g'th
> cgroup of p (where you can make an identity between the root cgroup and
> the system default).
> 
> Now; as per the other email; I think the straight forward composition:
> 
> struct range compose(struct range a, struct range b)
> {
> 	return (range){.min = clamp(a.min, b.min, b.max),
> 	               .max = clamp(a.max, b.min, b.max), };
> }

This composition is done in uclamp_effective_get() but it's
slightly different, since we want to support a "nice policy" where
tasks can always ask less then what they have got assigned.

Thus, from an abstract standpoint, if a task is in a cgroup:

     task.min <= R_g.min
     task.max <= R_g.max

While, for tasks in the root cgroup system default applies and we
enforece:

     task.min >= R_0.min
     task.max <= R_0.max

... where the "nice policy" is currently not more supported, but
perhaps we can/should use the same for system defaults too.

> (note that this is non-commutative, so we have to pay attention to
> get the order 'right')
> 
> Works in this case; unlike the cpu/rq conposition where we resort to a
> pure max function for non-interference.

Right.

> > I don't think we can avoid to somehow back annotate on which bucket a
> > task has been refcounted... it makes dequeue so much easier, it helps
> > in ensuring that the refcouning is consistent and enable lazy updates.
> 
> So I'll have to go over the code again, but I'm wondering why you're
> changing uclamp_se::bucket_id on a runnable task.

We change only the "requested" value, not the "effective" one.

> Ideally you keep bucket_id invariant between enqueue and dequeue; then
> dequeue knows where we put it.

Right, that's what we do for the "effective" value.

> Now I suppose actually determining bucket_id is 'expensive' (it
> certainly is with the whole mapping scheme, but even that integer
> division is not nice), so we'd like to precompute the bucket_id.

Yes, although the complexity is mostly in the composition logic
described above not on mapping at all. We have "mapping" overheads
only when we change a "request" value and that's from slow-paths.

The "effective" value is computed at each enqueue time by composing
precomputed bucket_id representing the current "requested" task's,
cgroup's and system default's values.

> This then leads to the problem of how to change uclamp_se::value while
> runnable (since per the other thread you don't want to always update all
> runnable tasks).
> 
> So far so right?

Yes.

> I'm thikning that if we haz a single bit, say:
> 
>   struct uclamp_se {
> 	...
> 	unsigned int	changed : 1;
>   };
> 
> We can update uclamp_se::value and set uclamp_se::changed, and then the
> next enqueue will (unlikely) test-and-clear changed and recompute the
> bucket_id.

This mean will lazy update the "requested" bucket_id by deferring its
computation at enqueue time. Which saves us a copy of the bucket_id,
i.e. we will have only the "effective" value updated at enqueue time.

But...

> Would that not be simpler?

... although being simpler it does not fully exploit the slow-path,
a syscall which is usually running from a different process context
(system management software).

It also fits better for lazy updates but, in the cgroup case, where we
wanna enforce an update ASAP for RUNNABLE tasks, we will still have to
do the updates from the slow-path.

Will look better into this simplification while working on v7, perhaps
the linear mapping can really help in that too.

Cheers Patrick

-- 
#include <best/regards.h>

Patrick Bellasi
