From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Sat, 12 Mar 2016 07:26:59 +0100
Message-ID: <1457764019.10402.72.camel@gmail.com>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2016-03-11 at 10:41 -0500, Tejun Heo wrote:
> Hello,
> 
> This patchset extends cgroup v2 to support rgroup (resource group) for
> in-process hierarchical resource control and implements PRIO_RGRP for
> setpriority(2) on top to allow in-process hierarchical CPU cycle
> control in a seamless way.
> 
> cgroup v1 allowed putting threads of a process in different cgroups
> which enabled ad-hoc in-process resource control of some resources.
> Unfortunately, this approach was fraught with problems such as
> membership ambiguity with per-process resources and lack of isolation
> between system management and in-process properties.  For a more
> detailed discussion on the subject, please refer to the following
> message.
> 
>  [1] [RFD] cgroup: thread granularity support for cpu controller
> 
> This patchset implements the mechanism outlined in the above message.
> The new mechanism is named rgroup (resource group).  When explicitly
> designating a non-rgroup cgroup, the term sgroup (system group) is
> used.  rgroup has the following properties.
> 
> * A rgroup is a cgroup which is invisible on and transparent to the
>   system-level cgroupfs interface.
> 
> * A rgroup can be created by specifying CLONE_NEWRGRP flag, along with
>   CLONE_THREAD, during clone(2).  A new rgroup is created under the
>   parent thread's cgroup and the new thread is created in it.
> 
> * A rgroup is automatically destroyed when empty.
> 
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
> 
> * Subset of controllers available on the parent sgroup are available
>   to rgroup subtrees.  Controller management on rgroups is automatic
>   and implicit and doesn't interfere with system-level cgroup
>   controller management.  If a controller is made unavailable on the
>   parent sgroup, it's automatically disabled from child rgroup
>   subtrees.
> 
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
> 
> PRIO_RGRP allows in-process hierarchical control of CPU cycles in a
> manner which is a straight-forward and minimal extension of existing
> task and priority management.

Hrm.  You're showing that per-thread groups can coexist just fine,
which is good given need and usage exists today out in the wild.  Why
do such groups have to be invisible with a unique interface though?

Given the core has to deal with them whether they're visible or not,
and given they exist to fulfill a need, seems they should be first
class citizens, not some Quasimodo like creature sneaking into the
cathedral via a back door and slinking about in the shadows.

	-Mike
