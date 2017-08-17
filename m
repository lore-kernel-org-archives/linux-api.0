From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 16/22] fpga: intel: add fpga bridge platform driver for FME
Date: Thu, 17 Aug 2017 14:34:34 -0500
Message-ID: <CANk1AXQinJp5y7joGz8TwUA99ggd-A8XkhcwGVoTChs2TM-wbw@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-17-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498441938-14046-17-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> This patch adds fpga bridge platform driver for Intel FPGA Management
> Engine. It implements the enable_set call back for fpga bridge.
>
> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/fpga/Kconfig             |  7 ++++
>  drivers/fpga/Makefile            |  1 +
>  drivers/fpga/intel-fpga-fme-br.c | 77 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 85 insertions(+)
>  create mode 100644 drivers/fpga/intel-fpga-fme-br.c
>
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index 6f2f623..05e2a8e 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -158,6 +158,13 @@ config INTEL_FPGA_FME_MGR
>           Say Y to enable FPGA Manager driver for Intel FPGA Management
>           Engine.
>
> +config INTEL_FPGA_FME_BRIDGE
> +       tristate "Intel FPGA FME Bridge Driver"
> +       depends on INTEL_FPGA_FME && FPGA_BRIDGE
> +       help
> +         Say Y to enable FPGA Bridge driver for Intel FPGA Management
> +         Engine.
> +
>  endif
>
>  endif # FPGA
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> index d1d588b..131c105 100644
> --- a/drivers/fpga/Makefile
> +++ b/drivers/fpga/Makefile
> @@ -32,6 +32,7 @@ obj-$(CONFIG_OF_FPGA_REGION)          += of-fpga-region.o
>  obj-$(CONFIG_INTEL_FPGA_PCI)           += intel-fpga-pci.o
>  obj-$(CONFIG_INTEL_FPGA_FME)           += intel-fpga-fme.o
>  obj-$(CONFIG_INTEL_FPGA_FME_MGR)       += intel-fpga-fme-mgr.o
> +obj-$(CONFIG_INTEL_FPGA_FME_BRIDGE)    += intel-fpga-fme-br.o
>
>  intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
>  intel-fpga-fme-objs := intel-fme-main.o intel-fme-pr.o
> diff --git a/drivers/fpga/intel-fpga-fme-br.c b/drivers/fpga/intel-fpga-fme-br.c
> new file mode 100644
> index 0000000..9b922d2
> --- /dev/null
> +++ b/drivers/fpga/intel-fpga-fme-br.c
> @@ -0,0 +1,77 @@
> +/*
> + * FPGA Bridge Driver for Intel FPGA Management Engine (FME)
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
> +#include <linux/fpga/fpga-bridge.h>
> +
> +#include "intel-feature-dev.h"
> +#include "intel-fme.h"
> +
> +static int fme_bridge_enable_set(struct fpga_bridge *bridge, bool enable)
> +{
> +       struct fme_br_pdata *pdata = bridge->priv;
> +       int ret = 0;
> +
> +       if (enable)
> +               fpga_port_enable(pdata->port);
> +       else
> +               ret = fpga_port_disable(pdata->port);
> +
> +       return ret;
> +}
> +
> +static const struct fpga_bridge_ops fme_bridge_ops = {
> +       .enable_set = fme_bridge_enable_set,
> +};
> +
> +static int fme_br_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct fme_br_pdata *pdata = dev_get_platdata(dev);
> +       int ret;
> +
> +       ret = fpga_bridge_register(dev, "Intel FPGA FME Bridge",
> +                                  &fme_bridge_ops, pdata);
> +       if (ret)
> +               dev_err(dev, "unable to register FPGA Bridge\n");
> +
> +       dev_dbg(dev, "Intel FME FPGA Bridge probed\n");
> +
> +       return ret;
> +}
> +
> +static int fme_br_remove(struct platform_device *pdev)
> +{
> +       fpga_bridge_unregister(&pdev->dev);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver fme_br_driver = {
> +       .driver = {
> +               .name    = INTEL_FPGA_FME_BRIDGE,
> +       },
> +       .probe   = fme_br_probe,
> +       .remove  = fme_br_remove,
> +};
> +
> +module_platform_driver(fme_br_driver);
> +
> +MODULE_DESCRIPTION("FPGA Bridge for Intel FPGA Management Engine");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:intel-fpga-fme-bridge");
> --
> 1.8.3.1
>
