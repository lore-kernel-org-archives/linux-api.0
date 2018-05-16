From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 07/14] powerpc: Add support for restartable sequences
Date: Wed, 16 May 2018 16:13:16 -0400 (EDT)
Message-ID: <112970629.1913.1526501596485.JavaMail.zimbra@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <20180430224433.17407-8-mathieu.desnoyers@efficios.com> <20180516161837.GI12198@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516161837.GI12198@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On May 16, 2018, at 12:18 PM, Peter Zijlstra peterz@infradead.org wrote:

> On Mon, Apr 30, 2018 at 06:44:26PM -0400, Mathieu Desnoyers wrote:
>> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
>> index c32a181a7cbb..ed21a777e8c6 100644
>> --- a/arch/powerpc/Kconfig
>> +++ b/arch/powerpc/Kconfig
>> @@ -223,6 +223,7 @@ config PPC
>>  	select HAVE_SYSCALL_TRACEPOINTS
>>  	select HAVE_VIRT_CPU_ACCOUNTING
>>  	select HAVE_IRQ_TIME_ACCOUNTING
>> +	select HAVE_RSEQ
>>  	select IRQ_DOMAIN
>>  	select IRQ_FORCED_THREADING
>>  	select MODULES_USE_ELF_RELA
>> diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
>> index 61db86ecd318..d3bb3aaaf5ac 100644
>> --- a/arch/powerpc/kernel/signal.c
>> +++ b/arch/powerpc/kernel/signal.c
>> @@ -133,6 +133,8 @@ static void do_signal(struct task_struct *tsk)
>>  	/* Re-enable the breakpoints for the signal stack */
>>  	thread_change_pc(tsk, tsk->thread.regs);
>>  
>> +	rseq_signal_deliver(tsk->thread.regs);
>> +
>>  	if (is32) {
>>          	if (ksig.ka.sa.sa_flags & SA_SIGINFO)
>>  			ret = handle_rt_signal32(&ksig, oldset, tsk);
>> @@ -164,6 +166,7 @@ void do_notify_resume(struct pt_regs *regs, unsigned long
>> thread_info_flags)
>>  	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
>>  		clear_thread_flag(TIF_NOTIFY_RESUME);
>>  		tracehook_notify_resume(regs);
>> +		rseq_handle_notify_resume(regs);
>>  	}
>>  
>>  	user_enter();
> 
> Again no rseq_syscall().

Same question for PowerPC as for ARM:

Considering that rseq_syscall is implemented as follows:

+void rseq_syscall(struct pt_regs *regs)
+{
+       unsigned long ip = instruction_pointer(regs);
+       struct task_struct *t = current;
+       struct rseq_cs rseq_cs;
+
+       if (!t->rseq)
+               return;
+       if (!access_ok(VERIFY_READ, t->rseq, sizeof(*t->rseq)) ||
+           rseq_get_rseq_cs(t, &rseq_cs) || in_rseq_cs(ip, &rseq_cs))
+               force_sig(SIGSEGV, t);
+}

and that x86 calls it from syscall_return_slowpath() (which AFAIU is
now used in the fast-path since KPTI), I wonder where we should call
this on PowerPC ?  I was under the impression that PowerPC return to
userspace fast-path was not calling C code unless work flags were set,
but I might be wrong.

Thoughts ?

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
