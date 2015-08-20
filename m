From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 1/2] PCI: Add Enhanced Allocation register entries
Date: Thu, 20 Aug 2015 09:59:06 -0700
Message-ID: <1440089947-2839-2-git-send-email-sean.stalley@intel.com>
References: <1440089947-2839-1-git-send-email-sean.stalley@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440089947-2839-1-git-send-email-sean.stalley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bhelgaas@google.com, rajatxjain@gmail.com, mst@redhat.com, zajec5@gmail.com, gong.chen@linux.intel.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: sean.stalley@intel.com
List-Id: linux-api@vger.kernel.org

Add registers defined in PCI-SIG's Enhanced allocation ECN.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
---
 include/uapi/linux/pci_regs.h | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 413417f..084ce98 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -216,7 +216,8 @@
 #define  PCI_CAP_ID_MSIX	0x11	/* MSI-X */
 #define  PCI_CAP_ID_SATA	0x12	/* SATA Data/Index Conf. */
 #define  PCI_CAP_ID_AF		0x13	/* PCI Advanced Features */
-#define  PCI_CAP_ID_MAX		PCI_CAP_ID_AF
+#define  PCI_CAP_ID_EA		0x14	/* PCI Enhanced Allocation */
+#define  PCI_CAP_ID_MAX		PCI_CAP_ID_EA
 #define PCI_CAP_LIST_NEXT	1	/* Next capability in the list */
 #define PCI_CAP_FLAGS		2	/* Capability defined flags (16 bits) */
 #define PCI_CAP_SIZEOF		4
@@ -353,6 +354,43 @@
 #define  PCI_AF_STATUS_TP	0x01
 #define PCI_CAP_AF_SIZEOF	6	/* size of AF registers */
 
+/* PCI Enhanced Allocation registers */
+
+#define PCI_EA_NUM_ENT		2	/* Number of Capability Entries */
+#define PCI_EA_NUM_ENT_MASK	0x3f	/* Num Entries Mask */
+#define PCI_EA_FIRST_ENT	4	/* First EA Entry in List */
+#define PCI_EA_FIRST_ENT_BRIDGE	8	/* First EA Entry for Bridges */
+#define PCI_EA_ES		0x7	/* Entry Size */
+#define PCI_EA_BEI(x)	(((x) >> 4) & 0xf) /* BAR Equivalent Indicator */
+/* 0-5 map to BARs 0-5 respectively */
+#define  PCI_EA_BEI_BRIDGE	6	/* Resource behind bridge */
+#define  PCI_EA_BEI_ENI		7	/* Equivalent Not Indicated */
+#define  PCI_EA_BEI_ROM		8	/* Expansion ROM */
+/* 9-14 map to VF BARs 0-5 respectively */
+#define  PCI_EA_BEI_RESERVED	15	/* Reserved - Treat like ENI */
+
+#define PCI_EA_PP(x)	(((x) >>  8) & 0xff)	/* Primary Properties */
+#define PCI_EA_SP(x)	(((x) >> 16) & 0xff)	/* Secondary Properties */
+#define  PCI_EA_P_MEM			0x00	/* Non-Prefetch Memory */
+#define  PCI_EA_P_MEM_PREFETCH		0x01	/* Prefetchable Memory */
+#define  PCI_EA_P_IO			0x02	/* I/O Space */
+#define  PCI_EA_P_VIRT_MEM_PREFETCH	0x03	/* VF Prefetchable Memory */
+#define  PCI_EA_P_VIRT_MEM		0x04	/* VF Non-Prefetch Memory */
+#define  PCI_EA_P_BRIDGE_MEM		0x05	/* Bridge Non-Prefetch Memory */
+#define  PCI_EA_P_BRIDGE_MEM_PREFETCH	0x06	/* Bridge Prefetchable Memory */
+#define  PCI_EA_P_BRIDGE_IO		0x07	/* Bridge I/O Space */
+/* 0x08-0xfc reserved */
+#define  PCI_EA_P_MEM_RESERVED		0xfd	/* Reserved Memory */
+#define  PCI_EA_P_IO_RESERVED		0xfe	/* Reserved I/O Space */
+#define  PCI_EA_P_UNAVAILABLE		0xff	/* Entry Unavailable */
+#define PCI_EA_WRITEABLE	BIT(30) /* Writable, 1 = RW, 0 = HwInit */
+#define PCI_EA_ENABLE		BIT(31) /* Enable for this entry */
+#define PCI_EA_BASE		4	/* Base Address Offset */
+#define PCI_EA_MAX_OFFSET	8	/* MaxOffset (resource length) */
+/* bit 0 is reserved */
+#define PCI_EA_IS_64		BIT(1)	/* 64-bit field flag */
+#define PCI_EA_FIELD_MASK	0xfffffffc	/* For Base & Max Offset */
+
 /* PCI-X registers (Type 0 (non-bridge) devices) */
 
 #define PCI_X_CMD		2	/* Modes & Features */
-- 
1.9.1
