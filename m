From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 07/14] powerpc: Add support for restartable sequences
Date: Thu, 17 May 2018 11:28:09 -0400 (EDT)
Message-ID: <277374719.2144.1526570889798.JavaMail.zimbra@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <20180430224433.17407-8-mathieu.desnoyers@efficios.com> <20180516161837.GI12198@hirez.programming.kicks-ass.net> <112970629.1913.1526501596485.JavaMail.zimbra@efficios.com> <20180517011949.GA1121@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517011949.GA1121@tardis>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On May 16, 2018, at 9:19 PM, Boqun Feng boqun.feng@gmail.com wrote:

> On Wed, May 16, 2018 at 04:13:16PM -0400, Mathieu Desnoyers wrote:
>> ----- On May 16, 2018, at 12:18 PM, Peter Zijlstra peterz@infradead.org wrote:
>> 
>> > On Mon, Apr 30, 2018 at 06:44:26PM -0400, Mathieu Desnoyers wrote:
>> >> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> >> index c32a181a7cbb..ed21a777e8c6 100644
>> >> --- a/arch/powerpc/Kconfig
>> >> +++ b/arch/powerpc/Kconfig
>> >> @@ -223,6 +223,7 @@ config PPC
>> >>  	select HAVE_SYSCALL_TRACEPOINTS
>> >>  	select HAVE_VIRT_CPU_ACCOUNTING
>> >>  	select HAVE_IRQ_TIME_ACCOUNTING
>> >> +	select HAVE_RSEQ
>> >>  	select IRQ_DOMAIN
>> >>  	select IRQ_FORCED_THREADING
>> >>  	select MODULES_USE_ELF_RELA
>> >> diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
>> >> index 61db86ecd318..d3bb3aaaf5ac 100644
>> >> --- a/arch/powerpc/kernel/signal.c
>> >> +++ b/arch/powerpc/kernel/signal.c
>> >> @@ -133,6 +133,8 @@ static void do_signal(struct task_struct *tsk)
>> >>  	/* Re-enable the breakpoints for the signal stack */
>> >>  	thread_change_pc(tsk, tsk->thread.regs);
>> >>  
>> >> +	rseq_signal_deliver(tsk->thread.regs);
>> >> +
>> >>  	if (is32) {
>> >>          	if (ksig.ka.sa.sa_flags & SA_SIGINFO)
>> >>  			ret = handle_rt_signal32(&ksig, oldset, tsk);
>> >> @@ -164,6 +166,7 @@ void do_notify_resume(struct pt_regs *regs, unsigned long
>> >> thread_info_flags)
>> >>  	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
>> >>  		clear_thread_flag(TIF_NOTIFY_RESUME);
>> >>  		tracehook_notify_resume(regs);
>> >> +		rseq_handle_notify_resume(regs);
>> >>  	}
>> >>  
>> >>  	user_enter();
>> > 
>> > Again no rseq_syscall().
>> 
>> Same question for PowerPC as for ARM:
>> 
>> Considering that rseq_syscall is implemented as follows:
>> 
>> +void rseq_syscall(struct pt_regs *regs)
>> +{
>> +       unsigned long ip = instruction_pointer(regs);
>> +       struct task_struct *t = current;
>> +       struct rseq_cs rseq_cs;
>> +
>> +       if (!t->rseq)
>> +               return;
>> +       if (!access_ok(VERIFY_READ, t->rseq, sizeof(*t->rseq)) ||
>> +           rseq_get_rseq_cs(t, &rseq_cs) || in_rseq_cs(ip, &rseq_cs))
>> +               force_sig(SIGSEGV, t);
>> +}
>> 
>> and that x86 calls it from syscall_return_slowpath() (which AFAIU is
>> now used in the fast-path since KPTI), I wonder where we should call
> 
> So we actually detect this after the syscall takes effect, right? I
> wonder whether this could be problematic, because "disallowing syscall"
> in rseq areas may means the syscall won't take effect to some people, I
> guess?
> 
>> this on PowerPC ?  I was under the impression that PowerPC return to
>> userspace fast-path was not calling C code unless work flags were set,
>> but I might be wrong.
>> 
> 
> I think you're right. So we have to introduce callsite to rseq_syscall()
> in syscall path, something like:
> 
> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
> index 51695608c68b..a25734a96640 100644
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -222,6 +222,9 @@ system_call_exit:
> 	mtmsrd	r11,1
> #endif /* CONFIG_PPC_BOOK3E */
> 
> +	addi    r3,r1,STACK_FRAME_OVERHEAD
> +	bl	rseq_syscall
> +
> 	ld	r9,TI_FLAGS(r12)
> 	li	r11,-MAX_ERRNO
> 	andi.
> 		r0,r9,(_TIF_SYSCALL_DOTRACE|_TIF_SINGLESTEP|_TIF_USER_WORK_MASK|_TIF_PERSYSCALL_MASK)
> 
> But I think it's important for us to first decide where (before or after
> the syscall) we do the detection.

As Peter said, we don't really care whether it's on syscall entry or exit, as
long as the process gets killed when the erroneous use is detected. I think doing
it on syscall exit is a bit easier because we can clearly access the userspace
TLS, which AFAIU may be less straightforward on syscall entry.

We may want to add #ifdef CONFIG_DEBUG_RSEQ / #endif around the code you
proposed above, so it's only compiled in if CONFIG_DEBUG_RSEQ=y.

On the ARM leg of the email thread, Will Deacon suggests to test whether current->rseq
is non-NULL before calling rseq_syscall(). I wonder if this added check is justified
as the assembly level, considering that this is just a debugging option. We already do
that check at the very beginning of rseq_syscall().

Thoughts ?

Thanks,

Mathieu

> 
> Regards,
> Boqun
> 
>> Thoughts ?
>> 
>> Thanks!
>> 
>> Mathieu
>> 
>> --
>> Mathieu Desnoyers
>> EfficiOS Inc.
> > http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
