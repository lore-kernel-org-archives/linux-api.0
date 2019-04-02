From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 2/7] arm64: HWCAP: add support for AT_HWCAP2
Date: Tue, 2 Apr 2019 15:58:31 +0100
Message-ID: <20190402145831.GI3567@e103592.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-3-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190401104515.39775-3-andrew.murray@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Murray <andrew.murray@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Phil Blundell <pb@pbcl.net>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 01, 2019 at 11:45:10AM +0100, Andrew Murray wrote:
> As we will exhaust the first 32 bits of AT_HWCAP let's start
> exposing AT_HWCAP2 to userspace to give us up to 64 caps.
> 
> Whilst it's possible to use the remaining 32 bits of AT_HWCAP, we
> prefer to expand into AT_HWCAP2 in order to provide a consistent
> view to userspace between ILP32 and LP64. However internal to the
> kernel we prefer to continue to use the full space of elf_hwcap.
> 
> To reduce complexity and allow for future expansion, we now
> represent hwcaps in the kernel as ordinals and use a
> KERNEL_HWCAP_ prefix. This allows us to support automatic feature
> based module loading for all our hwcaps.
> 
> We introduce cpu_set_feature to set hwcaps which compliments the

Nit: maybe "complements"?  (I've always been a bit fuzzy on the precise
distinction, though.)

> existing cpu_have_feature helper. These helpers allow us to clean
> up existing direct uses of elf_hwcap and reduce any future effort
> required to move beyond 64 caps.
> 
> For convenience we also introduce cpu_{have,set}_named_feature which
> makes use of the cpu_feature macro to allow providing a hwcap name
> without a {KERNEL_}HWCAP_ prefix.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/crypto/aes-ce-ccm-glue.c      |  2 +-
>  arch/arm64/crypto/aes-neonbs-glue.c      |  2 +-
>  arch/arm64/crypto/chacha-neon-glue.c     |  2 +-
>  arch/arm64/crypto/crct10dif-ce-glue.c    |  4 +-
>  arch/arm64/crypto/ghash-ce-glue.c        |  8 +--
>  arch/arm64/crypto/nhpoly1305-neon-glue.c |  2 +-
>  arch/arm64/crypto/sha256-glue.c          |  4 +-
>  arch/arm64/include/asm/cpufeature.h      | 22 ++++----
>  arch/arm64/include/asm/hwcap.h           | 49 +++++++++++++++++-
>  arch/arm64/include/uapi/asm/hwcap.h      |  2 +-
>  arch/arm64/kernel/cpufeature.c           | 66 ++++++++++++------------
>  arch/arm64/kernel/cpuinfo.c              |  2 +-
>  arch/arm64/kernel/fpsimd.c               |  4 +-
>  drivers/clocksource/arm_arch_timer.c     |  8 +++
>  14 files changed, 117 insertions(+), 60 deletions(-)
> 

[...]

> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index e505e1fbd2b9..f06e1da1d678 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -14,15 +14,8 @@
>  #include <asm/hwcap.h>
>  #include <asm/sysreg.h>
>  
> -/*
> - * In the arm64 world (as in the ARM world), elf_hwcap is used both internally
> - * in the kernel and for user space to keep track of which optional features
> - * are supported by the current system. So let's map feature 'x' to HWCAP_x.
> - * Note that HWCAP_x constants are bit fields so we need to take the log.
> - */
> -
> -#define MAX_CPU_FEATURES	(8 * sizeof(elf_hwcap))
> -#define cpu_feature(x)		ilog2(HWCAP_ ## x)
> +#define MAX_CPU_FEATURES	64
> +#define cpu_feature(x)		(KERNEL_HWCAP_ ## x)

Nit: do we need the () here?  They may be defensive, but I'm not sure
they're required.

[...]

> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> index 400b80b49595..d21fe3314d90 100644
> --- a/arch/arm64/include/asm/hwcap.h
> +++ b/arch/arm64/include/asm/hwcap.h
> @@ -39,12 +39,59 @@
>  #define COMPAT_HWCAP2_SHA2	(1 << 3)
>  #define COMPAT_HWCAP2_CRC32	(1 << 4)
>  
> +/*
> + * For userspace we represent hwcaps as a collection of HWCAP{,2}_x bitfields
> + * as described in uapi/asm/hwcap.h. For the kernel we represent hwcaps as
> + * natural numbers (in a single range of size MAX_CPU_FEATURES) defined here
> + * with prefix KERNEL_HWCAP_ mapped to their HWCAP{,2}_x counterpart.
> + *
> + * Hwcaps should be set and tested within the kernel via the
> + * cpu_{set,have}_named_feature(feature) where feature is the unique suffix
> + * of KERNEL_HWCAP_{feature}.
> + */
> +#define KERNEL_HWCAP_FP			ilog2(HWCAP_FP)
> +#define KERNEL_HWCAP_ASIMD		ilog2(HWCAP_ASIMD)
> +#define KERNEL_HWCAP_EVTSTRM		ilog2(HWCAP_EVTSTRM)
> +#define KERNEL_HWCAP_AES		ilog2(HWCAP_AES)
> +#define KERNEL_HWCAP_PMULL		ilog2(HWCAP_PMULL)
> +#define KERNEL_HWCAP_SHA1		ilog2(HWCAP_SHA1)
> +#define KERNEL_HWCAP_SHA2		ilog2(HWCAP_SHA2)
> +#define KERNEL_HWCAP_CRC32		ilog2(HWCAP_CRC32)
> +#define KERNEL_HWCAP_ATOMICS		ilog2(HWCAP_ATOMICS)
> +#define KERNEL_HWCAP_FPHP		ilog2(HWCAP_FPHP)
> +#define KERNEL_HWCAP_ASIMDHP		ilog2(HWCAP_ASIMDHP)
> +#define KERNEL_HWCAP_CPUID		ilog2(HWCAP_CPUID)
> +#define KERNEL_HWCAP_ASIMDRDM		ilog2(HWCAP_ASIMDRDM)
> +#define KERNEL_HWCAP_JSCVT		ilog2(HWCAP_JSCVT)
> +#define KERNEL_HWCAP_FCMA		ilog2(HWCAP_FCMA)
> +#define KERNEL_HWCAP_LRCPC		ilog2(HWCAP_LRCPC)
> +#define KERNEL_HWCAP_DCPOP		ilog2(HWCAP_DCPOP)
> +#define KERNEL_HWCAP_SHA3		ilog2(HWCAP_SHA3)
> +#define KERNEL_HWCAP_SM3		ilog2(HWCAP_SM3)
> +#define KERNEL_HWCAP_SM4		ilog2(HWCAP_SM4)
> +#define KERNEL_HWCAP_ASIMDDP		ilog2(HWCAP_ASIMDDP)
> +#define KERNEL_HWCAP_SHA512		ilog2(HWCAP_SHA512)
> +#define KERNEL_HWCAP_SVE		ilog2(HWCAP_SVE)
> +#define KERNEL_HWCAP_ASIMDFHM		ilog2(HWCAP_ASIMDFHM)
> +#define KERNEL_HWCAP_DIT		ilog2(HWCAP_DIT)
> +#define KERNEL_HWCAP_USCAT		ilog2(HWCAP_USCAT)
> +#define KERNEL_HWCAP_ILRCPC		ilog2(HWCAP_ILRCPC)
> +#define KERNEL_HWCAP_FLAGM		ilog2(HWCAP_FLAGM)
> +#define KERNEL_HWCAP_SSBS		ilog2(HWCAP_SSBS)
> +#define KERNEL_HWCAP_SB			ilog2(HWCAP_SB)
> +#define KERNEL_HWCAP_PACA		ilog2(HWCAP_PACA)
> +#define KERNEL_HWCAP_PACG		ilog2(HWCAP_PACG)
> +#define KERNEL_HWCAP_DCPODP		(ilog2(HWCAP2_DCPODP) + 32)

Nit: can we wrap this so that the "+ 32" doesn't have to be spelled out
each time?

If we are splitting ths CVADP support from this patch, then dropping
such a wrapper macro here (maybe with a comment) will serve as a
placeholder for whichever patch wins the race for the first HWCAP2
flag.

Say

#define __khwcap2_feature(x) (ilog2(HWCAP2_ ## xx) + 32)

(Optionally, we could also have __khwcap_feature() too so that
everything looks nice and regular.)

[...]

> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index aa4ec53281ce..6cc8aff83805 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -833,7 +833,11 @@ static void arch_timer_evtstrm_enable(int divider)
>  	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
>  			| ARCH_TIMER_VIRT_EVT_EN;
>  	arch_timer_set_cntkctl(cntkctl);
> +#ifdef CONFIG_ARM64
> +	cpu_set_named_feature(EVTSTRM);
> +#else
>  	elf_hwcap |= HWCAP_EVTSTRM;
> +#endif

I wonder whether we can have a generic definition for this:

#define cpu_set_named_feature(x) (elf_hwcap |= HWCAP_ ## x)

seems a reasonable fallback when the arch doesn't provide its own
version.


Although we don't have many instances, it would still be nice to avoid
ifdeffery creeping in.

[...]

We can probably pull the Documentation/arm64/elf_hwcaps.txt changes into
this patch.

It probably makes sense to pull the Documentation/arm64/elf_hwcaps.txt
updates alongside this patch in the series (or even incorporate them
into this patch, since they're not huge.)

Other than that, looks reasonable to me.

Cheers
---Dave
