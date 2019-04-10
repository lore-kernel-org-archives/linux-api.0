From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH 11/17] fpga: dfl: afu: add error reporting support.
Date: Wed, 10 Apr 2019 09:43:58 +0800
Message-ID: <20190410014358.GB6689@hao-dev>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-12-git-send-email-hao.wu@intel.com>
 <CANk1AXS_JcdOve_7rfdzg6hkGCHY9Yp7qz6UKVq8YsRiB_fdGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXS_JcdOve_7rfdzg6hkGCHY9Yp7qz6UKVq8YsRiB_fdGg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 09, 2019 at 03:57:37PM -0500, Alan Tull wrote:
> On Sun, Mar 24, 2019 at 10:24 PM Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> >
> > Error reporting is one important private feature, it reports error
> > detected on port and accelerated function unit (AFU). It introduces
> > several sysfs interfaces to allow userspace to check and clear
> > errors detected by hardware.
> >
> > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > ---
> >  Documentation/ABI/testing/sysfs-platform-dfl-port |  29 +++
> >  drivers/fpga/Makefile                             |   1 +
> >  drivers/fpga/dfl-afu-error.c                      | 225 ++++++++++++++++++++++
> >  drivers/fpga/dfl-afu-main.c                       |   4 +
> >  drivers/fpga/dfl-afu.h                            |   4 +
> >  5 files changed, 263 insertions(+)
> >  create mode 100644 drivers/fpga/dfl-afu-error.c
> >
> > diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-port b/Documentation/ABI/testing/sysfs-platform-dfl-port
> > index f611e47..e6140aa 100644
> > --- a/Documentation/ABI/testing/sysfs-platform-dfl-port
> > +++ b/Documentation/ABI/testing/sysfs-platform-dfl-port
> > @@ -79,3 +79,32 @@ KernelVersion:       5.2
> >  Contact:       Wu Hao <hao.wu@intel.com>
> >  Description:   Read-only. Read this file to get the status of issued command
> >                 to userclck_freqcntrcmd.
> > +
> > +What:          /sys/bus/platform/devices/dfl-port.0/errors/errors
> > +Date:          March 2019
> > +KernelVersion: 5.2
> > +Contact:       Wu Hao <hao.wu@intel.com>
> > +Description:   Read-only. Read this file to get errors detected on port and
> > +               Accelerated Function Unit (AFU).
> > +
> > +What:          /sys/bus/platform/devices/dfl-port.0/errors/first_error
> > +Date:          March 2019
> > +KernelVersion: 5.2
> > +Contact:       Wu Hao <hao.wu@intel.com>
> > +Description:   Read-only. Read this file to get the first error detected by
> > +               hardware.
> > +
> > +What:          /sys/bus/platform/devices/dfl-port.0/errors/first_malformed_req
> > +Date:          March 2019
> > +KernelVersion: 5.2
> > +Contact:       Wu Hao <hao.wu@intel.com>
> > +Description:   Read-only. Read this file to get the first malformed request
> > +               captured by hardware.
> > +
> > +What:          /sys/bus/platform/devices/dfl-port.0/errors/clear
> > +Date:          March 2019
> > +KernelVersion: 5.2
> > +Contact:       Wu Hao <hao.wu@intel.com>
> > +Description:   Write-only. Write error code to this file to clear errors. If
> > +               the input error code doesn't match, it returns -EBUSY error
> > +               code.
> 
> I understand how -EBUSY could be the right error code for when the
> hardware is in a state where the error can't be cleared.  But if the
> input error code doesn't match, shouldn't the code be -EINVAL?  Also
> as noted below, the way this is currently coded, -ETIMEDOUT could get
> returned.

Thanks for the comments, let me try to capture all possible error return
values in doc in the next version to avoid confusion.

> 
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index c0dd4c8..f1f0af7 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -40,6 +40,7 @@ obj-$(CONFIG_FPGA_DFL_AFU)            += dfl-afu.o
> >
> >  dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
> >  dfl-afu-objs := dfl-afu-main.o dfl-afu-region.o dfl-afu-dma-region.o
> > +dfl-afu-objs += dfl-afu-error.o
> >
> >  # Drivers for FPGAs which implement DFL
> >  obj-$(CONFIG_FPGA_DFL_PCI)             += dfl-pci.o
> > diff --git a/drivers/fpga/dfl-afu-error.c b/drivers/fpga/dfl-afu-error.c
> > new file mode 100644
> > index 0000000..b66bd4a
> > --- /dev/null
> > +++ b/drivers/fpga/dfl-afu-error.c
> > @@ -0,0 +1,225 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Driver for FPGA Accelerated Function Unit (AFU) Error Reporting
> > + *
> > + * Copyright 2019 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Wu Hao <hao.wu@linux.intel.com>
> > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > + *   Joseph Grecco <joe.grecco@intel.com>
> > + *   Enno Luebbers <enno.luebbers@intel.com>
> > + *   Tim Whisonant <tim.whisonant@intel.com>
> > + *   Ananda Ravuri <ananda.ravuri@intel.com>
> > + *   Mitchel Henry <henry.mitchel@intel.com>
> > + */
> > +
> > +#include <linux/uaccess.h>
> > +
> > +#include "dfl-afu.h"
> > +
> > +#define PORT_ERROR_MASK                0x8
> > +#define PORT_ERROR             0x10
> > +#define PORT_FIRST_ERROR       0x18
> > +#define PORT_MALFORMED_REQ0    0x20
> > +#define PORT_MALFORMED_REQ1    0x28
> > +
> > +#define ERROR_MASK             GENMASK_ULL(63, 0)
> > +
> > +/* mask or unmask port errors by the error mask register. */
> > +static void __port_err_mask(struct device *dev, bool mask)
> > +{
> > +       void __iomem *base;
> > +
> > +       base = dfl_get_feature_ioaddr_by_id(dev, PORT_FEATURE_ID_ERROR);
> > +
> > +       writeq(mask ? ERROR_MASK : 0, base + PORT_ERROR_MASK);
> > +}
> > +
> > +/* clear port errors. */
> > +static int __port_err_clear(struct device *dev, u64 err)
> > +{
> > +       struct platform_device *pdev = to_platform_device(dev);
> > +       void __iomem *base_err, *base_hdr;
> > +       int ret;
> > +       u64 v;
> > +
> > +       base_err = dfl_get_feature_ioaddr_by_id(dev, PORT_FEATURE_ID_ERROR);
> > +       base_hdr = dfl_get_feature_ioaddr_by_id(dev, PORT_FEATURE_ID_HEADER);
> > +
> > +       /*
> > +        * clear Port Errors
> > +        *
> > +        * - Check for AP6 State
> > +        * - Halt Port by keeping Port in reset
> > +        * - Set PORT Error mask to all 1 to mask errors
> > +        * - Clear all errors
> > +        * - Set Port mask to all 0 to enable errors
> > +        * - All errors start capturing new errors
> > +        * - Enable Port by pulling the port out of reset
> > +        */
> > +
> > +       /* if device is still in AP6 power state, can not clear any error. */
> > +       v = readq(base_hdr + PORT_HDR_STS);
> > +       if (FIELD_GET(PORT_STS_PWR_STATE, v) == PORT_STS_PWR_STATE_AP6) {
> > +               dev_err(dev, "Could not clear errors, device in AP6 state.\n");
> > +               return -EBUSY;
> > +       }
> > +
> > +       /* Halt Port by keeping Port in reset */
> > +       ret = __port_disable(pdev);
> > +       if (ret)
> > +               return ret;
> 
> __port_disable can return -ETIMEDOUT which will then get returned from
> clear_store.  The sysfs document only talks about -EBUSY. You could
> either document -ETIMEDOUT in the sysfs doc or you could change the
> code to adjust the returned error code.

Yes, agree.

> 
> > +
> > +       /* Mask all errors */
> > +       __port_err_mask(dev, true);
> > +
> > +       /* Clear errors if err input matches with current port errors.*/
> > +       v = readq(base_err + PORT_ERROR);
> > +
> > +       if (v == err) {
> > +               writeq(v, base_err + PORT_ERROR);
> > +
> > +               v = readq(base_err + PORT_FIRST_ERROR);
> > +               writeq(v, base_err + PORT_FIRST_ERROR);
> > +       } else {
> > +               ret = -EBUSY;
> > +       }
> > +
> > +       /* Clear mask */
> > +       __port_err_mask(dev, false);
> > +
> > +       /* Enable the Port by clear the reset */
> > +       __port_enable(pdev);
> > +
> > +       return ret;
> > +}
> > +
> > +static ssize_t revision_show(struct device *dev, struct device_attribute *attr,
> > +                            char *buf)
> > +{
> > +       void __iomem *base;
> > +
> > +       base = dfl_get_feature_ioaddr_by_id(dev, PORT_FEATURE_ID_ERROR);
> > +
> > +       return scnprintf(buf, PAGE_SIZE, "%u\n", dfl_feature_revision(base));
> > +}
> > +static DEVICE_ATTR_RO(revision);
> 
> This appears to be adding a
> /sys/bus/platform/devices/dfl-port.0/errors/revision attribute that
> isn't documented in the sysfs document.

Sorry, will fix all above issues in the next version.

Thanks again for the code review and comments.

Hao
