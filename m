From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 08/11] coresight-etm4x: Controls pertaining to the counter functions
Date: Wed, 22 Apr 2015 16:40:48 -0600
Message-ID: <1429742451-11465-9-git-send-email-mathieu.poirier@linaro.org>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

Adding sysfs entries related to the counter functionality, more specifically
to set, control and reload the counters.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  26 ++++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 144 +++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 44723f2e107e..b4581c9426d3 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -216,3 +216,29 @@ KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
 Description: 	(RW) Moves the sequencer to state 0 when a programmed event
 		occurs.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/cntr_idx
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Select which counter unit to work with.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/cntrldvr
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) This sets or returns the reload count value of the
+		specific counter.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/cntr_val
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) This sets or returns the current count value of the
+                specific counter.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/cntr_ctrl
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Controls the operation of the selected counter.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 7d2af2926967..309f0c282392 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1567,6 +1567,146 @@ static ssize_t seq_reset_event_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(seq_reset_event);
 
+static ssize_t cntr_idx_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->cntr_idx;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t cntr_idx_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val >= drvdata->nr_cntr)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->cntr_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_idx);
+
+static ssize_t cntrldvr_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->cntr_idx;
+	val = drvdata->cntrldvr[idx];
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t cntrldvr_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val > ETM_CNTR_MAX_VAL)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->cntr_idx;
+	drvdata->cntrldvr[idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(cntrldvr);
+
+static ssize_t cntr_val_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->cntr_idx;
+	val = drvdata->cntr_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t cntr_val_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val > ETM_CNTR_MAX_VAL)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->cntr_idx;
+	drvdata->cntr_val[idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_val);
+
+static ssize_t cntr_ctrl_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->cntr_idx;
+	val = drvdata->cntr_ctrl[idx];
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t cntr_ctrl_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->cntr_idx;
+	drvdata->cntr_ctrl[idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(cntr_ctrl);
+
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -1743,6 +1883,10 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_seq_state.attr,
 	&dev_attr_seq_event.attr,
 	&dev_attr_seq_reset_event.attr,
+	&dev_attr_cntr_idx.attr,
+	&dev_attr_cntrldvr.attr,
+	&dev_attr_cntr_val.attr,
+	&dev_attr_cntr_ctrl.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
