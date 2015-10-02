From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Add support for EDD4 fields and types.
Date: Fri,  2 Oct 2015 10:34:27 -0400
Message-ID: <1443796467-13475-1-git-send-email-pjones@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Back in 2010, t13 EDD version 4 added a couple of storage types, some
host bridge types (that are pretty much all represented identically),
and a couple of fields on existing storage types.

This change makes the driver expose those to userland.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/edd.c   | 15 ++++++++++-----
 include/uapi/linux/edd.h |  6 +++++-
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index e229576..5092b92 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -152,15 +152,15 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 			     info->params.interface_path.isa.base_address);
 	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
 		   !strncmp(info->params.host_bus_type, "PCI", 3) ||
-		   !strncmp(info->params.host_bus_type, "XPRS", 4)) {
+		   !strncmp(info->params.host_bus_type, "XPRS", 4) ||
+		   !strncmp(info->params.host_bus_type, "HTPT", 4)) {
 		p += scnprintf(p, left,
 			     "\t%02x:%02x.%d  channel: %u\n",
 			     info->params.interface_path.pci.bus,
 			     info->params.interface_path.pci.slot,
 			     info->params.interface_path.pci.function,
 			     info->params.interface_path.pci.channel);
-	} else if (!strncmp(info->params.host_bus_type, "IBND", 4) ||
-		   !strncmp(info->params.host_bus_type, "HTPT", 4)) {
+	} else if (!strncmp(info->params.host_bus_type, "IBND", 4)) {
 		p += scnprintf(p, left,
 			     "\tTBD: %llx\n",
 			     info->params.interface_path.ibnd.reserved);
@@ -220,8 +220,13 @@ edd_show_interface(struct edd_device *edev, char *buf)
 		p += scnprintf(p, left, "\tidentity_tag: %x\n",
 			     info->params.device_path.raid.array_number);
 	} else if (!strncmp(info->params.interface_type, "SATA", 4)) {
-		p += scnprintf(p, left, "\tdevice: %u\n",
-			     info->params.device_path.sata.device);
+		p += scnprintf(p, left, "\tdevice: %u pmp: %u\n",
+			     info->params.device_path.sata.device,
+			     info->params.device_path.sata.pmp);
+	} else if (!strncmp(info->params.interface_type, "SAS", 4)) {
+		p += scnprintf(p, left, "\taddress: %llx lun: %llx\n",
+			       info->params.device_path.sas.address,
+			       info->params.device_path.sas.lun);
 	} else {
 		p += scnprintf(p, left, "\tunknown: %llx %llx\n",
 			     info->params.device_path.unknown.reserved1,
diff --git a/include/uapi/linux/edd.h b/include/uapi/linux/edd.h
index 89240a0..aff4573 100644
--- a/include/uapi/linux/edd.h
+++ b/include/uapi/linux/edd.h
@@ -155,12 +155,16 @@ struct edd_device_params {
 		} __attribute__ ((packed)) raid;
 		struct {
 			__u8 device;
-			__u8 reserved1;
+			__u8 pmp;
 			__u16 reserved2;
 			__u32 reserved3;
 			__u64 reserved4;
 		} __attribute__ ((packed)) sata;
 		struct {
+			__u64 address;
+			__u64 lun;
+		} __attribute__ ((packed)) sas;
+		struct {
 			__u64 reserved1;
 			__u64 reserved2;
 		} __attribute__ ((packed)) unknown;
-- 
2.5.0
