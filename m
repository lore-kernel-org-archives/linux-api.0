From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 15:04:24 -0400
Message-ID: <20160407190424.GA20407@cmpxchg.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407082810.GN3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407082810.GN3430-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 10:28:10AM +0200, Peter Zijlstra wrote:
> On Thu, Apr 07, 2016 at 03:35:47AM -0400, Johannes Weiner wrote:
> > There was a lot of back and forth whether we should add a second set
> > of knobs just to control the local tasks separately from the subtree,
> > but ended up concluding that the situation can be expressed more
> > clearly by creating dedicated leaf subgroups for stuff like management
> > software and launchers instead, so that their memory pools/LRUs are
> > clearly delineated from other groups and seperately controllable. And
> > we couldn't think of any meaningful configuration that could not be
> > expressed in that scheme. I mean, it's the same thing, right?
> 
> No, not the same.
> 
> 
> 	R
>       / | \
>      t1	t2 A
>          /   \
>         t3   t4
> 
> 
> Is fundamentally different from:
> 
> 
>              R
> 	   /   \
> 	 L       A
>        /   \   /   \
>       t1  t2  t3   t4
> 
> 
> Because if in the first hierarchy you add a task (t5) to R, all of its A
> will run at 1/4th of total bandwidth where before it had 1/3rd, whereas
> with the second example, if you add our t5 to L, A doesn't get any less
> bandwidth.

I didn't mean the same exact configuration, I meant being able to
configure with the same outcome of resource distribution.

All this means here is that if you want to change the shares allocated
to the tasks in R (or then L) you have to be explicit about it and
update the weight configuration in L.

Again, it's not gratuitous, it's based on the problems this concept in
the interface created in more comprehensive container deployments.

> Please pull your collective heads out of the systemd arse and start
> thinking.

I don't care about systemd here. In fact, in 5 years of rewriting the
memory controller, zero percent of it was driven by systemd and most
of it from Google's feedback at LSF and email since they had by far
the most experience and were pushing the frontier. And even though the
performance and overhead of the memory controller was absolutely
abysmal - routinely hitting double digits in page fault profiles - the
discussions *always* centered around the interface and configuration.

IMO, this thread is a little too focused on the reality of a single
resource controller, when in real setups it doesn't exist in a vacuum.
What these environments need is to robustly divide the machine up into
parcels to isolate thousands of jobs on X dimensions at the same time:
allocate CPU time, allocate memory, allocate IO. And then on top of
that implement higher concepts such as dirty page quotas and
writeback, accounting for kswapd's cpu time based on who owns the
memory it reclaims, accounting IO time for the stuff it swaps out
etc. That *needs* all three resources to be coordinated.

You disparagingly called it the lowest common denominator, but the
thing is that streamlining the controllers and coordinating them
around shared resource domains gives us much more powerful and robust
ways to allocate the *machines* as a whole, and allows the proper
tracking and accounting of cross-domain operations such as writeback
that wasn't even possible before. And all that in a way that doesn't
have the same usability pitfalls that v1 had when you actually push
this stuff beyond the "i want to limit the cpu cycles of this one
service" and move towards "this machine is an anonymous node in a data
center and I want it to host thousands of different workloads - some
sensitive to latency, some that only care about throughput - and they
better not step on each other's toes on *any* of the resource pools."

Those are my primary concerns when it comes to the v2 interface, and I
think focusing too much on what's theoretically possible with a single
controller is missing the bigger challenge of allocating machines.
