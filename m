From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Tue, 12 Apr 2016 18:29:15 -0400
Message-ID: <20160412222915.GT24661@htj.duckdns.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160409133917.GV3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Peter.

On Sat, Apr 09, 2016 at 03:39:17PM +0200, Peter Zijlstra wrote:
> > While the separate buckets and entities model may not be as elegant as
> > tree of uniform objects, it is far from uncommon and more robust when
> > dealing with different types of objects.
> 
> The graph does not care about the type of objects the nodes represent,
> and proportional weight distribution only cares about the edges.
> 
> With cpu-cgroup the nodes are not of uniform type either, they can be a
> group or a task. You get runtime type identification and make it work.
>
> There just isn't an excuse for crazy crap like this. Its wrong, no two
> ways about it.

Abstracing tasks and groups as equivalent objects works well for the
scheduler and that's great.  This is also because the domain lends
itself very well to such simple and elegant approach.  The only
entities of interest are tasks, as you and Mike pointed out earlier in
the thread, and group priority can be easily mapped to task priority.
However, this isn't necessarily the case for other controllers.

There's also the issue of mapping the model to absolute controllers.
For the uniform model to work, there must be a way to treat internal
and leaf entities in the same way.  For memory, the leaf entities are
processes and applying the same model would mean that memory
controller would have to implement equivalent per-process control
knobs.  We don't have that.  In fact, we can't have that - a
significant part of memory consumption can't be attached to a single
process.  There is a fundamental distinction between internal and leaf
nodes in the memory resource graph.

We aren't designing a spherical cow in a vacuum, and, I believe,
should aspire to make pragmatic trade-offs of all involved factors.
If multiple controllers co-operating on the same resource domains is
beneficial and required, we should figure out a way to make different
controllers agree and that way most likely will require some
trade-offs from various controllers.

Given the currently known requirements and constraints, restricting
internal competition is a simple and straight-forward way to isolate
leaf node handling details of different controllers.

The cost is part aesthetical and part practical.  While less elegant
than tree of uniform objects, it seems a stretch to call internal /
leaf node distinction broken especially given that the model is
natural to some controllers.

The practical cost is loss of the ability to let leaf entities compete
against groups.  However, we can't evaluate how important such
capability is without actual use-cases.  If there are important ones,
please bring them up, so that we can examine the actual requirements
and try to find a good trade-off to support them.

I understand that CPU controller getting constrained due to other
controllers can feel frustrating; however, the constraint is there to
solve practical problems which hopefully are being explained in this
conversation.  If there is a better trade-off, we can easily get rid
of it and move on, but such decision can only be made considering all
the relevant factors.  If you can think of a better solution, let's
please discuss it.

Thanks.

-- 
tejun
