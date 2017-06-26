From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 21/22] fpga: intel: afu: add user afu sub feature support
Date: Mon, 26 Jun 2017 09:52:17 +0800
Message-ID: <1498441938-14046-22-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

User Accelerated Function Unit sub feature exposes the MMIO region of
the AFU. After valid green bitstream (GBS) is programmed and port is
enabled, then this MMIO region could be accessed.

This patch adds support to enumerate the AFU MMIO region and expose it
to userspace via mmap file operation. Below interfaces are exposed to user:

Sysfs interface:
* /sys/class/fpga/<fpga.x>/<intel-fpga-port.x>/afu_id
  Read-only. Indicate which green bitstream is programmed to this AFU.

Ioctl interfaces:
* FPGA_PORT_GET_INFO
  Provide info to userspace on the number of supported region.
  Only UAFU region is supported now.

* FPGA_PORT_GET_REGION_INFO
  Provide region information, including access permission, region size,
  offset from the start of device fd.

Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
    add sysfs documentation.
    switched to GPLv2 license.
---
 .../ABI/testing/sysfs-platform-intel-fpga-afu      |   9 +
 drivers/fpga/Makefile                              |   2 +-
 drivers/fpga/intel-afu-main.c                      | 204 ++++++++++++++++++++-
 drivers/fpga/intel-afu-region.c                    | 127 +++++++++++++
 drivers/fpga/intel-afu.h                           |  52 ++++++
 include/uapi/linux/intel-fpga.h                    |  47 +++++
 6 files changed, 437 insertions(+), 4 deletions(-)
 create mode 100644 drivers/fpga/intel-afu-region.c
 create mode 100644 drivers/fpga/intel-afu.h

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-fpga-afu b/Documentation/ABI/testing/sysfs-platform-intel-fpga-afu
index 8ad22c9..6cd8781 100644
--- a/Documentation/ABI/testing/sysfs-platform-intel-fpga-afu
+++ b/Documentation/ABI/testing/sysfs-platform-intel-fpga-afu
@@ -5,3 +5,12 @@ Contact:	Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 Description:	Read-only. It returns id of this port. One Intel FPGA device
 		may have more than one port. Userspace could use this id to
 		distinguish different ports under same FPGA device.
+
+What:		/sys/bus/platform/devices/intel-fpga-port.0/afu_id
+Date:		June 2017
+KernelVersion:  4.12
+Contact:	Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+Description:	Read-only. User can program different green bitstreams (GBS) to
+		FPGA Accelerator Function Unit (AFU) for different functions.
+		It returns uuid which could be used to identify which GBS is
+		programmed in this AFU.
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index ce08833..45c0538 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -38,4 +38,4 @@ obj-$(CONFIG_INTEL_FPGA_AFU)		+= intel-fpga-afu.o
 
 intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
 intel-fpga-fme-objs := intel-fme-main.o intel-fme-pr.o
-intel-fpga-afu-objs := intel-afu-main.o
+intel-fpga-afu-objs := intel-afu-main.o intel-afu-region.o
diff --git a/drivers/fpga/intel-afu-main.c b/drivers/fpga/intel-afu-main.c
index 22f77f2..8c7aa70 100644
--- a/drivers/fpga/intel-afu-main.c
+++ b/drivers/fpga/intel-afu-main.c
@@ -18,9 +18,10 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include <linux/intel-fpga.h>
 
-#include "intel-feature-dev.h"
+#include "intel-afu.h"
 
 static ssize_t
 id_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -80,12 +81,69 @@ struct feature_ops port_hdr_ops = {
 	.ioctl = port_hdr_ioctl,
 };
 
+static ssize_t
+afu_id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(dev);
+	struct feature_port_header *port_hdr =
+			get_feature_ioaddr_by_index(dev, PORT_FEATURE_ID_UAFU);
+	u64 guidl;
+	u64 guidh;
+
+	mutex_lock(&pdata->lock);
+	guidl = readq(&port_hdr->afu_header.guid.b[0]);
+	guidh = readq(&port_hdr->afu_header.guid.b[8]);
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
+					struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "PORT AFU UInit.\n");
+
+	sysfs_remove_files(&pdev->dev.kobj, port_uafu_attrs);
+}
+
+struct feature_ops port_uafu_ops = {
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
@@ -129,6 +187,64 @@ static long afu_ioctl_check_extension(struct feature_platform_data *pdata,
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
@@ -143,6 +259,10 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
@@ -163,27 +283,104 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
 
@@ -193,6 +390,7 @@ static int afu_remove(struct platform_device *pdev)
 
 	fpga_dev_feature_uinit(pdev);
 	fpga_unregister_dev_ops(pdev);
+	afu_dev_destroy(pdev);
 	return 0;
 }
 
diff --git a/drivers/fpga/intel-afu-region.c b/drivers/fpga/intel-afu-region.c
new file mode 100644
index 0000000..702275b
--- /dev/null
+++ b/drivers/fpga/intel-afu-region.c
@@ -0,0 +1,127 @@
+/*
+ * Driver for Intel FPGA Accelerated Function Unit (AFU) Region Management
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2. See
+ * the COPYING file in the top-level directory.
+ */
+
+#include "intel-afu.h"
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
+			    u64 offset, u64 size,
+			    struct fpga_afu_region *pregion)
+{
+	struct fpga_afu_region *region;
+	struct fpga_afu *afu;
+	int ret = 0;
+
+	mutex_lock(&pdata->lock);
+	afu = fpga_pdata_get_private(pdata);
+	for_each_region(region, afu)
+		if (region->offset <= offset &&
+		   region->offset + region->size >= offset + size) {
+			*pregion = *region;
+			goto exit;
+		}
+	ret = -EINVAL;
+exit:
+	mutex_unlock(&pdata->lock);
+	return ret;
+}
diff --git a/drivers/fpga/intel-afu.h b/drivers/fpga/intel-afu.h
new file mode 100644
index 0000000..3417780d
--- /dev/null
+++ b/drivers/fpga/intel-afu.h
@@ -0,0 +1,52 @@
+/*
+ * Header file for Intel FPGA Accelerated Function Unit (AFU) Driver
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *     Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *     Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *     Joseph Grecco <joe.grecco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *     Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *     Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *     Ananda Ravuri <ananda.ravuri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *     Henry Mitchel <henry.mitchel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2. See
+ * the COPYING file in the top-level directory.
+ */
+
+#ifndef __INTEL_AFU_H
+#define __INTEL_AFU_H
+
+#include "intel-feature-dev.h"
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
+			    u64 offset, u64 size,
+			    struct fpga_afu_region *pregion);
+
+#endif
diff --git a/include/uapi/linux/intel-fpga.h b/include/uapi/linux/intel-fpga.h
index be5f813..a2ad332 100644
--- a/include/uapi/linux/intel-fpga.h
+++ b/include/uapi/linux/intel-fpga.h
@@ -64,6 +64,53 @@
 
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
