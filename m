From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/5] coresight-etm3x: Change the name of the ctxid_val to ctxid_pid
Date: Tue,  7 Jul 2015 16:41:54 +0800
Message-ID: <1436258518-9339-2-git-send-email-zhang.chunyan@linaro.org>
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
 .../ABI/testing/sysfs-bus-coresight-devices-etm3x        |  2 +-
 drivers/hwtracing/coresight/coresight-etm.h              |  4 ++--
 drivers/hwtracing/coresight/coresight-etm3x.c            | 16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
index b4d0b99..d72ca17 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
@@ -112,7 +112,7 @@ KernelVersion:	3.19
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description: 	(RW) Mask to apply to all the context ID comparator.
 
-What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/ctxid_val
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/ctxid_pid
 Date:		November 2014
 KernelVersion:	3.19
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
diff --git a/drivers/hwtracing/coresight/coresight-etm.h b/drivers/hwtracing/coresight/coresight-etm.h
index 098ffbe..52af5f0 100644
--- a/drivers/hwtracing/coresight/coresight-etm.h
+++ b/drivers/hwtracing/coresight/coresight-etm.h
@@ -183,7 +183,7 @@
  * @seq_13_event: event causing the transition from 1 to 3.
  * @seq_curr_state: current value of the sequencer register.
  * @ctxid_idx: index for the context ID registers.
- * @ctxid_val: value for the context ID to trigger on.
+ * @ctxid_pid: value for the context ID to trigger on.
  * @ctxid_mask: mask applicable to all the context IDs.
  * @sync_freq:	Synchronisation frequency.
  * @timestamp_event: Defines an event that requests the insertion
@@ -235,7 +235,7 @@ struct etm_drvdata {
 	u32				seq_13_event;
 	u32				seq_curr_state;
 	u8				ctxid_idx;
-	u32				ctxid_val[ETM_MAX_CTXID_CMP];
+	u32				ctxid_pid[ETM_MAX_CTXID_CMP];
 	u32				ctxid_mask;
 	u32				sync_freq;
 	u32				timestamp_event;
diff --git a/drivers/hwtracing/coresight/coresight-etm3x.c b/drivers/hwtracing/coresight/coresight-etm3x.c
index 018a00f..cfda302 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x.c
@@ -238,7 +238,7 @@ static void etm_set_default(struct etm_drvdata *drvdata)
 	drvdata->seq_curr_state = 0x0;
 	drvdata->ctxid_idx = 0x0;
 	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
-		drvdata->ctxid_val[i] = 0x0;
+		drvdata->ctxid_pid[i] = 0x0;
 	drvdata->ctxid_mask = 0x0;
 }
 
@@ -289,7 +289,7 @@ static void etm_enable_hw(void *info)
 	for (i = 0; i < drvdata->nr_ext_out; i++)
 		etm_writel(drvdata, ETM_DEFAULT_EVENT_VAL, ETMEXTOUTEVRn(i));
 	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
-		etm_writel(drvdata, drvdata->ctxid_val[i], ETMCIDCVRn(i));
+		etm_writel(drvdata, drvdata->ctxid_pid[i], ETMCIDCVRn(i));
 	etm_writel(drvdata, drvdata->ctxid_mask, ETMCIDCMR);
 	etm_writel(drvdata, drvdata->sync_freq, ETMSYNCFR);
 	/* No external input selected */
@@ -1386,20 +1386,20 @@ static ssize_t ctxid_idx_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(ctxid_idx);
 
-static ssize_t ctxid_val_show(struct device *dev,
+static ssize_t ctxid_pid_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
 	unsigned long val;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 
 	spin_lock(&drvdata->spinlock);
-	val = drvdata->ctxid_val[drvdata->ctxid_idx];
+	val = drvdata->ctxid_pid[drvdata->ctxid_idx];
 	spin_unlock(&drvdata->spinlock);
 
 	return sprintf(buf, "%#lx\n", val);
 }
 
-static ssize_t ctxid_val_store(struct device *dev,
+static ssize_t ctxid_pid_store(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t size)
 {
@@ -1412,12 +1412,12 @@ static ssize_t ctxid_val_store(struct device *dev,
 		return ret;
 
 	spin_lock(&drvdata->spinlock);
-	drvdata->ctxid_val[drvdata->ctxid_idx] = val;
+	drvdata->ctxid_pid[drvdata->ctxid_idx] = val;
 	spin_unlock(&drvdata->spinlock);
 
 	return size;
 }
-static DEVICE_ATTR_RW(ctxid_val);
+static DEVICE_ATTR_RW(ctxid_pid);
 
 static ssize_t ctxid_mask_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -1609,7 +1609,7 @@ static struct attribute *coresight_etm_attrs[] = {
 	&dev_attr_seq_13_event.attr,
 	&dev_attr_seq_curr_state.attr,
 	&dev_attr_ctxid_idx.attr,
-	&dev_attr_ctxid_val.attr,
+	&dev_attr_ctxid_pid.attr,
 	&dev_attr_ctxid_mask.attr,
 	&dev_attr_sync_freq.attr,
 	&dev_attr_timestamp_event.attr,
-- 
1.9.1
