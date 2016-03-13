From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup NAKs ignored? Re: [PATCHSET RFC cgroup/for-4.6] cgroup,
 sched: implement resource group and PRIO_RGRP
Date: Sun, 13 Mar 2016 10:42:57 -0400
Message-ID: <20160313144257.GA13405@htj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <1457764019.10402.72.camel@gmail.com>
 <1457802262.3628.129.camel@gmail.com>
 <20160312171318.GD1108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160312171318.GD1108-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Ingo.

On Sat, Mar 12, 2016 at 06:13:18PM +0100, Ingo Molnar wrote:
> > BTW, within the scheduler, "process" does not exist. [...]
> 
> Yes, and that's very fundamental.

I'll go into this part later.

> And I see that many bits of the broken 'v2' cgroups ABI already snuck into the 
> upstream kernel in this merge dinwo, without this detail having been agreed upon!
> :-(
>
> Tejun, this _REALLY_ sucks. We had pending NAKs over the design, still you moved 
> ahead like nothing happened, why?!

Hmmmm?  The cpu controller is still in review branch.  The thread
sprawled out but the disagreement there was about missing the ability
to hierarchically distribute CPU cycles in process and the two
alternatives discussed throughout the thread were per-process private
filesystem under /proc/PID and extension of existing process resource
nmanagement mechanisms.

Going back to the per-process part, I described the rationales in
cgroup-v2 documentation and the RFD document but here are some
important bits.

1. Common resource domains

* When different resources get intermixed as do memory and io during
  writeback, without a common resource domain defined across the
  different resource types, it's impossible to perform resource
  control.  As a simplistic example, let's say there are four
  processes (1, 2, 3, 4), two memory cgroups (ma, mb) and two io
  cgroups (ia, ib) with the following memership.

   ma: 1, 2  mb: 3, 4
   ia: 1, 3  ib: 2, 4

  Writeback and dirty throttling are regulated by the proportion of
  dirty memory against available and writeback bandwidth of the target
  backing device.  When resource domains are orthogonal like the
  above, it's impossible to define clear relationship.  This is one of
  the main reasons why writeback behavior has been so erratic with
  respect to cgroups.

* It is a lot more useful and less painful to have common resource
  domains defined across all resource types as it allows expressing
  things like "if this belongs to resource domain F, do XYZ".  A lot
  of use cases are already doing this by building the identical
  hierarchies (to differing depths) across all controllers.


2. Per-process

* There is a relatively pronounced boundary between system management
  and internal operations of an application and one side-effect of
  allowing threads to be assigned arbitrarily across system cgroupfs
  hierarchy is that it mandates close coordination between individual
  applications and system management (whether that be a human being or
  system agent software).  This is userland suffering because the
  kernel fails to provide a properly abstracted and isolated
  constructs.

  Decoupling system management and in-application operations makes
  hierarchical resource grouping and control easily accessible to
  individual applications without worrying about how the system is
  managed in larger scope.  Process is a fairly good approximation of
  this boundary.

* For some resources, going beyond process granularity doesn't make
  much sense.  While we can just let users do whatever they wanna do
  and declare certain configurations to yield undefined behaviors (io
  controller on v1 hierarchy actually does this), it is better to
  provide abstractions which match the actual characteristics.
  Combined with the above, it is natural to distinguish across-process
  and in-process operations.

> > [...]  A high level composite entity is what we currently aggregate from 
> > arbitrary individual entities, a.k.a threads.  Whether an individual entity be 
> > an un-threaded "process" bash, a thread of "process" oracle, or one of 
> > "process!?!" kernel is irrelevant.  What entity aggregation has to do with 
> > "process" eludes me completely.
> > 
> > What's ad-hoc or unusual about a thread pool servicing an arbitrary number of 
> > customers using cgroup bean accounting?  Job arrives from customer, worker is 
> > dispatched to customer workshop (cgroup), it does whatever on behest of 
> > customer, sends bean count off to the billing department, and returns to the 
> > break room.  What's so annoying about using bean counters for.. counting beans 
> > that you want to forbid it?
> 
> Agreed ... and many others expressed this concern as well. Why were these concerns 
> ignored?

They weren't ignored.  The concern expressed was the loss of the
ability to hierarchically distribute resource in process and the RFD
document and this patchset are the attempts at resolving that specific
issue.

Going back to Mike's "why can't these be arbitrary bean counters?",
yes, they can be.  That's what one gets when the cpu controller is
mounted on its own hierarchy.  If that's what the use case at hand
calls for, that is the way to go and there's nothing preventing that.
In fact, with recent restructuring of cgroup core, stealing a
stateless controller to a new hierarchy can be made a lot easier for
such use cases.

However, as explained above, controlling a resource in abstraction and
restriction-free style also has its costs.  There's no way to tie
different types of resources serving the same purpose which can be
generally painful and makes some cross-resource operations impossible.
Or entangling in-process operations with system management, IOW, a
process having to speak to the external $SYSTEM_AGENT to manage its
threadpools.

What the proposed solution tries to achieve is balancing flexibility
at system management level with proper abstractions and isolation so
that hierarchical resource management is actually accessible to a lot
wider set of applications and use-cases.

Given how cgroup is used in the wild, I'm pretty sure that the
structured approach will reach a lot wider audience without getting in
the way of what they try to achieve.  That said, again, for specific
use cases where the benefits from structured approach can or should be
ignored, using the cpu controller as arbitrary hierarchical bean
counters is completely fine and the right solution.

Thanks.

-- 
tejun
