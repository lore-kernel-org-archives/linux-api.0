From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Mon, 14 Mar 2016 12:30:13 +0100
Message-ID: <20160314113013.GM6344@twins.programming.kicks-ass.net>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 10:41:18AM -0500, Tejun Heo wrote:
> * A rgroup is a cgroup which is invisible on and transparent to the
>   system-level cgroupfs interface.
> 
> * A rgroup can be created by specifying CLONE_NEWRGRP flag, along with
>   CLONE_THREAD, during clone(2).  A new rgroup is created under the
>   parent thread's cgroup and the new thread is created in it.

This seems overly restrictive. As you well know there's people moving
threads about after creation.

Also, with this interface the whole thing cannot be used until your
libc's pthread_create() has been patched to allow use of this new flag.

> * A rgroup is automatically destroyed when empty.

Except for Zombies it appears..

> * A top-level rgroup of a process is a rgroup whose parent cgroup is a
>   sgroup.  A process may have multiple top-level rgroups and thus
>   multiple rgroup subtrees under the same parent sgroup.
> 
> * Unlike sgroups, rgroups are allowed to compete against peer threads.
>   Each rgroup behaves equivalent to a sibling task.
> 
> * rgroup subtrees are local to the process.  When the process forks or
>   execs, its rgroup subtrees are collapsed.
> 
> * When a process is migrated to a different cgroup, its rgroup
>   subtrees are preserved.

This all makes it impossible to say put a single thread outside of the
hierarchy forced upon it by the process. Like putting a RT thread in an
isolated group on the side.

Which is a rather common thing to do.

> rgroup lays the foundation for other kernel mechanisms to make use of
> resource controllers while providing proper isolation between system
> management and in-process operations removing the awkward and
> layer-violating requirement for coordination between individual
> applications and system management.  On top of the rgroup mechanism,
> PRIO_RGRP is implemented for {set|get}priority(2).
> 
> * PRIO_RGRP can only be used if the target task is already in a
>   rgroup.  If setpriority(2) is used and cpu controller is available,
>   cpu controller is enabled until the target rgroup is covered and the
>   specified nice value is set as the weight of the rgroup.
> 
> * The specified nice value has the same meaning as for tasks.  For
>   example, a rgroup and a task competing under the same parent would
>   behave exactly the same as two tasks.
> 
> * For top-level rgroups, PRIO_RGRP follows the same rlimit
>   restrictions as PRIO_PROCESS; however, as nested rgroups only
>   distribute CPU cycles which are allocated to the process, no
>   restriction is applied.

While this appears neat, I doubt it will remain so in the face of this:

> * A mechanism that applications can use to publish certain rgroups so
>   that external entities can determine which IDs to use to change
>   rgroup settings.  I already have interface and implementation design
>   mostly pinned down.

So you need some new fangled way to set/query all the other possible
cgroup parameters supported, and then suddenly you have one that has two
possible interface. That's way ugly.

While I appreciate the sentiment that having two entities poking at the
cgroup filesystem without coordination is a problem, I don't see this as
the solution. I would much rather just kill the system wide thing, that
too solves the problem.

IOW, I'm unconvinced this approach will cater to current practises or
even allow similar functionality.
