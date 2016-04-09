From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Sat, 9 Apr 2016 15:39:17 +0200
Message-ID: <20160409133917.GV3448@twins.programming.kicks-ass.net>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407080833.GK3430@twins.programming.kicks-ass.net>
 <20160407194555.GI7822@mtj.duckdns.org>
 <20160407202542.GD3448@twins.programming.kicks-ass.net>
 <20160408201135.GO24661@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160408201135.GO24661-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 08, 2016 at 04:11:35PM -0400, Tejun Heo wrote:

> > > Widely diverging from
> > > CPU's behavior, IO grouped all internal tasks into an internal leaf
> > > node and used to assign a fixed weight to it.
> > 
> > That's just plain broken... That is not how a proportional weight based
> > hierarchical controller works.
> 
> That's a strong statement. 

No its plain fact.

If you modify a graph, it is not the same graph.

Even if you argue by merit of the function on this graph, and state that
only the result of this function is important, and any modification to
the graph that leaves this result in tact is good; ie. a modification
invariant to the function, this fails.

Because for proportional controllers all that matters is the number and
weight of edges leaving a node.

The modification described above does clearly change the outcome and is
not invariant under the proportional weight distribution function.

> When the hierarchy is composed of
> equivalent objects as in CPU, not distinguishing internal and leaf
> nodes would be a more natural way to organize; however, it isn't
> necessarily true in all cases.  For example, while a writeback IO
> would be issued by some task, the task itself might not have done
> anything to cause that IO and the IO would essentially be anonymous in
> the resource domain.  Also, different controllers use different units
> of organization - CPU sees threads, IO sees IO contexts which are
> usually shared in a process.  The difference would lead to differing
> scaling behaviors in proportional distribution.
> 
> While the separate buckets and entities model may not be as elegant as
> tree of uniform objects, it is far from uncommon and more robust when
> dealing with different types of objects.

The graph does not care about the type of objects the nodes represent,
and proportional weight distribution only cares about the edges.

With cpu-cgroup the nodes are not of uniform type either, they can be a
group or a task. You get runtime type identification and make it work.

There just isn't an excuse for crazy crap like this. Its wrong, no two
ways about it.
