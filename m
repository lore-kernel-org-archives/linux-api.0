From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: [PATCH v2] scsi: dpt: remove i2o header in uapi
Date: Sun,  4 Oct 2015 01:22:50 +0200
Message-ID: <1443914571-19312-1-git-send-email-gabriel@lse.epita.fr>
References: <1443712510-6714-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443712510-6714-1-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adaptec OEM Raid Solutions <aacraid-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Masahiro Yamada <yamada.m-NAum8xwdG0+S7A1Ibl2khg@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, "open list:DPT_I2O SCSI RAID DRIVER" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The i2o subsystem was removed by
commit 4a72a7af462d ("staging: remove i2o subsystem") but the header was
still used by drivers/scsi/dpt_i2o.c driver.

This patch moves the structures used from the header into dpti_i2o.h.

CC: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
CC: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
---
 drivers/scsi/dpt/dpti_i2o.h  | 134 +++++++++++++-
 include/uapi/linux/Kbuild    |   1 -
 include/uapi/linux/i2o-dev.h | 421 -------------------------------------------
 3 files changed, 132 insertions(+), 424 deletions(-)
 delete mode 100644 include/uapi/linux/i2o-dev.h

diff --git a/drivers/scsi/dpt/dpti_i2o.h b/drivers/scsi/dpt/dpti_i2o.h
index bd9e31e..50515d3 100644
--- a/drivers/scsi/dpt/dpti_i2o.h
+++ b/drivers/scsi/dpt/dpti_i2o.h
@@ -19,8 +19,6 @@
 
 #ifdef __KERNEL__       /* This file to be included by kernel only */
 
-#include <linux/i2o-dev.h>
-
 #include <linux/notifier.h>
 #include <linux/atomic.h>
 
@@ -41,6 +39,137 @@
 
 #define I2O_MAX_MANAGERS	4
 
+#define I2O_BUS_LOCAL	0
+#define I2O_BUS_ISA	1
+#define I2O_BUS_EISA	2
+/* was  I2O_BUS_MCA	3 */
+#define I2O_BUS_PCI	4
+#define I2O_BUS_PCMCIA	5
+#define I2O_BUS_NUBUS	6
+#define I2O_BUS_CARDBUS 7
+#define I2O_BUS_UNKNOWN 0x80
+
+typedef struct _i2o_pci_bus {
+	__u8 PciFunctionNumber;
+	__u8 PciDeviceNumber;
+	__u8 PciBusNumber;
+	__u8 reserved;
+	__u16 PciVendorID;
+	__u16 PciDeviceID;
+} i2o_pci_bus;
+
+typedef struct _i2o_local_bus {
+	__u16 LbBaseIOPort;
+	__u16 reserved;
+	__u32 LbBaseMemoryAddress;
+} i2o_local_bus;
+
+typedef struct _i2o_isa_bus {
+	__u16 IsaBaseIOPort;
+	__u8 CSN;
+	__u8 reserved;
+	__u32 IsaBaseMemoryAddress;
+} i2o_isa_bus;
+
+typedef struct _i2o_eisa_bus_info {
+	__u16 EisaBaseIOPort;
+	__u8 reserved;
+	__u8 EisaSlotNumber;
+	__u32 EisaBaseMemoryAddress;
+} i2o_eisa_bus;
+
+typedef struct _i2o_mca_bus {
+	__u16 McaBaseIOPort;
+	__u8 reserved;
+	__u8 McaSlotNumber;
+	__u32 McaBaseMemoryAddress;
+} i2o_mca_bus;
+
+typedef struct _i2o_other_bus {
+	__u16 BaseIOPort;
+	__u16 reserved;
+	__u32 BaseMemoryAddress;
+} i2o_other_bus;
+
+typedef struct _i2o_hrt_entry {
+	__u32 adapter_id;
+	__u32 parent_tid:12;
+	__u32 state:4;
+	__u32 bus_num:8;
+	__u32 bus_type:8;
+	union {
+		i2o_pci_bus pci_bus;
+		i2o_local_bus local_bus;
+		i2o_isa_bus isa_bus;
+		i2o_eisa_bus eisa_bus;
+		i2o_mca_bus mca_bus;
+		i2o_other_bus other_bus;
+	} bus;
+} i2o_hrt_entry;
+
+typedef struct _i2o_hrt {
+	__u16 num_entries;
+	__u8 entry_len;
+	__u8 hrt_version;
+	__u32 change_ind;
+	i2o_hrt_entry hrt_entry[1];
+} i2o_hrt;
+
+typedef struct _i2o_lct_entry {
+	__u32 entry_size:16;
+	__u32 tid:12;
+	__u32 reserved:4;
+	__u32 change_ind;
+	__u32 device_flags;
+	__u32 class_id:12;
+	__u32 version:4;
+	__u32 vendor_id:16;
+	__u32 sub_class;
+	__u32 user_tid:12;
+	__u32 parent_tid:12;
+	__u32 bios_info:8;
+	__u8 identity_tag[8];
+	__u32 event_capabilities;
+} i2o_lct_entry;
+
+typedef struct _i2o_lct {
+	__u32 table_size:16;
+	__u32 boot_tid:12;
+	__u32 lct_ver:4;
+	__u32 iop_flags;
+	__u32 change_ind;
+	i2o_lct_entry lct_entry[1];
+} i2o_lct;
+
+typedef struct _i2o_status_block {
+	__u16 org_id;
+	__u16 reserved;
+	__u16 iop_id:12;
+	__u16 reserved1:4;
+	__u16 host_unit_id;
+	__u16 segment_number:12;
+	__u16 i2o_version:4;
+	__u8 iop_state;
+	__u8 msg_type;
+	__u16 inbound_frame_size;
+	__u8 init_code;
+	__u8 reserved2;
+	__u32 max_inbound_frames;
+	__u32 cur_inbound_frames;
+	__u32 max_outbound_frames;
+	char product_id[24];
+	__u32 expected_lct_size;
+	__u32 iop_capabilities;
+	__u32 desired_mem_size;
+	__u32 current_mem_size;
+	__u32 current_mem_base;
+	__u32 desired_io_size;
+	__u32 current_io_size;
+	__u32 current_io_base;
+	__u32 reserved3:24;
+	__u32 cmd_status:8;
+} i2o_status_block;
+
 /*
  *	I2O Interface Objects
  */
@@ -131,6 +260,7 @@ struct i2o_sys_tbl
 	struct i2o_sys_tbl_entry iops[0];
 };
 
+
 /*
  *	I2O classes / subclasses
  */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index f7b2db4..38f6e50 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -151,7 +151,6 @@ header-y += hyperv.h
 header-y += hysdn_if.h
 header-y += i2c-dev.h
 header-y += i2c.h
-header-y += i2o-dev.h
 header-y += i8k.h
 header-y += icmp.h
 header-y += icmpv6.h
diff --git a/include/uapi/linux/i2o-dev.h b/include/uapi/linux/i2o-dev.h
deleted file mode 100644
index a8093bf..0000000
-- 
2.6.0
