From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v7 20/29] fpga: dfl: add fpga bridge platform driver for FME
Date: Sat, 30 Jun 2018 08:53:27 +0800
Message-ID: <1530320016-24712-21-git-send-email-hao.wu@intel.com>
References: <1530320016-24712-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530320016-24712-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

This patch adds fpga bridge platform driver for FPGA Management Engine.
It implements the enable_set callback for fpga bridge.

Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
Signed-off-by: Shiva Rao <shiva.rao@intel.com>
Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
---
v3: rename driver to fpga-dfl-fme-br
    remove useless dev_dbg in probe function.
    rebased due to fpga api change.
v4: rename to dfl-fme-br and fix SPDX license issue
    include dfl-fme-pr.h instead of dfl-fme.h
    add Acked-by from Alan and Moritz
v5: rebase due to API changes.
    defer port and its ops finding when really need.
v6: reabse and fix copyright time.
v7: fix kbuild issue.
---
 drivers/fpga/Kconfig      |   6 +++
 drivers/fpga/Makefile     |   1 +
 drivers/fpga/dfl-fme-br.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+)
 create mode 100644 drivers/fpga/dfl-fme-br.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 46b48e5..11d1943 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -162,6 +162,12 @@ config FPGA_DFL_FME_MGR
 	help
 	  Say Y to enable FPGA Manager driver for FPGA Management Engine.
 
+config FPGA_DFL_FME_BRIDGE
+	tristate "FPGA DFL FME Bridge Driver"
+	depends on FPGA_DFL_FME && HAS_IOMEM
+	help
+	  Say Y to enable FPGA Bridge driver for FPGA Management Engine.
+
 config FPGA_DFL_PCI
 	tristate "FPGA DFL PCIe Device Driver"
 	depends on PCI && FPGA_DFL
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index 23f41b0..cda0551 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_OF_FPGA_REGION)		+= of-fpga-region.o
 obj-$(CONFIG_FPGA_DFL)			+= dfl.o
 obj-$(CONFIG_FPGA_DFL_FME)		+= dfl-fme.o
 obj-$(CONFIG_FPGA_DFL_FME_MGR)		+= dfl-fme-mgr.o
+obj-$(CONFIG_FPGA_DFL_FME_BRIDGE)	+= dfl-fme-br.o
 
 dfl-fme-objs := dfl-fme-main.o dfl-fme-pr.o
 
diff --git a/drivers/fpga/dfl-fme-br.c b/drivers/fpga/dfl-fme-br.c
new file mode 100644
index 0000000..7cc041d
--- /dev/null
+++ b/drivers/fpga/dfl-fme-br.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * FPGA Bridge Driver for FPGA Management Engine (FME)
+ *
+ * Copyright (C) 2017-2018 Intel Corporation, Inc.
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
+#include <linux/fpga/fpga-bridge.h>
+
+#include "dfl.h"
+#include "dfl-fme-pr.h"
+
+struct fme_br_priv {
+	struct dfl_fme_br_pdata *pdata;
+	struct dfl_fpga_port_ops *port_ops;
+	struct platform_device *port_pdev;
+};
+
+static int fme_bridge_enable_set(struct fpga_bridge *bridge, bool enable)
+{
+	struct fme_br_priv *priv = bridge->priv;
+	struct platform_device *port_pdev;
+	struct dfl_fpga_port_ops *ops;
+
+	if (!priv->port_pdev) {
+		port_pdev = dfl_fpga_cdev_find_port(priv->pdata->cdev,
+						    &priv->pdata->port_id,
+						    dfl_fpga_check_port_id);
+		if (!port_pdev)
+			return -ENODEV;
+
+		priv->port_pdev = port_pdev;
+	}
+
+	if (priv->port_pdev && !priv->port_ops) {
+		ops = dfl_fpga_port_ops_get(priv->port_pdev);
+		if (!ops || !ops->enable_set)
+			return -ENOENT;
+
+		priv->port_ops = ops;
+	}
+
+	return priv->port_ops->enable_set(priv->port_pdev, enable);
+}
+
+static const struct fpga_bridge_ops fme_bridge_ops = {
+	.enable_set = fme_bridge_enable_set,
+};
+
+static int fme_br_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct fme_br_priv *priv;
+	struct fpga_bridge *br;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pdata = dev_get_platdata(dev);
+
+	br = fpga_bridge_create(dev, "DFL FPGA FME Bridge",
+				&fme_bridge_ops, priv);
+	if (!br)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, br);
+
+	ret = fpga_bridge_register(br);
+	if (ret)
+		fpga_bridge_free(br);
+
+	return ret;
+}
+
+static int fme_br_remove(struct platform_device *pdev)
+{
+	struct fpga_bridge *br = platform_get_drvdata(pdev);
+	struct fme_br_priv *priv = br->priv;
+
+	fpga_bridge_unregister(br);
+
+	if (priv->port_pdev)
+		put_device(&priv->port_pdev->dev);
+	if (priv->port_ops)
+		dfl_fpga_port_ops_put(priv->port_ops);
+
+	return 0;
+}
+
+static struct platform_driver fme_br_driver = {
+	.driver	= {
+		.name    = DFL_FPGA_FME_BRIDGE,
+	},
+	.probe   = fme_br_probe,
+	.remove  = fme_br_remove,
+};
+
+module_platform_driver(fme_br_driver);
+
+MODULE_DESCRIPTION("FPGA Bridge for DFL FPGA Management Engine");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:dfl-fme-bridge");
-- 
1.8.3.1
