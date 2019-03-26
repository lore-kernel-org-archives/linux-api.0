From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 03/17] fpga: dfl: fme: support 512bit data width PR
Date: Tue, 26 Mar 2019 14:33:54 -0500
Message-ID: <CANk1AXSBHAudsLfNkSK1OuE6R9bogo6jW9bYmmZdvweTt3eCiA@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-4-git-send-email-hao.wu@intel.com> <127a9356a7bf597d35dd361f2b16bf80460f0370.camel@redhat.com>
 <655bf2991a4f8bf6a473c91218d6dba7748520aa.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <655bf2991a4f8bf6a473c91218d6dba7748520aa.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Wood <swood@redhat.com>
Cc: Wu Hao <hao.wu@intel.com>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 5:58 PM Scott Wood <swood@redhat.com> wrote:

Hi Scott,

>
> On Mon, 2019-03-25 at 17:53 -0500, Scott Wood wrote:
> > On Mon, 2019-03-25 at 11:07 +0800, Wu Hao wrote:
> > > In early partial reconfiguration private feature, it only
> > > supports 32bit data width when writing data to hardware for
> > > PR. 512bit data width PR support is an important optimization
> > > for some specific solutions (e.g. XEON with FPGA integrated),
> > > it allows driver to use AVX512 instruction to improve the
> > > performance of partial reconfiguration. e.g. programming one
> > > 100MB bitstream image via this 512bit data width PR hardware
> > > only takes ~300ms, but 32bit revision requires ~3s per test
> > > result.
> > >
> > > Please note now this optimization is only done on revision 2
> > > of this PR private feature which is only used in integrated
> > > solution that AVX512 is always supported.
> > >
> > > Signed-off-by: Ananda Ravuri <ananda.ravuri@intel.com>
> > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > > ---
> > >  drivers/fpga/dfl-fme-main.c |  3 ++
> > >  drivers/fpga/dfl-fme-mgr.c  | 75 +++++++++++++++++++++++++++++++++++++-
> > > --
> > > -----
> > >  drivers/fpga/dfl-fme-pr.c   | 45 ++++++++++++++++-----------
> > >  drivers/fpga/dfl-fme.h      |  2 ++
> > >  drivers/fpga/dfl.h          |  5 +++
> > >  5 files changed, 99 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
> > > index 086ad24..076d74f 100644
> > > --- a/drivers/fpga/dfl-fme-main.c
> > > +++ b/drivers/fpga/dfl-fme-main.c
> > > @@ -21,6 +21,8 @@
> > >  #include "dfl.h"
> > >  #include "dfl-fme.h"
> > >
> > > +#define DRV_VERSION        "0.8"
> >
> > What is this going to be used for?  Under what circumstances will the
> > driver version be bumped?  What does it have to do with 512-bit writes?
> >
> > > +#if defined(CONFIG_X86) && defined(CONFIG_AS_AVX512)
> > > +
> > > +#include <asm/fpu/api.h>
> > > +
> > > +static inline void copy512(void *src, void __iomem *dst)
> > > +{
> > > +   kernel_fpu_begin();
> > > +
> > > +   asm volatile("vmovdqu64 (%0), %%zmm0;"
> > > +                "vmovntdq %%zmm0, (%1);"
> > > +                :
> > > +                : "r"(src), "r"(dst));
> > > +
> > > +   kernel_fpu_end();
> > > +}
> >
> > Shouldn't there be some sort of check that AVX512 is actually supported
> > on the running system?
> >
> > Also, src should be const, and the asm statement should have a memory
> > clobber.
> >
> > > +#else
> > > +static inline void copy512(void *src, void __iomem *dst)
> > > +{
> > > +   WARN_ON_ONCE(1);
> > > +}
> > > +#endif
> >
> > Likewise, this will be called if a revision 2 device is used on non-x86
> > (or on x86 with an old binutils).  The driver should fall back to 32-bit
> > in such cases.
>
> Sorry, I missed the comment about revision 2 only being on integrated
> devices -- but will that always be the case?  Seems worthwhile to check for
> AVX512 support anyway.  And there's still the possibility of being built
> with an old binutils such that CONFIG_AS_AVX512 is not set, or running on a
> kernel where avx512 was disabled via a boot option.

The code checks for CONFIG_AS_AVX512 above.

What boot option are you referring to?

Alan

>
> What about future revisions >= 2?  Currently the driver will treat them as
> if they were revision < 2.  Is that intended?
>
> -Scott
>
>
