From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 02/22] fpga: add FPGA device framework
Date: Thu, 27 Jul 2017 11:35:58 -0500
Message-ID: <CANk1AXRoxz7nOY--UYfBtg-3kGFy0gqCz0cbF9mOvzU2+EdzpA@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-3-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-3-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>, Rob Herring <robh+dt@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Rob,

I was hoping to pick your brain a bit on a DT question.

> During FPGA device (e.g PCI-based) discovery, platform devices are
> registered for different FPGA function units. But the device node path
> isn't quite friendly to applications.
>
> Consider this case, applications want to access child device's sysfs file
> for some information.
>
> 1) Access using bus-based path (e.g PCI)
>
>   /sys/bus/pci/devices/xxxxx/fpga_func_a.0/sysfs_file
>
>   From the path, it's clear which PCI device is the parent, but not perfect
>   solution for applications. PCI device BDF is not fixed, application may
>   need to search all PCI device to find the actual FPGA Device.
>
> 2) Or access using platform device path
>
>   /sys/bus/platform/devices/fpga_func_a.0/sysfs_file
>
>   Applications find the actual function by name easily, but no information
>   about which fpga device it belongs to. It's quite confusing if multiple
>   FPGA devices are in one system.

There's a proposal for adding sysfs nodes that correspond to each FPGA
device., with the devices located on each FPGA under them.  It makes
it easier to see which device is on which FPGA.

>
> 'FPGA Device' class is introduced to resolve this problem. Each node under
> this class represents a fpga device, which may have one or more child
> devices. Applications only need to search under this FPGA Device class
> folder to find the child device node it needs.
>
> For example, for the platform has 2 fpga devices, each fpga device has
> 3 child devices, the hierarchy looks like this.
>
> Two nodes are under /sys/class/fpga/:
> /sys/class/fpga/fpga.0
> /sys/class/fpga/fpga.1
>
> Each node has 1 function A device and 2 function B devices:
> /sys/class/fpga/fpga.0/func_a.0
> /sys/class/fpga/fpga.0/func_b.0
> /sys/class/fpga/fpga.0/func_b.1
>
> /sys/class/fpga/fpga.1/func_a.1
> /sys/class/fpga/fpga.1/func_b.2
> /sys/class/fpga/fpga.1/func_b.3

I can see the value of having sysfs nodes that correspond to fpga
devices and being able to find devices under them.  I'm thinking what
that would mean for Device Tree when fpga-dev is used on DT enabled
systems.  In Device Tree, what is a fpga-dev?

Currently the DT would have a FPGA bridge corresponding to each FPGA's
hardware bridge and a heirarchy of bridges, regions and devices under
it.  On systems that don't support partial reconfiguration under the
OS (so not main bridge that was controlled by the OS), there would be
a FPGA region, then its child regions, bridges, and devices.

Alan

>
> This following APIs are provided by FPGA device framework:
> * fpga_dev_create
>   Create fpga device under the given parent device.
> * fpga_dev_destroy
>   Destroy fpga device
>
> The following sysfs files are created:
> * /sys/class/fpga/<fpga.x>/name
>   Name of the fpga device.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
> v2: added sysfs documentation for fpga-dev class.
>     switched to GPLv2 license.
> ---
>  Documentation/ABI/testing/sysfs-class-fpga-dev |   5 ++
>  drivers/fpga/Kconfig                           |   6 ++
>  drivers/fpga/Makefile                          |   3 +
>  drivers/fpga/fpga-dev.c                        | 118 +++++++++++++++++++++++++
>  include/linux/fpga/fpga-dev.h                  |  31 +++++++
>  5 files changed, 163 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-dev
>  create mode 100644 drivers/fpga/fpga-dev.c
>  create mode 100644 include/linux/fpga/fpga-dev.h
>
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-dev b/Documentation/ABI/testing/sysfs-class-fpga-dev
> new file mode 100644
> index 0000000..ce162df
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-dev
> @@ -0,0 +1,5 @@
> +What:          /sys/class/fpga/<device>/name
> +Date:          June 2017
> +KernelVersion: 4.12
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Name of FPGA device
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index 394c141..ed600d5 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -12,6 +12,12 @@ config FPGA
>           manager drivers.
>
>  if FPGA
> +config FPGA_DEVICE
> +       tristate "FPGA Device Framework"
> +       help
> +         Say Y here if you want support for FPGA Devices from the kernel.
> +         The FPGA Device Framework adds a FPGA device class and provide
> +         interfaces to create FPGA devices.
>
>  config FPGA_REGION
>         tristate "FPGA Region"
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> index 85b45d0..8950a8f 100644
> --- a/drivers/fpga/Makefile
> +++ b/drivers/fpga/Makefile
> @@ -5,6 +5,9 @@
>  # Core FPGA Manager Framework
>  obj-$(CONFIG_FPGA)                     += fpga-mgr.o
>
> +# FPGA Device Framework
> +obj-$(CONFIG_FPGA_DEVICE)              += fpga-dev.o
> +
>  # FPGA Manager Drivers
>  obj-$(CONFIG_FPGA_MGR_ICE40_SPI)       += ice40-spi.o
>  obj-$(CONFIG_FPGA_MGR_SOCFPGA)         += socfpga.o
> diff --git a/drivers/fpga/fpga-dev.c b/drivers/fpga/fpga-dev.c
> new file mode 100644
> index 0000000..5778ebc
> --- /dev/null
> +++ b/drivers/fpga/fpga-dev.c
> @@ -0,0 +1,118 @@
> +/*
> + * FPGA Device Framework Driver
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * This work is licensed under the terms of the GNU GPL version 2. See
> + * the COPYING file in the top-level directory.
> + */
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/fpga/fpga-dev.h>
> +
> +static DEFINE_IDA(fpga_dev_ida);
> +static struct class *fpga_dev_class;
> +
> +static ssize_t name_show(struct device *dev,
> +                        struct device_attribute *attr, char *buf)
> +{
> +       struct fpga_dev *fdev = to_fpga_dev(dev);
> +
> +       return sprintf(buf, "%s\n", fdev->name);
> +}
> +static DEVICE_ATTR_RO(name);
> +
> +static struct attribute *fpga_dev_attrs[] = {
> +       &dev_attr_name.attr,
> +       NULL,
> +};
> +ATTRIBUTE_GROUPS(fpga_dev);
> +
> +/**
> + * fpga_dev_create - create a fpga device
> + * @parent: parent device
> + * @name: fpga device name
> + *
> + * Return fpga_dev struct for success, error code otherwise.
> + */
> +struct fpga_dev *fpga_dev_create(struct device *parent, const char *name)
> +{
> +       struct fpga_dev *fdev;
> +       int id, ret = 0;
> +
> +       if (!name || !strlen(name)) {
> +               dev_err(parent, "Attempt to register with no name!\n");
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       fdev = kzalloc(sizeof(*fdev), GFP_KERNEL);
> +       if (!fdev)
> +               return ERR_PTR(-ENOMEM);
> +
> +       id = ida_simple_get(&fpga_dev_ida, 0, 0, GFP_KERNEL);
> +       if (id < 0) {
> +               ret = id;
> +               goto error_kfree;
> +       }
> +
> +       fdev->name = name;
> +
> +       device_initialize(&fdev->dev);
> +       fdev->dev.class = fpga_dev_class;
> +       fdev->dev.parent = parent;
> +       fdev->dev.id = id;
> +
> +       ret = dev_set_name(&fdev->dev, "fpga.%d", id);
> +       if (ret)
> +               goto error_device;
> +
> +       ret = device_add(&fdev->dev);
> +       if (ret)
> +               goto error_device;
> +
> +       dev_dbg(fdev->dev.parent, "fpga device [%s] created\n", fdev->name);
> +
> +       return fdev;
> +
> +error_device:
> +       ida_simple_remove(&fpga_dev_ida, id);
> +error_kfree:
> +       kfree(fdev);
> +
> +       return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(fpga_dev_create);
> +
> +static void fpga_dev_release(struct device *dev)
> +{
> +       struct fpga_dev *fdev = to_fpga_dev(dev);
> +
> +       ida_simple_remove(&fpga_dev_ida, fdev->dev.id);
> +       kfree(fdev);
> +}
> +
> +static int __init fpga_dev_class_init(void)
> +{
> +       pr_info("FPGA Device framework\n");
> +
> +       fpga_dev_class = class_create(THIS_MODULE, "fpga");
> +       if (IS_ERR(fpga_dev_class))
> +               return PTR_ERR(fpga_dev_class);
> +
> +       fpga_dev_class->dev_groups = fpga_dev_groups;
> +       fpga_dev_class->dev_release = fpga_dev_release;
> +
> +       return 0;
> +}
> +
> +static void __exit fpga_dev_class_exit(void)
> +{
> +       class_destroy(fpga_dev_class);
> +}
> +
> +MODULE_DESCRIPTION("FPGA Device framework");
> +MODULE_LICENSE("GPL v2");
> +
> +subsys_initcall(fpga_dev_class_init);
> +module_exit(fpga_dev_class_exit);
> diff --git a/include/linux/fpga/fpga-dev.h b/include/linux/fpga/fpga-dev.h
> new file mode 100644
> index 0000000..ee693cc
> --- /dev/null
> +++ b/include/linux/fpga/fpga-dev.h
> @@ -0,0 +1,31 @@
> +/*
> + * FPGA Device Driver Header
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * This work is licensed under the terms of the GNU GPL version 2. See
> + * the COPYING file in the top-level directory.
> + */
> +#ifndef _LINUX_FPGA_DEV_H
> +#define _LINUX_FPGA_DEV_H
> +
> +/**
> + * struct fpga_dev - fpga device structure
> + * @name: name of fpga device
> + * @dev: fpga device
> + */
> +struct fpga_dev {
> +       const char *name;
> +       struct device dev;
> +};
> +
> +#define to_fpga_dev(d) container_of(d, struct fpga_dev, dev)
> +
> +struct fpga_dev *fpga_dev_create(struct device *parent, const char *name);
> +
> +static inline void fpga_dev_destroy(struct fpga_dev *fdev)
> +{
> +       device_unregister(&fdev->dev);
> +}
> +
> +#endif
> --
> 1.8.3.1
>
