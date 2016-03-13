From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Sun, 13 Mar 2016 11:00:12 -0400
Message-ID: <20160313150012.GB13405@htj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <1457764019.10402.72.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457764019.10402.72.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Mike.

On Sat, Mar 12, 2016 at 07:26:59AM +0100, Mike Galbraith wrote:
> Hrm.  You're showing that per-thread groups can coexist just fine,
> which is good given need and usage exists today out in the wild.  Why
> do such groups have to be invisible with a unique interface though?

I tried to explain these in the forementioned RFD document.  I'll give
a brief example here.

Let's say there is an application which wants to manage resource
distributions across its multiple threadpools in a hierarchical way.
With cgroupfs interface as the only system-wide interface, it has to
coordinate who or whatever is managing that interface.  Maybe it can
get a subtree delegated to it, maybe it has to ask the system thing to
create and place threads there, maybe it can just expose the pids and
let the system management do its thing (what if the threads in the
pools are dynamic tho?).  There is no reliable universal way of doing
this.  Each such application has to be ready to specifically
coordinate with the specific system management in use.

This is kernel failing to provide proper abstraction and isolation
between different layers.  The "raw" feature is there but it's unsafe
to use and thus can't be used widely.

> Given the core has to deal with them whether they're visible or not,
> and given they exist to fulfill a need, seems they should be first
> class citizens, not some Quasimodo like creature sneaking into the
> cathedral via a back door and slinking about in the shadows.

In terms of programmability and accessibility for individual
applications, group resource management being available through
straight-forward and incremental extension of exsiting mechanisms is
*way* more first class citizen.  It is two seamless extensions to
clone(2) and setpriority(2) making hierarchical resource management
generally available to applications.

There can be use cases where building cpu resource hierarchy which is
completely alien to how the rest of the system is organized is useful.
For those cases, the only thing which can be done is building a
separate hierarchy for the cpu controller and that capability isn't
going anywhere.

Thanks.

-- 
tejun
