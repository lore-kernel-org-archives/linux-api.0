From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] coresight-etm3x: Support context-ID tracing when PID namespace is enabled
Date: Tue,  7 Jul 2015 16:41:57 +0800
Message-ID: <1436258518-9339-5-git-send-email-zhang.chunyan@linaro.org>
References: <1436258518-9339-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436258518-9339-1-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge.broslavsky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The Coresight ETM drivers already support context-ID tracing, but it won't
work when PID namespace is enabled. This is because when using PID
namespace a process id (ie. VPID) seen from the current namespace differs
from the id (ie. PID) seen by kernel.

So when users write the process id seen by themselves to ETM, there needs
to be a translation from VPID to PID, as such ETM drivers will write the
PID into the Context ID register correctly.

Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/hwtracing/coresight/coresight-etm.h   |  3 +++
 drivers/hwtracing/coresight/coresight-etm3x.c | 16 +++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm.h b/drivers/hwtracing/coresight/coresight-etm.h
index 52af5f0..b4481eb 100644
--- a/drivers/hwtracing/coresight/coresight-etm.h
+++ b/drivers/hwtracing/coresight/coresight-etm.h
@@ -184,6 +184,8 @@
  * @seq_curr_state: current value of the sequencer register.
  * @ctxid_idx: index for the context ID registers.
  * @ctxid_pid: value for the context ID to trigger on.
+ * @ctxid_vpid:	Virtual PID seen by users if PID namespace is enabled, otherwise
+ *		the same value of ctxid_pid.
  * @ctxid_mask: mask applicable to all the context IDs.
  * @sync_freq:	Synchronisation frequency.
  * @timestamp_event: Defines an event that requests the insertion
@@ -236,6 +238,7 @@ struct etm_drvdata {
 	u32				seq_curr_state;
 	u8				ctxid_idx;
 	u32				ctxid_pid[ETM_MAX_CTXID_CMP];
+	u32				ctxid_vpid[ETM_MAX_CTXID_CMP];
 	u32				ctxid_mask;
 	u32				sync_freq;
 	u32				timestamp_event;
diff --git a/drivers/hwtracing/coresight/coresight-etm3x.c b/drivers/hwtracing/coresight/coresight-etm3x.c
index cfda302..996f083 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x.c
@@ -237,8 +237,11 @@ static void etm_set_default(struct etm_drvdata *drvdata)
 
 	drvdata->seq_curr_state = 0x0;
 	drvdata->ctxid_idx = 0x0;
-	for (i = 0; i < drvdata->nr_ctxid_cmp; i++)
+	for (i = 0; i < drvdata->nr_ctxid_cmp; i++) {
 		drvdata->ctxid_pid[i] = 0x0;
+		drvdata->ctxid_vpid[i] = 0x0;
+	}
+
 	drvdata->ctxid_mask = 0x0;
 }
 
@@ -1393,7 +1396,7 @@ static ssize_t ctxid_pid_show(struct device *dev,
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 
 	spin_lock(&drvdata->spinlock);
-	val = drvdata->ctxid_pid[drvdata->ctxid_idx];
+	val = drvdata->ctxid_vpid[drvdata->ctxid_idx];
 	spin_unlock(&drvdata->spinlock);
 
 	return sprintf(buf, "%#lx\n", val);
@@ -1404,15 +1407,18 @@ static ssize_t ctxid_pid_store(struct device *dev,
 			       const char *buf, size_t size)
 {
 	int ret;
-	unsigned long val;
+	unsigned long vpid, pid;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 
-	ret = kstrtoul(buf, 16, &val);
+	ret = kstrtoul(buf, 16, &vpid);
 	if (ret)
 		return ret;
 
+	pid = coresight_vpid_to_pid(vpid);
+
 	spin_lock(&drvdata->spinlock);
-	drvdata->ctxid_pid[drvdata->ctxid_idx] = val;
+	drvdata->ctxid_pid[drvdata->ctxid_idx] = pid;
+	drvdata->ctxid_vpid[drvdata->ctxid_idx] = vpid;
 	spin_unlock(&drvdata->spinlock);
 
 	return size;
-- 
1.9.1
