From: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH 3/3] hpsa: Convert DEVICE_ATTR macro usage to
 DEVICE_ATTR_RO|WR|WO
Date: Wed, 1 Jul 2015 03:47:10 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4442E19F@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James Bottomley (JBottomley-O3H1v1f1dlM@public.gmane.org)" <JBottomley-O3H1v1f1dlM@public.gmane.org>, ISS StorageDev <iss_storagedev-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> (greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org)" <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Convert DEVICE_ATTR macro usage to DEVICE_ATTR_RO|WR|WO
Changes forced some function names to change.

Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
---
--- a/drivers/scsi/hpsa.c	2015-06-30 16:34:01.403904650 -0500
+++ b/drivers/scsi/hpsa.c	2015-06-30 16:21:54.214954176 -0500
@@ -376,7 +376,7 @@ static int check_for_busy(struct ctlr_in
 }
 
 static u32 lockup_detected(struct ctlr_info *h);
-static ssize_t host_show_lockup_detected(struct device *dev,
+static ssize_t lockup_detected_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	int ld;
@@ -389,7 +389,7 @@ static ssize_t host_show_lockup_detected
 	return sprintf(buf, "ld=%d\n", ld);
 }
 
-static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
+static ssize_t hp_ssd_smart_path_status_store(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
@@ -413,7 +413,7 @@ static ssize_t host_store_hp_ssd_smart_p
 	return count;
 }
 
-static ssize_t host_store_raid_offload_debug(struct device *dev,
+static ssize_t raid_offload_debug_store(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
@@ -438,7 +438,7 @@ static ssize_t host_store_raid_offload_d
 	return count;
 }
 
-static ssize_t host_store_rescan(struct device *dev,
+static ssize_t rescan_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
@@ -449,7 +449,7 @@ static ssize_t host_store_rescan(struct
 	return count;
 }
 
-static ssize_t host_show_firmware_revision(struct device *dev,
+static ssize_t firmware_revision_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
@@ -464,7 +464,7 @@ static ssize_t host_show_firmware_revisi
 		fwrev[0], fwrev[1], fwrev[2], fwrev[3]);
 }
 
-static ssize_t host_show_commands_outstanding(struct device *dev,
+static ssize_t commands_outstanding_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
@@ -474,7 +474,7 @@ static ssize_t host_show_commands_outsta
 			atomic_read(&h->commands_outstanding));
 }
 
-static ssize_t host_show_transport_mode(struct device *dev,
+static ssize_t transport_mode_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
@@ -486,7 +486,7 @@ static ssize_t host_show_transport_mode(
 			"performant" : "simple");
 }
 
-static ssize_t host_show_hp_ssd_smart_path_status(struct device *dev,
+static ssize_t hp_ssd_smart_path_status_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
@@ -582,7 +582,7 @@ static int ctlr_needs_abort_tags_swizzle
 			ARRAY_SIZE(needs_abort_tags_swizzled), board_id);
 }
 
-static ssize_t host_show_resettable(struct device *dev,
+static ssize_t resettable_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
@@ -692,7 +692,7 @@ static ssize_t unique_id_show(struct dev
 			sn[12], sn[13], sn[14], sn[15]);
 }
 
-static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
+static ssize_t hp_ssd_smart_path_enabled_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
@@ -714,27 +714,18 @@ static ssize_t host_show_hp_ssd_smart_pa
 	return scnprintf(buf, 20, "%d\n", offload_enabled);
 }
 
-static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
-static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
-static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
-static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
-static DEVICE_ATTR(hp_ssd_smart_path_enabled, S_IRUGO,
-			host_show_hp_ssd_smart_path_enabled, NULL);
-static DEVICE_ATTR(hp_ssd_smart_path_status, S_IWUSR|S_IRUGO|S_IROTH,
-		host_show_hp_ssd_smart_path_status,
-		host_store_hp_ssd_smart_path_status);
-static DEVICE_ATTR(raid_offload_debug, S_IWUSR, NULL,
-			host_store_raid_offload_debug);
-static DEVICE_ATTR(firmware_revision, S_IRUGO,
-	host_show_firmware_revision, NULL);
-static DEVICE_ATTR(commands_outstanding, S_IRUGO,
-	host_show_commands_outstanding, NULL);
-static DEVICE_ATTR(transport_mode, S_IRUGO,
-	host_show_transport_mode, NULL);
-static DEVICE_ATTR(resettable, S_IRUGO,
-	host_show_resettable, NULL);
-static DEVICE_ATTR(lockup_detected, S_IRUGO,
-	host_show_lockup_detected, NULL);
+static DEVICE_ATTR_RO(raid_level);
+static DEVICE_ATTR_RO(lunid);
+static DEVICE_ATTR_RO(unique_id);
+static DEVICE_ATTR_WO(rescan);
+static DEVICE_ATTR_RO(hp_ssd_smart_path_enabled);
+static DEVICE_ATTR_RW(hp_ssd_smart_path_status);
+static DEVICE_ATTR_WO(raid_offload_debug);
+static DEVICE_ATTR_RO(firmware_revision);
+static DEVICE_ATTR_RO(commands_outstanding);
+static DEVICE_ATTR_RO(transport_mode);
+static DEVICE_ATTR_RO(resettable);
+static DEVICE_ATTR_RO(lockup_detected);
 
 static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
