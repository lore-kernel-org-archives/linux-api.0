From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Thu, 7 Apr 2016 10:08:33 +0200
Message-ID: <20160407080833.GK3430@twins.programming.kicks-ass.net>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160314113013.GM6344@twins.programming.kicks-ass.net>
 <20160406155830.GI24661@htj.duckdns.org>
 <20160407064549.GH3430@twins.programming.kicks-ass.net>
 <20160407073547.GA12560@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160407073547.GA12560-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 03:35:47AM -0400, Johannes Weiner wrote:
> On Thu, Apr 07, 2016 at 08:45:49AM +0200, Peter Zijlstra wrote:
> > So I recently got made aware of the fact that cgroupv2 doesn't allow
> > tasks to be associated with !leaf cgroups, this is yet another
> > capability of cpu-cgroup you've destroyed.
> 
> May I ask how you are using that?

_I_ use a kernel with CONFIG_CGROUPS=n (yes really).

But seriously? You have to ask?

The root cgroup is per definition not a leaf, and all tasks start life
there, and some cannot be ever moved out.

Therefore _everybody_ uses this.

> The behavior for tasks in !leaf groups was fairly inconsistent across
> controllers because they all did different things, or didn't handle it
> at all.

Then they're all bloody broken, because fully hierarchical was an early
requirement for cgroups; I know, because I had to throw away many days
of work and start over with cgroup support when they did that.

> So it was a nice cleanup for the memory controller and I believe the
> IO controller as well. I'd be curious how it'd be a problem for CPU?

The full hierarchy took years to make work and is fully ingrained with
how the thing words, changing it isn't going to be nice or easy.


So sure, go with a lowest common denominator, instead of fixing shit,
yay for progress :/
