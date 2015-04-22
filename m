From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 10/11] coresight-etm4x: Controls pertaining to the context ID functions
Date: Wed, 22 Apr 2015 16:40:50 -0600
Message-ID: <1429742451-11465-11-git-send-email-mathieu.poirier@linaro.org>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429742451-11465-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Adding sysfs entries to access and configure specifics about the
context ID comparator functions.

Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  19 +++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 187 +++++++++++++++++++++
 2 files changed, 206 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index b5c0456290ab..8b32cb7b9723 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -254,3 +254,22 @@ Date:		April 2015
 KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description: 	(RW) Controls the selection of the resources in the trace unit.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/ctxid_idx
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description:	(RW) Select which context ID comparator to work with.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/ctxid_val
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description:	(RW) Get/Set the context ID comparator value to trigger on.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/ctxid_masks
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description:	(RW) Mask for all 8 context ID comparator value
+		registers (if implemented).
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 67f3b71ea8dc..9bae7b158b20 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1780,6 +1780,190 @@ static ssize_t res_ctrl_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(res_ctrl);
 
+static ssize_t ctxid_idx_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->ctxid_idx;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t ctxid_idx_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val >= drvdata->numcidc)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->ctxid_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(ctxid_idx);
+
+static ssize_t ctxid_val_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->ctxid_idx;
+	val = (unsigned long)drvdata->ctxid_val[idx];
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t ctxid_val_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	u8 idx;
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	/*
+	 * only implemented when ctxid tracing is enabled, i.e. at least one
+	 * ctxid comparator is implemented and ctxid is greater than 0 bits
+	 * in length
+	 */
+	if (!drvdata->ctxid_size || !drvdata->numcidc)
+		return -EINVAL;
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	idx = drvdata->ctxid_idx;
+	drvdata->ctxid_val[idx] = (u64)val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(ctxid_val);
+
+static ssize_t ctxid_masks_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned long val1, val2;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	val1 = drvdata->ctxid_mask0;
+	val2 = drvdata->ctxid_mask1;
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx %#lx\n", val1, val2);
+}
+
+static ssize_t ctxid_masks_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	u8 i, j, maskbyte;
+	unsigned long val1, val2, mask;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	/*
+	 * only implemented when ctxid tracing is enabled, i.e. at least one
+	 * ctxid comparator is implemented and ctxid is greater than 0 bits
+	 * in length
+	 */
+	if (!drvdata->ctxid_size || !drvdata->numcidc)
+		return -EINVAL;
+	if (sscanf(buf, "%lx %lx", &val1, &val2) != 2)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	/*
+	 * each byte[0..3] controls mask value applied to ctxid
+	 * comparator[0..3]
+	 */
+	switch (drvdata->numcidc) {
+	case 0x1:
+		/* COMP0, bits[7:0] */
+		drvdata->ctxid_mask0 = val1 & 0xFF;
+		break;
+	case 0x2:
+		/* COMP1, bits[15:8] */
+		drvdata->ctxid_mask0 = val1 & 0xFFFF;
+		break;
+	case 0x3:
+		/* COMP2, bits[23:16] */
+		drvdata->ctxid_mask0 = val1 & 0xFFFFFF;
+		break;
+	case 0x4:
+		 /* COMP3, bits[31:24] */
+		drvdata->ctxid_mask0 = val1;
+		break;
+	case 0x5:
+		/* COMP4, bits[7:0] */
+		drvdata->ctxid_mask0 = val1;
+		drvdata->ctxid_mask1 = val2 & 0xFF;
+		break;
+	case 0x6:
+		/* COMP5, bits[15:8] */
+		drvdata->ctxid_mask0 = val1;
+		drvdata->ctxid_mask1 = val2 & 0xFFFF;
+		break;
+	case 0x7:
+		/* COMP6, bits[23:16] */
+		drvdata->ctxid_mask0 = val1;
+		drvdata->ctxid_mask1 = val2 & 0xFFFFFF;
+		break;
+	case 0x8:
+		/* COMP7, bits[31:24] */
+		drvdata->ctxid_mask0 = val1;
+		drvdata->ctxid_mask1 = val2;
+		break;
+	default:
+		break;
+	}
+	/*
+	 * If software sets a mask bit to 1, it must program relevant byte
+	 * of ctxid comparator value 0x0, otherwise behavior is unpredictable.
+	 * For example, if bit[3] of ctxid_mask0 is 1, we must clear bits[31:24]
+	 * of ctxid comparator0 value (corresponding to byte 0) register.
+	 */
+	mask = drvdata->ctxid_mask0;
+	for (i = 0; i < drvdata->numcidc; i++) {
+		/* mask value of corresponding ctxid comparator */
+		maskbyte = mask & ETMv4_EVENT_MASK;
+		/*
+		 * each bit corresponds to a byte of respective ctxid comparator
+		 * value register
+		 */
+		for (j = 0; j < 8; j++) {
+			if (maskbyte & 1)
+				drvdata->ctxid_val[i] &= ~(0xFF << (j * 8));
+			maskbyte >>= 1;
+		}
+		/* Select the next ctxid comparator mask value */
+		if (i == 3)
+			/* ctxid comparators[4-7] */
+			mask = drvdata->ctxid_mask1;
+		else
+			mask >>= 0x8;
+	}
+
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(ctxid_masks);
+
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -1962,6 +2146,9 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_cntr_ctrl.attr,
 	&dev_attr_res_idx.attr,
 	&dev_attr_res_ctrl.attr,
+	&dev_attr_ctxid_idx.attr,
+	&dev_attr_ctxid_val.attr,
+	&dev_attr_ctxid_masks.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
