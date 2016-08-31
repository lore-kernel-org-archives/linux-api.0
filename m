From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 31 Aug 2016 12:57:46 -0700
Message-ID: <CALCETrXDjVi5PreimyWR8MVOPQo+HyuvcG8bhM_g_MZ9EUCeaQ@mail.gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org> <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org> <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160829222048.GH28713-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I'm replying separately to keep the two issues in separate emails.

On Mon, Aug 29, 2016 at 3:20 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Andy.
>
> Sorry about the delay.  Was kinda overwhelmed with other things.
>
> On Sat, Aug 20, 2016 at 11:45:55AM -0700, Andy Lutomirski wrote:
>> > This becomes clear whenever an entity is allocating memory on behalf
>> > of someone else - get_user_pages(), khugepaged, swapoff and so on (and
>> > likely userfaultfd too).  When a task is trying to add a page to a
>> > VMA, the task might not have any relationship with the VMA other than
>> > that it's operating on it for someone else.  The page has to be
>> > charged to whoever is responsible for the VMA and the only ownership
>> > which can be established is the containing mm_struct.
>>
>> This surprises me a bit.  If I do access_process_vm(), then I would
>> have expected the charge to go the caller, not the mm being accessed.
>
> It does and should go the target mm.  Who faults in a page shouldn't
> be the final determinant in the ownership; otherwise, we end up in
> situations where the ownership changes due to, for example,
> fluctuations in page fault pattern.  It doesn't make semantical sense
> either.  If a kthread is doing PIO for a process, why would it get
> charged for the memory it's faulting in?

OK, that makes sense.  Although, given that cgroup1 allows tasks in
the same processes to be split up, how does this work in cgroup1?  Do
you just pick the mm associated with the thread group leader?  If so,
why can't cgroup2 do the same thing?

But even this is at best a vague approximation.  If you have
MAP_SHARED mappings (libc.so, for example), then the cgroup you charge
it to is more or less arbitrary.

>
>> What happens if a program calls read(2), though?  A page may be
>> inserted into page cache on behalf of an address_space without any
>> particular mm being involved.  There will usually be a calling task,
>> though.
>
> Most faults are synchronous and the faulting thread is a member of the
> mm to be charged, so this usually isn't an issue.  I don't think there
> are places where we populate an address_space without knowing who it
> is for (as opposed / in addition to who the operator is).

True, but there's no *mm* involved in any fundamental sense.  You can
look at the task and find the task's mm (or actually the task's thread
group leader, since cgroup2 doesn't literally map mms to cgroups), but
that seems to me to be a pretty poor reason to argue that tasks should
have to be kept together.

>
>> But this is all very memcg-specific.  What about other cgroups?  I/O
>> is per-task, right?  Scheduling is definitely per-task.
>
> They aren't separate.  Think about IOs to write out page cache, CPU
> cycles spent reclaiming memory or encrypting writeback IOs.  It's fine
> to get more granular with specific resources but the semantics gets
> messy for cross-resource accounting and control without proper
> scoping.

Page cache doesn't belong to a a specific mm.  Memory reclaim only has
an mm associated if the memory being reclaimed belongs cleanly to an
mm.  Encrypting writeback (I assume you mean the cpu usage) is just
like page cache writeback IO -- there's no specific mm involved in
general.

>
>> > Consider the scenario where you have somebody faulting on behalf of a
>> > foreign VMA, but the thread who created and is actively using that VMA
>> > is in a different cgroup than the process leader.  Who are we going to
>> > charge?  All possible answers seem erratic.
>>
>> Indeed, and this problem is probably not solvable in practice unless
>> you charge all involved cgroups.  But the caller's *mm* is entirely
>> irrelevant here, so I don't see how this implies that cgroups need to
>> keep tasks in the same process together.  The relevant entities are
>> the calling *task* and the target mm, and you're going to be
>> hard-pressed to ensure that they belong to the same cgroup, so I think
>> you need to be able handle weird cases in which there isn't an
>> obviously correct cgroup to charge.
>
> It is an erratic case which is caused by userland interface allowing
> non-sensical configuration.  We can accept it as a necessary trade-off
> given big enough benefits or unavoidable constraints but it isn't
> something to do willy-nilly.
>
>> > For system-level and process-level operations to not step on each
>> > other's toes, they need to agree on the granularity boundary -
>> > system-level should be able to treat an application hierarchy as a
>> > single unit.  A possible solution is allowing rgroup hirearchies to
>> > span across process boundaries and implementing cgroup migration
>> > operations which treat such hierarchies as a single unit.  I'm not yet
>> > sure whether the boundary should be at program groups or rgroups.
>>
>> I think that, if the system cgroup manager is moving processes around
>> after starting them and execing the final binary, there will be races
>> and confusion, and no about of granularity fiddling will fix that.
>
> I don't see how that statement is true.  For example, if you confine
> the hierarhcy to in-process, there is proper isolation and whether
> system agent migrates the process or not doesn't make any difference
> to the internal hierarchy.

But hierarchy isn't always per process.  Some real-world services have
threads and subprocesses.

>
>> I know nothing about rgroups.  Are they upstream?
>
> It was linked from the original message.
>
> [7]  http://lkml.kernel.org/r/20160105154503.GC5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org
>      [RFD] cgroup: thread granularity support for cpu controller
>      Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I can see two issues here:

1. You're allowing groups and tasks to be siblings.  If you're okay
allowing that for rgroups, why not allow it for cgroup2 on the same
set of controllers?

2. It looks impossible to fork and keep a child in the same group as
one of your non-leader threads.

I think I'm starting to agree with PeterZ here.  Why not just make
cgroup2 more flexible?

--Andy
