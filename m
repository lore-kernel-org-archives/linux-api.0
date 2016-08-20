From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 20 Aug 2016 11:45:55 -0700
Message-ID: <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org> <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160820155659.GA16906@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Sat, Aug 20, 2016 at 8:56 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Andy.
>
> On Wed, Aug 17, 2016 at 01:18:24PM -0700, Andy Lutomirski wrote:
>> >   2-1-1. Process Granularity
>> >
>> >   For memory, because an address space is shared between all threads
>> >   of a process, the terminal consumer is a process, not a thread.
>> >   Separating the threads of a single process into different memory
>> >   control domains doesn't make semantical sense.  cgroup v2 ensures
>> >   that all controller can agree on the same organization by requiring
>> >   that threads of the same process belong to the same cgroup.
>>
>> I haven't followed all of the history here, but it seems to me that
>> this argument is less accurate than it appears.  Linux, for better or
>> for worse, has somewhat orthogonal concepts of thread groups
>> (processes), mms, and file tables.  An mm has VMAs in it, and VMAs can
>> reference things (files, etc) that hold resources.  (Two mms can share
>> resources by mapping the same thing or using fork().)  File tables
>> hold files, and files can use resources.  Both of these are, at best,
>> moderately good approximations of what actually holds resources.
>> Meanwhile, threads (tasks) do syscalls, take page faults, *allocate*
>> resources, etc.
>>
>> So I think it's not really true to say that the "terminal consumer" of
>> anything is a process, not a thread.
>
> The terminal consumer is actually the mm context.  A task may be the
> allocating entity but not always for itself.
>
> This becomes clear whenever an entity is allocating memory on behalf
> of someone else - get_user_pages(), khugepaged, swapoff and so on (and
> likely userfaultfd too).  When a task is trying to add a page to a
> VMA, the task might not have any relationship with the VMA other than
> that it's operating on it for someone else.  The page has to be
> charged to whoever is responsible for the VMA and the only ownership
> which can be established is the containing mm_struct.

This surprises me a bit.  If I do access_process_vm(), then I would
have expected the charge to go the caller, not the mm being accessed.

What happens if a program calls read(2), though?  A page may be
inserted into page cache on behalf of an address_space without any
particular mm being involved.  There will usually be a calling task,
though.

But this is all very memcg-specific.  What about other cgroups?  I/O
is per-task, right?  Scheduling is definitely per-task.

>
> While a mm_struct technically may not map to a process, it is a very
> close approxmiation which is hardly ever broken in practice.
>
>> While it's certainly easier to think about assigning processes to
>> cgroups, and I certainly agree that, in the common case, it's the
>> right thing to do, I don't see why requiring it is a good idea.  Can
>> we turn this around: what actually goes wrong if cgroup v2 were to
>> allow assigning individual threads if a user specifically requests it?
>
> Consider the scenario where you have somebody faulting on behalf of a
> foreign VMA, but the thread who created and is actively using that VMA
> is in a different cgroup than the process leader.  Who are we going to
> charge?  All possible answers seem erratic.
>

Indeed, and this problem is probably not solvable in practice unless
you charge all involved cgroups.  But the caller's *mm* is entirely
irrelevant here, so I don't see how this implies that cgroups need to
keep tasks in the same process together.  The relevant entities are
the calling *task* and the target mm, and you're going to be
hard-pressed to ensure that they belong to the same cgroup, so I think
you need to be able handle weird cases in which there isn't an
obviously correct cgroup to charge.

>> >   there are other reasons to enforce process granularity.  One
>> >   important one is isolating system-level management operations from
>> >   in-process application operations.  The cgroup interface, being a
>> >   virtual filesystem, is very unfit for multiple independent
>> >   operations taking place at the same time as most operations have to
>> >   be multi-step and there is no way to synchronize multiple accessors.
>> >   See also [5] Documentation/cgroup-v2.txt, "R-2. Thread Granularity"
>>
>> I don't buy this argument at all.  System-level code is likely to
>> assign single process *trees*, which are a different beast entirely.
>> I.e. you fork, move the child into a cgroup, and that child and its
>> children stay in that cgroup.  I don't see how the thread/process
>> distinction matters.
>
> Good point on the multi-process issue, this is something which nagged
> me a bit while working on rgroup, although I have to point out that
> the issue here is one of not going far enough rather than the approach
> being wrong.  There are limitations to scoping it to individual
> processes but that doesn't negate the underlying problem or the
> usefulness of in-process control.
>
> For system-level and process-level operations to not step on each
> other's toes, they need to agree on the granularity boundary -
> system-level should be able to treat an application hierarchy as a
> single unit.  A possible solution is allowing rgroup hirearchies to
> span across process boundaries and implementing cgroup migration
> operations which treat such hierarchies as a single unit.  I'm not yet
> sure whether the boundary should be at program groups or rgroups.

I think that, if the system cgroup manager is moving processes around
after starting them and execing the final binary, there will be races
and confusion, and no about of granularity fiddling will fix that.

I know nothing about rgroups.  Are they upstream?


>
>> >   2-1-2. No Internal Process Constraint
>> >
>> >   cgroup v2 does not allow processes to belong to any cgroup which has
>> >   child cgroups when resource controllers are enabled on it (the
>> >   notable exception being the root cgroup itself).
>>
>> Can you elaborate on this exception?  How do you get any of the
>> supposed benefits of not having processes and cgroups exist as
>> siblings when you make an exception for the root?  Similarly, if you
>> make an exception for the root, what do you do about cgroup namespaces
>> where the apparent root isn't the global root?
>
> Having a special case doesn't necessarily get in the way of benefiting
> from a set of general rules.  The root cgroup is inherently special as
> it has to be the catch-all scope for entities and resource
> consumptions which can't be tied to any specific consumer - irq
> handling, packet rx, journal writes, memory reclaim from global memory
> pressure and so on.  None of sub-cgroups have to worry about them.
>
> These base-system operations are special regardless of cgroup and we
> already have sometimes crude ways to affect their behaviors where
> necessary through sysctl knobs, priorities on specific kernel threads
> and so on.  cgroup doesn't change the situation all that much.  What
> gets left in the root cgroup usually are the base-system operations
> which are outside the scope of cgroup resource control in the first
> place and cgroup resource graph can treat the root as an opaque anchor
> point.

This seems to explain why the controllers need to be able to handle
things being charged to the root cgroup (or to an unidentifiable
cgroup, anyway).  That isn't quite the same thing as allowing, from an
ABI point of view, the root cgroup to contain processes and cgroups
but not allowing other cgroups to do the same thing.  Consider:
suppose that systemd (or some competing cgroup manager) is designed to
run in the root cgroup namespace.  It presumably expects *itself* to
be in the root cgroup.  Now try to run it using cgroups v2 in a
non-root namespace.  I don't see how it can possibly work if it the
hierarchy constraints don't permit it to create sub-cgroups while it's
still in the root.  In fact, this seems impossible to fix even with
user code changes.  The manager would need to simultaneously create a
new child cgroup to contain itself and assign itself to that child
cgroup, because the intermediate state is illegal.

I really, really think that cgroup v2 should supply the same
*interface* inside and outside of a non-root namespace.  If this is
impossible due to ABI compatibility, then you could, in the worst
case, introduce cgroup v3, fix it there, and remove cgroup v2, since
apparently cgroup v2 isn't in use right now in mainline kernels.  (To
be clear, I think either decision -- allowing tasks and cgroups to be
siblings or disallowing it -- is okay, but I think that the interface
should apply the same constraint at all levels.)

--Andy
