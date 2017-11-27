From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 05/21] fpga: dfl: add chardev support for feature devices
Date: Mon, 27 Nov 2017 14:42:12 +0800
Message-ID: <1511764948-20972-6-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

For feature devices drivers, both the FPGA Management Engine (FME) and
Accelerated Function Unit (AFU) driver need to expose user interfaces via
the device file, for example, mmap and ioctls.

This patch adds chardev support in the fpga-dfl driver for feature devices,
FME and AFU. It reserves the chardev regions for FME and AFU, and provide
interfaces for FME and AFU driver to register their device file operations.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
----
v2: rebased
v3: move chardev support to fpga-dfl framework
---
 drivers/fpga/fpga-dfl.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/fpga/fpga-dfl.h | 13 +++++++
 2 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/fpga-dfl.c b/drivers/fpga/fpga-dfl.c
index 6609828..9294c0a 100644
--- a/drivers/fpga/fpga-dfl.c
+++ b/drivers/fpga/fpga-dfl.c
@@ -76,6 +76,83 @@ static enum fpga_id_type feature_dev_id_type(struct platform_device *pdev)
 	return FPGA_ID_MAX;
 }
 
+struct fpga_chardev_info {
+	const char *name;
+	dev_t devt;
+};
+
+/* indexed by enum fpga_devt_type */
+struct fpga_chardev_info fpga_chrdevs[] = {
+	{.name = FPGA_FEATURE_DEV_FME},		/* FPGA_DEVT_FME */
+	{.name = FPGA_FEATURE_DEV_PORT},	/* FPGA_DEVT_AFU */
+};
+
+static void fpga_chardev_uinit(void)
+{
+	int i;
+
+	for (i = 0; i < FPGA_DEVT_MAX; i++)
+		if (MAJOR(fpga_chrdevs[i].devt)) {
+			unregister_chrdev_region(fpga_chrdevs[i].devt,
+						 MINORMASK);
+			fpga_chrdevs[i].devt = MKDEV(0, 0);
+		}
+}
+
+static int fpga_chardev_init(void)
+{
+	int i, ret;
+
+	for (i = 0; i < FPGA_DEVT_MAX; i++) {
+		ret = alloc_chrdev_region(&fpga_chrdevs[i].devt, 0, MINORMASK,
+					  fpga_chrdevs[i].name);
+		if (ret)
+			goto exit;
+	}
+
+	return 0;
+
+exit:
+	fpga_chardev_uinit();
+	return ret;
+}
+
+static dev_t fpga_get_devt(enum fpga_devt_type type, int id)
+{
+	WARN_ON(type >= FPGA_DEVT_MAX);
+
+	return MKDEV(MAJOR(fpga_chrdevs[type].devt), id);
+}
+
+int fpga_register_dev_ops(struct platform_device *pdev,
+			  const struct file_operations *fops,
+			  struct module *owner)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+
+	cdev_init(&pdata->cdev, fops);
+	pdata->cdev.owner = owner;
+
+	/*
+	 * set parent to the feature device so that its refcount is
+	 * decreased after the last refcount of cdev is gone, that
+	 * makes sure the feature device is valid during device
+	 * file's life-cycle.
+	 */
+	pdata->cdev.kobj.parent = &pdev->dev.kobj;
+
+	return cdev_add(&pdata->cdev, pdev->dev.devt, 1);
+}
+EXPORT_SYMBOL_GPL(fpga_register_dev_ops);
+
+void fpga_unregister_dev_ops(struct platform_device *pdev)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+
+	cdev_del(&pdata->cdev);
+}
+EXPORT_SYMBOL_GPL(fpga_unregister_dev_ops);
+
 /**
  * build_feature_devs_info - info collected during feature dev build.
  *
@@ -139,8 +216,12 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
 	struct platform_device *fdev;
 	struct resource *res;
 	struct feature_platform_data *pdata;
+	enum fpga_devt_type devt_type = FPGA_DEVT_FME;
 	int ret;
 
+	if (type == PORT_ID)
+		devt_type = FPGA_DEVT_PORT;
+
 	/* we will create a new device, commit current device first */
 	ret = build_info_commit_dev(binfo);
 	if (ret)
@@ -161,6 +242,7 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
 		return fdev->id;
 
 	fdev->dev.parent = &binfo->cdev->region.dev;
+	fdev->dev.devt = fpga_get_devt(devt_type, fdev->id);
 
 	/*
 	 * we do not need to care for the memory which is associated with
@@ -866,13 +948,20 @@ int __fpga_port_disable(struct platform_device *pdev)
 
 static int __init dfl_fpga_init(void)
 {
+	int ret;
+
 	fpga_ids_init();
 
-	return 0;
+	ret = fpga_chardev_init();
+	if (ret)
+		fpga_ids_destroy();
+
+	return ret;
 }
 
 static void __exit dfl_fpga_exit(void)
 {
+	fpga_chardev_uinit();
 	fpga_ids_destroy();
 }
 
diff --git a/drivers/fpga/fpga-dfl.h b/drivers/fpga/fpga-dfl.h
index abcbe57..e569a13 100644
--- a/drivers/fpga/fpga-dfl.h
+++ b/drivers/fpga/fpga-dfl.h
@@ -17,6 +17,7 @@
 #define __DFL_FPGA_H
 
 #include <linux/bitfield.h>
+#include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/iopoll.h>
@@ -185,6 +186,7 @@ struct feature_platform_data {
 	/* list the feature dev to cci_drvdata->port_dev_list. */
 	struct list_head node;
 	struct mutex lock;		/* protect platform data */
+	struct cdev cdev;
 	struct platform_device *dev;
 	unsigned int disable_count;	/* count for port disable */
 
@@ -226,6 +228,17 @@ static inline int feature_platform_data_size(const int num)
 		num * sizeof(struct feature);
 }
 
+enum fpga_devt_type {
+	FPGA_DEVT_FME,
+	FPGA_DEVT_PORT,
+	FPGA_DEVT_MAX,
+};
+
+int fpga_register_dev_ops(struct platform_device *pdev,
+			  const struct file_operations *fops,
+			  struct module *owner);
+void fpga_unregister_dev_ops(struct platform_device *pdev);
+
 int fpga_port_id(struct platform_device *pdev);
 
 static inline int fpga_port_check_id(struct platform_device *pdev,
-- 
1.8.3.1
