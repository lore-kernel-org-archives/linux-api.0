From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Wed, 13 Apr 2016 09:43:01 +0200
Message-ID: <1460533381.3780.191.camel@gmail.com>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
	 <20160314113013.GM6344@twins.programming.kicks-ass.net>
	 <20160406155830.GI24661@htj.duckdns.org>
	 <20160407064549.GH3430@twins.programming.kicks-ass.net>
	 <20160407073547.GA12560@cmpxchg.org>
	 <20160407080833.GK3430@twins.programming.kicks-ass.net>
	 <20160407194555.GI7822@mtj.duckdns.org>
	 <20160407202542.GD3448@twins.programming.kicks-ass.net>
	 <20160408201135.GO24661@htj.duckdns.org>
	 <20160409133917.GV3448@twins.programming.kicks-ass.net>
	 <20160412222915.GT24661@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412222915.GT24661-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2016-04-12 at 18:29 -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Sat, Apr 09, 2016 at 03:39:17PM +0200, Peter Zijlstra wrote:
> > > While the separate buckets and entities model may not be as elegant as
> > > tree of uniform objects, it is far from uncommon and more robust when
> > > dealing with different types of objects.
> > 
> > The graph does not care about the type of objects the nodes represent,
> > and proportional weight distribution only cares about the edges.
> > 
> > With cpu-cgroup the nodes are not of uniform type either, they can be a
> > group or a task. You get runtime type identification and make it work.
> > 
> > There just isn't an excuse for crazy crap like this. Its wrong, no two
> > ways about it.
> 
> Abstracing tasks and groups as equivalent objects works well for the
> scheduler and that's great.  This is also because the domain lends
> itself very well to such simple and elegant approach.  The only
> entities of interest are tasks, as you and Mike pointed out earlier in
> the thread, and group priority can be easily mapped to task priority.
> However, this isn't necessarily the case for other controllers.
> 
> There's also the issue of mapping the model to absolute controllers.
> For the uniform model to work, there must be a way to treat internal
> and leaf entities in the same way.  For memory, the leaf entities are
> processes and applying the same model would mean that memory
> controller would have to implement equivalent per-process control
> knobs.  We don't have that.  In fact, we can't have that - a
> significant part of memory consumption can't be attached to a single
> process.  There is a fundamental distinction between internal and leaf
> nodes in the memory resource graph.
> 
> We aren't designing a spherical cow in a vacuum, and, I believe,
> should aspire to make pragmatic trade-offs of all involved factors.
> If multiple controllers co-operating on the same resource domains is
> beneficial and required, we should figure out a way to make different
> controllers agree and that way most likely will require some
> trade-offs from various controllers.
> 
> Given the currently known requirements and constraints, restricting
> internal competition is a simple and straight-forward way to isolate
> leaf node handling details of different controllers.
> 
> The cost is part aesthetical and part practical.  While less elegant
> than tree of uniform objects, it seems a stretch to call internal /
> leaf node distinction broken especially given that the model is
> natural to some controllers.

That justifies prohibiting proper usages of three controllers, cpu,
cpuacct and cpuset?
 
> The practical cost is loss of the ability to let leaf entities compete
> against groups.  However, we can't evaluate how important such
> capability is without actual use-cases.  If there are important ones,
> please bring them up, so that we can examine the actual requirements
> and try to find a good trade-off to support them.

Hm, I though Google did that, and I know I mentioned another gigabuck
sized outfit.  Whatever, ob trade-off..

Another cpuset example is something I was asked to look into recently. 
 There are folks out in the real world who want to run RT guests.  Now
VIRTUAL REALtime tickles my funny-bone, but I piddled around with it
nonetheless to see what such can deliver (not much).  System thing
and/or libvirt created a cpuset home for qemu, but with VPUs sharing
CPU with other qemu threads and the rest of the world, RT performance
in little virtual box was as pathetic as one would expect.  What did I
do about it?  Among others, the obvious, I created an exclusive cpuset,
and distributed qemu contexts having different requirements among
context containment vessels having the required properties.

I won't be doing any more of that particular scenario, but certainly
will want to distribute various contexts among various context
containment vessels in future.  I soon enough won't care about cgroups,
but others will surely expect cpu, cpuacct and cpuset controllers to
continue to function properly.

> I understand that CPU controller getting constrained due to other
> controllers can feel frustrating; however, the constraint is there to
> solve practical problems which hopefully are being explained in this
> conversation.  If there is a better trade-off, we can easily get rid
> of it and move on, but such decision can only be made considering all
> the relevant factors.  If you can think of a better solution, let's
> please discuss it.

None here.  Any artificial restriction placed on controllers will
render same broken in one way or another that will matter to someone
somewhere.  Making something less than it was will do that.

	-Mike
