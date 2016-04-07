From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 05:28:24 -0400
Message-ID: <20160407092824.GA13839@cmpxchg.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407080833.GK3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407080833.GK3430-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 10:08:33AM +0200, Peter Zijlstra wrote:
> On Thu, Apr 07, 2016 at 03:35:47AM -0400, Johannes Weiner wrote:
> > On Thu, Apr 07, 2016 at 08:45:49AM +0200, Peter Zijlstra wrote:
> > > So I recently got made aware of the fact that cgroupv2 doesn't allow
> > > tasks to be associated with !leaf cgroups, this is yet another
> > > capability of cpu-cgroup you've destroyed.
> > 
> > May I ask how you are using that?
> 
> _I_ use a kernel with CONFIG_CGROUPS=n (yes really).
> 
> But seriously? You have to ask?
> 
> The root cgroup is per definition not a leaf, and all tasks start life
> there, and some cannot be ever moved out.
> 
> Therefore _everybody_ uses this.

Hm? The root group can always contain tasks. It's not the only thing
the root is exempt from, it can't control any resources either:

sched_group_set_shares():

	/*
	 * We can't change the weight of the root cgroup.
	 */
	if (!tg->se[0])
		return -EINVAL;

tg_set_cfs_bandwidth():

	if (tg == &root_task_group)
		return -EINVAL;

etc.

and all the problems that led to this rule stem from resource control.

> > The behavior for tasks in !leaf groups was fairly inconsistent across
> > controllers because they all did different things, or didn't handle it
> > at all.
> 
> Then they're all bloody broken, because fully hierarchical was an early
> requirement for cgroups; I know, because I had to throw away many days
> of work and start over with cgroup support when they did that.

I think we're talking past each other.

They're all fully hierarchical in the sense of accounting and divvying
up resources along a tree structure, and configurable groups competing
with other configurable groups or subtrees. That all works perfectly
fine. It's the concept of loose unconfigurable tasks competing with
configured groups or subtrees that invites problems.

It's not a question of implementation, it's that the configurations
that people created with e.g. the memory controller repeatedly ended
up creating the same problems and the same stupid patches to add the
local-only knobs (which the cpu cgroup doesn't have either AFAICS).

This is not some gratuitous cutting away of convenience, it's hours
and hours of discussions both on the mailinglists and at conferences
about such lovely stuff as to whether the memory lowlimit (softlimit)
should apply to only the local memory pool or hierarchically because
that user happened to have memory pools in !leaf nodes which they had
to control somehow.

Swear to god.

[ And yes, the root group IS "loose unconfigurable tasks" that compete
  with configured subtrees. But that is very explicit in the interface
  and you move stuff that consumes significant resources and needs to
  be controlled out of the root group; it doesn't have the same issue. ]

If that happens once or twice I'm willing to write it off as PEBCAK,
but if otherwise competent users like Google repeatedly create
configurations that lead to these problems, and then end up pushing
and lobbying in this case for non-hierarchical knobs to work around
problems in the structural organization of the workloads, it's more
likely that the interface is shit.

So we added a rule that doesn't take away any functionality, but it
forces you to organize your workloads more explicitely to take away
that ambiguity.
