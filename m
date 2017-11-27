From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 07/21] fpga: dfl: add feature device infrastructure
Date: Mon, 27 Nov 2017 14:42:14 +0800
Message-ID: <1511764948-20972-8-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
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
----
v2: rebased
v3: use const for feature_ops.
    replace pci related function.
---
 drivers/fpga/fpga-dfl.c | 68 +++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/fpga-dfl.h | 80 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+)

diff --git a/drivers/fpga/fpga-dfl.c b/drivers/fpga/fpga-dfl.c
index ce03b17..1714803 100644
--- a/drivers/fpga/fpga-dfl.c
+++ b/drivers/fpga/fpga-dfl.c
@@ -76,6 +76,74 @@ static enum fpga_id_type feature_dev_id_type(struct platform_device *pdev)
 	return FPGA_ID_MAX;
 }
 
+int fme_feature_to_resource_index(int feature_id)
+{
+	WARN_ON(feature_id >= FME_FEATURE_ID_MAX);
+	return feature_id;
+}
+
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
+			/* skip the feature which is not initialized. */
+			if (!feature->name)
+				continue;
+
+			if (!strcmp(drv->name, feature->name)) {
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
diff --git a/drivers/fpga/fpga-dfl.h b/drivers/fpga/fpga-dfl.h
index 36e2394..e5a1094 100644
--- a/drivers/fpga/fpga-dfl.h
+++ b/drivers/fpga/fpga-dfl.h
@@ -176,12 +176,20 @@
 #define PORT_UAFU_DFH		DFH
 #define PORT_UAFU_SIZE		DFH_SIZE
 
+struct feature_driver {
+	const char *name;
+	const struct feature_ops *ops;
+};
+
 struct feature {
 	const char *name;
 	int resource_index;
 	void __iomem *ioaddr;
+	const struct feature_ops *ops;
 };
 
+#define DEV_STATUS_IN_USE	0
+
 struct feature_platform_data {
 	/* list the feature dev to cci_drvdata->port_dev_list. */
 	struct list_head node;
@@ -189,11 +197,46 @@ struct feature_platform_data {
 	struct cdev cdev;
 	struct platform_device *dev;
 	unsigned int disable_count;	/* count for port disable */
+	unsigned long dev_status;
+
+	void *private;			/* ptr to feature dev private data */
 
 	int num;			/* number of features */
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
 enum fme_feature_id {
 	FME_FEATURE_ID_HEADER = 0x0,
 	FME_FEATURE_ID_THERMAL_MGMT = 0x1,
@@ -228,6 +271,10 @@ static inline int feature_platform_data_size(const int num)
 		num * sizeof(struct feature);
 }
 
+void fpga_dev_feature_uinit(struct platform_device *pdev);
+int fpga_dev_feature_init(struct platform_device *pdev,
+			  struct feature_driver *feature_drvs);
+
 enum fpga_devt_type {
 	FPGA_DEVT_FME,
 	FPGA_DEVT_PORT,
@@ -296,6 +343,15 @@ static inline int fpga_port_reset(struct platform_device *pdev)
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
 static inline void __iomem *
 get_feature_ioaddr_by_index(struct device *dev, int index)
 {
@@ -304,6 +360,21 @@ static inline int fpga_port_reset(struct platform_device *pdev)
 	return pdata->features[index].ioaddr;
 }
 
+static inline bool is_feature_present(struct device *dev, int index)
+{
+	return !!get_feature_ioaddr_by_index(dev, index);
+}
+
+static inline struct device *
+fpga_pdata_to_parent(struct feature_platform_data *pdata)
+{
+	return pdata->dev->dev.parent->parent;
+}
+
+#define fpga_dev_for_each_feature(pdata, feature)			    \
+	for ((feature) = (pdata)->features;				    \
+	   (feature) < (pdata)->features + (pdata)->num; (feature)++)
+
 static inline bool feature_is_fme(void __iomem *base)
 {
 	u64 v = readq(base + DFH);
@@ -391,4 +462,13 @@ struct platform_device *
 
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
 #endif /* __DFL_FPGA_H */
-- 
1.8.3.1
