From: Moritz Fischer <moritz.fischer@ettus.com>
Subject: Re: [PATCH v2 18/22] fpga: intel: add FPGA Accelerated Function Unit
 driver basic framework
Date: Thu, 17 Aug 2017 12:09:51 -0700
Message-ID: <CAAtXAHca6R7rKOmFHD0eic1dv-NxfG3fBS+yRVFNYoX_M0eVbw@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-19-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-19-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Alan Tull <atull@kernel.org>, linux-fpga@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 6:52 PM, Wu Hao <hao.wu@intel.com> wrote:
> On Intel FPGA devices, the Accelerated Function Unit (AFU), can be
> reprogrammed for different functions. It connects to the FPGA
> infrastructure("blue bistream") via a Port. Port CSRs are implemented
> separately from the AFU CSRs to provide control and status of the Port.
> Once valid green bitstream is programmed into the AFU, it allows access
> to the AFU CSRs in the AFU MMIO space.
>
> This patch only implements basic driver framework for AFU, including
> device file operation framework.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
> v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
>     switched to GPLv2 license.
> ---
>  drivers/fpga/Kconfig          |   9 +++
>  drivers/fpga/Makefile         |   2 +
>  drivers/fpga/intel-afu-main.c | 159 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 170 insertions(+)
>  create mode 100644 drivers/fpga/intel-afu-main.c
>
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index db1a6ea..4658a13 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -172,6 +172,15 @@ config INTEL_FPGA_FME_REGION
>           Say Y to enable FPGA Region driver for Intel FPGA Management
>           Engine.
>
> +config INTEL_FPGA_AFU
> +       tristate "Intel FPGA AFU Driver"
> +       depends on INTEL_FPGA_PCI
> +       help
> +         This is the driver for FPGA Accelerated Function Unit (AFU) which
> +         implements AFU and Port management features. A User AFU connects
> +         to the FPGA infrastructure via a Port. There may be more than 1
> +         Port/AFU per Intel FPGA.
> +
>  endif
>
>  endif # FPGA
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> index fd0a71f..ce08833 100644
> --- a/drivers/fpga/Makefile
> +++ b/drivers/fpga/Makefile
> @@ -34,6 +34,8 @@ obj-$(CONFIG_INTEL_FPGA_FME)          += intel-fpga-fme.o
>  obj-$(CONFIG_INTEL_FPGA_FME_MGR)       += intel-fpga-fme-mgr.o
>  obj-$(CONFIG_INTEL_FPGA_FME_BRIDGE)    += intel-fpga-fme-br.o
>  obj-$(CONFIG_INTEL_FPGA_FME_REGION)    += intel-fpga-fme-region.o
> +obj-$(CONFIG_INTEL_FPGA_AFU)           += intel-fpga-afu.o
>
>  intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
>  intel-fpga-fme-objs := intel-fme-main.o intel-fme-pr.o
> +intel-fpga-afu-objs := intel-afu-main.o
> diff --git a/drivers/fpga/intel-afu-main.c b/drivers/fpga/intel-afu-main.c
> new file mode 100644
> index 0000000..96d0367
> --- /dev/null
> +++ b/drivers/fpga/intel-afu-main.c
> @@ -0,0 +1,159 @@
> +/*
> + * Driver for Intel FPGA Accelerated Function Unit (AFU)
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * Authors:
> + *   Wu Hao <hao.wu@intel.com>
> + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> + *   Joseph Grecco <joe.grecco@intel.com>
> + *   Enno Luebbers <enno.luebbers@intel.com>
> + *   Tim Whisonant <tim.whisonant@intel.com>
> + *   Ananda Ravuri <ananda.ravuri@intel.com>
> + *   Henry Mitchel <henry.mitchel@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL version 2. See
> + * the COPYING file in the top-level directory.

Or just: SPDX-License-Identifier: GPL-2.0
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include "intel-feature-dev.h"
> +
> +static int port_hdr_init(struct platform_device *pdev, struct feature *feature)
> +{
> +       dev_dbg(&pdev->dev, "PORT HDR Init.\n");
> +
> +       return 0;
> +}
> +
> +static void port_hdr_uinit(struct platform_device *pdev,
> +                                       struct feature *feature)
> +{
> +       dev_dbg(&pdev->dev, "PORT HDR UInit.\n");
> +}
> +
> +struct feature_ops port_hdr_ops = {
> +       .init = port_hdr_init,
> +       .uinit = port_hdr_uinit,
> +};
> +
> +static struct feature_driver port_feature_drvs[] = {
> +       {
> +               .name = PORT_FEATURE_HEADER,
> +               .ops = &port_hdr_ops,
> +       },
> +       {
> +               .ops = NULL,
> +       }
> +};
> +
> +static int afu_open(struct inode *inode, struct file *filp)
> +{
> +       struct platform_device *fdev = fpga_inode_to_feature_dev(inode);
> +       struct feature_platform_data *pdata;
> +       int ret;
> +
> +       pdata = dev_get_platdata(&fdev->dev);
> +       if (WARN_ON(!pdata))
> +               return -ENODEV;
> +
> +       ret = feature_dev_use_begin(pdata);
> +       if (ret)
> +               return ret;
> +
> +       dev_dbg(&fdev->dev, "Device File Open\n");
> +       filp->private_data = fdev;
> +
> +       return 0;
> +}
> +
> +static int afu_release(struct inode *inode, struct file *filp)
> +{
> +       struct platform_device *pdev = filp->private_data;
> +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +
> +       dev_dbg(&pdev->dev, "Device File Release\n");
> +
> +       feature_dev_use_end(pdata);
> +       return 0;
> +}
> +
> +static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +       struct platform_device *pdev = filp->private_data;
> +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +       struct feature *f;
> +       long ret;
> +
> +       dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
> +
> +       switch (cmd) {
> +       default:
> +               /*
> +                * Let sub-feature's ioctl function to handle the cmd
> +                * Sub-feature's ioctl returns -ENODEV when cmd is not
> +                * handled in this sub feature, and returns 0 and other
> +                * error code if cmd is handled.
> +                */
> +               fpga_dev_for_each_feature(pdata, f)
> +                       if (f->ops && f->ops->ioctl) {
> +                               ret = f->ops->ioctl(pdev, f, cmd, arg);
> +                               if (ret == -ENODEV)
> +                                       continue;
> +                               else
> +                                       return ret;
> +                       }
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static const struct file_operations afu_fops = {
> +       .owner = THIS_MODULE,
> +       .open = afu_open,
> +       .release = afu_release,
> +       .unlocked_ioctl = afu_ioctl,
> +};
> +
> +static int afu_probe(struct platform_device *pdev)
> +{
> +       int ret;
> +
> +       dev_dbg(&pdev->dev, "%s\n", __func__);
> +
> +       ret = fpga_dev_feature_init(pdev, port_feature_drvs);
> +       if (ret)
> +               return ret;
> +
> +       ret = fpga_register_dev_ops(pdev, &afu_fops, THIS_MODULE);
> +       if (ret)
> +               fpga_dev_feature_uinit(pdev);
> +
> +       return ret;
> +}
> +
> +static int afu_remove(struct platform_device *pdev)
> +{
> +       dev_dbg(&pdev->dev, "%s\n", __func__);
> +
> +       fpga_dev_feature_uinit(pdev);
> +       fpga_unregister_dev_ops(pdev);
> +       return 0;
> +}
> +
> +static struct platform_driver afu_driver = {
> +       .driver = {
> +               .name    = "intel-fpga-port",
> +       },
> +       .probe   = afu_probe,
> +       .remove  = afu_remove,
> +};
> +
> +module_platform_driver(afu_driver);
> +
> +MODULE_DESCRIPTION("Intel FPGA Accelerated Function Unit driver");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:intel-fpga-port");
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

Moritz
