From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V5 2/4] coresight: adding path for STM device
Date: Thu,  7 Apr 2016 10:51:17 +0800
Message-ID: <1459997479-19431-3-git-send-email-zhang.chunyan@linaro.org>
References: <1459997479-19431-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459997479-19431-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: mike.leach@arm.com, Michael.Williams@arm.com, al.grant@arm.com, tor@ti.com, nicolas.guion@st.com, pratikp@codeaurora.org, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

>From a core framework point of view an STM device is a source that is
treated the same way as any other tracers.  Unlike tracers though STM
devices are not associated with a CPU.  As such it doesn't make sense
to associate the path from an STM device to its sink with a per-cpu
variable as it is done for tracers.

This patch simply adds another global variable to keep STM paths and the
processing in coresight_enable/disable() is updated to deal with STM
devices properly.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 drivers/hwtracing/coresight/coresight.c | 106 ++++++++++++++++++++++++--------
 1 file changed, 82 insertions(+), 24 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
index 2ea5961..6c80663 100644
--- a/drivers/hwtracing/coresight/coresight.c
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -43,7 +43,15 @@ struct coresight_node {
  * When operating Coresight drivers from the sysFS interface, only a single
  * path can exist from a tracer (associated to a CPU) to a sink.
  */
-static DEFINE_PER_CPU(struct list_head *, sysfs_path);
+static DEFINE_PER_CPU(struct list_head *, tracer_path);
+
+/*
+ * As of this writing only a single STM can be found in CS topologies.  Since
+ * there is no way to know if we'll ever see more and what kind of
+ * configuration they will enact, for the time being only define a single path
+ * for STM.
+ */
+static struct list_head *stm_path;
 
 static int coresight_id_match(struct device *dev, void *data)
 {
@@ -432,18 +440,45 @@ void coresight_release_path(struct list_head *path)
 	path = NULL;
 }
 
+/** coresight_validate_source - make sure a source has the right credentials
+ *  @csdev:	the device structure for a source.
+ *  @function:	the function this was called from.
+ *
+ * Assumes the coresight_mutex is held.
+ */
+static int coresight_validate_source(struct coresight_device *csdev,
+				     const char *function)
+{
+	u32 type, subtype;
+
+	type = csdev->type;
+	subtype = csdev->subtype.source_subtype;
+
+	if (type != CORESIGHT_DEV_TYPE_SOURCE) {
+		dev_err(&csdev->dev, "wrong device type in %s\n", function);
+		return -EINVAL;
+	}
+
+	if (subtype != CORESIGHT_DEV_SUBTYPE_SOURCE_PROC &&
+	    subtype != CORESIGHT_DEV_SUBTYPE_SOURCE_SOFTWARE) {
+		dev_err(&csdev->dev, "wrong device subtype in %s\n", function);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int coresight_enable(struct coresight_device *csdev)
 {
-	int ret = 0;
-	int cpu;
+	int cpu, ret = 0;
 	struct list_head *path;
 
 	mutex_lock(&coresight_mutex);
-	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
-		ret = -EINVAL;
-		dev_err(&csdev->dev, "wrong device type in %s\n", __func__);
+
+	ret = coresight_validate_source(csdev, __func__);
+	if (ret)
 		goto out;
-	}
+
 	if (csdev->enable)
 		goto out;
 
@@ -461,15 +496,25 @@ int coresight_enable(struct coresight_device *csdev)
 	if (ret)
 		goto err_source;
 
-	/*
-	 * When working from sysFS it is important to keep track
-	 * of the paths that were created so that they can be
-	 * undone in 'coresight_disable()'.  Since there can only
-	 * be a single session per tracer (when working from sysFS)
-	 * a per-cpu variable will do just fine.
-	 */
-	cpu = source_ops(csdev)->cpu_id(csdev);
-	per_cpu(sysfs_path, cpu) = path;
+	switch (csdev->subtype.source_subtype) {
+	case CORESIGHT_DEV_SUBTYPE_SOURCE_PROC:
+		/*
+		 * When working from sysFS it is important to keep track
+		 * of the paths that were created so that they can be
+		 * undone in 'coresight_disable()'.  Since there can only
+		 * be a single session per tracer (when working from sysFS)
+		 * a per-cpu variable will do just fine.
+		 */
+		cpu = source_ops(csdev)->cpu_id(csdev);
+		per_cpu(tracer_path, cpu) = path;
+		break;
+	case CORESIGHT_DEV_SUBTYPE_SOURCE_SOFTWARE:
+		stm_path = path;
+		break;
+	default:
+		/* We can't be here */
+		break;
+	}
 
 out:
 	mutex_unlock(&coresight_mutex);
@@ -486,23 +531,36 @@ EXPORT_SYMBOL_GPL(coresight_enable);
 
 void coresight_disable(struct coresight_device *csdev)
 {
-	int cpu;
-	struct list_head *path;
+	int cpu, ret;
+	struct list_head *path = NULL;
 
 	mutex_lock(&coresight_mutex);
-	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
-		dev_err(&csdev->dev, "wrong device type in %s\n", __func__);
+
+	ret = coresight_validate_source(csdev, __func__);
+	if (ret)
 		goto out;
-	}
+
 	if (!csdev->enable)
 		goto out;
 
-	cpu = source_ops(csdev)->cpu_id(csdev);
-	path = per_cpu(sysfs_path, cpu);
+	switch (csdev->subtype.source_subtype) {
+	case CORESIGHT_DEV_SUBTYPE_SOURCE_PROC:
+		cpu = source_ops(csdev)->cpu_id(csdev);
+		path = per_cpu(tracer_path, cpu);
+		per_cpu(tracer_path, cpu) = NULL;
+		break;
+	case CORESIGHT_DEV_SUBTYPE_SOURCE_SOFTWARE:
+		path = stm_path;
+		stm_path = NULL;
+		break;
+	default:
+		/* We can't be here */
+		break;
+	}
+
 	coresight_disable_source(csdev);
 	coresight_disable_path(path);
 	coresight_release_path(path);
-	per_cpu(sysfs_path, cpu) = NULL;
 
 out:
 	mutex_unlock(&coresight_mutex);
-- 
1.9.1
