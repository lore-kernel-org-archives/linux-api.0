From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 03/22] fpga: bridge: remove OF dependency for
 fpga-bridge
Date: Fri, 22 Sep 2017 10:15:01 +0800
Message-ID: <20170922021501.GA15082@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-4-git-send-email-hao.wu@intel.com>
 <20170921191109.GA7814@tyrael.ni.corp.natinst.com>
 <CANk1AXRbXybjwq-ha=G6Z7nXwd8fNjPWP5awTz6=23KVXbd=kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXRbXybjwq-ha=G6Z7nXwd8fNjPWP5awTz6=23KVXbd=kQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 21, 2017 at 02:50:07PM -0500, Alan Tull wrote:
> On Thu, Sep 21, 2017 at 2:11 PM, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> Hi Moritz,
> 
> > Hi,
> >
> > On Mon, Jun 26, 2017 at 09:51:59AM +0800, Wu Hao wrote:
> >> This patch removes OF dependency of fpga-bridge, it allows drivers
> >> to use fpga-bridge class without device tree support.
> >>
> >> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  drivers/fpga/Kconfig | 1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> >> index ed600d5..c1d8f41 100644
> >> --- a/drivers/fpga/Kconfig
> >> +++ b/drivers/fpga/Kconfig
> >> @@ -75,7 +75,6 @@ config FPGA_MGR_ZYNQ_FPGA
> >>
> >>  config FPGA_BRIDGE
> >>       tristate "FPGA Bridge Framework"
> >> -     depends on OF
> >
> > Shouldn't that dependency be removed in the patch that removes the
> > dependency, or was the dependency never there in the first place?
> 
> It wasn't dependent on OF in the first place.

Hi Alan / Moritz

I see this change has been integrated into below patch from Alan.

[PATCH v4 15/18] fpga: region: move device tree support to of-fpga-region.c

so I think I can drop this patch in my next version patch set. : )

Thanks
Hao

> 
> Thanks,
> Alan
> 
> >
> >>       help
> >>         Say Y here if you want to support bridges connected between host
> >>         processors and FPGAs or between FPGAs.
> >> --
> >> 1.8.3.1
> >>
> >
> > Thanks,
> >
> > Moritz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
