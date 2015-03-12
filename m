From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v7 1/3] scsi: ufs: add ioctl interface for query request
Date: Thu, 12 Mar 2015 17:54:32 +0200
Message-ID: <1426175674-23077-2-git-send-email-gbroner@codeaurora.org>
References: <1426175674-23077-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426175674-23077-1-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Noa Rubens <noag@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

From: Dolev Raviv <draviv@codeaurora.org>

This patch exposes the ioctl interface for UFS driver via SCSI device
ioctl interface. As of now UFS driver would provide the ioctl for query
interface to connected UFS device.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Noa Rubens <noag@codeaurora.org>
Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h        |  53 ++--------
 drivers/scsi/ufs/ufshcd.c     | 226 +++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi.h           |   1 +
 include/uapi/scsi/Kbuild      |   1 +
 include/uapi/scsi/ufs/Kbuild  |   3 +
 include/uapi/scsi/ufs/ioctl.h |  57 +++++++++++
 include/uapi/scsi/ufs/ufs.h   |  66 ++++++++++++
 7 files changed, 363 insertions(+), 44 deletions(-)
 create mode 100644 include/uapi/scsi/ufs/Kbuild
 create mode 100644 include/uapi/scsi/ufs/ioctl.h
 create mode 100644 include/uapi/scsi/ufs/ufs.h

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 42c459a..1f023c4 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -38,6 +38,7 @@
 
 #include <linux/mutex.h>
 #include <linux/types.h>
+#include <scsi/ufs/ufs.h>
 
 #define MAX_CDB_SIZE	16
 #define GENERAL_UPIU_REQUEST_SIZE 32
@@ -71,6 +72,16 @@ enum {
 	UFS_UPIU_RPMB_WLUN		= 0xC4,
 };
 
+/**
+ * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
+ * @lun: LU number to check
+ * @return: true if the lun has a matching unit descriptor, false otherwise
+ */
+static inline bool ufs_is_valid_unit_desc_lun(u8 lun)
+{
+	return (lun == UFS_UPIU_RPMB_WLUN || (lun < UFS_UPIU_MAX_GENERAL_LUN));
+}
+
 /*
  * UFS Protocol Information Unit related definitions
  */
@@ -126,35 +137,6 @@ enum {
 	UPIU_QUERY_FUNC_STANDARD_WRITE_REQUEST          = 0x81,
 };
 
-/* Flag idn for Query Requests*/
-enum flag_idn {
-	QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
-	QUERY_FLAG_IDN_PWR_ON_WPE	= 0x03,
-	QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
-};
-
-/* Attribute idn for Query requests */
-enum attr_idn {
-	QUERY_ATTR_IDN_ACTIVE_ICC_LVL	= 0x03,
-	QUERY_ATTR_IDN_BKOPS_STATUS	= 0x05,
-	QUERY_ATTR_IDN_EE_CONTROL	= 0x0D,
-	QUERY_ATTR_IDN_EE_STATUS	= 0x0E,
-};
-
-/* Descriptor idn for Query requests */
-enum desc_idn {
-	QUERY_DESC_IDN_DEVICE		= 0x0,
-	QUERY_DESC_IDN_CONFIGURAION	= 0x1,
-	QUERY_DESC_IDN_UNIT		= 0x2,
-	QUERY_DESC_IDN_RFU_0		= 0x3,
-	QUERY_DESC_IDN_INTERCONNECT	= 0x4,
-	QUERY_DESC_IDN_STRING		= 0x5,
-	QUERY_DESC_IDN_RFU_1		= 0x6,
-	QUERY_DESC_IDN_GEOMETRY		= 0x7,
-	QUERY_DESC_IDN_POWER		= 0x8,
-	QUERY_DESC_IDN_MAX,
-};
-
 enum desc_header_offset {
 	QUERY_DESC_LENGTH_OFFSET	= 0x00,
 	QUERY_DESC_DESC_TYPE_OFFSET	= 0x01,
@@ -247,19 +229,6 @@ enum bkops_status {
 	BKOPS_STATUS_MAX		 = BKOPS_STATUS_CRITICAL,
 };
 
-/* UTP QUERY Transaction Specific Fields OpCode */
-enum query_opcode {
-	UPIU_QUERY_OPCODE_NOP		= 0x0,
-	UPIU_QUERY_OPCODE_READ_DESC	= 0x1,
-	UPIU_QUERY_OPCODE_WRITE_DESC	= 0x2,
-	UPIU_QUERY_OPCODE_READ_ATTR	= 0x3,
-	UPIU_QUERY_OPCODE_WRITE_ATTR	= 0x4,
-	UPIU_QUERY_OPCODE_READ_FLAG	= 0x5,
-	UPIU_QUERY_OPCODE_SET_FLAG	= 0x6,
-	UPIU_QUERY_OPCODE_CLEAR_FLAG	= 0x7,
-	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
-};
-
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5d60a86..5d82220 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3,7 +3,7 @@
  *
  * This code is based on drivers/scsi/ufs/ufshcd.c
  * Copyright (C) 2011-2013 Samsung India Software Operations
- * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
@@ -39,6 +39,7 @@
 
 #include <linux/async.h>
 #include <linux/devfreq.h>
+#include <scsi/ufs/ioctl.h>
 
 #include "ufshcd.h"
 #include "unipro.h"
@@ -74,6 +75,9 @@
 /* Interrupt aggregation default timeout, unit: 40us */
 #define INT_AGGR_DEF_TO	0x02
 
+/* IOCTL opcode for command - ufs set device read only */
+#define UFS_IOCTL_BLKROSET      BLKROSET
+
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
 		int _ret;                                               \
@@ -1882,7 +1886,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (lun != UFS_UPIU_RPMB_WLUN && (lun >= UFS_UPIU_MAX_GENERAL_LUN))
+	if (!ufs_is_valid_unit_desc_lun(lun))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
@@ -4201,6 +4205,223 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	ufshcd_probe_hba(hba);
 }
 
+/**
+ * ufshcd_query_ioctl - perform user read queries
+ * @hba: per-adapter instance
+ * @lun: used for lun specific queries
+ * @buffer: user space buffer for reading and submitting query data and params
+ * @return: 0 for success negative error code otherwise
+ *
+ * Expected/Submitted buffer structure is struct ufs_ioctl_query_data.
+ * It will read the opcode, idn and buf_length parameters, and, put the
+ * response in the buffer field while updating the used size in buf_length.
+ */
+static int ufshcd_query_ioctl(struct ufs_hba *hba, u8 lun, void __user *buffer)
+{
+	struct ufs_ioctl_query_data *ioctl_data;
+	int err = 0;
+	int length = 0;
+	void *data_ptr;
+	bool flag;
+	u32 att;
+	u8 index;
+	u8 *desc = NULL;
+
+	if (!buffer) {
+		dev_err(hba->dev, "%s: User buffer is NULL!\n", __func__);
+		return -EINVAL;
+	}
+
+	ioctl_data = kzalloc(sizeof(struct ufs_ioctl_query_data), GFP_KERNEL);
+	if (!ioctl_data) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* extract params from user buffer */
+	err = copy_from_user(ioctl_data, buffer,
+			sizeof(struct ufs_ioctl_query_data));
+	if (err) {
+		dev_err(hba->dev,
+			"%s: Failed copying buffer from user, err %d\n",
+			__func__, err);
+		goto out_release_mem;
+	}
+
+	/* verify legal parameters & send query */
+	switch (ioctl_data->opcode) {
+	case UPIU_QUERY_OPCODE_READ_DESC:
+		switch (ioctl_data->idn) {
+		case QUERY_DESC_IDN_DEVICE:
+		case QUERY_DESC_IDN_CONFIGURAION:
+		case QUERY_DESC_IDN_INTERCONNECT:
+		case QUERY_DESC_IDN_GEOMETRY:
+		case QUERY_DESC_IDN_POWER:
+			index = 0;
+			break;
+		case QUERY_DESC_IDN_UNIT:
+			if (!ufs_is_valid_unit_desc_lun(lun)) {
+				dev_err(hba->dev,
+					"%s: No unit descriptor for lun 0x%x\n",
+					__func__, lun);
+				err = -EINVAL;
+				goto out_release_mem;
+			}
+			index = lun;
+			break;
+		default:
+			goto out_einval;
+		}
+		length = min_t(int, QUERY_DESC_MAX_SIZE,
+				ioctl_data->buf_size);
+		desc = kzalloc(length, GFP_KERNEL);
+		if (!desc) {
+			dev_err(hba->dev, "%s: Failed allocating %d bytes\n",
+					__func__, length);
+			err = -ENOMEM;
+			goto out_release_mem;
+		}
+		err = ufshcd_query_descriptor(hba, ioctl_data->opcode,
+				ioctl_data->idn, index, 0, desc, &length);
+		break;
+	case UPIU_QUERY_OPCODE_READ_ATTR:
+		switch (ioctl_data->idn) {
+		case QUERY_ATTR_IDN_BOOT_LU_EN:
+		case QUERY_ATTR_IDN_POWER_MODE:
+		case QUERY_ATTR_IDN_ACTIVE_ICC_LVL:
+		case QUERY_ATTR_IDN_OOO_DATA_EN:
+		case QUERY_ATTR_IDN_BKOPS_STATUS:
+		case QUERY_ATTR_IDN_PURGE_STATUS:
+		case QUERY_ATTR_IDN_MAX_DATA_IN:
+		case QUERY_ATTR_IDN_MAX_DATA_OUT:
+		case QUERY_ATTR_IDN_REF_CLK_FREQ:
+		case QUERY_ATTR_IDN_CONF_DESC_LOCK:
+		case QUERY_ATTR_IDN_MAX_NUM_OF_RTT:
+		case QUERY_ATTR_IDN_EE_CONTROL:
+		case QUERY_ATTR_IDN_EE_STATUS:
+		case QUERY_ATTR_IDN_SECONDS_PASSED:
+			index = 0;
+			break;
+		case QUERY_ATTR_IDN_DYN_CAP_NEEDED:
+		case QUERY_ATTR_IDN_CORR_PRG_BLK_NUM:
+			index = lun;
+			break;
+		default:
+			goto out_einval;
+		}
+		err = ufshcd_query_attr(hba, ioctl_data->opcode,
+					ioctl_data->idn, index, 0, &att);
+		break;
+	case UPIU_QUERY_OPCODE_READ_FLAG:
+		switch (ioctl_data->idn) {
+		case QUERY_FLAG_IDN_FDEVICEINIT:
+		case QUERY_FLAG_IDN_PERMANENT_WPE:
+		case QUERY_FLAG_IDN_PWR_ON_WPE:
+		case QUERY_FLAG_IDN_BKOPS_EN:
+		case QUERY_FLAG_IDN_PURGE_ENABLE:
+		case QUERY_FLAG_IDN_FPHYRESOURCEREMOVAL:
+		case QUERY_FLAG_IDN_BUSY_RTC:
+			break;
+		default:
+			goto out_einval;
+		}
+		err = ufshcd_query_flag(hba, ioctl_data->opcode,
+					ioctl_data->idn, &flag);
+		break;
+	default:
+		goto out_einval;
+	}
+
+	if (err) {
+		dev_err(hba->dev, "%s: Query for idn %d failed\n", __func__,
+					ioctl_data->idn);
+		goto out_release_mem;
+	}
+
+	/*
+	 * copy response data
+	 * As we might end up reading less data then what is specified in
+	 * "ioct_data->buf_size". So we are updating "ioct_data->
+	 * buf_size" to what exactly we have read.
+	 */
+	switch (ioctl_data->opcode) {
+	case UPIU_QUERY_OPCODE_READ_DESC:
+		ioctl_data->buf_size = min_t(int, ioctl_data->buf_size, length);
+		data_ptr = desc;
+		break;
+	case UPIU_QUERY_OPCODE_READ_ATTR:
+		ioctl_data->buf_size = sizeof(u32);
+		data_ptr = &att;
+		break;
+	case UPIU_QUERY_OPCODE_READ_FLAG:
+		ioctl_data->buf_size = 1;
+		data_ptr = &flag;
+		break;
+	default:
+		BUG_ON(true);
+	}
+
+	/* copy to user */
+	err = copy_to_user(buffer, ioctl_data,
+			sizeof(struct ufs_ioctl_query_data));
+	if (err)
+		dev_err(hba->dev, "%s: Failed copying back to user.\n",
+			__func__);
+	err = copy_to_user(buffer + sizeof(struct ufs_ioctl_query_data),
+			data_ptr, ioctl_data->buf_size);
+	if (err)
+		dev_err(hba->dev, "%s: err %d copying back to user.\n",
+				__func__, err);
+	goto out_release_mem;
+
+out_einval:
+	dev_err(hba->dev,
+		"%s: illegal ufs query ioctl data, opcode 0x%x, idn 0x%x\n",
+		__func__, ioctl_data->opcode, (unsigned int)ioctl_data->idn);
+	err = -EINVAL;
+out_release_mem:
+	kfree(ioctl_data);
+	kfree(desc);
+out:
+	return err;
+}
+
+/**
+ * ufshcd_ioctl - ufs ioctl callback registered in scsi_host
+ * @dev: scsi device required for per LUN queries
+ * @cmd: command opcode
+ * @buffer: user space buffer for transferring data
+ *
+ * Supported commands:
+ * UFS_IOCTL_QUERY
+ */
+static int ufshcd_ioctl(struct scsi_device *dev, int cmd, void __user *buffer)
+{
+	struct ufs_hba *hba = shost_priv(dev->host);
+	int err = 0;
+
+	BUG_ON(!hba);
+
+	switch (cmd) {
+	case UFS_IOCTL_QUERY:
+		pm_runtime_get_sync(hba->dev);
+		err = ufshcd_query_ioctl(hba, ufshcd_scsi_to_upiu_lun(dev->lun),
+				buffer);
+		pm_runtime_put_sync(hba->dev);
+		break;
+	case UFS_IOCTL_BLKROSET:
+		err = -ENOIOCTLCMD;
+		break;
+	default:
+		err = -EINVAL;
+		dev_err(hba->dev, "%s: Illegal ufs-IOCTL cmd %d\n", __func__,
+				cmd);
+		break;
+	}
+
+	return err;
+}
+
 static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
@@ -4213,6 +4434,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
+	.ioctl			= ufshcd_ioctl,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d0a66aa..3feb501 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -569,6 +569,7 @@ static inline int scsi_is_wlun(u64 lun)
  * Here are some scsi specific ioctl commands which are sometimes useful.
  *
  * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
+ * include/uapi/scsi/ufs/ioctl.h defines 0x5388
  */
 
 /* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
diff --git a/include/uapi/scsi/Kbuild b/include/uapi/scsi/Kbuild
index 75746d5..d404525 100644
--- a/include/uapi/scsi/Kbuild
+++ b/include/uapi/scsi/Kbuild
@@ -1,5 +1,6 @@
 # UAPI Header export list
 header-y += fc/
+header-y += ufs/
 header-y += scsi_bsg_fc.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
diff --git a/include/uapi/scsi/ufs/Kbuild b/include/uapi/scsi/ufs/Kbuild
new file mode 100644
index 0000000..cc3ef20
--- /dev/null
+++ b/include/uapi/scsi/ufs/Kbuild
@@ -0,0 +1,3 @@
+# UAPI Header export list
+header-y += ioctl.h
+header-y += ufs.h
diff --git a/include/uapi/scsi/ufs/ioctl.h b/include/uapi/scsi/ufs/ioctl.h
new file mode 100644
index 0000000..bc4eed7
--- /dev/null
+++ b/include/uapi/scsi/ufs/ioctl.h
@@ -0,0 +1,57 @@
+#ifndef UAPI_UFS_IOCTL_H_
+#define UAPI_UFS_IOCTL_H_
+
+#include <linux/types.h>
+
+/*
+ *  IOCTL opcode for ufs queries has the following opcode after
+ *  SCSI_IOCTL_GET_PCI
+ */
+#define UFS_IOCTL_QUERY			0x5388
+
+/**
+ * struct ufs_ioctl_query_data - used to transfer data to and from user via ioctl
+ * @opcode: type of data to query (descriptor/attribute/flag)
+ * @idn: id of the data structure
+ * @buf_size: number of allocated bytes/data size on return
+ * @buffer: data location
+ *
+ * Received: buffer and buf_size (available space for transferred data)
+ * Submitted: opcode, idn, length, buf_size
+ */
+struct ufs_ioctl_query_data {
+	/*
+	 * User should select one of the opcode defined in "enum query_opcode".
+	 * Please check include/uapi/scsi/ufs/ufs.h for the definition of it.
+	 * Note that only UPIU_QUERY_OPCODE_READ_DESC,
+	 * UPIU_QUERY_OPCODE_READ_ATTR & UPIU_QUERY_OPCODE_READ_FLAG are
+	 * supported as of now. All other query_opcode would be considered
+	 * invalid.
+	 * As of now only read query operations are supported.
+	 */
+	__u32 opcode;
+	/*
+	 * User should select one of the idn from "enum flag_idn" or "enum
+	 * attr_idn" or "enum desc_idn" based on whether opcode above is
+	 * attribute, flag or descriptor.
+	 * Please check include/uapi/scsi/ufs/ufs.h for the definition of it.
+	 */
+	__u8 idn;
+	/*
+	 * User should specify the size of the buffer (buffer[0] below) where
+	 * it wants to read the query data (attribute/flag/descriptor).
+	 * As we might end up reading less data then what is specified in
+	 * buf_size. So we are updating buf_size to what exactly we have read.
+	 */
+	__u16 buf_size;
+	/*
+	 * placeholder for the start of the data buffer where kernel will copy
+	 * the query data (attribute/flag/descriptor) read from the UFS device
+	 * Note:
+	 * For Read Attribute you will have to allocate 4 bytes
+	 * For Read Flag you will have to allocate 1 byte
+	 */
+	__u8 buffer[0];
+};
+
+#endif /* UAPI_UFS_IOCTL_H_ */
diff --git a/include/uapi/scsi/ufs/ufs.h b/include/uapi/scsi/ufs/ufs.h
new file mode 100644
index 0000000..894ea45
--- /dev/null
+++ b/include/uapi/scsi/ufs/ufs.h
@@ -0,0 +1,66 @@
+#ifndef UAPI_UFS_H_
+#define UAPI_UFS_H_
+
+/* Flag idn for Query Requests*/
+enum flag_idn {
+	QUERY_FLAG_IDN_FDEVICEINIT		= 0x01,
+	QUERY_FLAG_IDN_PERMANENT_WPE		= 0x02,
+	QUERY_FLAG_IDN_PWR_ON_WPE		= 0x03,
+	QUERY_FLAG_IDN_BKOPS_EN			= 0x04,
+	QUERY_FLAG_IDN_RESERVED1		= 0x05,
+	QUERY_FLAG_IDN_PURGE_ENABLE		= 0x06,
+	QUERY_FLAG_IDN_RESERVED2		= 0x07,
+	QUERY_FLAG_IDN_FPHYRESOURCEREMOVAL      = 0x08,
+	QUERY_FLAG_IDN_BUSY_RTC			= 0x09,
+};
+
+/* Attribute idn for Query requests */
+enum attr_idn {
+	QUERY_ATTR_IDN_BOOT_LU_EN		= 0x00,
+	QUERY_ATTR_IDN_RESERVED			= 0x01,
+	QUERY_ATTR_IDN_POWER_MODE		= 0x02,
+	QUERY_ATTR_IDN_ACTIVE_ICC_LVL		= 0x03,
+	QUERY_ATTR_IDN_OOO_DATA_EN		= 0x04,
+	QUERY_ATTR_IDN_BKOPS_STATUS		= 0x05,
+	QUERY_ATTR_IDN_PURGE_STATUS		= 0x06,
+	QUERY_ATTR_IDN_MAX_DATA_IN		= 0x07,
+	QUERY_ATTR_IDN_MAX_DATA_OUT		= 0x08,
+	QUERY_ATTR_IDN_DYN_CAP_NEEDED		= 0x09,
+	QUERY_ATTR_IDN_REF_CLK_FREQ		= 0x0A,
+	QUERY_ATTR_IDN_CONF_DESC_LOCK		= 0x0B,
+	QUERY_ATTR_IDN_MAX_NUM_OF_RTT		= 0x0C,
+	QUERY_ATTR_IDN_EE_CONTROL		= 0x0D,
+	QUERY_ATTR_IDN_EE_STATUS		= 0x0E,
+	QUERY_ATTR_IDN_SECONDS_PASSED		= 0x0F,
+	QUERY_ATTR_IDN_CNTX_CONF		= 0x10,
+	QUERY_ATTR_IDN_CORR_PRG_BLK_NUM		= 0x11,
+};
+
+/* Descriptor idn for Query requests */
+enum desc_idn {
+	QUERY_DESC_IDN_DEVICE		= 0x0,
+	QUERY_DESC_IDN_CONFIGURAION	= 0x1,
+	QUERY_DESC_IDN_UNIT		= 0x2,
+	QUERY_DESC_IDN_RFU_0		= 0x3,
+	QUERY_DESC_IDN_INTERCONNECT	= 0x4,
+	QUERY_DESC_IDN_STRING		= 0x5,
+	QUERY_DESC_IDN_RFU_1		= 0x6,
+	QUERY_DESC_IDN_GEOMETRY		= 0x7,
+	QUERY_DESC_IDN_POWER		= 0x8,
+	QUERY_DESC_IDN_RFU_2		= 0x9,
+	QUERY_DESC_IDN_MAX,
+};
+
+/* UTP QUERY Transaction Specific Fields OpCode */
+enum query_opcode {
+	UPIU_QUERY_OPCODE_NOP		= 0x0,
+	UPIU_QUERY_OPCODE_READ_DESC	= 0x1,
+	UPIU_QUERY_OPCODE_WRITE_DESC	= 0x2,
+	UPIU_QUERY_OPCODE_READ_ATTR	= 0x3,
+	UPIU_QUERY_OPCODE_WRITE_ATTR	= 0x4,
+	UPIU_QUERY_OPCODE_READ_FLAG	= 0x5,
+	UPIU_QUERY_OPCODE_SET_FLAG	= 0x6,
+	UPIU_QUERY_OPCODE_CLEAR_FLAG	= 0x7,
+	UPIU_QUERY_OPCODE_TOGGLE_FLAG	= 0x8,
+};
+#endif /* UAPI_UFS_H_ */
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
