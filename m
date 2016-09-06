From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Tue, 6 Sep 2016 12:29:50 +0200
Message-ID: <20160906102950.GK10153@twins.programming.kicks-ass.net>
References: <20160820155659.GA16906@mtj.duckdns.org>
 <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 05, 2016 at 10:37:55AM -0700, Andy Lutomirski wrote:
> And I still think that, at least for cpu, nothing at all goes wrong if
> you allow processes to exist in cgroups that have cpu set in
> subtree-control.

cpu, cpuset, perf, cpuacct (although we all agree that really should be
part of cpu), pid, and possibly freezer (but I think we all agree
freezer is 'broken').

That's roughly half the controllers out there.

They all work on tasks, and should therefore have no problems what so
ever to allow the full hierarchy without silly exceptions and
constraints.



The fundamental problem is that we have 2 different types of
controllers, on the one hand these controllers above, that work on tasks
and form groups of them and build up from that. Lets call them
task-controllers.

On the other hand we have controllers like memcg which take the 'system'
as a whole and shrink it down into smaller bits. Lets call these
system-controllers.


They are fundamentally at odds with capabilities, simply because of the
granularity they can work on.

Merging the two into a common hierarchy is a useful concept for
containerization, no argument on that, esp. when also coupled with
namespaces and the like.


However, where I object _most_ strongly is having this one use dominate
and destroy the capabilities (which are in use) of the task-controllers.


> > I do.  It's a horrible userland API to expose to individual
> > applications if the organization that a given application expects can
> > be disturbed by system operations.  Imagine how this would be
> > documented - "if this operation races with system operation, it may
> > return -ENOENT.  Repeating the path lookup might make the operation
> > succeed again."
> 
> It could be made to work without races, though, with minimal (or even
> no) ABI change.  The managed program could grab an fd pointing to its
> cgroup.  Then it would use openat, etc for all operations.  As long as
> 'mv /cgroup/a/b /cgroup/c/" didn't cause that fd to stop working,
> we're fine.

I've mentioned openat() and related APIs several times, but so far never
got good reasons why that wouldn't work.



Also note that in order to partition the cpus with cpusets, you're
required to generate a disjoint hierarchy (that is, one where the
(common) parent is 'disabled' and the children have no overlap).

This is rather fundamental to partitioning, that by its very nature
requires separation.

The result is that if you want to place your RT threads (consider an
application that consists of RT and !RT parts) in a different partition
there is no common parent you can place the process in.


cgroup-v2, by placing the system style controllers first and foremost,
completely renders that scenario impossible. Note also that any proposed
rgroup would not work for this, since that, per design, is a subtree,
and therefore not disjoint.


So my objection to the whole cgroup-v2 model and implementation stems
from the fact that it purports to be a 'better' and 'improved' system,
while in actuality it neuters and destroys a lot of useful usecases.

It completely disregards all task-controllers and labels their use-cases
as irrelevant.
