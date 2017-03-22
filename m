From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of verify_pre_usermode_state
Date: Wed, 22 Mar 2017 12:15:03 -0700
Message-ID: <CAJcbSZEi6vxf8zGrLuLE3WGzBJYTrLEAC_Esx7pJx8MHn35qCg@mail.gmail.com>
References: <20170311000501.46607-1-thgarnie@google.com> <20170311000501.46607-2-thgarnie@google.com>
 <20170311094200.GA27700@gmail.com> <733ed189-6c01-2975-a81a-6fbfe4b7b593@zytor.com>
 <2d9aad2a-a677-40d2-c179-379fb6e9f194@zytor.com> <CAJcbSZG6F3DsiBMjizTbzaccvU5_RKdspU06wQ8yi+JT+EW2Jw@mail.gmail.com>
 <CALCETrVVo4aQosdjfUPBf=JWyVWE_cHavbBKX5Swv_HbV__RNw@mail.gmail.com>
 <CAJcbSZEFWzPVfxVzOF5r1yywkgMObxOt8W+1efuTUsv+82FBpg@mail.gmail.com>
 <7389c6e7-87dc-ea0d-5b2a-7925b8c8d33e@zytor.com> <CAJcbSZGjos1K9qvQWPTpr4COEcnW6Sn_jo7hCezGbh-BhPAH7w@mail.gmail.com>
 <8fa1a789-231f-dc2c-4a43-6406194259f9@zytor.com> <CAJcbSZGrD2q7ymUSFNMtvwL+JUzbQ5WNA=MU6tpJ6XVnfJipcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7055-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAJcbSZGrD2q7ymUSFNMtvwL+JUzbQ5WNA=MU6tpJ6XVnfJipcw@mail.gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 15, 2017 at 10:43 AM, Thomas Garnier <thgarnie@google.com> wrote:
> Thanks for the feedback. I will look into inlining by default (looking
> at code size on different arch), the updated patch for x86 in the
> meantime:

I did couple checks and it doesn't seem worth it. I will send a v4
with the change below for additional feedback.

> ===========
>
> Implement specific usage of verify_pre_usermode_state for user-mode
> returns for x86.
> ---
> Based on next-20170308
> ---
>  arch/x86/Kconfig                        |  1 +
>  arch/x86/entry/common.c                 |  3 +++
>  arch/x86/entry/entry_64.S               |  8 ++++++++
>  arch/x86/include/asm/pgtable_64_types.h | 11 +++++++++++
>  arch/x86/include/asm/processor.h        | 11 -----------
>  5 files changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 005df7c825f5..6d48e18e6f09 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -63,6 +63,7 @@ config X86
>   select ARCH_MIGHT_HAVE_ACPI_PDC if ACPI
>   select ARCH_MIGHT_HAVE_PC_PARPORT
>   select ARCH_MIGHT_HAVE_PC_SERIO
> + select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>   select ARCH_SUPPORTS_ATOMIC_RMW
>   select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
>   select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 370c42c7f046..525edbb77f03 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -22,6 +22,7 @@
>  #include <linux/context_tracking.h>
>  #include <linux/user-return-notifier.h>
>  #include <linux/uprobes.h>
> +#include <linux/syscalls.h>
>
>  #include <asm/desc.h>
>  #include <asm/traps.h>
> @@ -180,6 +181,8 @@ __visible inline void
> prepare_exit_to_usermode(struct pt_regs *regs)
>   struct thread_info *ti = current_thread_info();
>   u32 cached_flags;
>
> + verify_pre_usermode_state();
> +
>   if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
>   local_irq_disable();
>
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index d2b2a2948ffe..c079b010205c 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -218,6 +218,14 @@ entry_SYSCALL_64_fastpath:
>   testl $_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
>   jnz 1f
>
> + /*
> + * If address limit is not based on user-mode, jump to slow path for
> + * additional security checks.
> + */
> + movq $TASK_SIZE_MAX, %rcx
> + cmp %rcx, TASK_addr_limit(%r11)
> + jnz 1f
> +
>   LOCKDEP_SYS_EXIT
>   TRACE_IRQS_ON /* user mode is traced as IRQs on */
>   movq RIP(%rsp), %rcx
> diff --git a/arch/x86/include/asm/pgtable_64_types.h
> b/arch/x86/include/asm/pgtable_64_types.h
> index 3a264200c62f..0fbbb79d058c 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -76,4 +76,15 @@ typedef struct { pteval_t pte; } pte_t;
>
>  #define EARLY_DYNAMIC_PAGE_TABLES 64
>
> +/*
> + * User space process size. 47bits minus one guard page.  The guard
> + * page is necessary on Intel CPUs: if a SYSCALL instruction is at
> + * the highest possible canonical userspace address, then that
> + * syscall will enter the kernel with a non-canonical return
> + * address, and SYSRET will explode dangerously.  We avoid this
> + * particular problem by preventing anything from being mapped
> + * at the maximum canonical address.
> + */
> +#define TASK_SIZE_MAX ((_AC(1, UL) << 47) - PAGE_SIZE)
> +
>  #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index f385eca5407a..9bc99d37133e 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -829,17 +829,6 @@ static inline void spin_lock_prefetch(const void *x)
>  #define KSTK_ESP(task) (task_pt_regs(task)->sp)
>
>  #else
> -/*
> - * User space process size. 47bits minus one guard page.  The guard
> - * page is necessary on Intel CPUs: if a SYSCALL instruction is at
> - * the highest possible canonical userspace address, then that
> - * syscall will enter the kernel with a non-canonical return
> - * address, and SYSRET will explode dangerously.  We avoid this
> - * particular problem by preventing anything from being mapped
> - * at the maximum canonical address.
> - */
> -#define TASK_SIZE_MAX ((1UL << 47) - PAGE_SIZE)
> -
>  /* This decides where the kernel will search for a free chunk of vm
>   * space during mmap's.
>   */
> --
> 2.12.0.367.g23dc2f6d3c-goog
>
>
> On Tue, Mar 14, 2017 at 10:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 03/14/17 09:51, Thomas Garnier wrote:
>>>>
>>>> I wanted to comment on that thing: why on earth isn't
>>>> verify_pre_usermode_state() an inline?  Making it an out-of-line
>>>> function adds pointless extra overhead to the C code when we are talking
>>>> about a few instructions.
>>>
>>> Because outside of arch specific implementation it is called by each
>>> syscall handler. it will increase the code size a lot.
>>>
>>
>> Don't assume that.  On a lot of architectures a function call can be
>> more expensive than a simple compare and branch, because the compiler
>> has to assume a whole bunch of registers are lost at that point.
>>
>> Either way, don't penalize the common architectures for it.  Not okay.
>>
>>         -hpa
>>
>
>
>
> --
> Thomas



-- 
Thomas
