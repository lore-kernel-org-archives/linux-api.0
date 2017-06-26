From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v2 17/22] fpga: intel: add fpga region platform driver for FME
Date: Mon, 26 Jun 2017 09:52:13 +0800
Message-ID: <1498441938-14046-18-git-send-email-hao.wu@intel.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

This patch adds fpga region platform driver for Intel FPGA Management
Engine. It register a fpga region with given fpga manager / bridge
device.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 drivers/fpga/Kconfig                 |  7 +++
 drivers/fpga/Makefile                |  1 +
 drivers/fpga/intel-fpga-fme-region.c | 91 ++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)
 create mode 100644 drivers/fpga/intel-fpga-fme-region.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 05e2a8e..db1a6ea 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -165,6 +165,13 @@ config INTEL_FPGA_FME_BRIDGE
 	  Say Y to enable FPGA Bridge driver for Intel FPGA Management
 	  Engine.
 
+config INTEL_FPGA_FME_REGION
+	tristate "Intel FPGA FME Region Driver"
+	depends on INTEL_FPGA_FME && FPGA_REGION
+	help
+	  Say Y to enable FPGA Region driver for Intel FPGA Management
+	  Engine.
+
 endif
 
 endif # FPGA
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index 131c105..fd0a71f 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_INTEL_FPGA_PCI)		+= intel-fpga-pci.o
 obj-$(CONFIG_INTEL_FPGA_FME)		+= intel-fpga-fme.o
 obj-$(CONFIG_INTEL_FPGA_FME_MGR)	+= intel-fpga-fme-mgr.o
 obj-$(CONFIG_INTEL_FPGA_FME_BRIDGE)	+= intel-fpga-fme-br.o
+obj-$(CONFIG_INTEL_FPGA_FME_REGION)	+= intel-fpga-fme-region.o
 
 intel-fpga-pci-objs := intel-pcie.o intel-feature-dev.o
 intel-fpga-fme-objs := intel-fme-main.o intel-fme-pr.o
diff --git a/drivers/fpga/intel-fpga-fme-region.c b/drivers/fpga/intel-fpga-fme-region.c
new file mode 100644
index 0000000..2b5ca4d
--- /dev/null
+++ b/drivers/fpga/intel-fpga-fme-region.c
@@ -0,0 +1,91 @@
+/*
+ * FPGA Region Driver for Intel FPGA Management Engine (FME)
+ *
+ * Copyright (C) 2017 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Wu Hao <hao.wu@intel.com>
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
+#include <linux/module.h>
+#include <linux/fpga/fpga-region.h>
+
+#include "intel-feature-dev.h"
+#include "intel-fme.h"
+
+static int fme_region_get_bridges(struct fpga_region *region,
+				  struct fpga_image_info *info)
+{
+	struct fme_region_pdata *pdata = region->priv;
+	struct device *dev = &pdata->br->dev;
+
+	return fpga_bridge_get_to_list(dev, info, &region->bridge_list);
+}
+
+static int fme_region_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct fme_region_pdata *pdata = dev_get_platdata(dev);
+	struct fpga_region *region;
+	struct fpga_manager *mgr;
+	int ret;
+
+	mgr = fpga_mgr_get(&pdata->mgr->dev);
+	if (IS_ERR(mgr))
+		return -EPROBE_DEFER;
+
+	region = devm_kzalloc(dev, sizeof(*region), GFP_KERNEL);
+	if (!region) {
+		ret = -ENOMEM;
+		goto eprobe_mgr_put;
+	}
+
+	region->mgr = mgr;
+	region->get_bridges = fme_region_get_bridges;
+	region->priv = pdata;
+
+	ret = fpga_region_register(dev, region);
+	if (ret)
+		goto eprobe_mgr_put;
+
+	dev_dbg(dev, "Intel FME FPGA Region probed\n");
+
+	return 0;
+
+eprobe_mgr_put:
+	fpga_mgr_put(mgr);
+	return ret;
+}
+
+static int fme_region_remove(struct platform_device *pdev)
+{
+	struct fpga_region *region = dev_get_drvdata(&pdev->dev);
+
+	fpga_mgr_put(region->mgr);
+	fpga_region_unregister(region);
+
+	return 0;
+}
+
+static struct platform_driver fme_region_driver = {
+	.driver	= {
+		.name    = INTEL_FPGA_FME_REGION,
+	},
+	.probe   = fme_region_probe,
+	.remove  = fme_region_remove,
+};
+
+module_platform_driver(fme_region_driver);
+
+MODULE_DESCRIPTION("FPGA Region for Intel FPGA Management Engine");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:intel-fpga-fme-region");
-- 
1.8.3.1
