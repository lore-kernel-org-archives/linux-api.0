From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Wed, 28 Mar 2018 23:25:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1803282305030.1496@nanos.tec.linutronix.de>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180328125004.GV4043@hirez.programming.kicks-ass.net> <1523662633.2105.1522248474778.JavaMail.zimbra@efficios.com> <20180328145946.GH4082@hirez.programming.kicks-ass.net>
 <265889560.1.1522250045589.JavaMail.zimbra@efficios.com> <20180328152814.GI4082@hirez.programming.kicks-ass.net> <533214853.56.1522251426819.JavaMail.zimbra@efficios.com> <20180328174935.GK4082@hirez.programming.kicks-ass.net>
 <181076499.279.1522268382303.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <181076499.279.1522268382303.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil>
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018, Mathieu Desnoyers wrote:
> ----- On Mar 28, 2018, at 1:49 PM, Peter Zijlstra peterz@infradead.org wrote:
> > I don't think disallowing system calls is arbitrary. And I think that is
> > something we really want to enforce, because it's batshit insane to
> > allow.
> > 
> > And if we allow now, people _will_ use it and we can't ever take it
> > away again.
> 
> Here are some examples of how I would like to use system calls within
> rseq critical sections, for testing purposes:
> 
> - Issue poll(NULL, 0, ms_timeout) from a rseq critical section, to introduce
>   a delay in the critical section and test the effect,

It's simple enough to use a delay loop for that. It's testing after all.

> - Issue sched_yield() from a rseq critical section, to introduce preemption at
>   that point,

Make it loop on a varible and use secondary threads to force preemption.

> - Issue kill() on self, thus testing interruption by signals over rseq c.s.,

Second thread can do that

> - Invoke sched_setaffinity to tweak the cpu affinity mask to force thread
>   migration within a rseq c.s.

Second thread can do that

> I currently have only implemented the poll(), sched_yield() and kill()
> test-cases outside of the rseq critical sections, instead relying on
> assembly loops to introduce delays in rseq c.s.. However, if we disallow
> system calls in rseq critical sections, I'll never be able to use those
> systems calls to extend the test matrix.

All of these tests can be implemented without system calls and there is no
justification to allow system calls just because it makes writing test
cases simpler. Nice try.

> I see other use-cases where having a system call in a rseq critical section
> could make sense: if vDSO data shared between kernel and user-space rely
> on rseq for synchronization, but a fallback sometimes needs to issue a system
> call for part of the operation.

What in the VDSO relies on rseqs? Nothing AFAICT. If the VDSO ever goes to
use that then it's going to be a kernel/vdso specific variant and we'll
figure out how that needs to be handled if at all.

But we are not misdesigning now to accomodate artificial scenarios dreamed
up for argumentation sake,

> Therefore I'd really want to keep allowing system calls within rseq critical
> sections, even though we don't expect this to be the typical use-case.

Syscalls inside rseq sections make no sense whatsoever, unless you can
rollback the message you just sent through the intertubes when the rseq
loop failed the taste test. If that works we might reconsider.

Thanks,

	tglx
