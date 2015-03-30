From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 07/10] eeprom: qfprom: Add Qualcomm QFPROM support.
Date: Mon, 30 Mar 2015 22:58:22 +0100
Message-ID: <1427752702-17345-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds QFPROM support driver which is used by other drivers
like thermal sensor and cpufreq.

On MSM parts there are some efuses (called qfprom) these fuses store things like
calibration data, speed bins.. etc. Drivers like cpufreq, thermal sensors would
read out this data for configuring the driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/eeprom/Kconfig  | 15 +++++++++++++++
 drivers/eeprom/Makefile |  4 ++++
 drivers/eeprom/qfprom.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)
 create mode 100644 drivers/eeprom/qfprom.c

diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
index 15985e1..8fcde9b 100644
--- a/drivers/eeprom/Kconfig
+++ b/drivers/eeprom/Kconfig
@@ -8,3 +8,18 @@ menuconfig EEPROM
 	  from both the Linux Kernel and the userspace.
 
 	  If unsure, say no.
+
+if EEPROM
+
+config QCOM_QFPROM
+	tristate "QCOM QFPROM Support"
+	depends on ARCH_QCOM
+	select REGMAP_MMIO
+	help
+	  Say y here to enable QFPROM support. The QFPROM provides access
+	  functions for QFPROM data to rest of the drivers via eeprom interface.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called eeprom-qfprom.
+
+endif
diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
index 6812bbe..819476c 100644
--- a/drivers/eeprom/Makefile
+++ b/drivers/eeprom/Makefile
@@ -5,3 +5,7 @@
 obj-$(CONFIG_EEPROM)		+= eeprom_core.o
 eeprom_core-y			:= core.o
 eeprom_core-y			+= eeprom-mmio.o
+
+# Devices
+obj-$(CONFIG_QCOM_QFPROM)	+= eeprom_qfprom.o
+eeprom_qfprom-y			:= qfprom.o
diff --git a/drivers/eeprom/qfprom.c b/drivers/eeprom/qfprom.c
new file mode 100644
index 0000000..011bdf1
--- /dev/null
+++ b/drivers/eeprom/qfprom.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
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
+#include <linux/module.h>
+#include <linux/of.h>
+#include "eeprom-mmio.h"
+
+static struct regmap_config qfprom_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 8,
+	.reg_stride = 1,
+};
+
+static struct eeprom_config econfig = {
+	.name = "qfprom",
+	.owner = THIS_MODULE,
+};
+
+static struct eeprom_mmio_data qfprom_data = {
+	.eeprom_config = &econfig,
+	.regmap_config = &qfprom_regmap_config,
+};
+
+static const struct of_device_id qfprom_of_match[] = {
+	{ .compatible = "qcom,qfprom", .data = &qfprom_data},
+	{/* sentinel */},
+};
+MODULE_DEVICE_TABLE(of, qfprom_of_match);
+
+static struct platform_driver qfprom_driver = {
+	.probe = eeprom_mmio_probe,
+	.remove = eeprom_mmio_remove,
+	.driver = {
+		.name = "qcom,qfprom",
+		.of_match_table = qfprom_of_match,
+	},
+};
+module_platform_driver(qfprom_driver);
+MODULE_AUTHOR("Srinivas Kandagatla <srinivas.kandagatla@linaro.org>");
+MODULE_DESCRIPTION("Qualcomm QFPROM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1
