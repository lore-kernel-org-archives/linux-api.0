From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v2 05/22] fpga: mgr: add status for fpga-mgr
Date: Mon, 26 Jun 2017 09:52:01 +0800
Message-ID: <1498441938-14046-6-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds status to fpga-manager data structure, to allow
driver to store full/partial reconfiguration errors and other
status information.

one sysfs interface created for user space application to read
fpga-manager status.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 Documentation/ABI/testing/sysfs-class-fpga-manager | 10 +++++++++
 drivers/fpga/fpga-mgr.c                            | 24 ++++++++++++++++++++++
 include/linux/fpga/fpga-mgr.h                      |  9 ++++++++
 3 files changed, 43 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documentation/ABI/testing/sysfs-class-fpga-manager
index 23056c5..71b083e 100644
--- a/Documentation/ABI/testing/sysfs-class-fpga-manager
+++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
@@ -35,3 +35,13 @@ Description:	Read fpga manager state as a string.
 		* write complete	= Doing post programming steps
 		* write complete error	= Error while doing post programming
 		* operating		= FPGA is programmed and operating
+
+What:		/sys/class/fpga_manager/<fpga>/status
+Date:		June 2017
+KernelVersion:	4.12
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read fpga manager status as a string.
+		If FPGA programming operation fails, it could be due to crc
+		error or incompatible bitstream image. The intent of this
+		interface is to provide more detailed information for FPGA
+		programming errors to userspace.
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index be13cce..2485658 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -388,12 +388,36 @@ static ssize_t state_show(struct device *dev,
 	return sprintf(buf, "%s\n", state_str[mgr->state]);
 }
 
+static ssize_t status_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
+	int len = 0;
+
+	if (mgr->status & FPGA_MGR_STATUS_OPERATION_ERR)
+		len += sprintf(buf + len, "reconfig operation error\n");
+	if (mgr->status & FPGA_MGR_STATUS_CRC_ERR)
+		len += sprintf(buf + len, "reconfig crc error\n");
+	if (mgr->status & FPGA_MGR_STATUS_INCOMPATIBLE_BS_ERR)
+		len += sprintf(buf + len, "reconfig incompatible BS error\n");
+	if (mgr->status & FPGA_MGR_STATUS_IP_PROTOCOL_ERR)
+		len += sprintf(buf + len, "reconfig IP protocol error\n");
+	if (mgr->status & FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR)
+		len += sprintf(buf + len, "reconfig fifo overflow error\n");
+	if (mgr->status & FPGA_MGR_STATUS_SECURE_LOAD_ERR)
+		len += sprintf(buf + len, "reconfig secure load error\n");
+
+	return len;
+}
+
 static DEVICE_ATTR_RO(name);
 static DEVICE_ATTR_RO(state);
+static DEVICE_ATTR_RO(status);
 
 static struct attribute *fpga_mgr_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_state.attr,
+	&dev_attr_status.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(fpga_mgr);
diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
index b222a57..8cb42ac 100644
--- a/include/linux/fpga/fpga-mgr.h
+++ b/include/linux/fpga/fpga-mgr.h
@@ -128,6 +128,14 @@ struct fpga_manager_ops {
 	void (*fpga_remove)(struct fpga_manager *mgr);
 };
 
+/* FPGA manager status: Partial/Full Reconfiguration errors */
+#define FPGA_MGR_STATUS_OPERATION_ERR		BIT(0)
+#define FPGA_MGR_STATUS_CRC_ERR			BIT(1)
+#define FPGA_MGR_STATUS_INCOMPATIBLE_BS_ERR	BIT(2)
+#define FPGA_MGR_STATUS_IP_PROTOCOL_ERR		BIT(3)
+#define FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR	BIT(4)
+#define FPGA_MGR_STATUS_SECURE_LOAD_ERR		BIT(5)
+
 /**
  * struct fpga_manager - fpga manager structure
  * @name: name of low level fpga manager
@@ -142,6 +150,7 @@ struct fpga_manager {
 	struct device dev;
 	struct mutex ref_mutex;
 	enum fpga_mgr_states state;
+	u64 status;
 	const struct fpga_manager_ops *mops;
 	void *priv;
 };
-- 
1.8.3.1
