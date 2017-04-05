From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v6 4/4] arm64/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed, 5 Apr 2017 07:36:17 -0700
Message-ID: <CAJcbSZFeY-1ne1cYG0zW7ETRp1MyGkz7SSMzvWckWtUS82DMqg@mail.gmail.com>
References: <20170404174727.35478-1-thgarnie@google.com> <20170404174727.35478-4-thgarnie@google.com>
 <20170405142225.GA9072@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7246-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170405142225.GA9072@e104818-lin.cambridge.arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 5, 2017 at 7:22 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Tue, Apr 04, 2017 at 10:47:27AM -0700, Thomas Garnier wrote:
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 43512d4d7df2..6d598e7051c3 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -744,6 +744,10 @@ ENDPROC(cpu_switch_to)
>>  ret_fast_syscall:
>>       disable_irq                             // disable interrupts
>>       str     x0, [sp, #S_X0]                 // returned x0
>> +     ldr     x2, [tsk, #TSK_TI_ADDR_LIMIT]   // check addr limit change
>> +     mov     x1, #TASK_SIZE_64
>> +     cmp     x2, x1
>> +     b.ne    addr_limit_fail
>
> KERNEL_DS is set to the maximum address (-1UL), so it would be easier to
> check against this here and avoid a "mov". Even simpler if you'd check
> against bit 63 of the address for KERNEL_DS:

We also want to catch corruption so checking the 63 bit make sense. I
will look for this change in the next iteration.

>
>         ldr     x1, [tsk, TSK_TI_ADDR_LIMIT]    // check addr limit change
>         tbnz    x1, #63, addr_limit_fail        // KERNEL_DS is -1UL
>
>>       ldr     x1, [tsk, #TSK_TI_FLAGS]        // re-check for syscall tracing
>>       and     x2, x1, #_TIF_SYSCALL_WORK
>>       cbnz    x2, ret_fast_syscall_trace
>> @@ -771,6 +775,11 @@ work_pending:
>>   */
>>  ret_to_user:
>>       disable_irq                             // disable interrupts
>> +     ldr     x2, [tsk, #TSK_TI_ADDR_LIMIT]   // check addr limit change
>> +     mov     x1, #TASK_SIZE_64
>> +     cmp     x2, x1
>> +     b.ne    addr_limit_fail
>
> Same here.
>
>> +
>>       ldr     x1, [tsk, #TSK_TI_FLAGS]
>>       and     x2, x1, #_TIF_WORK_MASK
>>       cbnz    x2, work_pending
>> @@ -779,6 +788,12 @@ finish_ret_to_user:
>>       kernel_exit 0
>>  ENDPROC(ret_to_user)
>>
>> +addr_limit_fail:
>> +     stp     x0, lr, [sp,#-16]!
>> +     bl      asm_verify_pre_usermode_state
>> +     ldp     x0, lr, [sp],#16
>> +     ret     lr
>
> Where is this supposed to return? What is the value of lr when branching
> to addr_limit_fail?

It is not supposed to return. Do you think I should remove stp, ldp,
ret and jut add a brk 0x100 or jmp/call a break/bug function?

>
> --
> Catalin



-- 
Thomas
