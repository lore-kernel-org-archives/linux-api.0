From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v6 09/29] fpga: dfl: add feature device infrastructure
Date: Tue, 12 Jun 2018 18:10:23 +0800
Message-ID: <1528798243-2029-10-git-send-email-hao.wu@intel.com>
References: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528798243-2029-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

From: Xiao Guangrong <guangrong.xiao@linux.intel.com>

This patch abstracts the common operations of the sub features, and defines
the feature_ops data structure, including init, uinit and ioctl function
pointers. And this patch adds some common helper functions for FME and AFU
drivers, e.g dfl_feature_dev_use_begin/end which are used to ensure
exclusive usage of the feature device file.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Kang Luwei <luwei.kang@intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
---
v2: rebased
v3: use const for feature_ops.
    replace pci related function.
v4: rebase and add more comments in code.
v5: remove useless WARN_ON().
    reorder declarations in functions per suggestion from Moritz.
    add "dfl_" prefix to functions and data structure.
v6: add comments for init/uinit function.
    add Acked-by from Alan.
---
 drivers/fpga/dfl.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/dfl.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index 5db4d11..e8bd331 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -136,6 +136,77 @@ static enum dfl_id_type dfh_id_to_type(u32 id)
 	return DFL_ID_MAX;
 }
 
+/**
+ * dfl_fpga_dev_feature_uinit - uinit for sub features of dfl feature device
+ * @pdev: feature device.
+ */
+void dfl_fpga_dev_feature_uinit(struct platform_device *pdev)
+{
+	struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct dfl_feature *feature;
+
+	dfl_fpga_dev_for_each_feature(pdata, feature)
+		if (feature->ops) {
+			feature->ops->uinit(pdev, feature);
+			feature->ops = NULL;
+		}
+}
+EXPORT_SYMBOL_GPL(dfl_fpga_dev_feature_uinit);
+
+static int dfl_feature_instance_init(struct platform_device *pdev,
+				     struct dfl_feature_platform_data *pdata,
+				     struct dfl_feature *feature,
+				     struct dfl_feature_driver *drv)
+{
+	int ret;
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
+/**
+ * dfl_fpga_dev_feature_init - init for sub features of dfl feature device
+ * @pdev: feature device.
+ * @feature_drvs: drvs for sub features.
+ *
+ * This function will match sub features with given feature drvs list, and
+ * use matched drv to init related sub feature.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int dfl_fpga_dev_feature_init(struct platform_device *pdev,
+			      struct dfl_feature_driver *feature_drvs)
+{
+	struct dfl_feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct dfl_feature_driver *drv = feature_drvs;
+	struct dfl_feature *feature;
+	int ret;
+
+	while (drv->ops) {
+		dfl_fpga_dev_for_each_feature(pdata, feature) {
+			/* match feature and drv using id */
+			if (feature->id == drv->id) {
+				ret = dfl_feature_instance_init(pdev, pdata,
+								feature, drv);
+				if (ret)
+					goto exit;
+			}
+		}
+		drv++;
+	}
+
+	return 0;
+exit:
+	dfl_fpga_dev_feature_uinit(pdev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dfl_fpga_dev_feature_init);
+
 static void dfl_chardev_uinit(void)
 {
 	int i;
diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
index b4f6525..974d603 100644
--- a/drivers/fpga/dfl.h
+++ b/drivers/fpga/dfl.h
@@ -132,6 +132,17 @@
 #define PORT_CTRL_SFTRST_ACK	BIT_ULL(4)		/* HW ack for reset */
 
 /**
+ * struct dfl_feature_driver - sub feature's driver
+ *
+ * @id: sub feature id.
+ * @ops: ops of this sub feature.
+ */
+struct dfl_feature_driver {
+	u64 id;
+	const struct dfl_feature_ops *ops;
+};
+
+/**
  * struct dfl_feature - sub feature of the feature devices
  *
  * @id: sub feature id.
@@ -139,13 +150,17 @@
  *		    this index is used to find its mmio resource from the
  *		    feature dev (platform device)'s reources.
  * @ioaddr: mapped mmio resource address.
+ * @ops: ops of this sub feature.
  */
 struct dfl_feature {
 	u64 id;
 	int resource_index;
 	void __iomem *ioaddr;
+	const struct dfl_feature_ops *ops;
 };
 
+#define DEV_STATUS_IN_USE	0
+
 /**
  * struct dfl_feature_platform_data - platform data for feature devices
  *
@@ -156,6 +171,8 @@ struct dfl_feature {
  * @dfl_cdev: ptr to container device.
  * @disable_count: count for port disable.
  * @num: number for sub features.
+ * @dev_status: dev status (e.g DEV_STATUS_IN_USE).
+ * @private: ptr to feature dev private data.
  * @features: sub features of this feature dev.
  */
 struct dfl_feature_platform_data {
@@ -165,11 +182,49 @@ struct dfl_feature_platform_data {
 	struct platform_device *dev;
 	struct dfl_fpga_cdev *dfl_cdev;
 	unsigned int disable_count;
-
+	unsigned long dev_status;
+	void *private;
 	int num;
 	struct dfl_feature features[0];
 };
 
+static inline
+int dfl_feature_dev_use_begin(struct dfl_feature_platform_data *pdata)
+{
+	/* Test and set IN_USE flags to ensure file is exclusively used */
+	if (test_and_set_bit_lock(DEV_STATUS_IN_USE, &pdata->dev_status))
+		return -EBUSY;
+
+	return 0;
+}
+
+static inline
+void dfl_feature_dev_use_end(struct dfl_feature_platform_data *pdata)
+{
+	clear_bit_unlock(DEV_STATUS_IN_USE, &pdata->dev_status);
+}
+
+static inline
+void dfl_fpga_pdata_set_private(struct dfl_feature_platform_data *pdata,
+				void *private)
+{
+	pdata->private = private;
+}
+
+static inline
+void *dfl_fpga_pdata_get_private(struct dfl_feature_platform_data *pdata)
+{
+	return pdata->private;
+}
+
+struct dfl_feature_ops {
+	int (*init)(struct platform_device *pdev, struct dfl_feature *feature);
+	void (*uinit)(struct platform_device *pdev,
+		      struct dfl_feature *feature);
+	long (*ioctl)(struct platform_device *pdev, struct dfl_feature *feature,
+		      unsigned int cmd, unsigned long arg);
+};
+
 #define DFL_FPGA_FEATURE_DEV_FME		"dfl-fme"
 #define DFL_FPGA_FEATURE_DEV_PORT		"dfl-port"
 
@@ -179,11 +234,25 @@ static inline int dfl_feature_platform_data_size(const int num)
 		num * sizeof(struct dfl_feature);
 }
 
+void dfl_fpga_dev_feature_uinit(struct platform_device *pdev);
+int dfl_fpga_dev_feature_init(struct platform_device *pdev,
+			      struct dfl_feature_driver *feature_drvs);
+
 int dfl_fpga_dev_ops_register(struct platform_device *pdev,
 			      const struct file_operations *fops,
 			      struct module *owner);
 void dfl_fpga_dev_ops_unregister(struct platform_device *pdev);
 
+static inline
+struct platform_device *dfl_fpga_inode_to_feature_dev(struct inode *inode)
+{
+	struct dfl_feature_platform_data *pdata;
+
+	pdata = container_of(inode->i_cdev, struct dfl_feature_platform_data,
+			     cdev);
+	return pdata->dev;
+}
+
 #define dfl_fpga_dev_for_each_feature(pdata, feature)			    \
 	for ((feature) = (pdata)->features;				    \
 	   (feature) < (pdata)->features + (pdata)->num; (feature)++)
@@ -213,6 +282,17 @@ void __iomem *dfl_get_feature_ioaddr_by_id(struct device *dev, u64 id)
 	return NULL;
 }
 
+static inline bool is_dfl_feature_present(struct device *dev, u64 id)
+{
+	return !!dfl_get_feature_ioaddr_by_id(dev, id);
+}
+
+static inline
+struct device *dfl_fpga_pdata_to_parent(struct dfl_feature_platform_data *pdata)
+{
+	return pdata->dev->dev.parent->parent;
+}
+
 static inline bool dfl_feature_is_fme(void __iomem *base)
 {
 	u64 v = readq(base + DFH);
-- 
1.8.3.1
