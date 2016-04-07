From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Wed, 6 Apr 2016 20:00:34 -0400
Message-ID: <20160407000034.GL24661@htj.duckdns.org>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
 <1457764019.10402.72.camel@gmail.com>
 <20160313150012.GB13405@htj.duckdns.org>
 <1457890835.3859.72.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457890835.3859.72.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Mike.

On Sun, Mar 13, 2016 at 06:40:35PM +0100, Mike Galbraith wrote:
> On Sun, 2016-03-13 at 11:00 -0400, Tejun Heo wrote:
> > Let's say there is an application which wants to manage resource
> > distributions across its multiple threadpools in a hierarchical way.
> > With cgroupfs interface as the only system-wide interface, it has to
> > coordinate who or whatever is managing that interface.  Maybe it can
> > get a subtree delegated to it, maybe it has to ask the system thing to
> > create and place threads there, maybe it can just expose the pids and
> > let the system management do its thing (what if the threads in the
> > pools are dynamic tho?).  There is no reliable universal way of doing
> > this.  Each such application has to be ready to specifically
> > coordinate with the specific system management in use.
> 
> The last thing I ever want to see on my boxen is random applications
> either doing their own thing with my cgroups management interface, or
> conspiring with "the system thing" behind my back to do things that I
> did not specifically ask them to do.

That isn't too different from saying that you don't want applications
to be calling setpriority(2) on its threads, which is a weird thing to
say, especially given that there are situations where applying control
from outside simply can't work - thread pools can be dynamic and there
is no reliable way of telling which threads are for which purposes
from outside.

This is not to say that admin override is unnecessary or unsupported.
In fact, rgroup and cgroup give the admin a lot more control.
Controller access can be revoked from applications in subtrees and the
entire controller can be detached from the hierarchy for full
override.

> "The system thing" started doing its own thing behind my back, and
> oddly enough, its tentacles started falling off.  By golly, its eyes
> seem to have fallen out as well.
> 
> That's what happens when control freak meets control freak, one of them
> ends up in pieces.  There can be only one, and that one is me, the
> administrator.  Applications don't coordinate spit, if I put on my
> administrator hat and stuff 'em in a box, they better stay stuffed.

Sure, you're a control freak.  Be that.  rgroup doesn't get in the way
of you doing that; however, you also have to realize that a single
person hand-configuring a specialized setup for oneself isn't the only
mode of usage.  Those are, in fact, vocal but clearly minority use
cases.  What's more common would be systematic management of resources
and applications configuring resource distribution across their
threads.  If you wanna assume full control, do so.  Nothing is
preventing that, and, at the same time, that shouldn't get in the way
of implementing mechanisms which are more widely useful.

> > > Given the core has to deal with them whether they're visible or not,
> > > and given they exist to fulfill a need, seems they should be first
> > > class citizens, not some Quasimodo like creature sneaking into the
> > > cathedral via a back door and slinking about in the shadows.
> > 
> > In terms of programmability and accessibility for individual
> > applications, group resource management being available through
> > straight-forward and incremental extension of exsiting mechanisms is
> > *way* more first class citizen.  It is two seamless extensions to
> > clone(2) and setpriority(2) making hierarchical resource management
> > generally available to applications.
> 
> To me, that sounds like chaos.

Care to elaborate rationales for the claim?

> > There can be use cases where building cpu resource hierarchy which is
> > completely alien to how the rest of the system is organized is useful.
> > For those cases, the only thing which can be done is building a
> > separate hierarchy for the cpu controller and that capability isn't
> > going anywhere.
> 
> As long as administrators can use the system interface to aggregate
> what they see fit, I'm happy.  The scheduler schedules threads, ergo
> the cpu controller must aggregate threads.  There is no process.

Scheduler not knowing beyond threads is great but that doesn't make
the concept of process any less of a real thing when the kernel
interacts with userland.  Processes and threads are clearly the
primary constructs that our userland uses for execution contexts, and
process boundaries are frequently used to delimit various isolation
domains both in kerne API and programming conventions.

A capability can also become inaccessible when it's exposed in a way
which doesn't work in conjunction with the existing abstractions.  The
kernel not providing isolation at the expected layers is a failure
that can prevent the feature from being useable in a lot of cases.
What rgroup tries to do is exposing cgroup's capabilities in a way
which integrates with the existing programming constructs that
userland already depends upon to make these capabilities accessible to
them.

Again, if you wanna be a control freak, nothing stands in your way,
but control freak admins aren't the only consumers of kernel.

Thanks.

-- 
tejun
