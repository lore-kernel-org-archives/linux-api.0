From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 06/10] eeprom: Add simple eeprom-mmio consumer helper functions.
Date: Mon, 30 Mar 2015 22:58:13 +0100
Message-ID: <1427752693-17303-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427752492-17039-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds probe and remove helper functions for eeproms which are
mmio based, With these helper function new eeprom consumer drivers need
very little code add its driver.

This code is currently used for qfprom and sunxi-sid eeprom consumer drivers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/eeprom/Makefile      |  1 +
 drivers/eeprom/eeprom-mmio.c | 69 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/eeprom/eeprom-mmio.h | 41 ++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)
 create mode 100644 drivers/eeprom/eeprom-mmio.c
 create mode 100644 drivers/eeprom/eeprom-mmio.h

diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
index 51a727f..6812bbe 100644
--- a/drivers/eeprom/Makefile
+++ b/drivers/eeprom/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_EEPROM)		+= eeprom_core.o
 eeprom_core-y			:= core.o
+eeprom_core-y			+= eeprom-mmio.o
diff --git a/drivers/eeprom/eeprom-mmio.c b/drivers/eeprom/eeprom-mmio.c
new file mode 100644
index 0000000..55b8913
--- /dev/null
+++ b/drivers/eeprom/eeprom-mmio.c
@@ -0,0 +1,69 @@
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
+#include <linux/of_device.h>
+#include "eeprom-mmio.h"
+
+int eeprom_mmio_remove(struct platform_device *pdev)
+{
+	struct eeprom_device *eeprom = platform_get_drvdata(pdev);
+
+	return eeprom_unregister(eeprom);
+}
+EXPORT_SYMBOL_GPL(eeprom_mmio_remove);
+
+int eeprom_mmio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	const struct eeprom_mmio_data *data;
+	struct eeprom_device *eeprom;
+	struct regmap *regmap;
+	const struct of_device_id *match;
+	void __iomem *base;
+
+	if (!dev || !dev->driver)
+		return -ENODEV;
+
+	match = of_match_device(dev->driver->of_match_table, dev);
+	if (!match || !match->data)
+		return -EINVAL;
+
+	data = match->data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	data->regmap_config->max_register = resource_size(res) - 1;
+
+	regmap = devm_regmap_init_mmio(dev, base, data->regmap_config);
+	if (IS_ERR(regmap)) {
+		dev_err(dev, "regmap init failed\n");
+		return PTR_ERR(regmap);
+	}
+	data->eeprom_config->dev = dev;
+	eeprom = eeprom_register(data->eeprom_config);
+	if (IS_ERR(eeprom))
+		return PTR_ERR(eeprom);
+
+	platform_set_drvdata(pdev, eeprom);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eeprom_mmio_probe);
diff --git a/drivers/eeprom/eeprom-mmio.h b/drivers/eeprom/eeprom-mmio.h
new file mode 100644
index 0000000..e58bcc8
--- /dev/null
+++ b/drivers/eeprom/eeprom-mmio.h
@@ -0,0 +1,41 @@
+/*
+ * MMIO based EEPROM providers.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _LINUX_EEPROM_MMIO_H
+#define _LINUX_EEPROM_MMIO_H
+
+#include <linux/platform_device.h>
+#include <linux/eeprom-provider.h>
+#include <linux/regmap.h>
+
+struct eeprom_mmio_data {
+	struct regmap_config *regmap_config;
+	struct eeprom_config *eeprom_config;
+};
+
+#if IS_ENABLED(CONFIG_EEPROM)
+
+int eeprom_mmio_probe(struct platform_device *pdev);
+int eeprom_mmio_remove(struct platform_device *pdev);
+
+#else
+
+static inline int eeprom_mmio_probe(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+
+static inline int eeprom_mmio_remove(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+#endif
+
+#endif  /* ifndef _LINUX_EEPROM_MMIO_H */
-- 
1.9.1
