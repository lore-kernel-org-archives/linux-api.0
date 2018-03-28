From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH for 4.17 02/21] rseq: Introduce restartable sequences
 system call (v12)
Date: Wed, 28 Mar 2018 17:28:14 +0200
Message-ID: <20180328152814.GI4082@hirez.programming.kicks-ass.net>
References: <20180327160542.28457-1-mathieu.desnoyers@efficios.com>
 <20180327160542.28457-3-mathieu.desnoyers@efficios.com>
 <20180328125004.GV4043@hirez.programming.kicks-ass.net>
 <1523662633.2105.1522248474778.JavaMail.zimbra@efficios.com>
 <20180328145946.GH4082@hirez.programming.kicks-ass.net>
 <265889560.1.1522250045589.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <265889560.1.1522250045589.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 11:14:05AM -0400, Mathieu Desnoyers wrote:

> > If at all possible I would make it SIGSEGV when issueing SYSCALL()s from
> > within an RSEQ.
> 
> What's the goal there ? rseq critical sections can technically do system calls
> if they wish. Why prevent this ?

This all started as a way to do 'small' _fast_ per-cpu ops, System calls
do NOT fit in that pattern. If you're willing to do a system calls the
cost of atomics is not a problem.

> How would you handle signal handlers that issue system calls while nested
> on top of a rseq critical section in the userspace thread ? SIGSEGV on
> SYSCALLs will break this case.

Have the rseq thing aborted prior to delivering the signal ?
