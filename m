From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 03/14] arm: Add restartable sequences support
Date: Thu, 17 May 2018 14:32:31 +0100
Message-ID: <20180517133230.GA2688@arm.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <20180430224433.17407-4-mathieu.desnoyers@efficios.com>
 <20180516161809.GH12198@hirez.programming.kicks-ass.net>
 <670368504.1912.1526501593893.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <670368504.1912.1526501593893.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

On Wed, May 16, 2018 at 04:13:13PM -0400, Mathieu Desnoyers wrote:
> ----- On May 16, 2018, at 12:18 PM, Peter Zijlstra peterz@infradead.org wrote:
> 
> > On Mon, Apr 30, 2018 at 06:44:22PM -0400, Mathieu Desnoyers wrote:
> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >> index a7f8e7f4b88f..4f5c386631d4 100644
> >> --- a/arch/arm/Kconfig
> >> +++ b/arch/arm/Kconfig
> >> @@ -91,6 +91,7 @@ config ARM
> >>  	select HAVE_PERF_USER_STACK_DUMP
> >>  	select HAVE_RCU_TABLE_FREE if (SMP && ARM_LPAE)
> >>  	select HAVE_REGS_AND_STACK_ACCESS_API
> >> +	select HAVE_RSEQ
> >>  	select HAVE_SYSCALL_TRACEPOINTS
> >>  	select HAVE_UID16
> >>  	select HAVE_VIRT_CPU_ACCOUNTING_GEN
> >> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> >> index bd8810d4acb3..5879ab3f53c1 100644
> >> --- a/arch/arm/kernel/signal.c
> >> +++ b/arch/arm/kernel/signal.c
> >> @@ -541,6 +541,12 @@ static void handle_signal(struct ksignal *ksig, struct
> >> pt_regs *regs)
> >>  	int ret;
> >>  
> >>  	/*
> >> +	 * Increment event counter and perform fixup for the pre-signal
> >> +	 * frame.
> >> +	 */
> >> +	rseq_signal_deliver(regs);
> >> +
> >> +	/*
> >>  	 * Set up the stack frame
> >>  	 */
> >>  	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
> >> @@ -660,6 +666,7 @@ do_work_pending(struct pt_regs *regs, unsigned int
> >> thread_flags, int syscall)
> >>  			} else {
> >>  				clear_thread_flag(TIF_NOTIFY_RESUME);
> >>  				tracehook_notify_resume(regs);
> >> +				rseq_handle_notify_resume(regs);
> >>  			}
> >>  		}
> >>  		local_irq_disable();
> > 
> > I think you forgot to hook up rseq_syscall() checking.
> 
> Considering that rseq_syscall is implemented as follows:
> 
> +void rseq_syscall(struct pt_regs *regs)
> +{
> +       unsigned long ip = instruction_pointer(regs);
> +       struct task_struct *t = current;
> +       struct rseq_cs rseq_cs;
> +
> +       if (!t->rseq)
> +               return;
> +       if (!access_ok(VERIFY_READ, t->rseq, sizeof(*t->rseq)) ||
> +           rseq_get_rseq_cs(t, &rseq_cs) || in_rseq_cs(ip, &rseq_cs))
> +               force_sig(SIGSEGV, t);
> +}
> 
> and that x86 calls it from syscall_return_slowpath() (which AFAIU is
> now used in the fast-path since KPTI), I wonder where we should call
> this on ARM ? I was under the impression that ARM return to userspace
> fast-path was not calling C code unless work flags were set, but I might
> be wrong.
> 
> Thoughts ?

Since this only matters for CONFIG_DEBUG_RSEQ, can we just force the
slowpath for rseq tasks when that option is set?

Will
