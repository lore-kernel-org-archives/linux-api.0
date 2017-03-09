From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/4] arm64/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Thu, 9 Mar 2017 12:23:54 +0000
Message-ID: <20170309122354.GB6320@leverpostej>
References: <20170309012456.5631-1-thgarnie@google.com>
 <20170309012456.5631-4-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-6962-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170309012456.5631-4-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?utf-8?B?UmVuw6k=?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Fre
List-Id: linux-api@vger.kernel.org

On Wed, Mar 08, 2017 at 05:24:56PM -0800, Thomas Garnier wrote:
> Implement specific usage of verify_pre_usermode_state for user-mode
> returns for arm64.
> ---
> Based on next-20170308
> ---
>  arch/arm64/Kconfig        |  1 +
>  arch/arm64/kernel/entry.S | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 896eba61e5ed..da54774838d8 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -24,6 +24,7 @@ config ARM64
>  	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
>  	select ARCH_WANT_FRAME_POINTERS
>  	select ARCH_HAS_UBSAN_SANITIZE_ALL
> +	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>  	select ARM_AMBA
>  	select ARM_ARCH_TIMER
>  	select ARM_GIC
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 43512d4d7df2..eca392ae63e9 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -737,6 +737,19 @@ ENTRY(cpu_switch_to)
>  	ret
>  ENDPROC(cpu_switch_to)
>  
> +#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
> +.macro VERIFY_PRE_USERMODE_STATE
> +	bl	verify_pre_usermode_state
> +.endm
> +#else

We generally stick to lower case for the arm64 assembly macros. If we
need this, we should stick to the existing convention.

> +/* Similar to set_fs(USER_DS) in verify_pre_usermode_state without a warning. */
> +.macro VERIFY_PRE_USERMODE_STATE
> +	mov	x1, #TASK_SIZE_64
> +	str	x1, [tsk, #TSK_TI_ADDR_LIMIT]
> +.endm

We need arm64's set_fs() to configure UAO, too, so this is much weaker
than set_fs(), and will leave __{get,put}_user and
__copy_{to,from}_user() able to access kernel memory.

We don't currently have an asm helper to clear UAO, and unconditionally
poking that on exception return is liable to be somewhat expensive.

Also, given we're only trying to catch this in syscalls, I'm afraid I
don't see what we gain by doing this in the entry assembly.

Thanks,
Mark.

> +#endif
> +
> +
>  /*
>   * This is the fast syscall return path.  We do as little as possible here,
>   * and this includes saving x0 back into the kernel stack.
> @@ -744,6 +757,7 @@ ENDPROC(cpu_switch_to)
>  ret_fast_syscall:
>  	disable_irq				// disable interrupts
>  	str	x0, [sp, #S_X0]			// returned x0
> +	VERIFY_PRE_USERMODE_STATE
>  	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
>  	and	x2, x1, #_TIF_SYSCALL_WORK
>  	cbnz	x2, ret_fast_syscall_trace
> @@ -771,6 +785,7 @@ work_pending:
>   */
>  ret_to_user:
>  	disable_irq				// disable interrupts
> +	VERIFY_PRE_USERMODE_STATE
>  	ldr	x1, [tsk, #TSK_TI_FLAGS]
>  	and	x2, x1, #_TIF_WORK_MASK
>  	cbnz	x2, work_pending
> -- 
> 2.12.0.246.ga2ecc84866-goog
> 
