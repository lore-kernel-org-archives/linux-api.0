From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH v2 05/11] coresight-etm4x: Controls pertaining to the ViewInst
 register
Date: Wed, 29 Apr 2015 11:16:29 -0600
Message-ID: <1430327795-10710-6-git-send-email-mathieu.poirier@linaro.org>
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

Adding sysfs entries to control the ViewInst register's event
selector along with secure and non-secure exception level
instruction tracing.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  | 20 +++++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 98 ++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index 2aeae2976c10..d7409c3d58e6 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -146,3 +146,23 @@ KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
 Description: 	(RW) Controls which regions in the memory map are enabled to
 		use branch broadcasting.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/event_vinst
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) Controls instruction trace filtering.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/s_exlevel_vinst
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) In Secure state, each bit controls whether instruction
+		tracing is enabled for the corresponding exception level.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/ns_exlevel_vinst
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description: 	(RW) In non-secure state, each bit controls whether instruction
+		tracing is enabled for the corresponding exception level.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index f69e4652a357..9f2a13dd1280 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -932,6 +932,101 @@ static ssize_t bb_ctrl_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(bb_ctrl);
 
+static ssize_t event_vinst_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->vinst_ctrl & ETMv4_EVENT_MASK;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t event_vinst_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	val &= ETMv4_EVENT_MASK;
+	drvdata->vinst_ctrl &= ~ETMv4_EVENT_MASK;
+	drvdata->vinst_ctrl |= val;
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(event_vinst);
+
+static ssize_t s_exlevel_vinst_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = BMVAL(drvdata->vinst_ctrl, 16, 19);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t s_exlevel_vinst_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	/* clear all EXLEVEL_S bits (bit[18] is never implemented) */
+	drvdata->vinst_ctrl &= ~(BIT(16) | BIT(17) | BIT(19));
+	/* enable instruction tracing for corresponding exception level */
+	val &= drvdata->s_ex_level;
+	drvdata->vinst_ctrl |= (val << 16);
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(s_exlevel_vinst);
+
+static ssize_t ns_exlevel_vinst_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	/* EXLEVEL_NS, bits[23:20] */
+	val = BMVAL(drvdata->vinst_ctrl, 20, 23);
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+
+static ssize_t ns_exlevel_vinst_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t size)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	if (kstrtoul(buf, 16, &val))
+		return -EINVAL;
+
+	spin_lock(&drvdata->spinlock);
+	/* clear EXLEVEL_NS bits (bit[23] is never implemented */
+	drvdata->vinst_ctrl &= ~(BIT(20) | BIT(21) | BIT(22));
+	/* enable instruction tracing for corresponding exception level */
+	val &= drvdata->ns_ex_level;
+	drvdata->vinst_ctrl |= (val << 20);
+	spin_unlock(&drvdata->spinlock);
+	return size;
+}
+static DEVICE_ATTR_RW(ns_exlevel_vinst);
+
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -1093,6 +1188,9 @@ static struct attribute *coresight_etmv4_attrs[] = {
 	&dev_attr_syncfreq.attr,
 	&dev_attr_cyc_threshold.attr,
 	&dev_attr_bb_ctrl.attr,
+	&dev_attr_event_vinst.attr,
+	&dev_attr_s_exlevel_vinst.attr,
+	&dev_attr_ns_exlevel_vinst.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
