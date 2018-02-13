From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 08/24] fpga: add FPGA DFL PCIe device driver
Date: Tue, 13 Feb 2018 17:24:37 +0800
Message-ID: <1518513893-4719-9-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch implements the basic framework of the driver for FPGA PCIe
device which implements the Device Feature List (DFL) in its MMIO space.
This driver is verified on Intel(R) PCIe based FPGA DFL devices, including
both integrated (e.g Intel Server Platform with In-package FPGA) and
discrete (e.g Intel FPGA PCIe Acceleration Cards) solutions.

Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v2: move the code to drivers/fpga folder as suggested by Alan Tull.
    switch to GPLv2 license.
    fix comments from Moritz Fischer.
v3: switch to pci_set_dma_mask/consistent_dma_mask() function.
    remove pci_save_state() in probe function.
    rename driver to INTEL_FPGA_DFL_PCI and intel-dfl-pci.c to indicate
    this driver supports Intel FPGA PCI devices which implement DFL.
    improve Kconfig description for INTEL_FPGA_DFL_PCI
v4: rename to FPGA_DFL_PCI (dfl-pci.c) for better reuse.
    fix SPDX license issue.
---
 drivers/fpga/Kconfig   |  15 ++++++
 drivers/fpga/Makefile  |   3 ++
 drivers/fpga/dfl-pci.c | 127 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+)
 create mode 100644 drivers/fpga/dfl-pci.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 01ad31f..87f3d44 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -140,4 +140,19 @@ config FPGA_DFL
 	  Gate Array (FPGA) solutions which implement Device Feature List.
 	  It provides enumeration APIs, and feature device infrastructure.
 
+config FPGA_DFL_PCI
+	tristate "FPGA Device Feature List (DFL) PCIe Device Driver"
+	depends on PCI && FPGA_DFL
+	help
+	  Select this option to enable PCIe driver for PCIe based
+	  Field-Programmable Gate Array (FPGA) solutions which implemented
+	  the Device Feature List (DFL). This driver provides interfaces
+	  for userspace applications to configure, enumerate, open and access
+	  FPGA accelerators on the FPGA DFL devices, enables system level
+	  management functions such as FPGA partial reconfiguration, power
+	  management, and virtualization with DFL framework and DFL feature
+	  device drivers.
+
+	  To compile this as a module, choose M here.
+
 endif # FPGA
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index c4c62b9..4375630 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -30,3 +30,6 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
 
 # FPGA Device Feature List Support
 obj-$(CONFIG_FPGA_DFL)			+= dfl.o
+
+# Drivers for FPGAs which implement DFL
+obj-$(CONFIG_FPGA_DFL_PCI)		+= dfl-pci.o
diff --git a/drivers/fpga/dfl-pci.c b/drivers/fpga/dfl-pci.c
new file mode 100644
index 0000000..d91ea42
--- /dev/null
+++ b/drivers/fpga/dfl-pci.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Driver for FPGA Device Feature List (DFL) PCIe device
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Zhang Yi <Yi.Z.Zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *   Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ *   Joseph Grecco <joe.grecco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *   Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *   Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *   Ananda Ravuri <ananda.ravuri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *   Henry Mitchel <henry.mitchel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ */
+
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/stddef.h>
+#include <linux/errno.h>
+#include <linux/aer.h>
+
+#define DRV_VERSION	"0.8"
+#define DRV_NAME	"dfl-pci"
+
+/* PCI Device ID */
+#define PCIE_DEVICE_ID_PF_INT_5_X	0xBCBD
+#define PCIE_DEVICE_ID_PF_INT_6_X	0xBCC0
+#define PCIE_DEVICE_ID_PF_DSC_1_X	0x09C4
+/* VF Device */
+#define PCIE_DEVICE_ID_VF_INT_5_X	0xBCBF
+#define PCIE_DEVICE_ID_VF_INT_6_X	0xBCC1
+#define PCIE_DEVICE_ID_VF_DSC_1_X	0x09C5
+
+static struct pci_device_id cci_pcie_id_tbl[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_5_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_INT_5_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_INT_6_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_INT_6_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_PF_DSC_1_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_VF_DSC_1_X),},
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, cci_pcie_id_tbl);
+
+static
+int cci_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *pcidevid)
+{
+	int ret;
+
+	ret = pci_enable_device(pcidev);
+	if (ret < 0) {
+		dev_err(&pcidev->dev, "Failed to enable device %d.\n", ret);
+		return ret;
+	}
+
+	ret = pci_enable_pcie_error_reporting(pcidev);
+	if (ret && ret != -EINVAL)
+		dev_info(&pcidev->dev, "PCIE AER unavailable %d.\n", ret);
+
+	ret = pci_request_regions(pcidev, DRV_NAME);
+	if (ret) {
+		dev_err(&pcidev->dev, "Failed to request regions.\n");
+		goto disable_error_report_exit;
+	}
+
+	pci_set_master(pcidev);
+
+	if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64));
+		if (ret)
+			goto release_region_exit;
+	} else if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(32))) {
+		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
+		if (ret)
+			goto release_region_exit;
+	} else {
+		ret = -EIO;
+		dev_err(&pcidev->dev, "No suitable DMA support available.\n");
+		goto release_region_exit;
+	}
+
+	/* TODO: create and add the platform device per feature list */
+	return 0;
+
+release_region_exit:
+	pci_release_regions(pcidev);
+disable_error_report_exit:
+	pci_disable_pcie_error_reporting(pcidev);
+	pci_disable_device(pcidev);
+	return ret;
+}
+
+static void cci_pci_remove(struct pci_dev *pcidev)
+{
+	pci_release_regions(pcidev);
+	pci_disable_pcie_error_reporting(pcidev);
+	pci_disable_device(pcidev);
+}
+
+static struct pci_driver cci_pci_driver = {
+	.name = DRV_NAME,
+	.id_table = cci_pcie_id_tbl,
+	.probe = cci_pci_probe,
+	.remove = cci_pci_remove,
+};
+
+static int __init ccidrv_init(void)
+{
+	pr_info("FPGA DFL PCIe Driver: Version %s\n", DRV_VERSION);
+
+	return pci_register_driver(&cci_pci_driver);
+}
+
+static void __exit ccidrv_exit(void)
+{
+	pci_unregister_driver(&cci_pci_driver);
+}
+
+module_init(ccidrv_init);
+module_exit(ccidrv_exit);
+
+MODULE_DESCRIPTION("FPGA DFL PCIe Device Driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
