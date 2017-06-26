From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v2 08/22] fpga: intel: pcie: add chardev support for feature devices
Date: Mon, 26 Jun 2017 09:52:04 +0800
Message-ID: <1498441938-14046-9-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

From: Xiao Guangrong <guangrong.xiao@linux.intel.com>

For feature devices drivers, both the FPGA Management Engine (FME) and
Accelerated Function Unit (AFU) driver need to expose user interfaces via
the device file, for example, mmap and ioctls.

This patch adds chardev support in the pcie driver for feature devices,
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
---
 drivers/fpga/intel-feature-dev.c | 76 ++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/intel-feature-dev.h | 16 +++++++++
 drivers/fpga/intel-pcie.c        | 18 +++++++++-
 3 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/intel-feature-dev.c b/drivers/fpga/intel-feature-dev.c
index 68f9cba..45788fe 100644
--- a/drivers/fpga/intel-feature-dev.c
+++ b/drivers/fpga/intel-feature-dev.c
@@ -51,6 +51,82 @@ int port_feature_num(void)
 	return PORT_FEATURE_ID_MAX;
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
+void fpga_chardev_uinit(void)
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
+int fpga_chardev_init(void)
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
+dev_t fpga_get_devt(enum fpga_devt_type type, int id)
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
 int fpga_port_id(struct platform_device *pdev)
 {
 	struct feature_port_header *port_hdr;
diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
index f67784a..d64a51e 100644
--- a/drivers/fpga/intel-feature-dev.h
+++ b/drivers/fpga/intel-feature-dev.h
@@ -17,6 +17,7 @@
 #define __INTEL_FPGA_FEATURE_H
 
 #include <linux/fs.h>
+#include <linux/cdev.h>
 #include <linux/pci.h>
 #include <linux/uuid.h>
 #include <linux/delay.h>
@@ -230,6 +231,7 @@ struct feature_platform_data {
 	/* list the feature dev to cci_drvdata->port_dev_list. */
 	struct list_head node;
 	struct mutex lock;
+	struct cdev cdev;
 	struct platform_device *dev;
 	unsigned int disable_count;	/* count for port disable */
 
@@ -276,6 +278,20 @@ static inline int feature_platform_data_size(const int num)
 struct feature_platform_data *
 feature_platform_data_alloc_and_init(struct platform_device *dev, int num);
 
+enum fpga_devt_type {
+	FPGA_DEVT_FME,
+	FPGA_DEVT_PORT,
+	FPGA_DEVT_MAX,
+};
+
+void fpga_chardev_uinit(void);
+int fpga_chardev_init(void);
+dev_t fpga_get_devt(enum fpga_devt_type type, int id);
+int fpga_register_dev_ops(struct platform_device *pdev,
+			  const struct file_operations *fops,
+			  struct module *owner);
+void fpga_unregister_dev_ops(struct platform_device *pdev);
+
 int fpga_port_id(struct platform_device *pdev);
 
 static inline int fpga_port_check_id(struct platform_device *pdev,
diff --git a/drivers/fpga/intel-pcie.c b/drivers/fpga/intel-pcie.c
index 70b8284..54c0e3a 100644
--- a/drivers/fpga/intel-pcie.c
+++ b/drivers/fpga/intel-pcie.c
@@ -274,8 +274,12 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
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
@@ -294,6 +298,7 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
 		return fdev->id;
 
 	fdev->dev.parent = &binfo->parent_dev->dev;
+	fdev->dev.devt = fpga_get_devt(devt_type, fdev->id);
 
 	/*
 	 * we do not need to care for the memory which is associated with
@@ -942,16 +947,27 @@ static int __init ccidrv_init(void)
 
 	fpga_ids_init();
 
+	ret = fpga_chardev_init();
+	if (ret)
+		goto exit_ids;
+
 	ret = pci_register_driver(&cci_pci_driver);
 	if (ret)
-		fpga_ids_destroy();
+		goto exit_chardev;
 
+	return 0;
+
+exit_chardev:
+	fpga_chardev_uinit();
+exit_ids:
+	fpga_ids_destroy();
 	return ret;
 }
 
 static void __exit ccidrv_exit(void)
 {
 	pci_unregister_driver(&cci_pci_driver);
+	fpga_chardev_uinit();
 	fpga_ids_destroy();
 }
 
-- 
1.8.3.1
