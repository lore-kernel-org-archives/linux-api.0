From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v3 1/2] PCI: Add Enhanced Allocation register entries
Date: Mon, 28 Sep 2015 17:10:38 -0700
Message-ID: <1443485439-12081-2-git-send-email-ddaney.cavm@gmail.com>
References: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com
Cc: "Signed-off-by: David Daney" <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

From: "Sean O. Stalley" <sean.stalley@intel.com>

Add registers defined in PCI-SIG's Enhanced allocation ECN.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
[david.daney@cavium.com: Added definitions for PCI_EA_BEI_BAR0 and PCI_EA_BEI_VF_BAR0]
Signed-off-by: Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/uapi/linux/pci_regs.h | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 413417f..d9119eb 100644
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
@@ -353,6 +354,45 @@
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
+#define  PCI_EA_BEI_BAR0	0
+#define  PCI_EA_BEI_BRIDGE	6	/* Resource behind bridge */
+#define  PCI_EA_BEI_ENI		7	/* Equivalent Not Indicated */
+#define  PCI_EA_BEI_ROM		8	/* Expansion ROM */
+/* 9-14 map to VF BARs 0-5 respectively */
+#define  PCI_EA_BEI_VF_BAR0	9
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
