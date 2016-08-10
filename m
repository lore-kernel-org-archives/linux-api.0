From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 10 Aug 2016 18:09:44 -0400
Message-ID: <20160810220944.GB3085@cmpxchg.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <1470474291.4117.243.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470474291.4117.243.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Aug 06, 2016 at 11:04:51AM +0200, Mike Galbraith wrote:
> On Fri, 2016-08-05 at 13:07 -0400, Tejun Heo wrote:
> >   It is true that the trees are semantically different from each other
> >   and the symmetric handling of tasks and cgroups is aesthetically
> >   pleasing.  However, it isn't clear what the practical usefulness of
> >   a layout with direct competition between tasks and cgroups would be,
> >   considering that number and behavior of tasks are controlled by each
> >   application, and cgroups primarily deal with system level resource
> >   distribution; changes in the number of active threads would directly
> >   impact resource distribution.  Real world use cases of such layouts
> >   could not be established during the discussions.
> 
> You apparently intend to ignore any real world usages that don't work
> with these new constraints.

He didn't ignore these use cases. He offered alternatives like rgroup
to allow manipulating threads from within the application, only in a
way that does not interfere with cgroup2's common controller model.

The complete lack of cohesiveness between v1 controllers prevents us
from implementing even the most fundamental resource control that
cloud fleets like Google's and Facebook's are facing, such as
controlling buffered IO; attributing CPU cycles spent receiving
packets, reclaiming memory in kswapd, encrypting the disk; attributing
swap IO etc. That's why cgroup2 runs a tighter ship when it comes to
the controllers: to make something much bigger work.

Agreeing on something - in this case a common controller model - is
necessarily going to take away some flexibility from how you approach
a problem. What matters is whether the problem can still be solved.

This argument that cgroup2 is not backward compatible is laughable. Of
course it's going to be different, otherwise we wouldn't have had to
version it. The question is not whether the exact same configurations
and existing application design can be used in v1 and v2 - that's a
strange onus to put on a versioned interface. The question is whether
you can translate a solution from v1 to v2. Yeah, it might be a hassle
depending on how specialized your setup is, but that's why we keep v1
around until the last user dies and allow you to freely mix and match
v1 and v2 controllers within a single system to ease the transition.

But this distinction between approach and application design, and the
application's actual purpose is crucial. Every time this discussion
came up, somebody says 'moving worker threads between different
resource domains'. That's not a goal, though, that's a very specific
means to an end, with no explanation of why it has to be done that
way. When comparing the cgroup v1 and v2 interface, we should be
discussing goals, not 'this is my favorite way to do it'. If you have
an actual real-world goal that can be accomplished in v1 but not in v2
+ rgroup, then that's what we should be talking about.

Lastly, again - and this was the whole point of this document - the
changes in cgroup2 are not gratuitous. They are driven by fundamental
resource control problems faced by more comprehensive applications of
cgroup. On the other hand, the opposition here mainly seems to be the
inconvenience of switching some specialized setups from a v1-oriented
way of solving a problem to a v2-oriented way.

[ That, and a disturbing number of emotional outbursts against
  systemd, which has nothing to do with any of this. ]

It's a really myopic line of argument.

That being said, let's go through your points:

> Priority and affinity are not process wide attributes, never have
> been, but you're insisting that so they must become for the sake of
> progress.

Not really.

It's just questionable whether the cgroup interface is the best way to
manipulate these attributes, or whether existing interfaces like
setpriority() and sched_setaffinity() should be extended to manipulate
groups, like the rgroup proposal does. The problems of using the
cgroup interface for this are extensively documented, including in the
email you were replying to.

> I mentioned a real world case of a thread pool servicing customer
> accounts by doing something quite sane: hop into an account (cgroup),
> do work therein, send bean count off to the $$ department, wash, rinse
> repeat.  That's real world users making real world cash registers go ka
> -ching so real world people can pay their real world bills.

Sure, but you're implying that this is the only way to run this real
world cash register. I think it's entirely justified to re-evaluate
this, given the myriad of much more fundamental problems that cgroup2
is solving by building on a common controller model.

I'm not going down the rabbit hole again of arguing against an
incomplete case description. Scale matters. Number of workers
matter. Amount of work each thread does matters to evaluate
transaction overhead. Task migration is an expensive operation etc.

> I also mentioned breakage to cpusets: given exclusive set A and
> exclusive subset B therein, there is one and only one spot where
> affinity A exists... at the to be forbidden junction of A and B.

Again, a means to an end rather than a goal - and a particularly
suspicious one at that: why would a cgroup need to tell its *siblings*
which cpus/nodes in cannot use? In the hierarchical model, it's
clearly the task of the ancestor to allocate the resources downward.

More details would be needed to properly discuss what we are trying to
accomplish here.

> As with the thread pool, process granularity makes it impossible for
> any threaded application affinity to be managed via cpusets, such as
> say stuffing realtime critical threads into a shielded cpuset, mundane
> threads into another.  There are any number of affinity usages that
> will break.

Ditto. It's not obvious why this needs to be the cgroup interface and
couldn't instead be solved with extending sched_setaffinity() - again
weighing that against the power of the common controller model that
could be preserved this way.

> Try as I may, I can't see anything progressive about enforcing process
> granularity of per thread attributes.  I do see regression potential
> for users of these controllers,

I could understand not being entirely happy about the trade-offs if
you look at this from the perspective of a single controller in the
entire resource control subsystem.

But not seeing anything progressive in a common controller model? Have
you read anything we have been writing?

> and no viable means to even report them as being such.  It will
> likely be systemd flipping the V2 on switch, not the kernel, not the
> user.  Regression reports would thus presumably be deflected
> to... those who want this.  Sweet.

There it is...
