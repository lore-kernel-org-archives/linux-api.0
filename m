From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 03:35:47 -0400
Message-ID: <20160407073547.GA12560@cmpxchg.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407064549.GH3430-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 08:45:49AM +0200, Peter Zijlstra wrote:
> So I recently got made aware of the fact that cgroupv2 doesn't allow
> tasks to be associated with !leaf cgroups, this is yet another
> capability of cpu-cgroup you've destroyed.

May I ask how you are using that?

The behavior for tasks in !leaf groups was fairly inconsistent across
controllers because they all did different things, or didn't handle it
at all. For example, the block controller in v1 implements separate
weight knobs for the group as a subtree root as well as for the tasks
only inside the group itself. But it didn't do so for bandwith limits.

The memory controller on the other hand only had a singular set of the
controls that applied to both the local tasks and all subgroups. And I
know Google had a lot of trouble with that because they ended up with
basically uncontrollable leftover cache in the top-level group of some
subtree that would put pressure on the real workload leafgroups below.

There was a lot of back and forth whether we should add a second set
of knobs just to control the local tasks separately from the subtree,
but ended up concluding that the situation can be expressed more
clearly by creating dedicated leaf subgroups for stuff like management
software and launchers instead, so that their memory pools/LRUs are
clearly delineated from other groups and seperately controllable. And
we couldn't think of any meaningful configuration that could not be
expressed in that scheme. I mean, it's the same thing, right? Only
that with tasks in !leaf groups the controller would have to emulate a
hidden leaf subgroup and provide additional interfacing, and without
it the leaf groups are explicit and a single set of knobs suffices.
I.e. it seems more of a convenience thing than actual functionality,
but one that forces ugly redundancy in the interface.

So it was a nice cleanup for the memory controller and I believe the
IO controller as well. I'd be curious how it'd be a problem for CPU?
