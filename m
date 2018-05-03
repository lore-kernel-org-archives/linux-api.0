From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Wed, 2 May 2018 21:15:36 -0400
Message-ID: <20180502211536.44b560c7@vmware.local.home>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
        <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
        <20180502172218.GL12180@hirez.programming.kicks-ass.net>
        <CAKOZuesjF8QxfphgsyRKctO89jR9VAM727dspTe7PX1z8KFpyw@mail.gmail.com>
        <20180502202233.GV12217@hirez.programming.kicks-ass.net>
        <CAKOZuevUq-XsT632VHU1TQQ5_rGqNROXiZAqv7S+ky=-wcQ3bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuevUq-XsT632VHU1TQQ5_rGqNROXiZAqv7S+ky=-wcQ3bQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Robert Haas <robertmhaas@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 02 May 2018 20:37:13 +0000
Daniel Colascione <dancol@google.com> wrote:

> On Wed, May 2, 2018 at 1:23 PM Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, May 02, 2018 at 06:27:22PM +0000, Daniel Colascione wrote:  
> > > On Wed, May 2, 2018 at 10:22 AM Peter Zijlstra <peterz@infradead.org>  
> wrote:
> > > >> On Wed, May 02, 2018 at 03:53:47AM +0000, Daniel Colascione wrote:
> > > > > Suppose we make a userspace mutex implemented with a lock word  
> having
> > > three  
> > > > > bits: acquired, sleep_mode, and wait_pending, with the rest of the  
> word
> > > not  
> > > > > being relevant at the moment.  
> > >  
> > > > So ideally we'd kill FUTEX_WAIT/FUTEX_WAKE for mutexes entirely, and  
> go
> > > > with FUTEX_LOCK/FUTEX_UNLOCK that have the same semantics as the
> > > > existing FUTEX_LOCK_PI/FUTEX_UNLOCK_PI, namely, the word contains the
> > > > owner TID.  
> > >
> > > That doesn't work if you want to use the rest of the word for something
> > > else, like a recursion count. With FUTEX_WAIT and FUTEX_WAKE, you can  
> make
> > > a lock with two bits.  
> 
> > Recursive locks are teh most horrible crap ever. And having the tid in  
> 
> What happened to providing mechanism, not policy?
> 
> You can't wish away recursive locking. It's baked into Java and the CLR,
> and it's enshrined in POSIX. It's not going away, and there's no reason not
> to support it efficiently.
> 
> > the word allows things like kernel based optimistic spins and possibly
> > PI related things.  
> 
> Sure. A lot of people don't want PI though, or at least they want to opt
> into it. And we shouldn't require an entry into the kernel for what we can
> in principle do efficiently in userspace.
> 
> > > > As brought up in the last time we talked about spin loops, why do we
> > > > care if the spin loop is in userspace or not? Aside from the whole PTI
> > > > thing, the syscall cost was around 150 cycle or so, while a LOCK  
> CMPXCHG
> > > > is around 20 cycles. So ~7 spins gets you the cost of entry. 

What about exit?
 
> > >
> > > That's pre-KPTI, isn't it?  
> 
> > Yes, and once the hardware gets sorted, we'll be there again. I don't
> > think we should design interfaces for 'broken' hardware.  
> 
> It would be a mistake to design interfaces under the assumption that
> everyone has fast permission level transitions.

Note, Robert Haas told me a few years ago at a plumbers conference that
postgresql implements their own user space spin locks because anything
that goes into the kernel has killed the performance. And they tried to
use futex but that still didn't beat out plain userspace locks.

-- Steve
