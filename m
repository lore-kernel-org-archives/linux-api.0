From: Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH v3 1/3] ACPI / debugger: Add kernel flushing support
Date: Fri, 22 Jul 2016 12:16:58 +0800
Message-ID: <8a5465d7b4ce3ef0bac0113208ce9e2bc2b6ea93.1469155242.git.lv.zheng@intel.com>
References: <cover.1468464391.git.lv.zheng@intel.com> <cover.1469155242.git.lv.zheng@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <cover.1469155242.git.lv.zheng@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch adds debugger log flushing support in kernel via .ioctl()
callback. The in-kernel flushing is more efficient, because it reduces
useless log IOs by bypassing log user_read/kern_write during the flush
period.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: linux-api@vger.kernel.org
---
 drivers/acpi/acpi_dbg.c          |   85 ++++++++++++++++++++++++++++++++++++--
 include/linux/acpi.h             |    1 +
 include/uapi/linux/acpi-ioctls.h |   21 ++++++++++
 3 files changed, 103 insertions(+), 4 deletions(-)
 create mode 100644 include/uapi/linux/acpi-ioctls.h

diff --git a/drivers/acpi/acpi_dbg.c b/drivers/acpi/acpi_dbg.c
index dee8692..a5f4457 100644
--- a/drivers/acpi/acpi_dbg.c
+++ b/drivers/acpi/acpi_dbg.c
@@ -46,6 +46,8 @@
 #define ACPI_AML_KERN		(ACPI_AML_IN_KERN | ACPI_AML_OUT_KERN)
 #define ACPI_AML_BUSY		(ACPI_AML_USER | ACPI_AML_KERN)
 #define ACPI_AML_OPEN		(ACPI_AML_OPENED | ACPI_AML_CLOSED)
+#define ACPI_AML_FLUSHING_LOG	0x0040 /* flushing log output */
+#define ACPI_AML_WAITING_CMD	0x0080 /* waiting for cmd input */
 
 struct acpi_aml_io {
 	wait_queue_head_t wait;
@@ -120,6 +122,16 @@ static inline bool __acpi_aml_busy(void)
 	return false;
 }
 
+static inline bool __acpi_aml_waiting_cmd(void)
+{
+	return !!(acpi_aml_io.flags & ACPI_AML_WAITING_CMD);
+}
+
+static inline bool __acpi_aml_flushing_log(void)
+{
+	return !!(acpi_aml_io.flags & ACPI_AML_FLUSHING_LOG);
+}
+
 static inline bool __acpi_aml_opened(void)
 {
 	if (acpi_aml_io.flags & ACPI_AML_OPEN)
@@ -152,6 +164,26 @@ static bool acpi_aml_busy(void)
 	return ret;
 }
 
+static inline bool acpi_aml_waiting_cmd(void)
+{
+	bool ret;
+
+	mutex_lock(&acpi_aml_io.lock);
+	ret = __acpi_aml_waiting_cmd();
+	mutex_unlock(&acpi_aml_io.lock);
+	return ret;
+}
+
+static inline bool acpi_aml_flushing_log(void)
+{
+	bool ret;
+
+	mutex_lock(&acpi_aml_io.lock);
+	ret = __acpi_aml_flushing_log();
+	mutex_unlock(&acpi_aml_io.lock);
+	return ret;
+}
+
 static bool acpi_aml_used(void)
 {
 	bool ret;
@@ -183,7 +215,8 @@ static bool acpi_aml_kern_writable(void)
 
 	mutex_lock(&acpi_aml_io.lock);
 	ret = !__acpi_aml_access_ok(ACPI_AML_OUT_KERN) ||
-	      __acpi_aml_writable(&acpi_aml_io.out_crc, ACPI_AML_OUT_KERN);
+	      __acpi_aml_writable(&acpi_aml_io.out_crc, ACPI_AML_OUT_KERN) ||
+	      __acpi_aml_flushing_log();
 	mutex_unlock(&acpi_aml_io.lock);
 	return ret;
 }
@@ -264,6 +297,9 @@ static int acpi_aml_write_kern(const char *buf, int len)
 	int n;
 	char *p;
 
+	if (acpi_aml_flushing_log())
+		return len;
+
 	ret = acpi_aml_lock_write(crc, ACPI_AML_OUT_KERN);
 	if (ret < 0)
 		return ret;
@@ -458,9 +494,18 @@ static int acpi_aml_wait_command_ready(bool single_step,
 	else
 		acpi_os_printf("\n%1c ", ACPI_DEBUGGER_COMMAND_PROMPT);
 
+	mutex_lock(&acpi_aml_io.lock);
+	acpi_aml_io.flags |= ACPI_AML_WAITING_CMD;
+	wake_up_interruptible(&acpi_aml_io.wait);
+	mutex_unlock(&acpi_aml_io.lock);
+
 	status = acpi_os_get_line(buffer, length, NULL);
 	if (ACPI_FAILURE(status))
 		return -EINVAL;
+
+	mutex_lock(&acpi_aml_io.lock);
+	acpi_aml_io.flags &= ~ACPI_AML_WAITING_CMD;
+	mutex_unlock(&acpi_aml_io.lock);
 	return 0;
 }
 
@@ -593,9 +638,11 @@ static int acpi_aml_read_user(char __user *buf, int len)
 	smp_rmb();
 	p = &crc->buf[crc->tail];
 	n = min(len, circ_count_to_end(crc));
-	if (copy_to_user(buf, p, n)) {
-		ret = -EFAULT;
-		goto out;
+	if (!acpi_aml_flushing_log()) {
+		if (copy_to_user(buf, p, n)) {
+			ret = -EFAULT;
+			goto out;
+		}
 	}
 	/* sync tail after removing logs */
 	smp_mb();
@@ -731,10 +778,40 @@ static unsigned int acpi_aml_poll(struct file *file, poll_table *wait)
 	return masks;
 }
 
+static int acpi_aml_flush(void)
+{
+	int ret;
+
+	/*
+	 * Discard output buffer and put the driver into a state waiting
+	 * for the new user input.
+	 */
+	mutex_lock(&acpi_aml_io.lock);
+	acpi_aml_io.flags |= ACPI_AML_FLUSHING_LOG;
+	mutex_unlock(&acpi_aml_io.lock);
+
+	ret = wait_event_interruptible(acpi_aml_io.wait,
+		acpi_aml_waiting_cmd());
+	(void)acpi_aml_read_user(NULL, ACPI_AML_BUF_SIZE);
+
+	mutex_lock(&acpi_aml_io.lock);
+	acpi_aml_io.flags &= ~ACPI_AML_FLUSHING_LOG;
+	mutex_unlock(&acpi_aml_io.lock);
+	return ret;
+}
+
+static long acpi_aml_ioctl(struct file *file,
+			   unsigned int cmd, unsigned long arg)
+{
+	return cmd == ACPI_IOCTL_DEBUGGER_FLUSH ?
+	       acpi_aml_flush() : -EINVAL;
+}
+
 static const struct file_operations acpi_aml_operations = {
 	.read		= acpi_aml_read,
 	.write		= acpi_aml_write,
 	.poll		= acpi_aml_poll,
+	.unlocked_ioctl	= acpi_aml_ioctl,
 	.open		= acpi_aml_open,
 	.release	= acpi_aml_release,
 	.llseek		= generic_file_llseek,
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 08235a6..9354fb8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -26,6 +26,7 @@
 #include <linux/resource_ext.h>
 #include <linux/device.h>
 #include <linux/property.h>
+#include <uapi/linux/acpi-ioctls.h>
 
 #ifndef _LINUX
 #define _LINUX
diff --git a/include/uapi/linux/acpi-ioctls.h b/include/uapi/linux/acpi-ioctls.h
new file mode 100644
index 0000000..71b891a
--- /dev/null
+++ b/include/uapi/linux/acpi-ioctls.h
@@ -0,0 +1,21 @@
+/*
+ * ACPI IOCTL collections
+ *
+ * Copyright (C) 2016, Intel Corporation
+ * Authors: Lv Zheng <lv.zheng@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UAPI_LINUX_ACPI_IOCTLS_H
+#define _UAPI_LINUX_ACPI_IOCTLS_H
+
+#include <linux/ioctl.h>
+
+#define ACPI_IOCTL_IDENT		'a'
+
+#define ACPI_IOCTL_DEBUGGER_FLUSH	_IO(ACPI_IOCTL_IDENT, 0x80)
+
+#endif /* _UAPI_LINUX_ACPI_IOCTLS_H */
-- 
1.7.10

