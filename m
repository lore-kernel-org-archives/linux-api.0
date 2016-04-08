From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Fri, 8 Apr 2016 16:11:35 -0400
Message-ID: <20160408201135.GO24661@htj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407080833.GK3430@twins.programming.kicks-ass.net>
 <20160407194555.GI7822@mtj.duckdns.org>
 <20160407202542.GD3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407202542.GD3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Peter.

On Thu, Apr 07, 2016 at 10:25:42PM +0200, Peter Zijlstra wrote:
> > The balkanization was no coincidence either.  Tasks and cgroups are
> > different types of entities and don't have the same control knobs or
> > follow the same lifetime rules.  For absolute limits, it isn't clear
> > how much of the parent's resources should be distributed to internal
> > children as opposed to child cgroups.  People end up depending on
> > specific implementation details and proposing one-off hacks and
> > interface additions.
> 
> Yes, I'm familiar with the problem; but simply mandating leaf only nodes
> is not a solution, for the very simple fact that there are tasks in the
> root cgroup that cannot ever be moved out, so we _must_ be able to deal
> with !leaf nodes containing tasks.

As Johannes already pointed out, the root cgroup has always been
special.  While pure practicality, performance implications and
implementation convenience do play important roles in the special
treatment, another constributing aspect is avoiding exposing
statistics and control knobs which are duplicates of and/or
conflicting with what's already available at the system level.  It's
never fun to have multiple sources of truth.

> A consistent interface for absolute controllers to divvy up the
> resources between local tasks and child cgroups isn't _that_ hard.

I've spent months thinking about it and didn't get too far.  If you
have a good solution, I'd be happy to be enlightened.  Also, please
note that the current solution is based on restricting certain
configurations.  If we can find a better solution, we can relax the
relevant constraints and move onto it without breaking compatibility.

> And this leaf only business totally screwed over anything proportional.
> 
> This simply cannot work.

Will get to this below.

> > Proportional weights aren't much better either.  CPU has internal
> > mapping between nice values and shares and treat them equally, which
> > can get confusing as the configured weights behave differently
> > depending on how many threads are in the parent cgroup which often is
> > opaque and can't be controlled from outside.
> 
> Huh what? There's nothing confusing there, the nice to weight mapping is
> static and can easily be consulted. Alternatively we can make an
> interface where you can set weight through nice values, for those people
> that are afraid of numbers.
>
> But the configured weights do _not_ behave differently depending on the
> number of tasks, they behave exactly as specified in the proportional
> weight based rate distribution. We've done the math..

Yes, once one understands what's going on, it isn't confusing.  It's
just not something users can intuitively understand from the presented
interface.  The confusion of course is worsened severely by different
controller behaviors.

> > Widely diverging from
> > CPU's behavior, IO grouped all internal tasks into an internal leaf
> > node and used to assign a fixed weight to it.
> 
> That's just plain broken... That is not how a proportional weight based
> hierarchical controller works.

That's a strong statement.  When the hierarchy is composed of
equivalent objects as in CPU, not distinguishing internal and leaf
nodes would be a more natural way to organize; however, it isn't
necessarily true in all cases.  For example, while a writeback IO
would be issued by some task, the task itself might not have done
anything to cause that IO and the IO would essentially be anonymous in
the resource domain.  Also, different controllers use different units
of organization - CPU sees threads, IO sees IO contexts which are
usually shared in a process.  The difference would lead to differing
scaling behaviors in proportional distribution.

While the separate buckets and entities model may not be as elegant as
tree of uniform objects, it is far from uncommon and more robust when
dealing with different types of objects.

> > Now, you might think that none of it matters and each subsystem
> > treating cgroup hierarchy as arbitrary and orthogonal collections of
> > bean counters is fine; however, that makes it impossible to account
> > for and control operations which span different types of resources.
> > This prevented us from implementing resource control over frigging
> > buffered writes, making the whole IO control thing a joke.  While CPU
> > currently doesn't directly tie into it, that is only because CPU
> > cycles spent during writeback isn't yet properly accounted.
> 
> CPU cycles spend in waitqueues aren't properly accounted to whoever
> queued the job either, and there's a metric ton of async stuff that's
> not properly accounted, so what?

The ultimate goal of cgroup resource control is accounting and
controlling all significant resource consumptions as configured.  Some
system operations are inherently global and others are simply too
cheap to justify the overhead; however, there still are significant
aggregate operations which are being missed out including almost
everything taking place in the writeback path.  So, yes, we eventually
want to be able to account for them, of course in a way which doesn't
get in the way of actual operation.

> > However, please understand that there are a lot of use cases where
> > comprehensive and consistent resource accounting and control over all
> > major resources is useful and necessary.
> 
> Maybe, but so far I've only heard people complain this v2 thing didn't
> work for them, and as far as I can see the whole v2 model is internally
> inconsistent and impossible to implement.

I suppose we live in different bubbles.  Can you please elaborate
which parts of cgroup v2 model are internally inconsistent and
impossible to implement?  I'd be happy to rectify the situation.

> The suggestion by Johannes to adjust the leaf node weight depending on
> the number of tasks in is so ludicrous I don't even know where to start
> enumerating the fail.

That sounds like a pretty uncharitable way to read his message.  I
think he was trying to find out the underlying requirements so that a
way forward can be discussed.  I do have the same question.  It's
difficult to have discussions about trade-offs without knowing where
the requirements are coming from.  Do you have something on mind for
cases where internal tasks have to compete with sibling cgroups?

Thanks.

-- 
tejun
