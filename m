From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 17/22] fpga: intel: add fpga region platform driver for FME
Date: Wed, 12 Jul 2017 11:09:46 -0500
Message-ID: <CANk1AXRioZsobi9k_VVcRypV+LrviPLjRejb_Og9VwKhCRth5g@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-18-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498441938-14046-18-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

Hi Hao,

Thanks for using the region patchset.  This looks good except for one
thing below.

> This patch adds fpga region platform driver for Intel FPGA Management
> Engine. It register a fpga region with given fpga manager / bridge
> device.
>
> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/fpga/Kconfig                 |  7 +++
>  drivers/fpga/Makefile                |  1 +
>  drivers/fpga/intel-fpga-fme-region.c | 91 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 99 insertions(+)
>  create mode 100644 drivers/fpga/intel-fpga-fme-region.c
>
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index 05e2a8e..db1a6ea 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -165,6 +165,13 @@ config INTEL_FPGA_FME_BRIDGE
>           Say Y to enable FPGA Bridge driver for Intel FPGA Management
>           Engine.
>
> +config INTEL_FPGA_FME_REGION
> +       tristate "Intel FPGA FME Region Driver"
> +       depends on INTEL_FPGA_FME && FPGA_REGION
> +       help
> +         Say Y to enable FPGA Region driver for Intel FPGA Management
> +         Engine.
> +
>  endif
>
>  endif # FPGA
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> index 131c105..fd0a71f 100644
> --- a/drivers/fpga/Makefile
> +++ b/drivers/fpga/Makefile
> @@ -33,6 +33,7 @@ obj-$(CONFIG_INTEL_FPGA_PCI)          += intel-fpga-pci.o
>  obj-$(CONFIG_INTEL_FPGA_FME)           += intel-fpga-fme.o
>  obj-$(CONFIG_INTEL_FPGA_FME_MGR)       += intel-fpga-fme-mgr.o
>  obj-$(CONFIG_INTEL_FPGA_FME_BRIDGE)    += intel-fpga-fme-br.o
> +obj-$(CONFIG_INTEL_FPGA_FME_REGION)    += intel-fpga-fme-region.o
>
>  intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
>  intel-fpga-fme-objs := intel-fme-main.o intel-fme-pr.o
> diff --git a/drivers/fpga/intel-fpga-fme-region.c b/drivers/fpga/intel-fpga-fme-region.c
> new file mode 100644
> index 0000000..2b5ca4d
> --- /dev/null
> +++ b/drivers/fpga/intel-fpga-fme-region.c
> @@ -0,0 +1,91 @@
> +/*
> + * FPGA Region Driver for Intel FPGA Management Engine (FME)
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * Authors:
> + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Joseph Grecco <joe.grecco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Ananda Ravuri <ananda.ravuri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Henry Mitchel <henry.mitchel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *
> + * This work is licensed under the terms of the GNU GPL version 2. See
> + * the COPYING file in the top-level directory.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/fpga/fpga-region.h>
> +
> +#include "intel-feature-dev.h"
> +#include "intel-fme.h"
> +
> +static int fme_region_get_bridges(struct fpga_region *region,
> +                                 struct fpga_image_info *info)
> +{
> +       struct fme_region_pdata *pdata = region->priv;
> +       struct device *dev = &pdata->br->dev;
> +
> +       return fpga_bridge_get_to_list(dev, info, &region->bridge_list);
> +}
> +
> +static int fme_region_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct fme_region_pdata *pdata = dev_get_platdata(dev);
> +       struct fpga_region *region;
> +       struct fpga_manager *mgr;
> +       int ret;
> +
> +       mgr = fpga_mgr_get(&pdata->mgr->dev);
> +       if (IS_ERR(mgr))
> +               return -EPROBE_DEFER;
> +
> +       region = devm_kzalloc(dev, sizeof(*region), GFP_KERNEL);
> +       if (!region) {
> +               ret = -ENOMEM;
> +               goto eprobe_mgr_put;
> +       }
> +
> +       region->mgr = mgr;
> +       region->get_bridges = fme_region_get_bridges;
> +       region->priv = pdata;
> +
> +       ret = fpga_region_register(dev, region);
> +       if (ret)
> +               goto eprobe_mgr_put;
> +
> +       dev_dbg(dev, "Intel FME FPGA Region probed\n");
> +
> +       return 0;
> +
> +eprobe_mgr_put:
> +       fpga_mgr_put(mgr);
> +       return ret;
> +}
> +
> +static int fme_region_remove(struct platform_device *pdev)
> +{
> +       struct fpga_region *region = dev_get_drvdata(&pdev->dev);
> +
> +       fpga_mgr_put(region->mgr);
> +       fpga_region_unregister(region);

Please unregister before putting the mgr ;)

Alan

> +
> +       return 0;
> +}
> +
> +static struct platform_driver fme_region_driver = {
> +       .driver = {
> +               .name    = INTEL_FPGA_FME_REGION,
> +       },
> +       .probe   = fme_region_probe,
> +       .remove  = fme_region_remove,
> +};
> +
> +module_platform_driver(fme_region_driver);
> +
> +MODULE_DESCRIPTION("FPGA Region for Intel FPGA Management Engine");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:intel-fpga-fme-region");
> --
> 1.8.3.1
>
