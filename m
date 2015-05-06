From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH v3 09/11] coresight-etm4x: Controls pertaining to the selection of resources
Date: Wed,  6 May 2015 09:27:25 -0600
Message-ID: <1430926047-9125-10-git-send-email-mathieu.poirier@linaro.org>
References: <1430926047-9125-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430926047-9125-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

Adding sysfs entries to control the selection of the resources the
trace unit will use as triggers to perform a trace run.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  | 12 ++++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 75 ++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index b4581c9426d3..b5c0456290ab 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -242,3 +242,15 @@ Date:		April 2015
 KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
 Description: 	(RW) Controls the operation of the selected counter.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/res_idx
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Select which resource selection unit to work with.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/res_ctrl
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Controls the selection of the resources in the trace unit.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 7d22a630ec8a..d578500f937d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1707,6 +1707,79 @@ static ssize_t cntr_ctrl_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(cntr_ctrl);
 
+static ssize_t res_idx_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->res_idx;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t res_idx_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	/* Resource selector pair 0 is always implemented and reserved */
+	if ((val == 0) || (val >= drvdata->nr_resource))
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->res_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(res_idx);
+
+static ssize_t res_ctrl_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->res_idx;
+	val = drvdata->res_ctrl[idx];
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t res_ctrl_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->res_idx;
+	/* For odd idx pair inversal bit is RES0 */
+	if (idx % 2 != 0)
+		/* PAIRINV, bit[21] */
+		val &= ~BIT(21);
+	drvdata->res_ctrl[idx] = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(res_ctrl);
+
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -1887,6 +1960,8 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_cntrldvr.attr,
 	&dev_attr_cntr_val.attr,
 	&dev_attr_cntr_ctrl.attr,
+	&dev_attr_res_idx.attr,
+	&dev_attr_res_ctrl.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
