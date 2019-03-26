From: Scott Wood <swood@redhat.com>
Subject: Re: [PATCH 03/17] fpga: dfl: fme: support 512bit data width PR
Date: Tue, 26 Mar 2019 16:22:34 -0500
Message-ID: <580c6c604d3915c105f076fc7f22ab5da98598fc.camel@redhat.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
         <1553483264-5379-4-git-send-email-hao.wu@intel.com>
         <127a9356a7bf597d35dd361f2b16bf80460f0370.camel@redhat.com>
         <655bf2991a4f8bf6a473c91218d6dba7748520aa.camel@redhat.com>
         <CANk1AXSBHAudsLfNkSK1OuE6R9bogo6jW9bYmmZdvweTt3eCiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANk1AXSBHAudsLfNkSK1OuE6R9bogo6jW9bYmmZdvweTt3eCiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Wu Hao <hao.wu@intel.com>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2019-03-26 at 14:33 -0500, Alan Tull wrote:
> On Mon, Mar 25, 2019 at 5:58 PM Scott Wood <swood@redhat.com> wrote:
> 
> Hi Scott,
> 
> > On Mon, 2019-03-25 at 17:53 -0500, Scott Wood wrote:
> > > On Mon, 2019-03-25 at 11:07 +0800, Wu Hao wrote:
> > > > +#if defined(CONFIG_X86) && defined(CONFIG_AS_AVX512)
> > > > +
> > > > +#include <asm/fpu/api.h>
> > > > +
> > > > +static inline void copy512(void *src, void __iomem *dst)
> > > > +{
> > > > +   kernel_fpu_begin();
> > > > +
> > > > +   asm volatile("vmovdqu64 (%0), %%zmm0;"
> > > > +                "vmovntdq %%zmm0, (%1);"
> > > > +                :
> > > > +                : "r"(src), "r"(dst));
> > > > +
> > > > +   kernel_fpu_end();
> > > > +}
> > > 
> > > Shouldn't there be some sort of check that AVX512 is actually
> > > supported
> > > on the running system?
> > > 
> > > Also, src should be const, and the asm statement should have a memory
> > > clobber.
> > > 
> > > > +#else
> > > > +static inline void copy512(void *src, void __iomem *dst)
> > > > +{
> > > > +   WARN_ON_ONCE(1);
> > > > +}
> > > > +#endif
> > > 
> > > Likewise, this will be called if a revision 2 device is used on non-
> > > x86
> > > (or on x86 with an old binutils).  The driver should fall back to 32-
> > > bit
> > > in such cases.
> > 
> > Sorry, I missed the comment about revision 2 only being on integrated
> > devices -- but will that always be the case?  Seems worthwhile to check
> > for
> > AVX512 support anyway.  And there's still the possibility of being built
> > with an old binutils such that CONFIG_AS_AVX512 is not set, or running
> > on a
> > kernel where avx512 was disabled via a boot option.
> 
> The code checks for CONFIG_AS_AVX512 above.

That just indicates that binutils supports it.  Plus, the code does not
check for CONFIG_AS_AVX512 when deciding whether to set pr_datawidth to 64
(and thus call copy512), so you'll get a WARN_ON rather than falling back to
32-bit.

> What boot option are you referring to?

clearcpuid=304

-Scott
