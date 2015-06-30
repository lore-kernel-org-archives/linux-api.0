From: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH] hpsa: convert DEVICE_ATTR to RO|WO|RW and show methods must
 use scnprintf
Date: Tue, 30 Jun 2015 05:22:20 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3F8EC219@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ISS StorageDev <iss_storagedev-VXdhtT5mjnY@public.gmane.org>, "James Bottomley (JBottomley-O3H1v1f1dlM@public.gmane.org)" <JBottomley-O3H1v1f1dlM@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Changed DEVICE_ATTR macro usage to DEVICE_ATTR_RO|WO|RW.
This also forced some show/store function names to change.

Changed all show method sprint/snprintf usage to scnprintf per
Documentation/filesystems/sysfs.txt.

Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
---
--- a/drivers/scsi/hpsa.c	2015-06-25 15:52:15.633031319 -0500
+++ b/drivers/scsi/hpsa.c	2015-06-29 17:28:24.628475369 -0500
@@ -376,7 +376,7 @@ static int check_for_busy(struct ctlr_in
 }
 
 static u32 lockup_detected(struct ctlr_info *h);
-static ssize_t host_show_lockup_detected(struct device *dev,
+static ssize_t lockup_detected_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	int ld;
@@ -386,10 +386,10 @@ static ssize_t host_show_lockup_detected
 	h = shost_to_hba(shost);
 	ld = lockup_detected(h);
 
-	return sprintf(buf, "ld=%d\n", ld);
+	return scnprintf(buf, PAGE_SIZE, "ld=%d\n", ld);
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
@@ -460,40 +460,40 @@ static ssize_t host_show_firmware_revisi
 	if (!h->hba_inquiry_data)
 		return 0;
 	fwrev = &h->hba_inquiry_data[32];
-	return snprintf(buf, 20, "%c%c%c%c\n",
+	return scnprintf(buf, 20, "%c%c%c%c\n",
 		fwrev[0], fwrev[1], fwrev[2], fwrev[3]);
 }
 
-static ssize_t host_show_commands_outstanding(struct device *dev,
+static ssize_t commands_outstanding_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ctlr_info *h = shost_to_hba(shost);
 
-	return snprintf(buf, 20, "%d\n",
+	return scnprintf(buf, 20, "%d\n",
 			atomic_read(&h->commands_outstanding));
 }
 
-static ssize_t host_show_transport_mode(struct device *dev,
+static ssize_t transport_mode_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	h = shost_to_hba(shost);
-	return snprintf(buf, 20, "%s\n",
+	return scnprintf(buf, 20, "%s\n",
 		h->transMethod & CFGTBL_Trans_Performant ?
 			"performant" : "simple");
 }
 
-static ssize_t host_show_hp_ssd_smart_path_status(struct device *dev,
+static ssize_t hp_ssd_smart_path_status_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	h = shost_to_hba(shost);
-	return snprintf(buf, 30, "HP SSD Smart Path %s\n",
+	return scnprintf(buf, 30, "HP SSD Smart Path %s\n",
 		(h->acciopath_status == 1) ?  "enabled" : "disabled");
 }
 
@@ -582,14 +582,14 @@ static int ctlr_needs_abort_tags_swizzle
 			ARRAY_SIZE(needs_abort_tags_swizzled), board_id);
 }
 
-static ssize_t host_show_resettable(struct device *dev,
+static ssize_t resettable_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	h = shost_to_hba(shost);
-	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h->board_id));
+	return scnprintf(buf, 20, "%d\n", ctlr_is_resettable(h->board_id));
 }
 
 static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
@@ -631,7 +631,7 @@ static ssize_t raid_level_show(struct de
 	/* Is this even a logical drive? */
 	if (!is_logical_dev_addr_mode(hdev->scsi3addr)) {
 		spin_unlock_irqrestore(&h->lock, flags);
-		l = snprintf(buf, PAGE_SIZE, "N/A\n");
+		l = scnprintf(buf, PAGE_SIZE, "N/A\n");
 		return l;
 	}
 
@@ -639,7 +639,7 @@ static ssize_t raid_level_show(struct de
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (rlevel > RAID_UNKNOWN)
 		rlevel = RAID_UNKNOWN;
-	l = snprintf(buf, PAGE_SIZE, "RAID %s\n", raid_label[rlevel]);
+	l = scnprintf(buf, PAGE_SIZE, "RAID %s\n", raid_label[rlevel]);
 	return l;
 }
 
@@ -662,7 +662,7 @@ static ssize_t lunid_show(struct device
 	}
 	memcpy(lunid, hdev->scsi3addr, sizeof(lunid));
 	spin_unlock_irqrestore(&h->lock, flags);
-	return snprintf(buf, 20, "0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+	return scnprintf(buf, 20, "0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 		lunid[0], lunid[1], lunid[2], lunid[3],
 		lunid[4], lunid[5], lunid[6], lunid[7]);
 }
@@ -686,7 +686,7 @@ static ssize_t unique_id_show(struct dev
 	}
 	memcpy(sn, hdev->device_id, sizeof(sn));
 	spin_unlock_irqrestore(&h->lock, flags);
-	return snprintf(buf, 16 * 2 + 2,
+	return scnprintf(buf, 16 * 2 + 2,
 			"%02X%02X%02X%02X%02X%02X%02X%02X"
 			"%02X%02X%02X%02X%02X%02X%02X%02X\n",
 			sn[0], sn[1], sn[2], sn[3],
@@ -695,7 +695,7 @@ static ssize_t unique_id_show(struct dev
 			sn[12], sn[13], sn[14], sn[15]);
 }
 
-static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
+static ssize_t hp_ssd_smart_path_enabled_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
 	struct ctlr_info *h;
@@ -714,30 +714,21 @@ static ssize_t host_show_hp_ssd_smart_pa
 	}
 	offload_enabled = hdev->offload_enabled;
 	spin_unlock_irqrestore(&h->lock, flags);
-	return snprintf(buf, 20, "%d\n", offload_enabled);
+	return scnprintf(buf, 20, "%d\n", offload_enabled);
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
