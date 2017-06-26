From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 10/22] fpga: intel: add feature device infrastructure
Date: Mon, 26 Jun 2017 09:52:06 +0800
Message-ID: <1498441938-14046-11-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

This patch abstracts the common operations of the sub features, and defines
the feature_ops data structure, including init, uinit and ioctl function
pointers. And this patch adds some common helper functions for FME and AFU
drivers, e.g feature_dev_use_begin/end which are used to ensure exclusive
usage of the feature device file.

Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v2: rebased
---
 drivers/fpga/intel-feature-dev.c | 66 +++++++++++++++++++++++++++++++++++++
 drivers/fpga/intel-feature-dev.h | 71 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/drivers/fpga/intel-feature-dev.c b/drivers/fpga/intel-feature-dev.c
index 45788fe..833bfa9 100644
--- a/drivers/fpga/intel-feature-dev.c
+++ b/drivers/fpga/intel-feature-dev.c
@@ -51,6 +51,72 @@ int port_feature_num(void)
 	return PORT_FEATURE_ID_MAX;
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
diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
index 06b3fb6..635b857 100644
--- a/drivers/fpga/intel-feature-dev.h
+++ b/drivers/fpga/intel-feature-dev.h
@@ -221,12 +221,20 @@ struct feature_port_stp {
 
 #pragma pack()
 
+struct feature_driver {
+	const char *name;
+	struct feature_ops *ops;
+};
+
 struct feature {
 	const char *name;
 	int resource_index;
 	void __iomem *ioaddr;
+	struct feature_ops *ops;
 };
 
+#define DEV_STATUS_IN_USE	0
+
 struct feature_platform_data {
 	/* list the feature dev to cci_drvdata->port_dev_list. */
 	struct list_head node;
@@ -234,6 +242,9 @@ struct feature_platform_data {
 	struct cdev cdev;
 	struct platform_device *dev;
 	unsigned int disable_count;	/* count for port disable */
+	unsigned long dev_status;
+
+	void *private;			/* ptr to feature dev private data */
 
 	struct platform_device *(*fpga_for_each_port)(struct platform_device *,
 			void *, int (*match)(struct platform_device *, void *));
@@ -242,6 +253,38 @@ struct feature_platform_data {
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
+				unsigned int cmd, unsigned long arg);
+};
+
 enum fme_feature_id {
 	FME_FEATURE_ID_HEADER = 0x0,
 	FME_FEATURE_ID_THERMAL_MGMT = 0x1,
@@ -281,6 +324,10 @@ static inline int feature_platform_data_size(const int num)
 struct feature_platform_data *
 feature_platform_data_alloc_and_init(struct platform_device *dev, int num);
 
+void fpga_dev_feature_uinit(struct platform_device *pdev);
+int fpga_dev_feature_init(struct platform_device *pdev,
+			  struct feature_driver *feature_drvs);
+
 enum fpga_devt_type {
 	FPGA_DEVT_FME,
 	FPGA_DEVT_PORT,
@@ -350,6 +397,15 @@ static inline int fpga_port_reset(struct platform_device *pdev)
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
@@ -358,9 +414,24 @@ static inline int fpga_port_reset(struct platform_device *pdev)
 	return pdata->features[index].ioaddr;
 }
 
+static inline bool is_feature_present(struct device *dev, int index)
+{
+	return !!get_feature_ioaddr_by_index(dev, index);
+}
+
 static inline struct device *
 fpga_feature_dev_to_pcidev(struct platform_device *dev)
 {
 	return dev->dev.parent->parent;
 }
+
+static inline struct device *
+fpga_pdata_to_pcidev(struct feature_platform_data *pdata)
+{
+	return fpga_feature_dev_to_pcidev(pdata->dev);
+}
+
+#define fpga_dev_for_each_feature(pdata, feature)			    \
+	for ((feature) = (pdata)->features;				    \
+	   (feature) < (pdata)->features + (pdata)->num; (feature)++)
 #endif
-- 
1.8.3.1
