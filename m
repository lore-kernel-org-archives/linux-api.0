From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 04/24] fpga: add device feature list support
Date: Fri, 23 Mar 2018 12:33:04 +0800
Message-ID: <20180323043304.GA14733@hao-dev>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-5-git-send-email-hao.wu@intel.com>
 <CANk1AXSaE3wQ7jnBkB0TR3kLKnG1XUeHk+LbDSxyRtBxbMNGPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSaE3wQ7jnBkB0TR3kLKnG1XUeHk+LbDSxyRtBxbMNGPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 22, 2018 at 04:31:05PM -0500, Alan Tull wrote:
> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
> 
> Hi Hao,

Hi Alan

Thanks a lot for the code review and the comments. : )

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
> > given device) and fill it to the fpga_enum_info data structure. Please
> > refer to below description for APIs added for enumeration.
> >
> > Functions for enumeration information preparation:
> >  *fpga_enum_info_alloc
> >    allocate enumeration information data structure.
> >
> >  *fpga_enum_info_add_dfl
> >    add a device feature list to fpga_enum_info data structure.
> >
> >  *fpga_enum_info_free
> >    free fpga_enum_info data structure and related resources.
> >
> > Functions for feature device enumeration:
> >  *fpga_enumerate_feature_devs
> >    enumerate feature devices and return container device.
> >
> >  *fpga_remove_feature_devs
> >    remove feature devices under given container device.
> 
> This header doesn't say anything about the reset or bridge
> functionality (fpga_port_enable/disable/reset) that's added here and
> used elsewhere in the patch set.

Sure, I will add descriptions for these functions in the next version.

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
> > ---
> >  drivers/fpga/Kconfig  |  16 +
> >  drivers/fpga/Makefile |   3 +
> >  drivers/fpga/dfl.c    | 787 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/fpga/dfl.h    | 345 ++++++++++++++++++++++
> >  4 files changed, 1151 insertions(+)
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
> > index 0000000..f50694e
> > --- /dev/null
> > +++ b/drivers/fpga/dfl.c
> > @@ -0,0 +1,787 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Driver for FPGA Device Feature List (DFL) Support
> > + *
> > + * Copyright (C) 2017 Intel Corporation, Inc.
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
> > +static DEFINE_MUTEX(fpga_id_mutex);
> > +
> > +enum fpga_id_type {
> > +       FME_ID,         /* fme id allocation and mapping */
> > +       PORT_ID,        /* port id allocation and mapping */
> > +       FPGA_ID_MAX,
> > +};
> > +
> > +/* it is protected by fpga_id_mutex */
> > +static struct idr fpga_ids[FPGA_ID_MAX];
> > +
> > +static void fpga_ids_init(void)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(fpga_ids); i++)
> > +               idr_init(fpga_ids + i);
> > +}
> > +
> > +static void fpga_ids_destroy(void)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(fpga_ids); i++)
> > +               idr_destroy(fpga_ids + i);
> > +}
> > +
> > +static int alloc_fpga_id(enum fpga_id_type type, struct device *dev)
> > +{
> > +       int id;
> > +
> > +       WARN_ON(type >= FPGA_ID_MAX);
> > +       mutex_lock(&fpga_id_mutex);
> > +       id = idr_alloc(fpga_ids + type, dev, 0, 0, GFP_KERNEL);
> > +       mutex_unlock(&fpga_id_mutex);
> > +
> > +       return id;
> > +}
> > +
> > +static void free_fpga_id(enum fpga_id_type type, int id)
> > +{
> > +       WARN_ON(type >= FPGA_ID_MAX);
> > +       mutex_lock(&fpga_id_mutex);
> > +       idr_remove(fpga_ids + type, id);
> > +       mutex_unlock(&fpga_id_mutex);
> > +}
> > +
> > +static enum fpga_id_type feature_dev_id_type(struct platform_device *pdev)
> > +{
> > +       if (!strcmp(pdev->name, FPGA_FEATURE_DEV_FME))
> > +               return FME_ID;
> > +
> > +       if (!strcmp(pdev->name, FPGA_FEATURE_DEV_PORT))
> > +               return PORT_ID;
> > +
> > +       WARN_ON(1);
> > +
> > +       return FPGA_ID_MAX;
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
> > +       struct fpga_cdev *cdev;
> > +       struct platform_device *feature_dev;
> > +       void __iomem *ioaddr;
> > +       struct list_head sub_features;
> > +       int feature_num;
> > +};
> > +
> > +/**
> > + * struct feature_info - sub feature info collected during feature dev build.
> > + *
> > + * @fid: id of this sub feature.
> > + * @mmio_res: mmio resource of this sub feature.
> > + * @ioaddr: mapped base address of mmio resource.
> > + * @node: node in sub_features link list.
> > + */
> > +struct feature_info {
> > +       u64 fid;
> > +       struct resource mmio_res;
> > +       void __iomem *ioaddr;
> > +       struct list_head node;
> > +};
> > +
> > +static void fpga_cdev_add_port_dev(struct fpga_cdev *cdev,
> > +                                  struct platform_device *port_pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&port_pdev->dev);
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
> > +       struct feature_platform_data *pdata;
> > +       struct feature_info *finfo, *p;
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
> > +       pdata = kzalloc(feature_platform_data_size(binfo->feature_num),
> > +                       GFP_KERNEL);
> > +       if (pdata) {
> > +               pdata->dev = fdev;
> > +               pdata->num = binfo->feature_num;
> > +               mutex_init(&pdata->lock);
> > +       } else {
> > +               return -ENOMEM;
> > +       }
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
> > +               struct feature *feature = &pdata->features[index];
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
> > +                       fpga_cdev_add_port_dev(binfo->cdev, binfo->feature_dev);
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
> > +                     enum fpga_id_type type, const char *name,
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
> > +       fdev->id = alloc_fpga_id(type, &fdev->dev);
> > +       if (fdev->id < 0)
> > +               return fdev->id;
> > +
> > +       fdev->dev.parent = &binfo->cdev->region.dev;
> > +
> > +       return 0;
> > +}
> > +
> > +static void build_info_free(struct build_feature_devs_info *binfo)
> > +{
> > +       struct feature_info *finfo, *p;
> > +
> > +       /*
> > +        * it is a valid id, free it. See comments in
> > +        * build_info_create_dev()
> > +        */
> > +       if (binfo->feature_dev && binfo->feature_dev->id >= 0) {
> > +               free_fpga_id(feature_dev_id_type(binfo->feature_dev),
> > +                            binfo->feature_dev->id);
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
> > +                       struct fpga_enum_dfl *dfl, resource_size_t ofst,
> > +                       resource_size_t size, u64 fid)
> > +{
> > +       struct feature_info *finfo;
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
> > +                            struct fpga_enum_dfl *dfl, resource_size_t ofst)
> > +{
> > +       int ret;
> > +
> > +       ret = build_info_create_dev(binfo, FME_ID, FPGA_FEATURE_DEV_FME,
> > +                                   dfl->ioaddr + ofst);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return create_feature_instance(binfo, dfl, ofst, 0, 0);
> > +}
> > +
> > +static int parse_feature_port(struct build_feature_devs_info *binfo,
> > +                             struct fpga_enum_dfl *dfl,
> > +                             resource_size_t ofst)
> > +{
> > +       int ret;
> > +
> > +       ret = build_info_create_dev(binfo, PORT_ID, FPGA_FEATURE_DEV_PORT,
> > +                                   dfl->ioaddr + ofst);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return create_feature_instance(binfo, dfl, ofst, 0, 0);
> > +}
> > +
> > +static int parse_feature_port_afu(struct build_feature_devs_info *binfo,
> > +                                 struct fpga_enum_dfl *dfl,
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
> > +                            struct fpga_enum_dfl *dfl,
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
> > +                            struct fpga_enum_dfl *dfl,
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
> > +
> > +       if (ret)
> > +               return ret;
> > +
> > +       /* Find and parse FIU's child AFU via its NEXT_AFU register */
> > +       v = readq(dfl->ioaddr + ofst + NEXT_AFU);
> > +
> > +       offset = FIELD_GET(NEXT_AFU_NEXT_DFH_OFST, v);
> > +       if (offset)
> > +               return parse_feature_afu(binfo, dfl, ofst + offset);
> > +
> > +       dev_dbg(binfo->dev, "No AFUs detected on FIU %d\n", id);
> > +
> > +       return ret;
> > +}
> > +
> > +static int parse_feature_private(struct build_feature_devs_info *binfo,
> > +                                struct fpga_enum_dfl *dfl,
> > +                                resource_size_t ofst)
> > +{
> > +       if (!binfo->feature_dev) {
> > +               dev_err(binfo->dev, "the private feature %llx does not belong to any AFU.\n",
> > +                       (unsigned long long)feature_id(dfl->ioaddr + ofst));
> > +               return -EINVAL;
> > +       }
> > +
> > +       return create_feature_instance(binfo, dfl, ofst, 0, 0);
> > +}
> > +
> > +/**
> > + * parse_feature - parse a feature on given device feature list
> > + *
> > + * @binfo: build feature devices information.
> > + * @dfl: device feature list to parse
> > + * @ofst: offset to feature header on this device feature list
> > + */
> > +static int parse_feature(struct build_feature_devs_info *binfo,
> > +                        struct fpga_enum_dfl *dfl, resource_size_t ofst)
> > +{
> > +       u64 v;
> > +       u32 type;
> > +
> > +       v = readq(dfl->ioaddr + ofst + DFH);
> > +       type = FIELD_GET(DFH_TYPE, v);
> > +
> > +       switch (type) {
> > +       case DFH_TYPE_AFU:
> > +               return parse_feature_afu(binfo, dfl, ofst);
> > +       case DFH_TYPE_PRIVATE:
> > +               return parse_feature_private(binfo, dfl, ofst);
> > +       case DFH_TYPE_FIU:
> > +               return parse_feature_fiu(binfo, dfl, ofst);
> > +       default:
> > +               dev_info(binfo->dev,
> > +                        "Feature Type %x is not supported.\n", type);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int parse_feature_list(struct build_feature_devs_info *binfo,
> > +                             struct fpga_enum_dfl *dfl)
> > +{
> > +       void __iomem *start = dfl->ioaddr;
> > +       void __iomem *end = dfl->ioaddr + dfl->len;
> > +       int ret = 0;
> > +       u32 ofst = 0;
> > +       u64 v;
> > +
> > +       /* walk through the device feature list via DFH's next DFH pointer. */
> > +       for (; start < end; start += ofst) {
> > +               if (end - start < DFH_SIZE) {
> > +                       dev_err(binfo->dev, "The region is too small to contain a feature.\n");
> > +                       return -EINVAL;
> > +               }
> > +
> > +               ret = parse_feature(binfo, dfl, start - dfl->ioaddr);
> > +               if (ret)
> > +                       return ret;
> > +
> > +               v = readq(start + DFH);
> > +               ofst = FIELD_GET(DFH_NEXT_HDR_OFST, v);
> > +
> > +               /* stop parsing if EOL(End of List) is set or offset is 0 */
> > +               if ((v & DFH_EOL) || !ofst)
> > +                       break;
> > +       }
> > +
> > +       /* commit current feature device when reach the end of list */
> > +       return build_info_commit_dev(binfo);
> > +}
> > +
> > +struct fpga_enum_info *fpga_enum_info_alloc(struct device *dev)
> > +{
> > +       struct fpga_enum_info *info;
> > +
> > +       get_device(dev);
> > +
> > +       info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
> > +       if (!info) {
> > +               put_device(dev);
> > +               return NULL;
> > +       }
> > +
> > +       info->dev = dev;
> > +       INIT_LIST_HEAD(&info->dfls);
> > +
> > +       return info;
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_enum_info_alloc);
> > +
> > +void fpga_enum_info_free(struct fpga_enum_info *info)
> > +{
> > +       struct fpga_enum_dfl *tmp, *dfl;
> > +       struct device *dev;
> > +
> > +       if (!info)
> > +               return;
> > +
> > +       dev = info->dev;
> > +
> > +       /* remove all device feature lists in the list. */
> > +       list_for_each_entry_safe(dfl, tmp, &info->dfls, node) {
> > +               list_del(&dfl->node);
> > +               devm_kfree(dev, dfl);
> > +       }
> > +
> > +       devm_kfree(dev, info);
> > +       put_device(dev);
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_enum_info_free);
> > +
> > +/**
> > + * fpga_enum_info_add_dfl - add info for a device feature list to fpga_enum_info
> > + *
> > + * @info: ptr to fpga_enum_info
> > + * @start: mmio resource address of the device feature list.
> > + * @len: mmio resource length of the device feature list.
> > + * @ioaddr: mapped mmio resource address of the device feature list.
> > + *
> > + * One FPGA device may have 1 or more Device Feature Lists (DFLs), use this
> > + * function to add information of each DFL to common data structure for next
> > + * step enumeration.
> > + *
> > + * Return: 0 on success, negative error code otherwise.
> > + */
> > +int fpga_enum_info_add_dfl(struct fpga_enum_info *info, resource_size_t start,
> > +                          resource_size_t len, void __iomem *ioaddr)
> > +{
> > +       struct fpga_enum_dfl *dfl;
> > +
> > +       dfl = devm_kzalloc(info->dev, sizeof(*dfl), GFP_KERNEL);
> > +       if (!dfl)
> > +               return -ENOMEM;
> > +
> > +       dfl->start = start;
> > +       dfl->len = len;
> > +       dfl->ioaddr = ioaddr;
> > +
> > +       list_add_tail(&dfl->node, &info->dfls);
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_enum_info_add_dfl);
> > +
> > +static int remove_feature_dev(struct device *dev, void *data)
> > +{
> > +       struct platform_device *pdev = to_platform_device(dev);
> > +       enum fpga_id_type type = feature_dev_id_type(pdev);
> > +       int id = pdev->id;
> > +
> > +       platform_device_unregister(pdev);
> > +
> > +       free_fpga_id(type, id);
> > +
> > +       return 0;
> > +}
> > +
> > +static void remove_feature_devs(struct fpga_cdev *cdev)
> > +{
> > +       device_for_each_child(&cdev->region.dev, NULL, remove_feature_dev);
> > +}
> > +
> > +/**
> > + * fpga_enumerate_feature_devs - enumerate feature devices
> > + * @info: information for enumeration.
> > + *
> > + * This function creates a container device (base FPGA region), enumerates
> > + * feature devices based on the enumeration info and creates platform devices
> > + * under the container device.
> > + *
> > + * Return: fpga_cdev struct on success, -errno on failure
> > + */
> > +struct fpga_cdev *fpga_enumerate_feature_devs(struct fpga_enum_info *info)
> > +{
> > +       struct build_feature_devs_info *binfo;
> > +       struct fpga_cdev *cdev;
> > +       struct fpga_enum_dfl *dfl;
> > +       int ret = 0;
> > +
> > +       if (!info->dev)
> > +               return ERR_PTR(-ENODEV);
> > +
> > +       cdev = devm_kzalloc(info->dev, sizeof(*cdev), GFP_KERNEL);
> > +       if (!cdev)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       cdev->parent = info->dev;
> > +       mutex_init(&cdev->lock);
> > +       INIT_LIST_HEAD(&cdev->port_dev_list);
> > +       cdev->region.parent = info->dev;
> > +
> > +       ret = fpga_region_register(&cdev->region);
> > +       if (ret)
> > +               goto free_cdev_exit;
> > +
> > +       /* create and init build info for enumeration */
> > +       binfo = devm_kzalloc(info->dev, sizeof(*binfo), GFP_KERNEL);
> > +       if (!binfo) {
> > +               ret = -ENOMEM;
> > +               goto unregister_region_exit;
> > +       }
> > +
> > +       binfo->dev = info->dev;
> > +       binfo->cdev = cdev;
> > +
> > +       /*
> > +        * start enumeration for all feature devices based on Device Feature
> > +        * Lists.
> > +        */
> > +       list_for_each_entry(dfl, &info->dfls, node) {
> > +               ret = parse_feature_list(binfo, dfl);
> > +               if (ret) {
> > +                       remove_feature_devs(cdev);
> > +                       build_info_free(binfo);
> > +                       goto unregister_region_exit;
> > +               }
> > +       }
> > +
> > +       build_info_free(binfo);
> > +
> > +       return cdev;
> > +
> > +unregister_region_exit:
> > +       fpga_region_unregister(&cdev->region);
> > +free_cdev_exit:
> > +       devm_kfree(cdev->parent, cdev);
> > +       return ERR_PTR(ret);
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_enumerate_feature_devs);
> > +
> > +/**
> > + * fpga_remove_feature_devs - remove all feature devices
> > + * @cdev: fpga container device.
> > + *
> > + * Remove the container device and all feature devices under given container
> > + * devices.
> > + */
> > +void fpga_remove_feature_devs(struct fpga_cdev *cdev)
> > +{
> > +       struct feature_platform_data *pdata, *ptmp;
> > +
> > +       remove_feature_devs(cdev);
> > +
> > +       mutex_lock(&cdev->lock);
> > +       if (cdev->fme_dev) {
> > +               /* the fme should be unregistered. */
> > +               WARN_ON(device_is_registered(cdev->fme_dev));
> > +               put_device(cdev->fme_dev);
> > +       }
> > +
> > +       list_for_each_entry_safe(pdata, ptmp, &cdev->port_dev_list, node) {
> > +               struct platform_device *port_dev = pdata->dev;
> > +
> > +               /* the port should be unregistered. */
> > +               WARN_ON(device_is_registered(&port_dev->dev));
> > +               list_del(&pdata->node);
> > +               put_device(&port_dev->dev);
> > +       }
> > +       mutex_unlock(&cdev->lock);
> > +
> > +       fpga_region_unregister(&cdev->region);
> > +       devm_kfree(cdev->parent, cdev);
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_remove_feature_devs);
> > +
> > +int fpga_port_id(struct platform_device *pdev)
> > +{
> > +       void __iomem *base = get_feature_ioaddr_by_id(&pdev->dev,
> > +                                                     PORT_FEATURE_ID_HEADER);
> > +
> > +       return FIELD_GET(PORT_CAP_PORT_NUM, readq(base + PORT_HDR_CAP));
> > +}
> > +EXPORT_SYMBOL_GPL(fpga_port_id);
> > +
> > +/**
> > + * __fpga_port_enable - enable a port
> > + * @pdev: port platform device.
> > + *
> > + * Enable Port by clear the port soft reset bit, which is set by default.
> > + * The User AFU is unable to respond to any MMIO access while in reset.
> > + * __fpga_port_enable function should only be used after __fpga_port_disable
> > + * function.
> > + */
> > +void __fpga_port_enable(struct platform_device *pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +       void __iomem *base;
> > +       u64 v;
> > +
> > +       WARN_ON(!pdata->disable_count);
> > +
> > +       if (--pdata->disable_count != 0)
> > +               return;
> > +
> > +       base = get_feature_ioaddr_by_id(&pdev->dev, PORT_FEATURE_ID_HEADER);
> > +
> > +       /* Clear port soft reset */
> > +       v = readq(base + PORT_HDR_CTRL);
> > +       v &= ~PORT_CTRL_SFTRST;
> > +       writeq(v, base + PORT_HDR_CTRL);
> > +}
> > +EXPORT_SYMBOL_GPL(__fpga_port_enable);
> > +
> > +#define RST_POLL_INVL 10 /* us */
> > +#define RST_POLL_TIMEOUT 1000 /* us */
> > +
> > +/**
> > + * __fpga_port_disable - disable a port
> > + * @pdev: port platform device.
> > + *
> > + * Disable Port by setting the port soft reset bit, it puts the port into
> > + * reset.
> > + */
> > +int __fpga_port_disable(struct platform_device *pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +       void __iomem *base;
> > +       u64 v;
> > +
> > +       if (pdata->disable_count++ != 0)
> > +               return 0;
> > +
> > +       base = get_feature_ioaddr_by_id(&pdev->dev, PORT_FEATURE_ID_HEADER);
> > +
> > +       /* Set port soft reset */
> > +       v = readq(base + PORT_HDR_CTRL);
> > +       v |= PORT_CTRL_SFTRST;
> > +       writeq(v, base + PORT_HDR_CTRL);
> > +
> > +       /*
> > +        * HW sets ack bit to 1 when all outstanding requests have been drained
> > +        * on this port and minimum soft reset pulse width has elapsed.
> > +        * Driver polls port_soft_reset_ack to determine if reset done by HW.
> > +        */
> > +       if (readq_poll_timeout(base + PORT_HDR_CTRL, v, v & PORT_CTRL_SFTRST,
> > +                              RST_POLL_INVL, RST_POLL_TIMEOUT)) {
> > +               dev_err(&pdev->dev, "timeout, fail to reset device\n");
> > +               return -ETIMEDOUT;
> > +       }
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(__fpga_port_disable);
> > +
> > +static int __init dfl_fpga_init(void)
> > +{
> > +       fpga_ids_init();
> > +
> > +       return 0;
> > +}
> > +
> > +static void __exit dfl_fpga_exit(void)
> > +{
> > +       fpga_ids_destroy();
> > +}
> > +
> > +module_init(dfl_fpga_init);
> > +module_exit(dfl_fpga_exit);
> > +
> > +MODULE_DESCRIPTION("FPGA Device Feature List (DFL) Support");
> > +MODULE_AUTHOR("Intel Corporation");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
> > new file mode 100644
> > index 0000000..22dcf73
> > --- /dev/null
> > +++ b/drivers/fpga/dfl.h
> > @@ -0,0 +1,345 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Driver Header File for FPGA Device Feature List (DFL) Support
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
> > +#ifndef __FPGA_DFL_H
> > +#define __FPGA_DFL_H
> > +
> > +#include <linux/bitfield.h>
> > +#include <linux/delay.h>
> > +#include <linux/fs.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/io-64-nonatomic-lo-hi.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/slab.h>
> > +#include <linux/uuid.h>
> > +#include <linux/fpga/fpga-region.h>
> > +
> > +/* maximum supported number of ports */
> > +#define MAX_FPGA_PORT_NUM 4
> > +/* plus one for fme device */
> > +#define MAX_FEATURE_DEV_NUM    (MAX_FPGA_PORT_NUM + 1)
> > +
> > +/* Reserved 0x0 for Header Group Register and 0xff for AFU */
> > +#define FEATURE_ID_FIU_HEADER          0x0
> > +#define FEATURE_ID_AFU                 0xff
> > +
> > +#define FME_FEATURE_ID_HEADER          FEATURE_ID_FIU_HEADER
> > +#define FME_FEATURE_ID_THERMAL_MGMT    0x1
> > +#define FME_FEATURE_ID_POWER_MGMT      0x2
> > +#define FME_FEATURE_ID_GLOBAL_IPERF    0x3
> > +#define FME_FEATURE_ID_GLOBAL_ERR      0x4
> > +#define FME_FEATURE_ID_PR_MGMT         0x5
> > +#define FME_FEATURE_ID_HSSI            0x6
> > +#define FME_FEATURE_ID_GLOBAL_DPERF    0x7
> > +
> > +#define PORT_FEATURE_ID_HEADER         FEATURE_ID_FIU_HEADER
> > +#define PORT_FEATURE_ID_AFU            FEATURE_ID_AFU
> > +#define PORT_FEATURE_ID_ERROR          0x10
> > +#define PORT_FEATURE_ID_UMSG           0x11
> > +#define PORT_FEATURE_ID_UINT           0x12
> > +#define PORT_FEATURE_ID_STP            0x13
> > +
> > +/*
> > + * Device Feature Header Register Set
> > + *
> > + * For FIUs, they all have DFH + GUID + NEXT_AFU as common header registers.
> > + * For AFUs, they have DFH + GUID as common header registers.
> > + * For private features, they only have DFH register as common header.
> > + */
> > +#define DFH                    0x0
> > +#define GUID_L                 0x8
> > +#define GUID_H                 0x10
> > +#define NEXT_AFU               0x18
> > +
> > +#define DFH_SIZE               0x8
> > +
> > +/* Device Feature Header Register Bitfield */
> > +#define DFH_ID                 GENMASK_ULL(11, 0)      /* Feature ID */
> > +#define DFH_ID_FIU_FME         0
> > +#define DFH_ID_FIU_PORT                1
> > +#define DFH_REVISION           GENMASK_ULL(15, 12)     /* Feature revision */
> > +#define DFH_NEXT_HDR_OFST      GENMASK_ULL(39, 16)     /* Offset to next DFH */
> > +#define DFH_EOL                        BIT(40)                 /* End of list */
> > +#define DFH_TYPE               GENMASK_ULL(63, 60)     /* Feature type */
> > +#define DFH_TYPE_AFU           1
> > +#define DFH_TYPE_PRIVATE       3
> > +#define DFH_TYPE_FIU           4
> > +
> > +/* Next AFU Register Bitfield */
> > +#define NEXT_AFU_NEXT_DFH_OFST GENMASK_ULL(23, 0)      /* Offset to next AFU */
> > +
> > +/* FME Header Register Set */
> > +#define FME_HDR_DFH            DFH
> > +#define FME_HDR_GUID_L         GUID_L
> > +#define FME_HDR_GUID_H         GUID_H
> > +#define FME_HDR_NEXT_AFU       NEXT_AFU
> > +#define FME_HDR_CAP            0x30
> > +#define FME_HDR_PORT_OFST(n)   (0x38 + ((n) * 0x8))
> > +#define FME_HDR_BITSTREAM_ID   0x60
> > +#define FME_HDR_BITSTREAM_MD   0x68
> > +
> > +/* FME Fab Capability Register Bitfield */
> > +#define FME_CAP_FABRIC_VERID   GENMASK_ULL(7, 0)       /* Fabric version ID */
> > +#define FME_CAP_SOCKET_ID      BIT(8)                  /* Socket ID */
> > +#define FME_CAP_PCIE0_LINK_AVL BIT(12)                 /* PCIE0 Link */
> > +#define FME_CAP_PCIE1_LINK_AVL BIT(13)                 /* PCIE1 Link */
> > +#define FME_CAP_COHR_LINK_AVL  BIT(14)                 /* Coherent Link */
> > +#define FME_CAP_IOMMU_AVL      BIT(16)                 /* IOMMU available */
> > +#define FME_CAP_NUM_PORTS      GENMASK_ULL(19, 17)     /* Number of ports */
> > +#define FME_CAP_ADDR_WIDTH     GENMASK_ULL(29, 24)     /* Address bus width */
> > +#define FME_CAP_CACHE_SIZE     GENMASK_ULL(43, 32)     /* cache size in KB */
> > +#define FME_CAP_CACHE_ASSOC    GENMASK_ULL(47, 44)     /* Associativity */
> > +
> > +/* FME Port Offset Register Bitfield */
> > +/* Offset to port device feature header */
> > +#define FME_PORT_OFST_DFH_OFST GENMASK_ULL(23, 0)
> > +/* PCI Bar ID for this port */
> > +#define FME_PORT_OFST_BAR_ID   GENMASK_ULL(34, 32)
> > +/* AFU MMIO access permission. 1 - VF, 0 - PF. */
> > +#define FME_PORT_OFST_ACC_CTRL BIT(55)
> > +#define FME_PORT_OFST_ACC_PF   0
> > +#define FME_PORT_OFST_ACC_VF   1
> > +#define FME_PORT_OFST_IMP      BIT(60)
> > +
> > +/* PORT Header Register Set */
> > +#define PORT_HDR_DFH           DFH
> > +#define PORT_HDR_GUID_L                GUID_L
> > +#define PORT_HDR_GUID_H                GUID_H
> > +#define PORT_HDR_NEXT_AFU      NEXT_AFU
> > +#define PORT_HDR_CAP           0x30
> > +#define PORT_HDR_CTRL          0x38
> > +
> > +/* Port Capability Register Bitfield */
> > +#define PORT_CAP_PORT_NUM      GENMASK_ULL(1, 0)       /* ID of this port */
> > +#define PORT_CAP_MMIO_SIZE     GENMASK_ULL(23, 8)      /* MMIO size in KB */
> > +#define PORT_CAP_SUPP_INT_NUM  GENMASK_ULL(35, 32)     /* Interrupts num */
> > +
> > +/* Port Control Register Bitfield */
> > +#define PORT_CTRL_SFTRST       BIT(0)                  /* Port soft reset */
> > +/* Latency tolerance reporting. '1' >= 40us, '0' < 40us.*/
> > +#define PORT_CTRL_LATENCY      BIT(2)
> > +#define PORT_CTRL_SFTRST_ACK   BIT(4)                  /* HW ack for reset */
> > +
> > +/**
> > + * struct feature - sub feature of the feature devices
> > + *
> > + * @id:        sub feature id.
> > + * @resource_index: each sub feature has one mmio resource for its registers.
> > + *                 this index is used to find its mmio resource from the
> > + *                 feature dev (platform device)'s reources.
> > + * @ioaddr: mapped mmio resource address.
> > + */
> > +struct feature {
> > +       u64 id;
> > +       int resource_index;
> > +       void __iomem *ioaddr;
> > +};
> > +
> > +/**
> > + * struct feature_platform_data - platform data for feature devices
> > + *
> > + * @node: node to link feature devs to container device's port_dev_list.
> > + * @lock: mutex to protect platform data.
> > + * @dev: ptr to platform device linked with this platform data.
> > + * @disable_count: count for port disable.
> > + * @num: number for sub features.
> > + * @features: sub features of this feature dev.
> > + */
> > +struct feature_platform_data {
> > +       struct list_head node;
> > +       struct mutex lock;
> > +       struct platform_device *dev;
> > +       unsigned int disable_count;
> > +
> > +       int num;
> > +       struct feature features[0];
> > +};
> > +
> > +#define FPGA_FEATURE_DEV_FME           "dfl-fme"
> > +#define FPGA_FEATURE_DEV_PORT          "dfl-port"
> > +
> > +static inline int feature_platform_data_size(const int num)
> > +{
> > +       return sizeof(struct feature_platform_data) +
> > +               num * sizeof(struct feature);
> > +}
> > +
> > +int fpga_port_id(struct platform_device *pdev);
> > +
> > +static inline int fpga_port_check_id(struct platform_device *pdev,
> > +                                    void *pport_id)
> > +{
> > +       return fpga_port_id(pdev) == *(int *)pport_id;
> > +}
> > +
> > +void __fpga_port_enable(struct platform_device *pdev);
> > +int __fpga_port_disable(struct platform_device *pdev);
> > +
> > +static inline void fpga_port_enable(struct platform_device *pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +
> > +       mutex_lock(&pdata->lock);
> > +       __fpga_port_enable(pdev);
> > +       mutex_unlock(&pdata->lock);
> > +}
> > +
> > +static inline int fpga_port_disable(struct platform_device *pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +       int ret;
> > +
> > +       mutex_lock(&pdata->lock);
> > +       ret = __fpga_port_disable(pdev);
> > +       mutex_unlock(&pdata->lock);
> > +
> > +       return ret;
> > +}
> > +
> > +/*
> > + * This function resets the FPGA Port and its accelerator (AFU) by function
> > + * __fpga_port_disable and __fpga_port_enable (set port soft reset bit and
> > + * then clear it). Userspace can do Port reset at any time, e.g during DMA
> > + * or Partial Reconfiguration. But it should never cause any system level
> > + * issue, only functional failure (e.g DMA or PR operation failure) and be
> > + * recoverable from the failure.
> > + *
> > + * Note: the accelerator (AFU) is not accessible when its port is in reset
> > + * (disabled). Any attempts on MMIO access to AFU while in reset, will
> > + * result errors reported via port error reporting sub feature (if present).
> > + */
> > +static inline int __fpga_port_reset(struct platform_device *pdev)
> > +{
> > +       int ret;
> > +
> > +       ret = __fpga_port_disable(pdev);
> > +       if (ret)
> > +               return ret;
> > +
> > +       __fpga_port_enable(pdev);
> > +
> > +       return 0;
> > +}
> > +
> > +static inline int fpga_port_reset(struct platform_device *pdev)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> > +       int ret;
> > +
> > +       mutex_lock(&pdata->lock);
> > +       ret = __fpga_port_reset(pdev);
> > +       mutex_unlock(&pdata->lock);
> > +
> > +       return ret;
> > +}
> 
> I'm still scratching my head about how the enumeration code also has
> code that handles resetting the PL in a FPGA region and
> enabling/disabling the bridge.  We've discussed this before [1] and I
> know you've looked into it, I'm still trying to figure out how this
> can be made modular, so when someone needs to support a different port
> in the future, it isn't a complete rewrite.
> 
> Speaking of resets, one way forward would be to create a reset
> controller for the port (and if possible move the port code to the
> bridge platform driver).  The current linux-next repo adds support for
> reset lookups, so that reset controllers are supported for non-DT
> platforms [2].
> 
> So the bridge driver would implement the enable/disable functions and
> create a reset controller, the fpga-region (or whoever else needs it)
> could look the reset controller and use the reset.  By using the
> kernel reset framework, we don't have to have that piece of code
> shared around by having a reset function in a .h file.  And it avoids
> adding extra dependencies between modules.  Also, where necessary, I'd
> rather add functionality to the existing bridge/mgr/region frameworks,
> adding common interfaces at that level to allow reuse (like adding
> status to fpga-mgr).  Ideally, this DFL framework would sit on top of
> mgr and bridge and allow those to be swapped out for reuse of the DFL
> framework on other devices.  Also it will save future headaches as mgr
> or port implementations evolve.

Thanks a lot for the suggestion. I really really appreciate this.

Actually if we consider the virutalization case as I mentioned in [1] below,
that means AFU and its Port will be turned into a PCI VF and assigned (passed
through) to a virtual machine. There is no FME block on that PCI VF device,
(the FME is always kept in PCI PF device in the host) and currently the bridge
is created by FME module for PR functionatily. So in the guest virtual machine,
nobody creates the reset controller actually.

As I mentioned in [1], one possible method is, put these port reset functions to
AFU (Port) module, and share those functions with FME bridge module. I think
that will make the code in the common DFL framework a little more clean, but it
will introduce some module dependency here for sure, (e.g FME modules can't
finish PR without AFU (Port) Module loaded). But anyway it may be still
acceptable for users as all these modules could be loaded automatically. How do
you think? :)

Thanks
Hao


> 
> Alan
> 
> [1] https://lkml.org/lkml/2017/12/22/398
> [2] https://patchwork.kernel.org/patch/10247475/
> 
> > +
> > +#define fpga_dev_for_each_feature(pdata, feature)                          \
> > +       for ((feature) = (pdata)->features;                                 \
> > +          (feature) < (pdata)->features + (pdata)->num; (feature)++)
> > +
> > +static inline struct feature *get_feature_by_id(struct device *dev, u64 id)
> > +{
> > +       struct feature_platform_data *pdata = dev_get_platdata(dev);
> > +       struct feature *feature;
> > +
> > +       fpga_dev_for_each_feature(pdata, feature)
> > +               if (feature->id == id)
> > +                       return feature;
> > +
> > +       return NULL;
> > +}
> > +
> > +static inline void __iomem *get_feature_ioaddr_by_id(struct device *dev, u64 id)
> > +{
> > +       struct feature *feature = get_feature_by_id(dev, id);
> > +
> > +       if (feature && feature->ioaddr)
> > +               return feature->ioaddr;
> > +
> > +       WARN_ON(1);
> > +       return NULL;
> > +}
> > +
> > +static inline bool feature_is_fme(void __iomem *base)
> > +{
> > +       u64 v = readq(base + DFH);
> > +
> > +       return (FIELD_GET(DFH_TYPE, v) == DFH_TYPE_FIU) &&
> > +               (FIELD_GET(DFH_ID, v) == DFH_ID_FIU_FME);
> > +}
> > +
> > +static inline bool feature_is_port(void __iomem *base)
> > +{
> > +       u64 v = readq(base + DFH);
> > +
> > +       return (FIELD_GET(DFH_TYPE, v) == DFH_TYPE_FIU) &&
> > +               (FIELD_GET(DFH_ID, v) == DFH_ID_FIU_PORT);
> > +}
> > +
> > +/**
> > + * struct fpga_enum_info - FPGA enumeration information
> > + *
> > + * @dev: parent device.
> > + * @dfls: list of device feature lists.
> > + */
> > +struct fpga_enum_info {
> > +       struct device *dev;
> > +       struct list_head dfls;
> > +};
> > +
> > +/**
> > + * struct fpga_enum_dfl - FPGA enumeration device feature list information
> > + *
> > + * @start: base address of this device feature list.
> > + * @len: size of this device feature list.
> > + * @ioaddr: mapped base address of this device feature list.
> > + * @node: node in list of device feature lists.
> > + */
> > +struct fpga_enum_dfl {
> > +       resource_size_t start;
> > +       resource_size_t len;
> > +
> > +       void __iomem *ioaddr;
> > +
> > +       struct list_head node;
> > +};
> > +
> > +struct fpga_enum_info *fpga_enum_info_alloc(struct device *dev);
> > +int fpga_enum_info_add_dfl(struct fpga_enum_info *info, resource_size_t start,
> > +                          resource_size_t len, void __iomem *ioaddr);
> > +void fpga_enum_info_free(struct fpga_enum_info *info);
> > +
> > +/**
> > + * struct fpga_cdev - fpga container device
> > + *
> > + * @parent: parent device of this container device.
> > + * @region: base fpga region.
> > + * @fme_dev: FME feature device under this container device.
> > + * @lock: mutex lock to protect the port device list.
> > + * @port_dev_list: list of all port feature devices under this container device.
> > + */
> > +struct fpga_cdev {
> > +       struct device *parent;
> > +
> > +       struct fpga_region region;
> > +
> > +       struct device *fme_dev;
> > +
> > +       struct mutex lock; /* to protect the port device list */
> > +       struct list_head port_dev_list;
> > +};
> > +
> > +struct fpga_cdev *fpga_enumerate_feature_devs(struct fpga_enum_info *info);
> > +void fpga_remove_feature_devs(struct fpga_cdev *cdev);
> > +
> > +#endif /* __FPGA_DFL_H */
> > --
> > 2.7.4
> >
