From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] coresight: etm3x: breaking down sysFS status interface
Date: Fri, 18 Sep 2015 08:49:22 -0600
Message-ID: <1442587762-1880-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

SysFS rules stipulate that only one value can be conveyed per
file.  As such splitting the "status" interface in individual files.

This is also be useful for user space application - that way they can
probe each file individually rather than having to parse a list of entries.

Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm3x  |  77 ++++++++++++++--
 drivers/hwtracing/coresight/coresight-etm3x.c      | 100 +++++++++++----------
 2 files changed, 121 insertions(+), 56 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
index d72ca1736ba4..67e3557bc4bf 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
@@ -8,13 +8,6 @@ Description:	(RW) Enable/disable tracing on this specific trace entiry.
 		of coresight components linking the source to the sink is
 		configured and managed automatically by the coresight framework.
 
-What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/status
-Date:		November 2014
-KernelVersion:	3.19
-Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
-Description:	(R) List various control and status registers.  The specific
-		layout and content is driver specific.
-
 What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/addr_idx
 Date:		November 2014
 KernelVersion:	3.19
@@ -251,3 +244,73 @@ Date:		November 2014
 KernelVersion:	3.19
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description: 	(RW) Define the event that controls the trigger.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmccr
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Configuration Code register
+		(0x004).  The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmccer
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Configuration Code Extension
+		register (0x1e8).  The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmscr
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM System Configuration
+		register (0x014).  The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmidr
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM ID register (0x1e4).  The
+		value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmcr
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Main Control register (0x000).
+		The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmtraceidr
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Trace ID register (0x200).
+		The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmteevr
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Trace Enable Event register
+		(0x020). The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmtsscr
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Trace Start/Stop Conrol
+		register (0x018). The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmtecr1
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Enable Conrol #1
+		register (0x024). The value is read directly from the HW.
+
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmtecr2
+Date:		September 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description: 	(RO) Print the content of the ETM Enable Conrol #2
+		register (0x01c). The value is read directly from the HW.
diff --git a/drivers/hwtracing/coresight/coresight-etm3x.c b/drivers/hwtracing/coresight/coresight-etm3x.c
index 4797f56e7f13..87374b3388ad 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x.c
@@ -313,14 +313,6 @@ static void etm_enable_hw(void *info)
 	dev_dbg(drvdata->dev, "cpu: %d enable smp call done\n", drvdata->cpu);
 }
 
-static int etm_trace_id_simple(struct etm_drvdata *drvdata)
-{
-	if (!drvdata->enable)
-		return drvdata->traceid;
-
-	return (etm_readl(drvdata, ETMTRACEIDR) & ETM_TRACEID_MASK);
-}
-
 static int etm_trace_id(struct coresight_device *csdev)
 {
 	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
@@ -1506,45 +1498,6 @@ static ssize_t timestamp_event_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(timestamp_event);
 
-static ssize_t status_show(struct device *dev,
-			   struct device_attribute *attr, char *buf)
-{
-	int ret;
-	unsigned long flags;
-	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
-
-	pm_runtime_get_sync(drvdata->dev);
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-
-	CS_UNLOCK(drvdata->base);
-	ret = sprintf(buf,
-		      "ETMCCR: 0x%08x\n"
-		      "ETMCCER: 0x%08x\n"
-		      "ETMSCR: 0x%08x\n"
-		      "ETMIDR: 0x%08x\n"
-		      "ETMCR: 0x%08x\n"
-		      "ETMTRACEIDR: 0x%08x\n"
-		      "Enable event: 0x%08x\n"
-		      "Enable start/stop: 0x%08x\n"
-		      "Enable control: CR1 0x%08x CR2 0x%08x\n"
-		      "CPU affinity: %d\n",
-		      drvdata->etmccr, drvdata->etmccer,
-		      etm_readl(drvdata, ETMSCR), etm_readl(drvdata, ETMIDR),
-		      etm_readl(drvdata, ETMCR), etm_trace_id_simple(drvdata),
-		      etm_readl(drvdata, ETMTEEVR),
-		      etm_readl(drvdata, ETMTSSCR),
-		      etm_readl(drvdata, ETMTECR1),
-		      etm_readl(drvdata, ETMTECR2),
-		      drvdata->cpu);
-	CS_LOCK(drvdata->base);
-
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	pm_runtime_put(drvdata->dev);
-
-	return ret;
-}
-static DEVICE_ATTR_RO(status);
-
 static ssize_t cpu_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -1631,12 +1584,61 @@ static struct attribute *coresight_etm_attrs[] = {
 	&dev_attr_ctxid_mask.attr,
 	&dev_attr_sync_freq.attr,
 	&dev_attr_timestamp_event.attr,
-	&dev_attr_status.attr,
 	&dev_attr_traceid.attr,
 	&dev_attr_cpu.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(coresight_etm);
+
+#define coresight_simple_func(name, offset)                             \
+static ssize_t name##_show(struct device *_dev,                         \
+			   struct device_attribute *attr, char *buf)    \
+{                                                                       \
+	struct etm_drvdata *drvdata = dev_get_drvdata(_dev->parent);    \
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n",                      \
+			 readl_relaxed(drvdata->base + offset));        \
+}                                                                       \
+DEVICE_ATTR_RO(name)
+
+coresight_simple_func(etmccr, ETMCCR);
+coresight_simple_func(etmccer, ETMCCER);
+coresight_simple_func(etmscr, ETMSCR);
+coresight_simple_func(etmidr, ETMIDR);
+coresight_simple_func(etmcr, ETMCR);
+coresight_simple_func(etmtraceidr, ETMTRACEIDR);
+coresight_simple_func(etmteevr, ETMTEEVR);
+coresight_simple_func(etmtssvr, ETMTSSCR);
+coresight_simple_func(etmtecr1, ETMTECR1);
+coresight_simple_func(etmtecr2, ETMTECR2);
+
+static struct attribute *coresight_etm_mgmt_attrs[] = {
+	&dev_attr_etmccr.attr,
+	&dev_attr_etmccer.attr,
+	&dev_attr_etmscr.attr,
+	&dev_attr_etmidr.attr,
+	&dev_attr_etmcr.attr,
+	&dev_attr_etmtraceidr.attr,
+	&dev_attr_etmteevr.attr,
+	&dev_attr_etmtssvr.attr,
+	&dev_attr_etmtecr1.attr,
+	&dev_attr_etmtecr2.attr,
+	NULL,
+};
+
+static const struct attribute_group coresight_etm_group = {
+	.attrs = coresight_etm_attrs,
+};
+
+
+static const struct attribute_group coresight_etm_mgmt_group = {
+	.attrs = coresight_etm_mgmt_attrs,
+	.name = "mgmt",
+};
+
+static const struct attribute_group *coresight_etm_groups[] = {
+	&coresight_etm_group,
+	&coresight_etm_mgmt_group,
+	NULL,
+};
 
 static int etm_cpu_callback(struct notifier_block *nfb, unsigned long action,
 			    void *hcpu)
-- 
1.9.1
