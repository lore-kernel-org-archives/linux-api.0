From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 20/21] fpga: dfl: afu: add user afu sub feature support
Date: Mon, 27 Nov 2017 14:42:27 +0800
Message-ID: <1511764948-20972-21-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

From: Xiao Guangrong <guangrong.xiao@linux.intel.com>

User Accelerated Function Unit sub feature exposes the MMIO region of
the AFU. After valid green bitstream (GBS) is programmed and port is
enabled, then this MMIO region could be accessed.

This patch adds support to enumerate the AFU MMIO region and expose it
to userspace via mmap file operation. Below interfaces are exposed to user:

Sysfs interface:
* /sys/class/fpga_region/<regionX>/<fpga-dfl-port.x>/afu_id
  Read-only. Indicate which green bitstream is programmed to this AFU.

Ioctl interfaces:
* FPGA_PORT_GET_INFO
  Provide info to userspace on the number of supported region.
  Only UAFU region is supported now.

* FPGA_PORT_GET_REGION_INFO
  Provide region information, including access permission, region size,
  offset from the start of device fd.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
------
v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
    add sysfs documentation.
    switched to GPLv2 license.
v3: rename driver to fpga-dfl-afu
    fix coding style and checkpatch issue.
    only allow afu_id to be read when port isn't in reset.
---
 .../ABI/testing/sysfs-platform-fpga-dfl-afu        |   9 +
 drivers/fpga/Makefile                              |   2 +-
 drivers/fpga/dfl-afu-main.c                        | 211 ++++++++++++++++++++-
 drivers/fpga/dfl-afu-region.c                      | 127 +++++++++++++
 drivers/fpga/dfl-afu.h                             |  54 ++++++
 include/uapi/linux/fpga-dfl.h                      |  47 +++++
 6 files changed, 446 insertions(+), 4 deletions(-)
 create mode 100644 drivers/fpga/dfl-afu-region.c
 create mode 100644 drivers/fpga/dfl-afu.h

diff --git a/Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu
index f4bcd94..54bcfad 100644
--- a/Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu
+++ b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu
@@ -5,3 +5,12 @@ Contact:	Wu Hao <hao.wu@intel.com>
 Description:	Read-only. It returns id of this port. One DFL FPGA device
 		may have more than one port. Userspace could use this id to
 		distinguish different ports under same FPGA device.
+
+What:		/sys/bus/platform/devices/fpga-dfl-port.0/afu_id
+Date:		November 2017
+KernelVersion:  4.15
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. User can program different green bitstreams (GBS) to
+		FPGA Accelerator Function Unit (AFU) for different functions.
+		It returns uuid which could be used to identify which GBS is
+		programmed in this AFU.
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index e234fa8..f0dd09f 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_FPGA_DFL_FME_REGION)	+= fpga-dfl-fme-region.o
 obj-$(CONFIG_FPGA_DFL_AFU)		+= fpga-dfl-afu.o
 
 fpga-dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
-fpga-dfl-afu-objs := dfl-afu-main.o
+fpga-dfl-afu-objs := dfl-afu-main.o dfl-afu-region.o
 
 # Drivers for FPGAs which implement DFL
 obj-$(CONFIG_INTEL_FPGA_DFL_PCI)	+= intel-dfl-pci.o
diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
index d3d534c..ca37a51 100644
--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -18,9 +18,10 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include <linux/fpga-dfl.h>
 
-#include "fpga-dfl.h"
+#include "dfl-afu.h"
 
 static ssize_t
 id_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -80,12 +81,74 @@ static void port_hdr_uinit(struct platform_device *pdev,
 	.ioctl = port_hdr_ioctl,
 };
 
+static ssize_t
+afu_id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(dev);
+	void __iomem *base;
+	u64 guidl, guidh;
+
+	base = get_feature_ioaddr_by_index(dev, PORT_FEATURE_ID_UAFU);
+
+	mutex_lock(&pdata->lock);
+	if (pdata->disable_count) {
+		mutex_unlock(&pdata->lock);
+		return -EBUSY;
+	}
+
+	guidl = readq(base + GUID_L);
+	guidh = readq(base + GUID_H);
+	mutex_unlock(&pdata->lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%016llx%016llx\n", guidh, guidl);
+}
+static DEVICE_ATTR_RO(afu_id);
+
+static const struct attribute *port_uafu_attrs[] = {
+	&dev_attr_afu_id.attr,
+	NULL
+};
+
+static int port_uafu_init(struct platform_device *pdev, struct feature *feature)
+{
+	struct resource *res = &pdev->resource[feature->resource_index];
+	u32 flags = FPGA_REGION_READ | FPGA_REGION_WRITE | FPGA_REGION_MMAP;
+	int ret;
+
+	dev_dbg(&pdev->dev, "PORT AFU Init.\n");
+
+	ret = afu_region_add(dev_get_platdata(&pdev->dev),
+			     FPGA_PORT_INDEX_UAFU, resource_size(res),
+			     res->start, flags);
+	if (ret)
+		return ret;
+
+	return sysfs_create_files(&pdev->dev.kobj, port_uafu_attrs);
+}
+
+static void port_uafu_uinit(struct platform_device *pdev,
+			    struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "PORT AFU UInit.\n");
+
+	sysfs_remove_files(&pdev->dev.kobj, port_uafu_attrs);
+}
+
+static const struct feature_ops port_uafu_ops = {
+	.init = port_uafu_init,
+	.uinit = port_uafu_uinit,
+};
+
 static struct feature_driver port_feature_drvs[] = {
 	{
 		.name = PORT_FEATURE_HEADER,
 		.ops = &port_hdr_ops,
 	},
 	{
+		.name = PORT_FEATURE_UAFU,
+		.ops = &port_uafu_ops,
+	},
+	{
 		.ops = NULL,
 	}
 };
@@ -130,6 +193,64 @@ static long afu_ioctl_check_extension(struct feature_platform_data *pdata,
 	return 0;
 }
 
+static long
+afu_ioctl_get_info(struct feature_platform_data *pdata, void __user *arg)
+{
+	struct fpga_port_info info;
+	struct fpga_afu *afu;
+	unsigned long minsz;
+
+	minsz = offsetofend(struct fpga_port_info, num_umsgs);
+
+	if (copy_from_user(&info, arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	mutex_lock(&pdata->lock);
+	afu = fpga_pdata_get_private(pdata);
+	info.flags = 0;
+	info.num_regions = afu->num_regions;
+	info.num_umsgs = afu->num_umsgs;
+	mutex_unlock(&pdata->lock);
+
+	if (copy_to_user(arg, &info, sizeof(info)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long
+afu_ioctl_get_region_info(struct feature_platform_data *pdata, void __user *arg)
+{
+	struct fpga_port_region_info rinfo;
+	struct fpga_afu_region region;
+	unsigned long minsz;
+	long ret;
+
+	minsz = offsetofend(struct fpga_port_region_info, offset);
+
+	if (copy_from_user(&rinfo, arg, minsz))
+		return -EFAULT;
+
+	if (rinfo.argsz < minsz || rinfo.padding)
+		return -EINVAL;
+
+	ret = afu_get_region_by_index(pdata, rinfo.index, &region);
+	if (ret)
+		return ret;
+
+	rinfo.flags = region.flags;
+	rinfo.size = region.size;
+	rinfo.offset = region.offset;
+
+	if (copy_to_user(arg, &rinfo, sizeof(rinfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct platform_device *pdev = filp->private_data;
@@ -144,6 +265,10 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return FPGA_API_VERSION;
 	case FPGA_CHECK_EXTENSION:
 		return afu_ioctl_check_extension(pdata, arg);
+	case FPGA_PORT_GET_INFO:
+		return afu_ioctl_get_info(pdata, (void __user *)arg);
+	case FPGA_PORT_GET_REGION_INFO:
+		return afu_ioctl_get_region_info(pdata, (void __user *)arg);
 	default:
 		/*
 		 * Let sub-feature's ioctl function to handle the cmd
@@ -164,27 +289,106 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	return -EINVAL;
 }
 
+static int afu_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct fpga_afu_region region;
+	struct platform_device *pdev = filp->private_data;
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	u64 size = vma->vm_end - vma->vm_start;
+	u64 offset;
+	int ret;
+
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	offset = vma->vm_pgoff << PAGE_SHIFT;
+	ret = afu_get_region_by_offset(pdata, offset, size, &region);
+	if (ret)
+		return ret;
+
+	if (!(region.flags & FPGA_REGION_MMAP))
+		return -EINVAL;
+
+	if ((vma->vm_flags & VM_READ) && !(region.flags & FPGA_REGION_READ))
+		return -EPERM;
+
+	if ((vma->vm_flags & VM_WRITE) && !(region.flags & FPGA_REGION_WRITE))
+		return -EPERM;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	return remap_pfn_range(vma, vma->vm_start,
+			(region.phys + (offset - region.offset)) >> PAGE_SHIFT,
+			size, vma->vm_page_prot);
+}
+
 static const struct file_operations afu_fops = {
 	.owner = THIS_MODULE,
 	.open = afu_open,
 	.release = afu_release,
 	.unlocked_ioctl = afu_ioctl,
+	.mmap = afu_mmap,
 };
 
+static int afu_dev_init(struct platform_device *pdev)
+{
+	struct fpga_afu *afu;
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+
+	afu = devm_kzalloc(&pdev->dev, sizeof(*afu), GFP_KERNEL);
+	if (!afu)
+		return -ENOMEM;
+
+	afu->pdata = pdata;
+
+	mutex_lock(&pdata->lock);
+	fpga_pdata_set_private(pdata, afu);
+	afu_region_init(pdata);
+	mutex_unlock(&pdata->lock);
+	return 0;
+}
+
+static int afu_dev_destroy(struct platform_device *pdev)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct fpga_afu *afu;
+
+	mutex_lock(&pdata->lock);
+	afu = fpga_pdata_get_private(pdata);
+	afu_region_destroy(pdata);
+	fpga_pdata_set_private(pdata, NULL);
+	mutex_unlock(&pdata->lock);
+
+	devm_kfree(&pdev->dev, afu);
+
+	return 0;
+}
+
 static int afu_probe(struct platform_device *pdev)
 {
 	int ret;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
+	ret = afu_dev_init(pdev);
+	if (ret)
+		goto exit;
+
 	ret = fpga_dev_feature_init(pdev, port_feature_drvs);
 	if (ret)
-		return ret;
+		goto dev_destroy;
 
 	ret = fpga_register_dev_ops(pdev, &afu_fops, THIS_MODULE);
-	if (ret)
+	if (ret) {
 		fpga_dev_feature_uinit(pdev);
+		goto dev_destroy;
+	}
+
+	return 0;
 
+dev_destroy:
+	afu_dev_destroy(pdev);
+exit:
 	return ret;
 }
 
@@ -194,6 +398,7 @@ static int afu_remove(struct platform_device *pdev)
 
 	fpga_dev_feature_uinit(pdev);
 	fpga_unregister_dev_ops(pdev);
+	afu_dev_destroy(pdev);
 
 	return 0;
 }
diff --git a/drivers/fpga/dfl-afu-region.c b/drivers/fpga/dfl-afu-region.c
new file mode 100644
index 0000000..1f711ce
--- /dev/null
+++ b/drivers/fpga/dfl-afu-region.c
@@ -0,0 +1,127 @@
+/*
+ * Driver for FPGA Accelerated Function Unit (AFU) Region Management
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Wu Hao <hao.wu@intel.com>
+ *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+#include "dfl-afu.h"
+
+void afu_region_init(struct feature_platform_data *pdata)
+{
+	struct fpga_afu *afu = fpga_pdata_get_private(pdata);
+
+	INIT_LIST_HEAD(&afu->regions);
+}
+
+#define for_each_region(region, afu)	\
+	list_for_each_entry((region), &(afu)->regions, node)
+static struct fpga_afu_region *get_region_by_index(struct fpga_afu *afu,
+						   u32 region_index)
+{
+	struct fpga_afu_region *region;
+
+	for_each_region(region, afu)
+		if (region->index == region_index)
+			return region;
+
+	return NULL;
+}
+
+int afu_region_add(struct feature_platform_data *pdata, u32 region_index,
+		   u64 region_size, u64 phys, u32 flags)
+{
+	struct fpga_afu_region *region;
+	struct fpga_afu *afu;
+	int ret = 0;
+
+	region = devm_kzalloc(&pdata->dev->dev, sizeof(*region), GFP_KERNEL);
+	if (!region)
+		return -ENOMEM;
+
+	region->index = region_index;
+	region->size = region_size;
+	region->phys = phys;
+	region->flags = flags;
+
+	mutex_lock(&pdata->lock);
+
+	afu = fpga_pdata_get_private(pdata);
+
+	/* check if @index already exists */
+	if (get_region_by_index(afu, region_index)) {
+		mutex_unlock(&pdata->lock);
+		ret = -EEXIST;
+		goto exit;
+	}
+
+	region_size = PAGE_ALIGN(region_size);
+	region->offset = afu->region_cur_offset;
+	list_add(&region->node, &afu->regions);
+
+	afu->region_cur_offset += region_size;
+	afu->num_regions++;
+	mutex_unlock(&pdata->lock);
+
+	return 0;
+
+exit:
+	devm_kfree(&pdata->dev->dev, region);
+	return ret;
+}
+
+void afu_region_destroy(struct feature_platform_data *pdata)
+{
+	struct fpga_afu_region *tmp, *region;
+	struct fpga_afu *afu = fpga_pdata_get_private(pdata);
+
+	list_for_each_entry_safe(region, tmp, &afu->regions, node)
+		devm_kfree(&pdata->dev->dev, region);
+}
+
+int afu_get_region_by_index(struct feature_platform_data *pdata,
+			    u32 region_index, struct fpga_afu_region *pregion)
+{
+	struct fpga_afu_region *region;
+	struct fpga_afu *afu;
+	int ret = 0;
+
+	mutex_lock(&pdata->lock);
+	afu = fpga_pdata_get_private(pdata);
+	region = get_region_by_index(afu, region_index);
+	if (!region) {
+		ret = -EINVAL;
+		goto exit;
+	}
+	*pregion = *region;
+exit:
+	mutex_unlock(&pdata->lock);
+	return ret;
+}
+
+int afu_get_region_by_offset(struct feature_platform_data *pdata,
+			     u64 offset, u64 size,
+			     struct fpga_afu_region *pregion)
+{
+	struct fpga_afu_region *region;
+	struct fpga_afu *afu;
+	int ret = 0;
+
+	mutex_lock(&pdata->lock);
+	afu = fpga_pdata_get_private(pdata);
+	for_each_region(region, afu)
+		if (region->offset <= offset &&
+		    region->offset + region->size >= offset + size) {
+			*pregion = *region;
+			goto exit;
+		}
+	ret = -EINVAL;
+exit:
+	mutex_unlock(&pdata->lock);
+	return ret;
+}
diff --git a/drivers/fpga/dfl-afu.h b/drivers/fpga/dfl-afu.h
new file mode 100644
index 0000000..78f9696
--- /dev/null
+++ b/drivers/fpga/dfl-afu.h
@@ -0,0 +1,54 @@
+/*
+ * Header file for FPGA Accelerated Function Unit (AFU) Driver
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *     Wu Hao <hao.wu@intel.com>
+ *     Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *     Joseph Grecco <joe.grecco@intel.com>
+ *     Enno Luebbers <enno.luebbers@intel.com>
+ *     Tim Whisonant <tim.whisonant@intel.com>
+ *     Ananda Ravuri <ananda.ravuri@intel.com>
+ *     Henry Mitchel <henry.mitchel@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#ifndef __DFL_AFU_H
+#define __DFL_AFU_H
+
+#include <linux/mm.h>
+
+#include "fpga-dfl.h"
+
+struct fpga_afu_region {
+	u32 index;
+	u32 flags;
+	u64 size;
+	u64 offset;
+	u64 phys;
+	struct list_head node;
+};
+
+struct fpga_afu {
+	u64 region_cur_offset;
+	int num_regions;
+	u8 num_umsgs;
+	struct list_head regions;
+
+	struct feature_platform_data *pdata;
+};
+
+void afu_region_init(struct feature_platform_data *pdata);
+int afu_region_add(struct feature_platform_data *pdata, u32 region_index,
+		   u64 region_size, u64 phys, u32 flags);
+void afu_region_destroy(struct feature_platform_data *pdata);
+int afu_get_region_by_index(struct feature_platform_data *pdata,
+			    u32 region_index, struct fpga_afu_region *pregion);
+int afu_get_region_by_offset(struct feature_platform_data *pdata,
+			     u64 offset, u64 size,
+			     struct fpga_afu_region *pregion);
+
+#endif
diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-dfl.h
index 9bf273d..78937b0 100644
--- a/include/uapi/linux/fpga-dfl.h
+++ b/include/uapi/linux/fpga-dfl.h
@@ -67,6 +67,53 @@
 
 #define FPGA_PORT_RESET		_IO(FPGA_MAGIC, PORT_BASE + 0)
 
+/**
+ * FPGA_PORT_GET_INFO - _IOR(FPGA_MAGIC, PORT_BASE + 1, struct fpga_port_info)
+ *
+ * Retrieve information about the fpga port.
+ * Driver fills the info in provided struct fpga_port_info.
+ * Return: 0 on success, -errno on failure.
+ */
+struct fpga_port_info {
+	/* Input */
+	__u32 argsz;		/* Structure length */
+	/* Output */
+	__u32 flags;		/* Zero for now */
+	__u32 num_regions;	/* The number of supported regions */
+	__u32 num_umsgs;	/* The number of allocated umsgs */
+};
+
+#define FPGA_PORT_GET_INFO	_IO(FPGA_MAGIC, PORT_BASE + 1)
+
+/**
+ * FPGA_PORT_GET_REGION_INFO - _IOWR(FPGA_MAGIC, PORT_BASE + 2,
+ *						struct fpga_port_region_info)
+ *
+ * Retrieve information about a device region.
+ * Caller provides struct fpga_port_region_info with index value set.
+ * Driver returns the region info in other fields.
+ * Return: 0 on success, -errno on failure.
+ */
+struct fpga_port_region_info {
+	/* input */
+	__u32 argsz;		/* Structure length */
+	/* Output */
+	__u32 flags;		/* Access permission */
+#define FPGA_REGION_READ	(1 << 0)	/* Region is readable */
+#define FPGA_REGION_WRITE	(1 << 1)	/* Region is writable */
+#define FPGA_REGION_MMAP	(1 << 2)	/* Can be mmaped to userspace */
+	/* Input */
+	__u32 index;		/* Region index */
+#define FPGA_PORT_INDEX_UAFU	0		/* User AFU */
+#define FPGA_PORT_INDEX_STP	1		/* Signal Tap */
+	__u32 padding;
+	/* Output */
+	__u64 size;		/* Region size (bytes) */
+	__u64 offset;		/* Region offset from start of device fd */
+};
+
+#define FPGA_PORT_GET_REGION_INFO	_IO(FPGA_MAGIC, PORT_BASE + 2)
+
 /* IOCTLs for FME file descriptor */
 
 /**
-- 
1.8.3.1
