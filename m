From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 3/4] arm/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Wed, 8 Mar 2017 21:49:56 +0000
Message-ID: <20170308214956.GF21222@n2100.armlinux.org.uk>
References: <20170308213844.131877-1-thgarnie@google.com>
 <20170308213844.131877-3-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308213844.131877-3-thgarnie@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Garnier <thgarnie@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg
List-Id: linux-api@vger.kernel.org

On Wed, Mar 08, 2017 at 01:38:43PM -0800, Thomas Garnier wrote:
> Implement specific usage of verify_pre_usermode_state for user-mode
> returns for arm.
> ---
> Based on next-20170308
> ---
>  arch/arm/Kconfig               | 1 +
>  arch/arm/kernel/entry-common.S | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 0d4e71b42c77..704fd8f197fa 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -12,6 +12,7 @@ config ARM
>  	select ARCH_HAVE_CUSTOM_GPIO_H
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
> +	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
>  	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
>  	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT if CPU_V7
>  	select ARCH_SUPPORTS_ATOMIC_RMW
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index eb5cd77bf1d8..80cfdc7fabde 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -39,6 +39,9 @@
>  ret_fast_syscall:
>   UNWIND(.fnstart	)
>   UNWIND(.cantunwind	)
> +	push	{r0}				@ save returned r0
> +	bl	verify_pre_usermode_state
> +	pop	{r0}				@ restore r0

This really makes the fast exit utterly pointless, and we might as well
rip all that out.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
