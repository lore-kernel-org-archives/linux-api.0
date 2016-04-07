From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 07:35:26 -0700
Message-ID: <CALCETrV0vcYcnBrs0axykJD=_BM28wKWVMG6bMzK8zh8R3m5fg@mail.gmail.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com> <20160407120254.GY3448@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407120254.GY3448-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Apr 7, 2016 5:02 AM, "Peter Zijlstra" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Wed, Apr 06, 2016 at 08:56:33AM -0700, Andy Lutomirski wrote:
> > What are the useful commit operations?  IIUC they probably need to be
> > single instructions, which makes it sound like they're all either RMW
> > or store operations.  I think that plain stores are sufficient to
> > emulate RMW since (1) if the value changes out from under you, you'll
> > abort, and (2) most CPUs don't have single instruction RMW anyway.
>
> Yeah so stores are sufficient. The only requirement is that the store is
> a single operation/instruction. So you can typically not commit anything
> wider than the native word size.
>
> > We could probably speed up commits and make the code a bit more
> > obvious by feeding the kernel a pointer to a descriptor instead of
> > feeding it individual values.  For example, the descriptor could be:
>
> See the Thread-Local-ABI effort by Mathieu, the idea is to get a single
> full cacheline (64bytes) fixed size thingy allocated at a fixed offset
> to the TCB.
>
> That way we can reduce to %[gf]s:offset for these here variables (I
> forever forget which segment register userspace uses for TLS).

What I meant was: rather than shoving individual values into the TLABI
thing, shove in a pointer:

struct commit_info {
  u64 post_commit_rip;
  u32 cpu;
  u64 *event;
  // whatever else;
};

and then put a commit_info* in TLABI.

This would save some bytes in the TLABI structure.

>
> > Is your scheme safe against signals that are delivered during commit?
> > Would the signal context need to save and zero the commit state?
>
> The patches you comment on here explicitly update the event from the
> signal frame setup and thereby handle this.
>
> The update not only increments the sequence count, but also tests the
> post_commit_ip thing, if set it assigns fail value to regs->ip (ie the
> commit fails).
>
> tl;dr, yes its safe against signals happening during commit.

That's not quite what I meant -- see below.

>
> > I still want to see if we can get away from the kernel-managed event
> > counter.  Would the following work:
> >
> > start_sequence:
> >  read current CPU number
> >  change event counter
> >  re-read current CPU number [1]
> >
> > commit:
> >   tell kernel we're committing
> >   re-check event counter and CPU number
> >   do the commit instruction
> >   tell kernel we're done committing
> >
> > [1] avoids a memory ordering issue if we migrate before changing the
> > event counter
>
> So currently the event and cpu form a single 64bit value, so that on
> 64bit we can use a single load and cmp to verify them.
>
> So letting the user manage the event is doable, but it would still be
> advisable to have the event in the same shared word.
>

Why is a single load needed?  The event and CPU in the TLABI structure
are only ever accessed from the thread in question.

> > The kernel forces an abort if, on resume from any kernel entry, the
> > CPU number or event counter is wrong.
> >
> > If this worked, then it would be inherently debuggable, since the only
> > way that it would abort in a single-threaded situation is if it
> > migrated during commit.
>
> (or a signal happened, as per the below)
>
> Tempting.. not signal safe though, although I suppose we can still
> explicitly do the:
>
>   if (regs->ip < post_commit_ip)
>     regs->ip = regs->rcx;
>
> thing on signal frame setup to abort any in-flight commit without
> explicitly incrementing the sequence number.

What I meant was: what if we did it a bit differently?  On signal
delivery, we could stash post_commit_ip, etc in the signal context and
then zero them out.  On sigreturn, we would restore them from the
signal frame back into TLABI and then, before resuming userspace, we'd
check for an abort.

That way we could take an async signal, handle it, and resume, even in
the middle of a commit, without aborting.  Of course, if the signal
hander tried to access the same rseq-protected resource, it would bump
the event counter and cause an abort.

I think it's safe in the sense that a signal will abort a commit
operation.  I'm wondering if we can do better: what if a signal could
avoid interfering with commit unless it would actually conflict?s food
for thought: what if, instead of aborting

--Andy
