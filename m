From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 20 Aug 2016 11:56:59 -0400
Message-ID: <20160820155659.GA16906@mtj.duckdns.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Andy.

On Wed, Aug 17, 2016 at 01:18:24PM -0700, Andy Lutomirski wrote:
> >   2-1-1. Process Granularity
> >
> >   For memory, because an address space is shared between all threads
> >   of a process, the terminal consumer is a process, not a thread.
> >   Separating the threads of a single process into different memory
> >   control domains doesn't make semantical sense.  cgroup v2 ensures
> >   that all controller can agree on the same organization by requiring
> >   that threads of the same process belong to the same cgroup.
> 
> I haven't followed all of the history here, but it seems to me that
> this argument is less accurate than it appears.  Linux, for better or
> for worse, has somewhat orthogonal concepts of thread groups
> (processes), mms, and file tables.  An mm has VMAs in it, and VMAs can
> reference things (files, etc) that hold resources.  (Two mms can share
> resources by mapping the same thing or using fork().)  File tables
> hold files, and files can use resources.  Both of these are, at best,
> moderately good approximations of what actually holds resources.
> Meanwhile, threads (tasks) do syscalls, take page faults, *allocate*
> resources, etc.
> 
> So I think it's not really true to say that the "terminal consumer" of
> anything is a process, not a thread.

The terminal consumer is actually the mm context.  A task may be the
allocating entity but not always for itself.

This becomes clear whenever an entity is allocating memory on behalf
of someone else - get_user_pages(), khugepaged, swapoff and so on (and
likely userfaultfd too).  When a task is trying to add a page to a
VMA, the task might not have any relationship with the VMA other than
that it's operating on it for someone else.  The page has to be
charged to whoever is responsible for the VMA and the only ownership
which can be established is the containing mm_struct.

While a mm_struct technically may not map to a process, it is a very
close approxmiation which is hardly ever broken in practice.

> While it's certainly easier to think about assigning processes to
> cgroups, and I certainly agree that, in the common case, it's the
> right thing to do, I don't see why requiring it is a good idea.  Can
> we turn this around: what actually goes wrong if cgroup v2 were to
> allow assigning individual threads if a user specifically requests it?

Consider the scenario where you have somebody faulting on behalf of a
foreign VMA, but the thread who created and is actively using that VMA
is in a different cgroup than the process leader.  Who are we going to
charge?  All possible answers seem erratic.

Please note that I agree that thread granularity can be useful for
some resources; however, my points are 1. it should be scoped so that
the resource distribution tree as a whole can be shared across
different resources, and, 2. cgroup filesystem interface isn't a good
interface for the purpose.  I'll continue the second point below.

> >   there are other reasons to enforce process granularity.  One
> >   important one is isolating system-level management operations from
> >   in-process application operations.  The cgroup interface, being a
> >   virtual filesystem, is very unfit for multiple independent
> >   operations taking place at the same time as most operations have to
> >   be multi-step and there is no way to synchronize multiple accessors.
> >   See also [5] Documentation/cgroup-v2.txt, "R-2. Thread Granularity"
> 
> I don't buy this argument at all.  System-level code is likely to
> assign single process *trees*, which are a different beast entirely.
> I.e. you fork, move the child into a cgroup, and that child and its
> children stay in that cgroup.  I don't see how the thread/process
> distinction matters.

Good point on the multi-process issue, this is something which nagged
me a bit while working on rgroup, although I have to point out that
the issue here is one of not going far enough rather than the approach
being wrong.  There are limitations to scoping it to individual
processes but that doesn't negate the underlying problem or the
usefulness of in-process control.

For system-level and process-level operations to not step on each
other's toes, they need to agree on the granularity boundary -
system-level should be able to treat an application hierarchy as a
single unit.  A possible solution is allowing rgroup hirearchies to
span across process boundaries and implementing cgroup migration
operations which treat such hierarchies as a single unit.  I'm not yet
sure whether the boundary should be at program groups or rgroups.

> On the contrary: with cgroup namespaces, one could easily create a
> cgroup namespace, shove a process in it, and let that process delegate
> its threads to child cgroups however it likes.  (Well, children of the
> namespace root.)

cgroup namespace solves just one piece of the whole problem and not in
a very robust way.  It's okay for containers but not so for individual
applications.

* Using namespace is neither trivial or dependable.  It requires
  explicit mount setups, and, more importantly, an application can't
  rely on a specific namespace setup being there, unlike a
  setpriority() extension.  This affects application designs in the
  first place and severely hampers the accessibility and thus
  usefulness of in-application resource control.

* While it makes the names consistent from inside, it doesn't solve
  the atomicity issues when system and application operate on the
  subtree concurrently.

  Imagine system level operation trying to relocate the namespace.
  While the symbolic names can be made to stay the same before and
  after.  That's about it.  During migration, depending on how
  migration is implemented, some may see path linking back to the old
  or new location.  Even the open files for the filesystem knobs
  wouldn't work after such migration.

* It's just a bad interface if one has to use setpriority(2) to set a
  thread priority but resort to opening a file, parse path, open
  another file, write a number string which uses a completely
  different value range to it for thread groups.

> >   2-1-2. No Internal Process Constraint
> >
> >   cgroup v2 does not allow processes to belong to any cgroup which has
> >   child cgroups when resource controllers are enabled on it (the
> >   notable exception being the root cgroup itself).
> 
> Can you elaborate on this exception?  How do you get any of the
> supposed benefits of not having processes and cgroups exist as
> siblings when you make an exception for the root?  Similarly, if you
> make an exception for the root, what do you do about cgroup namespaces
> where the apparent root isn't the global root?

Having a special case doesn't necessarily get in the way of benefiting
from a set of general rules.  The root cgroup is inherently special as
it has to be the catch-all scope for entities and resource
consumptions which can't be tied to any specific consumer - irq
handling, packet rx, journal writes, memory reclaim from global memory
pressure and so on.  None of sub-cgroups have to worry about them.

These base-system operations are special regardless of cgroup and we
already have sometimes crude ways to affect their behaviors where
necessary through sysctl knobs, priorities on specific kernel threads
and so on.  cgroup doesn't change the situation all that much.  What
gets left in the root cgroup usually are the base-system operations
which are outside the scope of cgroup resource control in the first
place and cgroup resource graph can treat the root as an opaque anchor
point.

There can be other ways to deal with the issue; however, treating root
cgroup this way has the big advantage of minimizing the gap between
configurations without and with cgroups both in terms of mental model
and implementation.

Hopefully, the case of a namespace root is clear now.  If it's gonna
have a sub-hierarchy, it itself can't contain processes but the system
root just contains base-system entities and resources which a
namespace root doesn't have to worry about.  Ignoring base-system
stuff, a namespace root is topologically in the same position as the
system root in the cgroup resource graph.

Thanks.

-- 
tejun
