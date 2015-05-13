From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 05/13] coresight-etm4x: Controls pertaining to the ViewInst register
Date: Wed, 13 May 2015 10:34:13 -0600
Message-ID: <1431534861-24986-6-git-send-email-mathieu.poirier@linaro.org>
References: <1431534861-24986-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431534861-24986-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Adding sysfs entries to control the ViewInst register's event
selector along with secure and non-secure exception level
instruction tracing.

Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  | 20 +++++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 98 ++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 7e5f9bf1d508..ca0a51838e35 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -134,3 +134,23 @@ KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description: 	(RW) Controls which regions in the memory map are enabled to
 		use branch broadcasting.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/event_vinst
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RW) Controls instruction trace filtering.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/s_exlevel_vinst
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RW) In Secure state, each bit controls whether instruction
+		tracing is enabled for the corresponding exception level.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/ns_exlevel_vinst
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RW) In non-secure state, each bit controls whether instruction
+		tracing is enabled for the corresponding exception level.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 51fbda837026..e44cc8464134 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -932,6 +932,101 @@ static ssize_t bb_ctrl_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(bb_ctrl);
 
+static ssize_t event_vinst_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->vinst_ctrl & ETMv4_EVENT_MASK;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t event_vinst_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	val &= ETMv4_EVENT_MASK;
+	drvdata->vinst_ctrl &= ~ETMv4_EVENT_MASK;
+	drvdata->vinst_ctrl |= val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(event_vinst);
+
+static ssize_t s_exlevel_vinst_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = BMVAL(drvdata->vinst_ctrl, 16, 19);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t s_exlevel_vinst_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	/* clear all EXLEVEL_S bits (bit[18] is never implemented) */
+	drvdata->vinst_ctrl &= ~(BIT(16) | BIT(17) | BIT(19));
+	/* enable instruction tracing for corresponding exception level */
+	val &= drvdata->s_ex_level;
+	drvdata->vinst_ctrl |= (val << 16);
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(s_exlevel_vinst);
+
+static ssize_t ns_exlevel_vinst_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	/* EXLEVEL_NS, bits[23:20] */
+	val = BMVAL(drvdata->vinst_ctrl, 20, 23);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t ns_exlevel_vinst_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	/* clear EXLEVEL_NS bits (bit[23] is never implemented */
+	drvdata->vinst_ctrl &= ~(BIT(20) | BIT(21) | BIT(22));
+	/* enable instruction tracing for corresponding exception level */
+	val &= drvdata->ns_ex_level;
+	drvdata->vinst_ctrl |= (val << 20);
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(ns_exlevel_vinst);
+
 static ssize_t cpu_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -963,6 +1058,9 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_syncfreq.attr,
 	&dev_attr_cyc_threshold.attr,
 	&dev_attr_bb_ctrl.attr,
+	&dev_attr_event_vinst.attr,
+	&dev_attr_s_exlevel_vinst.attr,
+	&dev_attr_ns_exlevel_vinst.attr,
 	&dev_attr_cpu.attr,
 	NULL,
 };
-- 
1.9.1
