From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 21/24] fpga: dfl: afu: add header sub feature support
Date: Tue, 13 Feb 2018 17:24:50 +0800
Message-ID: <1518513893-4719-22-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The port header register set is always present for port, it is mainly
for capability, control and status of the ports that AFU connected to.

This patch implements header sub feature support. Below user interfaces
are created by this patch.

Sysfs interface:
* /sys/class/fpga_region/<regionX>/<dfl-port.x>/id
  Read-only. Port ID.

Ioctl interface:
* FPGA_PORT_RESET
  Reset the FPGA Port and its AFU.

Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
v3: rename driver name to fpga-dfl-afu
    add more description for reset ioctl.
    fix some checkpatch issues.
v4: rebase.
    add Acked-by from Alan.
---
 Documentation/ABI/testing/sysfs-platform-dfl-port |  7 ++++
 drivers/fpga/dfl-afu-main.c                       | 44 ++++++++++++++++++++++-
 include/uapi/linux/fpga-dfl.h                     | 17 +++++++++
 3 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-dfl-port

diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-port b/Documentation/ABI/testing/sysfs-platform-dfl-port
new file mode 100644
index 0000000..79e8332
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-dfl-port
@@ -0,0 +1,7 @@
+What:		/sys/bus/platform/devices/dfl-port.0/id
+Date:		Februray 2018
+KernelVersion:  4.16
+Contact:	Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+Description:	Read-only. It returns id of this port. One DFL FPGA device
+		may have more than one port. Userspace could use this id to
+		distinguish different ports under same FPGA device.
diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
index 70db28c..b2f8798 100644
--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -16,25 +16,66 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fpga-dfl.h>
 
 #include "dfl.h"
 
+static ssize_t
+id_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int id = fpga_port_id(to_platform_device(dev));
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", id);
+}
+static DEVICE_ATTR_RO(id);
+
+static const struct attribute *port_hdr_attrs[] = {
+	&dev_attr_id.attr,
+	NULL,
+};
+
 static int port_hdr_init(struct platform_device *pdev, struct feature *feature)
 {
 	dev_dbg(&pdev->dev, "PORT HDR Init.\n");
 
-	return 0;
+	fpga_port_reset(pdev);
+
+	return sysfs_create_files(&pdev->dev.kobj, port_hdr_attrs);
 }
 
 static void port_hdr_uinit(struct platform_device *pdev,
 			   struct feature *feature)
 {
 	dev_dbg(&pdev->dev, "PORT HDR UInit.\n");
+
+	sysfs_remove_files(&pdev->dev.kobj, port_hdr_attrs);
+}
+
+static long
+port_hdr_ioctl(struct platform_device *pdev, struct feature *feature,
+	       unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	switch (cmd) {
+	case FPGA_PORT_RESET:
+		if (!arg)
+			ret = fpga_port_reset(pdev);
+		else
+			ret = -EINVAL;
+		break;
+	default:
+		dev_dbg(&pdev->dev, "%x cmd not handled", cmd);
+		ret = -ENODEV;
+	}
+
+	return ret;
 }
 
 static const struct feature_ops port_hdr_ops = {
 	.init = port_hdr_init,
 	.uinit = port_hdr_uinit,
+	.ioctl = port_hdr_ioctl,
 };
 
 static struct feature_driver port_feature_drvs[] = {
@@ -74,6 +115,7 @@ static int afu_release(struct inode *inode, struct file *filp)
 
 	dev_dbg(&pdev->dev, "Device File Release\n");
 
+	fpga_port_reset(pdev);
 	feature_dev_use_end(pdata);
 
 	return 0;
diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-dfl.h
index 50ee831..727bec2 100644
--- a/include/uapi/linux/fpga-dfl.h
+++ b/include/uapi/linux/fpga-dfl.h
@@ -28,8 +28,11 @@
 #define FPGA_MAGIC 0xB6
 
 #define FPGA_BASE 0
+#define PORT_BASE 0x40
 #define FME_BASE 0x80
 
+/* Common IOCTLs for both FME and AFU file descriptor */
+
 /**
  * FPGA_GET_API_VERSION - _IO(FPGA_MAGIC, FPGA_BASE + 0)
  *
@@ -48,6 +51,20 @@
 
 #define FPGA_CHECK_EXTENSION	_IO(FPGA_MAGIC, FPGA_BASE + 1)
 
+/* IOCTLs for AFU file descriptor */
+
+/**
+ * FPGA_PORT_RESET - _IO(FPGA_MAGIC, PORT_BASE + 0)
+ *
+ * Reset the FPGA Port and its AFU. No parameters are supported.
+ * Userspace can do Port reset at any time, e.g during DMA or PR. But
+ * it should never cause any system level issue, only functional failure
+ * (e.g DMA or PR operation failure) and be recoverable from the failure.
+ * Return: 0 on success, -errno of failure
+ */
+
+#define FPGA_PORT_RESET		_IO(FPGA_MAGIC, PORT_BASE + 0)
+
 /* IOCTLs for FME file descriptor */
 
 /**
-- 
2.7.4
