From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 04/13] coresight-etm4x: Controls pertaining to various configuration options
Date: Wed, 13 May 2015 10:34:12 -0600
Message-ID: <1431534861-24986-5-git-send-email-mathieu.poirier@linaro.org>
References: <1431534861-24986-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431534861-24986-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Adding sysfs entries to configure:
. global timestamp.
. how often trace synchronisation occur.
. the threashold value for cycle counting.
. branch and broadcasting regions.

Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  26 +++++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 124 +++++++++++++++++++++
 2 files changed, 150 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 7917a180cfc6..7e5f9bf1d508 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -108,3 +108,29 @@ Date:		April 2015
 KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description: 	(RW) Controls the behavior of the events in bank 0 to 3.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/event_ts
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RW) Controls the insertion of global timestamps in the trace
+		streams.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/syncfreq
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RW) Controls how often trace synchronization requests occur.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/cyc_threshold
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RW) Sets the threshold value for cycle counting.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/bb_ctrl
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RW) Controls which regions in the memory map are enabled to
+		use branch broadcasting.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index e9f58a5d2934..51fbda837026 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -812,6 +812,126 @@ static ssize_t event_instren_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(event_instren);
 
+static ssize_t event_ts_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->ts_ctrl;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t event_ts_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (!drvdata->ts_size)
+		return -EINVAL;
+
+	drvdata->ts_ctrl = val & ETMv4_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(event_ts);
+
+static ssize_t syncfreq_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->syncfreq;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t syncfreq_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (drvdata->syncpr == true)
+		return -EINVAL;
+
+	drvdata->syncfreq = val & ETMv4_SYNC_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(syncfreq);
+
+static ssize_t cyc_threshold_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->ccctlr;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t cyc_threshold_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val < drvdata->ccitmin)
+		return -EINVAL;
+
+	drvdata->ccctlr = val & ETM_CYC_THRESHOLD_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(cyc_threshold);
+
+static ssize_t bb_ctrl_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->bb_ctrl;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t bb_ctrl_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (drvdata->trcbb == false)
+		return -EINVAL;
+	if (!drvdata->nr_addr_cmp)
+		return -EINVAL;
+	/*
+	 * Bit[7:0] selects which address range comparator is used for
+	 * branch broadcast control.
+	 */
+	if (BMVAL(val, 0, 7) > drvdata->nr_addr_cmp)
+		return -EINVAL;
+
+	drvdata->bb_ctrl = val;
+	return size;
+}
+static DEVICE_ATTR_RW(bb_ctrl);
+
 static ssize_t cpu_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -839,6 +959,10 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_pe.attr,
 	&dev_attr_event.attr,
 	&dev_attr_event_instren.attr,
+	&dev_attr_event_ts.attr,
+	&dev_attr_syncfreq.attr,
+	&dev_attr_cyc_threshold.attr,
+	&dev_attr_bb_ctrl.attr,
 	&dev_attr_cpu.attr,
 	NULL,
 };
-- 
1.9.1
