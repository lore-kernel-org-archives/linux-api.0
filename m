From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 10/24] fpga: dfl: add FPGA Management Engine driver
 basic framework
Date: Fri, 6 Apr 2018 19:04:39 +0800
Message-ID: <20180406110439.GB32345@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-11-git-send-email-hao.wu@intel.com>
 <CANk1AXQidwWhHfHd-usQVdK3jZbJuB3y8=NK7y5K_h_8eJhjAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXQidwWhHfHd-usQVdK3jZbJuB3y8=NK7y5K_h_8eJhjAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 05, 2018 at 01:35:24PM -0500, Alan Tull wrote:
> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> > From: Kang Luwei <luwei.kang@intel.com>
> >
> > The FPGA Management Engine (FME) provides power, thermal management,
> > performance counters, partial reconfiguration and other functions. For each
> > function, it is packaged into a private feature linked to the FME feature
> > device in the 'Device Feature List'. It's a platform device created by
> > DFL framework.
> >
> > This patch adds the basic framework of FME platform driver. It defines
> > sub feature drivers to handle the different sub features, including init,
> > uinit and ioctl. It also registers the file operations for the device file.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Kang Luwei <luwei.kang@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > ---
> > v3: rename driver from intel-fpga-fme to dfl-fme
> >     rename Kconfig from INTEL_FPGA_FME to FPGA_DFL_FME
> > v4: fix SPDX license issue, use dfl-fme as module name
> > ---
> >  drivers/fpga/Kconfig        |  10 +++
> >  drivers/fpga/Makefile       |   3 +
> >  drivers/fpga/dfl-fme-main.c | 158 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 171 insertions(+)
> >  create mode 100644 drivers/fpga/dfl-fme-main.c
> >
> > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> > index 87f3d44..103d5e2 100644
> > --- a/drivers/fpga/Kconfig
> > +++ b/drivers/fpga/Kconfig
> > @@ -140,6 +140,16 @@ config FPGA_DFL
> >           Gate Array (FPGA) solutions which implement Device Feature List.
> >           It provides enumeration APIs, and feature device infrastructure.
> >
> > +config FPGA_DFL_FME
> > +       tristate "FPGA DFL FME Driver"
> > +       depends on FPGA_DFL
> > +       help
> > +         The FPGA Management Engine (FME) is a feature device implemented
> > +         under Device Feature List (DFL) framework. Select this option to
> > +         enable the platform device driver for FME which implements all
> > +         FPGA platform level management features. There shall be 1 FME
> > +         per DFL based FPGA device.
> > +
> >  config FPGA_DFL_PCI
> >         tristate "FPGA Device Feature List (DFL) PCIe Device Driver"
> >         depends on PCI && FPGA_DFL
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index 4375630..fbd1c85 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -30,6 +30,9 @@ obj-$(CONFIG_OF_FPGA_REGION)          += of-fpga-region.o
> >
> >  # FPGA Device Feature List Support
> >  obj-$(CONFIG_FPGA_DFL)                 += dfl.o
> > +obj-$(CONFIG_FPGA_DFL_FME)             += dfl-fme.o
> > +
> > +dfl-fme-objs := dfl-fme-main.o
> >
> >  # Drivers for FPGAs which implement DFL
> >  obj-$(CONFIG_FPGA_DFL_PCI)             += dfl-pci.o
> > diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
> > new file mode 100644
> > index 0000000..ebe6b52
> > --- /dev/null
> > +++ b/drivers/fpga/dfl-fme-main.c
> > @@ -0,0 +1,158 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Driver for FPGA Management Engine (FME)
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Kang Luwei <luwei.kang@intel.com>
> > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > + *   Joseph Grecco <joe.grecco@intel.com>
> > + *   Enno Luebbers <enno.luebbers@intel.com>
> > + *   Tim Whisonant <tim.whisonant@intel.com>
> > + *   Ananda Ravuri <ananda.ravuri@intel.com>
> > + *   Henry Mitchel <henry.mitchel@intel.com>
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +
> > +#include "dfl.h"
> > +
> > +static int fme_hdr_init(struct platform_device *pdev, struct feature *feature)
> > +{
> > +       dev_dbg(&pdev->dev, "FME HDR Init.\n");
> > +
> > +       return 0;
> > +}
> > +
> > +static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
> > +{
> > +       dev_dbg(&pdev->dev, "FME HDR UInit.\n");
> > +}
> > +
> > +static const struct feature_ops fme_hdr_ops = {
> > +       .init = fme_hdr_init,
> > +       .uinit = fme_hdr_uinit,
> > +};
> > +
> > +static struct feature_driver fme_feature_drvs[] = {
> > +       {
> > +               .id = FME_FEATURE_ID_HEADER,
> > +               .ops = &fme_hdr_ops,
> > +       },
> > +       {
> > +               .ops = NULL,
> > +       },
> > +};
> > +
> > +static int fme_open(struct inode *inode, struct file *filp)
> > +{
> > +       struct platform_device *fdev = fpga_inode_to_feature_dev(inode);
> > +       struct feature_platform_data *pdata = dev_get_platdata(&fdev->dev);
> > +       int ret;
> > +
> > +       if (WARN_ON(!pdata))
> > +               return -ENODEV;
> > +
> > +       ret = feature_dev_use_begin(pdata);
> > +       if (ret)
> > +               return ret;
> > +
> > +       dev_dbg(&fdev->dev, "Device File Open\n");
> > +       filp->private_data = pdata;
> > +
> > +       return 0;
> > +}
> > +
> > +static int fme_release(struct inode *inode, struct file *filp)
> > +{
> > +       struct feature_platform_data *pdata = filp->private_data;
> > +       struct platform_device *pdev = pdata->dev;
> > +
> > +       dev_dbg(&pdev->dev, "Device File Release\n");
> > +       feature_dev_use_end(pdata);
> > +
> > +       return 0;
> > +}
> > +
> > +static long fme_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > +{
> > +       struct feature_platform_data *pdata = filp->private_data;
> > +       struct platform_device *pdev = pdata->dev;
> > +       struct feature *f;
> > +       long ret;
> > +
> > +       dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
> > +
> > +       switch (cmd) {
> > +       default:
> > +               /*
> > +                * Let sub-feature's ioctl function to handle the cmd
> > +                * Sub-feature's ioctl returns -ENODEV when cmd is not
> > +                * handled in this sub feature, and returns 0 and other
> > +                * error code if cmd is handled.
> > +                */
> > +               fpga_dev_for_each_feature(pdata, f) {
> > +                       if (f->ops && f->ops->ioctl) {
> > +                               ret = f->ops->ioctl(pdev, f, cmd, arg);
> > +                               if (ret == -ENODEV)
> > +                                       continue;
> > +                               else
> > +                                       return ret;
> 
> continue and else aren't needed.  Could be
> 
> if (ret != -ENODEV)
>         return ret;

Hi Alan

Thanks for the review and comments.

I agree with you, will fix this in the next version.

Thanks
Hao

> 
> Alan
> 
> > +                       }
> > +               }
> > +       }
> > +
> > +       return -EINVAL;
> > +}
> > +
> > +static const struct file_operations fme_fops = {
> > +       .owner          = THIS_MODULE,
> > +       .open           = fme_open,
> > +       .release        = fme_release,
> > +       .unlocked_ioctl = fme_ioctl,
> > +};
> > +
> > +static int fme_probe(struct platform_device *pdev)
> > +{
> > +       int ret;
> > +
> > +       ret = fpga_dev_feature_init(pdev, fme_feature_drvs);
> > +       if (ret)
> > +               goto exit;
> > +
> > +       ret = fpga_register_dev_ops(pdev, &fme_fops, THIS_MODULE);
> > +       if (ret)
> > +               goto feature_uinit;
> > +
> > +       return 0;
> > +
> > +feature_uinit:
> > +       fpga_dev_feature_uinit(pdev);
> > +exit:
> > +       return ret;
> > +}
> > +
> > +static int fme_remove(struct platform_device *pdev)
> > +{
> > +       fpga_dev_feature_uinit(pdev);
> > +       fpga_unregister_dev_ops(pdev);
> > +
> > +       return 0;
> > +}
> > +
> > +static struct platform_driver fme_driver = {
> > +       .driver = {
> > +               .name    = FPGA_FEATURE_DEV_FME,
> > +       },
> > +       .probe   = fme_probe,
> > +       .remove  = fme_remove,
> > +};
> > +
> > +module_platform_driver(fme_driver);
> > +
> > +MODULE_DESCRIPTION("FPGA Management Engine driver");
> > +MODULE_AUTHOR("Intel Corporation");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_ALIAS("platform:dfl-fme");
> > --
> > 2.7.4
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
