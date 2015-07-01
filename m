From: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH 1/3] hpsa: convert show method snprintf usage to scnprintf
Date: Wed, 1 Jul 2015 03:45:49 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4442E184@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James Bottomley (JBottomley-O3H1v1f1dlM@public.gmane.org)" <JBottomley-O3H1v1f1dlM@public.gmane.org>, ISS StorageDev <iss_storagedev-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> (greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org)" <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Changed all show method snprintf usage to scnprintf per
Documentation/filesystems/sysfs.txt.

Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
---
Please let me know if this is not the correct way to submit
patches by separating them but keeping them logically
together.
--- a/drivers/scsi/hpsa.c	2015-06-25 15:52:15.633031319 -0500
+++ b/drivers/scsi/hpsa.c	2015-06-30 16:12:58.125990687 -0500
@@ -460,7 +460,7 @@ static ssize_t host_show_firmware_revisi
 	if (!h->hba_inquiry_data)
 		return 0;
 	fwrev = &h->hba_inquiry_data[32];
-	return snprintf(buf, 20, "%c%c%c%c\n",
+	return scnprintf(buf, 20, "%c%c%c%c\n",
 		fwrev[0], fwrev[1], fwrev[2], fwrev[3]);
 }
 
@@ -470,7 +470,7 @@ static ssize_t host_show_commands_outsta
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ctlr_info *h = shost_to_hba(shost);
 
-	return snprintf(buf, 20, "%d\n",
+	return scnprintf(buf, 20, "%d\n",
 			atomic_read(&h->commands_outstanding));
 }
 
@@ -481,7 +481,7 @@ static ssize_t host_show_transport_mode(
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	h = shost_to_hba(shost);
-	return snprintf(buf, 20, "%s\n",
+	return scnprintf(buf, 20, "%s\n",
 		h->transMethod & CFGTBL_Trans_Performant ?
 			"performant" : "simple");
 }
@@ -493,7 +493,7 @@ static ssize_t host_show_hp_ssd_smart_pa
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	h = shost_to_hba(shost);
-	return snprintf(buf, 30, "HP SSD Smart Path %s\n",
+	return scnprintf(buf, 30, "HP SSD Smart Path %s\n",
 		(h->acciopath_status == 1) ?  "enabled" : "disabled");
 }
 
@@ -589,7 +589,7 @@ static ssize_t host_show_resettable(stru
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
@@ -714,7 +714,7 @@ static ssize_t host_show_hp_ssd_smart_pa
 	}
 	offload_enabled = hdev->offload_enabled;
 	spin_unlock_irqrestore(&h->lock, flags);
-	return snprintf(buf, 20, "%d\n", offload_enabled);
+	return scnprintf(buf, 20, "%d\n", offload_enabled);
 }
 
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
