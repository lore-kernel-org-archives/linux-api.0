From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 11:14:05 -0400 (EDT)
Message-ID: <265889560.1.1522250045589.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328125004.GV4043@hirez.programming.kicks-ass.net> <1523662633.2105.1522248474778.JavaMail.zimbra@efficios.com> <20180328145946.GH4082@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328145946.GH4082@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 10:59 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Wed, Mar 28, 2018 at 10:47:54AM -0400, Mathieu Desnoyers wrote:
>> ----- On Mar 28, 2018, at 8:50 AM, Peter Zijlstra peterz@infradead.org wrote:
>> 
>> > On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
>> >> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> >> index fb5fc458547f..66b070444a7e 100644
>> >> --- a/kernel/sched/sched.h
>> >> +++ b/kernel/sched/sched.h
>> >> @@ -1249,6 +1249,7 @@ static inline void __set_task_cpu(struct task_struct *p,
>> >> unsigned int cpu)
>> >>  #endif
>> >>  	p->wake_cpu = cpu;
>> >>  #endif
>> >> +	rseq_migrate(p);
>> >>  }
>> > 
>> > I think you want that in set_task_cpu(), right next to nr_migrations++.
>> 
>> This would miss the __set_task_cpu() call from sched_fork() and
>> wake_up_new_task().
> 
> Correct; but since those are _new_ tasks they _SHOULD_ not have an
> active RSEQ to begin with.

As long as fork() can be issued from a rseq critical section, nothing
actually prevents this. This is a fork(), not an exec(), so the new tasks
may very well be going through a restartable sequence when fork() happens.

> 
>> Those cases are not accounted as explicit "migrations", but it does change the
>> CPU
>> of the current task. So if for some weird reason userspace wants to fork() while
>> in
>> a rseq critical section, we want to trigger a rseq restart.
> 
> If at all possible I would make it SIGSEGV when issueing SYSCALL()s from
> within an RSEQ.

What's the goal there ? rseq critical sections can technically do system calls
if they wish. Why prevent this ?

How would you handle signal handlers that issue system calls while nested
on top of a rseq critical section in the userspace thread ? SIGSEGV on
SYSCALLs will break this case.

> 
>> An alternative to this would be to call rseq_migrate() in rseq_fork().
>> 
>> Thoughts ?
> 
> Yes, don't try and support that at all. It's _insane_.

Thomas told me those fork corner-cases should be correctly handled
in a previous version of the patchset. I'm following his advice here.

So either we disallow fork() within rseq critical sections completely with
some kind of validation, or we need to provide a non-bogus behavior when this
happens. Given that fork(2) is async-signal-safe, this means a signal handler
can do a fork() while nested on top of a userspace thread's rseq critical section.

So prohibiting fork() from being called over a rseq c.s. does not seem like
something we can do here.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
