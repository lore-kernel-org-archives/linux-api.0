From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 18/24] fpga: dfl: add fpga region platform driver for FME
Date: Tue, 13 Feb 2018 17:24:47 +0800
Message-ID: <1518513893-4719-19-git-send-email-hao.wu@intel.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

This patch adds fpga region platform driver for FPGA Management Engine.
It register an fpga region with given fpga manager / bridge device.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
---
v3: rename driver to fpga-dfl-fme-region
    fix fpga_mgr_put order problem in remove function.
    rebased due to fpga api changes.
v4: rename to dfl-fme-region, fix SPDX license issue
    include dfl-fme-pr.h instead of dfl-fme.h and dfl.h
    add Acked-by from Alan and Moritz
---
 drivers/fpga/Kconfig          |  6 +++
 drivers/fpga/Makefile         |  1 +
 drivers/fpga/dfl-fme-region.c | 89 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+)
 create mode 100644 drivers/fpga/dfl-fme-region.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index a8f939a..65d54a4 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -162,6 +162,12 @@ config FPGA_DFL_FME_BRIDGE
 	help
 	  Say Y to enable FPGA Bridge driver for FPGA Management Engine.
 
+config FPGA_DFL_FME_REGION
+	tristate "FPGA DFL FME Region Driver"
+	depends on FPGA_DFL_FME
+	help
+	  Say Y to enable FPGA Region driver for FPGA Management Engine.
+
 config FPGA_DFL_PCI
 	tristate "FPGA Device Feature List (DFL) PCIe Device Driver"
 	depends on PCI && FPGA_DFL
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index 75096e9..163894e 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_FPGA_DFL)			+= dfl.o
 obj-$(CONFIG_FPGA_DFL_FME)		+= dfl-fme.o
 obj-$(CONFIG_FPGA_DFL_FME_MGR)		+= dfl-fme-mgr.o
 obj-$(CONFIG_FPGA_DFL_FME_BRIDGE)	+= dfl-fme-br.o
+obj-$(CONFIG_FPGA_DFL_FME_REGION)	+= dfl-fme-region.o
 
 dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
 
diff --git a/drivers/fpga/dfl-fme-region.c b/drivers/fpga/dfl-fme-region.c
new file mode 100644
index 0000000..1f5f33d
--- /dev/null
+++ b/drivers/fpga/dfl-fme-region.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FPGA Region Driver for FPGA Management Engine (FME)
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
+ */
+
+#include <linux/module.h>
+#include <linux/fpga/fpga-region.h>
+
+#include "dfl-fme-pr.h"
+
+static int fme_region_get_bridges(struct fpga_region *region)
+{
+	struct fme_region_pdata *pdata = region->priv;
+	struct device *dev = &pdata->br->dev;
+
+	return fpga_bridge_get_to_list(dev, region->info, &region->bridge_list);
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
+	region->parent = dev;
+	platform_set_drvdata(pdev, region);
+
+	ret = fpga_region_register(region);
+	if (ret)
+		goto eprobe_mgr_put;
+
+	dev_dbg(dev, "DFL FME FPGA Region probed\n");
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
+	fpga_region_unregister(region);
+	fpga_mgr_put(region->mgr);
+
+	return 0;
+}
+
+static struct platform_driver fme_region_driver = {
+	.driver	= {
+		.name    = FPGA_DFL_FME_REGION,
+	},
+	.probe   = fme_region_probe,
+	.remove  = fme_region_remove,
+};
+
+module_platform_driver(fme_region_driver);
+
+MODULE_DESCRIPTION("FPGA Region for DFL FPGA Management Engine");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:dfl-fme-region");
-- 
2.7.4
