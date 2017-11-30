From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v3 04/21] fpga: add device feature list support
Date: Thu, 30 Nov 2017 13:59:19 +0800
Message-ID: <20171130055919.GA497@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-5-git-send-email-hao.wu@intel.com>
 <20171129060736.2moyxthn72yxtogh@us-aus-ras-130-164-29-6.amer.corp.natinst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171129060736.2moyxthn72yxtogh@us-aus-ras-130-164-29-6.amer.corp.natinst.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: atull@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 28, 2017 at 10:07:36PM -0800, Moritz Fischer wrote:
> Hi Hao,
> 
> first pass, I didn't get all the way through, yet.

Hi Moritz

Thanks a lot for your review and comments. :)

> 
> On Mon, Nov 27, 2017 at 02:42:11PM +0800, Wu Hao wrote:
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
> > 
> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > ----
> > v3: split from another patch.
> >     separate dfl enumeration code from original pcie driver.
> >     provide common data structures and APIs for enumeration.
> >     update device feature list parsing process according to latest hw.
> >     add dperf/iperf/hssi sub feature placeholder according to latest hw.
> >     remove build_info_add_sub_feature and other small functions.
> >     replace *_feature_num function with macro.
> >     remove writeq/readq.
> > ---
> >  drivers/fpga/Kconfig    |  16 +
> >  drivers/fpga/Makefile   |   3 +
> >  drivers/fpga/fpga-dfl.c | 884 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/fpga/fpga-dfl.h | 365 ++++++++++++++++++++
> >  4 files changed, 1268 insertions(+)
> >  create mode 100644 drivers/fpga/fpga-dfl.c
> >  create mode 100644 drivers/fpga/fpga-dfl.h
> > 
> > diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> > index f47ef84..01ad31f 100644
> > --- a/drivers/fpga/Kconfig
> > +++ b/drivers/fpga/Kconfig
> > @@ -124,4 +124,20 @@ config OF_FPGA_REGION
> >  	  Support for loading FPGA images by applying a Device Tree
> >  	  overlay.
> >  
> > +config FPGA_DFL
> > +	tristate "FPGA Device Feature List (DFL) support"
> > +	select FPGA_BRIDGE
> > +	select FPGA_REGION
> > +	help
> > +	  Device Feature List (DFL) defines a feature list structure that
> > +	  creates a link list of feature headers within the MMIO space
> > +	  to provide an extensible way of adding features for FPGA.
> > +	  Driver can walk through the feature headers to enumerate feature
> > +	  devices (e.g FPGA Management Engine, Port and Accelerator
> > +	  Function Unit) and their private features for target FPGA devices.
> > +
> > +	  Select this option to enable common support for Field-Programmable
> > +	  Gate Array (FPGA) solutions which implement Device Feature List.
> > +	  It provides enumeration APIs, and feature device infrastructure.
> > +
> >  endif # FPGA
> > diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> > index 3cb276a..447ba2b 100644
> > --- a/drivers/fpga/Makefile
> > +++ b/drivers/fpga/Makefile
> > @@ -27,3 +27,6 @@ obj-$(CONFIG_XILINX_PR_DECOUPLER)	+= xilinx-pr-decoupler.o
> >  # High Level Interfaces
> >  obj-$(CONFIG_FPGA_REGION)		+= fpga-region.o
> >  obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
> > +
> > +# FPGA Device Feature List Support
> > +obj-$(CONFIG_FPGA_DFL)			+= fpga-dfl.o
> > diff --git a/drivers/fpga/fpga-dfl.c b/drivers/fpga/fpga-dfl.c
> > new file mode 100644
> > index 0000000..6609828
> > --- /dev/null
> > +++ b/drivers/fpga/fpga-dfl.c
> > @@ -0,0 +1,884 @@
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
> > + *
> > + * This work is licensed under the terms of the GNU GPL version 2.
> 
> This is redundant.
> > + * SPDX-License-Identifier: GPL-2.0
> 
> Also I think the current consensus is that this should go in the first
> line

Sure, I will put this SPDX-License-Identifier to the first line and remove
the redundant line above.

> > + */
> > +#include <linux/module.h>
> > +
> > +#include "fpga-dfl.h"
> > +
> > +static DEFINE_MUTEX(fpga_id_mutex);
> > +
> > +enum fpga_id_type {
> > +	FME_ID,		/* fme id allocation and mapping */
> > +	PORT_ID,	/* port id allocation and mapping */
> > +	FPGA_ID_MAX,
> > +};
> > +
> > +/* it is protected by fpga_id_mutex */
> > +static struct idr fpga_ids[FPGA_ID_MAX];
> > +
> > +static void fpga_ids_init(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(fpga_ids); i++)
> > +		idr_init(fpga_ids + i);
> > +}
> > +
> > +static void fpga_ids_destroy(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(fpga_ids); i++)
> > +		idr_destroy(fpga_ids + i);
> > +}
> > +
> > +static int alloc_fpga_id(enum fpga_id_type type, struct device *dev)
> > +{
> > +	int id;
> > +
> > +	WARN_ON(type >= FPGA_ID_MAX);
> > +	mutex_lock(&fpga_id_mutex);
> > +	id = idr_alloc(fpga_ids + type, dev, 0, 0, GFP_KERNEL);
> > +	mutex_unlock(&fpga_id_mutex);
> > +
> > +	return id;
> > +}
> > +
> > +static void free_fpga_id(enum fpga_id_type type, int id)
> > +{
> > +	WARN_ON(type >= FPGA_ID_MAX);
> > +	mutex_lock(&fpga_id_mutex);
> > +	idr_remove(fpga_ids + type, id);
> > +	mutex_unlock(&fpga_id_mutex);
> > +}
> > +
> > +static enum fpga_id_type feature_dev_id_type(struct platform_device *pdev)
> > +{
> > +	if (!strcmp(pdev->name, FPGA_FEATURE_DEV_FME))
> > +		return FME_ID;
> > +
> > +	if (!strcmp(pdev->name, FPGA_FEATURE_DEV_PORT))
> > +		return PORT_ID;
> > +
> > +	WARN_ON(1);
> 
> Do we really need a WARN_ON() here? Wouldn't returning an error be
> nicer?

Actually this is a static function only used in this file, and ideally
enumeration code will only create feature devices for FME and PORT.
So ideally there couldn't be any feature device with other names, only FME
and PORT.  WARN_ON(1) is used here, to just be a warning that there could
be a critical driver problem somewhere and return FPGA_ID_MAX as error code
which will never be used as an id for any feature device.

> > +
> > +	return FPGA_ID_MAX;
> > +}
> > +
> > +/**
> > + * build_feature_devs_info - info collected during feature dev build.
> > + *
> > + * @dev: device to enumerate.
> > + * @cdev: the container device for all feature devices.
> > + * @feature_dev: current feature device.
> > + */
> > +struct build_feature_devs_info {
> > +	struct device *dev;
> > +	struct fpga_cdev *cdev;
> > +	struct platform_device *feature_dev;
> > +};
> > +
> > +static void fpga_cdev_add_port_dev(struct fpga_cdev *cdev,
> > +				   struct platform_device *port_pdev)
> > +{
> > +	struct feature_platform_data *pdata = dev_get_platdata(&port_pdev->dev);
> > +
> > +	mutex_lock(&cdev->lock);
> > +	list_add(&pdata->node, &cdev->port_dev_list);
> > +	get_device(&pdata->dev->dev);
> > +	mutex_unlock(&cdev->lock);
> > +}
> > +
> > +/*
> > + * register current feature device, it is called when we need to switch to
> > + * another feature parsing or we have parsed all features on given device
> > + * feature list.
> > + */
> > +static int build_info_commit_dev(struct build_feature_devs_info *binfo)
> > +{
> > +	int ret;
> > +
> > +	if (!binfo->feature_dev)
> > +		return 0;
> > +
> > +	ret = platform_device_add(binfo->feature_dev);
> > +	if (!ret) {
> > +		if (feature_dev_id_type(binfo->feature_dev) == PORT_ID)
> > +			fpga_cdev_add_port_dev(binfo->cdev, binfo->feature_dev);
> > +		else
> 
> So if you get back FPGA_ID_MAX, it is automatically a fme_dev?

If FPGA_ID_MAX returned, there would be a WARN_ON(1) triggered, so we get
notified there would be a critical driver issue somewhere, needs to be fixed
firstly.

In normal driver flow, we should never see FPGA_ID_MAX returned and the
WARN_ON(1). :)

> > +			binfo->cdev->fme_dev =
> > +					get_device(&binfo->feature_dev->dev);
> > +		/*
> > +		 * reset it to avoid build_info_free() freeing their resource.
> > +		 *
> > +		 * The resource of successfully registered feature devices
> > +		 * will be freed by platform_device_unregister(). See the
> > +		 * comments in build_info_create_dev().
> > +		 */
> > +		binfo->feature_dev = NULL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> > +build_info_create_dev(struct build_feature_devs_info *binfo,
> > +		      enum fpga_id_type type, int feature_nr, const char *name)
> > +{
> > +	struct platform_device *fdev;
> > +	struct resource *res;
> > +	struct feature_platform_data *pdata;
> > +	int ret;
> > +
> > +	/* we will create a new device, commit current device first */
> > +	ret = build_info_commit_dev(binfo);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * we use -ENODEV as the initialization indicator which indicates
> > +	 * whether the id need to be reclaimed
> > +	 */
> > +	fdev = platform_device_alloc(name, -ENODEV);
> > +	if (!fdev)
> > +		return -ENOMEM;
> > +
> > +	binfo->feature_dev = fdev;
> > +
> > +	fdev->id = alloc_fpga_id(type, &fdev->dev);
> > +	if (fdev->id < 0)
> > +		return fdev->id;
> > +
> > +	fdev->dev.parent = &binfo->cdev->region.dev;
> > +
> > +	/*
> > +	 * we do not need to care for the memory which is associated with
> > +	 * the platform device. After calling platform_device_unregister(),
> > +	 * it will be automatically freed by device's release() callback,
> > +	 * platform_device_release().
> > +	 */
> > +	pdata = kzalloc(feature_platform_data_size(feature_nr), GFP_KERNEL);
> > +	if (pdata) {
> > +		pdata->dev = fdev;
> > +		pdata->num = feature_nr;
> > +		mutex_init(&pdata->lock);
> > +	} else {
> > +		return -ENOMEM;
> Does this path clean up fdev->id? Does that happen in
> platform_device_release() ?

This patch cleans up fdev->id manually, as platform_device_release can't
cover this. There are two cases, we have to clean up the fdev->id.

1) error found during enumeration (fdev is not registered yet), just like
above case, return -ENOMEM, and finally it causes parse_feature_list
function to return error code, and fdev->id will be cleaned up by
build_info_free function. (only platform_device_put required as
platform_device_add is not invoked yet).

2) normal clean up flow with registered fdev. Then fdev->id will be
cleaned up by remove_feature_dev function. (platform_device_unregister
will be used in this case). :)

Thanks
Hao
