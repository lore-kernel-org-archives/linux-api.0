From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v2 11/22] fpga: intel: add FPGA Management Engine driver basic framework
Date: Mon, 26 Jun 2017 09:52:07 +0800
Message-ID: <1498441938-14046-12-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

From: Kang Luwei <luwei.kang@intel.com>

The FPGA Management Engine (FME) provides power, thermal management,
performance counters, partial reconfiguration and other functions. For each
function, it is packaged into a private feature linked to the FME feature
device in the 'Device Feature List'. It's a platform device created by
Intel FPGA PCIe driver.

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
---
v2: moved the code to drivers/fpga folder as suggested by Alan Tull.
    switched to GPLv2 license.
---
 drivers/fpga/Kconfig          |   8 +++
 drivers/fpga/Makefile         |   2 +
 drivers/fpga/intel-fme-main.c | 156 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 166 insertions(+)
 create mode 100644 drivers/fpga/intel-fme-main.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 3f3b7f4..b91458f 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -143,6 +143,14 @@ config INTEL_FPGA_PCI
 
 	  To compile this as a module, choose M here.
 
+config INTEL_FPGA_FME
+	tristate "Intel FPGA FME Driver"
+	depends on INTEL_FPGA_PCI
+	help
+	  This is the driver for FPGA Management Engine which implements
+	  all FPGA platform level management features. There shall be 1
+	  FME per Intel FPGA.
+
 endif
 
 endif # FPGA
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index ad24b3d..09bf281 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -30,5 +30,7 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
 
 # Intel FPGA Support
 obj-$(CONFIG_INTEL_FPGA_PCI)		+= intel-fpga-pci.o
+obj-$(CONFIG_INTEL_FPGA_FME)		+= intel-fpga-fme.o
 
 intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
+intel-fpga-fme-objs := intel-fme-main.o
diff --git a/drivers/fpga/intel-fme-main.c b/drivers/fpga/intel-fme-main.c
new file mode 100644
index 0000000..c16cf81
--- /dev/null
+++ b/drivers/fpga/intel-fme-main.c
@@ -0,0 +1,156 @@
+/*
+ * Driver for Intel FPGA Management Engine (FME)
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
+ * This work is licensed under the terms of the GNU GPL version 2. See
+ * the COPYING file in the top-level directory.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "intel-feature-dev.h"
+
+static int fme_hdr_init(struct platform_device *pdev, struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "FME HDR Init.\n");
+	return 0;
+}
+
+static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
+{
+	dev_dbg(&pdev->dev, "FME HDR UInit.\n");
+}
+
+struct feature_ops fme_hdr_ops = {
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
+MODULE_DESCRIPTION("Intel FPGA Management Engine driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:intel-fpga-fme");
-- 
1.8.3.1
