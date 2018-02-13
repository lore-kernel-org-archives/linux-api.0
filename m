From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 11/24] fpga: dfl: fme: add header sub feature support
Date: Tue, 13 Feb 2018 17:24:40 +0800
Message-ID: <1518513893-4719-12-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Kang Luwei <luwei.kang@intel.com>

The Header Register set is always present for FPGA Management Engine (FME),
this patch implements init and uinit function for header sub feature and
introduce several read-only sysfs interfaces for the capability and status.

Sysfs interfaces:
* /sys/class/fpga_region/<regionX>/<dfl-fme.x>/ports_num
  Read-only. Number of ports implemented

* /sys/class/fpga_region/<regionX>/<dfl-fme.x>/bitstream_id
  Read-only. Blue Bitstream (static FPGA region) identifier number. It contains
  the detailed version and other information of this static FPGA region.

* /sys/class/fpga_region/<regionX>/<dfl-fme.x>/bitstream_metadata
  Read-only. Blue Bitstream (static FPGA region) meta data. It contains the
  synthesis date, seed and other information of this static FPGA region.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Kang Luwei <luwei.kang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
v2: add sysfs documentation
v3: rename driver to fpga-dfl-fme.
    improve sysfs doc and commit description.
    replace bitfield.
v4: rebase and switch to use id for sub feature matching.
    add more description for bitstream_id/metadata.
---
 Documentation/ABI/testing/sysfs-platform-dfl-fme | 23 ++++++++
 drivers/fpga/dfl-fme-main.c                      | 68 ++++++++++++++++++++++++
 2 files changed, 91 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-dfl-fme

diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-fme b/Documentation/ABI/testing/sysfs-platform-dfl-fme
new file mode 100644
index 0000000..23a13a5
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-dfl-fme
@@ -0,0 +1,23 @@
+What:		/sys/bus/platform/devices/dfl-fme.0/ports_num
+Date:		February 2018
+KernelVersion:  4.16
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. One DFL FPGA device may have more than 1
+		port/Accelerator Function Unit (AFU). It returns the
+		number of ports on the FPGA device when read it.
+
+What:		/sys/bus/platform/devices/dfl-fme.0/bitstream_id
+Date:		February 2018
+KernelVersion:  4.16
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. It returns Blue Bitstream (static FPGA region)
+		identifier number, which includes the detailed version
+		and other information of this static FPGA region.
+
+What:		/sys/bus/platform/devices/dfl-fme.0/bitstream_meta
+Date:		February 2018
+KernelVersion:  4.16
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read-only. It returns Blue Bitstream (static FPGA region)
+		meta data, which includes the synthesis date, seed and other
+		information of this static FPGA region.
diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
index ebe6b52..056ae24 100644
--- a/drivers/fpga/dfl-fme-main.c
+++ b/drivers/fpga/dfl-fme-main.c
@@ -19,9 +19,76 @@
 
 #include "dfl.h"
 
+static ssize_t ports_num_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
+
+	v = readq(base + FME_HDR_CAP);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 (unsigned int)FIELD_GET(FME_CAP_NUM_PORTS, v));
+}
+static DEVICE_ATTR_RO(ports_num);
+
+/*
+ * Blue Bitstream (static FPGA region) identifier number. It contains the
+ * detailed version and other information of this static FPGA region.
+ */
+static ssize_t bitstream_id_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
+
+	v = readq(base + FME_HDR_BITSTREAM_ID);
+
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n", (unsigned long long)v);
+}
+static DEVICE_ATTR_RO(bitstream_id);
+
+/*
+ * Blue Bitstream (static FPGA region) meta data. It contains the synthesis
+ * date, seed and other information of this static FPGA region.
+ */
+static ssize_t bitstream_metadata_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	void __iomem *base;
+	u64 v;
+
+	base = get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
+
+	v = readq(base + FME_HDR_BITSTREAM_MD);
+
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n", (unsigned long long)v);
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
+	void __iomem *base = feature->ioaddr;
+	int ret;
+
 	dev_dbg(&pdev->dev, "FME HDR Init.\n");
+	dev_dbg(&pdev->dev, "FME cap %llx.\n",
+		(unsigned long long)readq(base + FME_HDR_CAP));
+
+	ret = sysfs_create_files(&pdev->dev.kobj, fme_hdr_attrs);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -29,6 +96,7 @@ static int fme_hdr_init(struct platform_device *pdev, struct feature *feature)
 static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
 {
 	dev_dbg(&pdev->dev, "FME HDR UInit.\n");
+	sysfs_remove_files(&pdev->dev.kobj, fme_hdr_attrs);
 }
 
 static const struct feature_ops fme_hdr_ops = {
-- 
2.7.4
