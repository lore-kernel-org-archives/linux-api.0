From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Thu, 7 Apr 2016 14:02:54 +0200
Message-ID: <20160407120254.GY3448@twins.programming.kicks-ass.net>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
 <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW=3bZyC9d5tUoESEsNt-rc-uhNhZpgEgeSC8W4FAVYkg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paul Turner <commonly@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Lameter <cl@linux.com>, Andi Kleen <andi@firstfloor.org>, Josh Triplett <josh@joshtriplett.org>, Dave Watson <davejwatson@fb.com>, Andrew Hunter <ahh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 06, 2016 at 08:56:33AM -0700, Andy Lutomirski wrote:
> What are the useful commit operations?  IIUC they probably need to be
> single instructions, which makes it sound like they're all either RMW
> or store operations.  I think that plain stores are sufficient to
> emulate RMW since (1) if the value changes out from under you, you'll
> abort, and (2) most CPUs don't have single instruction RMW anyway.

Yeah so stores are sufficient. The only requirement is that the store is
a single operation/instruction. So you can typically not commit anything
wider than the native word size.

> We could probably speed up commits and make the code a bit more
> obvious by feeding the kernel a pointer to a descriptor instead of
> feeding it individual values.  For example, the descriptor could be:

See the Thread-Local-ABI effort by Mathieu, the idea is to get a single
full cacheline (64bytes) fixed size thingy allocated at a fixed offset
to the TCB.

That way we can reduce to %[gf]s:offset for these here variables (I
forever forget which segment register userspace uses for TLS).

> Is your scheme safe against signals that are delivered during commit?
> Would the signal context need to save and zero the commit state?

The patches you comment on here explicitly update the event from the
signal frame setup and thereby handle this.

The update not only increments the sequence count, but also tests the
post_commit_ip thing, if set it assigns fail value to regs->ip (ie the
commit fails).

tl;dr, yes its safe against signals happening during commit.

> I still want to see if we can get away from the kernel-managed event
> counter.  Would the following work:
> 
> start_sequence:
>  read current CPU number
>  change event counter
>  re-read current CPU number [1]
> 
> commit:
>   tell kernel we're committing
>   re-check event counter and CPU number
>   do the commit instruction
>   tell kernel we're done committing
> 
> [1] avoids a memory ordering issue if we migrate before changing the
> event counter

So currently the event and cpu form a single 64bit value, so that on
64bit we can use a single load and cmp to verify them.

So letting the user manage the event is doable, but it would still be
advisable to have the event in the same shared word.

> The kernel forces an abort if, on resume from any kernel entry, the
> CPU number or event counter is wrong.
> 
> If this worked, then it would be inherently debuggable, since the only
> way that it would abort in a single-threaded situation is if it
> migrated during commit.

(or a signal happened, as per the below)

Tempting.. not signal safe though, although I suppose we can still
explicitly do the:

  if (regs->ip < post_commit_ip)
    regs->ip = regs->rcx;

thing on signal frame setup to abort any in-flight commit without
explicitly incrementing the sequence number.

Not having to mange the event count from kernel reduces the kernel work
to migration only -- ie. we can get rid of the preemption hook and
reduce overhead there, something I'm entirely happy with if possible.
