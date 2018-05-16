From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/14] arm: Add restartable sequences support
Date: Wed, 16 May 2018 18:18:09 +0200
Message-ID: <20180516161809.GH12198@hirez.programming.kicks-ass.net>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <20180430224433.17407-4-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180430224433.17407-4-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 30, 2018 at 06:44:22PM -0400, Mathieu Desnoyers wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a7f8e7f4b88f..4f5c386631d4 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -91,6 +91,7 @@ config ARM
>  	select HAVE_PERF_USER_STACK_DUMP
>  	select HAVE_RCU_TABLE_FREE if (SMP && ARM_LPAE)
>  	select HAVE_REGS_AND_STACK_ACCESS_API
> +	select HAVE_RSEQ
>  	select HAVE_SYSCALL_TRACEPOINTS
>  	select HAVE_UID16
>  	select HAVE_VIRT_CPU_ACCOUNTING_GEN
> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> index bd8810d4acb3..5879ab3f53c1 100644
> --- a/arch/arm/kernel/signal.c
> +++ b/arch/arm/kernel/signal.c
> @@ -541,6 +541,12 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  	int ret;
>  
>  	/*
> +	 * Increment event counter and perform fixup for the pre-signal
> +	 * frame.
> +	 */
> +	rseq_signal_deliver(regs);
> +
> +	/*
>  	 * Set up the stack frame
>  	 */
>  	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
> @@ -660,6 +666,7 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
>  			} else {
>  				clear_thread_flag(TIF_NOTIFY_RESUME);
>  				tracehook_notify_resume(regs);
> +				rseq_handle_notify_resume(regs);
>  			}
>  		}
>  		local_irq_disable();

I think you forgot to hook up rseq_syscall() checking.
