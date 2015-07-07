From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/5] coresight-etm4x: Change the name of the ctxid_val to ctxid_pid
Date: Tue,  7 Jul 2015 16:41:55 +0800
Message-ID: <1436258518-9339-3-git-send-email-zhang.chunyan@linaro.org>
References: <1436258518-9339-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436258518-9339-1-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge.broslavsky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

'ctxid_val' array was used to store the value of ETM context ID comparator
which actually stores the process ID to be traced, so using 'ctxid_pid' as
its name instead make it easier to understand.

This patch also changes the ABI, it is normally not allowed, but
fortunately it is a testing ABI and very new for now. Nevertheless,
if you don't think it should be changed, we could always add an alias
for userspace.

Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x    |  2 +-
 drivers/hwtracing/coresight/coresight-etm4x.c        | 20 ++++++++++----------
 drivers/hwtracing/coresight/coresight-etm4x.h        |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 2fe2e3d..2355ed8 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -249,7 +249,7 @@ KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description:	(RW) Select which context ID comparator to work with.
 
-What:		/sys/bus/coresight/devices/<memory_map>.etm/ctxid_val
+What:		/sys/bus/coresight/devices/<memory_map>.etm/ctxid_pid
 Date:		April 2015
 KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index 1312e99..9afbda5 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -155,7 +155,7 @@ static void etm4_enable_hw(void *info)
 			       drvdata->base + TRCACATRn(i));
 	}
 	for (i = 0; i < drvdata->numcidc; i++)
-		writeq_relaxed(drvdata->ctxid_val[i],
+		writeq_relaxed(drvdata->ctxid_pid[i],
 			       drvdata->base + TRCCIDCVRn(i));
 	writel_relaxed(drvdata->ctxid_mask0, drvdata->base + TRCCIDCCTLR0);
 	writel_relaxed(drvdata->ctxid_mask1, drvdata->base + TRCCIDCCTLR1);
@@ -507,7 +507,7 @@ static ssize_t reset_store(struct device *dev,
 
 	drvdata->ctxid_idx = 0x0;
 	for (i = 0; i < drvdata->numcidc; i++)
-		drvdata->ctxid_val[i] = 0x0;
+		drvdata->ctxid_pid[i] = 0x0;
 	drvdata->ctxid_mask0 = 0x0;
 	drvdata->ctxid_mask1 = 0x0;
 
@@ -1815,7 +1815,7 @@ static ssize_t ctxid_idx_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(ctxid_idx);
 
-static ssize_t ctxid_val_show(struct device *dev,
+static ssize_t ctxid_pid_show(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
 {
@@ -1825,12 +1825,12 @@ static ssize_t ctxid_val_show(struct device *dev,
 
 	spin_lock(&drvdata->spinlock);
 	idx = drvdata->ctxid_idx;
-	val = (unsigned long)drvdata->ctxid_val[idx];
+	val = (unsigned long)drvdata->ctxid_pid[idx];
 	spin_unlock(&drvdata->spinlock);
 	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
 }
 
-static ssize_t ctxid_val_store(struct device *dev,
+static ssize_t ctxid_pid_store(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t size)
 {
@@ -1850,11 +1850,11 @@ static ssize_t ctxid_val_store(struct device *dev,
 
 	spin_lock(&drvdata->spinlock);
 	idx = drvdata->ctxid_idx;
-	drvdata->ctxid_val[idx] = (u64)val;
+	drvdata->ctxid_pid[idx] = (u64)val;
 	spin_unlock(&drvdata->spinlock);
 	return size;
 }
-static DEVICE_ATTR_RW(ctxid_val);
+static DEVICE_ATTR_RW(ctxid_pid);
 
 static ssize_t ctxid_masks_show(struct device *dev,
 				struct device_attribute *attr,
@@ -1949,7 +1949,7 @@ static ssize_t ctxid_masks_store(struct device *dev,
 		 */
 		for (j = 0; j < 8; j++) {
 			if (maskbyte & 1)
-				drvdata->ctxid_val[i] &= ~(0xFF << (j * 8));
+				drvdata->ctxid_pid[i] &= ~(0xFF << (j * 8));
 			maskbyte >>= 1;
 		}
 		/* Select the next ctxid comparator mask value */
@@ -2193,7 +2193,7 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_res_idx.attr,
 	&dev_attr_res_ctrl.attr,
 	&dev_attr_ctxid_idx.attr,
-	&dev_attr_ctxid_val.attr,
+	&dev_attr_ctxid_pid.attr,
 	&dev_attr_ctxid_masks.attr,
 	&dev_attr_vmid_idx.attr,
 	&dev_attr_vmid_val.attr,
@@ -2514,7 +2514,7 @@ static void etm4_init_default_data(struct etmv4_drvdata *drvdata)
 	}
 
 	for (i = 0; i < drvdata->numcidc; i++)
-		drvdata->ctxid_val[i] = 0x0;
+		drvdata->ctxid_pid[i] = 0x0;
 	drvdata->ctxid_mask0 = 0x0;
 	drvdata->ctxid_mask1 = 0x0;
 
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index e08e983..1e8fb36 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -265,7 +265,7 @@
  * @addr_type:	Current status of the comparator register.
  * @ctxid_idx:	Context ID index selector.
  * @ctxid_size:	Size of the context ID field to consider.
- * @ctxid_val:	Value of the context ID comparator.
+ * @ctxid_pid:	Value of the context ID comparator.
  * @ctxid_mask0:Context ID comparator mask for comparator 0-3.
  * @ctxid_mask1:Context ID comparator mask for comparator 4-7.
  * @vmid_idx:	VM ID index selector.
@@ -352,7 +352,7 @@ struct etmv4_drvdata {
 	u8				addr_type[ETM_MAX_SINGLE_ADDR_CMP];
 	u8				ctxid_idx;
 	u8				ctxid_size;
-	u64				ctxid_val[ETMv4_MAX_CTXID_CMP];
+	u64				ctxid_pid[ETMv4_MAX_CTXID_CMP];
 	u32				ctxid_mask0;
 	u32				ctxid_mask1;
 	u8				vmid_idx;
-- 
1.9.1
