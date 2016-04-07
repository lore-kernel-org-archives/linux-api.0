From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 16:23:44 -0400
Message-ID: <20160407202344.GA22509@cmpxchg.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407082810.GN3430@twins.programming.kicks-ass.net>
 <20160407190424.GA20407@cmpxchg.org>
 <20160407193127.GB3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407193127.GB3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 09:31:27PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 07, 2016 at 03:04:24PM -0400, Johannes Weiner wrote:
> 
> > All this means here is that if you want to change the shares allocated
> > to the tasks in R (or then L) you have to be explicit about it and
> > update the weight configuration in L.
> 
> Updating the weight of L for every task spawned and killed is simply not
> an option.
> 
> The fact that you're not willing to admit to this is troubling, but does
> confirm I can stop spending time on anything cgroup v2. cpu-cgroup just
> isn't going to move to this inferior interface.

I guess I walked right into that one, didn't I ;-) It probably makes
more sense to discuss a real-life workload instead of a diagram.

Obviously, if the threadpool size is highly variable it's not
reasonable to ask the user to track every update and accordingly
reconfigure the controller. I fully agree with you there.

All I meant to point out is that the *implicit* behavior of the v1
interface did create real problems, to show you that this is not a
one-sided discussion and that there are real life concerns that played
into the decision of not letting loose tasks compete with groups.

If this is a real workload rather than a thought experiment, it will
need to be supported in v2 as well - just if we can help it hopefully
without reverting to the tricky behavior of the v1 controller. One
possible solution I could imagine for example is adding the option to
configure a groups weight such that its dynamically based on the # of
threads. But it depends on what the exact requirements are here.

Could you explain what this workload is so it's easier to reason about?

Mike, is that the one you referred to with one group per customer
account? If so, would you have a pointer to where you outline it?
