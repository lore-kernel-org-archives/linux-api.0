From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Sun, 6 May 2018 12:03:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1805061202550.1685@nanos.tec.linutronix.de>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com> <20180502172218.GL12180@hirez.programming.kicks-ass.net> <CAKOZuesjF8QxfphgsyRKctO89jR9VAM727dspTe7PX1z8KFpyw@mail.gmail.com>
 <20180502202233.GV12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502202233.GV12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Colascione <dancol@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, rostedt@goodmis.org, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, 2 May 2018, Peter Zijlstra wrote:

> On Wed, May 02, 2018 at 06:27:22PM +0000, Daniel Colascione wrote:
> > On Wed, May 2, 2018 at 10:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > >> On Wed, May 02, 2018 at 03:53:47AM +0000, Daniel Colascione wrote:
> > > > Suppose we make a userspace mutex implemented with a lock word having
> > three
> > > > bits: acquired, sleep_mode, and wait_pending, with the rest of the word
> > not
> > > > being relevant at the moment.
> > 
> > > So ideally we'd kill FUTEX_WAIT/FUTEX_WAKE for mutexes entirely, and go
> > > with FUTEX_LOCK/FUTEX_UNLOCK that have the same semantics as the
> > > existing FUTEX_LOCK_PI/FUTEX_UNLOCK_PI, namely, the word contains the
> > > owner TID.
> > 
> > That doesn't work if you want to use the rest of the word for something
> > else, like a recursion count. With FUTEX_WAIT and FUTEX_WAKE, you can make
> > a lock with two bits.
> 
> Recursive locks are teh most horrible crap ever. And having the tid in
> the word allows things like kernel based optimistic spins and possibly
> PI related things.

FWIW, robust futex have also the TID requirement.

Thanks,

	tglx
