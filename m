From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v2 06/22] fpga: intel: add FPGA PCIe device driver
Date: Mon, 26 Jun 2017 09:52:02 +0800
Message-ID: <1498441938-14046-7-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Zhang Yi <yi.z.zhang@intel.com>

The Intel FPGA device appears as a PCIe device on the system. This patch
implements the basic framework of the driver for Intel PCIe device which
locates between CPU and Accelerated Function Units (AFUs).

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
    switched to GPLv2 license.
    fixed comments from Moritz Fischer.
---
 drivers/fpga/Kconfig      |  28 +++++++++++
 drivers/fpga/Makefile     |   5 ++
 drivers/fpga/intel-pcie.c | 126 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)
 create mode 100644 drivers/fpga/intel-pcie.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index c1d8f41..3f3b7f4 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -117,6 +117,34 @@ config XILINX_PR_DECOUPLER
 	  region of the FPGA from the busses while that region is
 	  being reprogrammed during partial reconfig.
 
+menuconfig INTEL_FPGA
+	tristate "Intel(R) FPGA support"
+	depends on FPGA_DEVICE
+	help
+	  Select this option to enable driver support for Intel(R)
+	  Field-Programmable Gate Array (FPGA) solutions. This driver
+	  provides interfaces for userspace applications to configure,
+	  enumerate, open, and access FPGA accelerators on platforms
+	  equipped with Intel(R) FPGA solutions and enables system
+	  level management functions such as FPGA reconfiguration,
+	  power management, and virtualization.
+
+	  Say Y if your platform has this technology. Say N if unsure.
+
+if INTEL_FPGA
+
+config INTEL_FPGA_PCI
+	tristate "Intel FPGA PCIe Driver"
+	depends on PCI
+	help
+	  This is the driver for the PCIe device which locates between
+	  CPU and Accelerated Function Units (AFUs) and allows them to
+	  communicate with each other.
+
+	  To compile this as a module, choose M here.
+
+endif
+
 endif # FPGA
 
 endmenu
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index 8950a8f..5613133 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -27,3 +27,8 @@ obj-$(CONFIG_XILINX_PR_DECOUPLER)	+= xilinx-pr-decoupler.o
 # High Level Interfaces
 obj-$(CONFIG_FPGA_REGION)		+= fpga-region.o
 obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
+
+# Intel FPGA Support
+obj-$(CONFIG_INTEL_FPGA_PCI)		+= intel-fpga-pci.o
+
+intel-fpga-pci-objs := intel-pcie.o
diff --git a/drivers/fpga/intel-pcie.c b/drivers/fpga/intel-pcie.c
new file mode 100644
index 0000000..f697de4
--- /dev/null
+++ b/drivers/fpga/intel-pcie.c
@@ -0,0 +1,126 @@
+/*
+ * Driver for Intel FPGA PCIe device
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Zhang Yi <Yi.Z.Zhang@intel.com>
+ *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *   Joseph Grecco <joe.grecco@intel.com>
+ *   Enno Luebbers <enno.luebbers@intel.com>
+ *   Tim Whisonant <tim.whisonant@intel.com>
+ *   Ananda Ravuri <ananda.ravuri@intel.com>
+ *   Henry Mitchel <henry.mitchel@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2. See
+ * the COPYING file in the top-level directory.
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
+#define DRV_NAME	"intel-fpga-pci"
+
+/* PCI Device ID */
+#define PCIe_DEVICE_ID_PF_INT_5_X	0xBCBD
+#define PCIe_DEVICE_ID_PF_INT_6_X	0xBCC0
+#define PCIe_DEVICE_ID_PF_DSC_1_X	0x09C4
+/* VF Device */
+#define PCIe_DEVICE_ID_VF_INT_5_X	0xBCBF
+#define PCIe_DEVICE_ID_VF_INT_6_X	0xBCC1
+#define PCIe_DEVICE_ID_VF_DSC_1_X	0x09C5
+
+static struct pci_device_id cci_pcie_id_tbl[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIe_DEVICE_ID_PF_INT_5_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIe_DEVICE_ID_VF_INT_5_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIe_DEVICE_ID_PF_INT_6_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIe_DEVICE_ID_VF_INT_6_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIe_DEVICE_ID_PF_DSC_1_X),},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIe_DEVICE_ID_VF_DSC_1_X),},
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
+	pci_save_state(pcidev);
+
+	if (!dma_set_mask(&pcidev->dev, DMA_BIT_MASK(64))) {
+		dma_set_coherent_mask(&pcidev->dev, DMA_BIT_MASK(64));
+	} else if (!dma_set_mask(&pcidev->dev, DMA_BIT_MASK(32))) {
+		dma_set_coherent_mask(&pcidev->dev, DMA_BIT_MASK(32));
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
+	pr_info("Intel(R) FPGA PCIe Driver: Version %s\n", DRV_VERSION);
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
+MODULE_DESCRIPTION("Intel FPGA PCIe Device Driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.1
