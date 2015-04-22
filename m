From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 07/11] coresight-etm4x: Controls pertaining to the sequencer functions
Date: Wed, 22 Apr 2015 16:40:47 -0600
Message-ID: <1429742451-11465-8-git-send-email-mathieu.poirier@linaro.org>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

Adding sysfs entries to access the sequencers related registers,
more specifically the sequencer state, the sequencer state
transition and the sequencer reset control registers.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  25 ++++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 129 +++++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 8cdc4ad10bd6..44723f2e107e 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -191,3 +191,28 @@ Date:		April 2015
 KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
 Description: 	(RW) Used to setup address range comparator values.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/seq_idx
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Select which sequensor.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/seq_state
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Use this to set, or read, the sequencer state.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/seq_event
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Moves the sequencer state to a specific state.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/seq_reset_event
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Moves the sequencer to state 0 when a programmed event
+		occurs.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 439b37109279..7d2af2926967 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1442,6 +1442,131 @@ static ssize_t addr_context_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(addr_context);
 
+static ssize_t seq_idx_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_idx;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t seq_idx_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val >= drvdata->nrseqstate - 1)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->seq_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(seq_idx);
+
+static ssize_t seq_state_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_state;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t seq_state_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val >= drvdata->nrseqstate)
+		return -EINVAL;
+
+	drvdata->seq_state = val;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_state);
+
+static ssize_t seq_event_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->seq_idx;
+	val = drvdata->seq_ctrl[idx];
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t seq_event_store(struct device *dev,
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
+	idx = drvdata->seq_idx;
+	/* RST, bits[7:0] */
+	drvdata->seq_ctrl[idx] = val & 0xFF;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(seq_event);
+
+static ssize_t seq_reset_event_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->seq_rst;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t seq_reset_event_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (!(drvdata->nrseqstate))
+		return -EINVAL;
+
+	drvdata->seq_rst = val & ETMv4_EVENT_MASK;
+	return size;
+}
+static DEVICE_ATTR_RW(seq_reset_event);
+
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -1614,6 +1739,10 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_addr_stop.attr,
 	&dev_attr_addr_ctxtype.attr,
 	&dev_attr_addr_context.attr,
+	&dev_attr_seq_idx.attr,
+	&dev_attr_seq_state.attr,
+	&dev_attr_seq_event.attr,
+	&dev_attr_seq_reset_event.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
