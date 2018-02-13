From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 07/24] fpga: dfl: add feature device infrastructure
Date: Tue, 13 Feb 2018 17:24:36 +0800
Message-ID: <1518513893-4719-8-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

From: Xiao Guangrong <guangrong.xiao@linux.intel.com>

This patch abstracts the common operations of the sub features, and defines
the feature_ops data structure, including init, uinit and ioctl function
pointers. And this patch adds some common helper functions for FME and AFU
drivers, e.g feature_dev_use_begin/end which are used to ensure exclusive
usage of the feature device file.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Kang Luwei <luwei.kang@intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
v2: rebased
v3: use const for feature_ops.
    replace pci related function.
v4: rebase and add more comments in code.
---
 drivers/fpga/dfl.c | 59 +++++++++++++++++++++++++++++++++++++
 drivers/fpga/dfl.h | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index 38dc819..c0aad87 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -74,6 +74,65 @@ static enum fpga_id_type feature_dev_id_type(struct platform_device *pdev)
 	return FPGA_ID_MAX;
 }
 
+void fpga_dev_feature_uinit(struct platform_device *pdev)
+{
+	struct feature *feature;
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+
+	fpga_dev_for_each_feature(pdata, feature)
+		if (feature->ops) {
+			feature->ops->uinit(pdev, feature);
+			feature->ops = NULL;
+		}
+}
+EXPORT_SYMBOL_GPL(fpga_dev_feature_uinit);
+
+static int
+feature_instance_init(struct platform_device *pdev,
+		      struct feature_platform_data *pdata,
+		      struct feature *feature, struct feature_driver *drv)
+{
+	int ret;
+
+	WARN_ON(!feature->ioaddr);
+
+	ret = drv->ops->init(pdev, feature);
+	if (ret)
+		return ret;
+
+	feature->ops = drv->ops;
+
+	return ret;
+}
+
+int fpga_dev_feature_init(struct platform_device *pdev,
+			  struct feature_driver *feature_drvs)
+{
+	struct feature *feature;
+	struct feature_driver *drv = feature_drvs;
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	int ret;
+
+	while (drv->ops) {
+		fpga_dev_for_each_feature(pdata, feature) {
+			/* match feature and drv using id */
+			if (feature->id == drv->id) {
+				ret = feature_instance_init(pdev, pdata,
+							    feature, drv);
+				if (ret)
+					goto exit;
+			}
+		}
+		drv++;
+	}
+
+	return 0;
+exit:
+	fpga_dev_feature_uinit(pdev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_dev_feature_init);
+
 struct fpga_chardev_info {
 	const char *name;
 	dev_t devt;
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index d6ecda1..ede1e95 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -132,6 +132,17 @@
 #define PORT_CTRL_SFTRST_ACK	BIT(4)			/* HW ack for reset */
 
 /**
+ * struct feature_driver - sub feature's driver
+ *
+ * @id:	sub feature id.
+ * @ops: ops of this sub feature.
+ */
+struct feature_driver {
+	u64 id;
+	const struct feature_ops *ops;
+};
+
+/**
  * struct feature - sub feature of the feature devices
  *
  * @id:	sub feature id.
@@ -139,13 +150,17 @@
  *		    this index is used to find its mmio resource from the
  *		    feature dev (platform device)'s reources.
  * @ioaddr: mapped mmio resource address.
+ * @ops: ops of this sub feature.
  */
 struct feature {
 	u64 id;
 	int resource_index;
 	void __iomem *ioaddr;
+	const struct feature_ops *ops;
 };
 
+#define DEV_STATUS_IN_USE	0
+
 /**
  * struct feature_platform_data - platform data for feature devices
  *
@@ -155,6 +170,8 @@ struct feature {
  * @dev: ptr to platform device linked with this platform data.
  * @disable_count: count for port disable.
  * @num: number for sub features.
+ * @dev_status: dev status (e.g DEV_STATUS_IN_USE).
+ * @private: ptr to feature dev private data.
  * @features: sub features of this feature dev.
  */
 struct feature_platform_data {
@@ -163,11 +180,44 @@ struct feature_platform_data {
 	struct cdev cdev;
 	struct platform_device *dev;
 	unsigned int disable_count;
-
+	unsigned long dev_status;
+	void *private;
 	int num;
 	struct feature features[0];
 };
 
+static inline int feature_dev_use_begin(struct feature_platform_data *pdata)
+{
+	/* Test and set IN_USE flags to ensure file is exclusively used */
+	if (test_and_set_bit_lock(DEV_STATUS_IN_USE, &pdata->dev_status))
+		return -EBUSY;
+
+	return 0;
+}
+
+static inline void feature_dev_use_end(struct feature_platform_data *pdata)
+{
+	clear_bit_unlock(DEV_STATUS_IN_USE, &pdata->dev_status);
+}
+
+static inline void
+fpga_pdata_set_private(struct feature_platform_data *pdata, void *private)
+{
+	pdata->private = private;
+}
+
+static inline void *fpga_pdata_get_private(struct feature_platform_data *pdata)
+{
+	return pdata->private;
+}
+
+struct feature_ops {
+	int (*init)(struct platform_device *pdev, struct feature *feature);
+	void (*uinit)(struct platform_device *pdev, struct feature *feature);
+	long (*ioctl)(struct platform_device *pdev, struct feature *feature,
+		      unsigned int cmd, unsigned long arg);
+};
+
 #define FPGA_FEATURE_DEV_FME		"dfl-fme"
 #define FPGA_FEATURE_DEV_PORT		"dfl-port"
 
@@ -177,6 +227,10 @@ static inline int feature_platform_data_size(const int num)
 		num * sizeof(struct feature);
 }
 
+void fpga_dev_feature_uinit(struct platform_device *pdev);
+int fpga_dev_feature_init(struct platform_device *pdev,
+			  struct feature_driver *feature_drvs);
+
 enum fpga_devt_type {
 	FPGA_DEVT_FME,
 	FPGA_DEVT_PORT,
@@ -257,6 +311,15 @@ static inline int fpga_port_reset(struct platform_device *pdev)
 	return ret;
 }
 
+static inline
+struct platform_device *fpga_inode_to_feature_dev(struct inode *inode)
+{
+	struct feature_platform_data *pdata;
+
+	pdata = container_of(inode->i_cdev, struct feature_platform_data, cdev);
+	return pdata->dev;
+}
+
 #define fpga_dev_for_each_feature(pdata, feature)			    \
 	for ((feature) = (pdata)->features;				    \
 	   (feature) < (pdata)->features + (pdata)->num; (feature)++)
@@ -284,6 +347,17 @@ static inline void __iomem *get_feature_ioaddr_by_id(struct device *dev, u64 id)
 	return NULL;
 }
 
+static inline bool is_feature_present(struct device *dev, u64 id)
+{
+	return !!get_feature_ioaddr_by_id(dev, id);
+}
+
+static inline struct device *
+fpga_pdata_to_parent(struct feature_platform_data *pdata)
+{
+	return pdata->dev->dev.parent->parent;
+}
+
 static inline bool feature_is_fme(void __iomem *base)
 {
 	u64 v = readq(base + DFH);
@@ -376,4 +450,13 @@ fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
 
 	return pdev;
 }
+
+static inline struct fpga_cdev *
+fpga_pdata_to_fpga_cdev(struct feature_platform_data *pdata)
+{
+	struct device *dev = pdata->dev->dev.parent;
+	struct fpga_region *region = to_fpga_region(dev);
+
+	return container_of(region, struct fpga_cdev, region);
+}
 #endif /* __FPGA_DFL_H */
-- 
2.7.4
