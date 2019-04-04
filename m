From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v4 1/6] arm64: HWCAP: add support for AT_HWCAP2
Date: Thu, 4 Apr 2019 13:47:00 +0100
Message-ID: <20190404124659.GE3567@e103592.cambridge.arm.com>
References: <20190403105628.39798-1-andrew.murray@arm.com>
 <20190403105628.39798-2-andrew.murray@arm.com>
 <20190403132112.GP3567@e103592.cambridge.arm.com>
 <20190403160622.GM53702@e119886-lin.cambridge.arm.com>
 <20190403163302.GV3567@e103592.cambridge.arm.com>
 <20190404112549.GN53702@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190404112549.GN53702@e119886-lin.cambridge.arm.com>
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

On Thu, Apr 04, 2019 at 12:25:50PM +0100, Andrew Murray wrote:
> On Wed, Apr 03, 2019 at 05:33:03PM +0100, Dave Martin wrote:
> > On Wed, Apr 03, 2019 at 05:06:23PM +0100, Andrew Murray wrote:
> > > On Wed, Apr 03, 2019 at 02:21:12PM +0100, Dave Martin wrote:
> > > > On Wed, Apr 03, 2019 at 11:56:23AM +0100, Andrew Murray wrote:
> > > > > As we will exhaust the first 32 bits of AT_HWCAP let's start
> > > > > exposing AT_HWCAP2 to userspace to give us up to 64 caps.
> > > > > 
> > > > > Whilst it's possible to use the remaining 32 bits of AT_HWCAP, we
> > > > > prefer to expand into AT_HWCAP2 in order to provide a consistent
> > > > > view to userspace between ILP32 and LP64. However internal to the
> > > > > kernel we prefer to continue to use the full space of elf_hwcap.
> > > > > 
> > > > > To reduce complexity and allow for future expansion, we now
> > > > > represent hwcaps in the kernel as ordinals and use a
> > > > > KERNEL_HWCAP_ prefix. This allows us to support automatic feature
> > > > > based module loading for all our hwcaps.
> > > > > 
> > > > > We introduce cpu_set_feature to set hwcaps which complements the
> > > > > existing cpu_have_feature helper. These helpers allow us to clean
> > > > > up existing direct uses of elf_hwcap and reduce any future effort
> > > > > required to move beyond 64 caps.
> > > > > 
> > > > > For convenience we also introduce cpu_{have,set}_named_feature which
> > > > > makes use of the cpu_feature macro to allow providing a hwcap name
> > > > > without a {KERNEL_}HWCAP_ prefix.
> > > > > 
> > > > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > > 
> > > > [...]
> > > > 
> > > > > diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> > > > > index 400b80b49595..1f38a2740f7a 100644
> > > > > --- a/arch/arm64/include/asm/hwcap.h
> > > > > +++ b/arch/arm64/include/asm/hwcap.h
> > > > > @@ -39,12 +39,61 @@
> > > > >  #define COMPAT_HWCAP2_SHA2	(1 << 3)
> > > > >  #define COMPAT_HWCAP2_CRC32	(1 << 4)
> > > > >  
> > > > > +/*
> > > > > + * For userspace we represent hwcaps as a collection of HWCAP{,2}_x bitfields
> > > > > + * as described in uapi/asm/hwcap.h. For the kernel we represent hwcaps as
> > > > > + * natural numbers (in a single range of size MAX_CPU_FEATURES) defined here
> > > > > + * with prefix KERNEL_HWCAP_ mapped to their HWCAP{,2}_x counterpart.
> > > > > + *
> > > > > + * Hwcaps should be set and tested within the kernel via the
> > > > > + * cpu_{set,have}_named_feature(feature) where feature is the unique suffix
> > > > > + * of KERNEL_HWCAP_{feature}.
> > > > > + */
> > > > > +#define __khwcap_feature(x)		ilog2(HWCAP_ ## x)
> > > > 
> > > > Hmm, I didn't spot this before, but we should probably include
> > > > <linux/log2.h>.  This isn't asm-friendly however.
> > > 
> > > Doh!
> > > 
> > > > 
> > > > <asm/hwcap.h> gets included (unnecessarily?) by arch/arm64/mm/proc.S and
> > > > arch/arm64/include/uapi/asm/ptrace.h.
> > > 
> > > I also can't see any reason why either of these files includes hwcap.h...
> > 
> > Maybe we could just drop that include from proc.S.
> > 
> > > > Rather than risk breaking a UAPI header, can we remove the ilog2() here
> > > > and add it back into cpu_feature() where it was originally?
> > > 
> > > No I don't think we can. 
> > 
> > Agreed: userspace may be relying (however unwisely) on getting the
> > hwcaps as a side-effect of <uapi/asm/ptrace.h>, so we can't do much
> > about that one without taking a risk.
> > 
> > > > There may be a reason why this didn't work that I've forgotten...
> > > 
> > > We need the UAPI HWCAP_xx's to be bitfields and we've decided that we should
> > > limit them to 32 bits. Thus UAPI HWCAP2_xx's will also live within the first
> > > 32 bits meaning that we can't distinguish between them based on their value.
> > > 
> > > This isn't ideal within the kernel, as it means if we store the value
> > > anywhere (such as struct arm64_cpu_capabilities) then we need to also store
> > > some additional information to identify if it's AT_HWCAP or AT_HWCAP2.
> > 
> > But we could keep shadow kernel #defines that (for hwcap2) are shifted
> > up by 32 bits?  This required anything that deals with hwcap numbers to
> > cope with them being giant numbers that fit in an unsigned long, not
> > just small intergers (which possibly doesn't work without core changes?)
> > 
> > > In some cases (automatic hwcap based module loading) it's not possible to work
> > > around this - which is why arm32 can only support this for their elf_hwcap2.
> > > The approach this series takes allows automatic module loading to work based
> > > on any hwcap.
> > > 
> > > The solutions I can come up with at the moment are:
> > > 
> > >  - hard code the mapping without ilog2, as follows, though this is error
> > >    prone
> > > 
> > > #define KERNEL_HWCAP_ASIMD              2
> > > 
> > >  - Move the #ifndef __ASSEMBLY__ in include/asm/hwcap.h above the definitions
> > >    of KERNEL_HWCAP_xx and include <linux/log2.h> under __ASSEMBLY__. This works
> > >    but we can't test for hwcaps in assembly - maybe this isn't a problem?
> > 
> > Since this is a kernel header, this is probably OK: is asm needs the
> > hwcaps, sooner or later someone will need to fix it.
> > 
> > Possibly there are out-of-tree drivers relying on using the hwcaps from
> > assembly, but that's probably their own problem.
> > 
> > So, either move the #ifndef for simplicity, or introduce the ordinals
> > into <uapi/asm/hwcap.h>:
> > 
> > #define __HWCAP_NR_FP		0
> > #define __HWCAP_NR_ASIMD	1
> > #define __HWCAP_NR_EVTSTRM	2
> > 
> > ...
> > 
> > #define HWCAP_FP	(1UL << __HWCAP_NR_FP)
> > #define HWCAP_ASIMD 	(1UL << __HWCAP_NR_ASIMD)
> > #define HWCAP_EVTSTRM	(1UL << __HWCAP_NR_EVTSTRM)
> > 
> > ...
> > 
> > #define __HWCAP2_NR_DCPODP	0
> > 
> > #define HWCAP2_DCPODP	(1UL << __HWCAP2_NR_DCPODP)
> > 
> > ...
> > 
> > then use the __HWCAP{,2}_NR_ constants directly place of the
> > KERNEL_HWCAP_ #defines, or define the KERNEL_HWCAP defined in terms of
> > them.
> 
> Though we'd still have to add 32 to the HWCAP2's for asm/hwcap.h (thus
> justifying the continued use of KERNEL_HWCAP).
>
> > This is a noisy approach though, and I'm not totally convinced it's
> > better.
> > 
> > What do you think?
> 
> The only downside to this, is that we create another set of defines per
> HWCAP (bringing it up to 3) - these feels excessive.

I can't really argue with that.

> I'll stick with moving the #ifndef for now.

Probably makes sense for now, if there's no other straightforward
solution.

Cheers
---Dave
