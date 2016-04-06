From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Wed, 6 Apr 2016 17:53:07 -0400
Message-ID: <20160406215307.GJ24661@htj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <20160315172136.GA6114@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160315172136.GA6114-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Michal.

Sorry about the delay.

On Tue, Mar 15, 2016 at 06:21:36PM +0100, Michal Hocko wrote:
> While I agree that per-thread granularity is no fun for controllers
> which operate on different than task_struct entities (like memory cgroup
> controller) but I am afraid that all the complications will not go away
> if we are strictly per-process anyway.
> 
> For example memcg controller is not strictly per-process either, it
> operates on the mm_struct and that might be shared between different
> _processes_. So we still might end up in the same schizophrenic
> situation where two different processes are living in different
> cgroups while one of them is silently operating in a different memcg
> cgroup. I really hate this but this is what our clone(CLONE_VM) (without
> CLONE_THREAD) allows to do.

Can you list applications which make use of CLONE_VM without
CLONE_THREAD?  I searched using searchcode.com and the only non-kernel
code that I see are niche pthread implementations and some strace type
audit tools.  The only reason those threadpackages use CLONE_VM &&
!CLONE_THREAD is that that used to be how linuxthreads was done before
linux kernel grew proper threading support with CLONE_THREAD.

What you're pointing out is a historical vestige and if you can't
bring yourself to agree to the fact that processes and threads are the
primary abstractions that our userspace use day in and day out, you
are not thinking straight.  Even the existing usages are *to*
implement pthread.

While the kernel can't assume CLONE_VM is always accompanied by
CLONE_THREAD and shouldn't be crashing when such conditions occur, we
also don't and shouldn't architect or optimize for them either.  In
fact, both memory and io pretty much declare that the specific
behaviors are undefined.

> I do not know about other controllers, maybe only memcg is so special,
> but that would suggest that even process-only restriction might turn out
> to be a problem in the future and controllers would have to face the
> same problem later on.
>
> Now I have to admit I do not have great ideas how to cover all the
> possible cases but wouldn't it make more sense to allow for more
> flexibility and allow thread migration while the migration can be vetoed
> by any controller should it cross into a different/incompatible cgroup.

This is a non-issue and designing an interface is not about "covering
all the possible cases".  Different cases have differing levels of
importance.  It'd be absolutely crazy to put the same amount of
consideration towards CLONE_VM && !CLONE_THREAD case when designing
*anything*.

Another factor to consider, which might not be immediately intuitive,
is that exposing everything comes at a cost, often a steep one.
cgroup has been reliably proving to be a very good example of this.
Orthogonal hierarchies seems totally flexible on the surface but it
makes it extremely awkward for different controllers to cooperate
preventing something as fundamental as control over buffered writes.

This case is similar too.  While exposing every possible combination
to userland might seem to be a good idea on the surface, the end
result is the kernel failing to provide a necessary isolation between
operations internal to applications and system management making
resource control essentially inaccessible outside of specialized
custom setups.  It's a failure, not a feature.

Thanks.

-- 
tejun
