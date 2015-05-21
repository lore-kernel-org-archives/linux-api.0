From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 07/11] nvmem: Add simple nvmem-mmio consumer helper functions.
Date: Thu, 21 May 2015 17:44:25 +0100
Message-ID: <1432226665-8994-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432226535-8640-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch adds probe and remove helper functions for nvmems which are
mmio based, With these helper function new nvmem consumer drivers need
very little code add its driver.

This code is currently used for qfprom and sunxi-sid nvmem consumer
drivers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/nvmem/Makefile     |  1 +
 drivers/nvmem/nvmem-mmio.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvmem/nvmem-mmio.h | 41 +++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)
 create mode 100644 drivers/nvmem/nvmem-mmio.c
 create mode 100644 drivers/nvmem/nvmem-mmio.h

diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
index 6df2c69..f694cfc 100644
--- a/drivers/nvmem/Makefile
+++ b/drivers/nvmem/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_NVMEM)		+= nvmem_core.o
 nvmem_core-y			:= core.o
+nvmem_core-y			+= nvmem-mmio.o
diff --git a/drivers/nvmem/nvmem-mmio.c b/drivers/nvmem/nvmem-mmio.c
new file mode 100644
index 0000000..0d8131f
--- /dev/null
+++ b/drivers/nvmem/nvmem-mmio.c
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
+#include "nvmem-mmio.h"
+
+int nvmem_mmio_remove(struct platform_device *pdev)
+{
+	struct nvmem_device *nvmem = platform_get_drvdata(pdev);
+
+	return nvmem_unregister(nvmem);
+}
+EXPORT_SYMBOL_GPL(nvmem_mmio_remove);
+
+int nvmem_mmio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	const struct nvmem_mmio_data *data;
+	struct nvmem_device *nvmem;
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
+	data->nvmem_config->dev = dev;
+	nvmem = nvmem_register(data->nvmem_config);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	platform_set_drvdata(pdev, nvmem);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvmem_mmio_probe);
diff --git a/drivers/nvmem/nvmem-mmio.h b/drivers/nvmem/nvmem-mmio.h
new file mode 100644
index 0000000..a2ad4e5
--- /dev/null
+++ b/drivers/nvmem/nvmem-mmio.h
@@ -0,0 +1,41 @@
+/*
+ * MMIO based nvmem providers.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _LINUX_NVMEM_MMIO_H
+#define _LINUX_NVMEM_MMIO_H
+
+#include <linux/platform_device.h>
+#include <linux/nvmem-provider.h>
+#include <linux/regmap.h>
+
+struct nvmem_mmio_data {
+	struct regmap_config *regmap_config;
+	struct nvmem_config *nvmem_config;
+};
+
+#if IS_ENABLED(CONFIG_NVMEM)
+
+int nvmem_mmio_probe(struct platform_device *pdev);
+int nvmem_mmio_remove(struct platform_device *pdev);
+
+#else
+
+static inline int nvmem_mmio_probe(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+
+static inline int nvmem_mmio_remove(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+#endif
+
+#endif  /* ifndef _LINUX_NVMEM_MMIO_H */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
