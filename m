From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 10:28:10 +0200
Message-ID: <20160407082810.GN3430@twins.programming.kicks-ass.net>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407073547.GA12560-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 03:35:47AM -0400, Johannes Weiner wrote:
> There was a lot of back and forth whether we should add a second set
> of knobs just to control the local tasks separately from the subtree,
> but ended up concluding that the situation can be expressed more
> clearly by creating dedicated leaf subgroups for stuff like management
> software and launchers instead, so that their memory pools/LRUs are
> clearly delineated from other groups and seperately controllable. And
> we couldn't think of any meaningful configuration that could not be
> expressed in that scheme. I mean, it's the same thing, right?


No, not the same.


	R
      / | \
     t1	t2 A
         /   \
        t3   t4


Is fundamentally different from:


             R
	   /   \
	 L       A
       /   \   /   \
      t1  t2  t3   t4


Because if in the first hierarchy you add a task (t5) to R, all of its A
will run at 1/4th of total bandwidth where before it had 1/3rd, whereas
with the second example, if you add our t5 to L, A doesn't get any less
bandwidth.


Please pull your collective heads out of the systemd arse and start
thinking.
