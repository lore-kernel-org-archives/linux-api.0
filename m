From: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Subject: st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Wed, 24 Jun 2015 06:02:12 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3F8E9D88@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Convert DRIVER_ATTR macros to DRIVER_ATTR_RO as requested by
Greg KH. Also switched to using sprintf as nothing printed should
exceed PAGE_SIZE - based on feedback from Greg when implementing
show functions for tape stats.

Suggested-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
---
This patch was implemented on top of the previous patch to
convert to using driver attr groups.
--- a/drivers/scsi/st.c	2015-06-22 20:38:16.061386739 -0500
+++ b/drivers/scsi/st.c	2015-06-23 17:29:03.547867682 -0500
@@ -4427,29 +4427,29 @@ module_exit(exit_st);
 
 
 /* The sysfs driver interface. Read-only at the moment */
-static ssize_t st_try_direct_io_show(struct device_driver *ddp, char *buf)
+static ssize_t try_direct_io_show(struct device_driver *ddp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
+	return sprintf(buf, "%d\n", try_direct_io);
 }
-static DRIVER_ATTR(try_direct_io, S_IRUGO, st_try_direct_io_show, NULL);
+static DRIVER_ATTR_RO(try_direct_io);
 
-static ssize_t st_fixed_buffer_size_show(struct device_driver *ddp, char *buf)
+static ssize_t fixed_buffer_size_show(struct device_driver *ddp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", st_fixed_buffer_size);
+	return sprintf(buf, "%d\n", st_fixed_buffer_size);
 }
-static DRIVER_ATTR(fixed_buffer_size, S_IRUGO, st_fixed_buffer_size_show, NULL);
+static DRIVER_ATTR_RO(fixed_buffer_size);
 
-static ssize_t st_max_sg_segs_show(struct device_driver *ddp, char *buf)
+static ssize_t max_sg_segs_show(struct device_driver *ddp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", st_max_sg_segs);
+	return sprintf(buf, "%d\n", st_max_sg_segs);
 }
-static DRIVER_ATTR(max_sg_segs, S_IRUGO, st_max_sg_segs_show, NULL);
+static DRIVER_ATTR_RO(max_sg_segs);
 
-static ssize_t st_version_show(struct device_driver *ddd, char *buf)
+static ssize_t version_show(struct device_driver *ddd, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "[%s]\n", verstr);
+	return sprintf(buf, "[%s]\n", verstr);
 }
-static DRIVER_ATTR(version, S_IRUGO, st_version_show, NULL);
+static DRIVER_ATTR_RO(version);
 
 static struct attribute *st_drv_attrs[] = {
 	&driver_attr_try_direct_io.attr,
