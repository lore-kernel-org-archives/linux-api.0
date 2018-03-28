From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable
 sequences system call (v12)
Date: Wed, 28 Mar 2018 11:37:06 -0400 (EDT)
Message-ID: <533214853.56.1522251426819.JavaMail.zimbra@efficios.com>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com> <20180327160542.28457-3-mathieu.desnoyers@efficios.com> <20180328125004.GV4043@hirez.programming.kicks-ass.net> <1523662633.2105.1522248474778.JavaMail.zimbra@efficios.com> <20180328145946.GH4082@hirez.programming.kicks-ass.net> <265889560.1.1522250045589.JavaMail.zimbra@efficios.com> <20180328152814.GI4082@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180328152814.GI4082@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2018, at 11:28 AM, Peter Zijlstra peterz@infradead.org wrote:

> On Wed, Mar 28, 2018 at 11:14:05AM -0400, Mathieu Desnoyers wrote:
> 
>> > If at all possible I would make it SIGSEGV when issueing SYSCALL()s from
>> > within an RSEQ.
>> 
>> What's the goal there ? rseq critical sections can technically do system calls
>> if they wish. Why prevent this ?
> 
> This all started as a way to do 'small' _fast_ per-cpu ops, System calls
> do NOT fit in that pattern. If you're willing to do a system calls the
> cost of atomics is not a problem.

I'm not arguing that a typical rseq would do a system call. I'm merely
pointing out that if we start putting arbitrary limitations like "SIGSEGV
when a fork or system call is encountered on top of rseq", this will cause
pain in user-space.

> 
>> How would you handle signal handlers that issue system calls while nested
>> on top of a rseq critical section in the userspace thread ? SIGSEGV on
>> SYSCALLs will break this case.
> 
> Have the rseq thing aborted prior to delivering the signal ?

Not if the RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL flag is set either in the TLS
or in the rseq_cs structure.

How about we simply add a rseq_migrate() within rseq_fork() (when
forking to a new process), which will allow me to move the rseq_migrate
from __set_task_cpu() to set_task_cpu() as you request. Is that solution
acceptable for you ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
