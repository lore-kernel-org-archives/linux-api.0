From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v5 06/28] fpga: add device feature list support
Date: Wed, 6 Jun 2018 20:22:04 +0800
Message-ID: <20180606122204.GA7681@hao-dev>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com>
 <1525229431-3087-7-git-send-email-hao.wu@intel.com>
 <CANk1AXQcq4ozNA6_Ad5S1_dJHsT7OLb73xmJ9Fhjhbx1qnwa4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXQcq4ozNA6_Ad5S1_dJHsT7OLb73xmJ9Fhjhbx1qnwa4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 05, 2018 at 03:21:31PM -0500, Alan Tull wrote:
> On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,
> 
> I understand that you are implementing support for something that
> already has been defined and already exists.  With that, I have some
> minor suggestions below.  I have some questions below about how new
> features are added and suggestions for where some comments could be
> added to guide anyone who is adding feature devices or sub-features so
> they will do it cleanly in the way that you intend.  Also some
> suggestions so that when a new feature is added, less places in code
> have to be touched.

Hi Alan,

I fully understand your point, thanks a lot for the review. Please see
my response below.

> 
> > Device Feature List (DFL) defines a feature list structure that creates
> > a link list of feature headers within the MMIO space to provide an
> > extensible way of adding features. This patch introduces a kernel module
> > to provide basic infrastructure to support FPGA devices which implement
> > the Device Feature List.
> >
> > Usually there will be different features and their sub features linked into
> > the DFL. This code provides common APIs for feature enumeration, it creates
> > a container device (FPGA base region), walks through the DFLs and creates
> > platform devices for feature devices (Currently it only supports two
> > different feature devices, FPGA Management Engine (FME) and Port which
> > the Accelerator Function Unit (AFU) connected to). In order to enumerate
> > the DFLs, the common APIs required low level driver to provide necessary
> > enumeration information (e.g address for each device feature list for
> > given device) and fill it to the dfl_fpga_enum_info data structure. Please
> > refer to below description for APIs added for enumeration.
> >
> > Functions for enumeration information preparation:
> >  *dfl_fpga_enum_info_alloc
> >    allocate enumeration information data structure.
> >
> >  *dfl_fpga_enum_info_add_dfl
> >    add a device feature list to dfl_fpga_enum_info data structure.
> >
> >  *dfl_fpga_enum_info_free
> >    free dfl_fpga_enum_info data structure and related resources.
> >
> > Functions for feature device enumeration:
> >  *dfl_fpga_enumerate_feature_devs
> >    enumerate feature devices and return container device.
> >
> >  *dfl_fpga_remove_feature_devs
> >    remove feature devices under given container device.
> 
> How about dfl_fpga_feature_devs_enumerate/remove?

Sure, will rename it in v6.

> 
> >
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > ---
> > v3: split from another patch.
> >     separate dfl enumeration code from original pcie driver.
> >     provide common data structures and APIs for enumeration.
> >     update device feature list parsing process according to latest hw.
> >     add dperf/iperf/hssi sub feature placeholder according to latest hw.
> >     remove build_info_add_sub_feature and other small functions.
> >     replace *_feature_num function with macro.
> >     remove writeq/readq.
> > v4: fix SPDX license issue
> >     rename files to dfl.[ch], fix typo and add more comments.
> >     remove static feature_info tables for FME and Port.
> >     remove check on next_afu link list as only FIU has next_afu ptr.
> >     remove unused macro in header file.
> >     add more comments for functions.
> > v5: add "dfl_" prefix to functions and data structures.
> >     remove port related functions from DFL framework.
> >     use BIT_ULL for 64bit register definition.
> >     save dfl_fpga_cdev in pdata for feature platform devices.
> >     rebase due to fpga region api changes.
> > ---
> >  drivers/fpga/Kconfig  |  16 ++
> >  drivers/fpga/Makefile |   3 +
> >  drivers/fpga/dfl.c    | 720 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/fpga/dfl.h    | 279 +++++++++++++++++++
> >  4 files changed, 1018 insertions(+)
> >  create mode 100644 drivers/fpga/dfl.c
> >  create mode 100644 drivers/fpga/dfl.h
> >
> > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> > index f47ef84..01ad31f 100644
> > --- a/drivers/fpga/Kconfig
> > +++ b/drivers/fpga/Kconfig
> > @@ -124,4 +124,20 @@ config OF_FPGA_REGION
> >           Support for loading FPGA images by applying a Device Tree
> >           overlay.
> >
> > +config FPGA_DFL
> > +       tristate "FPGA Device Feature List (DFL) support"
> > +       select FPGA_BRIDGE
> > +       select FPGA_REGION
> > +       help
> > +         Device Feature List (DFL) defines a feature list structure that
> > +         creates a link list of feature headers within the MMIO space
> > +         to provide an extensible way of adding features for FPGA.
> > +         Driver can walk through the feature headers to enumerate feature
> > +         devices (e.g FPGA Management Engine, Port and Accelerator
> > +         Function Unit) and their private features for target FPGA devices.
> > +
> > +         Select this option to enable common support for Field-Programmable
> > +         Gate Array (FPGA) solutions which implement Device Feature List.
> > +         It provides enumeration APIs, and feature device infrastructure.
> > +
> >  endif # FPGA
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index 3cb276a..c4c62b9 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -27,3 +27,6 @@ obj-$(CONFIG_XILINX_PR_DECOUPLER)     += xilinx-pr-decoupler.o
> >  # High Level Interfaces
> >  obj-$(CONFIG_FPGA_REGION)              += fpga-region.o
> >  obj-$(CONFIG_OF_FPGA_REGION)           += of-fpga-region.o
> > +
> > +# FPGA Device Feature List Support
> > +obj-$(CONFIG_FPGA_DFL)                 += dfl.o
> > diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> > new file mode 100644
> > index 0000000..c1462e9
> > --- /dev/null
> > +++ b/drivers/fpga/dfl.c
> > @@ -0,0 +1,720 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Driver for FPGA Device Feature List (DFL) Support
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
> 
> 2017-2018

I will fix this in all driver files in v6.

> 
> > + *
> > + * Authors:
> > + *   Kang Luwei <luwei.kang@intel.com>
> > + *   Zhang Yi <yi.z.zhang@intel.com>
> > + *   Wu Hao <hao.wu@intel.com>
> > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > + */
> > +#include <linux/module.h>
> > +
> > +#include "dfl.h"
> > +
> > +static DEFINE_MUTEX(dfl_id_mutex);
> > +
> > +enum dfl_id_type {
> > +       FME_ID,         /* fme id allocation and mapping */
> > +       PORT_ID,        /* port id allocation and mapping */
> > +       DFL_ID_MAX,
> > +};
> 
> Please add a comment that new values of DFL_ID need to be added to this enum.
> 
> It may make sense to add dfl_chrdevs[] (from patch 7) here and add the
> DFH_ID id to that struct.  That would give you one struct that has all
> that info together in one place and new feature drivers would be added
> to it.  Any translations between dfl_id, char dev name, and
> dfl_fpga_devt_type could use that one table, and it could cut down on
> the number of if statements and special cases involved in parsing.  I
> give a few examples of usage below.

Sure, understand your point on this. Will try to fix this, and also provide
clear comments on how to add new ones.

Actually dfl_id maps to platform device name, and dfl_fpga_dev_type to char
device name. will try to find a way to do translations or just combine them
as currently each feature device (platform device) only need one chardev.

> 
> > +
> > +/* it is protected by dfl_id_mutex */
> > +static struct idr dfl_ids[DFL_ID_MAX];
> > +
> > +static void dfl_ids_init(void)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(dfl_ids); i++)
> > +               idr_init(dfl_ids + i);
> > +}
> > +
> > +static void dfl_ids_destroy(void)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(dfl_ids); i++)
> > +               idr_destroy(dfl_ids + i);
> > +}
> > +
> > +static int alloc_dfl_id(enum dfl_id_type type, struct device *dev)
> > +{
> > +       int id;
> > +
> > +       WARN_ON(type >= DFL_ID_MAX);
> > +       mutex_lock(&dfl_id_mutex);
> > +       id = idr_alloc(dfl_ids + type, dev, 0, 0, GFP_KERNEL);
> > +       mutex_unlock(&dfl_id_mutex);
> > +
> > +       return id;
> > +}
> > +
> > +static void free_dfl_id(enum dfl_id_type type, int id)
> > +{
> > +       WARN_ON(type >= DFL_ID_MAX);
> > +       mutex_lock(&dfl_id_mutex);
> > +       idr_remove(dfl_ids + type, id);
> > +       mutex_unlock(&dfl_id_mutex);
> > +}
> 
> We discussed function name groups having a matching prefix on another
> thread for another patch.  Same thing here, please, such as
> dfl_id_alloc/free.

Yes, will fix this in v6.

> 
> > +
> > +static enum dfl_id_type feature_dev_id_type(struct platform_device *pdev)
> > +{
> > +       if (!strcmp(pdev->name, DFL_FPGA_FEATURE_DEV_FME))
> > +               return FME_ID;
> > +
> > +       if (!strcmp(pdev->name, DFL_FPGA_FEATURE_DEV_PORT))
> > +               return PORT_ID;
> 
> Will a new if statement need to be added to this function for each
> added DFH_ID?  IIUC, at the point this function is called, the feature
> device exists and has private data.  Perhaps it is worth saving the ID
> in its private data so you don't have to do this reverse lookup (and
> won't have to change this function for each new feature).
> 
> Alternatively, if dfl_chrdevs[] is added in this patch, you could use
> it here, using a loop that goes through and does the lookup from that
> struct and you won't ever have to touch this function again.
> 
> In either case, if you add the names of your devices to a table like
> dfl_chrdevs[], hopefully things can be coded such that words like
> DFL_FPGA_FEATURE_DEV_FME/PORT only have to show up in that table (and
> in the individual drivers).

Understand your point, will fix this.

> 
> > +
> > +       WARN_ON(1);
> > +
> > +       return DFL_ID_MAX;
> > +}
> > +
> > +/**
> > + * struct build_feature_devs_info - info collected during feature dev build.
> > + *
> > + * @dev: device to enumerate.
> > + * @cdev: the container device for all feature devices.
> > + * @feature_dev: current feature device.
> > + * @ioaddr: header register region address of feature device in enumeration.
> > + * @sub_features: a sub features link list for feature device in enumeration.
> > + * @feature_num: number of sub features for feature device in enumeration.
> > + */
> > +struct build_feature_devs_info {
> > +       struct device *dev;
> > +       struct dfl_fpga_cdev *cdev;
> > +       struct platform_device *feature_dev;
> > +       void __iomem *ioaddr;
> > +       struct list_head sub_features;
> > +       int feature_num;
> > +};
> > +
> > +/**
> > + * struct dfl_feature_info - sub feature info collected during feature dev build
> > + *
> > + * @fid: id of this sub feature.
> > + * @mmio_res: mmio resource of this sub feature.
> > + * @ioaddr: mapped base address of mmio resource.
> > + * @node: node in sub_features link list.
> > + */
> > +struct dfl_feature_info {
> > +       u64 fid;
> > +       struct resource mmio_res;
> > +       void __iomem *ioaddr;
> > +       struct list_head node;
> > +};
> > +
> > +static void dfl_fpga_cdev_add_port_dev(struct dfl_fpga_cdev *cdev,
> > +                                      struct platform_device *port)
> > +{
> > +       struct dfl_feature_platform_data *pdata = dev_get_platdata(&port->dev);
> > +
> > +       mutex_lock(&cdev->lock);
> > +       list_add(&pdata->node, &cdev->port_dev_list);
> > +       get_device(&pdata->dev->dev);
> > +       mutex_unlock(&cdev->lock);
> > +}
> > +
> > +/*
> > + * register current feature device, it is called when we need to switch to
> > + * another feature parsing or we have parsed all features on given device
> > + * feature list.
> > + */
> > +static int build_info_commit_dev(struct build_feature_devs_info *binfo)
> > +{
> > +       struct platform_device *fdev = binfo->feature_dev;
> > +       struct dfl_feature_platform_data *pdata;
> > +       struct dfl_feature_info *finfo, *p;
> > +       int ret, index = 0;
> > +
> > +       if (!fdev)
> > +               return 0;
> > +
> > +       /*
> > +        * we do not need to care for the memory which is associated with
> > +        * the platform device. After calling platform_device_unregister(),
> > +        * it will be automatically freed by device's release() callback,
> > +        * platform_device_release().
> > +        */
> > +       pdata = kzalloc(dfl_feature_platform_data_size(binfo->feature_num),
> > +                       GFP_KERNEL);
> > +       if (pdata) {
> > +               pdata->dev = fdev;
> > +               pdata->num = binfo->feature_num;
> > +               pdata->dfl_cdev = binfo->cdev;
> > +               mutex_init(&pdata->lock);
> > +       } else {
> > +               return -ENOMEM;
> > +       }
> 
> if (!pdata)
>         return -ENOMEM;
> 
> pdata->dev = fdev; so on

will fix this.

> 
> > +
> > +       /*
> > +        * the count should be initialized to 0 to make sure
> > +        *__fpga_port_enable() following __fpga_port_disable()
> > +        * works properly for port device.
> > +        * and it should always be 0 for fme device.
> > +        */
> > +       WARN_ON(pdata->disable_count);
> > +
> > +       fdev->dev.platform_data = pdata;
> > +
> > +       /* each sub feature has one MMIO resource */
> > +       fdev->num_resources = binfo->feature_num;
> > +       fdev->resource = kcalloc(binfo->feature_num, sizeof(*fdev->resource),
> > +                                GFP_KERNEL);
> > +       if (!fdev->resource)
> > +               return -ENOMEM;
> > +
> > +       /* fill features and resource information for feature dev */
> > +       list_for_each_entry_safe(finfo, p, &binfo->sub_features, node) {
> > +               struct dfl_feature *feature = &pdata->features[index];
> > +
> > +               /* save resource information for each feature */
> > +               feature->id = finfo->fid;
> > +               feature->resource_index = index;
> > +               feature->ioaddr = finfo->ioaddr;
> > +               fdev->resource[index++] = finfo->mmio_res;
> > +
> > +               list_del(&finfo->node);
> > +               kfree(finfo);
> > +       }
> > +
> > +       ret = platform_device_add(binfo->feature_dev);
> > +       if (!ret) {
> > +               if (feature_dev_id_type(binfo->feature_dev) == PORT_ID)
> > +                       dfl_fpga_cdev_add_port_dev(binfo->cdev,
> > +                                                  binfo->feature_dev);
> > +               else
> > +                       binfo->cdev->fme_dev =
> > +                                       get_device(&binfo->feature_dev->dev);
> > +               /*
> > +                * reset it to avoid build_info_free() freeing their resource.
> > +                *
> > +                * The resource of successfully registered feature devices
> > +                * will be freed by platform_device_unregister(). See the
> > +                * comments in build_info_create_dev().
> > +                */
> > +               binfo->feature_dev = NULL;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static int
> > +build_info_create_dev(struct build_feature_devs_info *binfo,
> > +                     enum dfl_id_type type, const char *name,
> 
> If dfl_chrdevs[] were moved to this patch, build_info_create_dev could
> use it to look up the name.  That way you won't have to have separate
> functions for parse_feature_fme and parse_feature_port.

Yes, if we have the mapping table, then we don't need to pass the
related platform device name to this function. will fix this in v6.

> 
> > +                     void __iomem *ioaddr)
> > +{
> > +       struct platform_device *fdev;
> > +       int ret;
> > +
> > +       /* we will create a new device, commit current device first */
> > +       ret = build_info_commit_dev(binfo);
> > +       if (ret)
> > +               return ret;
> > +
> > +       /*
> > +        * we use -ENODEV as the initialization indicator which indicates
> > +        * whether the id need to be reclaimed
> > +        */
> > +       fdev = platform_device_alloc(name, -ENODEV);
> > +       if (!fdev)
> > +               return -ENOMEM;
> > +
> > +       binfo->feature_dev = fdev;
> > +       binfo->feature_num = 0;
> > +       binfo->ioaddr = ioaddr;
> > +       INIT_LIST_HEAD(&binfo->sub_features);
> > +
> > +       fdev->id = alloc_dfl_id(type, &fdev->dev);
> > +       if (fdev->id < 0)
> > +               return fdev->id;
> > +
> > +       fdev->dev.parent = &binfo->cdev->region->dev;
> > +
> > +       return 0;
> > +}
> > +
> > +static void build_info_free(struct build_feature_devs_info *binfo)
> > +{
> > +       struct dfl_feature_info *finfo, *p;
> > +
> > +       /*
> > +        * it is a valid id, free it. See comments in
> > +        * build_info_create_dev()
> > +        */
> > +       if (binfo->feature_dev && binfo->feature_dev->id >= 0) {
> > +               free_dfl_id(feature_dev_id_type(binfo->feature_dev),
> > +                           binfo->feature_dev->id);
> > +
> > +               list_for_each_entry_safe(finfo, p, &binfo->sub_features, node) {
> > +                       list_del(&finfo->node);
> > +                       kfree(finfo);
> > +               }
> > +       }
> > +
> > +       platform_device_put(binfo->feature_dev);
> > +
> > +       devm_kfree(binfo->dev, binfo);
> > +}
> > +
> > +static inline u32 feature_size(void __iomem *start)
> > +{
> > +       u64 v = readq(start + DFH);
> > +       u32 ofst = FIELD_GET(DFH_NEXT_HDR_OFST, v);
> > +       /* workaround for private features with invalid size, use 4K instead */
> > +       return ofst ? ofst : 4096;
> > +}
> > +
> > +static u64 feature_id(void __iomem *start)
> > +{
> > +       u64 v = readq(start + DFH);
> > +       u16 id = FIELD_GET(DFH_ID, v);
> > +       u8 type = FIELD_GET(DFH_TYPE, v);
> > +
> > +       if (type == DFH_TYPE_FIU)
> > +               return FEATURE_ID_FIU_HEADER;
> > +       else if (type == DFH_TYPE_PRIVATE)
> > +               return id;
> > +       else if (type == DFH_TYPE_AFU)
> > +               return FEATURE_ID_AFU;
> > +
> > +       WARN_ON(1);
> > +       return 0;
> > +}
> > +
> > +/*
> > + * when create sub feature instances, for private features, it doesn't need
> > + * to provide resource size and feature id as they could be read from DFH
> > + * register. For afu sub feature, its register region only contains user
> > + * defined registers, so never trust any information from it, just use the
> > + * resource size information provided by its parent FIU.
> > + */
> > +static int
> > +create_feature_instance(struct build_feature_devs_info *binfo,
> > +                       struct dfl_fpga_enum_dfl *dfl, resource_size_t ofst,
> > +                       resource_size_t size, u64 fid)
> > +{
> > +       struct dfl_feature_info *finfo;
> > +
> > +       /* read feature size and id if inputs are invalid */
> > +       size = size ? size : feature_size(dfl->ioaddr + ofst);
> > +       fid = fid ? fid : feature_id(dfl->ioaddr + ofst);
> > +
> > +       if (dfl->len - ofst < size)
> > +               return -EINVAL;
> > +
> > +       finfo = kzalloc(sizeof(*finfo), GFP_KERNEL);
> > +       if (!finfo)
> > +               return -ENOMEM;
> > +
> > +       finfo->fid = fid;
> > +       finfo->mmio_res.start = dfl->start + ofst;
> > +       finfo->mmio_res.end = finfo->mmio_res.start + size - 1;
> > +       finfo->mmio_res.flags = IORESOURCE_MEM;
> > +       finfo->ioaddr = dfl->ioaddr + ofst;
> > +
> > +       list_add_tail(&finfo->node, &binfo->sub_features);
> > +       binfo->feature_num++;
> > +
> > +       return 0;
> > +}
> > +
> > +static int parse_feature_fme(struct build_feature_devs_info *binfo,
> > +                            struct dfl_fpga_enum_dfl *dfl,
> > +                            resource_size_t ofst)
> > +{
> > +       int ret;
> > +
> > +       ret = build_info_create_dev(binfo, FME_ID, DFL_FPGA_FEATURE_DEV_FME,
> > +                                   dfl->ioaddr + ofst);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return create_feature_instance(binfo, dfl, ofst, 0, 0);
> > +}
> > +
> > +static int parse_feature_port(struct build_feature_devs_info *binfo,
> > +                             struct dfl_fpga_enum_dfl *dfl,
> > +                             resource_size_t ofst)
> > +{
> > +       int ret;
> > +
> > +       ret = build_info_create_dev(binfo, PORT_ID, DFL_FPGA_FEATURE_DEV_PORT,
> > +                                   dfl->ioaddr + ofst);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return create_feature_instance(binfo, dfl, ofst, 0, 0);
> > +}
> > +
> > +static int parse_feature_port_afu(struct build_feature_devs_info *binfo,
> > +                                 struct dfl_fpga_enum_dfl *dfl,
> > +                                 resource_size_t ofst)
> > +{
> > +       u64 v = readq(binfo->ioaddr + PORT_HDR_CAP);
> > +       u32 size = FIELD_GET(PORT_CAP_MMIO_SIZE, v) << 10;
> > +
> > +       WARN_ON(!size);
> > +
> > +       return create_feature_instance(binfo, dfl, ofst, size, FEATURE_ID_AFU);
> > +}
> > +
> > +static int parse_feature_afu(struct build_feature_devs_info *binfo,
> > +                            struct dfl_fpga_enum_dfl *dfl,
> > +                            resource_size_t ofst)
> > +{
> > +       if (!binfo->feature_dev) {
> > +               dev_err(binfo->dev, "this AFU does not belong to any FIU.\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       switch (feature_dev_id_type(binfo->feature_dev)) {
> > +       case PORT_ID:
> > +               return parse_feature_port_afu(binfo, dfl, ofst);
> > +       default:
> > +               dev_info(binfo->dev, "AFU belonging to FIU %s is not supported yet.\n",
> > +                        binfo->feature_dev->name);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int parse_feature_fiu(struct build_feature_devs_info *binfo,
> > +                            struct dfl_fpga_enum_dfl *dfl,
> > +                            resource_size_t ofst)
> > +{
> > +       u32 id, offset;
> > +       u64 v;
> > +       int ret = 0;
> > +
> > +       v = readq(dfl->ioaddr + ofst + DFH);
> > +       id = FIELD_GET(DFH_ID, v);
> > +
> > +       switch (id) {
> > +       case DFH_ID_FIU_FME:
> > +               ret = parse_feature_fme(binfo, dfl, ofst);
> > +               break;
> > +       case DFH_ID_FIU_PORT:
> > +               ret = parse_feature_port(binfo, dfl, ofst);
> > +               break;
> > +       default:
> > +               dev_info(binfo->dev, "FIU TYPE %d is not supported yet.\n",
> > +                        id);
> > +       }
> 
> If the name lookup is added to build_info_create_dev(), then this
> switch statement goes away and the contents of parse_feature_fme/port
> are identical and trivial enough to be included here.  My reason for
> looking for these things is to reduce, where possible, the places
> where a function needs to be added or changed to parse each new ID.

I see, will improve this.

Thanks
Hao
