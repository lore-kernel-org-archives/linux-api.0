From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 04/24] 32-bit userspace ABI: introduce ARCH_32BIT_OFF_T
 config option
Date: Fri, 8 Jun 2018 18:32:07 +0100
Message-ID: <20180608173207.nwoi25jee52gpdwy@armageddon.cambridge.arm.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20180516081910.10067-5-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180516081910.10067-5-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Szabolcs Nagy <szabolcs.nagy@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, Steve Ellcey <sellcey@caviumnetworks.com>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Alexander Graf <agraf@suse.de>, Bamvor Zhangjian <bamv2005@gmail.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Dave Martin <Dave.Martin@arm.com>, Adam Borowski <kilobyte@angband.pl>, Manuel Montezelo <manuel.montezelo@gmail.com>, James Hogan <james.hogan@imgtec.com>, Ch
List-Id: linux-api@vger.kernel.org

On Wed, May 16, 2018 at 11:18:49AM +0300, Yury Norov wrote:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 76c0b54443b1..ee079244dc3c 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -264,6 +264,21 @@ config ARCH_THREAD_STACK_ALLOCATOR
>  config ARCH_WANTS_DYNAMIC_TASK_STRUCT
>  	bool
>  
> +config ARCH_32BIT_OFF_T
> +	bool
> +	depends on !64BIT
> +	help
> +	  All new 32-bit architectures should have 64-bit off_t type on
> +	  userspace side which corresponds to the loff_t kernel type. This
> +	  is the requirement for modern ABIs. Some existing architectures
> +	  already have 32-bit off_t. This option is enabled for all such
> +	  architectures explicitly. Namely: arc, arm, blackfin, cris, frv,
> +	  h8300, hexagon, m32r, m68k, metag, microblaze, mips32, mn10300,
> +	  nios2, openrisc, parisc32, powerpc32, score, sh, sparc, tile32,
> +	  unicore32, x86_32 and xtensa. This is the complete list. Any
> +	  new 32-bit architecture should declare 64-bit off_t type on user
> +	  side and so should not enable this option.

Do you know if this is the case for riscv and nds32, merged in the
meantime? If not, I suggest you drop this patch altogether and just
define force_o_largefile() for arm64/ilp32 as we don't seem to stick to
"all new 32-bit architectures should have 64-bit off_t".

-- 
Catalin
