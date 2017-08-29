From: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/4] arm/syscalls: Optimize address limit check
Date: Tue, 29 Aug 2017 07:32:39 -0700
Message-ID: <CAJcbSZEd10fMp6OSgSYv_Wmt=wX5fw_Gu-_N=fM_QmP==wUMew@mail.gmail.com>
References: <20170814213732.104301-1-thgarnie@google.com> <20170814213732.104301-3-thgarnie@google.com>
 <CAJcbSZG1b7ObJAv6Kmp-fR3vZRg7AdbcgqDceGB95r-72Yv0yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJcbSZG1b7ObJAv6Kmp-fR3vZRg7AdbcgqDceGB95r-72Yv0yg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, =?UTF-8?Q?Lothar_Wa=C3=9Fmann?= <LW-AvR2QvxeiV7DiMYJYoSAnRvVK+yQ3ZXh@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 22, 2017 at 9:42 AM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Aug 14, 2017 at 2:37 PM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> Disable the generic address limit check in favor of an architecture
>> specific optimized implementation. The generic implementation using
>> pending work flags did not work well with ARM and alignment faults.
>>
>> The address limit is checked on each syscall return path to user-mode
>> path as well as the irq user-mode return function. If the address limit
>> was changed, a function is called to report data corruption (stopping
>> the kernel or process based on configuration).
>>
>> The address limit check has to be done before any pending work because
>> they can reset the address limit and the process is killed using a
>> SIGKILL signal. For example the lkdtm address limit check does not work
>> because the signal to kill the process will reset the user-mode address
>> limit.
>>
>> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Any feedback?

CCing LW-AvR2QvxeiV7DiMYJYoSAnRvVK+yQ3ZXh@public.gmane.org who experienced the same issue this patch
proposal fix.

Russel: Any feedback?

>
>> ---
>>  arch/arm/kernel/entry-common.S | 11 +++++++++++
>>  arch/arm/kernel/signal.c       |  7 +++++++
>>  2 files changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
>> index 0b60adf4a5d9..99c908226065 100644
>> --- a/arch/arm/kernel/entry-common.S
>> +++ b/arch/arm/kernel/entry-common.S
>> @@ -12,6 +12,7 @@
>>  #include <asm/unistd.h>
>>  #include <asm/ftrace.h>
>>  #include <asm/unwind.h>
>> +#include <asm/memory.h>
>>  #ifdef CONFIG_AEABI
>>  #include <asm/unistd-oabi.h>
>>  #endif
>> @@ -48,10 +49,14 @@ ret_fast_syscall:
>>   UNWIND(.fnstart       )
>>   UNWIND(.cantunwind    )
>>         disable_irq_notrace                     @ disable interrupts
>> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
>> +       cmp     r2, #TASK_SIZE
>> +       blne    addr_limit_check_failed
>>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
>>         tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
>>         bne     fast_work_pending
>>
>> +
>>         /* perform architecture specific actions before user return */
>>         arch_ret_to_user r1, lr
>>
>> @@ -74,6 +79,9 @@ ret_fast_syscall:
>>   UNWIND(.cantunwind    )
>>         str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
>>         disable_irq_notrace                     @ disable interrupts
>> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
>> +       cmp     r2, #TASK_SIZE
>> +       blne    addr_limit_check_failed
>>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
>>         tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
>>         beq     no_work_pending
>> @@ -106,6 +114,9 @@ ENTRY(ret_to_user)
>>  ret_slow_syscall:
>>         disable_irq_notrace                     @ disable interrupts
>>  ENTRY(ret_to_user_from_irq)
>> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
>> +       cmp     r2, #TASK_SIZE
>> +       blne    addr_limit_check_failed
>>         ldr     r1, [tsk, #TI_FLAGS]
>>         tst     r1, #_TIF_WORK_MASK
>>         bne     slow_work_pending
>> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
>> index 5814298ef0b7..b67ae12503f3 100644
>> --- a/arch/arm/kernel/signal.c
>> +++ b/arch/arm/kernel/signal.c
>> @@ -14,6 +14,7 @@
>>  #include <linux/uaccess.h>
>>  #include <linux/tracehook.h>
>>  #include <linux/uprobes.h>
>> +#include <linux/syscalls.h>
>>
>>  #include <asm/elf.h>
>>  #include <asm/cacheflush.h>
>> @@ -673,3 +674,9 @@ struct page *get_signal_page(void)
>>
>>         return page;
>>  }
>> +
>> +/* Defer to generic check */
>> +asmlinkage void addr_limit_check_failed(void)
>> +{
>> +       addr_limit_user_check();
>> +}
>> --
>> 2.14.1.480.gb18f417b89-goog
>>
>
>
>
> --
> Thomas



-- 
Thomas
