From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 05/24] fpga: dfl: add chardev support for feature devices
Date: Tue, 13 Feb 2018 17:24:34 +0800
Message-ID: <1518513893-4719-6-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

For feature devices drivers, both the FPGA Management Engine (FME) and
Accelerated Function Unit (AFU) driver need to expose user interfaces via
the device file, for example, mmap and ioctls.

This patch adds chardev support in the dfl driver for feature devices,
FME and AFU. It reserves the chardev regions for FME and AFU, and provide
interfaces for FME and AFU driver to register their device file operations.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
v2: rebased
v3: move chardev support to fpga-dfl framework
v4: rebase, and add more comments in code.
---
 drivers/fpga/dfl.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/fpga/dfl.h |  14 ++++++++
 2 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index f50694e..dcfe5ab 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -74,6 +74,96 @@ static enum fpga_id_type feature_dev_id_type(struct platform_device *pdev)
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
+/**
+ * fpga_register_dev_ops - register cdev ops for feature dev
+ *
+ * @pdev: feature dev.
+ * @fops: file operations for feature dev's cdev.
+ * @owner: owning module/driver.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
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
+/**
+ * fpga_unregister_dev_ops - unregister cdev ops for feature dev
+ * @pdev: feature dev.
+ */
+void fpga_unregister_dev_ops(struct platform_device *pdev)
+{
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+
+	cdev_del(&pdata->cdev);
+}
+EXPORT_SYMBOL_GPL(fpga_unregister_dev_ops);
+
 /**
  * struct build_feature_devs_info - info collected during feature dev build.
  *
@@ -207,8 +297,12 @@ build_info_create_dev(struct build_feature_devs_info *binfo,
 		      void __iomem *ioaddr)
 {
 	struct platform_device *fdev;
+	enum fpga_devt_type devt_type = FPGA_DEVT_FME;
 	int ret;
 
+	if (type == PORT_ID)
+		devt_type = FPGA_DEVT_PORT;
+
 	/* we will create a new device, commit current device first */
 	ret = build_info_commit_dev(binfo);
 	if (ret)
@@ -232,6 +326,7 @@ build_info_create_dev(struct build_feature_devs_info *binfo,
 		return fdev->id;
 
 	fdev->dev.parent = &binfo->cdev->region.dev;
+	fdev->dev.devt = fpga_get_devt(devt_type, fdev->id);
 
 	return 0;
 }
@@ -769,13 +864,20 @@ EXPORT_SYMBOL_GPL(__fpga_port_disable);
 
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
 
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index 22dcf73..9b19399 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -15,6 +15,7 @@
 #define __FPGA_DFL_H
 
 #include <linux/bitfield.h>
+#include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/iopoll.h>
@@ -150,6 +151,7 @@ struct feature {
  *
  * @node: node to link feature devs to container device's port_dev_list.
  * @lock: mutex to protect platform data.
+ * @cdev: cdev of feature dev.
  * @dev: ptr to platform device linked with this platform data.
  * @disable_count: count for port disable.
  * @num: number for sub features.
@@ -158,6 +160,7 @@ struct feature {
 struct feature_platform_data {
 	struct list_head node;
 	struct mutex lock;
+	struct cdev cdev;
 	struct platform_device *dev;
 	unsigned int disable_count;
 
@@ -174,6 +177,17 @@ static inline int feature_platform_data_size(const int num)
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
2.7.4
