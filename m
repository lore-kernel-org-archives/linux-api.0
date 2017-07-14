From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/22] fpga: intel: pcie: parse feature list and
 create platform device for features.
Date: Fri, 14 Jul 2017 17:22:50 +0800
Message-ID: <20170714092250.GA2821@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-8-git-send-email-hao.wu@intel.com>
 <CANk1AXS-VftzKmmK4P3Anas+DQZ0ZPQ=7yVQt=QrNULPY7PaDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXS-VftzKmmK4P3Anas+DQZ0ZPQ=7yVQt=QrNULPY7PaDA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 13, 2017 at 12:52:30PM -0500, Alan Tull wrote:
> On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > From: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >
> > Device Feature List structure creates a link list of feature headers
> > within the MMIO space to provide an extensible way of adding features.
> >
> > The Intel FPGA PCIe driver walks through the feature headers to enumerate
> > feature devices, FPGA Management Engine (FME) and FPGA Port for Accelerated
> > Function Unit (AFU), and their private sub features. For feature devices,
> > it creates the platform devices and linked the private sub features into
> > their platform data.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
> >     switched to GPLv2 license.
> >     fixed comments from Moritz Fischer.
> >     fixed kbuild warning, typos and clean up the code.
> > ---
> >  drivers/fpga/Makefile            |   2 +-
> >  drivers/fpga/intel-feature-dev.c | 130 ++++++
> >  drivers/fpga/intel-feature-dev.h | 341 ++++++++++++++++
> >  drivers/fpga/intel-pcie.c        | 841 ++++++++++++++++++++++++++++++++++++++-
> >  4 files changed, 1311 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/fpga/intel-feature-dev.c
> >  create mode 100644 drivers/fpga/intel-feature-dev.h
> >
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index 5613133..ad24b3d 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -31,4 +31,4 @@ obj-$(CONFIG_OF_FPGA_REGION)          += of-fpga-region.o
> >  # Intel FPGA Support
> >  obj-$(CONFIG_INTEL_FPGA_PCI)           += intel-fpga-pci.o
> >
> > -intel-fpga-pci-objs := intel-pcie.o
> > +intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
> > diff --git a/drivers/fpga/intel-feature-dev.c b/drivers/fpga/intel-feature-dev.c
> > new file mode 100644
> > index 0000000..68f9cba
> > --- /dev/null
> > +++ b/drivers/fpga/intel-feature-dev.c
> > @@ -0,0 +1,130 @@
> > +/*
> > + * Intel FPGA Feature Device Driver
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > + *   Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > + *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > + *
> > + * This work is licensed under the terms of the GNU GPL version 2. See
> > + * the COPYING file in the top-level directory.
> > + */
> > +
> > +#include "intel-feature-dev.h"
> > +
> > +void feature_platform_data_add(struct feature_platform_data *pdata,
> > +                              int index, const char *name,
> > +                              int resource_index, void __iomem *ioaddr)
> > +{
> > +       WARN_ON(index >= pdata->num);
> > +
> > +       pdata->features[index].name = name;
> > +       pdata->features[index].resource_index = resource_index;
> > +       pdata->features[index].ioaddr = ioaddr;
> > +}
> > +
> > +struct feature_platform_data *
> > +feature_platform_data_alloc_and_init(struct platform_device *dev, int num)
> > +{
> > +       struct feature_platform_data *pdata;
> > +
> > +       pdata = kzalloc(feature_platform_data_size(num), GFP_KERNEL);
> > +       if (pdata) {
> > +               pdata->dev = dev;
> > +               pdata->num = num;
> > +               mutex_init(&pdata->lock);
> > +       }
> > +
> > +       return pdata;
> > +}
> > +
> > +int fme_feature_num(void)
> > +{
> > +       return FME_FEATURE_ID_MAX;
> > +}
> > +
> > +int port_feature_num(void)
> > +{
> > +       return PORT_FEATURE_ID_MAX;
> > +}
> > +
> > +int fpga_port_id(struct platform_device *pdev)
> > +{
> > +       struct feature_port_header *port_hdr;
> > +       struct feature_port_capability capability;
> > +
> > +       port_hdr = get_feature_ioaddr_by_index(&pdev->dev,
> > +                                              PORT_FEATURE_ID_HEADER);
> > +       WARN_ON(!port_hdr);
> > +
> > +       capability.csr = readq(&port_hdr->capability);
> > +       return capability.port_number;
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_port_id);
> > +
> > +/*
> > + * Enable Port by clear the port soft reset bit, which is set by default.
> > + * The User AFU is unable to respond to any MMIO access while in reset.
> > + * __fpga_port_enable function should only be used after __fpga_port_disable
> > + * function.
> > + */
> > +void __fpga_port_enable(struct platform_device *pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +       struct feature_port_header *port_hdr;
> > +       struct feature_port_control control;
> > +
> > +       WARN_ON(!pdata->disable_count);
> > +
> > +       if (--pdata->disable_count != 0)
> > +               return;
> > +
> > +       port_hdr = get_feature_ioaddr_by_index(&pdev->dev,
> > +                                              PORT_FEATURE_ID_HEADER);
> > +       WARN_ON(!port_hdr);
> > +
> > +       control.csr = readq(&port_hdr->control);
> > +       control.port_sftrst = 0x0;
> > +       writeq(control.csr, &port_hdr->control);
> > +}
> > +EXPORT_SYMBOL_GPL(__fpga_port_enable);
> > +
> > +#define RST_POLL_INVL 10 /* us */
> > +#define RST_POLL_TIMEOUT 1000 /* us */
> > +
> > +int __fpga_port_disable(struct platform_device *pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +       struct feature_port_header *port_hdr;
> > +       struct feature_port_control control;
> > +
> > +       if (pdata->disable_count++ != 0)
> > +               return 0;
> > +
> > +       port_hdr = get_feature_ioaddr_by_index(&pdev->dev,
> > +                                              PORT_FEATURE_ID_HEADER);
> > +       WARN_ON(!port_hdr);
> > +
> > +       /* Set port soft reset */
> > +       control.csr = readq(&port_hdr->control);
> > +       control.port_sftrst = 0x1;
> > +       writeq(control.csr, &port_hdr->control);
> > +
> > +       /*
> > +        * HW sets ack bit to 1 when all outstanding requests have been drained
> > +        * on this port and minimum soft reset pulse width has elapsed.
> > +        * Driver polls port_soft_reset_ack to determine if reset done by HW.
> > +        */
> > +       if (readq_poll_timeout(&port_hdr->control, control.csr,
> > +                              (control.port_sftrst_ack == 1),
> > +                              RST_POLL_INVL, RST_POLL_TIMEOUT)) {
> > +               dev_err(&pdev->dev, "timeout, fail to reset device\n");
> > +               return -ETIMEDOUT;
> > +       }
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(__fpga_port_disable);
> > diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
> > new file mode 100644
> > index 0000000..f67784a
> > --- /dev/null
> > +++ b/drivers/fpga/intel-feature-dev.h
> > @@ -0,0 +1,341 @@
> > +/*
> > + * Intel FPGA Feature Device Driver Header File
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > + *   Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > + *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > + *
> > + * This work is licensed under the terms of the GNU GPL version 2. See
> > + * the COPYING file in the top-level directory.
> > + */
> > +
> > +#ifndef __INTEL_FPGA_FEATURE_H
> > +#define __INTEL_FPGA_FEATURE_H
> > +
> > +#include <linux/fs.h>
> > +#include <linux/pci.h>
> > +#include <linux/uuid.h>
> > +#include <linux/delay.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/platform_device.h>
> > +
> > +#ifndef readq
> > +static inline u64 readq(void __iomem *addr)
> > +{
> > +       return readl(addr) + ((u64)readl(addr + 4) << 32);
> > +}
> > +#endif
> > +
> > +#ifndef writeq
> > +static inline void writeq(u64 val, void __iomem *addr)
> > +{
> > +       writel((u32) (val), addr);
> > +       writel((u32) (val >> 32), (addr + 4));
> > +}
> > +#endif
> > +
> > +/* maximum supported number of ports */
> > +#define MAX_FPGA_PORT_NUM 4
> > +/* plus one for fme device */
> > +#define MAX_FEATURE_DEV_NUM    (MAX_FPGA_PORT_NUM + 1)
> > +
> > +#define FME_FEATURE_HEADER          "fme_hdr"
> > +#define FME_FEATURE_THERMAL_MGMT    "fme_thermal"
> > +#define FME_FEATURE_POWER_MGMT      "fme_power"
> > +#define FME_FEATURE_GLOBAL_PERF     "fme_gperf"
> > +#define FME_FEATURE_GLOBAL_ERR      "fme_error"
> > +#define FME_FEATURE_PR_MGMT         "fme_pr"
> > +
> > +#define PORT_FEATURE_HEADER         "port_hdr"
> > +#define PORT_FEATURE_UAFU           "port_uafu"
> > +#define PORT_FEATURE_ERR            "port_err"
> > +#define PORT_FEATURE_UMSG           "port_umsg"
> > +#define PORT_FEATURE_PR             "port_pr"
> > +#define PORT_FEATURE_STP            "port_stp"
> > +
> > +/* All headers and structures must be byte-packed to match the spec. */
> > +#pragma pack(1)
> > +
> > +/* common header for all features */
> > +struct feature_header {
> > +       union {
> > +               u64 csr;
> > +               struct {
> > +                       u64 id:12;
> > +                       u64 revision:4;
> > +                       u64 next_header_offset:24; /* offset to next header */
> > +                       u64 rsvdz:20;
> > +                       u64 type:4;                /* feature type */
> > +#define FEATURE_TYPE_AFU               0x1
> > +#define FEATURE_TYPE_PRIVATE           0x3
> > +               };
> > +       };
> > +};
> 
> Hi Hao,
> 
> Aren't these union's introducing a portability problem?  Can you use
> regmap instead?

Hi Alan

I think it's fine to use union here, as endian conversion should be covered
inside the readq/writeq function. :)

Thanks
Hao

> 
> Alan
> 
