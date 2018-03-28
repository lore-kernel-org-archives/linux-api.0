From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 10:47:54 -0400 (EDT)
Message-ID: <1523662633.2105.1522248474778.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328125004.GV4043@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328125004.GV4043@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 8:50 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Tue, Mar 27, 2018 at 12:05:23PM -0400, Mathieu Desnoyers wrote:
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index fb5fc458547f..66b070444a7e 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -1249,6 +1249,7 @@ static inline void __set_task_cpu(struct task_struct *p,
>> unsigned int cpu)
>>  #endif
>>  	p->wake_cpu = cpu;
>>  #endif
>> +	rseq_migrate(p);
>>  }
> 
> I think you want that in set_task_cpu(), right next to nr_migrations++.

This would miss the __set_task_cpu() call from sched_fork() and wake_up_new_task().
Those cases are not accounted as explicit "migrations", but it does change the CPU
of the current task. So if for some weird reason userspace wants to fork() while in
a rseq critical section, we want to trigger a rseq restart.

Note that rseq_fork() implies rseq_preempt(), but userspace can request to
track only migrations for a given rseq critical section (by using the
RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT flag), so the rseq_preempt() in rseq_fork()
is not enough to restart if a migration between CPUs is done across a fork.

An alternative to this would be to call rseq_migrate() in rseq_fork().

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
