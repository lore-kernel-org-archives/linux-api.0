From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 22:25:42 +0200
Message-ID: <20160407202542.GD3448@twins.programming.kicks-ass.net>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407080833.GK3430@twins.programming.kicks-ass.net>
 <20160407194555.GI7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407194555.GI7822-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 03:45:55PM -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Thu, Apr 07, 2016 at 10:08:33AM +0200, Peter Zijlstra wrote:
> > On Thu, Apr 07, 2016 at 03:35:47AM -0400, Johannes Weiner wrote:
> > > So it was a nice cleanup for the memory controller and I believe the
> > > IO controller as well. I'd be curious how it'd be a problem for CPU?
> > 
> > The full hierarchy took years to make work and is fully ingrained with
> > how the thing words, changing it isn't going to be nice or easy.
> > 
> > So sure, go with a lowest common denominator, instead of fixing shit,
> > yay for progress :/
> 
> It's easy to get fixated on what each subsystem can do and develop
> towards different directions siloed in each subsystem.  That's what
> we've had for quite a while in cgroup.  Expectedly, this sends off
> controllers towards different directions.  Direct competion between
> tasks and child cgroups was one of the main sources of balkanization.
> 
> The balkanization was no coincidence either.  Tasks and cgroups are
> different types of entities and don't have the same control knobs or
> follow the same lifetime rules.  For absolute limits, it isn't clear
> how much of the parent's resources should be distributed to internal
> children as opposed to child cgroups.  People end up depending on
> specific implementation details and proposing one-off hacks and
> interface additions.

Yes, I'm familiar with the problem; but simply mandating leaf only nodes
is not a solution, for the very simple fact that there are tasks in the
root cgroup that cannot ever be moved out, so we _must_ be able to deal
with !leaf nodes containing tasks.

A consistent interface for absolute controllers to divvy up the
resources between local tasks and child cgroups isn't _that_ hard.

And this leaf only business totally screwed over anything proportional.

This simply cannot work.

> Proportional weights aren't much better either.  CPU has internal
> mapping between nice values and shares and treat them equally, which
> can get confusing as the configured weights behave differently
> depending on how many threads are in the parent cgroup which often is
> opaque and can't be controlled from outside.

Huh what? There's nothing confusing there, the nice to weight mapping is
static and can easily be consulted. Alternatively we can make an
interface where you can set weight through nice values, for those people
that are afraid of numbers.

But the configured weights do _not_ behave differently depending on the
number of tasks, they behave exactly as specified in the proportional
weight based rate distribution. We've done the math..

> Widely diverging from
> CPU's behavior, IO grouped all internal tasks into an internal leaf
> node and used to assign a fixed weight to it.

That's just plain broken... That is not how a proportional weight based
hierarchical controller works.

> Now, you might think that none of it matters and each subsystem
> treating cgroup hierarchy as arbitrary and orthogonal collections of
> bean counters is fine; however, that makes it impossible to account
> for and control operations which span different types of resources.
> This prevented us from implementing resource control over frigging
> buffered writes, making the whole IO control thing a joke.  While CPU
> currently doesn't directly tie into it, that is only because CPU
> cycles spent during writeback isn't yet properly accounted.

CPU cycles spend in waitqueues aren't properly accounted to whoever
queued the job either, and there's a metric ton of async stuff that's
not properly accounted, so what?

> However, please understand that there are a lot of use cases where
> comprehensive and consistent resource accounting and control over all
> major resources is useful and necessary.

Maybe, but so far I've only heard people complain this v2 thing didn't
work for them, and as far as I can see the whole v2 model is internally
inconsistent and impossible to implement.

The suggestion by Johannes to adjust the leaf node weight depending on
the number of tasks in is so ludicrous I don't even know where to start
enumerating the fail.
