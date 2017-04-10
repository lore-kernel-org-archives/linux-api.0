From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 4/4] arm64/syscalls: Architecture specific
 pre-usermode check
Date: Mon, 10 Apr 2017 18:12:40 +0100
Message-ID: <20170410171240.GE30647@e104818-lin.cambridge.arm.com>
References: <20170410164420.64003-1-thgarnie@google.com>
 <20170410164420.64003-4-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-7346-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170410164420.64003-4-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shu>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 10, 2017 at 09:44:20AM -0700, Thomas Garnier wrote:
> Disable the generic pre-usermode check in favor of an optimized
> implementation. This patch adds specific checks on user-mode return path
> to make it faster and smaller.
> 
> The address limit is checked on each syscall return path to user-mode.
> If it was changed, a generic handler is called to stop the kernel on an
> explicit check.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20170410
> ---
>  arch/arm64/Kconfig        |  1 +
>  arch/arm64/kernel/entry.S | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 9b8fcab7da56..3f9e8e7d9376 100644
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
> index 43512d4d7df2..bdd094c7837a 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -744,6 +744,8 @@ ENDPROC(cpu_switch_to)
>  ret_fast_syscall:
>  	disable_irq				// disable interrupts
>  	str	x0, [sp, #S_X0]			// returned x0
> +	ldr	x2, [tsk, #TSK_TI_ADDR_LIMIT]	// check addr limit change
> +	tbnz	x2, #63, addr_limit_fail
>  	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
>  	and	x2, x1, #_TIF_SYSCALL_WORK
>  	cbnz	x2, ret_fast_syscall_trace
> @@ -771,6 +773,9 @@ work_pending:
>   */
>  ret_to_user:
>  	disable_irq				// disable interrupts
> +	ldr	x2, [tsk, #TSK_TI_ADDR_LIMIT]	// check addr limit change
> +	tbnz	x2, #63, addr_limit_fail
> +

Nitpick: unnecessary empty line added.

>  	ldr	x1, [tsk, #TSK_TI_FLAGS]
>  	and	x2, x1, #_TIF_WORK_MASK
>  	cbnz	x2, work_pending
> @@ -780,6 +785,14 @@ finish_ret_to_user:
>  ENDPROC(ret_to_user)
>  
>  /*
> + * Address limit was incorrect before returning in user-mode which could be
> + * used to elevate privileges. Call the generic handler to stop the kernel on
> + * the appropriate check. This function does not return.
> + */
> +addr_limit_fail:
> +	bl address_limit_check_failed

You could do a "b address_limit_check_failed" rather than "bl" since we
don't care about returning here (and a nitpick: insert tab between "b"
and "address_limit_check_failed").

With the above:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
