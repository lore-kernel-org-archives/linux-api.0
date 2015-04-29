From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH v2 02/11] coresight-etm4x: Controls pertaining to tracer configuration
Date: Wed, 29 Apr 2015 11:16:26 -0600
Message-ID: <1430327795-10710-3-git-send-email-mathieu.poirier@linaro.org>
References: <1430327795-10710-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430327795-10710-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

Tracers can be configured with various options at synthesis
time and knowing what resources are available is important for
SW configuration purposes.

As such adding RO sysfs entries for characteristics related to the
tracer implementation.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  61 +++++++++++
 drivers/hwtracing/coresight/coresight-etm4x.c      | 117 +++++++++++++++++++++
 2 files changed, 178 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
index a4b623871ca0..0f579eb24631 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
@@ -26,3 +26,64 @@ Date:		April 2015
 KernelVersion:	4.01
 Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
 Description:	(R) Provides value of all the ID registers (TRCIDRx).
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/nr_pe_cmp
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of PE comparator inputs that are
+		available for tracing.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/nr_addr_cmp
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of address comparator pairs that are
+		available for tracing.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/nr_cntr
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of counters that are available for
+		tracing.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/nr_ext_inp
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates how many external inputs are implemented.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/numcidc
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of Context ID comparators that are
+		available for tracing.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/numvmidc
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of VMID comparators that are available
+		for tracing.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/nrseqstate
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of sequencer states that are implemented.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/nr_resource
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of resource selection pairs that are
+		available for tracing.
+
+What:		/sys/bus/coresight/devices/<memory_map>.etm/nr_ss_cmp
+Date:		April 2015
+KernelVersion:	4.01
+Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
+Description:	(R) Indicates the number of single-shot comparator controls that
+		are available for tracing.
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index c53274264898..babf9bb27d25 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -268,6 +268,114 @@ static const struct coresight_ops etm4_cs_ops = {
 	.source_ops	= &etm4_source_ops,
 };
 
+static ssize_t nr_pe_cmp_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_pe_cmp;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_pe_cmp);
+
+static ssize_t nr_addr_cmp_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_addr_cmp;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_addr_cmp);
+
+static ssize_t nr_cntr_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_cntr;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_cntr);
+
+static ssize_t nr_ext_inp_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_ext_inp;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_ext_inp);
+
+static ssize_t numcidc_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->numcidc;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(numcidc);
+
+static ssize_t numvmidc_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->numvmidc;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(numvmidc);
+
+static ssize_t nrseqstate_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nrseqstate;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nrseqstate);
+
+static ssize_t nr_resource_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_resource;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_resource);
+
+static ssize_t nr_ss_cmp_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	unsigned long val;
+	struct etmv4_drvdata *drvdata = dev_get_drvdata(dev->parent);
+
+	val = drvdata->nr_ss_cmp;
+	return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+}
+static DEVICE_ATTR_RO(nr_ss_cmp);
+
 static ssize_t status_show(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
@@ -412,6 +520,15 @@ static ssize_t trcidr_show(struct device *dev,
 static DEVICE_ATTR_RO(trcidr);
 
 static struct attribute *coresight_etmv4_attrs[] = {
+	&dev_attr_nr_pe_cmp.attr,
+	&dev_attr_nr_addr_cmp.attr,
+	&dev_attr_nr_cntr.attr,
+	&dev_attr_nr_ext_inp.attr,
+	&dev_attr_numcidc.attr,
+	&dev_attr_numvmidc.attr,
+	&dev_attr_nrseqstate.attr,
+	&dev_attr_nr_resource.attr,
+	&dev_attr_nr_ss_cmp.attr,
 	&dev_attr_status.attr,
 	&dev_attr_mgmt.attr,
 	&dev_attr_trcidr.attr,
-- 
1.9.1
