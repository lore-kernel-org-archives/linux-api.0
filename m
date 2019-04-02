From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 6/7] arm64: Advertise ARM64_HAS_DCPODP cpu feature
Date: Tue, 2 Apr 2019 15:59:58 +0100
Message-ID: <20190402145958.GJ3567@e103592.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-7-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190401104515.39775-7-andrew.murray@arm.com>
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

On Mon, Apr 01, 2019 at 11:45:14AM +0100, Andrew Murray wrote:
> Advertise ARM64_HAS_DCPOP when both DC CVAP and DC CVADP are supported.

Do you mean ARM64_HAS_DCPODP?

And do we need this?  This capability flag doesn't currently appear to
be used for anything (which makes me wonder whether it _should_ be wired
up to something in the kernel).

Do we expect the kernel to do something special with this in the future?

OTOH, we get a nice printk when the feature is detected, and the code
size cost is insignificant.  So, if there's a reasonable expectation that
we will use it someday, I don't see a big problem with having it.

Cheers
---Dave

> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/include/asm/cpucaps.h | 3 ++-
>  arch/arm64/kernel/cpufeature.c   | 9 +++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index f6a76e43f39e..defdc67d9ab4 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -61,7 +61,8 @@
>  #define ARM64_HAS_GENERIC_AUTH_ARCH		40
>  #define ARM64_HAS_GENERIC_AUTH_IMP_DEF		41
>  #define ARM64_HAS_IRQ_PRIO_MASKING		42
> +#define ARM64_HAS_DCPODP			43
>  
> -#define ARM64_NCAPS				43
> +#define ARM64_NCAPS				44
>  
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 5e27d2dbe45e..c74b25895c43 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1339,6 +1339,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
>  		.min_field_value = 1,
>  	},
> +	{
> +		.desc = "Data cache clean to Point of Deep Persistence",
> +		.capability = ARM64_HAS_DCPODP,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		.sys_reg = SYS_ID_AA64ISAR1_EL1,
> +		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
> +		.min_field_value = 2,
> +	},
>  #endif
>  #ifdef CONFIG_ARM64_SVE
>  	{
> -- 
> 2.21.0
> 
