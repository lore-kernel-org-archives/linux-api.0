From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 17/21] fpga: dfl: add FPGA Accelerated Function Unit driver basic framework
Date: Mon, 27 Nov 2017 14:42:24 +0800
Message-ID: <1511764948-20972-18-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On DFL FPGA devices, the Accelerated Function Unit (AFU), can be
reprogrammed for different functions. It connects to the FPGA
infrastructure("blue bistream") via a Port. Port CSRs are implemented
separately from the AFU CSRs to provide control and status of the Port.
Once valid green bitstream is programmed into the AFU, it allows access
to the AFU CSRs in the AFU MMIO space.

This patch only implements basic driver framework for AFU, including
device file operation framework.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
----
v3: rename driver to dfl-afu-main
---
 drivers/fpga/Kconfig        |   9 +++
 drivers/fpga/Makefile       |   2 +
 drivers/fpga/dfl-afu-main.c | 161 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 drivers/fpga/dfl-afu-main.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 2df9dfd..fa1905b 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -168,6 +168,15 @@ config FPGA_DFL_FME_REGION
 	help
 	  Say Y to enable FPGA Region driver for FPGA Management Engine.
 
+config FPGA_DFL_AFU
+	tristate "FPGA DFL AFU Driver"
+	depends on FPGA_DFL
+	help
+	  This is the driver for FPGA Accelerated Function Unit (AFU) which
+	  implements AFU and Port management features. A User AFU connects
+	  to the FPGA infrastructure via a Port. There may be more than 1
+	  Port/AFU per DFL based FPGA device.
+
 config INTEL_FPGA_DFL_PCI
 	tristate "Intel FPGA DFL PCIe Device Driver"
 	depends on PCI && FPGA_DFL
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index 11777d3..e234fa8 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -34,8 +34,10 @@ obj-$(CONFIG_FPGA_DFL_FME)		+= fpga-dfl-fme.o
 obj-$(CONFIG_FPGA_DFL_FME_MGR)		+= fpga-dfl-fme-mgr.o
 obj-$(CONFIG_FPGA_DFL_FME_BRIDGE)	+= fpga-dfl-fme-br.o
 obj-$(CONFIG_FPGA_DFL_FME_REGION)	+= fpga-dfl-fme-region.o
+obj-$(CONFIG_FPGA_DFL_AFU)		+= fpga-dfl-afu.o
 
 fpga-dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
+fpga-dfl-afu-objs := dfl-afu-main.o
 
 # Drivers for FPGAs which implement DFL
 obj-$(CONFIG_INTEL_FPGA_DFL_PCI)	+= intel-dfl-pci.o
diff --git a/drivers/fpga/dfl-afu-main.c b/drivers/fpga/dfl-afu-main.c
new file mode 100644
index 0000000..d9f4b81
--- /dev/null
+++ b/drivers/fpga/dfl-afu-main.c
@@ -0,0 +1,161 @@
+/*
+ * Driver for FPGA Accelerated Function Unit (AFU)
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Wu Hao <hao.wu@intel.com>
+ *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
+ *   Joseph Grecco <joe.grecco@intel.com>
+ *   Enno Luebbers <enno.luebbers@intel.com>
+ *   Tim Whisonant <tim.whisonant@intel.com>
+ *   Ananda Ravuri <ananda.ravuri@intel.com>
+ *   Henry Mitchel <henry.mitchel@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL version 2.
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "fpga-dfl.h"
+
+static int port_hdr_init(struct platform_device *pdev, struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "PORT HDR Init.\n");
+
+	return 0;
+}
+
+static void port_hdr_uinit(struct platform_device *pdev,
+			   struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "PORT HDR UInit.\n");
+}
+
+static const struct feature_ops port_hdr_ops = {
+	.init = port_hdr_init,
+	.uinit = port_hdr_uinit,
+};
+
+static struct feature_driver port_feature_drvs[] = {
+	{
+		.name = PORT_FEATURE_HEADER,
+		.ops = &port_hdr_ops,
+	},
+	{
+		.ops = NULL,
+	}
+};
+
+static int afu_open(struct inode *inode, struct file *filp)
+{
+	struct platform_device *fdev = fpga_inode_to_feature_dev(inode);
+	struct feature_platform_data *pdata;
+	int ret;
+
+	pdata = dev_get_platdata(&fdev->dev);
+	if (WARN_ON(!pdata))
+		return -ENODEV;
+
+	ret = feature_dev_use_begin(pdata);
+	if (ret)
+		return ret;
+
+	dev_dbg(&fdev->dev, "Device File Open\n");
+	filp->private_data = fdev;
+
+	return 0;
+}
+
+static int afu_release(struct inode *inode, struct file *filp)
+{
+	struct platform_device *pdev = filp->private_data;
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+
+	dev_dbg(&pdev->dev, "Device File Release\n");
+
+	feature_dev_use_end(pdata);
+
+	return 0;
+}
+
+static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct platform_device *pdev = filp->private_data;
+	struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
+	struct feature *f;
+	long ret;
+
+	dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
+
+	switch (cmd) {
+	default:
+		/*
+		 * Let sub-feature's ioctl function to handle the cmd
+		 * Sub-feature's ioctl returns -ENODEV when cmd is not
+		 * handled in this sub feature, and returns 0 and other
+		 * error code if cmd is handled.
+		 */
+		fpga_dev_for_each_feature(pdata, f)
+			if (f->ops && f->ops->ioctl) {
+				ret = f->ops->ioctl(pdev, f, cmd, arg);
+				if (ret == -ENODEV)
+					continue;
+				else
+					return ret;
+			}
+	}
+
+	return -EINVAL;
+}
+
+static const struct file_operations afu_fops = {
+	.owner = THIS_MODULE,
+	.open = afu_open,
+	.release = afu_release,
+	.unlocked_ioctl = afu_ioctl,
+};
+
+static int afu_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	ret = fpga_dev_feature_init(pdev, port_feature_drvs);
+	if (ret)
+		return ret;
+
+	ret = fpga_register_dev_ops(pdev, &afu_fops, THIS_MODULE);
+	if (ret)
+		fpga_dev_feature_uinit(pdev);
+
+	return ret;
+}
+
+static int afu_remove(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	fpga_dev_feature_uinit(pdev);
+	fpga_unregister_dev_ops(pdev);
+
+	return 0;
+}
+
+static struct platform_driver afu_driver = {
+	.driver	= {
+		.name    = FPGA_FEATURE_DEV_PORT,
+	},
+	.probe   = afu_probe,
+	.remove  = afu_remove,
+};
+
+module_platform_driver(afu_driver);
+
+MODULE_DESCRIPTION("FPGA Accelerated Function Unit driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:fpga-dfl-port");
-- 
1.8.3.1
