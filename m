From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Thu, 29 Mar 2018 16:23:38 +0200
Message-ID: <20180329142338.GD4043@hirez.programming.kicks-ass.net>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
 <20180328145946.GH4082@hirez.programming.kicks-ass.net>
 <265889560.1.1522250045589.JavaMail.zimbra@efficios.com>
 <20180328152814.GI4082@hirez.programming.kicks-ass.net>
 <533214853.56.1522251426819.JavaMail.zimbra@efficios.com>
 <20180328174935.GK4082@hirez.programming.kicks-ass.net>
 <181076499.279.1522268382303.JavaMail.zimbra@efficios.com>
 <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de>
 <87410797.545.1522331641598.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87410797.545.1522331641598.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 29, 2018 at 09:54:01AM -0400, Mathieu Desnoyers wrote:
> Let's say we disallow system calls from rseq critical sections. A few points
> arise:
> 
> - We still need to allow traps (page faults, breakpoints, ...) within rseq c.s.,
> 
> - We still need to allow interrupts within rseq c.s.,

Sure, but all those are different entry points, so that shouldn't be a
problem.

> - We need to decide whether we just document that syscalls within rseq c.s.
>   are not supported, or we enforce a behavior if this happens (e.g. SIGSEGV).
>   If we enforce a SIGSEGV, we'd have to figure out whether it's worth it to
>   add extra branches to the system call fast path to validate this.

Without enforcement someone will eventually do this :/ We might (maybe)
get away with it being a debug option somewhere, but even that sounds
like trouble.

> - We need to carefully consider the case of system calls issued within signal
>   handlers nested on top of rseq. When RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL is
>   _not_ set, neither in the rseq c.s. descriptor nor in the TLS @flags,
>   it's pretty much straightforward: upon signal delivery, the kernel moves the
>   ip to abort, and clears the tls @rseq_cs pointer. This means that any system
>   call issued within the signal handler is not actually within the rseq c.s.
>   upon which the signal is nested.
> 
>   The case I worry about is if a thread sets the RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
>   flag in its TLS @flags field (useful in a debugging scenario where we want a
>   debugger to single-step through the rseq c.s. and observe registers at each step).
>   Arguably, this is only ever used in development. However, it does allow a situation
>   where a system call executed within a signal handler can nest over a rseq c.s..
>   So if we choose to be very strict and SIGSEGV any syscall nested over rseq
>   c.s., we may very well end up killing the process for no good reason in this
>   scenario.

Yes, that needs a little thought; but when we run the signal handler,
the IP would no longer be inside the active RSEQ, right?

> - We need to decide whether all syscalls are disallowed, or if we want to pick
>   specific ones (e.g. fork()).

All.
