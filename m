From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 03/24] fpga: mgr: add status for fpga-manager
Date: Tue, 13 Feb 2018 17:24:32 +0800
Message-ID: <1518513893-4719-4-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

This patch adds status to fpga-manager data structure, to allow
driver to store full/partial reconfiguration errors and other
status information, and adds one status callback to fpga_manager_ops
to allow fpga_manager to collect latest status when failures are
detected.

The following sysfs file is created:
* /sys/class/fpga_manager/<fpga>/status
  Return status of fpga manager, including reconfiguration errors.

Signed-off-by: Wu Hao <hao.wu@intel.com>
---
v3: add one line description for status
    add status callback function to fpga_manager_ops
    update fpga-mgr status if any failure or during initialization
    s/INCOMPATIBLE_BS_ERR/INCOMPATIBLE_IMAGE_ERR/
v4: simply code per suggestion from Alan.
    add supported status strings (and descriptions) in sysfs document.
    remove unused error code (SECURE_LOAD_ERR).
---
 Documentation/ABI/testing/sysfs-class-fpga-manager | 24 +++++++++++++++++++
 drivers/fpga/fpga-mgr.c                            | 28 ++++++++++++++++++++++
 include/linux/fpga/fpga-mgr.h                      |  9 +++++++
 3 files changed, 61 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documentation/ABI/testing/sysfs-class-fpga-manager
index 23056c5..60db277 100644
--- a/Documentation/ABI/testing/sysfs-class-fpga-manager
+++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
@@ -35,3 +35,27 @@ Description:	Read fpga manager state as a string.
 		* write complete	= Doing post programming steps
 		* write complete error	= Error while doing post programming
 		* operating		= FPGA is programmed and operating
+
+What:		/sys/class/fpga_manager/<fpga>/status
+Date:		February 2018
+KernelVersion:	4.16
+Contact:	Wu Hao <hao.wu@intel.com>
+Description:	Read fpga manager status as a string.
+		If FPGA programming operation fails, it could be caused by crc
+		error or incompatible bitstream image. The intent of this
+		interface is to provide more detailed information for FPGA
+		programming errors to userspace. This is a list of strings for
+		the supported status.
+
+		* reconfig operation error 	- invalid operations detected by
+						  reconfiguration hardware.
+						  e.g start reconfiguration
+						  with errors not cleared
+		* reconfig CRC error		- CRC error detected by
+						  reconfiguration hardware.
+		* reconfig incompatible image	- reconfiguration image is
+						  incompatible with hardware
+		* reconfig IP protocol error	- protocol errors detected by
+						  reconfiguration hardware
+		* reconfig fifo overflow error	- FIFO overflow detected by
+						  reconfiguration hardware
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index 245e7a6..50b7396 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -397,12 +397,40 @@ static ssize_t state_show(struct device *dev,
 	return sprintf(buf, "%s\n", state_str[mgr->state]);
 }
 
+static ssize_t status_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
+	u64 status;
+	int len = 0;
+
+	if (!mgr->mops->status)
+		return -ENOENT;
+
+	status = mgr->mops->status(mgr);
+
+	if (status & FPGA_MGR_STATUS_OPERATION_ERR)
+		len += sprintf(buf + len, "reconfig operation error\n");
+	if (status & FPGA_MGR_STATUS_CRC_ERR)
+		len += sprintf(buf + len, "reconfig CRC error\n");
+	if (status & FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR)
+		len += sprintf(buf + len, "reconfig incompatible image\n");
+	if (status & FPGA_MGR_STATUS_IP_PROTOCOL_ERR)
+		len += sprintf(buf + len, "reconfig IP protocol error\n");
+	if (status & FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR)
+		len += sprintf(buf + len, "reconfig fifo overflow error\n");
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
index 6e98b66..6c79183 100644
--- a/include/linux/fpga/fpga-mgr.h
+++ b/include/linux/fpga/fpga-mgr.h
@@ -112,6 +112,7 @@ struct fpga_image_info {
  * struct fpga_manager_ops - ops for low level fpga manager drivers
  * @initial_header_size: Maximum number of bytes that should be passed into write_init
  * @state: returns an enum value of the FPGA's state
+ * @status: returns status of the FPGA, including reconfiguration error code
  * @write_init: prepare the FPGA to receive confuration data
  * @write: write count bytes of configuration data to the FPGA
  * @write_sg: write the scatter list of configuration data to the FPGA
@@ -126,6 +127,7 @@ struct fpga_image_info {
 struct fpga_manager_ops {
 	size_t initial_header_size;
 	enum fpga_mgr_states (*state)(struct fpga_manager *mgr);
+	u64 (*status)(struct fpga_manager *mgr);
 	int (*write_init)(struct fpga_manager *mgr,
 			  struct fpga_image_info *info,
 			  const char *buf, size_t count);
@@ -137,6 +139,13 @@ struct fpga_manager_ops {
 	const struct attribute_group **groups;
 };
 
+/* FPGA manager status: Partial/Full Reconfiguration errors */
+#define FPGA_MGR_STATUS_OPERATION_ERR		BIT(0)
+#define FPGA_MGR_STATUS_CRC_ERR			BIT(1)
+#define FPGA_MGR_STATUS_INCOMPATIBLE_IMAGE_ERR	BIT(2)
+#define FPGA_MGR_STATUS_IP_PROTOCOL_ERR		BIT(3)
+#define FPGA_MGR_STATUS_FIFO_OVERFLOW_ERR	BIT(4)
+
 /**
  * struct fpga_manager - fpga manager structure
  * @name: name of low level fpga manager
-- 
2.7.4
