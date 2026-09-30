Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72128519DFD;
	Wed, 30 Sep 2026 18:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792555; cv=none; b=m4cP7//W9Pk4ZkjNgyJM3Ytv0oEm/g6z8EjlENi0vz2DrJMyHmoIVyW1eP9TieFgecyXbPXDos+TUhTJ9qufRHUdYSSDYUpETC7ZlOGLl9GZcvz05uTU1FHyAEQMZXdFCJBGpGiWyF9fZpSUg/FOVMF8x7wj1isAUaOXxmyr+l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792555; c=relaxed/simple;
	bh=aZtWt5LLIHVBoPR3pe7TFxhb8invAGcE3Ne/y719eqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZnsSSy37DyOVVocpl5P4KtMNGT3wSjWFOxyC35ih/yusxp+648Qu0UGvzW7gJzzCFcc1+ZqUKF5Vjx/vdg32AKYqvvdO/PzANm4I/HyG3AG9Tkxg3b9YQErkvQ8sojRs5oVtMeuqmhj17nZRJOQpBlT6T6r7d4Hx8n94w0YMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DrPun8PI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DrPun8PI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790792552; x=1822328552;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aZtWt5LLIHVBoPR3pe7TFxhb8invAGcE3Ne/y719eqU=;
  b=DrPun8PIX/kgEJ2z5mX2hE58DqCSVGaoOmb1MSAm4+JhEbUQn3CyyJQg
   EvVTrJyILnqDeUAwFrXVeguK8mffC3sW0MbLdx/ogYhxaIqPJeg40mkU3
   V3uPKs497X9WfkzdY98q84RoSrOST1bGeZzXqzCV9BsuIXc2JXwwCNf3e
   Qtsdu0qBZ7vrt1fHZyZ6jHzKmq1lfdXLfOeUOa63ZUVqEfNpWyCh3q+Oq
   fDVXDfxmSjDUbeLRD9mt4tT9/gY6nb/CpW+zNAcw3BOnUPU3XIGCOsm0J
   iIzRYCMM7kCpL63pBQ5ntDgzwYUWTOFFgpL23/tzWSMMV82qzwdSzQC5D
   Q==;
X-CSE-ConnectionGUID: oiJ8SnfjS0GLtVQNYTxEoA==
X-CSE-MsgGUID: lo44cXcAT9WkkWFT8lHjFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="90595380"
X-IronPort-AV: E=Sophos;i="6.27,133,1787036400"; 
   d="scan'208";a="90595380"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 11:22:31 -0700
X-CSE-ConnectionGUID: i25Q1xqiSwWMOMVnHBUhmw==
X-CSE-MsgGUID: TG3wVXm+TbCmtOEyl1ksfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,133,1787036400"; 
   d="scan'208";a="303693740"
Received: from ubuntu.jf.intel.com ([10.54.60.84])
  by fmviesa001.fm.intel.com with ESMTP; 30 Sep 2026 11:22:30 -0700
From: Miguel Vadillo <miguel.vadillo@intel.com>
To: linux-media@vger.kernel.org,
	mchehab@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	sakari.ailus@linux.intel.com,
	hansg@kernel.org,
	laurent.pinchart@ideasonboard.com,
	mehdi.djait@bootlin.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	srini@kernel.org,
	arun.t@intel.com,
	miguel.vadillo@intel.com
Subject: [PATCH] media: i2c: cvs: Add NVMem-based firmware update support
Date: Wed, 30 Sep 2026 11:21:42 -0700
Message-ID: <20260930182142.108744-1-miguel.vadillo@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add firmware update support for the Intel CVS device using the kernel
NVMem provider framework.

Two NVMem devices are registered per CVS device:
 - nvm_active: read-only, exposes the active firmware version by
   querying the device over I2C.
 - nvm_non_active: write-only, root-only, accepts an incoming firmware
   image staged by userspace (e.g. fwupd).

Firmware update is triggered via the nvm_authenticate sysfs attribute,
which supports the following write values:
 1 - Validate staged image, stream to device, and request reset
 2 - Validate and stream image only (no reset request)
 3 - Request reset for a previously streamed image
 0 - Clear update state and reset_pending flag

On a successful write of 1 or 3, a KOBJ_CHANGE uevent is emitted and
nvm_reset_pending is set to signal that a device reset is required to
activate the new firmware.

The nvm_version attribute exposes the running firmware version in
major.minor decimal format. The device_id attribute exposes the device
VID:PID for identification by userspace tools.

Firmware images are streamed to the device in 256-byte or 1KB chunks
over I2C depending on device quirks. The staging buffer is vmalloc'd
on first write and released once the image has been streamed to the
device, or on driver remove if no update was performed.

ABI documentation for all new sysfs attributes is added under
Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs.

The kernel does not inspect the firmware image contents. Signature
verification and anti-rollback enforcement are performed by the CVS
device firmware, which rejects images that fail either check.

Signed-off-by: Miguel Vadillo <miguel.vadillo@intel.com>
---
 .../ABI/testing/sysfs-bus-i2c-devices-cvs     |  53 ++
 MAINTAINERS                                   |   1 +
 drivers/media/i2c/cvs/Kconfig                 |   1 +
 drivers/media/i2c/cvs/core.c                  | 504 +++++++++++++++++-
 drivers/media/i2c/cvs/icvs.h                  |  34 +-
 drivers/media/i2c/cvs/v4l2.c                  |   2 +-
 6 files changed, 572 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs

diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs b/Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs
new file mode 100644
index 000000000000..553532b35f07
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs
@@ -0,0 +1,53 @@
+What:		/sys/bus/i2c/devices/<dev>/nvm_version
+Date:		January 2027
+KernelVersion:	7.4
+Contact:	Miguel Vadillo <miguel.vadillo@intel.com>
+Description:	Returns the active firmware version of the Intel CVS device
+		in "<major>.<minor>" decimal format. This reflects the firmware
+		version currently running on the device.
+
+		This file is read-only and is only present when the CVS device
+		is accessible over I2C.
+
+What:		/sys/bus/i2c/devices/<dev>/nvm_authenticate
+Date:		January 2027
+KernelVersion:	7.4
+Contact:	Miguel Vadillo <miguel.vadillo@intel.com>
+Description:	Reading returns the authentication status of the last firmware
+		update attempt as a hex value. 0x0 indicates success; any
+		non-zero value is an errno from the failed operation.
+
+		Writing triggers a firmware update operation using the image
+		previously staged via the nvm_non_active NVMem region. Accepted
+		values:
+
+		* 0 - Clear the staged update state
+		* 1 - Validate staged image, stream to device, and request reset
+		* 2 - Validate and stream image only (no reset request)
+		* 3 - Request device reset for a previously streamed image
+
+		After a successful write of 1 or 3, a KOBJ_CHANGE uevent is
+		emitted. The new firmware only takes effect once the device
+		has been reset.
+
+		The kernel does not inspect the image contents. Signature
+		verification and anti-rollback enforcement are performed by the
+		CVS device firmware, which rejects images that fail either
+		check.
+
+		This file is only present when the CVS device is accessible
+		over I2C and supports firmware update.
+
+What:		/sys/bus/i2c/devices/<dev>/device_id
+Date:		January 2027
+KernelVersion:	7.4
+Contact:	Miguel Vadillo <miguel.vadillo@intel.com>
+Description:	Returns the device vendor and product identifier in
+		"<vid>:<pid>" lowercase hexadecimal format
+		(e.g. "06cb:0701"). Note this identifies the CVS device
+		make and model, not the individual device instance, and
+		is not necessarily unique when multiple identical devices
+		share the same bus.
+
+		This file is read-only and is only present when the CVS device
+		is accessible over I2C.
diff --git a/MAINTAINERS b/MAINTAINERS
index 72294ddfa5b7..0462ce7a3b2c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13033,6 +13033,7 @@ INTEL COMPUTER VISION SENSING (CVS) DRIVER
 M:	Miguel Vadillo <miguel.vadillo@intel.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-bus-i2c-devices-cvs
 F:	drivers/media/i2c/cvs/
 
 INTEL CPU family model numbers
diff --git a/drivers/media/i2c/cvs/Kconfig b/drivers/media/i2c/cvs/Kconfig
index 4309d20dd726..0a5f4fdc6b66 100644
--- a/drivers/media/i2c/cvs/Kconfig
+++ b/drivers/media/i2c/cvs/Kconfig
@@ -5,6 +5,7 @@ config VIDEO_INTEL_CVS
 	depends on I2C && ACPI && VIDEO_DEV
 	depends on IPU_BRIDGE || !IPU_BRIDGE
 	select MEDIA_CONTROLLER
+	select NVMEM
 	select VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
 	help
diff --git a/drivers/media/i2c/cvs/core.c b/drivers/media/i2c/cvs/core.c
index d4a3b9c3bab1..dc870024da5a 100644
--- a/drivers/media/i2c/cvs/core.c
+++ b/drivers/media/i2c/cvs/core.c
@@ -13,11 +13,15 @@
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
+#include <linux/nvmem-provider.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/time64.h>
+#include <linux/unaligned.h>
+#include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 
 #include <media/ipu-bridge.h>
@@ -25,9 +29,18 @@
 
 #include "icvs.h"
 
-/* Command timeouts determined experimentally */
-#define CMD_TIMEOUT (5 * HZ)
-#define FW_READY_DELAY_MS 100
+/*
+ * FW_LOADER_END has to wait for the device to actually finish writing the
+ * image to flash and exit ICVS_DEV_STATE_DOWNLOAD. Measured completion time
+ * on reference hardware is well under a second, but this is given extra
+ * margin over the generic ICVS_CMD_TIMEOUT since flash commit time can
+ * vary with image size and flash part across supported devices.
+ */
+#define FW_END_TIMEOUT		(10 * HZ)
+#define FW_READY_DELAY_MS	100
+
+#define ICVS_NVM_MIN_SIZE	SZ_4K
+#define ICVS_NVM_MAX_SIZE	SZ_4M
 
 #define PCI_DEVICE_ID_INTEL_IPU7		0x645d	/* MTL / LNL */
 #define PCI_DEVICE_ID_INTEL_IPU7P5		0xb05d	/* ARL / PTL */
@@ -436,6 +449,9 @@ static void cvs_reset(struct icvs *ctx)
  * @work: Embedded delayed_work member
  *
  * Re-reads device state; if device_busy remains set, re-schedules itself.
+ * When ctx->nvm.wait_dl_clear is set (FW_LOADER_END completion), also keeps
+ * re-scheduling while ICVS_DEV_STATE_DOWNLOAD remains set, since the
+ * device can clear BUSY slightly before it exits download mode.
  * Otherwise stores state into wq_resp and completes the command.
  */
 static void cvs_recv(struct work_struct *work)
@@ -450,7 +466,8 @@ static void cvs_recv(struct work_struct *work)
 		return;
 	}
 
-	if (state & ICVS_DEV_STATE_BUSY) {
+	if ((state & ICVS_DEV_STATE_BUSY) ||
+	    (ctx->nvm.wait_dl_clear && (state & ICVS_DEV_STATE_DOWNLOAD))) {
 		dev_dbg(cvs_dev(ctx), "device busy, reschedule\n");
 		schedule_delayed_work(&ctx->work,
 				      msecs_to_jiffies(FW_READY_DELAY_MS));
@@ -466,6 +483,8 @@ static void cvs_recv(struct work_struct *work)
  * @ctx: CVS device context
  * @cmd: Command buffer (icvs_cmd) with cmd_id and param populated
  * @len: Buffer length
+ * @timeout: Timeout (jiffies) to wait for command completion; unused for
+ *	     the GPIO-only ICVS_HOST_SENSOR_OWNER command
  *
  * Dispatches a set of supported commands:
  * - ICVS_SET_DEV_HOST_ID,
@@ -483,7 +502,8 @@ static void cvs_recv(struct work_struct *work)
  * Return: 0 on success, negative errno, -EINVAL for unsupported command
  * or status from device in ctx->wq_resp.
  */
-int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len)
+int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len,
+	     unsigned long timeout)
 {
 	int ret, status = 0;
 
@@ -500,8 +520,7 @@ int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len)
 		if (ret < 0)
 			break;
 
-		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS,
-					    CMD_TIMEOUT);
+		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS, timeout);
 		if (ret < 0)
 			break;
 
@@ -521,8 +540,7 @@ int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len)
 		if (ret < 0)
 			break;
 
-		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS,
-					    CMD_TIMEOUT);
+		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS, timeout);
 		status = (ctx->wq_resp.resp.state &
 			  ICVS_DEV_STATE_ERROR) ? -EINVAL : 0;
 		break;
@@ -532,13 +550,11 @@ int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len)
 		if (ret < 0)
 			break;
 
-		ret = cvs_wait_wake_or_sleep(ctx, CMD_TIMEOUT,
-					     FW_READY_DELAY_MS);
+		ret = cvs_wait_wake_or_sleep(ctx, timeout, FW_READY_DELAY_MS);
 		if (ret)
 			break;
 
-		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS,
-					    CMD_TIMEOUT);
+		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS, timeout);
 		status = (ctx->wq_resp.resp.state &
 			  ICVS_DEV_STATE_DOWNLOAD) ? 0 : -EINVAL;
 		break;
@@ -561,8 +577,7 @@ int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len)
 		if (ret)
 			break;
 
-		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS,
-					    CMD_TIMEOUT);
+		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS, timeout);
 		status = ctx->wq_resp.resp.state &
 			  ICVS_DEV_STATE_ERROR ? -EINVAL : 0;
 		break;
@@ -572,13 +587,13 @@ int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len)
 		if (ret < 0)
 			break;
 
-		ret = cvs_wait_wake_or_sleep(ctx, CMD_TIMEOUT,
-					     FW_READY_DELAY_MS);
+		ret = cvs_wait_wake_or_sleep(ctx, timeout, FW_READY_DELAY_MS);
 		if (ret)
 			break;
 
-		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS,
-					    CMD_TIMEOUT);
+		ctx->nvm.wait_dl_clear = true;
+		ret = cvs_schedule_and_wait(ctx, FW_READY_DELAY_MS, timeout);
+		ctx->nvm.wait_dl_clear = false;
 		status = !(ctx->wq_resp.resp.state &
 			   ICVS_DEV_STATE_DOWNLOAD) ? 0 : -EINVAL;
 		break;
@@ -612,7 +627,7 @@ int cvs_set_link_owner(struct icvs *ctx, enum icvs_csi_link_owner owner)
 	size_t cmd_size = sizeof(cmd.cmd_id) + sizeof(cmd.param.param);
 
 	guard(mutex)(&ctx->lock);
-	return cvs_send(ctx, &cmd, cmd_size);
+	return cvs_send(ctx, &cmd, cmd_size, ICVS_CMD_TIMEOUT);
 }
 
 /**
@@ -641,9 +656,435 @@ static int cvs_configure_dev_caps(struct icvs *ctx)
 		cmd.param.host_id |= ICVS_HOST_ID_RGBCAMERA_PWRUP;
 
 	guard(mutex)(&ctx->lock);
-	return cvs_send(ctx, &cmd, sz);
+	return cvs_send(ctx, &cmd, sz, ICVS_CMD_TIMEOUT);
+}
+
+/**
+ * enum icvs_nvm_auth_mode - nvm_authenticate sysfs write values
+ * @ICVS_NVM_AUTH_CLEAR: Clear the staged update state
+ * @ICVS_NVM_AUTH_WRITE_AND_AUTH: Validate image, stream, and request reset
+ * @ICVS_NVM_AUTH_WRITE_ONLY: Validate and stream image without reset request
+ * @ICVS_NVM_AUTH_AUTH_ONLY: Request reset for previously streamed image
+ */
+enum icvs_nvm_auth_mode {
+	ICVS_NVM_AUTH_CLEAR		= 0,
+	ICVS_NVM_AUTH_WRITE_AND_AUTH	= 1,
+	ICVS_NVM_AUTH_WRITE_ONLY	= 2,
+	ICVS_NVM_AUTH_AUTH_ONLY		= 3,
+};
+
+/**
+ * cvs_nvm_validate - Locate the payload within the staged firmware image
+ * @ctx: CVS device context
+ *
+ * Only the staged image size is checked here. Signature verification and
+ * anti-rollback enforcement are performed by the CVS device firmware, which
+ * rejects images that fail either check.
+ *
+ * Return: 0 on success, -ENODATA when no usable image is staged.
+ */
+static int cvs_nvm_validate(struct icvs *ctx)
+{
+	struct icvs_nvm *nvm = &ctx->nvm;
+	unsigned int header_size = SZ_1K;
+
+	if (ctx->quirks & ICVS_FW_HEADER_SIZE_256)
+		header_size = SZ_256;
+
+	if (!nvm->buf || nvm->buf_total_size < ICVS_NVM_MIN_SIZE)
+		return -ENODATA;
+
+	/* The ICVS_NVM_MIN_SIZE check above keeps this from underflowing */
+	nvm->buf_data_start = nvm->buf + header_size;
+	nvm->buf_data_size = nvm->buf_total_size - header_size;
+
+	return 0;
 }
 
+/**
+ * cvs_do_fw_download - Stream firmware payload to the device over I2C
+ * @ctx: CVS device context (ctx->lock held by caller)
+ * @buf: Firmware payload (header already removed)
+ * @size: Payload size in bytes
+ *
+ * Sends FW_LOADER_START, streams @buf in FW_LOADER_DATA chunks, then
+ * FW_LOADER_END. cvs_send() already waits for and confirms actual flash
+ * completion for FW_LOADER_END (via the BUSY/DOWNLOAD state polling in
+ * cvs_recv()), so its return value is the final result here.
+ *
+ * Return: 0 on success or negative errno.
+ */
+static int cvs_do_fw_download(struct icvs *ctx, const u8 *buf, size_t size)
+{
+	struct icvs_cmd cmd = { };
+	size_t chunk_max, chunk, pos;
+	int ret, end_ret;
+
+	if (ctx->quirks & ICVS_FW_BUF_SIZE_256)
+		chunk_max = SZ_256;
+	else
+		chunk_max = SZ_1K;
+
+	void *fw_buf __free(kfree) = kmalloc(chunk_max + sizeof(__be16),
+					     GFP_KERNEL);
+	if (!fw_buf)
+		return -ENOMEM;
+
+	cmd.cmd_id = cpu_to_be16(ICVS_FW_LOADER_START);
+	ret = cvs_send(ctx, &cmd, sizeof(cmd.cmd_id), ICVS_CMD_TIMEOUT);
+	if (ret < 0)
+		return ret;
+
+	for (pos = 0; pos < size; pos += chunk) {
+		chunk = min(chunk_max, size - pos);
+		put_unaligned_be16(ICVS_FW_LOADER_DATA, fw_buf);
+		memcpy(fw_buf + sizeof(__be16), buf + pos, chunk);
+
+		ret = cvs_send(ctx, fw_buf, sizeof(__be16) + chunk,
+			       ICVS_CMD_TIMEOUT);
+		if (ret < 0) {
+			dev_err(cvs_dev(ctx),
+				"FW data chunk send failed: %d\n", ret);
+			break;
+		}
+	}
+
+	/* Always send FW_LOADER_END, but keep any earlier DATA error. */
+	cmd.cmd_id = cpu_to_be16(ICVS_FW_LOADER_END);
+	end_ret = cvs_send(ctx, &cmd, sizeof(cmd.cmd_id), FW_END_TIMEOUT);
+
+	return ret < 0 ? ret : end_ret;
+}
+
+/* cvs_nvm_active_read - NVMem read callback for active firmware region */
+static int cvs_nvm_active_read(void *priv, unsigned int offset,
+			       void *val, size_t bytes)
+{
+	__be16 op = cpu_to_be16(ICVS_GET_DEV_FW_VERSION);
+	struct icvs_fw_version fw_ver = { };
+	struct icvs *ctx = priv;
+	struct device *dev = cvs_dev(ctx);
+	size_t avail = sizeof(fw_ver);
+	size_t len;
+	int ret;
+
+	if (offset >= avail)
+		return -EINVAL;
+
+	PM_RUNTIME_ACQUIRE_IF_ENABLED_AUTOSUSPEND(dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
+	if (ret)
+		return ret;
+
+	scoped_guard(mutex, &ctx->lock) {
+		ret = cvs_read_i2c(ctx, op, &fw_ver, sizeof(fw_ver));
+		if (ret)
+			return ret;
+	}
+
+	len = min(bytes, avail - offset);
+	memcpy(val, (void *)&fw_ver + offset, len);
+
+	return 0;
+}
+
+/*
+ * cvs_nvm_write_buf - NVMem write callback for non-active firmware staging
+ *
+ * Serialized against nvm_authenticate_store() via ctx->lock, since both
+ * read and mutate the shared staging buffer and its size/flushed state.
+ *
+ * offset + bytes is always used as the new total size (rather than only
+ * growing it) so that staging a new, smaller image after a larger one
+ * does not leave stale trailing bytes from the previous image in the
+ * buffer that would otherwise be sent to the device.
+ */
+static int cvs_nvm_write_buf(void *priv, unsigned int offset,
+			     void *val, size_t bytes)
+{
+	struct icvs *ctx = priv;
+	struct icvs_nvm *nvm = &ctx->nvm;
+
+	guard(mutex)(&ctx->lock);
+
+	if (!nvm->buf)
+		nvm->buf = vmalloc(ICVS_NVM_MAX_SIZE);
+	if (!nvm->buf)
+		return -ENOMEM;
+
+	memcpy(nvm->buf + offset, val, bytes);
+	nvm->buf_total_size = offset + bytes;
+	nvm->flushed = false;
+
+	return 0;
+}
+
+/**
+ * cvs_nvm_add_active - Register read-only NVMem device for active FW version
+ * @ctx: CVS device context
+ *
+ * Registers an NVMem device named "nvm_active" whose read callback queries
+ * the device for its currently running firmware version.
+ *
+ * Return: 0 on success or negative errno.
+ */
+static int cvs_nvm_add_active(struct icvs *ctx)
+{
+	struct nvmem_config config = {
+		.name = "nvm_active",
+		.id = NVMEM_DEVID_NONE,
+		.dev = cvs_dev(ctx),
+		.owner = THIS_MODULE,
+		.read_only = true,
+		.reg_read = cvs_nvm_active_read,
+		.priv = ctx,
+		.stride = 4,
+		.word_size = 4,
+		.size = sizeof(struct icvs_fw_version),
+	};
+	struct nvmem_device *nvmem;
+
+	nvmem = nvmem_register(&config);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	ctx->nvm.active = nvmem;
+
+	return 0;
+}
+
+/**
+ * cvs_nvm_add_non_active - Register write-only NVMem device for FW staging
+ * @ctx: CVS device context
+ *
+ * Registers an NVMem device named "nvm_non_active" that accepts an incoming
+ * firmware image written by userspace (e.g. fwupd via dd). The image is
+ * buffered in memory until nvm_authenticate triggers the actual download.
+ * Access is restricted to root.
+ *
+ * Return: 0 on success or negative errno.
+ */
+static int cvs_nvm_add_non_active(struct icvs *ctx)
+{
+	struct nvmem_config config = {
+		.name = "nvm_non_active",
+		.id = NVMEM_DEVID_NONE,
+		.dev = cvs_dev(ctx),
+		.owner = THIS_MODULE,
+		.root_only = true,
+		.reg_write = cvs_nvm_write_buf,
+		.priv = ctx,
+		.stride = 4,
+		.word_size = 4,
+		.size = ICVS_NVM_MAX_SIZE,
+	};
+	struct nvmem_device *nvmem;
+
+	nvmem = nvmem_register(&config);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	ctx->nvm.non_active = nvmem;
+
+	return 0;
+}
+
+/**
+ * cvs_nvm_release_buf - Free the firmware staging buffer
+ * @nvm: NVM state to release the buffer from
+ *
+ * Frees the vmalloc'd staging buffer once it is no longer needed, either
+ * right after a successful download or during teardown. Does not touch
+ * @nvm->flushed, since a successfully streamed image must stay reflected
+ * there even after the buffer backing it has been released.
+ */
+static void cvs_nvm_release_buf(struct icvs_nvm *nvm)
+{
+	vfree(nvm->buf);
+	nvm->buf = NULL;
+	nvm->buf_total_size = 0;
+	nvm->buf_data_start = NULL;
+	nvm->buf_data_size = 0;
+}
+
+/**
+ * cvs_nvm_free - Release firmware staging buffer
+ * @ctx: CVS device context
+ *
+ * Frees the vmalloc'd buffer used to stage the incoming firmware image
+ * and resets all associated NVM state fields.
+ */
+static void cvs_nvm_free(struct icvs *ctx)
+{
+	nvmem_unregister(ctx->nvm.non_active);
+	ctx->nvm.non_active = NULL;
+	nvmem_unregister(ctx->nvm.active);
+	ctx->nvm.active = NULL;
+	cvs_nvm_release_buf(&ctx->nvm);
+	ctx->nvm.flushed = false;
+}
+
+static ssize_t nvm_version_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	__be16 op = cpu_to_be16(ICVS_GET_DEV_FW_VERSION);
+	struct icvs *ctx = dev_get_drvdata(dev);
+	struct icvs_fw_version fw_ver = { };
+	int ret;
+
+	PM_RUNTIME_ACQUIRE_IF_ENABLED_AUTOSUSPEND(dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
+	if (ret)
+		return ret;
+
+	scoped_guard(mutex, &ctx->lock) {
+		ret = cvs_read_i2c(ctx, op, &fw_ver, sizeof(fw_ver));
+		if (ret)
+			return ret;
+	}
+
+	return sysfs_emit(buf, "%u.%u\n", fw_ver.major, fw_ver.minor);
+}
+static DEVICE_ATTR_RO(nvm_version);
+
+static ssize_t nvm_authenticate_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct icvs *ctx = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%#x\n", ctx->nvm.auth_status);
+}
+
+static ssize_t nvm_authenticate_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct icvs *ctx = dev_get_drvdata(dev);
+	bool do_uevent = false;
+	unsigned int val;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+	if (val > ICVS_NVM_AUTH_AUTH_ONLY)
+		return -EINVAL;
+
+	PM_RUNTIME_ACQUIRE_IF_ENABLED_AUTOSUSPEND(dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
+	if (ret)
+		return ret;
+
+	mutex_lock(&ctx->lock);
+	ctx->nvm.auth_status = 0;
+
+	switch (val) {
+	case ICVS_NVM_AUTH_CLEAR:
+		ctx->nvm.flushed = false;
+		break;
+
+	case ICVS_NVM_AUTH_WRITE_ONLY:
+	case ICVS_NVM_AUTH_WRITE_AND_AUTH:
+		ret = cvs_nvm_validate(ctx);
+		if (ret)
+			goto err_status;
+
+		ret = cvs_do_fw_download(ctx, ctx->nvm.buf_data_start,
+					 ctx->nvm.buf_data_size);
+		if (ret)
+			goto err_status;
+
+		ctx->nvm.flushed = true;
+		cvs_nvm_release_buf(&ctx->nvm);
+
+		if (val == ICVS_NVM_AUTH_WRITE_ONLY)
+			break;
+
+		fallthrough;
+
+	case ICVS_NVM_AUTH_AUTH_ONLY:
+		if (!ctx->nvm.flushed) {
+			ret = -ENODATA;
+			goto err_status;
+		}
+
+		do_uevent = true;
+		break;
+	}
+
+	mutex_unlock(&ctx->lock);
+
+	if (do_uevent)
+		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+
+	return count;
+
+err_status:
+	ctx->nvm.auth_status = -ret;
+	mutex_unlock(&ctx->lock);
+
+	return ret;
+}
+static DEVICE_ATTR_RW(nvm_authenticate);
+
+static ssize_t device_id_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct icvs *ctx = dev_get_drvdata(dev);
+	struct icvs_resp n = { };
+	int ret;
+
+	PM_RUNTIME_ACQUIRE_IF_ENABLED_AUTOSUSPEND(dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
+	if (ret)
+		return ret;
+
+	n.cmd_id = cpu_to_be16(ICVS_GET_DEV_VID_PID);
+	scoped_guard(mutex, &ctx->lock) {
+		ret = cvs_read_i2c(ctx, n.cmd_id, &n.resp.vid_pid,
+				   sizeof(n.resp.vid_pid));
+		if (ret)
+			return ret;
+	}
+
+	return sysfs_emit(buf, "%04x:%04x\n",
+			  n.resp.vid_pid.v_id, n.resp.vid_pid.p_id);
+}
+static DEVICE_ATTR_RO(device_id);
+
+static umode_t cvs_fw_attr_visible(struct kobject *kobj,
+				   const struct attribute *attr, int n)
+{
+	struct icvs *ctx = dev_get_drvdata(kobj_to_dev(kobj));
+
+	/* Every attribute in this group needs the I2C transport */
+	if (!ctx->i2c_client)
+		return 0;
+
+	if ((ctx->quirks & ICVS_NO_FW_UPDATE) &&
+	    attr == &dev_attr_nvm_authenticate.attr)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute *const cvs_fw_attrs[] = {
+	&dev_attr_nvm_version.attr,
+	&dev_attr_nvm_authenticate.attr,
+	&dev_attr_device_id.attr,
+	NULL
+};
+
+static const struct attribute_group cvs_fw_group = {
+	.attrs_const = cvs_fw_attrs,
+	.is_visible_const = cvs_fw_attr_visible,
+};
+
+static const struct attribute_group *cvs_fw_groups[] = {
+	&cvs_fw_group,
+	NULL
+};
+
 /**
  * cvs_core_probe - Shared probe path for I2C & platform instantiation
  * @dev: Parent device
@@ -806,11 +1247,28 @@ static int cvs_core_probe(struct device *dev, struct i2c_client *i2c)
 	pm_runtime_enable(dev);
 	pm_runtime_idle(dev);
 
+	if (ctx->i2c_client) {
+		ret = cvs_nvm_add_active(ctx);
+		if (ret) {
+			dev_err_probe(dev, ret, "NVM active register failed\n");
+			goto err_csi_remove;
+		}
+
+		ret = cvs_nvm_add_non_active(ctx);
+		if (ret) {
+			dev_err_probe(dev, ret,
+				      "NVM non-active register failed\n");
+			goto err_csi_remove;
+		}
+	}
+
 	/*
 	 * Create a PM runtime device link with IPU as consumer and CVS as
 	 * supplier. When the IPU runtime-resumes to start streaming, the PM
 	 * framework automatically resumes CVS first, triggering
 	 * cvs_runtime_resume() which hands CSI-2 link ownership to the host.
+	 * Kept as the last probe step so it is only established once the
+	 * device is otherwise fully initialized.
 	 */
 	ctx->ipu_link = device_link_add(&ipu->dev, dev,
 					DL_FLAG_PM_RUNTIME |
@@ -830,6 +1288,7 @@ static int cvs_core_probe(struct device *dev, struct i2c_client *i2c)
 	return 0;
 
 err_csi_remove:
+	cvs_nvm_free(ctx);
 	if (ctx->ipu_link)
 		device_link_del(ctx->ipu_link);
 	cvs_csi_remove(ctx);
@@ -864,6 +1323,7 @@ static void cvs_core_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&ctx->work);
 	cvs_csi_remove(ctx);
+	cvs_nvm_free(ctx);
 
 	if (ctx->ipu_link)
 		device_link_del(ctx->ipu_link);
@@ -973,6 +1433,7 @@ static struct i2c_driver cvs_driver = {
 	.driver = {
 		.name = "intel_cvs",
 		.acpi_match_table = intel_cvs_acpi_match,
+		.dev_groups = cvs_fw_groups,
 		.pm = pm_ptr(&cvs_pm_ops),
 	},
 	.probe = cvs_probe,
@@ -1000,6 +1461,7 @@ static struct platform_driver cvs_platform_driver = {
 	.driver = {
 		.name = "cvs_platform",
 		.acpi_match_table = intel_cvs_acpi_match,
+		.dev_groups = cvs_fw_groups,
 		.pm = pm_ptr(&cvs_pm_ops),
 	},
 	.probe = cvs_platform_probe,
diff --git a/drivers/media/i2c/cvs/icvs.h b/drivers/media/i2c/cvs/icvs.h
index 17beb0920dd2..d0f4e3d02058 100644
--- a/drivers/media/i2c/cvs/icvs.h
+++ b/drivers/media/i2c/cvs/icvs.h
@@ -8,7 +8,9 @@
 
 #include <linux/bits.h>
 #include <linux/completion.h>
+#include <linux/jiffies.h>
 #include <linux/mutex.h>
+#include <linux/nvmem-provider.h>
 #include <linux/workqueue.h>
 #include <linux/types.h>
 #include <linux/wait.h>
@@ -38,6 +40,30 @@ struct i2c_client;
 /* Firmware response prefix (optional, for protocol revision 2.x or newer) */
 #define ICVS_PREFIX_VAL	0xCAFEB0BA
 
+/**
+ * struct icvs_nvm - NVM firmware staging and update state
+ * @buf: vmalloc'd buffer staging the incoming firmware image
+ * @buf_data_start: Pointer to payload start (past header)
+ * @active: Read-only NVMem device exposing active firmware version region
+ * @non_active: Write-only NVMem device accepting incoming firmware image
+ * @buf_total_size: Total bytes written into @buf by fwupd
+ * @buf_data_size: Payload byte count (total minus header)
+ * @auth_status: Last nvm_authenticate error (0 = success)
+ * @flushed: True after payload has been successfully streamed to device
+ * @wait_dl_clear: cvs_recv() keeps polling past BUSY until DOWNLOAD clears
+ */
+struct icvs_nvm {
+	u8 *buf;
+	u8 *buf_data_start;
+	struct nvmem_device *active;
+	struct nvmem_device *non_active;
+	unsigned int buf_total_size;
+	unsigned int buf_data_size;
+	unsigned int auth_status;
+	bool flushed;
+	bool wait_dl_clear;
+};
+
 /*
  * CSI bridge sub-device definitions
  */
@@ -443,6 +469,7 @@ enum icvs_state {
  * @irq: Wake IRQ (full capability)
  * @hostwake_event: Waitqueue for wake events
  * @hostwake_event_arg: Wake event flag
+ * @nvm: NVMem firmware staging and update state
  */
 struct icvs {
 	struct i2c_client *i2c_client;
@@ -468,6 +495,7 @@ struct icvs {
 	int irq;
 	wait_queue_head_t hostwake_event;
 	bool hostwake_event_arg;
+	struct icvs_nvm nvm;
 };
 
 /**
@@ -484,8 +512,12 @@ static inline struct device *cvs_dev(struct icvs *ctx)
 	return ctx->i2c_client ? &ctx->i2c_client->dev : ctx->subdev.dev;
 }
 
+/* Command timeout (jiffies) determined experimentally */
+#define ICVS_CMD_TIMEOUT (5 * HZ)
+
 /* Cross-unit interfaces */
-int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len);
+int cvs_send(struct icvs *ctx, struct icvs_cmd *cmd, size_t len,
+	     unsigned long timeout);
 int cvs_set_link_owner(struct icvs *ctx, enum icvs_csi_link_owner owner);
 int cvs_csi_init(struct icvs *ctx, struct device *dev, struct i2c_client *i2c);
 void cvs_csi_remove(struct icvs *ctx);
diff --git a/drivers/media/i2c/cvs/v4l2.c b/drivers/media/i2c/cvs/v4l2.c
index 9fadca7a3bee..c74fbd0cda5d 100644
--- a/drivers/media/i2c/cvs/v4l2.c
+++ b/drivers/media/i2c/cvs/v4l2.c
@@ -64,7 +64,7 @@ static int csi_set_link_cfg(struct icvs *ctx, u64 link_freq)
 	size_t cmd_size = sizeof(cmd.cmd_id) + sizeof(cmd.param.conf);
 
 	guard(mutex)(&ctx->lock);
-	return cvs_send(ctx, &cmd, cmd_size);
+	return cvs_send(ctx, &cmd, cmd_size, ICVS_CMD_TIMEOUT);
 }
 
 /*

base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.43.0

