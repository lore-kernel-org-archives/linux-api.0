From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 86/86] usb/dwc3: move ids to pci_ids.h
Date: Sun, 29 Mar 2015 15:43:40 +0200
Message-ID: <1427635734-24786-87-git-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427635734-24786-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Neubauer <pneubauer-OUHTSVaU61M6GL+IUqp+Xg@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Comment says IDs should move to pci_ids.h, let's do it.

Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/pci_ids.h |  8 ++++++++
 drivers/usb/dwc3/dwc3-pci.c  | 10 +---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/pci_ids.h b/include/uapi/linux/pci_ids.h
index e63c02a..c10833f3 100644
--- a/include/uapi/linux/pci_ids.h
+++ b/include/uapi/linux/pci_ids.h
@@ -2312,6 +2312,9 @@
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
+#define PCI_VENDOR_ID_SYNOPSYS		0x16c3
+#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
+
 #define PCI_VENDOR_ID_CENATEK		0x16CA
 #define PCI_DEVICE_ID_CENATEK_IDE	0x0001
 
@@ -2567,11 +2570,13 @@
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
 #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
+#define PCI_DEVICE_ID_INTEL_BYT		0x0f37
 #define PCI_DEVICE_ID_INTEL_8257X_SOL	0x1062
 #define PCI_DEVICE_ID_INTEL_82573E_SOL	0x1085
 #define PCI_DEVICE_ID_INTEL_82573L_SOL	0x108F
 #define PCI_DEVICE_ID_INTEL_82815_MC	0x1130
 #define PCI_DEVICE_ID_INTEL_82815_CGC	0x1132
+#define PCI_DEVICE_ID_INTEL_MRFLD	0x119e
 #define PCI_DEVICE_ID_INTEL_82092AA_0	0x1221
 #define PCI_DEVICE_ID_INTEL_7505_0	0x2550
 #define PCI_DEVICE_ID_INTEL_7205_0	0x255d
@@ -2593,6 +2598,7 @@
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI	0x1e31
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN	0x1e40
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX	0x1e5f
+#define PCI_DEVICE_ID_INTEL_BSW		0x22B7
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN	0x2310
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX	0x231f
 #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
@@ -2891,6 +2897,8 @@
 #define PCI_DEVICE_ID_INTEL_84460GX	0x84ea
 #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
 #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
+#define PCI_DEVICE_ID_INTEL_SPTLP	0x9d30
+#define PCI_DEVICE_ID_INTEL_SPTH	0xa130
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
 #define PCI_VENDOR_ID_SCALEMP		0x8686
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 4285d8f..19ca7f6 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -20,19 +20,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
+#include <linux/pci_ids.h>
 #include <linux/platform_device.h>
 
 #include "platform_data.h"
 
-/* FIXME define these in <uapi/linux/pci_ids.h> */
-#define PCI_VENDOR_ID_SYNOPSYS		0x16c3
-#define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
-#define PCI_DEVICE_ID_INTEL_BYT		0x0f37
-#define PCI_DEVICE_ID_INTEL_MRFLD	0x119e
-#define PCI_DEVICE_ID_INTEL_BSW		0x22B7
-#define PCI_DEVICE_ID_INTEL_SPTLP	0x9d30
-#define PCI_DEVICE_ID_INTEL_SPTH	0xa130
-
 static int dwc3_pci_quirks(struct pci_dev *pdev)
 {
 	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
-- 
MST
