From: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 14/21] fpga: dfl: add fpga manager platform driver for FME
Date: Mon, 5 Feb 2018 11:21:52 -0600
Message-ID: <CANk1AXRxkUqPqknzb+-apvjZM6MFRom9fscHPmMc8MTYSLpooA@mail.gmail.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-15-git-send-email-hao.wu@intel.com> <CANk1AXS-ON+Pcxtk-AY1XxH8Paw2aFBjiqhuCz7cA4cyuAQMUA@mail.gmail.com>
 <20180202094213.GB17015@hao-dev> <20180203002626.GA51125@eluebber-mac02.jf.intel.com>
 <20180203104124.luniynyrr6iwxozd@derp-derp.local> <20180204100546.GB26184@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180204100546.GB26184@hao-dev>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Luebbers, Enno" <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 4, 2018 at 4:05 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, Feb 03, 2018 at 11:41:24AM +0100, Moritz Fischer wrote:
>> Hi Hao,
>>
>> On Fri, Feb 02, 2018 at 04:26:26PM -0800, Luebbers, Enno wrote:
>> > Hi Hao, Alan,
>> >
>> > On Fri, Feb 02, 2018 at 05:42:13PM +0800, Wu Hao wrote:
>> > > On Thu, Feb 01, 2018 at 04:00:36PM -0600, Alan Tull wrote:
>> > > > On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > > >
>> > > > Hi Hao,
>> > > >
>> > > > A few comments below.   Besides that, looks good.
>> > > >
>> > > > > This patch adds fpga manager driver for FPGA Management Engine (FME). It
>> > > > > implements fpga_manager_ops for FPGA Partial Reconfiguration function.
>> > > > >
>> > > > > Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > Signed-off-by: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > > > > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > ----
>> > > > > v3: rename driver to dfl-fpga-fme-mgr
>> > > > >     implemented status callback for fpga manager
>> > > > >     rebased due to fpga api changes
>> > > > > ---
>> > > > >  .../ABI/testing/sysfs-platform-fpga-dfl-fme-mgr    |   8 +
>> > > > >  drivers/fpga/Kconfig                               |   6 +
>> > > > >  drivers/fpga/Makefile                              |   1 +
>> > > > >  drivers/fpga/fpga-dfl-fme-mgr.c                    | 318 +++++++++++++++++++++
>> > > > >  drivers/fpga/fpga-dfl.h                            |  39 ++-
>> > > > >  5 files changed, 371 insertions(+), 1 deletion(-)
>> > > > >  create mode 100644 Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr
>> > > > >  create mode 100644 drivers/fpga/fpga-dfl-fme-mgr.c
>> > > > >
>> > > > > diff --git a/Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr
>> > > > > new file mode 100644
>> > > > > index 0000000..2d4f917
>> > > > > --- /dev/null
>> > > > > +++ b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr
>> > > > > @@ -0,0 +1,8 @@
>> > > > > +What:          /sys/bus/platform/devices/fpga-dfl-fme-mgr.0/interface_id
>> > > > > +Date:          November 2017
>> > > > > +KernelVersion:  4.15
>> > > > > +Contact:       Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > +Description:   Read-only. It returns interface id of partial reconfiguration
>> > > > > +               hardware. Userspace could use this information to check if
>> > > > > +               current hardware is compatible with given image before FPGA
>> > > > > +               programming.
>> > > >
>> > > > I'm a little confused by this.  I can understand that the PR bitstream
>> > > > has a dependency on the FPGA's static image, but I don't understand
>> > > > the dependency of the bistream on the hardware that is used to program
>> > > > the bitstream to the FPGA.
>> > >
>> > > Sorry for the confusion, the interface_id is used to indicate the version of
>> > > the hardware for partial reconfiguration (it's part of the static image of
>> > > the FPGA device). Will improve the description on this.
>>
>> I'm not sure userland should be making the call on whether what you're
>> trying to load is compatible or not.

Could you explain more about what your concern was about this (unless
Hao has covered it below)?

It makes sense to me in this use case at least since userspace has a
pile of images and is choosing which one to load.

>> Isn't there a way to check this in
>> your PR reconfiguration handler in-kernel?
>
> Hi Moritz
>
> Actually with current driver interface, doing a partial reconfiguration with an
> incompatible image, then driver will report PR failure with error code
> FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR as hardware checks it, but anyway user
> needs to know hardware interface_id information to find or re-generated correct
> images. I think it's more flexible to leave it to userspace on using this
> information exposed by driver. : )
>
> Thanks
> Hao
>
>>
>> > >
>> >
>> > The interface_id expresses the compatibility of the static region with PR
>> > bitstreams generated for it. It changes every time a new static region is
>> > generated.

In the near future the DFL framework will be used with SoC's that have
a hard FPGA PR manager (that's not part of the static region).  The
hard FPGA manager driver won't know anything about the static region.

>> >
>> > Would it make more sense to have the interface_id exposed as part of the FME
>> > device (which represents the static region)? I'm not sure - it kind of also
>> > makes sense here, where you would have all the information in one place (if the
>> > interface_id matches, I can use this component to program a bitstream).

According to the intel-fpga.txt document, the identifier for the
static image is at

/sys/class/fpga_region/regionX/fpga-dfl-fme.n/bitstream_id

>> >
>> > Sorry for my limited understanding of the infrastructure - would this same
>> > "fpga-dfl-fme-mgr.0" be used for PR if we had multiple PR regions? In that case
>> > it would need to expose multiple interface_ids (or we'd have to track both
>> > interface IDs and an identifier for the target PR region).

interface_id sounds like it's trying to give some per-PR region
information.  That could support the real case where a FPGA static
region has multiple PR regions and userspace has a bunch of images.
The images are keyed to certain regions.  The reason the images are
region-specific could be that the regions have different connections
(possible but I think that's unlikely.  but possible) or because the
FPGA doesn't support relocatable PR images (true of most FPGAs that
support PR, but not a problem with Stratix10).

Each interface_ids could be exposed per fpga-region (each fpga-region
maps to a PR region).  That wouldn't be hard to implement, driver-wise
I think.

>> >
>> > > >
>> > > > > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
>> > > > > index 57da904..0171ecb 100644
>> > > > > --- a/drivers/fpga/Kconfig
>> > > > > +++ b/drivers/fpga/Kconfig
>> > > > > @@ -150,6 +150,12 @@ config FPGA_DFL_FME
>> > > > >           FPGA platform level management features. There shall be 1 FME
>> > > > >           per DFL based FPGA device.
>> > > > >
>> > > > > +config FPGA_DFL_FME_MGR
>> > > > > +       tristate "FPGA DFL FME Manager Driver"
>> > > > > +       depends on FPGA_DFL_FME
>> > > > > +       help
>> > > > > +         Say Y to enable FPGA Manager driver for FPGA Management Engine.
>> > > > > +
>> > > > >  config INTEL_FPGA_DFL_PCI
>> > > > >         tristate "Intel FPGA DFL PCIe Device Driver"
>> > > > >         depends on PCI && FPGA_DFL
>> > > > > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
>> > > > > index cc75bb3..6378580 100644
>> > > > > --- a/drivers/fpga/Makefile
>> > > > > +++ b/drivers/fpga/Makefile
>> > > > > @@ -31,6 +31,7 @@ obj-$(CONFIG_OF_FPGA_REGION)          += of-fpga-region.o
>> > > > >  # FPGA Device Feature List Support
>> > > > >  obj-$(CONFIG_FPGA_DFL)                 += fpga-dfl.o
>> > > > >  obj-$(CONFIG_FPGA_DFL_FME)             += fpga-dfl-fme.o
>> > > > > +obj-$(CONFIG_FPGA_DFL_FME_MGR)         += fpga-dfl-fme-mgr.o
>> > > > >
>> > > > >  fpga-dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
>> > > > >
>> > > > > diff --git a/drivers/fpga/fpga-dfl-fme-mgr.c b/drivers/fpga/fpga-dfl-fme-mgr.c
>> > > > > new file mode 100644
>> > > > > index 0000000..70356ce
>> > > > > --- /dev/null
>> > > > > +++ b/drivers/fpga/fpga-dfl-fme-mgr.c
>> > > > > @@ -0,0 +1,318 @@
>> > > > > +/*
>> > > > > + * FPGA Manager Driver for FPGA Management Engine (FME)
>> > > > > + *
>> > > > > + * Copyright (C) 2017 Intel Corporation, Inc.
>> > > > > + *
>> > > > > + * Authors:
>> > > > > + *   Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> > > > > + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *   Joseph Grecco <joe.grecco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *   Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *   Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *   Ananda Ravuri <ananda.ravuri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *   Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *   Henry Mitchel <henry.mitchel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > > > + *
>> > > > > + * This work is licensed under the terms of the GNU GPL version 2.
>> > > > > + * SPDX-License-Identifier: GPL-2.0
>> > > > > + */
>> > > > > +
>> > > > > +#include <linux/module.h>
>> > > > > +#include <linux/iopoll.h>
>> > > > > +#include <linux/fpga/fpga-mgr.h>
>> > > > > +
>> > > > > +#include "fpga-dfl.h"
>> > > > > +#include "dfl-fme.h"
>> > > > > +
>> > > > > +#define PR_WAIT_TIMEOUT   8000000
>> > > > > +#define PR_HOST_STATUS_IDLE    0
>> > > > > +
>> > > > > +struct fme_mgr_priv {
>> > > > > +       void __iomem *ioaddr;
>> > > > > +       u64 pr_error;
>> > > > > +};
>> > > > > +
>> > > > > +static ssize_t interface_id_show(struct device *dev,
>> > > > > +                                struct device_attribute *attr, char *buf)
>> > > > > +{
>> > > > > +       struct fpga_manager *mgr = dev_get_drvdata(dev);
>> > > > > +       struct fme_mgr_priv *priv = mgr->priv;
>> > > > > +       u64 intfc_id_l, intfc_id_h;
>> > > > > +
>> > > > > +       intfc_id_l = readq(priv->ioaddr + FME_PR_INTFC_ID_L);
>> > > > > +       intfc_id_h = readq(priv->ioaddr + FME_PR_INTFC_ID_H);
>> > > > > +
>> > > > > +       return scnprintf(buf, PAGE_SIZE, "%016llx%016llx\n",
>> > > > > +                       (unsigned long long)intfc_id_h,
>> > > > > +                       (unsigned long long)intfc_id_l);
>> > > > > +}
>> > > > > +static DEVICE_ATTR_RO(interface_id);
>> > > > > +
>> > > > > +static const struct attribute *fme_mgr_attrs[] = {
>> > > > > +       &dev_attr_interface_id.attr,
>> > > > > +       NULL,
>> > > > > +};
>> > > > > +
>> > > > > +static u64 pr_error_to_mgr_status(u64 err)
>> > > > > +{
>> > > > > +       u64 status = 0;
>> > > > > +
>> > > > > +       if (err & FME_PR_ERR_OPERATION_ERR)
>> > > > > +               status |= FPGA_MGR_STATUS_OPERATION_ERR;
>> > > > > +       if (err & FME_PR_ERR_CRC_ERR)
>> > > > > +               status |= FPGA_MGR_STATUS_CRC_ERR;
>> > > > > +       if (err & FME_PR_ERR_INCOMPATIBLE_BS)
>> > > > > +               status |= FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR;
>> > > > > +       if (err & FME_PR_ERR_PROTOCOL_ERR)
>> > > > > +               status |= FPGA_MGR_STATUS_IP_PROTOCOL_ERR;
>> > > > > +       if (err & FME_PR_ERR_FIFO_OVERFLOW)
>> > > > > +               status |= FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR;
>> > > > > +
>> > > > > +       return status;
>> > > > > +}
>> > > > > +
>> > > > > +static u64 fme_mgr_pr_error_handle(void __iomem *fme_pr)
>> > > > > +{
>> > > > > +       u64 pr_status, pr_error;
>> > > > > +
>> > > > > +       pr_status = readq(fme_pr + FME_PR_STS);
>> > > > > +       if (!(pr_status & FME_PR_STS_PR_STS))
>> > > > > +               return 0;
>> > > > > +
>> > > > > +       pr_error = readq(fme_pr + FME_PR_ERR);
>> > > > > +       writeq(pr_error, fme_pr + FME_PR_ERR);
>> > > > > +
>> > > > > +       return pr_error;
>> > > > > +}
>> > > > > +
>> > > > > +static int fme_mgr_write_init(struct fpga_manager *mgr,
>> > > > > +                             struct fpga_image_info *info,
>> > > > > +                             const char *buf, size_t count)
>> > > > > +{
>> > > > > +       struct device *dev = &mgr->dev;
>> > > > > +       struct fme_mgr_priv *priv = mgr->priv;
>> > > > > +       void __iomem *fme_pr = priv->ioaddr;
>> > > > > +       u64 pr_ctrl, pr_status;
>> > > > > +
>> > > > > +       if (!(info->flags & FPGA_MGR_PARTIAL_RECONFIG)) {
>> > > > > +               dev_err(dev, "only support partial reconfiguration.\n");
>> > > >
>> > > > supports
>> > > >
>> > > > > +               return -EINVAL;
>> > > > > +       }
>> > > > > +
>> > > > > +       dev_dbg(dev, "resetting PR before initiated PR\n");
>> > > > > +
>> > > > > +       pr_ctrl = readq(fme_pr + FME_PR_CTRL);
>> > > > > +       pr_ctrl |= FME_PR_CTRL_PR_RST;
>> > > > > +       writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
>> > > > > +
>> > > > > +       if (readq_poll_timeout(fme_pr + FME_PR_CTRL, pr_ctrl,
>> > > > > +                              pr_ctrl & FME_PR_CTRL_PR_RSTACK, 1,
>> > > > > +                              PR_WAIT_TIMEOUT)) {
>> > > > > +               dev_err(dev, "maximum PR timeout\n");
>> > > >
>> > > > We have two dev_err's with the same "maximum PR timeout" so the user
>> > > > would not be able to see at which point the timeout occurred.
>> > > >
>> > > > I suggest to get rid of the word 'maximum' for both.  This one could
>> > > > be 'reset ack timeout" or something similar.
>> > >
>> > > Sure, will switch to a more specific message per your suggestion. Thanks.
>> > >
>> > > >
>> > > > > +               return -ETIMEDOUT;
>> > > > > +       }
>> > > > > +
>> > > > > +       pr_ctrl = readq(fme_pr + FME_PR_CTRL);
>> > > > > +       pr_ctrl &= ~FME_PR_CTRL_PR_RST;
>> > > > > +       writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
>> > > > > +
>> > > > > +       dev_dbg(dev,
>> > > > > +               "waiting for PR resource in HW to be initialized and ready\n");
>> > > > > +
>> > > > > +       if (readq_poll_timeout(fme_pr + FME_PR_STS, pr_status,
>> > > > > +                              (pr_status & FME_PR_STS_PR_STS) ==
>> > > > > +                              FME_PR_STS_PR_STS_IDLE, 1, PR_WAIT_TIMEOUT)) {
>> > > > > +               dev_err(dev, "maximum PR timeout\n");
>> > > >
>> > > > "PR_STS timeout"?  Or something better.
>> > > >
>> > > > > +               priv->pr_error = fme_mgr_pr_error_handle(fme_pr);
>> > > > > +               return -ETIMEDOUT;
>> > > > > +       }
>> > > > > +
>> > > > > +       dev_dbg(dev, "check and clear previous PR error\n");
>> > > > > +       priv->pr_error = fme_mgr_pr_error_handle(fme_pr);
>> > > > > +       if (priv->pr_error)
>> > > > > +               dev_dbg(dev, "previous PR error detected %llx\n",
>> > > > > +                       (unsigned long long)priv->pr_error);
>> > > > > +
>> > > > > +       dev_dbg(dev, "set PR port ID\n");
>> > > > > +
>> > > > > +       pr_ctrl = readq(fme_pr + FME_PR_CTRL);
>> > > > > +       pr_ctrl &= ~FME_PR_CTRL_PR_RGN_ID;
>> > > > > +       pr_ctrl |= FIELD_PREP(FME_PR_CTRL_PR_RGN_ID, info->region_id);
>> > > > > +       writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
>> > > > > +
>> > > > > +       return 0;
>> > > > > +}
>> > > > > +
>> > > > > +static int fme_mgr_write(struct fpga_manager *mgr,
>> > > > > +                        const char *buf, size_t count)
>> > > > > +{
>> > > > > +       struct device *dev = &mgr->dev;
>> > > > > +       struct fme_mgr_priv *priv = mgr->priv;
>> > > > > +       void __iomem *fme_pr = priv->ioaddr;
>> > > > > +       u64 pr_ctrl, pr_status, pr_data;
>> > > > > +       int delay = 0, pr_credit, i = 0;
>> > > > > +
>> > > > > +       dev_dbg(dev, "start request\n");
>> > > > > +
>> > > > > +       pr_ctrl = readq(fme_pr + FME_PR_CTRL);
>> > > > > +       pr_ctrl |= FME_PR_CTRL_PR_START;
>> > > > > +       writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
>> > > > > +
>> > > > > +       dev_dbg(dev, "pushing data from bitstream to HW\n");
>> > > > > +
>> > > > > +       pr_status = readq(fme_pr + FME_PR_STS);
>> > > > > +       pr_credit = FIELD_GET(FME_PR_STS_PR_CREDIT, pr_status);
>> > > > > +
>> > > > > +       while (count > 0) {
>> > > > > +               while (pr_credit <= 1) {
>> > > > > +                       if (delay++ > PR_WAIT_TIMEOUT) {
>> > > > > +                               dev_err(dev, "maximum try\n");
>> > > >
>> > > > It looks like this is waiting for an entry in a queue and timing out
>> > > > here.  Could you add a some comments for pr_credit above and this
>> > > > loop?  Also a better error message, perhaps "PR credit timeout"?
>> > >
>> > > Driver needs to read the PR credit to know if it could push PR data
>> > > to hardware or not. I will add more description here on this PR credit,
>> > > and use "PR credit timeout" as error message.
>> > >
>> > > >
>> > > > > +                               return -ETIMEDOUT;
>> > > > > +                       }
>> > > > > +                       udelay(1);
>> > > > > +
>> > > > > +                       pr_status = readq(fme_pr + FME_PR_STS);
>> > > > > +                       pr_credit = FIELD_GET(FME_PR_STS_PR_CREDIT, pr_status);
>> > > > > +               }
>> > > > > +
>> > > > > +               if (count >= 4) {
>> > > > > +                       pr_data = 0;
>> > > > > +                       pr_data |= FIELD_PREP(FME_PR_DATA_PR_DATA_RAW,
>> > > > > +                                             *(((u32 *)buf) + i));
>> > > > > +                       writeq(pr_data, fme_pr + FME_PR_DATA);
>> > > > > +                       count -= 4;
>> > > > > +                       pr_credit--;
>> > > > > +                       i++;
>> > > > > +               } else {
>> > > > > +                       WARN_ON(1);
>> > > > > +                       return -EINVAL;
>> > > > > +               }
>> > > > > +       }
>> > > > > +
>> > > > > +       return 0;
>> > > > > +}
>> > > > > +
>> > > > > +static int fme_mgr_write_complete(struct fpga_manager *mgr,
>> > > > > +                                 struct fpga_image_info *info)
>> > > > > +{
>> > > > > +       struct device *dev = &mgr->dev;
>> > > > > +       struct fme_mgr_priv *priv = mgr->priv;
>> > > > > +       void __iomem *fme_pr = priv->ioaddr;
>> > > > > +       u64 pr_ctrl;
>> > > > > +
>> > > > > +       pr_ctrl = readq(fme_pr + FME_PR_CTRL);
>> > > > > +       pr_ctrl |= FME_PR_CTRL_PR_COMPLETE;
>> > > > > +       writeq(pr_ctrl, fme_pr + FME_PR_CTRL);
>> > > > > +
>> > > > > +       dev_dbg(dev, "green bitstream push complete\n");
>> > > > > +       dev_dbg(dev, "waiting for HW to release PR resource\n");
>> > > > > +
>> > > > > +       if (readq_poll_timeout(fme_pr + FME_PR_CTRL, pr_ctrl,
>> > > > > +                              !(pr_ctrl & FME_PR_CTRL_PR_START), 1,
>> > > > > +                              PR_WAIT_TIMEOUT)) {
>> > > > > +               dev_err(dev, "maximum try.\n");
>> > > >
>> > > > Some message specific to here also, please.
>> > > >
>> > > > > +               return -ETIMEDOUT;
>> > > > > +       }
>> > > > > +
>> > > > > +       dev_dbg(dev, "PR operation complete, checking status\n");
>> > > > > +       priv->pr_error = fme_mgr_pr_error_handle(fme_pr);
>> > > > > +       if (priv->pr_error) {
>> > > > > +               dev_dbg(dev, "PR error detected %llx\n",
>> > > > > +                       (unsigned long long)priv->pr_error);
>> > > > > +               return -EIO;
>> > > > > +       }
>> > > > > +
>> > > > > +       dev_dbg(dev, "PR done successfully\n");
>> > > > > +
>> > > > > +       return 0;
>> > > > > +}
>> > > > > +
>> > > > > +static enum fpga_mgr_states fme_mgr_state(struct fpga_manager *mgr)
>> > > > > +{
>> > > > > +       return FPGA_MGR_STATE_UNKNOWN;
>> > > > > +}
>> > > > > +
>> > > > > +static u64 fme_mgr_status(struct fpga_manager *mgr)
>> > > > > +{
>> > > > > +       struct fme_mgr_priv *priv = mgr->priv;
>> > > > > +
>> > > > > +       return pr_error_to_mgr_status(priv->pr_error);
>> > > > > +}
>> > > > > +
>> > > > > +static const struct fpga_manager_ops fme_mgr_ops = {
>> > > > > +       .write_init = fme_mgr_write_init,
>> > > > > +       .write = fme_mgr_write,
>> > > > > +       .write_complete = fme_mgr_write_complete,
>> > > > > +       .state = fme_mgr_state,
>> > > > > +       .status = fme_mgr_status,
>> > > > > +};
>> > > > > +
>> > > > > +static int fme_mgr_probe(struct platform_device *pdev)
>> > > > > +{
>> > > > > +       struct device *dev = &pdev->dev;
>> > > > > +       struct fme_mgr_priv *priv;
>> > > > > +       struct fpga_manager *mgr;
>> > > > > +       struct resource *res;
>> > > > > +       int ret;
>> > > > > +
>> > > > > +       priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>> > > > > +       if (!priv)
>> > > > > +               return -ENOMEM;
>> > > > > +
>> > > > > +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> > > > > +       priv->ioaddr = devm_ioremap(dev, res->start, resource_size(res));
>> > > > > +       if (IS_ERR(priv->ioaddr))
>> > > > > +               return PTR_ERR(priv->ioaddr);
>> > > > > +
>> > > > > +       ret = sysfs_create_files(&pdev->dev.kobj, fme_mgr_attrs);
>> > > > > +       if (ret)
>> > > > > +               return ret;
>> > > > > +
>> > > > > +       mgr = devm_kzalloc(dev, sizeof(*mgr), GFP_KERNEL);
>> > > > > +       if (!mgr)
>> > > > > +               goto sysfs_remove_exit;
>> > > > > +
>> > > > > +       mgr->name = "DFL FPGA Manager";
>> > > > > +       mgr->mops = &fme_mgr_ops;
>> > > > > +       mgr->priv = priv;
>> > > > > +       mgr->parent = dev;
>> > > > > +       platform_set_drvdata(pdev, mgr);
>> > > > > +
>> > > > > +       ret = fpga_mgr_register(mgr);
>> > > > > +       if (ret) {
>> > > > > +               dev_err(dev, "unable to register FPGA manager\n");
>> > > > > +               goto sysfs_remove_exit;
>> > > > > +       }
>> > > > > +
>> > > > > +       return 0;
>> > > > > +
>> > > > > +sysfs_remove_exit:
>> > > > > +       sysfs_remove_files(&pdev->dev.kobj, fme_mgr_attrs);
>> > > > > +       return ret;
>> > > > > +}
>> > > > > +
>> > > > > +static int fme_mgr_remove(struct platform_device *pdev)
>> > > > > +{
>> > > > > +       struct fpga_manager *mgr = platform_get_drvdata(pdev);
>> > > > > +
>> > > > > +       fpga_mgr_unregister(mgr);
>> > > > > +       sysfs_remove_files(&pdev->dev.kobj, fme_mgr_attrs);
>> > > > > +
>> > > > > +       return 0;
>> > > > > +}
>> > > > > +
>> > > > > +static struct platform_driver fme_mgr_driver = {
>> > > > > +       .driver = {
>> > > > > +               .name    = FPGA_DFL_FME_MGR,
>> > > > > +       },
>> > > > > +       .probe   = fme_mgr_probe,
>> > > > > +       .remove  = fme_mgr_remove,
>> > > > > +};
>> > > > > +
>> > > > > +module_platform_driver(fme_mgr_driver);
>> > > > > +
>> > > > > +MODULE_DESCRIPTION("FPGA Manager for FPGA Management Engine");
>> > > > > +MODULE_AUTHOR("Intel Corporation");
>> > > > > +MODULE_LICENSE("GPL v2");
>> > > > > +MODULE_ALIAS("platform:fpga-dfl-fme-mgr");
>> > > > > diff --git a/drivers/fpga/fpga-dfl.h b/drivers/fpga/fpga-dfl.h
>> > > > > index e5a1094..d45eb82 100644
>> > > > > --- a/drivers/fpga/fpga-dfl.h
>> > > > > +++ b/drivers/fpga/fpga-dfl.h
>> > > > > @@ -130,7 +130,44 @@
>> > > > >
>> > > > >  /* FME Partial Reconfiguration Sub Feature Register Set */
>> > > > >  #define FME_PR_DFH             DFH
>> > > > > -#define FME_PR_SIZE            DFH_SIZE
>> > > > > +#define FME_PR_CTRL            0x8
>> > > > > +#define FME_PR_STS             0x10
>> > > > > +#define FME_PR_DATA            0x18
>> > > > > +#define FME_PR_ERR             0x20
>> > > > > +#define FME_PR_INTFC_ID_H      0xA8
>> > > > > +#define FME_PR_INTFC_ID_L      0xB0
>> > > > > +#define FME_PR_SIZE            0xB8
>> > > > > +
>> > > > > +/* FME PR Control Register Bitfield */
>> > > > > +#define FME_PR_CTRL_PR_RST     BIT(0)  /* Reset PR engine */
>> > > > > +#define FME_PR_CTRL_PR_RSTACK  BIT(4)  /* Ack for PR engine reset */
>> > > > > +#define FME_PR_CTRL_PR_RGN_ID  GENMASK_ULL(9, 7)       /* PR Region ID */
>> > > > > +#define FME_PR_CTRL_PR_START   BIT(12) /* Start to request for PR service */
>> > > > > +#define FME_PR_CTRL_PR_COMPLETE        BIT(13) /* PR data push complete notification */
>> > > > > +
>> > > > > +/* FME PR Status Register Bitfield */
>> > > > > +/* Number of available entries in HW queue inside the PR engine. */
>> > > > > +#define FME_PR_STS_PR_CREDIT   GENMASK_ULL(8, 0)
>> > > > > +#define FME_PR_STS_PR_STS      BIT(16) /* PR operation status */
>> > > > > +#define FME_PR_STS_PR_STS_IDLE 0
>> > > > > +#define FME_PR_STS_PR_CTRLR_STS        GENMASK_ULL(22, 20)     /* Controller status */
>> > > > > +#define FME_PR_STS_PR_HOST_STS GENMASK_ULL(27, 24)     /* PR host status */
>> > > > > +
>> > > > > +/* FME PR Data Register Bitfield */
>> > > > > +/* PR data from the raw-binary file. */
>> > > > > +#define FME_PR_DATA_PR_DATA_RAW        GENMASK_ULL(32, 0)
>> > > > > +
>> > > > > +/* FME PR Error Register */
>> > > > > +/* Previous PR Operation errors detected. */
>> > > > > +#define FME_PR_ERR_OPERATION_ERR       BIT(0)
>> > > > > +/* CRC error detected. */
>> > > > > +#define FME_PR_ERR_CRC_ERR             BIT(1)
>> > > > > +/* Incompatible PR bitstream detected. */
>> > > > > +#define FME_PR_ERR_INCOMPATIBLE_BS     BIT(2)
>> > > > > +/* PR data push protocol violated. */
>> > > > > +#define FME_PR_ERR_PROTOCOL_ERR                BIT(3)
>> > > > > +/* PR data fifo overflow error detected */
>> > > > > +#define FME_PR_ERR_FIFO_OVERFLOW       BIT(4)
>> > > > >
>> > > > >  /* FME HSSI Sub Feature Register Set */
>> > > > >  #define FME_HSSI_DFH           DFH
>> > > >
>> > > > I see fpga-dfl.h as enumeration code which is separate from any driver
>> > > > implementation specifics other than what's required for the DFL
>> > > > enumeration scheme.    These PR engine #defines should move to a .h
>> > > > that is dedicated to this specific PR hardware device. If someone else
>> > > > adds a different PR device to the framework, their PR driver would
>> > > > also have its own .h.  Same for any other modules that aren't central
>> > > > to DFL enumeration.
>> > >
>> > > Sure, will move PR related register to a separated header file.
>> > > DFL enumeration related registers, will still be kept in fpga-dfl.h.
>> > >
>> > > Thanks
>> > > Hao
>> > >
>> > > >
>> > > > Thanks,
>> > > > Alan
>> > > >
>> > > > > --
>> > > > > 1.8.3.1
>> > > > >
>>
>> Thanks,
>> Moritz
>
>
