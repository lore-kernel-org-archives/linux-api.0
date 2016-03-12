From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: cgroup NAKs ignored? Re: [PATCHSET RFC cgroup/for-4.6] cgroup,
 sched: implement resource group and PRIO_RGRP
Date: Sat, 12 Mar 2016 18:13:18 +0100
Message-ID: <20160312171318.GD1108@gmail.com>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <1457764019.10402.72.camel@gmail.com>
 <1457802262.3628.129.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457802262.3628.129.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, 2016-03-12 at 07:26 +0100, Mike Galbraith wrote:
> > On Fri, 2016-03-11 at 10:41 -0500, Tejun Heo wrote:
> > > Hello,
> > > 
> > > This patchset extends cgroup v2 to support rgroup (resource group) for
> > > in-process hierarchical resource control and implements PRIO_RGRP for
> > > setpriority(2) on top to allow in-process hierarchical CPU cycle
> > > control in a seamless way.
> > > 
> > > cgroup v1 allowed putting threads of a process in different cgroups
> > > which enabled ad-hoc in-process resource control of some resources.
> 
> BTW, within the scheduler, "process" does not exist. [...]

Yes, and that's very fundamental.

And I see that many bits of the broken 'v2' cgroups ABI already snuck into the 
upstream kernel in this merge dinwo, without this detail having been agreed upon!
:-(

Tejun, this _REALLY_ sucks. We had pending NAKs over the design, still you moved 
ahead like nothing happened, why?!

> [...]  A high level composite entity is what we currently aggregate from 
> arbitrary individual entities, a.k.a threads.  Whether an individual entity be 
> an un-threaded "process" bash, a thread of "process" oracle, or one of 
> "process!?!" kernel is irrelevant.  What entity aggregation has to do with 
> "process" eludes me completely.
> 
> What's ad-hoc or unusual about a thread pool servicing an arbitrary number of 
> customers using cgroup bean accounting?  Job arrives from customer, worker is 
> dispatched to customer workshop (cgroup), it does whatever on behest of 
> customer, sends bean count off to the billing department, and returns to the 
> break room.  What's so annoying about using bean counters for.. counting beans 
> that you want to forbid it?

Agreed ... and many others expressed this concern as well. Why were these concerns 
ignored?

Thanks,

	Ingo
