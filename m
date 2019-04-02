From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 3/7] arm64: HWCAP: encapsulate elf_hwcap
Date: Tue, 2 Apr 2019 15:58:21 +0100
Message-ID: <20190402145821.GH3567@e103592.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-4-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-101113-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190401104515.39775-4-andrew.murray@arm.com>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Phil Blundell <pb@pbcl.net>, libc-alpha@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 01, 2019 at 11:45:11AM +0100, Andrew Murray wrote:
> The introduction of AT_HWCAP2 introduced accessors which ensure that
> hwcap features are set and tested appropriately.
> 
> Let's now mandate access to elf_hwcap via these accessors by making
> elf_hwcap static within cpufeature.c.

Looks reasonable except for a couple of minor nits below.

I had wondered whether putting these accessors out of line would affect
any hot paths, but I can't see these used from anything that looks like
a hot path.  So we're probably fine.

cpus_have_const_cap() is preferred for places where this matters,
anyway.

[...]

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 986ceeacd19f..84ca52fa75e5 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -35,8 +35,7 @@
>  #include <asm/traps.h>
>  #include <asm/virt.h>
>  
> -unsigned long elf_hwcap __read_mostly;
> -EXPORT_SYMBOL_GPL(elf_hwcap);
> +static unsigned long elf_hwcap __read_mostly;

Now that this doesn't correspond directly to ELF_HWCAP any more and we
hide it, can we rename it to avoid confusion?

Maybe "kernel_hwcap"?

>  #ifdef CONFIG_COMPAT
>  #define COMPAT_ELF_HWCAP_DEFAULT	\
> @@ -1947,6 +1946,35 @@ bool this_cpu_has_cap(unsigned int n)
>  	return false;
>  }
>  
> +void cpu_set_feature(unsigned int num)
> +{
> +	WARN_ON(num >= MAX_CPU_FEATURES);
> +	elf_hwcap |= BIT(num);
> +}
> +EXPORT_SYMBOL_GPL(cpu_set_feature);
> +
> +bool cpu_have_feature(unsigned int num)
> +{
> +	WARN_ON(num >= MAX_CPU_FEATURES);
> +	return elf_hwcap & BIT(num);
> +}
> +EXPORT_SYMBOL_GPL(cpu_have_feature);
> +
> +unsigned long cpu_get_elf_hwcap(void)
> +{
> +	/*
> +	 * We currently only populate the first 32 bits of AT_HWCAP. Please
> +	 * note that for userspace compatibility we guarantee that bit 62
> +	 * will always be returned as 0.
> +	 */

Presumably also bit 63?

It is reasonable to say this here, but I think there should also be a
note in Documentation/arm64/elf_hwcaps.txt.

[...]

Cheers
---Dave
