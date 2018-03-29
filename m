From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Thu, 29 Mar 2018 09:54:01 -0400 (EDT)
Message-ID: <87410797.545.1522331641598.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180328145946.GH4082@hirez.programming.kicks-ass.net> <265889560.1.1522250045589.JavaMail.zimbra@efficios.com> <20180328152814.GI4082@hirez.programming.kicks-ass.net> <533214853.56.1522251426819.JavaMail.zimbra@efficios.com> <20180328174935.GK4082@hirez.programming.kicks-ass.net> <181076499.279.1522268382303.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 5:25 PM, Thomas Gleixner tglx@linutronix.de wrote:

> On Wed, 28 Mar 2018, Mathieu Desnoyers wrote:
>> ----- On Mar 28, 2018, at 1:49 PM, Peter Zijlstra peterz@infradead.org wrote:
>> > I don't think disallowing system calls is arbitrary. And I think that is
>> > something we really want to enforce, because it's batshit insane to
>> > allow.
>> > 
>> > And if we allow now, people _will_ use it and we can't ever take it
>> > away again.
>> 
>> Here are some examples of how I would like to use system calls within
>> rseq critical sections, for testing purposes:
>> 
>> - Issue poll(NULL, 0, ms_timeout) from a rseq critical section, to introduce
>>   a delay in the critical section and test the effect,
> 
> It's simple enough to use a delay loop for that. It's testing after all.
> 
>> - Issue sched_yield() from a rseq critical section, to introduce preemption at
>>   that point,
> 
> Make it loop on a varible and use secondary threads to force preemption.
> 
>> - Issue kill() on self, thus testing interruption by signals over rseq c.s.,
> 
> Second thread can do that
> 
>> - Invoke sched_setaffinity to tweak the cpu affinity mask to force thread
>>   migration within a rseq c.s.
> 
> Second thread can do that
> 
>> I currently have only implemented the poll(), sched_yield() and kill()
>> test-cases outside of the rseq critical sections, instead relying on
>> assembly loops to introduce delays in rseq c.s.. However, if we disallow
>> system calls in rseq critical sections, I'll never be able to use those
>> systems calls to extend the test matrix.
> 
> All of these tests can be implemented without system calls and there is no
> justification to allow system calls just because it makes writing test
> cases simpler. Nice try.

You bring good points. As a logical consequence, I indeed don't need to issue
system calls from rseq c.s. for testing.

> 
>> I see other use-cases where having a system call in a rseq critical section
>> could make sense: if vDSO data shared between kernel and user-space rely
>> on rseq for synchronization, but a fallback sometimes needs to issue a system
>> call for part of the operation.
> 
> What in the VDSO relies on rseqs? Nothing AFAICT. If the VDSO ever goes to
> use that then it's going to be a kernel/vdso specific variant and we'll
> figure out how that needs to be handled if at all.

Sure, and we can craft the vDSO so the system call does not need to be
issued within a rseq c.s.. So this one is a non-issue I think.

> 
> But we are not misdesigning now to accomodate artificial scenarios dreamed
> up for argumentation sake,

If we decide to impose limitations on the rseq c.s. abilities, we need to
think this through very carefully.

Let's say we disallow system calls from rseq critical sections. A few points
arise:

- We still need to allow traps (page faults, breakpoints, ...) within rseq c.s.,

- We still need to allow interrupts within rseq c.s.,

- We need to decide whether we just document that syscalls within rseq c.s.
  are not supported, or we enforce a behavior if this happens (e.g. SIGSEGV).
  If we enforce a SIGSEGV, we'd have to figure out whether it's worth it to
  add extra branches to the system call fast path to validate this.

- If we document that syscalls are not supported within rseq c.s., we should
  specify whether doing so terminates the process, or if it merely does not
  guarantee proper abort behavior of the critical section.

- We need to carefully consider the case of system calls issued within signal
  handlers nested on top of rseq. When RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL is
  _not_ set, neither in the rseq c.s. descriptor nor in the TLS @flags,
  it's pretty much straightforward: upon signal delivery, the kernel moves the
  ip to abort, and clears the tls @rseq_cs pointer. This means that any system
  call issued within the signal handler is not actually within the rseq c.s.
  upon which the signal is nested.

  The case I worry about is if a thread sets the RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
  flag in its TLS @flags field (useful in a debugging scenario where we want a
  debugger to single-step through the rseq c.s. and observe registers at each step).
  Arguably, this is only ever used in development. However, it does allow a situation
  where a system call executed within a signal handler can nest over a rseq c.s..
  So if we choose to be very strict and SIGSEGV any syscall nested over rseq
  c.s., we may very well end up killing the process for no good reason in this
  scenario.

- We need to decide whether all syscalls are disallowed, or if we want to pick
  specific ones (e.g. fork()).

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
