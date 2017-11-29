From: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/21] fpga: add device feature list support
Date: Tue, 28 Nov 2017 22:07:36 -0800
Message-ID: <20171129060736.2moyxthn72yxtogh@us-aus-ras-130-164-29-6.amer.corp.natinst.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-5-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511764948-20972-5-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Hao,

first pass, I didn't get all the way through, yet.

On Mon, Nov 27, 2017 at 02:42:11PM +0800, Wu Hao wrote:
> Device Feature List (DFL) defines a feature list structure that creates
> a link list of feature headers within the MMIO space to provide an
> extensible way of adding features. This patch introduces a kernel module
> to provide basic infrastructure to support FPGA devices which implement
> the Device Feature List.
> 
> Usually there will be different features and their sub features linked into
> the DFL. This code provides common APIs for feature enumeration, it creates
> a container device (FPGA base region), walks through the DFLs and creates
> platform devices for feature devices (Currently it only supports two
> different feature devices, FPGA Management Engine (FME) and Port which
> the Accelerator Function Unit (AFU) connected to). In order to enumerate
> the DFLs, the common APIs required low level driver to provide necessary
> enumeration information (e.g address for each device feature list for
> given device) and fill it to the fpga_enum_info data structure. Please
> refer to below description for APIs added for enumeration.
> 
> Functions for enumeration information preparation:
>  *fpga_enum_info_alloc
>    allocate enumeration information data structure.
> 
>  *fpga_enum_info_add_dfl
>    add a device feature list to fpga_enum_info data structure.
> 
>  *fpga_enum_info_free
>    free fpga_enum_info data structure and related resources.
> 
> Functions for feature device enumeration:
>  *fpga_enumerate_feature_devs
>    enumerate feature devices and return container device.
> 
>  *fpga_remove_feature_devs
>    remove feature devices under given container device.
> 
> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ----
> v3: split from another patch.
>     separate dfl enumeration code from original pcie driver.
>     provide common data structures and APIs for enumeration.
>     update device feature list parsing process according to latest hw.
>     add dperf/iperf/hssi sub feature placeholder according to latest hw.
>     remove build_info_add_sub_feature and other small functions.
>     replace *_feature_num function with macro.
>     remove writeq/readq.
> ---
>  drivers/fpga/Kconfig    |  16 +
>  drivers/fpga/Makefile   |   3 +
>  drivers/fpga/fpga-dfl.c | 884 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/fpga/fpga-dfl.h | 365 ++++++++++++++++++++
>  4 files changed, 1268 insertions(+)
>  create mode 100644 drivers/fpga/fpga-dfl.c
>  create mode 100644 drivers/fpga/fpga-dfl.h
> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index f47ef84..01ad31f 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -124,4 +124,20 @@ config OF_FPGA_REGION
>  	  Support for loading FPGA images by applying a Device Tree
>  	  overlay.
>  
> +config FPGA_DFL
> +	tristate "FPGA Device Feature List (DFL) support"
> +	select FPGA_BRIDGE
> +	select FPGA_REGION
> +	help
> +	  Device Feature List (DFL) defines a feature list structure that
> +	  creates a link list of feature headers within the MMIO space
> +	  to provide an extensible way of adding features for FPGA.
> +	  Driver can walk through the feature headers to enumerate feature
> +	  devices (e.g FPGA Management Engine, Port and Accelerator
> +	  Function Unit) and their private features for target FPGA devices.
> +
> +	  Select this option to enable common support for Field-Programmable
> +	  Gate Array (FPGA) solutions which implement Device Feature List.
> +	  It provides enumeration APIs, and feature device infrastructure.
> +
>  endif # FPGA
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> index 3cb276a..447ba2b 100644
> --- a/drivers/fpga/Makefile
> +++ b/drivers/fpga/Makefile
> @@ -27,3 +27,6 @@ obj-$(CONFIG_XILINX_PR_DECOUPLER)	+= xilinx-pr-decoupler.o
>  # High Level Interfaces
>  obj-$(CONFIG_FPGA_REGION)		+= fpga-region.o
>  obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
> +
> +# FPGA Device Feature List Support
> +obj-$(CONFIG_FPGA_DFL)			+= fpga-dfl.o
> diff --git a/drivers/fpga/fpga-dfl.c b/drivers/fpga/fpga-dfl.c
> new file mode 100644
> index 0000000..6609828
> --- /dev/null
> +++ b/drivers/fpga/fpga-dfl.c
> @@ -0,0 +1,884 @@
> +/*
> + * Driver for FPGA Device Feature List (DFL) Support
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * Authors:
> + *   Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> + *
> + * This work is licensed under the terms of the GNU GPL version 2.

This is redundant.
> + * SPDX-License-Identifier: GPL-2.0

Also I think the current consensus is that this should go in the first
line
> + */
> +#include <linux/module.h>
> +
> +#include "fpga-dfl.h"
> +
> +static DEFINE_MUTEX(fpga_id_mutex);
> +
> +enum fpga_id_type {
> +	FME_ID,		/* fme id allocation and mapping */
> +	PORT_ID,	/* port id allocation and mapping */
> +	FPGA_ID_MAX,
> +};
> +
> +/* it is protected by fpga_id_mutex */
> +static struct idr fpga_ids[FPGA_ID_MAX];
> +
> +static void fpga_ids_init(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fpga_ids); i++)
> +		idr_init(fpga_ids + i);
> +}
> +
> +static void fpga_ids_destroy(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fpga_ids); i++)
> +		idr_destroy(fpga_ids + i);
> +}
> +
> +static int alloc_fpga_id(enum fpga_id_type type, struct device *dev)
> +{
> +	int id;
> +
> +	WARN_ON(type >= FPGA_ID_MAX);
> +	mutex_lock(&fpga_id_mutex);
> +	id = idr_alloc(fpga_ids + type, dev, 0, 0, GFP_KERNEL);
> +	mutex_unlock(&fpga_id_mutex);
> +
> +	return id;
> +}
> +
> +static void free_fpga_id(enum fpga_id_type type, int id)
> +{
> +	WARN_ON(type >= FPGA_ID_MAX);
> +	mutex_lock(&fpga_id_mutex);
> +	idr_remove(fpga_ids + type, id);
> +	mutex_unlock(&fpga_id_mutex);
> +}
> +
> +static enum fpga_id_type feature_dev_id_type(struct platform_device *pdev)
> +{
> +	if (!strcmp(pdev->name, FPGA_FEATURE_DEV_FME))
> +		return FME_ID;
> +
> +	if (!strcmp(pdev->name, FPGA_FEATURE_DEV_PORT))
> +		return PORT_ID;
> +
> +	WARN_ON(1);

Do we really need a WARN_ON() here? Wouldn't returning an error be
nicer?
> +
> +	return FPGA_ID_MAX;
> +}
> +
> +/**
> + * build_feature_devs_info - info collected during feature dev build.
> + *
> + * @dev: device to enumerate.
> + * @cdev: the container device for all feature devices.
> + * @feature_dev: current feature device.
> + */
> +struct build_feature_devs_info {
> +	struct device *dev;
> +	struct fpga_cdev *cdev;
> +	struct platform_device *feature_dev;
> +};
> +
> +static void fpga_cdev_add_port_dev(struct fpga_cdev *cdev,
> +				   struct platform_device *port_pdev)
> +{
> +	struct feature_platform_data *pdata = dev_get_platdata(&port_pdev->dev);
> +
> +	mutex_lock(&cdev->lock);
> +	list_add(&pdata->node, &cdev->port_dev_list);
> +	get_device(&pdata->dev->dev);
> +	mutex_unlock(&cdev->lock);
> +}
> +
> +/*
> + * register current feature device, it is called when we need to switch to
> + * another feature parsing or we have parsed all features on given device
> + * feature list.
> + */
> +static int build_info_commit_dev(struct build_feature_devs_info *binfo)
> +{
> +	int ret;
> +
> +	if (!binfo->feature_dev)
> +		return 0;
> +
> +	ret = platform_device_add(binfo->feature_dev);
> +	if (!ret) {
> +		if (feature_dev_id_type(binfo->feature_dev) == PORT_ID)
> +			fpga_cdev_add_port_dev(binfo->cdev, binfo->feature_dev);
> +		else

So if you get back FPGA_ID_MAX, it is automatically a fme_dev?
> +			binfo->cdev->fme_dev =
> +					get_device(&binfo->feature_dev->dev);
> +		/*
> +		 * reset it to avoid build_info_free() freeing their resource.
> +		 *
> +		 * The resource of successfully registered feature devices
> +		 * will be freed by platform_device_unregister(). See the
> +		 * comments in build_info_create_dev().
> +		 */
> +		binfo->feature_dev = NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int
> +build_info_create_dev(struct build_feature_devs_info *binfo,
> +		      enum fpga_id_type type, int feature_nr, const char *name)
> +{
> +	struct platform_device *fdev;
> +	struct resource *res;
> +	struct feature_platform_data *pdata;
> +	int ret;
> +
> +	/* we will create a new device, commit current device first */
> +	ret = build_info_commit_dev(binfo);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * we use -ENODEV as the initialization indicator which indicates
> +	 * whether the id need to be reclaimed
> +	 */
> +	fdev = platform_device_alloc(name, -ENODEV);
> +	if (!fdev)
> +		return -ENOMEM;
> +
> +	binfo->feature_dev = fdev;
> +
> +	fdev->id = alloc_fpga_id(type, &fdev->dev);
> +	if (fdev->id < 0)
> +		return fdev->id;
> +
> +	fdev->dev.parent = &binfo->cdev->region.dev;
> +
> +	/*
> +	 * we do not need to care for the memory which is associated with
> +	 * the platform device. After calling platform_device_unregister(),
> +	 * it will be automatically freed by device's release() callback,
> +	 * platform_device_release().
> +	 */
> +	pdata = kzalloc(feature_platform_data_size(feature_nr), GFP_KERNEL);
> +	if (pdata) {
> +		pdata->dev = fdev;
> +		pdata->num = feature_nr;
> +		mutex_init(&pdata->lock);
> +	} else {
> +		return -ENOMEM;
Does this path clean up fdev->id? Does that happen in
platform_device_release() ?
> +	}
> +
> +	/*
> +	 * the count should be initialized to 0 to make sure
> +	 *__fpga_port_enable() following __fpga_port_disable()
> +	 * works properly for port device.
> +	 * and it should always be 0 for fme device.
> +	 */
> +	WARN_ON(pdata->disable_count);
> +
> +	fdev->dev.platform_data = pdata;
> +	fdev->num_resources = feature_nr;
> +	fdev->resource = kcalloc(feature_nr, sizeof(*res), GFP_KERNEL);
> +	if (!fdev->resource)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static void build_info_free(struct build_feature_devs_info *binfo)
> +{
> +	/*
> +	 * it is a valid id, free it. See comments in
> +	 * build_info_create_dev()
> +	 */
> +	if (binfo->feature_dev && binfo->feature_dev->id >= 0)
> +		free_fpga_id(feature_dev_id_type(binfo->feature_dev),
> +			     binfo->feature_dev->id);
> +
> +	platform_device_put(binfo->feature_dev);
> +
> +	devm_kfree(binfo->dev, binfo);
> +}
> +
> +/*
> + * UAFU GUID is dynamic as it can be changed after FME downloads different
> + * Green Bitstream to the port, so we treat the unknown GUIDs which are
> + * attached on port's feature list as UAFU.
> + */
> +static bool feature_is_UAFU(struct build_feature_devs_info *binfo)
> +{
> +	if (!binfo->feature_dev ||
> +	    feature_dev_id_type(binfo->feature_dev) != PORT_ID)
> +		return false;
> +
> +	return true;
> +}
> +
> +struct feature_info {
> +	const char *name;
> +	resource_size_t resource_size;
> +	int feature_index;
> +};
> +
> +/* indexed by fme feature IDs which are defined in 'enum fme_feature_id'. */
> +static struct feature_info fme_features[] = {
> +	{
> +		.name = FME_FEATURE_HEADER,
> +		.resource_size = FME_HDR_SIZE,
> +		.feature_index = FME_FEATURE_ID_HEADER,
> +	},
> +	{
> +		.name = FME_FEATURE_THERMAL_MGMT,
> +		.resource_size = FME_THERMAL_SIZE,
> +		.feature_index = FME_FEATURE_ID_THERMAL_MGMT,
> +	},
> +	{
> +		.name = FME_FEATURE_POWER_MGMT,
> +		.resource_size = FME_POWER_SIZE,
> +		.feature_index = FME_FEATURE_ID_POWER_MGMT,
> +	},
> +	{
> +		.name = FME_FEATURE_GLOBAL_IPERF,
> +		.resource_size = FME_IPERF_SIZE,
> +		.feature_index = FME_FEATURE_ID_GLOBAL_IPERF,
> +	},
> +	{
> +		.name = FME_FEATURE_GLOBAL_ERR,
> +		.resource_size = FME_ERR_SIZE,
> +		.feature_index = FME_FEATURE_ID_GLOBAL_ERR,
> +	},
> +	{
> +		.name = FME_FEATURE_PR_MGMT,
> +		.resource_size = FME_PR_SIZE,
> +		.feature_index = FME_FEATURE_ID_PR_MGMT,
> +	},
> +	{
> +		.name = FME_FEATURE_HSSI,
> +		.resource_size = FME_HSSI_SIZE,
> +		.feature_index = FME_FEATURE_ID_HSSI,
> +	},
> +	{
> +		.name = FME_FEATURE_GLOBAL_DPERF,
> +		.resource_size = FME_DPERF_SIZE,
> +		.feature_index = FME_FEATURE_ID_GLOBAL_DPERF,
> +	},
> +};
> +
> +/* indexed by port feature IDs which are defined in 'enum port_feature_id'. */
> +static struct feature_info port_features[] = {
> +	{
> +		.name = PORT_FEATURE_HEADER,
> +		.resource_size = PORT_HDR_SIZE,
> +		.feature_index = PORT_FEATURE_ID_HEADER,
> +	},
> +	{
> +		.name = PORT_FEATURE_ERR,
> +		.resource_size = PORT_ERR_SIZE,
> +		.feature_index = PORT_FEATURE_ID_ERROR,
> +	},
> +	{
> +		.name = PORT_FEATURE_UMSG,
> +		.resource_size = PORT_UMSG_SIZE,
> +		.feature_index = PORT_FEATURE_ID_UMSG,
> +	},
> +	{
> +		/* This feature isn't available for now */
> +		.name = PORT_FEATURE_PR,
> +		.resource_size = DFH_SIZE,
> +		.feature_index = PORT_FEATURE_ID_PR,
> +	},
> +	{
> +		.name = PORT_FEATURE_STP,
> +		.resource_size = PORT_STP_SIZE,
> +		.feature_index = PORT_FEATURE_ID_STP,
> +	},
> +	{
> +		/*
> +		 * For User AFU feature, its region size is not fixed, but
> +		 * reported by register PortCapability.mmio_size. Resource
> +		 * size of UAFU will be set while parse port device.
> +		 */
> +		.name = PORT_FEATURE_UAFU,
> +		.resource_size = 0,
> +		.feature_index = PORT_FEATURE_ID_UAFU,
> +	},
> +};
> +
> +static int
> +create_feature_instance(struct build_feature_devs_info *binfo,
> +			struct fpga_enum_dfl *dfl, resource_size_t ofst,
> +			struct feature_info *finfo)
> +{
> +	int index = finfo->feature_index;
> +	struct platform_device *fdev = binfo->feature_dev;
> +	struct feature_platform_data *pdata = dev_get_platdata(&fdev->dev);
> +	struct resource *res = &fdev->resource[index];
> +
> +	if ((dfl->len - ofst < finfo->resource_size) || pdata->num < index)
> +		return -EINVAL;
> +
> +	res->start = dfl->start + ofst;
> +	res->end = res->start + finfo->resource_size - 1;
> +	res->flags = IORESOURCE_MEM;
> +	res->name = finfo->name;
> +
> +	pdata->features[index].name = finfo->name;
> +	pdata->features[index].resource_index = index;
> +	pdata->features[index].ioaddr = dfl->ioaddr + ofst;
> +
> +	return 0;
> +}
> +
> +static int parse_feature_fme(struct build_feature_devs_info *binfo,
> +			     struct fpga_enum_dfl *dfl,
> +			     resource_size_t ofst)
> +{
> +	int ret;
> +
> +	ret = build_info_create_dev(binfo, FME_ID, FME_FEATURE_NUM,
> +				    FPGA_FEATURE_DEV_FME);
> +	if (ret)
> +		return ret;
> +
> +	return create_feature_instance(binfo, dfl, ofst,
> +				       &fme_features[FME_FEATURE_ID_HEADER]);
> +}
> +
> +static int parse_feature_fme_private(struct build_feature_devs_info *binfo,
> +				     struct fpga_enum_dfl *dfl,
> +				     resource_size_t ofst)
> +{
> +	u64 v;
> +	int id;
> +
> +	v = readq(dfl->ioaddr + ofst + DFH);
> +	id = FIELD_GET(DFH_ID, v);
> +
> +	if (id >= ARRAY_SIZE(fme_features)) {
> +		dev_info(binfo->dev, "FME feature id %x is not supported yet.\n",
> +			 id);
> +		return 0;
> +	}
> +
> +	return create_feature_instance(binfo, dfl, ofst, &fme_features[id]);
> +}
> +
> +static int parse_feature_port(struct build_feature_devs_info *binfo,
> +			      struct fpga_enum_dfl *dfl,
> +			      resource_size_t ofst)
> +{
> +	int ret;
> +
> +	ret = build_info_create_dev(binfo, PORT_ID, PORT_FEATURE_NUM,
> +				    FPGA_FEATURE_DEV_PORT);
> +	if (ret)
> +		return ret;
> +
> +	return create_feature_instance(binfo, dfl, ofst,
> +				       &port_features[PORT_FEATURE_ID_HEADER]);
> +}
> +
> +static void enable_port_uafu(struct build_feature_devs_info *binfo)
> +{
> +	enum port_feature_id id = PORT_FEATURE_ID_UAFU;
> +	void __iomem *base;
> +	u64 v;
> +
> +	base = get_feature_ioaddr_by_index(&binfo->feature_dev->dev,
> +					   PORT_FEATURE_ID_HEADER);
> +
> +	v = readq(base + PORT_HDR_CAP);
> +	port_features[id].resource_size =
> +			FIELD_GET(PORT_CAP_MMIO_SIZE, v) << 10;
> +
> +	/*
> +	 * To enable User AFU, driver needs to clear reset bit on related port,
> +	 * otherwise the mmio space of this user AFU will be invalid.
> +	 */
> +	if (port_features[id].resource_size)
> +		fpga_port_reset(binfo->feature_dev);
> +}
> +
> +static int parse_feature_port_private(struct build_feature_devs_info *binfo,
> +				      struct fpga_enum_dfl *dfl,
> +				      resource_size_t ofst)
> +{
> +	enum port_feature_id id;
> +	u32 dfh_id;
> +	u64 v;
> +
> +	v = readq(dfl->ioaddr + ofst + DFH);
> +	dfh_id = FIELD_GET(DFH_ID, v);
> +
> +	/*
> +	 * the region of port feature id is [0x10, 0x13], + 1 to reserve 0
> +	 * which is dedicated for port-hdr.
> +	 */
> +	id = (dfh_id & 0x000f) + 1;
> +
> +	if (id >= ARRAY_SIZE(port_features)) {
> +		dev_info(binfo->dev, "Port feature id %x is not supported yet.\n",
> +			 dfh_id);
> +		return 0;
> +	}
> +
> +	return create_feature_instance(binfo, dfl, ofst, &port_features[id]);
> +}
> +
> +static int parse_feature_port_uafu(struct build_feature_devs_info *binfo,
> +				   struct fpga_enum_dfl *dfl,
> +				   resource_size_t ofst)
> +{
> +	enum port_feature_id id = PORT_FEATURE_ID_UAFU;
> +	int ret;
> +
> +	if (port_features[id].resource_size) {
> +		ret = create_feature_instance(binfo, dfl, ofst,
> +					      &port_features[id]);
> +		port_features[id].resource_size = 0;
> +	} else {
> +		dev_err(binfo->dev, "the uafu feature header is mis-configured.\n");
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int parse_feature_afus(struct build_feature_devs_info *binfo,
> +			      struct fpga_enum_dfl *dfl,
> +			      resource_size_t ofst)
> +{
> +	void __iomem *start = dfl->ioaddr + ofst;
> +	void __iomem *end = dfl->ioaddr + dfl->len;
> +	u32 offset;
> +	u64 v;
> +	int ret;
> +
> +	for (; start < end; start += offset) {
> +		if (end - start < AFU_DFH_SIZE)
> +			return -EINVAL;
> +
> +		if (feature_is_UAFU(binfo))
> +			ret = parse_feature_port_uafu(binfo, dfl,
> +						      start - dfl->ioaddr);
> +			if (ret)
> +				return ret;
> +
> +		v = readq(start + NEXT_AFU);
> +
> +		offset = FIELD_GET(NEXT_AFU_NEXT_DFH_OFST, v);
> +		if (!offset)
> +			break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int parse_feature_fiu(struct build_feature_devs_info *binfo,
> +			     struct fpga_enum_dfl *dfl,
> +			     resource_size_t ofst)
> +{
> +	u32 id, offset;
> +	u64 v;
> +	int ret = 0;
> +
> +	v = readq(dfl->ioaddr + ofst + DFH);
> +	id = FIELD_GET(DFH_ID, v);
> +
> +	switch (id) {
> +	case DFH_ID_FIU_FME:
> +		return parse_feature_fme(binfo, dfl, ofst);
> +	case DFH_ID_FIU_PORT:
> +		ret = parse_feature_port(binfo, dfl, ofst);
> +		enable_port_uafu(binfo);
> +		if (ret)
> +			return ret;
> +
> +		/* Check Port FIU's next_afu pointer to User AFU DFH */
> +		v = readq(dfl->ioaddr + ofst + NEXT_AFU);
> +
> +		offset = FIELD_GET(NEXT_AFU_NEXT_DFH_OFST, v);
> +		if (offset)
> +			return parse_feature_afus(binfo, dfl, ofst + offset);
> +
> +		dev_dbg(binfo->dev, "No AFUs detected on Port\n");
> +		break;
> +	default:
> +		dev_info(binfo->dev, "FIU TYPE %d is not supported yet.\n",
> +			 id);
> +	}
> +
> +	return ret;
> +}
> +
> +static int parse_feature_private(struct build_feature_devs_info *binfo,
> +				 struct fpga_enum_dfl *dfl,
> +				 resource_size_t ofst)
> +{
> +	u64 v;
> +	u32 id;
> +
> +	v = readq(dfl->ioaddr + ofst + DFH);
> +	id = FIELD_GET(DFH_ID, v);
> +
> +	if (!binfo->feature_dev) {
> +		dev_err(binfo->dev, "the private feature %x does not belong to any AFU.\n",
> +			id);
> +		return -EINVAL;
> +	}
> +
> +	switch (feature_dev_id_type(binfo->feature_dev)) {
> +	case FME_ID:
> +		return parse_feature_fme_private(binfo, dfl, ofst);
> +	case PORT_ID:
> +		return parse_feature_port_private(binfo, dfl, ofst);
> +	default:
> +		dev_info(binfo->dev, "private feature %x belonging to AFU %s is not supported yet.\n",
> +			 id, binfo->feature_dev->name);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * parse_feature - parse a feature on given device feature list
> + *
> + * @binfo: build feature devices information.
> + * @dfl: device feature list to parse
> + * @ofst: offset to feature header on this device feature list
> + */
> +static int parse_feature(struct build_feature_devs_info *binfo,
> +			 struct fpga_enum_dfl *dfl, resource_size_t ofst)
> +{
> +	u64 v;
> +	u32 type;
> +
> +	v = readq(dfl->ioaddr + ofst + DFH);
> +	type = FIELD_GET(DFH_TYPE, v);
> +
> +	switch (type) {
> +	case DFH_TYPE_AFU:
> +		return parse_feature_afus(binfo, dfl, ofst);
> +	case DFH_TYPE_PRIVATE:
> +		return parse_feature_private(binfo, dfl, ofst);
> +	case DFH_TYPE_FIU:
> +		return parse_feature_fiu(binfo, dfl, ofst);
> +	default:
> +		dev_info(binfo->dev,
> +			 "Feature Type %x is not supported.\n", type);
> +	}
> +
> +	return 0;
> +}
> +
> +static int parse_feature_list(struct build_feature_devs_info *binfo,
> +			      struct fpga_enum_dfl *dfl)
> +{
> +	void __iomem *start = dfl->ioaddr;
> +	void __iomem *end = dfl->ioaddr + dfl->len;
> +	int ret = 0;
> +	u32 ofst = 0;
> +	u64 v;
> +
> +	/* walk through the device feature list via DFH's next DFH pointer. */
> +	for (; start < end; start += ofst) {
> +		if (end - start < DFH_SIZE) {
> +			dev_err(binfo->dev, "The region is too small to contain a feature.\n");
> +			return -EINVAL;
> +		}
> +
> +		ret = parse_feature(binfo, dfl, start - dfl->ioaddr);
> +		if (ret)
> +			return ret;
> +
> +		v = readq(start + DFH);
> +		ofst = FIELD_GET(DFH_NEXT_HDR_OFST, v);
> +
> +		/* stop parsing if EOL(End of List) is set or offset is 0 */
> +		if ((v & DFH_EOL) || !ofst)
> +			break;
> +	}
> +
> +	/* commit current feature device when reach the end of list */
> +	return build_info_commit_dev(binfo);
> +}
> +
> +struct fpga_enum_info *fpga_enum_info_alloc(struct device *dev)
> +{
> +	struct fpga_enum_info *info;
> +
> +	get_device(dev);
> +
> +	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
> +	if (!info) {
> +		put_device(dev);
> +		return NULL;
> +	}
> +
> +	info->dev = dev;
> +	INIT_LIST_HEAD(&info->dfls);
> +
> +	return info;
> +}
> +EXPORT_SYMBOL_GPL(fpga_enum_info_alloc);
> +
> +int fpga_enum_info_add_dfl(struct fpga_enum_info *info, resource_size_t start,
> +			   resource_size_t len, void __iomem *ioaddr)
> +{
> +	struct fpga_enum_dfl *dfl;
> +
> +	dfl = devm_kzalloc(info->dev, sizeof(*dfl), GFP_KERNEL);
> +	if (!dfl)
> +		return -ENOMEM;
> +
> +	dfl->start = start;
> +	dfl->len = len;
> +	dfl->ioaddr = ioaddr;
> +
> +	list_add_tail(&dfl->node, &info->dfls);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fpga_enum_info_add_dfl);
> +
> +void fpga_enum_info_free(struct fpga_enum_info *info)
> +{
> +	struct fpga_enum_dfl *tmp, *dfl;
> +	struct device *dev;
> +
> +	if (!info)
> +		return;
> +
> +	dev = info->dev;
> +
> +	/* remove all device feature lists in the list. */
> +	list_for_each_entry_safe(dfl, tmp, &info->dfls, node) {
> +		list_del(&dfl->node);
> +		devm_kfree(dev, dfl);
> +	}
> +
> +	devm_kfree(dev, info);
> +	put_device(dev);
> +}
> +EXPORT_SYMBOL_GPL(fpga_enum_info_free);
> +
> +static int remove_feature_dev(struct device *dev, void *data)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	enum fpga_id_type type = feature_dev_id_type(pdev);
> +	int id = pdev->id;
> +
> +	platform_device_unregister(pdev);
> +
> +	free_fpga_id(type, id);
> +
> +	return 0;
> +}
> +
> +static void remove_feature_devs(struct fpga_cdev *cdev)
> +{
> +	device_for_each_child(&cdev->region.dev, NULL, remove_feature_dev);
> +}
> +
> +/**
> + * fpga_enumerate_feature_devs - enumerate feature devices
> + * @info: information for enumeration.
> + *
> + * This function creates a container device (base FPGA region), enumerates
> + * feature devices based on the enumeration info and creates platform devices
> + * under the container device.
> + *
> + * Return: fpga_cdev struct on success, -errno on failure
> + */
> +struct fpga_cdev *fpga_enumerate_feature_devs(struct fpga_enum_info *info)
> +{
> +	struct build_feature_devs_info *binfo;
> +	struct fpga_cdev *cdev;
> +	struct fpga_enum_dfl *dfl;
> +	int ret = 0;
> +
> +	if (!info->dev)
> +		return ERR_PTR(-ENODEV);
> +
> +	cdev = devm_kzalloc(info->dev, sizeof(*cdev), GFP_KERNEL);
> +	if (!cdev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	cdev->parent = info->dev;
> +	mutex_init(&cdev->lock);
> +	INIT_LIST_HEAD(&cdev->port_dev_list);
> +	cdev->region.parent = info->dev;
> +
> +	ret = fpga_region_register(&cdev->region);
> +	if (ret)
> +		goto free_cdev_exit;
> +
> +	/* create and init build info for enumeration */
> +	binfo = devm_kzalloc(info->dev, sizeof(*binfo), GFP_KERNEL);
> +	if (!binfo) {
> +		ret = -ENOMEM;
> +		goto unregister_region_exit;
> +	}
> +
> +	binfo->dev = info->dev;
> +	binfo->cdev = cdev;
> +
> +	/*
> +	 * start enumeration for all feature devices based on Device Feature
> +	 * Lists.
> +	 */
> +	list_for_each_entry(dfl, &info->dfls, node) {
> +		ret = parse_feature_list(binfo, dfl);
> +		if (ret) {
> +			remove_feature_devs(cdev);
> +			build_info_free(binfo);
> +			goto unregister_region_exit;
> +		}
> +	}
> +
> +	build_info_free(binfo);
> +
> +	return cdev;
> +
> +unregister_region_exit:
> +	fpga_region_unregister(&cdev->region);
> +free_cdev_exit:
> +	devm_kfree(cdev->parent, cdev);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(fpga_enumerate_feature_devs);
> +
> +/**
> + * fpga_remove_feature_devs - remove all feature devices
> + * @cdev: fpga container device.
> + *
> + * Remove the container device and all feature devices under given container
> + * devices.
> + */
> +void fpga_remove_feature_devs(struct fpga_cdev *cdev)
> +{
> +	struct feature_platform_data *pdata, *ptmp;
> +
> +	remove_feature_devs(cdev);
> +
> +	mutex_lock(&cdev->lock);
> +	if (cdev->fme_dev) {
> +		/* the fme should be unregistered. */
> +		WARN_ON(device_is_registered(cdev->fme_dev));
> +		put_device(cdev->fme_dev);
> +	}
> +
> +	list_for_each_entry_safe(pdata, ptmp, &cdev->port_dev_list, node) {
> +		struct platform_device *port_dev = pdata->dev;
> +
> +		/* the port should be unregistered. */
> +		WARN_ON(device_is_registered(&port_dev->dev));
> +		list_del(&pdata->node);
> +		put_device(&port_dev->dev);
> +	}
> +	mutex_unlock(&cdev->lock);
> +
> +	fpga_region_unregister(&cdev->region);
> +	devm_kfree(cdev->parent, cdev);
> +}
> +EXPORT_SYMBOL_GPL(fpga_remove_feature_devs);
> +
> +int fpga_port_id(struct platform_device *pdev)
> +{
> +	void __iomem *base;
> +
> +	base = get_feature_ioaddr_by_index(&pdev->dev, PORT_FEATURE_ID_HEADER);
> +	WARN_ON(!base);
> +
> +	return FIELD_GET(PORT_CAP_PORT_NUM, readq(base + FME_HDR_CAP));
> +}
> +EXPORT_SYMBOL_GPL(fpga_port_id);
> +
> +/*
> + * Enable Port by clear the port soft reset bit, which is set by default.
> + * The User AFU is unable to respond to any MMIO access while in reset.
> + * __fpga_port_enable function should only be used after __fpga_port_disable
> + * function.
> + */
> +void __fpga_port_enable(struct platform_device *pdev)
> +{
> +	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +	void __iomem *base;
> +	u64 v;
> +
> +	WARN_ON(!pdata->disable_count);
> +
> +	if (--pdata->disable_count != 0)
> +		return;
> +
> +	base = get_feature_ioaddr_by_index(&pdev->dev, PORT_FEATURE_ID_HEADER);
> +	WARN_ON(!base);
> +
> +	/* Clear port soft reset */
> +	v = readq(base + PORT_HDR_CTRL);
> +	v &= ~PORT_CTRL_SFTRST;
> +	writeq(v, base + PORT_HDR_CTRL);
> +}
> +EXPORT_SYMBOL_GPL(__fpga_port_enable);
> +
> +#define RST_POLL_INVL 10 /* us */
> +#define RST_POLL_TIMEOUT 1000 /* us */
> +
> +int __fpga_port_disable(struct platform_device *pdev)
> +{
> +	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +	void __iomem *base;
> +	u64 v;
> +
> +	if (pdata->disable_count++ != 0)
> +		return 0;
> +
> +	base = get_feature_ioaddr_by_index(&pdev->dev, PORT_FEATURE_ID_HEADER);
> +	WARN_ON(!base);
> +
> +	/* Set port soft reset */
> +	v = readq(base + PORT_HDR_CTRL);
> +	v |= PORT_CTRL_SFTRST;
> +	writeq(v, base + PORT_HDR_CTRL);
> +
> +	/*
> +	 * HW sets ack bit to 1 when all outstanding requests have been drained
> +	 * on this port and minimum soft reset pulse width has elapsed.
> +	 * Driver polls port_soft_reset_ack to determine if reset done by HW.
> +	 */
> +	if (readq_poll_timeout(base + PORT_HDR_CTRL, v, v & PORT_CTRL_SFTRST,
> +			       RST_POLL_INVL, RST_POLL_TIMEOUT)) {
> +		dev_err(&pdev->dev, "timeout, fail to reset device\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__fpga_port_disable);
> +
> +static int __init dfl_fpga_init(void)
> +{
> +	fpga_ids_init();
> +
> +	return 0;
> +}
> +
> +static void __exit dfl_fpga_exit(void)
> +{
> +	fpga_ids_destroy();
> +}
> +
> +module_init(dfl_fpga_init);
> +module_exit(dfl_fpga_exit);
> +
> +MODULE_DESCRIPTION("FPGA Device Feature List (DFL) Support");
> +MODULE_AUTHOR("Intel Corporation");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/fpga/fpga-dfl.h b/drivers/fpga/fpga-dfl.h
> new file mode 100644
> index 0000000..abcbe57
> --- /dev/null
> +++ b/drivers/fpga/fpga-dfl.h
> @@ -0,0 +1,365 @@
> +/*
> + * Driver Header File for FPGA Device Feature List (DFL) Support
> + *
> + * Copyright (C) 2017 Intel Corporation, Inc.
> + *
> + * Authors:
> + *   Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> + *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> + *
> + * This work is licensed under the terms of the GNU GPL version 2.
> + * SPDX-License-Identifier: GPL-2.0
> + */
> +
> +#ifndef __DFL_FPGA_H
> +#define __DFL_FPGA_H
> +
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/iopoll.h>
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/uuid.h>
> +#include <linux/fpga/fpga-region.h>
> +
> +/* maximum supported number of ports */
> +#define MAX_FPGA_PORT_NUM 4
> +/* plus one for fme device */
> +#define MAX_FEATURE_DEV_NUM	(MAX_FPGA_PORT_NUM + 1)
> +
> +#define FME_FEATURE_HEADER          "fme_hdr"
> +#define FME_FEATURE_THERMAL_MGMT    "fme_thermal"
> +#define FME_FEATURE_POWER_MGMT      "fme_power"
> +#define FME_FEATURE_GLOBAL_IPERF    "fme_iperf"
> +#define FME_FEATURE_GLOBAL_ERR      "fme_error"
> +#define FME_FEATURE_PR_MGMT         "fme_pr"
> +#define FME_FEATURE_HSSI            "fme_hssi"
> +#define FME_FEATURE_GLOBAL_DPERF    "fme_dperf"
> +
> +#define PORT_FEATURE_HEADER         "port_hdr"
> +#define PORT_FEATURE_UAFU           "port_uafu"
> +#define PORT_FEATURE_ERR            "port_err"
> +#define PORT_FEATURE_UMSG           "port_umsg"
> +#define PORT_FEATURE_PR             "port_pr"
> +#define PORT_FEATURE_STP            "port_stp"
> +
> +/* Device Feature Header Register Set */
> +#define DFH			0x0
> +#define GUID_L			0x8
> +#define GUID_H			0x10
> +#define NEXT_AFU		0x18
> +
> +/* Device Feature Header Register Bitfield */
> +#define DFH_ID			GENMASK_ULL(11, 0)	/* Feature ID */
> +#define DFH_ID_FIU_FME		0
> +#define DFH_ID_FIU_PORT		1
> +#define DFH_REVISION		GENMASK_ULL(15, 12)	/* Feature revision */
> +#define DFH_NEXT_HDR_OFST	GENMASK_ULL(39, 16)	/* Offset to next DFH */
> +#define DFH_EOL			BIT(40)			/* End of list */
> +#define DFH_TYPE		GENMASK_ULL(63, 60)	/* Feature type */
> +#define DFH_TYPE_AFU		1
> +#define DFH_TYPE_PRIVATE	3
> +#define DFH_TYPE_FIU		4
> +
> +/* Next AFU Register Bitfield */
> +#define NEXT_AFU_NEXT_DFH_OFST	GENMASK_ULL(23, 0)	/* Offset to next AFU */
> +
> +/*
> + * It only has DFH register as header for private feature, but for FIU/AFU
> + * For FIU/AFU features, they all have DFH + GUID + NEXT_AFU as common header
> + * registers.
> + */
> +#define DFH_SIZE		0x8
> +#define AFU_DFH_SIZE		0x20
> +#define FIU_DFH_SIZE		0x20
> +
> +/* FME Header Register Set */
> +#define FME_HDR_DFH		DFH
> +#define FME_HDR_AFU_GUID_L	GUID_L
> +#define FME_HDR_AFU_GUID_H	GUID_H
> +#define FME_HDR_NEXT_AFU	NEXT_AFU
> +#define FME_HDR_CAP		0x30
> +#define FME_HDR_PORT_OFST(n)	(0x38 + ((n) * 0x8))
> +#define FME_HDR_BITSTREAM_ID	0x60
> +#define FME_HDR_BITSTREAM_MD	0x68
> +#define FME_HDR_SIZE		0x70
> +
> +/* FME Fab Capability Register Bitfield */
> +#define FME_CAP_FABRIC_VERID	GENMASK_ULL(7, 0)	/* Fabric version ID */
> +#define FME_CAP_SOCKET_ID	BIT(8)			/* Socket ID */
> +#define FME_CAP_PCIE0_LINK_AVL	BIT(12)			/* PCIE0 Link */
> +#define FME_CAP_PCIE1_LINK_AVL	BIT(13)			/* PCIE1 Link */
> +#define FME_CAP_COHR_LINK_AVL	BIT(14)			/* Coherent Link */
> +#define FME_CAP_IOMMU_AVL	BIT(16)			/* IOMMU available */
> +#define FME_CAP_NUM_PORTS	GENMASK_ULL(19, 17)	/* Number of ports */
> +#define FME_CAP_ADDR_WIDTH	GENMASK_ULL(29, 24)	/* Address bus width */
> +#define FME_CAP_CACHE_SIZE	GENMASK_ULL(43, 32)	/* cache size in KB */
> +#define FME_CAP_CACHE_ASSOC	GENMASK_ULL(47, 44)	/* Associativity */
> +
> +/* FME Port Offset Register Bitfield */
> +/* Offset to port device feature header */
> +#define FME_PORT_OFST_DFH_OFST	GENMASK_ULL(23, 0)
> +/* PCI Bar ID for this port */
> +#define FME_PORT_OFST_BAR_ID	GENMASK_ULL(34, 32)
> +/* AFU MMIO access permission. 1 - VF, 0 - PF. */
> +#define FME_PORT_OFST_ACC_CTRL	BIT(55)
> +#define FME_PORT_OFST_ACC_PF	0
> +#define FME_PORT_OFST_ACC_VF	1
> +#define FME_PORT_OFST_IMP	BIT(60)
> +
> +/* FME Thermal Sub Feature Register Set */
> +#define FME_THERMAL_DFH		DFH
> +#define FME_THERMAL_SIZE	DFH_SIZE
> +
> +/* FME Power Sub Feature Register Set */
> +#define FME_POWER_DFH		DFH
> +#define FME_POWER_SIZE		DFH_SIZE
> +
> +/* FME Global Performance Sub Feature Register Set */
> +#define FME_IPERF_DFH		DFH
> +#define FME_IPERF_SIZE		DFH_SIZE
> +
> +/* FME Global Error Sub Feature Register Set */
> +#define FME_ERR_DFH		DFH
> +#define FME_ERR_SIZE		DFH_SIZE
> +
> +/* FME Partial Reconfiguration Sub Feature Register Set */
> +#define FME_PR_DFH		DFH
> +#define FME_PR_SIZE		DFH_SIZE
> +
> +/* FME HSSI Sub Feature Register Set */
> +#define FME_HSSI_DFH		DFH
> +#define FME_HSSI_SIZE		DFH_SIZE
> +
> +/* FME Global Performance Sub Feature Register Set */
> +#define FME_DPERF_DFH		DFH
> +#define FME_DPERF_SIZE		DFH_SIZE
> +
> +/* PORT Header Register Set */
> +#define PORT_HDR_DFG		DFH
> +#define PORT_HDR_AFU_GUID_L	GUID_L
> +#define PORT_HDR_AFU_GUID_H	GUID_H
> +#define PORT_HDR_NEXT_AFU	NEXT_AFU
> +#define PORT_HDR_CAP		0x30
> +#define PORT_HDR_CTRL		0x38
> +#define PORT_HDR_SIZE		0x40
> +
> +/* Port Capability Register Bitfield */
> +#define PORT_CAP_PORT_NUM	GENMASK(1, 0)		/* ID of this port */
> +#define PORT_CAP_MMIO_SIZE	GENMASK(23, 8)		/* MMIO size in KB */
> +#define PORT_CAP_SUPP_INT_NUM	GENMASK(35, 32)		/* Interrupts num */
> +
> +/* Port Control Register Bitfield */
> +#define PORT_CTRL_SFTRST	BIT(0)			/* Port soft reset */
> +/* Latency tolerance reporting. '1' >= 40us, '0' < 40us.*/
> +#define PORT_CTRL_LATENCY	BIT(2)
> +#define PORT_CTRL_SFTRST_ACK	BIT(4)			/* HW ack for reset */
> +
> +/* PORT Error Sub Feature Register Set */
> +#define PORT_ERR_DFH		DFH
> +#define PORT_ERR_SIZE		DFH_SIZE
> +
> +/* PORT Unordered Message Sub Feature Register Set */
> +#define PORT_UMSG_DFH		DFH
> +#define PORT_UMSG_SIZE		DFH_SIZE
> +
> +/* PORT SignalTap Sub Feature Register Set */
> +#define PORT_STP_DFH		DFH
> +#define PORT_STP_SIZE		DFH_SIZE
> +
> +/* PORT User AFU Sub Feature Register Set */
> +#define PORT_UAFU_DFH		DFH
> +#define PORT_UAFU_SIZE		DFH_SIZE
> +
> +struct feature {
> +	const char *name;
> +	int resource_index;
> +	void __iomem *ioaddr;
> +};
> +
> +struct feature_platform_data {
> +	/* list the feature dev to cci_drvdata->port_dev_list. */
> +	struct list_head node;
> +	struct mutex lock;		/* protect platform data */
> +	struct platform_device *dev;
> +	unsigned int disable_count;	/* count for port disable */
> +
> +	int num;			/* number of features */
> +	struct feature features[0];
> +};
> +
> +enum fme_feature_id {
> +	FME_FEATURE_ID_HEADER = 0x0,
> +	FME_FEATURE_ID_THERMAL_MGMT = 0x1,
> +	FME_FEATURE_ID_POWER_MGMT = 0x2,
> +	FME_FEATURE_ID_GLOBAL_IPERF = 0x3,
> +	FME_FEATURE_ID_GLOBAL_ERR = 0x4,
> +	FME_FEATURE_ID_PR_MGMT = 0x5,
> +	FME_FEATURE_ID_HSSI = 0x6,
> +	FME_FEATURE_ID_GLOBAL_DPERF = 0x7,
> +	FME_FEATURE_ID_MAX = 0x8,
> +};
> +
> +enum port_feature_id {
> +	PORT_FEATURE_ID_HEADER = 0x0,
> +	PORT_FEATURE_ID_ERROR = 0x1,
> +	PORT_FEATURE_ID_UMSG = 0x2,
> +	PORT_FEATURE_ID_PR = 0x3,
> +	PORT_FEATURE_ID_STP = 0x4,
> +	PORT_FEATURE_ID_UAFU = 0x5,
> +	PORT_FEATURE_ID_MAX = 0x6,
> +};
> +
> +#define FME_FEATURE_NUM			FME_FEATURE_ID_MAX
> +#define PORT_FEATURE_NUM		PORT_FEATURE_ID_MAX
> +
> +#define FPGA_FEATURE_DEV_FME		"fpga-dfl-fme"
> +#define FPGA_FEATURE_DEV_PORT		"fpga-dfl-port"
> +
> +static inline int feature_platform_data_size(const int num)
> +{
> +	return sizeof(struct feature_platform_data) +
> +		num * sizeof(struct feature);
> +}
> +
> +int fpga_port_id(struct platform_device *pdev);
> +
> +static inline int fpga_port_check_id(struct platform_device *pdev,
> +				     void *pport_id)
> +{
> +	return fpga_port_id(pdev) == *(int *)pport_id;
> +}
> +
> +void __fpga_port_enable(struct platform_device *pdev);
> +int __fpga_port_disable(struct platform_device *pdev);
> +
> +static inline void fpga_port_enable(struct platform_device *pdev)
> +{
> +	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +
> +	mutex_lock(&pdata->lock);
> +	__fpga_port_enable(pdev);
> +	mutex_unlock(&pdata->lock);
> +}
> +
> +static inline int fpga_port_disable(struct platform_device *pdev)
> +{
> +	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +	int ret;
> +
> +	mutex_lock(&pdata->lock);
> +	ret = __fpga_port_disable(pdev);
> +	mutex_unlock(&pdata->lock);
> +
> +	return ret;
> +}
> +
> +static inline int __fpga_port_reset(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	ret = __fpga_port_disable(pdev);
> +	if (ret)
> +		return ret;
> +
> +	__fpga_port_enable(pdev);
> +
> +	return 0;
> +}
> +
> +static inline int fpga_port_reset(struct platform_device *pdev)
> +{
> +	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
> +	int ret;
> +
> +	mutex_lock(&pdata->lock);
> +	ret = __fpga_port_reset(pdev);
> +	mutex_unlock(&pdata->lock);
> +
> +	return ret;
> +}
> +
> +static inline void __iomem *
> +get_feature_ioaddr_by_index(struct device *dev, int index)
> +{
> +	struct feature_platform_data *pdata = dev_get_platdata(dev);
> +
> +	return pdata->features[index].ioaddr;
> +}
> +
> +static inline bool feature_is_fme(void __iomem *base)
> +{
> +	u64 v = readq(base + DFH);
> +
> +	return (FIELD_GET(DFH_TYPE, v) == DFH_TYPE_FIU) &&
> +		(FIELD_GET(DFH_ID, v) == DFH_ID_FIU_FME);
> +}
> +
> +static inline bool feature_is_port(void __iomem *base)
> +{
> +	u64 v = readq(base + DFH);
> +
> +	return (FIELD_GET(DFH_TYPE, v) == DFH_TYPE_FIU) &&
> +		(FIELD_GET(DFH_ID, v) == DFH_ID_FIU_PORT);
> +}
> +
> +/**
> + * fpga_enum_info - FPGA enumeration information
> + *
> + * @dev: parent device.
> + * @dfls: list of device feature lists.
> + */
> +struct fpga_enum_info {
> +	struct device *dev;
> +	struct list_head dfls;
> +};
> +
> +/**
> + * fpga_enum_dfl - FPGA enumeration device feature list information
> + *
> + * @start: base address of this device feature list.
> + * @len: size of this device feature list.
> + * @ioaddr: mapped base address of this device feature list.
> + * @node: node in list of device feature lists.
> + */
> +struct fpga_enum_dfl {
> +	resource_size_t start;
> +	resource_size_t len;
> +
> +	void __iomem *ioaddr;
> +
> +	struct list_head node;
> +};
> +
> +struct fpga_enum_info *fpga_enum_info_alloc(struct device *dev);
> +int fpga_enum_info_add_dfl(struct fpga_enum_info *info, resource_size_t start,
> +			   resource_size_t len, void __iomem *ioaddr);
> +void fpga_enum_info_free(struct fpga_enum_info *info);
> +
> +/**
> + * fpga_cdev - fpga container device
> + * @parent: parent device of this container device.
> + * @region: base fpga region.
> + * @fme_dev: FME feature device under this container device.
> + * @lock: mutex lock to protect the port device list.
> + * @port_dev_list: list of all port feature devices under this container device.
> + */
> +struct fpga_cdev {
> +	struct device *parent;
> +
> +	struct fpga_region region;
> +
> +	struct device *fme_dev;
> +
> +	struct mutex lock; /* to protect the port device list */
> +	struct list_head port_dev_list;
> +};
> +
> +struct fpga_cdev *fpga_enumerate_feature_devs(struct fpga_enum_info *info);
> +void fpga_remove_feature_devs(struct fpga_cdev *cdev);
> +
> +#endif /* __DFL_FPGA_H */
> -- 
> 1.8.3.1
> 

Thanks,

Moritz
