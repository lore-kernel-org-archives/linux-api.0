From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v4 1/6] arm64: HWCAP: add support for AT_HWCAP2
Date: Wed, 3 Apr 2019 14:21:12 +0100
Message-ID: <20190403132112.GP3567@e103592.cambridge.arm.com>
References: <20190403105628.39798-1-andrew.murray@arm.com>
 <20190403105628.39798-2-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190403105628.39798-2-andrew.murray@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Phil Blundell <pb@pbcl.net>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 03, 2019 at 11:56:23AM +0100, Andrew Murray wrote:
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
> We introduce cpu_set_feature to set hwcaps which complements the
> existing cpu_have_feature helper. These helpers allow us to clean
> up existing direct uses of elf_hwcap and reduce any future effort
> required to move beyond 64 caps.
> 
> For convenience we also introduce cpu_{have,set}_named_feature which
> makes use of the cpu_feature macro to allow providing a hwcap name
> without a {KERNEL_}HWCAP_ prefix.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

[...]

> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> index 400b80b49595..1f38a2740f7a 100644
> --- a/arch/arm64/include/asm/hwcap.h
> +++ b/arch/arm64/include/asm/hwcap.h
> @@ -39,12 +39,61 @@
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
> +#define __khwcap_feature(x)		ilog2(HWCAP_ ## x)

Hmm, I didn't spot this before, but we should probably include
<linux/log2.h>.  This isn't asm-friendly however.

<asm/hwcap.h> gets included (unnecessarily?) by arch/arm64/mm/proc.S and
arch/arm64/include/uapi/asm/ptrace.h.

Rather than risk breaking a UAPI header, can we remove the ilog2() here
and add it back into cpu_feature() where it was originally?

There may be a reason why this didn't work that I've forgotten...

cpufeatures is the only place where we use the KERNEL_HWCAP_foo flags
directly.

> +#define KERNEL_HWCAP_FP			__khwcap_feature(FP)
> +#define KERNEL_HWCAP_ASIMD		__khwcap_feature(ASIMD)
> +#define KERNEL_HWCAP_EVTSTRM		__khwcap_feature(EVTSTRM)

[...]

Otherwise, looks OK to me.

Cheers
---Dave
