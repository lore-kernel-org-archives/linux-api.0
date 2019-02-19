From: Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH 7/8] csky: Use latest system call ABI
Date: Tue, 19 Feb 2019 10:18:34 +0800
Message-ID: <20190219021834.GA4495@guoren-Inspiron-7460>
References: <20190218210712.3503891-1-arnd@arndb.de>
 <20190218210712.3503891-8-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190218210712.3503891-8-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Mao Han <han_mao@c-sky.com>
Cc: y2038@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, yury.norov@gmail.com, linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp, Stafford Horne <shorne@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Palmer Dabbelt <palmer@sifive.com>, Greentime Hu <green.hu@gmail.com>, linux-riscv@lists.infradead.org, Guan Xuetao <gxt@pku.edu.cn>
List-Id: linux-api@vger.kernel.org

Mao Han has merged csky port into glibc 2.29, so we should keep the
__ARCH_WANT_TIME32_SYSCALLS.

F.Y.I:
han_mao@c-sky.com

On Mon, Feb 18, 2019 at 10:07:11PM +0100, Arnd Bergmann wrote:
> We don't yet have an upstream glibc port for csky, so there is no user
> space for the existing ABI, and we can remove the definitions for 32-bit
> time_t, off_t and struct resource.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/csky/Kconfig                   | 1 -
>  arch/csky/include/uapi/asm/unistd.h | 2 --
>  2 files changed, 3 deletions(-)
> 
> diff --git a/arch/csky/Kconfig b/arch/csky/Kconfig
> index 6959e0b1e956..398113c845f5 100644
> --- a/arch/csky/Kconfig
> +++ b/arch/csky/Kconfig
> @@ -1,6 +1,5 @@
>  config CSKY
>  	def_bool y
> -	select ARCH_32BIT_OFF_T
>  	select ARCH_HAS_SYNC_DMA_FOR_CPU
>  	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
>  	select ARCH_USE_BUILTIN_BSWAP
> diff --git a/arch/csky/include/uapi/asm/unistd.h b/arch/csky/include/uapi/asm/unistd.h
> index ec60e49cea66..224c9a9ab45b 100644
> --- a/arch/csky/include/uapi/asm/unistd.h
> +++ b/arch/csky/include/uapi/asm/unistd.h
> @@ -2,8 +2,6 @@
>  // Copyright (C) 2018 Hangzhou C-SKY Microsystems co.,ltd.
>  
>  #define __ARCH_WANT_SYS_CLONE
> -#define __ARCH_WANT_SET_GET_RLIMIT
Seems it's not related to y2038 issue. Is __ARCH_WANT_SET_GET_RLIMIT no
use ?

> -#define __ARCH_WANT_TIME32_SYSCALLS

Best Regards
 Guo Ren
