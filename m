From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 07/14] powerpc: Add support for restartable sequences
Date: Mon, 28 May 2018 03:00:19 -0400 (EDT)
Message-ID: <284936908.600.1527490819532.JavaMail.zimbra@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <277374719.2144.1526570889798.JavaMail.zimbra@efficios.com> <1526601043.1338308.1376191416.0444B8C5@webmail.messagingengine.com> <418003803.516.1526667437396.JavaMail.zimbra@efficios.com> <20180520140811.GB1121@tardis> <1928158599.1541.1527106479862.JavaMail.zimbra@efficios.com> <37442352.1577.1527110985175.JavaMail.zimbra@efficios.com> <87o9h5sw4e.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87o9h5sw4e.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, Boqun Feng <boqun.feng@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On May 24, 2018, at 3:03 AM, Michael Ellerman mpe@ellerman.id.au wrote:

> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
>> ----- On May 23, 2018, at 4:14 PM, Mathieu Desnoyers
>> mathieu.desnoyers@efficios.com wrote:
> ...
>>> 
>>> Hi Boqun,
>>> 
>>> I tried your patch in a ppc64 le environment, and it does not survive boot
>>> with CONFIG_DEBUG_RSEQ=y. init gets killed right away.
> 
> 
> Sorry this code is super gross and hard to deal with.
> 
>> The following fixup gets ppc64 to work:
>>
>> --- a/arch/powerpc/kernel/entry_64.S
>> +++ b/arch/powerpc/kernel/entry_64.S
>> @@ -208,6 +208,7 @@ system_call_exit:
>>         /* Check whether the syscall is issued inside a restartable sequence */
>>         addi    r3,r1,STACK_FRAME_OVERHEAD
>>         bl      rseq_syscall
>> +       ld      r3,RESULT(r1)
>>  #endif
>>         /*
>>          * Disable interrupts so current_thread_info()->flags can't change,
> 
> I don't think that's safe.
> 
> If you look above that, we have r3, r8 and r12 all live:
> 
> .Lsyscall_exit:
>	std	r3,RESULT(r1)
>	CURRENT_THREAD_INFO(r12, r1)
> 
>	ld	r8,_MSR(r1)
> #ifdef CONFIG_PPC_BOOK3S
>	/* No MSR:RI on BookE */
>	andi.	r10,r8,MSR_RI
>	beq-	.Lunrecov_restore
> #endif
> 
> 
> They're all volatile across function calls:
> 
>  http://openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655240_68174.html
> 
> 
> The system_call_exit symbol is actually there for kprobes and cosmetic
> purposes. The actual syscall return flow starts at .Lsyscall_exit.
> 
> So I think this would work:
> 
> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
> index db4df061c33a..e19f377a25e0 100644
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -184,6 +184,14 @@ system_call:			/* label this so stack traces look sane */
> 
> .Lsyscall_exit:
> 	std	r3,RESULT(r1)
> +
> +#ifdef CONFIG_DEBUG_RSEQ
> +	/* Check whether the syscall is issued inside a restartable sequence */
> +	addi    r3,r1,STACK_FRAME_OVERHEAD
> +	bl      rseq_syscall
> +	ld	r3,RESULT(r1)
> +#endif
> +
> 	CURRENT_THREAD_INFO(r12, r1)
> 
> 	ld	r8,_MSR(r1)
> 
> 
> I'll try and get this series into my test setup at some point, been a
> bit busy lately :)

Yes, this was needed. I had this in my tree already, but there is still
a kernel OOPS when running the rseq selftests on ppc64 with CONFIG_DEBUG_RSEQ=y.

My current dev tree is at: https://github.com/compudj/linux-percpu-dev/tree/rseq/dev-local

So considering we are at rc7 now, should I plan to removing the powerpc bits
for merge window submission, or is there someone planning to spend time on
fixing and testing ppc integration before the merge window opens ?

Thanks,

Mathieu


> 
> cheers

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
