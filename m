From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Mon, 29 Aug 2016 18:20:48 -0400
Message-ID: <20160829222048.GH28713@mtj.duckdns.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org>
 <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Andy.

Sorry about the delay.  Was kinda overwhelmed with other things.

On Sat, Aug 20, 2016 at 11:45:55AM -0700, Andy Lutomirski wrote:
> > This becomes clear whenever an entity is allocating memory on behalf
> > of someone else - get_user_pages(), khugepaged, swapoff and so on (and
> > likely userfaultfd too).  When a task is trying to add a page to a
> > VMA, the task might not have any relationship with the VMA other than
> > that it's operating on it for someone else.  The page has to be
> > charged to whoever is responsible for the VMA and the only ownership
> > which can be established is the containing mm_struct.
> 
> This surprises me a bit.  If I do access_process_vm(), then I would
> have expected the charge to go the caller, not the mm being accessed.

It does and should go the target mm.  Who faults in a page shouldn't
be the final determinant in the ownership; otherwise, we end up in
situations where the ownership changes due to, for example,
fluctuations in page fault pattern.  It doesn't make semantical sense
either.  If a kthread is doing PIO for a process, why would it get
charged for the memory it's faulting in?

> What happens if a program calls read(2), though?  A page may be
> inserted into page cache on behalf of an address_space without any
> particular mm being involved.  There will usually be a calling task,
> though.

Most faults are synchronous and the faulting thread is a member of the
mm to be charged, so this usually isn't an issue.  I don't think there
are places where we populate an address_space without knowing who it
is for (as opposed / in addition to who the operator is).

> But this is all very memcg-specific.  What about other cgroups?  I/O
> is per-task, right?  Scheduling is definitely per-task.

They aren't separate.  Think about IOs to write out page cache, CPU
cycles spent reclaiming memory or encrypting writeback IOs.  It's fine
to get more granular with specific resources but the semantics gets
messy for cross-resource accounting and control without proper
scoping.

> > Consider the scenario where you have somebody faulting on behalf of a
> > foreign VMA, but the thread who created and is actively using that VMA
> > is in a different cgroup than the process leader.  Who are we going to
> > charge?  All possible answers seem erratic.
> 
> Indeed, and this problem is probably not solvable in practice unless
> you charge all involved cgroups.  But the caller's *mm* is entirely
> irrelevant here, so I don't see how this implies that cgroups need to
> keep tasks in the same process together.  The relevant entities are
> the calling *task* and the target mm, and you're going to be
> hard-pressed to ensure that they belong to the same cgroup, so I think
> you need to be able handle weird cases in which there isn't an
> obviously correct cgroup to charge.

It is an erratic case which is caused by userland interface allowing
non-sensical configuration.  We can accept it as a necessary trade-off
given big enough benefits or unavoidable constraints but it isn't
something to do willy-nilly.

> > For system-level and process-level operations to not step on each
> > other's toes, they need to agree on the granularity boundary -
> > system-level should be able to treat an application hierarchy as a
> > single unit.  A possible solution is allowing rgroup hirearchies to
> > span across process boundaries and implementing cgroup migration
> > operations which treat such hierarchies as a single unit.  I'm not yet
> > sure whether the boundary should be at program groups or rgroups.
> 
> I think that, if the system cgroup manager is moving processes around
> after starting them and execing the final binary, there will be races
> and confusion, and no about of granularity fiddling will fix that.

I don't see how that statement is true.  For example, if you confine
the hierarhcy to in-process, there is proper isolation and whether
system agent migrates the process or not doesn't make any difference
to the internal hierarchy.

> I know nothing about rgroups.  Are they upstream?

It was linked from the original message.

[7]  http://lkml.kernel.org/r/20160105154503.GC5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org
     [RFD] cgroup: thread granularity support for cpu controller
     Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

[8]  http://lkml.kernel.org/r/1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
     [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource group and PRIO_RGRP
     Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

[9]  http://lkml.kernel.org/r/20160311160522.GA24046-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org
     Example program for PRIO_RGRP
     Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> > These base-system operations are special regardless of cgroup and we
> > already have sometimes crude ways to affect their behaviors where
> > necessary through sysctl knobs, priorities on specific kernel threads
> > and so on.  cgroup doesn't change the situation all that much.  What
> > gets left in the root cgroup usually are the base-system operations
> > which are outside the scope of cgroup resource control in the first
> > place and cgroup resource graph can treat the root as an opaque anchor
> > point.
> 
> This seems to explain why the controllers need to be able to handle
> things being charged to the root cgroup (or to an unidentifiable
> cgroup, anyway).  That isn't quite the same thing as allowing, from an
> ABI point of view, the root cgroup to contain processes and cgroups
> but not allowing other cgroups to do the same thing.  Consider:

The points are 1. we need the root to be a special container anyway
2. allowing it to be special and contain system-wide consumptions
doesn't make the resource graph inconsistent once all non-system-wide
consumptions are put in non-root cgroups, and 3. this is the most
natural way to handle the situation both from implementation and
interface standpoints as it makes non-cgroup configuration a natural
degenerate case of cgroup configuration.

> suppose that systemd (or some competing cgroup manager) is designed to
> run in the root cgroup namespace.  It presumably expects *itself* to
> be in the root cgroup.  Now try to run it using cgroups v2 in a
> non-root namespace.  I don't see how it can possibly work if it the
> hierarchy constraints don't permit it to create sub-cgroups while it's
> still in the root.  In fact, this seems impossible to fix even with
> user code changes.  The manager would need to simultaneously create a
> new child cgroup to contain itself and assign itself to that child
> cgroup, because the intermediate state is illegal.

Please re-read the constraint.  It doesn't prevent any organizational
operations before resource control is enabled.

> I really, really think that cgroup v2 should supply the same
> *interface* inside and outside of a non-root namespace.  If this is

It *does*.  That's what I tried to explain, that it's exactly
isomorhpic once you discount the system-wide consumptions.

Thanks.

-- 
tejun
