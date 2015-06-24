From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: [PATCH v2] st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Wed, 24 Jun 2015 06:54:35 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3F8E9E02@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Greg KH <gregkh@linuxfoundation.org> (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
Cc: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>
List-Id: linux-api@vger.kernel.org


Convert DRIVER_ATTR macros to DRIVER_ATTR_RO requested by
Greg KH. Also switched to using scnprintf instead of snprintf
per Documentation/filesystems/sysfs.txt.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Shane Seymour <shane.seymour@hp.com>
---
This patch was implemented on top of the previous patch to
convert to using driver attr groups.

Changes from v1:
- switched to scnprintf from sprintf after feedback from Sergey
Senozhatsky.
--- a/drivers/scsi/st.c	2015-06-22 20:38:16.061386739 -0500
+++ b/drivers/scsi/st.c	2015-06-23 19:59:21.302775649 -0500
@@ -4427,29 +4427,29 @@ module_exit(exit_st);
 
 
 /* The sysfs driver interface. Read-only at the moment */
-static ssize_t st_try_direct_io_show(struct device_driver *ddp, char *buf)
+static ssize_t try_direct_io_show(struct device_driver *ddp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
 }
-static DRIVER_ATTR(try_direct_io, S_IRUGO, st_try_direct_io_show, NULL);
+static DRIVER_ATTR_RO(try_direct_io);
 
-static ssize_t st_fixed_buffer_size_show(struct device_driver *ddp, char *buf)
+static ssize_t fixed_buffer_size_show(struct device_driver *ddp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", st_fixed_buffer_size);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", st_fixed_buffer_size);
 }
-static DRIVER_ATTR(fixed_buffer_size, S_IRUGO, st_fixed_buffer_size_show, NULL);
+static DRIVER_ATTR_RO(fixed_buffer_size);
 
-static ssize_t st_max_sg_segs_show(struct device_driver *ddp, char *buf)
+static ssize_t max_sg_segs_show(struct device_driver *ddp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", st_max_sg_segs);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", st_max_sg_segs);
 }
-static DRIVER_ATTR(max_sg_segs, S_IRUGO, st_max_sg_segs_show, NULL);
+static DRIVER_ATTR_RO(max_sg_segs);
 
-static ssize_t st_version_show(struct device_driver *ddd, char *buf)
+static ssize_t version_show(struct device_driver *ddd, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "[%s]\n", verstr);
+	return scnprintf(buf, PAGE_SIZE, "[%s]\n", verstr);
 }
-static DRIVER_ATTR(version, S_IRUGO, st_version_show, NULL);
+static DRIVER_ATTR_RO(version);
 
 static struct attribute *st_drv_attrs[] = {
 	&driver_attr_try_direct_io.attr,
