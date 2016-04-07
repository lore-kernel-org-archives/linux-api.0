From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 12:42:59 +0200
Message-ID: <20160407104259.GQ3430@twins.programming.kicks-ass.net>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
 <20160407080833.GK3430@twins.programming.kicks-ass.net>
 <20160407092824.GA13839@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407092824.GA13839-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 05:28:24AM -0400, Johannes Weiner wrote:
> Hm? The root group can always contain tasks. It's not the only thing
> the root is exempt from, it can't control any resources either:

it does in fact control resouces; the hierarchy directly affects the
proportional distribution of time.

> sched_group_set_shares():
> 
> 	/*
> 	 * We can't change the weight of the root cgroup.
> 	 */
> 	if (!tg->se[0])
> 		return -EINVAL;

The root has, per definition, no siblings, so setting a weight is
entirely pointless.

> tg_set_cfs_bandwidth():
> 
> 	if (tg == &root_task_group)
> 		return -EINVAL;
> 

We have had patches to implement this, but have so far held off because
they add a bunch of cycles to some really hot paths and we'd rather not
do that. Its not impossible, or unthinkable to do this otherwise.
