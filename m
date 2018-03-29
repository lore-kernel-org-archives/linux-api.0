From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Thu, 29 Mar 2018 11:39:00 -0400 (EDT)
Message-ID: <544124089.623.1522337940950.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180328152814.GI4082@hirez.programming.kicks-ass.net> <533214853.56.1522251426819.JavaMail.zimbra@efficios.com> <20180328174935.GK4082@hirez.programming.kicks-ass.net> <181076499.279.1522268382303.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de> <87410797.545.1522331641598.JavaMail.zimbra@efficios.com> <20180329142338.GD4043@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180329142338.GD4043@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 29, 2018, at 10:23 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Thu, Mar 29, 2018 at 09:54:01AM -0400, Mathieu Desnoyers wrote:
>> Let's say we disallow system calls from rseq critical sections. A few points
>> arise:
>> 
>> - We still need to allow traps (page faults, breakpoints, ...) within rseq c.s.,
>> 
>> - We still need to allow interrupts within rseq c.s.,
> 
> Sure, but all those are different entry points, so that shouldn't be a
> problem.

Yes, indeed.

> 
>> - We need to decide whether we just document that syscalls within rseq c.s.
>>   are not supported, or we enforce a behavior if this happens (e.g. SIGSEGV).
>>   If we enforce a SIGSEGV, we'd have to figure out whether it's worth it to
>>   add extra branches to the system call fast path to validate this.
> 
> Without enforcement someone will eventually do this :/ We might (maybe)
> get away with it being a debug option somewhere, but even that sounds
> like trouble.

I find it unlikely that someone will issue a syscall from a rseq critical
section without really intending it. The system call would need to be
crafted within the rseq assembly block.

Enforcing SIGSEGV on syscall entry when nested in a rseq critical section
will not be free both in terms of syscall overhead, and in terms of code
maintenance: we'd need to add those checks into entry.S for each architecture
supported, which pretty much doubles the amount of architecture-specific
code we need to implement for rseq. Currently, all we need is to hook in
signal delivery and wire up the system call numbers.

If there is some clever arch-agnostic way to enforce SIGSEGV in those
situations, I'm all ears. But I don't think it's worthwhile to enforce
this if it costs in terms of system call speed and adds extra arch-specific
code to maintain.

We could simply document that issuing a system call within a rseq critical
section will cause the restart behavior (whether the critical section is
restarted or not) to be undefined.

> 
>> - We need to carefully consider the case of system calls issued within signal
>>   handlers nested on top of rseq. When RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL is
>>   _not_ set, neither in the rseq c.s. descriptor nor in the TLS @flags,
>>   it's pretty much straightforward: upon signal delivery, the kernel moves the
>>   ip to abort, and clears the tls @rseq_cs pointer. This means that any system
>>   call issued within the signal handler is not actually within the rseq c.s.
>>   upon which the signal is nested.
>> 
>>   The case I worry about is if a thread sets the RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
>>   flag in its TLS @flags field (useful in a debugging scenario where we want a
>>   debugger to single-step through the rseq c.s. and observe registers at each
>>   step).
>>   Arguably, this is only ever used in development. However, it does allow a
>>   situation
>>   where a system call executed within a signal handler can nest over a rseq c.s..
>>   So if we choose to be very strict and SIGSEGV any syscall nested over rseq
>>   c.s., we may very well end up killing the process for no good reason in this
>>   scenario.
> 
> Yes, that needs a little thought; but when we run the signal handler,
> the IP would no longer be inside the active RSEQ, right?

Good point, I missed that. So yes, even with the RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
flag set, the instruction pointer comparison would detect that we're not actually
running in the rseq critical section if a syscall is issued from the signal handler.

> 
>> - We need to decide whether all syscalls are disallowed, or if we want to pick
>>   specific ones (e.g. fork()).
> 
> All.

I'm fine with that.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
