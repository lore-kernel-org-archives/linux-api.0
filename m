From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 11/11] coresight-etm4x: Controls pertaining to the VM ID functions
Date: Wed,  6 May 2015 09:27:27 -0600
Message-ID: <1430926047-9125-12-git-send-email-mathieu.poirier@linaro.org>
References: <1430926047-9125-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430926047-9125-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Adding sysfs entries to access and configure specifics about the
virtual machine ID comparator functions.

Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  20 +++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 178 +++++++++++++++++++++
 2 files changed, 198 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 8b32cb7b9723..eb5153891919 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -273,3 +273,23 @@ KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description:	(RW) Mask for all 8 context ID comparator value
 		registers (if implemented).
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/vmid_idx
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description:	(RW) Select which virtual machine ID comparator to work with.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/vmid_val
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description:	(RW) Get/Set the virtual machine ID comparator value to
+		trigger on.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/vmid_masks
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description:	(RW) Mask for all 8 virtual machine ID comparator value
+		registers (if implemented).
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index da1b3cdb0413..15bf5be5004a 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -1964,6 +1964,181 @@ static ssize_t ctxid_masks_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(ctxid_masks);
 
+static ssize_t vmid_idx_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->vmid_idx;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t vmid_idx_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+	if (val >= drvdata->numvmidc)
+		return -EINVAL;
+
+	/*
+	 * Use spinlock to ensure index doesn't change while it gets
+	 * dereferenced multiple times within a spinlock block elsewhere.
+	 */
+	spin_lock(&drvdata->spinlock);
+	drvdata->vmid_idx = val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(vmid_idx);
+
+static ssize_t vmid_val_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = (unsigned long)drvdata->vmid_val[drvdata->vmid_idx];
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t vmid_val_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	/*
+	 * only implemented when vmid tracing is enabled, i.e. at least one
+	 * vmid comparator is implemented and at least 8 bit vmid size
+	 */
+	if (!drvdata->vmid_size || !drvdata->numvmidc)
+		return -EINVAL;
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	drvdata->vmid_val[drvdata->vmid_idx] = (u64)val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(vmid_val);
+
+static ssize_t vmid_masks_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	unsigned long val1, val2;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	spin_lock(&drvdata->spinlock);
+	val1 = drvdata->vmid_mask0;
+	val2 = drvdata->vmid_mask1;
+	spin_unlock(&drvdata->spinlock);
+	return scnprintf(buf, PAGE_SIZE, "%#lx %#lx\n", val1, val2);
+}
+
+static ssize_t vmid_masks_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	u8 i, j, maskbyte;
+	unsigned long val1, val2, mask;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+	/*
+	 * only implemented when vmid tracing is enabled, i.e. at least one
+	 * vmid comparator is implemented and at least 8 bit vmid size
+	 */
+	if (!drvdata->vmid_size || !drvdata->numvmidc)
+		return -EINVAL;
+	if (sscanf(buf, "%lx %lx", &val1, &val2) != 2)
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+
+	/*
+	 * each byte[0..3] controls mask value applied to vmid
+	 * comparator[0..3]
+	 */
+	switch (drvdata->numvmidc) {
+	case 0x1:
+		/* COMP0, bits[7:0] */
+		drvdata->vmid_mask0 = val1 & 0xFF;
+		break;
+	case 0x2:
+		/* COMP1, bits[15:8] */
+		drvdata->vmid_mask0 = val1 & 0xFFFF;
+		break;
+	case 0x3:
+		/* COMP2, bits[23:16] */
+		drvdata->vmid_mask0 = val1 & 0xFFFFFF;
+		break;
+	case 0x4:
+		/* COMP3, bits[31:24] */
+		drvdata->vmid_mask0 = val1;
+		break;
+	case 0x5:
+		/* COMP4, bits[7:0] */
+		drvdata->vmid_mask0 = val1;
+		drvdata->vmid_mask1 = val2 & 0xFF;
+		break;
+	case 0x6:
+		/* COMP5, bits[15:8] */
+		drvdata->vmid_mask0 = val1;
+		drvdata->vmid_mask1 = val2 & 0xFFFF;
+		break;
+	case 0x7:
+		/* COMP6, bits[23:16] */
+		drvdata->vmid_mask0 = val1;
+		drvdata->vmid_mask1 = val2 & 0xFFFFFF;
+		break;
+	case 0x8:
+		/* COMP7, bits[31:24] */
+		drvdata->vmid_mask0 = val1;
+		drvdata->vmid_mask1 = val2;
+		break;
+	default:
+		break;
+	}
+
+	/*
+	 * If software sets a mask bit to 1, it must program relevant byte
+	 * of vmid comparator value 0x0, otherwise behavior is unpredictable.
+	 * For example, if bit[3] of vmid_mask0 is 1, we must clear bits[31:24]
+	 * of vmid comparator0 value (corresponding to byte 0) register.
+	 */
+	mask = drvdata->vmid_mask0;
+	for (i = 0; i < drvdata->numvmidc; i++) {
+		/* mask value of corresponding vmid comparator */
+		maskbyte = mask & ETMv4_EVENT_MASK;
+		/*
+		 * each bit corresponds to a byte of respective vmid comparator
+		 * value register
+		 */
+		for (j = 0; j < 8; j++) {
+			if (maskbyte & 1)
+				drvdata->vmid_val[i] &= ~(0xFF << (j * 8));
+			maskbyte >>= 1;
+		}
+		/* Select the next vmid comparator mask value */
+		if (i == 3)
+			/* vmid comparators[4-7] */
+			mask = drvdata->vmid_mask1;
+		else
+			mask >>= 0x8;
+	}
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(vmid_masks);
+
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -2149,6 +2324,9 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_ctxid_idx.attr,
 	&dev_attr_ctxid_val.attr,
 	&dev_attr_ctxid_masks.attr,
+	&dev_attr_vmid_idx.attr,
+	&dev_attr_vmid_val.attr,
+	&dev_attr_vmid_masks.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
