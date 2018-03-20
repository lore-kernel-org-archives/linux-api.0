From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 12/24] fpga: dfl: fme: add
 FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Tue, 20 Mar 2018 14:46:59 +0800
Message-ID: <20180320064659.GA31239@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-13-git-send-email-hao.wu@intel.com>
 <CANk1AXQ79CvNECJav6bvs+XZHSD=1ai=kg55W4zTYvSn7GRwKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXQ79CvNECJav6bvs+XZHSD=1ai=kg55W4zTYvSn7GRwKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 19, 2018 at 01:29:52PM -0500, Alan Tull wrote:
> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> Looking at fpga-dfl.h again, there's a lot of things that start with
> FPGA_.  Don't you think this is too general?  There are other FPGA_
> things in the kernel.  Not just the things added by this patch, but
> the whole file.

Hi Alan

Thanks for the comments, I got your point here. FPGA_ things should be 
reserved for more generic things for FPGA. I will search and replace
the FPGA_xxx things used here and in other files.

> 
> > FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones which
> 
> Maybe DFL_FPGA_GET_API_VERSION?

Yes, DFL_FPGA_GET_API_VERSION looks good.

> 
> > need to be supported by all feature devices drivers including FME and AFU.
> > Userspace application can use these ioctl interfaces to get the API info
> > and check if specific extension is supported or not in current driver.
> >
> > This patch implements above 2 ioctls in FPGA Management Engine (FME)
> > driver.
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > Acked-by: Alan Tull <atull@kernel.org>
> > Acked-by: Moritz Fischer <mdf@kernel.org>
> > ---
> > v2: switched to GPLv2 license.
> > v3: rename intel-fpga.h to fpga-dfl.h and rebased.
> > v4: fix SPDX license issue.
> >     add Acked-by from Alan and Moritz.
> > ---
> >  Documentation/ioctl/ioctl-number.txt |  1 +
> >  drivers/fpga/dfl-fme-main.c          | 12 +++++++++
> >  include/uapi/linux/fpga-dfl.h        | 48 ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 61 insertions(+)
> >  create mode 100644 include/uapi/linux/fpga-dfl.h
> >
> > diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> > index 6501389..f1e7baa 100644
> > --- a/Documentation/ioctl/ioctl-number.txt
> > +++ b/Documentation/ioctl/ioctl-number.txt
> > @@ -324,6 +324,7 @@ Code  Seq#(hex)     Include File            Comments
> >  0xB3   00      linux/mmc/ioctl.h
> >  0xB4   00-0F   linux/gpio.h            <mailto:linux-gpio@vger.kernel.org>
> >  0xB5   00-0F   uapi/linux/rpmsg.h      <mailto:linux-remoteproc@vger.kernel.org>
> > +0xB6   all     linux/fpga-dfl.h
> >  0xC0   00-0F   linux/usb/iowarrior.h
> >  0xCA   00-0F   uapi/misc/cxl.h
> >  0xCA   10-2F   uapi/misc/ocxl.h
> > diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
> > index 056ae24..1a9929c 100644
> > --- a/drivers/fpga/dfl-fme-main.c
> > +++ b/drivers/fpga/dfl-fme-main.c
> > @@ -16,6 +16,7 @@
> >
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/fpga-dfl.h>
> >
> >  #include "dfl.h"
> >
> > @@ -114,6 +115,13 @@ static struct feature_driver fme_feature_drvs[] = {
> >         },
> >  };
> >
> > +static long fme_ioctl_check_extension(struct feature_platform_data *pdata,
> > +                                     unsigned long arg)
> > +{
> > +       /* No extension support for now */
> > +       return 0;
> > +}
> > +
> >  static int fme_open(struct inode *inode, struct file *filp)
> >  {
> >         struct platform_device *fdev = fpga_inode_to_feature_dev(inode);
> > @@ -154,6 +162,10 @@ static long fme_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >         dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
> >
> >         switch (cmd) {
> > +       case FPGA_GET_API_VERSION:
> > +               return FPGA_API_VERSION;
> > +       case FPGA_CHECK_EXTENSION:
> > +               return fme_ioctl_check_extension(pdata, arg);
> >         default:
> >                 /*
> >                  * Let sub-feature's ioctl function to handle the cmd
> > diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-dfl.h
> > new file mode 100644
> > index 0000000..9321ee9
> > --- /dev/null
> > +++ b/include/uapi/linux/fpga-dfl.h
> > @@ -0,0 +1,48 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/*
> > + * Header File for FPGA DFL User API
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
> > + *
> > + * Authors:
> > + *   Kang Luwei <luwei.kang@intel.com>
> > + *   Zhang Yi <yi.z.zhang@intel.com>
> > + *   Wu Hao <hao.wu@intel.com>
> > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > + */
> > +
> > +#ifndef _UAPI_LINUX_FPGA_DFL_H
> > +#define _UAPI_LINUX_FPGA_DFL_H
> > +
> > +#define FPGA_API_VERSION 0
> 
> There will be other FPGA API's.  Maybe DFL_FPGA_... or FME_FPGA_...

I will pick DFL_FPGA_... here and below places. :)

> 
> > +
> > +/*
> > + * The IOCTL interface for DFL based FPGA is designed for extensibility by
> > + * embedding the structure length (argsz) and flags into structures passed
> > + * between kernel and userspace. This design referenced the VFIO IOCTL
> > + * interface (include/uapi/linux/vfio.h).
> > + */
> > +
> > +#define FPGA_MAGIC 0xB6
> 
> Same here.
> 
> > +
> > +#define FPGA_BASE 0
> 
> And here.
> 
> > +
> > +/**
> > + * FPGA_GET_API_VERSION - _IO(FPGA_MAGIC, FPGA_BASE + 0)
> > + *
> > + * Report the version of the driver API.
> > + * Return: Driver API Version.
> > + */
> > +
> > +#define FPGA_GET_API_VERSION   _IO(FPGA_MAGIC, FPGA_BASE + 0)
> > +
> > +/**
> > + * FPGA_CHECK_EXTENSION - _IO(FPGA_MAGIC, FPGA_BASE + 1)
> > + *
> > + * Check whether an extension is supported.
> > + * Return: 0 if not supported, otherwise the extension is supported.
> > + */
> > +
> > +#define FPGA_CHECK_EXTENSION   _IO(FPGA_MAGIC, FPGA_BASE + 1)
> 
> Basically all the FPGA_* stuff here is specific to this particular DFL
> FPGA API and should have a better name.

Will update them in the next version, thanks again for the comments.

Hao

> 
> Alan
> 
> > +
> > +#endif /* _UAPI_LINUX_FPGA_DFL_H */
> > --
> > 2.7.4
> >
