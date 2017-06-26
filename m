From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 12/22] fpga: intel: fme: add header sub feature support
Date: Mon, 26 Jun 2017 09:52:08 +0800
Message-ID: <1498441938-14046-13-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The header register set is always present for FPGA Management Engine (FME),
this patch implements init and uinit function for header sub feature and
introduce several read-only sysfs interfaces for the capability and status.

Sysfs interfaces:
* /sys/class/fpga/<fpga.x>/<intel-fpga-fme.x>/ports_num
  Read-only. Number of ports implemented

* /sys/class/fpga/<fpga.x>/<intel-fpga-fme.x>/bitstream_id
  Read-only. Blue Bitstream identifier number

* /sys/class/fpga/<fpga.x>/<intel-fpga-fme.x>/bitstream_metadata
  Read-only. Blue Bitstream meta data

Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v2: add sysfs documentation
---
 .../ABI/testing/sysfs-platform-intel-fpga-fme      | 19 ++++++++
 drivers/fpga/intel-feature-dev.h                   |  3 ++
 drivers/fpga/intel-fme-main.c                      | 55 ++++++++++++++++++++++
 3 files changed, 77 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-fpga-fme

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme b/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme
new file mode 100644
index 0000000..783cfa9
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme
@@ -0,0 +1,19 @@
+What:		/sys/bus/platform/devices/intel-fpga-fme.0/ports_num
+Date:		June 2017
+KernelVersion:  4.12
+Contact:	Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+Description:	Read-only. One Intel FPGA device may have more than 1
+		port/Accelerator Function Unit (AFU). It returns the
+		number of ports on the FPGA device when read it.
+
+What:		/sys/bus/platform/devices/intel-fpga-fme.0/bitstream_id
+Date:		June 2017
+KernelVersion:  4.12
+Contact:	Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+Description:	Read-only. It returns Blue Bitstream identifier number.
+
+What:		/sys/bus/platform/devices/intel-fpga-fme.0/bitstream_meta
+Date:		June 2017
+KernelVersion:  4.12
+Contact:	Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+Description:	Read-only. It returns Blue Bitstream meta data.
diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
index 635b857..3f97b75 100644
--- a/drivers/fpga/intel-feature-dev.h
+++ b/drivers/fpga/intel-feature-dev.h
@@ -138,6 +138,9 @@ struct feature_fme_header {
 	u64 rsvd[2];
 	struct feature_fme_capability capability;
 	struct feature_fme_port port[MAX_FPGA_PORT_NUM];
+	u64 rsvd1;
+	u64 bitstream_id;
+	u64 bitstream_md;
 };
 
 /* FME Thermal Sub Feature Register Set */
diff --git a/drivers/fpga/intel-fme-main.c b/drivers/fpga/intel-fme-main.c
index c16cf81..dfbb17c 100644
--- a/drivers/fpga/intel-fme-main.c
+++ b/drivers/fpga/intel-fme-main.c
@@ -21,15 +21,70 @@
 
 #include "intel-feature-dev.h"
 
+static ssize_t ports_num_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct feature_fme_header *fme_hdr
+		= get_feature_ioaddr_by_index(dev, FME_FEATURE_ID_HEADER);
+	struct feature_fme_capability fme_capability;
+
+	fme_capability.csr = readq(&fme_hdr->capability);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", fme_capability.num_ports);
+}
+static DEVICE_ATTR_RO(ports_num);
+
+static ssize_t bitstream_id_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct feature_fme_header *fme_hdr
+		= get_feature_ioaddr_by_index(dev, FME_FEATURE_ID_HEADER);
+	u64 bitstream_id = readq(&fme_hdr->bitstream_id);
+
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+				(unsigned long long)bitstream_id);
+}
+static DEVICE_ATTR_RO(bitstream_id);
+
+static ssize_t bitstream_metadata_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct feature_fme_header *fme_hdr
+		= get_feature_ioaddr_by_index(dev, FME_FEATURE_ID_HEADER);
+	u64 bitstream_md = readq(&fme_hdr->bitstream_md);
+
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
+				(unsigned long long)bitstream_md);
+}
+static DEVICE_ATTR_RO(bitstream_metadata);
+
+static const struct attribute *fme_hdr_attrs[] = {
+	&dev_attr_ports_num.attr,
+	&dev_attr_bitstream_id.attr,
+	&dev_attr_bitstream_metadata.attr,
+	NULL,
+};
+
 static int fme_hdr_init(struct platform_device *pdev, struct feature *feature)
 {
+	struct feature_fme_header *fme_hdr = feature->ioaddr;
+	int ret;
+
 	dev_dbg(&pdev->dev, "FME HDR Init.\n");
+	dev_dbg(&pdev->dev, "FME cap %llx.\n",
+				(unsigned long long)fme_hdr->capability.csr);
+
+	ret = sysfs_create_files(&pdev->dev.kobj, fme_hdr_attrs);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
 static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
 {
 	dev_dbg(&pdev->dev, "FME HDR UInit.\n");
+	sysfs_remove_files(&pdev->dev.kobj, fme_hdr_attrs);
 }
 
 struct feature_ops fme_hdr_ops = {
-- 
1.8.3.1
