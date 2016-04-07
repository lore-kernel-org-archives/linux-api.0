From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V5 1/4] stm class: Support devices that override software assigned masters
Date: Thu,  7 Apr 2016 10:51:16 +0800
Message-ID: <1459997479-19431-2-git-send-email-zhang.chunyan@linaro.org>
References: <1459997479-19431-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459997479-19431-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: mike.leach@arm.com, Michael.Williams@arm.com, al.grant@arm.com, tor@ti.com, nicolas.guion@st.com, pratikp@codeaurora.org, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

Some STM devices adjust software assigned master numbers depending on
the trace source and its runtime state and whatnot. This patch adds
a sysfs attribute to inform the trace-side software that master numbers
assigned to software sources will not match those in the STP stream,
so that, for example, master/channel allocation policy can be adjusted
accordingly.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-class-stm | 10 ++++++++++
 drivers/hwtracing/stm/core.c              | 15 +++++++++++++++
 include/linux/stm.h                       |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-stm b/Documentation/ABI/testing/sysfs-class-stm
index c9aa4f3..77ed3da 100644
--- a/Documentation/ABI/testing/sysfs-class-stm
+++ b/Documentation/ABI/testing/sysfs-class-stm
@@ -12,3 +12,13 @@ KernelVersion:	4.3
 Contact:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
 Description:
 		Shows the number of channels per master on this STM device.
+
+What:		/sys/class/stm/<stm>/hw_override
+Date:		March 2016
+KernelVersion:	4.7
+Contact:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
+Description:
+		Reads as 0 if master numbers in the STP stream produced by
+		this stm device will match the master numbers assigned by
+		the software or 1 if the stm hardware overrides software
+		assigned masters.
diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index de80d45..9387f8c 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -67,9 +67,24 @@ static ssize_t channels_show(struct device *dev,
 
 static DEVICE_ATTR_RO(channels);
 
+static ssize_t hw_override_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct stm_device *stm = to_stm_device(dev);
+	int ret;
+
+	ret = sprintf(buf, "%u\n", stm->data->hw_override);
+
+	return ret;
+}
+
+static DEVICE_ATTR_RO(hw_override);
+
 static struct attribute *stm_attrs[] = {
 	&dev_attr_masters.attr,
 	&dev_attr_channels.attr,
+	&dev_attr_hw_override.attr,
 	NULL,
 };
 
diff --git a/include/linux/stm.h b/include/linux/stm.h
index 1a79ed8..8369d8a 100644
--- a/include/linux/stm.h
+++ b/include/linux/stm.h
@@ -50,6 +50,8 @@ struct stm_device;
  * @sw_end:		last STP master available to software
  * @sw_nchannels:	number of STP channels per master
  * @sw_mmiosz:		size of one channel's IO space, for mmap, optional
+ * @hw_override:	masters in the STP stream will not match the ones
+ *			assigned by software, but are up to the STM hardware
  * @packet:		callback that sends an STP packet
  * @mmio_addr:		mmap callback, optional
  * @link:		called when a new stm_source gets linked to us, optional
@@ -85,6 +87,7 @@ struct stm_data {
 	unsigned int		sw_end;
 	unsigned int		sw_nchannels;
 	unsigned int		sw_mmiosz;
+	unsigned int		hw_override;
 	ssize_t			(*packet)(struct stm_data *, unsigned int,
 					  unsigned int, unsigned int,
 					  unsigned int, unsigned int,
-- 
1.9.1
