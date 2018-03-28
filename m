From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 16:19:42 -0400 (EDT)
Message-ID: <181076499.279.1522268382303.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180328125004.GV4043@hirez.programming.kicks-ass.net> <1523662633.2105.1522248474778.JavaMail.zimbra@efficios.com> <20180328145946.GH4082@hirez.programming.kicks-ass.net> <265889560.1.1522250045589.JavaMail.zimbra@efficios.com> <20180328152814.GI4082@hirez.programming.kicks-ass.net> <533214853.56.1522251426819.JavaMail.zimbra@efficios.com> <20180328174935.GK4082@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328174935.GK4082@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 1:49 PM, Peter Zijlstra peterz@infradead.org wrote:

> On Wed, Mar 28, 2018 at 11:37:06AM -0400, Mathieu Desnoyers wrote:
>> ----- On Mar 28, 2018, at 11:28 AM, Peter Zijlstra peterz@infradead.org wrote:
>> 
>> > On Wed, Mar 28, 2018 at 11:14:05AM -0400, Mathieu Desnoyers wrote:
>> > 
>> >> > If at all possible I would make it SIGSEGV when issueing SYSCALL()s from
>> >> > within an RSEQ.
>> >> 
>> >> What's the goal there ? rseq critical sections can technically do system calls
>> >> if they wish. Why prevent this ?
>> > 
>> > This all started as a way to do 'small' _fast_ per-cpu ops, System calls
>> > do NOT fit in that pattern. If you're willing to do a system calls the
>> > cost of atomics is not a problem.
>> 
>> I'm not arguing that a typical rseq would do a system call. I'm merely
>> pointing out that if we start putting arbitrary limitations like "SIGSEGV
>> when a fork or system call is encountered on top of rseq", this will cause
>> pain in user-space.
> 
> I don't think disallowing system calls is arbitrary. And I think that is
> something we really want to enforce, because it's batshit insane to
> allow.
> 
> And if we allow now, people _will_ use it and we can't ever take it
> away again.

Here are some examples of how I would like to use system calls within
rseq critical sections, for testing purposes:

- Issue poll(NULL, 0, ms_timeout) from a rseq critical section, to introduce
  a delay in the critical section and test the effect,
- Issue sched_yield() from a rseq critical section, to introduce preemption at
  that point,
- Issue kill() on self, thus testing interruption by signals over rseq c.s.,
- Invoke sched_setaffinity to tweak the cpu affinity mask to force thread
  migration within a rseq c.s.

I currently have only implemented the poll(), sched_yield() and kill()
test-cases outside of the rseq critical sections, instead relying on
assembly loops to introduce delays in rseq c.s.. However, if we disallow
system calls in rseq critical sections, I'll never be able to use those
systems calls to extend the test matrix.

I see other use-cases where having a system call in a rseq critical section
could make sense: if vDSO data shared between kernel and user-space rely
on rseq for synchronization, but a fallback sometimes needs to issue a system
call for part of the operation.

Therefore I'd really want to keep allowing system calls within rseq critical
sections, even though we don't expect this to be the typical use-case.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
