From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH v2 04/11] coresight-etm4x: Controls pertaining to various
 configuration options
Date: Wed, 29 Apr 2015 11:16:28 -0600
Message-ID: <1430327795-10710-5-git-send-email-mathieu.poirier@linaro.org>
References: <1430327795-10710-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1430327795-10710-1-git-send-email-mathieu.poirier@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: gregkh@linuxfoundation.org
Cc: mathieu.poirier@linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, zhang.chunyan@linaro.org, linux-arm-kernel@lists.infradead.org, kaixu.xia@linaro.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

Adding sysfs entries to configure:
. global timestamp.
. how often trace synchronisation occur.
. the threashold value for cycle counting.
. branch and broadcasting regions.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  28 ++++-
 drivers/hwtracing/coresight/coresight-etm4x.c      | 124 +++++++++++++++++++++
 2 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 9caf70382088..2aeae2976c10 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -119,4 +119,30 @@ What:		/sys/bus/coresight/devices/<memory_map>.etm/event_instren
 Date:		April 2015
 KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
-Description: 	(RW) Controls the behavior of the events in bank 0 to 3.
+Description: 	(RW) Controls the behavior of the events in bank 0 to 3
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/event_ts
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Controls the insertion of global timestamps in the trace
+		streams.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/syncfreq
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Controls how often trace synchronization requests occur.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/cyc_threshold
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Sets the threshold value for cycle counting.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/bb_ctrl
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Controls which regions in the memory map are enabled to
+		use branch broadcasting.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 4d58b41bb27c..f69e4652a357 100644
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
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -969,6 +1089,10 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_pe.attr,
 	&dev_attr_event.attr,
 	&dev_attr_event_instren.attr,
+	&dev_attr_event_ts.attr,
+	&dev_attr_syncfreq.attr,
+	&dev_attr_cyc_threshold.attr,
+	&dev_attr_bb_ctrl.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
