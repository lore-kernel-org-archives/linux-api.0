From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 13/21] fpga: dfl: fme: add partial reconfiguration sub feature support
Date: Mon, 27 Nov 2017 14:42:20 +0800
Message-ID: <1511764948-20972-14-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Kang Luwei <luwei.kang@intel.com>

Partial Reconfiguration (PR) is the most important function for FME. It
allows reconfiguration for given Port/Accelerated Function Unit (AFU).

It creates platform devices for fpga-mgr, fpga-regions and fpga-bridges,
and invokes fpga-region's interface (fpga_region_program_fpga) for PR
operation once PR request received via ioctl. Below user space interface
is exposed by this sub feature.

Ioctl interface:
* FPGA_FME_PORT_PR
  Do partial reconfiguration per information from userspace, including
  target port(AFU), buffer size and address info. It returns error code
  to userspace if failed. For detailed PR error information, user needs
  to read fpga-mgr's status sysfs interface.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Kang Luwei <luwei.kang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
----
v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
    switched to GPLv2 license.
    removed status from FPGA_FME_PORT_PR ioctl data structure.
    added platform devices creation for fpga-mgr/fpga-region/fpga-bridge.
    switched to fpga-region interface fpga_region_program_fpga for PR.
    fixed comments from Alan Tull on FPGA_MGR_PARTIAL_RECONFIG flag usage.
    fixed kbuild warnings.
v3: rename driver files to dfl-fme-*.
    rebase due to fpga APIs change.
    replace bitfields.
    switch to fpga_cdev_find_port to find port device.
---
 drivers/fpga/Makefile         |   2 +-
 drivers/fpga/dfl-fme-main.c   |  45 +++-
 drivers/fpga/dfl-fme-pr.c     | 492 ++++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/dfl-fme.h        |  57 +++++
 include/uapi/linux/fpga-dfl.h |  27 +++
 5 files changed, 621 insertions(+), 2 deletions(-)
 create mode 100644 drivers/fpga/dfl-fme-pr.c
 create mode 100644 drivers/fpga/dfl-fme.h

diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index e5ba158..cc75bb3 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
 obj-$(CONFIG_FPGA_DFL)			+= fpga-dfl.o
 obj-$(CONFIG_FPGA_DFL_FME)		+= fpga-dfl-fme.o
 
-fpga-dfl-fme-objs := dfl-fme-main.o
+fpga-dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
 
 # Drivers for FPGAs which implement DFL
 obj-$(CONFIG_INTEL_FPGA_DFL_PCI)	+= intel-dfl-pci.o
diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
index b4e0b54..13154d1 100644
--- a/drivers/fpga/dfl-fme-main.c
+++ b/drivers/fpga/dfl-fme-main.c
@@ -21,6 +21,7 @@
 #include <linux/fpga-dfl.h>
 
 #include "fpga-dfl.h"
+#include "dfl-fme.h"
 
 static ssize_t ports_num_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
@@ -105,6 +106,10 @@ static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
 		.ops = &fme_hdr_ops,
 	},
 	{
+		.name = FME_FEATURE_PR_MGMT,
+		.ops = &pr_mgmt_ops,
+	},
+	{
 		.ops = NULL,
 	},
 };
@@ -188,14 +193,49 @@ static long fme_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	.unlocked_ioctl = fme_ioctl,
 };
 
+static int fme_dev_init(struct platform_device *pdev)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct fpga_fme *fme;
+
+	fme = devm_kzalloc(&pdev->dev, sizeof(*fme), GFP_KERNEL);
+	if (!fme)
+		return -ENOMEM;
+
+	fme->pdata = pdata;
+
+	mutex_lock(&pdata->lock);
+	fpga_pdata_set_private(pdata, fme);
+	mutex_unlock(&pdata->lock);
+
+	return 0;
+}
+
+static void fme_dev_destroy(struct platform_device *pdev)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct fpga_fme *fme;
+
+	mutex_lock(&pdata->lock);
+	fme = fpga_pdata_get_private(pdata);
+	fpga_pdata_set_private(pdata, NULL);
+	mutex_unlock(&pdata->lock);
+
+	devm_kfree(&pdev->dev, fme);
+}
+
 static int fme_probe(struct platform_device *pdev)
 {
 	int ret;
 
-	ret = fpga_dev_feature_init(pdev, fme_feature_drvs);
+	ret = fme_dev_init(pdev);
 	if (ret)
 		goto exit;
 
+	ret = fpga_dev_feature_init(pdev, fme_feature_drvs);
+	if (ret)
+		goto dev_destroy;
+
 	ret = fpga_register_dev_ops(pdev, &fme_fops, THIS_MODULE);
 	if (ret)
 		goto feature_uinit;
@@ -204,6 +244,8 @@ static int fme_probe(struct platform_device *pdev)
 
 feature_uinit:
 	fpga_dev_feature_uinit(pdev);
+dev_destroy:
+	fme_dev_destroy(pdev);
 exit:
 	return ret;
 }
@@ -212,6 +254,7 @@ static int fme_remove(struct platform_device *pdev)
 {
 	fpga_dev_feature_uinit(pdev);
 	fpga_unregister_dev_ops(pdev);
+	fme_dev_destroy(pdev);
 
 	return 0;
 }
diff --git a/drivers/fpga/dfl-fme-pr.c b/drivers/fpga/dfl-fme-pr.c
new file mode 100644
index 0000000..2ed9ece
--- /dev/null
+++ b/drivers/fpga/dfl-fme-pr.c
@@ -0,0 +1,492 @@
+/*
+ * Driver for FPGA Management Engine (FME) Partial Reconfiguration
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Kang Luwei <luwei.kang@intel.com>
+ *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *   Wu Hao <hao.wu@intel.com>
+ *   Joseph Grecco <joe.grecco@intel.com>
+ *   Enno Luebbers <enno.luebbers@intel.com>
+ *   Tim Whisonant <tim.whisonant@intel.com>
+ *   Ananda Ravuri <ananda.ravuri@intel.com>
+ *   Christopher Rauer <christopher.rauer@intel.com>
+ *   Henry Mitchel <henry.mitchel@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/vmalloc.h>
+#include <linux/uaccess.h>
+#include <linux/fpga/fpga-mgr.h>
+#include <linux/fpga/fpga-bridge.h>
+#include <linux/fpga/fpga-region.h>
+#include <linux/fpga-dfl.h>
+
+#include "fpga-dfl.h"
+#include "dfl-fme.h"
+
+static struct fme_region *
+find_fme_region_by_port_id(struct fpga_fme *fme, int port_id)
+{
+	struct fme_region *fme_region;
+
+	list_for_each_entry(fme_region, &fme->region_list, node)
+		if (fme_region->port_id == port_id)
+			return fme_region;
+
+	return NULL;
+}
+
+static int fpga_fme_region_match(struct device *dev, const void *data)
+{
+	return dev->parent == data;
+}
+
+static struct fpga_region *
+fpga_fme_region_find(struct fpga_fme *fme, int port_id)
+{
+	struct fme_region *fme_region;
+	struct fpga_region *region;
+
+	fme_region = find_fme_region_by_port_id(fme, port_id);
+	if (!fme_region)
+		return NULL;
+
+	region = fpga_region_class_find(NULL, &fme_region->region->dev,
+					fpga_fme_region_match);
+	if (!region)
+		return NULL;
+
+	return region;
+}
+
+static int fme_pr(struct platform_device *pdev, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct fpga_fme *fme;
+	struct fpga_image_info *info;
+	struct fpga_region *region;
+	struct fpga_fme_port_pr port_pr;
+	unsigned long minsz;
+	void __iomem *fme_hdr;
+	void *buf = NULL;
+	int ret = 0;
+	u64 v;
+
+	minsz = offsetofend(struct fpga_fme_port_pr, buffer_address);
+
+	if (copy_from_user(&port_pr, argp, minsz))
+		return -EFAULT;
+
+	if (port_pr.argsz < minsz || port_pr.flags)
+		return -EINVAL;
+
+	if (!IS_ALIGNED(port_pr.buffer_size, 4))
+		return -EINVAL;
+
+	/* get fme header region */
+	fme_hdr = get_feature_ioaddr_by_index(&pdev->dev,
+					      FME_FEATURE_ID_HEADER);
+	if (WARN_ON(!fme_hdr))
+		return -EINVAL;
+
+	/* check port id */
+	v = readq(fme_hdr + FME_HDR_CAP);
+	if (port_pr.port_id >= FIELD_GET(FME_CAP_NUM_PORTS, v)) {
+		dev_dbg(&pdev->dev, "port number more than maximum\n");
+		return -EINVAL;
+	}
+
+	if (!access_ok(VERIFY_READ,
+		       (void __user *)(unsigned long)port_pr.buffer_address,
+		       port_pr.buffer_size))
+		return -EFAULT;
+
+	buf = vmalloc(port_pr.buffer_size);
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf,
+			   (void __user *)(unsigned long)port_pr.buffer_address,
+			   port_pr.buffer_size)) {
+		ret = -EFAULT;
+		goto free_exit;
+	}
+
+	/* prepare fpga_image_info for PR */
+	info = fpga_image_info_alloc(&pdev->dev);
+	if (!info) {
+		ret = -ENOMEM;
+		goto free_exit;
+	}
+
+	info->flags |= FPGA_MGR_PARTIAL_RECONFIG;
+
+	mutex_lock(&pdata->lock);
+	fme = fpga_pdata_get_private(pdata);
+	/* fme device has been unregistered. */
+	if (!fme) {
+		ret = -EINVAL;
+		goto unlock_exit;
+	}
+
+	region = fpga_fme_region_find(fme, port_pr.port_id);
+	if (!region) {
+		ret = -EINVAL;
+		goto unlock_exit;
+	}
+
+	fpga_image_info_free(region->info);
+
+	info->buf = buf;
+	info->count = port_pr.buffer_size;
+	info->region_id = port_pr.port_id;
+	region->info = info;
+
+	ret = fpga_region_program_fpga(region);
+
+	if (region->get_bridges)
+		fpga_bridges_put(&region->bridge_list);
+
+	put_device(&region->dev);
+unlock_exit:
+	mutex_unlock(&pdata->lock);
+free_exit:
+	vfree(buf);
+	if (copy_to_user((void __user *)arg, &port_pr, minsz))
+		return -EFAULT;
+
+	return ret;
+}
+
+/**
+ * fpga_fme_create_mgr - create fpga mgr platform device as child device
+ *
+ * @pdata: fme platform_device's pdata
+ *
+ * Return: mgr platform device if successful, and error code otherwise.
+ */
+static struct platform_device *
+fpga_fme_create_mgr(struct feature_platform_data *pdata)
+{
+	struct platform_device *mgr, *fme = pdata->dev;
+	struct resource res;
+	struct resource *pres;
+	int ret = -ENOMEM;
+
+	/*
+	 * Each FME has only one fpga-mgr, so allocate platform device using
+	 * the same FME platform device id.
+	 */
+	mgr = platform_device_alloc(FPGA_DFL_FME_MGR, fme->id);
+	if (!mgr)
+		return ERR_PTR(ret);
+
+	mgr->dev.parent = &fme->dev;
+
+	pres = platform_get_resource_byname(fme, IORESOURCE_MEM,
+					    FME_FEATURE_PR_MGMT);
+	if (!pres) {
+		ret = -ENODEV;
+		goto create_mgr_err;
+	}
+
+	memset(&res, 0, sizeof(struct resource));
+
+	res.start = pres->start;
+	res.end = pres->end;
+	res.name = pres->name;
+	res.flags = IORESOURCE_MEM;
+
+	ret = platform_device_add_resources(mgr, &res, 1);
+	if (ret)
+		goto create_mgr_err;
+
+	ret = platform_device_add(mgr);
+	if (ret)
+		goto create_mgr_err;
+
+	return mgr;
+
+create_mgr_err:
+	platform_device_put(mgr);
+	return ERR_PTR(ret);
+}
+
+/**
+ * fpga_fme_destroy_mgr - destroy fpga mgr platform device
+ *
+ * @mgr: fpga mgr platform device to be destroy
+ */
+static void fpga_fme_destroy_mgr(struct feature_platform_data *pdata)
+{
+	struct fpga_fme *priv = fpga_pdata_get_private(pdata);
+
+	platform_device_unregister(priv->mgr);
+}
+
+/**
+ * fpga_fme_create_bridge - create fme fpga bridge platform device as child
+ *
+ * @pdata: fme platform device's pdata
+ * @port_id: port id for the bridge to be created.
+ *
+ * Return: bridge platform device if successful, and error code otherwise.
+ */
+static struct fme_bridge *
+fpga_fme_create_bridge(struct feature_platform_data *pdata, int port_id)
+{
+	struct device *dev = &pdata->dev->dev;
+	struct fme_br_pdata br_pdata;
+	struct fme_bridge *fme_br;
+	int ret = -ENOMEM;
+
+	fme_br = devm_kzalloc(dev, sizeof(*fme_br), GFP_KERNEL);
+	if (!fme_br)
+		return ERR_PTR(ret);
+
+	br_pdata.port = fpga_cdev_find_port(fpga_pdata_to_fpga_cdev(pdata),
+					    &port_id, fpga_port_check_id);
+	if (!br_pdata.port)
+		return ERR_PTR(-ENODEV);
+
+	/*
+	 * Each FPGA device may have more than one port, so allocate platform
+	 * device using the same port platform device id.
+	 */
+	fme_br->br = platform_device_alloc(FPGA_DFL_FME_BRIDGE,
+					   br_pdata.port->id);
+	if (!fme_br->br) {
+		ret = -ENOMEM;
+		goto create_br_err;
+	}
+
+	fme_br->br->dev.parent = dev;
+
+	ret = platform_device_add_data(fme_br->br, &br_pdata, sizeof(br_pdata));
+	if (ret)
+		goto create_br_err;
+
+	ret = platform_device_add(fme_br->br);
+	if (ret)
+		goto create_br_err;
+
+	return fme_br;
+
+create_br_err:
+	platform_device_put(fme_br->br);
+	put_device(&br_pdata.port->dev);
+	return ERR_PTR(ret);
+}
+
+/**
+ * fpga_fme_destroy_bridge - destroy fpga bridge platform device
+ * @br: fpga bridge platform device to be destroy
+ */
+static void fpga_fme_destroy_bridge(struct feature_platform_data *pdata,
+				    struct fme_bridge *fme_br)
+{
+	struct fme_br_pdata *br_pdata = dev_get_platdata(&fme_br->br->dev);
+
+	put_device(&br_pdata->port->dev);
+	platform_device_unregister(fme_br->br);
+}
+
+static void fpga_fme_destroy_bridges(struct feature_platform_data *pdata)
+{
+	struct fpga_fme *priv = fpga_pdata_get_private(pdata);
+	struct fme_bridge *fbridge, *tmp;
+
+	list_for_each_entry_safe(fbridge, tmp, &priv->bridge_list, node) {
+		list_del(&fbridge->node);
+		fpga_fme_destroy_bridge(pdata, fbridge);
+	}
+}
+
+/**
+ * fpga_fme_create_region - create fpga region platform device as child
+ *
+ * @pdata: fme platform device's pdata
+ * @mgr: mgr platform device needed for region
+ * @br: br platform device needed for region
+ * @port_id: port id
+ *
+ * Return: fme region if successful, and error code otherwise.
+ */
+static struct fme_region *
+fpga_fme_create_region(struct feature_platform_data *pdata,
+		       struct platform_device *mgr,
+		       struct platform_device *br, int port_id)
+{
+	struct device *dev = &pdata->dev->dev;
+	struct fme_region_pdata region_pdata;
+	struct fme_region *fme_region;
+	int ret = -ENOMEM;
+
+	fme_region = devm_kzalloc(dev, sizeof(*fme_region), GFP_KERNEL);
+	if (!fme_region)
+		return ERR_PTR(ret);
+
+	region_pdata.mgr = mgr;
+	region_pdata.br = br;
+
+	/*
+	 * Each FPGA device may have more than one port, so allocate platform
+	 * device using the same port platform device id.
+	 */
+	fme_region->region = platform_device_alloc(FPGA_DFL_FME_REGION, br->id);
+	if (!fme_region->region)
+		return ERR_PTR(ret);
+
+	fme_region->region->dev.parent = dev;
+
+	ret = platform_device_add_data(fme_region->region, &region_pdata,
+				       sizeof(region_pdata));
+	if (ret)
+		goto create_region_err;
+
+	ret = platform_device_add(fme_region->region);
+	if (ret)
+		goto create_region_err;
+
+	fme_region->port_id = port_id;
+
+	return fme_region;
+
+create_region_err:
+	platform_device_put(fme_region->region);
+	return ERR_PTR(ret);
+}
+
+/**
+ * fpga_fme_destroy_region - destroy fme region
+ * @region: fme region to be destroy
+ */
+static void fpga_fme_destroy_region(struct feature_platform_data *pdata,
+				    struct fme_region *fme_region)
+{
+	platform_device_unregister(fme_region->region);
+}
+
+static void fpga_fme_destroy_regions(struct feature_platform_data *pdata)
+{
+	struct fpga_fme *priv = fpga_pdata_get_private(pdata);
+	struct fme_region *fme_region, *tmp;
+
+	list_for_each_entry_safe(fme_region, tmp, &priv->region_list, node) {
+		list_del(&fme_region->node);
+		fpga_fme_destroy_region(pdata, fme_region);
+	}
+}
+
+static int pr_mgmt_init(struct platform_device *pdev, struct feature *feature)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	void __iomem *fme_hdr;
+	struct platform_device *mgr;
+	struct fme_region *fme_region;
+	struct fme_bridge *fme_br;
+	struct fpga_fme *priv;
+	int ret = -ENODEV, i = 0;
+	u64 fme_cap, port_offset;
+
+	fme_hdr = get_feature_ioaddr_by_index(&pdev->dev,
+					      FME_FEATURE_ID_HEADER);
+	if (WARN_ON(!fme_hdr))
+		return -EINVAL;
+
+	mutex_lock(&pdata->lock);
+	priv = fpga_pdata_get_private(pdata);
+
+	/* Initialize the region and bridge sub device list */
+	INIT_LIST_HEAD(&priv->region_list);
+	INIT_LIST_HEAD(&priv->bridge_list);
+
+	/* Create fpga mgr platform device */
+	mgr = fpga_fme_create_mgr(pdata);
+	if (IS_ERR(mgr)) {
+		dev_err(&pdev->dev, "fail to create fpga mgr pdev\n");
+		goto unlock;
+	}
+
+	priv->mgr = mgr;
+
+	/* Read capability register to check number of regions and bridges */
+	fme_cap = readq(fme_hdr + FME_HDR_CAP);
+	for (; i < FIELD_GET(FME_CAP_NUM_PORTS, fme_cap); i++) {
+		port_offset = readq(fme_hdr + FME_HDR_PORT_OFST(i));
+		if (!(port_offset & FME_PORT_OFST_IMP))
+			continue;
+
+		/* Create bridge for each port */
+		fme_br = fpga_fme_create_bridge(pdata, i);
+		if (IS_ERR(fme_br)) {
+			ret = PTR_ERR(fme_br);
+			goto destroy_region;
+		}
+
+		list_add(&fme_br->node, &priv->bridge_list);
+
+		/* Create region for each port */
+		fme_region = fpga_fme_create_region(pdata, mgr, fme_br->br, i);
+		if (!fme_region) {
+			ret = PTR_ERR(fme_region);
+			goto destroy_region;
+		}
+
+		list_add(&fme_region->node, &priv->region_list);
+	}
+	mutex_unlock(&pdata->lock);
+
+	return 0;
+
+destroy_region:
+	fpga_fme_destroy_regions(pdata);
+	fpga_fme_destroy_bridges(pdata);
+	fpga_fme_destroy_mgr(pdata);
+unlock:
+	mutex_unlock(&pdata->lock);
+	return ret;
+}
+
+static void pr_mgmt_uinit(struct platform_device *pdev, struct feature *feature)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct fpga_fme *priv;
+
+	mutex_lock(&pdata->lock);
+	priv = fpga_pdata_get_private(pdata);
+
+	fpga_fme_destroy_regions(pdata);
+	fpga_fme_destroy_bridges(pdata);
+	fpga_fme_destroy_mgr(pdata);
+	mutex_unlock(&pdata->lock);
+}
+
+static long fme_pr_ioctl(struct platform_device *pdev, struct feature *feature,
+			 unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	switch (cmd) {
+	case FPGA_FME_PORT_PR:
+		ret = fme_pr(pdev, arg);
+		break;
+	default:
+		ret = -ENODEV;
+	}
+
+	return ret;
+}
+
+const struct feature_ops pr_mgmt_ops = {
+	.init = pr_mgmt_init,
+	.uinit = pr_mgmt_uinit,
+	.ioctl = fme_pr_ioctl,
+};
diff --git a/drivers/fpga/dfl-fme.h b/drivers/fpga/dfl-fme.h
new file mode 100644
index 0000000..88d6dfd
--- /dev/null
+++ b/drivers/fpga/dfl-fme.h
@@ -0,0 +1,57 @@
+/*
+ * Header file for FPGA Management Engine (FME) Driver
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Kang Luwei <luwei.kang@intel.com>
+ *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *   Wu Hao <hao.wu@intel.com>
+ *   Joseph Grecco <joe.grecco@intel.com>
+ *   Enno Luebbers <enno.luebbers@intel.com>
+ *   Tim Whisonant <tim.whisonant@intel.com>
+ *   Ananda Ravuri <ananda.ravuri@intel.com>
+ *   Henry Mitchel <henry.mitchel@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#ifndef __DFL_FME_H
+#define __DFL_FME_H
+
+#define FPGA_DFL_FME_MGR		"fpga-dfl-fme-mgr"
+#define FPGA_DFL_FME_BRIDGE		"fpga-dfl-fme-bridge"
+#define FPGA_DFL_FME_REGION		"fpga-dfl-fme-region"
+
+struct fpga_fme {
+	struct platform_device *mgr;
+	struct list_head region_list;
+	struct list_head bridge_list;
+	struct feature_platform_data *pdata;
+};
+
+struct fme_region {
+	struct platform_device *region;
+	struct list_head node;
+	int port_id;
+};
+
+struct fme_region_pdata {
+	struct platform_device *mgr;
+	struct platform_device *br;
+	int region_id;
+};
+
+struct fme_bridge {
+	struct platform_device *br;
+	struct list_head node;
+};
+
+struct fme_br_pdata {
+	struct platform_device *port;
+};
+
+extern const struct feature_ops pr_mgmt_ops;
+
+#endif /* __DFL_FME_H */
diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-dfl.h
index b46d124..75bdf88 100644
--- a/include/uapi/linux/fpga-dfl.h
+++ b/include/uapi/linux/fpga-dfl.h
@@ -16,6 +16,8 @@
 #ifndef _UAPI_LINUX_FPGA_DFL_H
 #define _UAPI_LINUX_FPGA_DFL_H
 
+#include <linux/types.h>
+
 #define FPGA_API_VERSION 0
 
 /*
@@ -28,6 +30,7 @@
 #define FPGA_MAGIC 0xB6
 
 #define FPGA_BASE 0
+#define FME_BASE 0x80
 
 /**
  * FPGA_GET_API_VERSION - _IO(FPGA_MAGIC, FPGA_BASE + 0)
@@ -47,4 +50,28 @@
 
 #define FPGA_CHECK_EXTENSION	_IO(FPGA_MAGIC, FPGA_BASE + 1)
 
+/* IOCTLs for FME file descriptor */
+
+/**
+ * FPGA_FME_PORT_PR - _IOW(FPGA_MAGIC, FME_BASE + 0, struct fpga_fme_port_pr)
+ *
+ * Driver does Partial Reconfiguration based on Port ID and Buffer (Image)
+ * provided by caller.
+ * Return: 0 on success, -errno on failure.
+ * If FPGA_FME_PORT_PR returns -EIO, that indicates the HW has detected
+ * some errors during PR, under this case, the user can fetch HW error info
+ * from the status of FME's fpga manager.
+ */
+
+struct fpga_fme_port_pr {
+	/* Input */
+	__u32 argsz;		/* Structure length */
+	__u32 flags;		/* Zero for now */
+	__u32 port_id;
+	__u32 buffer_size;
+	__u64 buffer_address;	/* Userspace address to the buffer for PR */
+};
+
+#define FPGA_FME_PORT_PR	_IO(FPGA_MAGIC, FME_BASE + 0)
+
 #endif /* _UAPI_LINUX_FPGA_DFL_H */
-- 
1.8.3.1
