From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 10/21] fpga: dfl: add FPGA Management Engine driver basic framework
Date: Mon, 27 Nov 2017 14:42:17 +0800
Message-ID: <1511764948-20972-11-git-send-email-hao.wu@intel.com>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Kang Luwei <luwei.kang@intel.com>

The FPGA Management Engine (FME) provides power, thermal management,
performance counters, partial reconfiguration and other functions. For each
function, it is packaged into a private feature linked to the FME feature
device in the 'Device Feature List'. It's a platform device created by
DFL framework.

This patch adds the basic framework of FME platform driver. It defines
sub feature drivers to handle the different sub features, including init,
uinit and ioctl. It also registers the file operations for the device file.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Kang Luwei <luwei.kang@intel.com>
Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
----
v3: rename driver from intel-fpga-fme to dfl-fme
    rename Kconfig from INTEL_FPGA_FME to FPGA_DFL_FME
---
 drivers/fpga/Kconfig        |  10 +++
 drivers/fpga/Makefile       |   3 +
 drivers/fpga/dfl-fme-main.c | 160 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)
 create mode 100644 drivers/fpga/dfl-fme-main.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index cc35d12..57da904 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -140,6 +140,16 @@ config FPGA_DFL
 	  Gate Array (FPGA) solutions which implement Device Feature List.
 	  It provides enumeration APIs, and feature device infrastructure.
 
+config FPGA_DFL_FME
+	tristate "FPGA DFL FME Driver"
+	depends on FPGA_DFL
+	help
+	  The FPGA Management Engine (FME) is a feature device implemented
+	  under Device Feature List (DFL) framework. Select this option to
+	  enable the platform device driver for FME which implements all
+	  FPGA platform level management features. There shall be 1 FME
+	  per DFL based FPGA device.
+
 config INTEL_FPGA_DFL_PCI
 	tristate "Intel FPGA DFL PCIe Device Driver"
 	depends on PCI && FPGA_DFL
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index d39a431..e5ba158 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -30,6 +30,9 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
 
 # FPGA Device Feature List Support
 obj-$(CONFIG_FPGA_DFL)			+= fpga-dfl.o
+obj-$(CONFIG_FPGA_DFL_FME)		+= fpga-dfl-fme.o
+
+fpga-dfl-fme-objs := dfl-fme-main.o
 
 # Drivers for FPGAs which implement DFL
 obj-$(CONFIG_INTEL_FPGA_DFL_PCI)	+= intel-dfl-pci.o
diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
new file mode 100644
index 0000000..f7b5f7d
--- /dev/null
+++ b/drivers/fpga/dfl-fme-main.c
@@ -0,0 +1,160 @@
+/*
+ * Driver for FPGA Management Engine (FME)
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Kang Luwei <luwei.kang@intel.com>
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
+static int fme_hdr_init(struct platform_device *pdev, struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "FME HDR Init.\n");
+
+	return 0;
+}
+
+static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "FME HDR UInit.\n");
+}
+
+static const struct feature_ops fme_hdr_ops = {
+	.init = fme_hdr_init,
+	.uinit = fme_hdr_uinit,
+};
+
+static struct feature_driver fme_feature_drvs[] = {
+	{
+		.name = FME_FEATURE_HEADER,
+		.ops = &fme_hdr_ops,
+	},
+	{
+		.ops = NULL,
+	},
+};
+
+static int fme_open(struct inode *inode, struct file *filp)
+{
+	struct platform_device *fdev = fpga_inode_to_feature_dev(inode);
+	struct feature_platform_data *pdata = dev_get_platdata(&fdev->dev);
+	int ret;
+
+	if (WARN_ON(!pdata))
+		return -ENODEV;
+
+	ret = feature_dev_use_begin(pdata);
+	if (ret)
+		return ret;
+
+	dev_dbg(&fdev->dev, "Device File Open\n");
+	filp->private_data = pdata;
+
+	return 0;
+}
+
+static int fme_release(struct inode *inode, struct file *filp)
+{
+	struct feature_platform_data *pdata = filp->private_data;
+	struct platform_device *pdev = pdata->dev;
+
+	dev_dbg(&pdev->dev, "Device File Release\n");
+	feature_dev_use_end(pdata);
+
+	return 0;
+}
+
+static long fme_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct feature_platform_data *pdata = filp->private_data;
+	struct platform_device *pdev = pdata->dev;
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
+		fpga_dev_for_each_feature(pdata, f) {
+			if (f->ops && f->ops->ioctl) {
+				ret = f->ops->ioctl(pdev, f, cmd, arg);
+				if (ret == -ENODEV)
+					continue;
+				else
+					return ret;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+static const struct file_operations fme_fops = {
+	.owner		= THIS_MODULE,
+	.open		= fme_open,
+	.release	= fme_release,
+	.unlocked_ioctl = fme_ioctl,
+};
+
+static int fme_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = fpga_dev_feature_init(pdev, fme_feature_drvs);
+	if (ret)
+		goto exit;
+
+	ret = fpga_register_dev_ops(pdev, &fme_fops, THIS_MODULE);
+	if (ret)
+		goto feature_uinit;
+
+	return 0;
+
+feature_uinit:
+	fpga_dev_feature_uinit(pdev);
+exit:
+	return ret;
+}
+
+static int fme_remove(struct platform_device *pdev)
+{
+	fpga_dev_feature_uinit(pdev);
+	fpga_unregister_dev_ops(pdev);
+
+	return 0;
+}
+
+static struct platform_driver fme_driver = {
+	.driver	= {
+		.name    = FPGA_FEATURE_DEV_FME,
+	},
+	.probe   = fme_probe,
+	.remove  = fme_remove,
+};
+
+module_platform_driver(fme_driver);
+
+MODULE_DESCRIPTION("FPGA Management Engine driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:fpga-dfl-fme");
-- 
1.8.3.1
