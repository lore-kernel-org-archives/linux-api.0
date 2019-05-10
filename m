From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v2 17/18] fpga: dfl: fme: add global error reporting
 support
Date: Fri, 10 May 2019 10:23:29 +0800
Message-ID: <20190510022329.GA12617@hao-dev>
References: <1556528151-17221-1-git-send-email-hao.wu@intel.com>
 <1556528151-17221-18-git-send-email-hao.wu@intel.com>
 <CANk1AXRpBe=8Jh+_ZMfARSdXZmrQaN3jc0AfxoX2nP5sLESv2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXRpBe=8Jh+_ZMfARSdXZmrQaN3jc0AfxoX2nP5sLESv2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 09, 2019 at 11:27:36AM -0500, Alan Tull wrote:
> On Mon, Apr 29, 2019 at 4:13 AM Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> The changes look good.  There's one easy to fix thing that Greg has
> pointed out recently on another patch (below).
> 
> >
> > This patch adds support for global error reporting for FPGA
> > Management Engine (FME), it introduces sysfs interfaces to
> > report different error detected by the hardware, and allow
> > user to clear errors or inject error for testing purpose.
> >
> > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > Signed-off-by: Ananda Ravuri <ananda.ravuri@intel.com>
> > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> 
> Acked-by: Alan Tull <atull@kernel.org>
> 
> > ---
> > v2: fix issues found in sysfs doc.
> >     fix returned error code issues for writable sysfs interfaces.
> >     (use -EINVAL if input doesn't match error code)
> >     reorder the sysfs groups in code.
> 
> > +static ssize_t revision_show(struct device *dev, struct device_attribute *attr,
> > +                            char *buf)
> > +{
> > +       struct device *err_dev = dev->parent;
> > +       void __iomem *base;
> > +
> > +       base = dfl_get_feature_ioaddr_by_id(err_dev, FME_FEATURE_ID_GLOBAL_ERR);
> > +
> > +       return scnprintf(buf, PAGE_SIZE, "%u\n", dfl_feature_revision(base));
> 
> Greg is discouraging use of scnprintf for sysfs attributes where it's
> not needed [1].
> 
> Please fix this up the attributes added in this patchset.  Besides
> that, looks good, I added my Ack.

Sure, will fix them in the next patchset.

thanks a lot!

Hao

> 
> Alan
> 
> > +}
> > +static DEVICE_ATTR_RO(revision);
> 
> [1] https://lkml.org/lkml/2019/4/25/1050
