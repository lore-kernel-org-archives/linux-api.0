From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v3 3/7] arm64: HWCAP: encapsulate elf_hwcap
Date: Tue, 2 Apr 2019 16:06:55 +0100
Message-ID: <20190402150654.GD53702@e119886-lin.cambridge.arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-4-andrew.murray@arm.com>
 <20190402145821.GH3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190402145821.GH3567@e103592.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, libc-alpha@sourceware.org, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Phil Blundell <pb@pbcl.net>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 02, 2019 at 03:58:21PM +0100, Dave Martin wrote:
> On Mon, Apr 01, 2019 at 11:45:11AM +0100, Andrew Murray wrote:
> > The introduction of AT_HWCAP2 introduced accessors which ensure that
> > hwcap features are set and tested appropriately.
> > 
> > Let's now mandate access to elf_hwcap via these accessors by making
> > elf_hwcap static within cpufeature.c.
> 
> Looks reasonable except for a couple of minor nits below.
> 
> I had wondered whether putting these accessors out of line would affect
> any hot paths, but I can't see these used from anything that looks like
> a hot path.  So we're probably fine.
> 
> cpus_have_const_cap() is preferred for places where this matters,
> anyway.
> 
> [...]
> 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 986ceeacd19f..84ca52fa75e5 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -35,8 +35,7 @@
> >  #include <asm/traps.h>
> >  #include <asm/virt.h>
> >  
> > -unsigned long elf_hwcap __read_mostly;
> > -EXPORT_SYMBOL_GPL(elf_hwcap);
> > +static unsigned long elf_hwcap __read_mostly;
> 
> Now that this doesn't correspond directly to ELF_HWCAP any more and we
> hide it, can we rename it to avoid confusion?
> 
> Maybe "kernel_hwcap"?

Yes this seems reasonable.

> 
> >  #ifdef CONFIG_COMPAT
> >  #define COMPAT_ELF_HWCAP_DEFAULT	\
> > @@ -1947,6 +1946,35 @@ bool this_cpu_has_cap(unsigned int n)
> >  	return false;
> >  }
> >  
> > +void cpu_set_feature(unsigned int num)
> > +{
> > +	WARN_ON(num >= MAX_CPU_FEATURES);
> > +	elf_hwcap |= BIT(num);
> > +}
> > +EXPORT_SYMBOL_GPL(cpu_set_feature);
> > +
> > +bool cpu_have_feature(unsigned int num)
> > +{
> > +	WARN_ON(num >= MAX_CPU_FEATURES);
> > +	return elf_hwcap & BIT(num);
> > +}
> > +EXPORT_SYMBOL_GPL(cpu_have_feature);
> > +
> > +unsigned long cpu_get_elf_hwcap(void)
> > +{
> > +	/*
> > +	 * We currently only populate the first 32 bits of AT_HWCAP. Please
> > +	 * note that for userspace compatibility we guarantee that bit 62
> > +	 * will always be returned as 0.
> > +	 */
> 
> Presumably also bit 63?

Yes, I will add this too.

> 
> It is reasonable to say this here, but I think there should also be a
> note in Documentation/arm64/elf_hwcaps.txt.

This is already present in this series, I'll update it to reflect bit 63
also. 

Thanks,

Andrew Murray

> 
> [...]
> 
> Cheers
> ---Dave
