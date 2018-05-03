From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Thu, 3 May 2018 10:49:06 +0200
Message-ID: <20180503084906.GW12217@hirez.programming.kicks-ass.net>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
 <20180502172218.GL12180@hirez.programming.kicks-ass.net>
 <CAKOZuesjF8QxfphgsyRKctO89jR9VAM727dspTe7PX1z8KFpyw@mail.gmail.com>
 <20180502202233.GV12217@hirez.programming.kicks-ass.net>
 <CAKOZuevUq-XsT632VHU1TQQ5_rGqNROXiZAqv7S+ky=-wcQ3bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuevUq-XsT632VHU1TQQ5_rGqNROXiZAqv7S+ky=-wcQ3bQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, rostedt@goodmis.org, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 02, 2018 at 08:37:13PM +0000, Daniel Colascione wrote:
> > Recursive locks are teh most horrible crap ever. And having the tid in
> 
> What happened to providing mechanism, not policy?
> 
> You can't wish away recursive locking. It's baked into Java and the CLR,
> and it's enshrined in POSIX. It's not going away, and there's no reason not
> to support it efficiently.

You can implement recursive locks just fine with a TID based word, just
keep the recursion counter external to the futex word. If owner==self,
increment etc..

> > the word allows things like kernel based optimistic spins and possibly
> > PI related things.
> 
> Sure. A lot of people don't want PI though, or at least they want to opt
> into it. And we shouldn't require an entry into the kernel for what we can
> in principle do efficiently in userspace.

Any additional PI would certainly be opt-in, but the kernel based
spinning might make sense unconditionally.
