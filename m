From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH 14/17] fpga: dfl: fme: add thermal management support
Date: Mon, 25 Mar 2019 11:07:41 +0800
Message-ID: <1553483264-5379-15-git-send-email-hao.wu@intel.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Wu Hao <hao.wu@intel.com>, Luwei Kang <luwei.kang@intel.com>, Russ Weight <russell.h.weight@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

This patch adds support to thermal management private feature for DFL
FPGA Management Engine (FME). As thermal throttling is handled by
hardware automatically per pre-defined thresholds, this private
feature driver only provides read-only sysfs interfaces for user
to read temperature, thresholds, threshold policy and other info.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 Documentation/ABI/testing/sysfs-platform-dfl-fme |  56 +++++++
 drivers/fpga/dfl-fme-main.c                      | 202 +++++++++++++++++++++++
 2 files changed, 258 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-fme b/Documentation/ABI/testing/sysfs-platform-dfl-fme
index b8327e9..d3aeb88 100644
--- a/Documentation/ABI/testing/sysfs-platform-dfl-fme
+++ b/Documentation/ABI/testing/sysfs-platform-dfl-fme
@@ -44,3 +44,59 @@ Description:	Read-only. It returns socket_id to indicate which socket
 		this FPGA belongs to, only valid for integrated solution.
 		User only needs this information, in case standard numa node
 		can't provide correct information.
+
+What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/temperature
+Date:		March 2019
+KernelVersion:  5.2
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. It returns temperature (in Celsius) of this FPGA
+		device.
+
+What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold1
+Date:		March 2019
+KernelVersion:  5.2
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. Read this file to get the temperature threshold1
+		(in Celsius).
+
+What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold2
+Date:		March 2019
+KernelVersion:  5.2
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. Read this file to get the temperature threshold2
+		(in Celsius).
+
+What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/trip_threshold
+Date:		March 2019
+KernelVersion:  5.2
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. It returns trip threshold (in Celsius), once FPGA
+		temperature reaches trip threshold, it triggers a fatal event
+		to board management controller (BMC) to shutdown FPGA.
+
+What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold1_status
+Date:		March 2019
+KernelVersion:  5.2
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. It returns 1 if temperature reaches threshold1,
+		otherwise 0. Once temperature reaches threshold1, hardware
+		will automatically enter throttling state (AP1 - 50%
+		or AP2 - 90% throttling, see 'threshold1_policy').
+
+What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold2_status
+Date:		March 2019
+KernelVersion:  5.2
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. It returns 1 if temperature reaches threshold2,
+		otherwise 0. Once temperature reaches threshold2, hardware
+		will automatically enter the deepest throttling state (AP6
+		- 100% throttling).
+
+What:		/sys/bus/platform/devices/dfl-fme.0/thermal_mgmt/threshold1_policy
+Date:		March 2019
+KernelVersion:  5.2
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. Read this file to get the policy of temperature
+		threshold1. It only supports two value (policy):
+		    0 - AP2 state (90% throttling)
+		    1 - AP1 state (50% throttling)
diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
index 8339ee8..449a17d 100644
--- a/drivers/fpga/dfl-fme-main.c
+++ b/drivers/fpga/dfl-fme-main.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/fpga-dfl.h>
+#include <linux/sysfs.h>
 
 #include "dfl.h"
 #include "dfl-fme.h"
@@ -217,6 +218,203 @@ static const struct dfl_feature_ops fme_hdr_ops = {
 	.ioctl = fme_hdr_ioctl,
 };
 
+#define FME_THERM_THRESHOLD	0x8
+#define TEMP_THRESHOLD1		GENMASK_ULL(6, 0)
+#define TEMP_THRESHOLD1_EN	BIT_ULL(7)
+#define TEMP_THRESHOLD2		GENMASK_ULL(14, 8)
+#define TEMP_THRESHOLD2_EN	BIT_ULL(15)
+#define TRIP_THRESHOLD		GENMASK_ULL(30, 24)
+#define TEMP_THRESHOLD1_STATUS	BIT_ULL(32)		/* threshold1 reached */
+#define TEMP_THRESHOLD2_STATUS	BIT_ULL(33)		/* threshold2 reached */
+/* threshold1 policy: 0 - AP2 (90% throttle) / 1 - AP1 (50% throttle) */
+#define TEMP_THRESHOLD1_POLICY	BIT_ULL(44)
+
+#define FME_THERM_RDSENSOR_FMT1	0x10
+#define FPGA_TEMPERATURE	GENMASK_ULL(6, 0)
+
+#define FME_THERM_CAP		0x20
+#define TEMP_THRESHOLD_DISABLE	BIT_ULL(0)
+
+#define THERMAL_ATTR(_name, _mode, _show, _store)	\
+struct device_attribute thermal_attr_##_name =		\
+	__ATTR(_name, _mode, _show, _store)
+
+#define THERMAL_ATTR_RO(_name, _show)			\
+	THERMAL_ATTR(_name, 0444, _show, NULL)
+
+static ssize_t temperature_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_THERMAL_MGMT);
+
+	v = readq(base + FME_THERM_RDSENSOR_FMT1);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(FPGA_TEMPERATURE, v));
+}
+static THERMAL_ATTR_RO(temperature, temperature_show);
+
+static struct attribute *thermal_mgmt_attrs[] = {
+	&thermal_attr_temperature.attr,
+	NULL,
+};
+
+static struct attribute_group thermal_mgmt_attr_group = {
+	.name   = "thermal_mgmt",
+	.attrs	= thermal_mgmt_attrs,
+};
+
+static ssize_t temp_threshold1_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_THERMAL_MGMT);
+
+	v = readq(base + FME_THERM_THRESHOLD);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(TEMP_THRESHOLD1, v));
+}
+static THERMAL_ATTR_RO(threshold1, temp_threshold1_show);
+
+static ssize_t temp_threshold2_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_THERMAL_MGMT);
+
+	v = readq(base + FME_THERM_THRESHOLD);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(TEMP_THRESHOLD2, v));
+}
+static THERMAL_ATTR_RO(threshold2, temp_threshold2_show);
+
+static ssize_t temp_trip_threshold_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_THERMAL_MGMT);
+
+	v = readq(base + FME_THERM_THRESHOLD);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(TRIP_THRESHOLD, v));
+}
+static THERMAL_ATTR_RO(trip_threshold, temp_trip_threshold_show);
+
+static ssize_t temp_threshold1_status_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_THERMAL_MGMT);
+
+	v = readq(base + FME_THERM_THRESHOLD);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(TEMP_THRESHOLD1_STATUS, v));
+}
+static THERMAL_ATTR_RO(threshold1_status, temp_threshold1_status_show);
+
+static ssize_t temp_threshold2_status_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_THERMAL_MGMT);
+
+	v = readq(base + FME_THERM_THRESHOLD);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(TEMP_THRESHOLD2_STATUS, v));
+}
+static THERMAL_ATTR_RO(threshold2_status, temp_threshold2_status_show);
+
+static ssize_t temp_threshold1_policy_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_THERMAL_MGMT);
+
+	v = readq(base + FME_THERM_THRESHOLD);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(TEMP_THRESHOLD1_POLICY, v));
+}
+static THERMAL_ATTR_RO(threshold1_policy, temp_threshold1_policy_show);
+
+static struct attribute *thermal_threshold_attrs[] = {
+	&thermal_attr_threshold1.attr,
+	&thermal_attr_threshold2.attr,
+	&thermal_attr_trip_threshold.attr,
+	&thermal_attr_threshold1_status.attr,
+	&thermal_attr_threshold2_status.attr,
+	&thermal_attr_threshold1_policy.attr,
+	NULL,
+};
+
+static struct attribute_group thermal_threshold_attr_group = {
+	.name   = "thermal_mgmt",
+	.attrs	= thermal_threshold_attrs,
+};
+
+static int fme_thermal_mgmt_init(struct platform_device *pdev,
+				 struct dfl_feature *feature)
+{
+	void __iomem *base = feature->ioaddr;
+	int ret;
+	u64 v;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &thermal_mgmt_attr_group);
+	if (ret)
+		return ret;
+
+	v = readq(base + FME_THERM_CAP);
+	if (FIELD_GET(TEMP_THRESHOLD_DISABLE, v))
+		return 0;
+
+	ret = sysfs_merge_group(&pdev->dev.kobj, &thermal_threshold_attr_group);
+	if (ret)
+		sysfs_remove_group(&pdev->dev.kobj, &thermal_mgmt_attr_group);
+
+	return ret;
+}
+
+static void fme_thermal_mgmt_uinit(struct platform_device *pdev,
+				   struct dfl_feature *feature)
+{
+	sysfs_unmerge_group(&pdev->dev.kobj, &thermal_threshold_attr_group);
+	sysfs_remove_group(&pdev->dev.kobj, &thermal_mgmt_attr_group);
+}
+
+static const struct dfl_feature_id fme_thermal_mgmt_id_table[] = {
+	{.id = FME_FEATURE_ID_THERMAL_MGMT,},
+	{0,}
+};
+
+static const struct dfl_feature_ops fme_thermal_mgmt_ops = {
+	.init = fme_thermal_mgmt_init,
+	.uinit = fme_thermal_mgmt_uinit,
+};
+
 static struct dfl_feature_driver fme_feature_drvs[] = {
 	{
 		.id_table = fme_hdr_id_table,
@@ -227,6 +425,10 @@ static struct dfl_feature_driver fme_feature_drvs[] = {
 		.ops = &fme_pr_mgmt_ops,
 	},
 	{
+		.id_table = fme_thermal_mgmt_id_table,
+		.ops = &fme_thermal_mgmt_ops,
+	},
+	{
 		.ops = NULL,
 	},
 };
-- 
2.7.4
