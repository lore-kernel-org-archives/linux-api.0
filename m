From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 5/7] eeprom: qfprom: Add Qualcomm QFPROM support.
Date: Fri, 13 Mar 2015 09:50:45 +0000
Message-ID: <1426240245-2621-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426240157-2383-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds QFPROM support driver which is used by other drivers
like thermal sensor and cpufreq.

On MSM parts there are some efuses (called qfprom) these fuses store things like
calibration data, speed bins.. etc. Drivers like cpufreq, thermal sensors would
read out this data for configuring the driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/eeprom/Kconfig  |  9 ++++-
 drivers/eeprom/Makefile |  1 +
 drivers/eeprom/qfprom.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 drivers/eeprom/qfprom.c

diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
index fd4fa2f..b77828b 100644
--- a/drivers/eeprom/Kconfig
+++ b/drivers/eeprom/Kconfig
@@ -23,4 +23,11 @@ config EEPROM_SUNXI_SID
 	  This driver can also be built as a module. If so, the module
 	  will be called eprom-sunxi-sid.
 
-endif
\ No newline at end of file
+config QCOM_QFPROM
+	tristate "QCOM QFPROM Support"
+	depends on EEPROM
+	select REGMAP_MMIO
+	help
+	  Say y here to enable QFPROM support. The QFPROM provides access
+	  functions for QFPROM data to rest of the drivers via eeprom interface.
+endif
diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
index 546a27c..9c1bb03 100644
--- a/drivers/eeprom/Makefile
+++ b/drivers/eeprom/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_EEPROM)		+= core.o
 
 # Devices
 obj-$(CONFIG_EEPROM_SUNXI_SID)	+= eeprom-sunxi-sid.o
+obj-$(CONFIG_QCOM_QFPROM)	+= qfprom.o
diff --git a/drivers/eeprom/qfprom.c b/drivers/eeprom/qfprom.c
new file mode 100644
index 0000000..7d9e5e9
--- /dev/null
+++ b/drivers/eeprom/qfprom.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/eeprom-provider.h>
+
+static struct regmap_config qfprom_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 8,
+	.reg_stride = 1,
+};
+
+static struct eeprom_config econfig = {
+	.stride = 1,
+	.name = "qfprom",
+};
+
+static int qfprom_remove(struct platform_device *pdev)
+{
+	struct eeprom_device *eeprom = platform_get_drvdata(pdev);
+
+	return eeprom_unregister(eeprom);
+}
+
+static int qfprom_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	void __iomem *base;
+	struct device *dev = &pdev->dev;
+	struct eeprom_device *eeprom;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	qfprom_regmap_config.max_register = resource_size(res) - 1;
+
+	econfig.regmap = devm_regmap_init_mmio(dev, base,
+					       &qfprom_regmap_config);
+	if (IS_ERR(econfig.regmap)) {
+		dev_err(dev, "regmap init failed\n");
+		return PTR_ERR(econfig.regmap);
+	}
+	econfig.owner = THIS_MODULE;
+	econfig.dev = dev;
+	econfig.size = resource_size(res) - 1;
+	eeprom = eeprom_register(&econfig);
+	if (IS_ERR(eeprom))
+		return PTR_ERR(eeprom);
+
+	platform_set_drvdata(pdev, eeprom);
+	return 0;
+}
+
+static const struct of_device_id qfprom_of_match[] = {
+	{ .compatible = "qcom,qfprom"},
+	{/* sentinel */},
+};
+MODULE_DEVICE_TABLE(of, qfprom_of_match);
+
+static struct platform_driver qfprom_driver = {
+	.probe = qfprom_probe,
+	.remove = qfprom_remove,
+	.driver = {
+		.name = "qcom,qfprom",
+		.of_match_table = qfprom_of_match,
+	},
+};
+module_platform_driver(qfprom_driver);
+MODULE_AUTHOR("Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>");
+MODULE_DESCRIPTION("Qualcomm QFPROM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
