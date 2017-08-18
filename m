From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 20/22] fpga: intel: afu add
 FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Fri, 18 Aug 2017 11:20:34 +0800
Message-ID: <20170818032034.GB25457@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-21-git-send-email-hao.wu@intel.com>
 <CAAtXAHdyCNBRHdk-9L+AOT7g7BEsxBN-EkdhxO2-aSqdDovTHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAtXAHdyCNBRHdk-9L+AOT7g7BEsxBN-EkdhxO2-aSqdDovTHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>
Cc: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 17, 2017 at 12:12:00PM -0700, Moritz Fischer wrote:
> Hi,
> 
> On Sun, Jun 25, 2017 at 6:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones which
> > need to be supported by all feature devices drivers including FME and AFU.
> > This patch implements above 2 ioctls in Intel FPGA Accelerated Function
> > Unit (AFU) driver.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > v2: rebased
> > ---
> >  drivers/fpga/intel-afu-main.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/fpga/intel-afu-main.c b/drivers/fpga/intel-afu-main.c
> > index 2a17cde..22f77f2 100644
> > --- a/drivers/fpga/intel-afu-main.c
> > +++ b/drivers/fpga/intel-afu-main.c
> > @@ -122,6 +122,13 @@ static int afu_release(struct inode *inode, struct file *filp)
> >         return 0;
> >  }
> >
> > +static long afu_ioctl_check_extension(struct feature_platform_data *pdata,
> > +                                    unsigned long arg)
> > +{
> > +       /* No extension support for now */
> 
> Do you maybe make that an -ENOTSUPP or -EINVAL then?

Hi Moritz

User will use this ioctl to check if extension X is supported. It always returns 0
means any extension indicated by the arg, is not supported.

I think we don't have to return an -ENOTSUPP or -EINVAL here, which may confuse
the enduser. : )

Thanks
Hao

> > +       return 0;
> > +}
> > +
> >  static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  {
> >         struct platform_device *pdev = filp->private_data;
> > @@ -132,6 +139,10 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >         dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
> >
> >         switch (cmd) {
> > +       case FPGA_GET_API_VERSION:
> > +               return FPGA_API_VERSION;
> > +       case FPGA_CHECK_EXTENSION:
> > +               return afu_ioctl_check_extension(pdata, arg);
> >         default:
> >                 /*
> >                  * Let sub-feature's ioctl function to handle the cmd
> > --
> > 1.8.3.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Thanks,
> 
> Moritz
