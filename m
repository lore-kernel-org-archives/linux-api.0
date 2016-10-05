From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 5 Oct 2016 10:07:55 +0200
Message-ID: <20161005080755.GE3142@twins.programming.kicks-ass.net>
References: <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160906102950.GK10153@twins.programming.kicks-ass.net>
 <20161004144717.GA4205@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161004144717.GA4205-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 04, 2016 at 10:47:17AM -0400, Tejun Heo wrote:
> > cgroup-v2, by placing the system style controllers first and foremost,
> > completely renders that scenario impossible. Note also that any proposed
> > rgroup would not work for this, since that, per design, is a subtree,
> > and therefore not disjoint.
> 
> If a use case absolutely requires disjoint resource hierarchies, the
> only solution is to keep using multiple v1 hierarchies, which
> necessarily excludes the possibility of doing anyting across different
> resource types.
> 
> > So my objection to the whole cgroup-v2 model and implementation stems
> > from the fact that it purports to be a 'better' and 'improved' system,
> > while in actuality it neuters and destroys a lot of useful usecases.
> > 
> > It completely disregards all task-controllers and labels their use-cases
> > as irrelevant.
> 
> Your objection then doesn't have much to do with the specifics of the
> cgroup v2 model or implementation.

It is too, I've stated multiple times that the no internal tasks thing
is bad and that the root exception is an inexcusable wart that makes the
whole thing internally inconsistent.

But talking to you guys is pointless. You'll just keep moving air until
the other party tires and gives up.

My NAK on v2 stands.

> It's an objection against
> establishing common resource domains as that excludes building
> orthogonal multiple hierarchies.  That, necessarily, can only be
> achieved by having multiple hierarchies for different resource types
> and thus giving up the benefits of common resource domains.

Yes, v2 not allowing that rules it out as a valid model.

> Assuming that, I don't think your position is against cgroup v2 but
> more toward keeping v1 around.  We're talking about two quite
> different mutually exclusive classes of use cases.  You need unified
> for one and disjoint for the other.  v1 is gonna be there and can
> easily be used alongside v2 for different controller types, which
> would in most cases be cpu and cpuset.
> 
> I can't see a reason why this would need to block properly supporting
> containerization use cases.

I don't block that use-case, I block cgroup-v2, its shit.

The fact is, the naming "v2" suggests its a replacement and will
deprecate "v1". Also the implementation is mutually exclusive with v1,
you have to pick one and the other becomes inaccessible.

You cannot even pick another one inside a container, breaking the
container invariant.
