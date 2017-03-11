From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Sat, 11 Mar 2017 10:42:00 +0100
Message-ID: <20170311094200.GA27700@gmail.com>
References: <20170311000501.46607-1-thgarnie@google.com>
 <20170311000501.46607-2-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-7016-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <20170311000501.46607-2-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.>
List-Id: linux-api@vger.kernel.org


* Thomas Garnier <thgarnie@google.com> wrote:

> Implement specific usage of verify_pre_usermode_state for user-mode
> returns for x86.
> ---
> Based on next-20170308
> ---
>  arch/x86/Kconfig                        |  1 +
>  arch/x86/entry/common.c                 |  3 +++
>  arch/x86/entry/entry_64.S               | 19 +++++++++++++++++++
>  arch/x86/include/asm/pgtable_64_types.h | 11 +++++++++++
>  arch/x86/include/asm/processor.h        | 11 -----------
>  5 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 005df7c825f5..6d48e18e6f09 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -63,6 +63,7 @@ config X86
>  	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
>  	select ARCH_MIGHT_HAVE_PC_SERIO
> +	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>  	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
>  	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
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
> @@ -180,6 +181,8 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
>  	struct thread_info *ti = current_thread_info();
>  	u32 cached_flags;
>  
> +	verify_pre_usermode_state();
> +
>  	if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
>  		local_irq_disable();
>  
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index d2b2a2948ffe..04db589be466 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -218,6 +218,25 @@ entry_SYSCALL_64_fastpath:
>  	testl	$_TIF_ALLWORK_MASK, TASK_TI_flags(%r11)
>  	jnz	1f
>  
> +	/*
> +	 * Check user-mode state on fast path return, the same check is done
> +	 * under the slow path through syscall_return_slowpath.
> +	 */
> +#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
> +	call	verify_pre_usermode_state
> +#else
> +	/*
> +	 * Similar to set_fs(USER_DS) in verify_pre_usermode_state without a
> +	 * warning.
> +	 */
> +	movq	PER_CPU_VAR(current_task), %rax
> +	movq	$TASK_SIZE_MAX, %rcx
> +	cmp	%rcx, TASK_addr_limit(%rax)
> +	jz	1f
> +	movq	%rcx, TASK_addr_limit(%rax)
> +1:
> +#endif
> +
>  	LOCKDEP_SYS_EXIT
>  	TRACE_IRQS_ON		/* user mode is traced as IRQs on */
>  	movq	RIP(%rsp), %rcx

Ugh, so you call an assembly function just to ... call another function.

Plus why is it in assembly to begin with? Is this some older code that got
written when the x86 entry code was in assembly, and never properly
converted to C?

Thanks,

	Ingo
