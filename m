From: Tejun Heo <tj@kernel.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Tue, 4 Oct 2016 10:47:17 -0400
Message-ID: <20161004144717.GA4205@htj.duckdns.org>
References: <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160906102950.GK10153@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160906102950.GK10153@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hello, Peter.

On Tue, Sep 06, 2016 at 12:29:50PM +0200, Peter Zijlstra wrote:
> The fundamental problem is that we have 2 different types of
> controllers, on the one hand these controllers above, that work on tasks
> and form groups of them and build up from that. Lets call them
> task-controllers.
> 
> On the other hand we have controllers like memcg which take the 'system'
> as a whole and shrink it down into smaller bits. Lets call these
> system-controllers.
>
> They are fundamentally at odds with capabilities, simply because of the
> granularity they can work on.

As pointed out multiple times, the picture is not that simple.  For
example, eventually, we want to be able to account for cpu cycles
spent during memory reclaim or processing IOs (e.g. encryption), which
can only be tied to the resource domain, not a specific task.

There surely are things that can only be done by task-level
controllers, but there are two different aspects here.  One is the
actual capabilities (e.g. hierarchical proportional cpu cycle
distribution) and the other is how such capabilities are exposed.
I'll continue below.

> Merging the two into a common hierarchy is a useful concept for
> containerization, no argument on that, esp. when also coupled with
> namespaces and the like.

Great, we now agree that comprehensive system resource control is
useful.

> However, where I object _most_ strongly is having this one use dominate
> and destroy the capabilities (which are in use) of the task-controllers.

The objection isn't necessarily just about loss of capabilities but
also about not being able to do them in the same way as v1.  The
reason I proposed rgroup instead of scoped task-granularity is because
I think that a properly insulated programmable interface which is
inline with other widely used APIs is a better solution in the long
run.

If we go cgroupfs route for thread granularity, we pretty much lose
the possibility, or at least make it very difficult, to make
hierarchical resource control widely available to individual
applications.

How important such use cases are is debatable.  I don't find it too
difficult to imagine scenarios where individual applications like
apache or torrent clients make use of it.  Probably more importantly,
rgroup, or something like it, gives an application an officially
supported way to build and expose their resource hierarchies, which
can then be used by both the application itself and outside to monitor
and manipulate resource distribution.

The decision between cgroupfs thread granularity and something like
rgroup isn't an obvious one.  Choosing the former is the path of lower
resistance but it is so at the cost of certain long-term benefits.

> > It could be made to work without races, though, with minimal (or even
> > no) ABI change.  The managed program could grab an fd pointing to its
> > cgroup.  Then it would use openat, etc for all operations.  As long as
> > 'mv /cgroup/a/b /cgroup/c/" didn't cause that fd to stop working,
> > we're fine.
> 
> I've mentioned openat() and related APIs several times, but so far never
> got good reasons why that wouldn't work.

Hopefully, this part was addressed in my reply to Andy.

> cgroup-v2, by placing the system style controllers first and foremost,
> completely renders that scenario impossible. Note also that any proposed
> rgroup would not work for this, since that, per design, is a subtree,
> and therefore not disjoint.

If a use case absolutely requires disjoint resource hierarchies, the
only solution is to keep using multiple v1 hierarchies, which
necessarily excludes the possibility of doing anyting across different
resource types.

> So my objection to the whole cgroup-v2 model and implementation stems
> from the fact that it purports to be a 'better' and 'improved' system,
> while in actuality it neuters and destroys a lot of useful usecases.
> 
> It completely disregards all task-controllers and labels their use-cases
> as irrelevant.

Your objection then doesn't have much to do with the specifics of the
cgroup v2 model or implementation.  It's an objection against
establishing common resource domains as that excludes building
orthogonal multiple hierarchies.  That, necessarily, can only be
achieved by having multiple hierarchies for different resource types
and thus giving up the benefits of common resource domains.

Assuming that, I don't think your position is against cgroup v2 but
more toward keeping v1 around.  We're talking about two quite
different mutually exclusive classes of use cases.  You need unified
for one and disjoint for the other.  v1 is gonna be there and can
easily be used alongside v2 for different controller types, which
would in most cases be cpu and cpuset.

I can't see a reason why this would need to block properly supporting
containerization use cases.

Thanks.

-- 
tejun
