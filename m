From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [RFC PATCH 3/3] eeprom: qfprom: Add Qualcomm QFPROM support.
Date: Thu, 19 Feb 2015 17:08:51 +0000
Message-ID: <1424365731-26768-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds QFPROM support driver which is used by other drivers
like thermal sensor and cpufreq.

On MSM parts there are some efuses (called qfprom) these fuses store things like
calibration data, speed bins.. etc. Drivers like cpufreq, thermal sensors would
read out this data for configuring the driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/eeprom/Kconfig  |  6 ++++
 drivers/eeprom/Makefile |  1 +
 drivers/eeprom/qfprom.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)
 create mode 100644 drivers/eeprom/qfprom.c

diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
index 39235a9..b0c94cb 100644
--- a/drivers/eeprom/Kconfig
+++ b/drivers/eeprom/Kconfig
@@ -26,4 +26,10 @@ config EEPROM_SUNXI_SID
 	  This driver can also be built as a module. If so, the module
 	  will be called sunxi_sid.
 
+config QCOM_QFPROM
+	tristate "QCOM QFPROM Support"
+        depends on EEPROM
+	help
+          Say y here to enable QFPROM support. The QFPROM provides access
+          functions for QFPROM data to rest of the drivers via eeprom interface.
 endif
diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
index 661422c..f99c824 100644
--- a/drivers/eeprom/Makefile
+++ b/drivers/eeprom/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_EEPROM)		+= core.o
 
 # Devices
 obj-$(CONFIG_EEPROM_SUNXI_SID)	+= eeprom-sunxi-sid.o
+obj-$(CONFIG_QCOM_QFPROM)	+= qfprom.o
diff --git a/drivers/eeprom/qfprom.c b/drivers/eeprom/qfprom.c
new file mode 100644
index 0000000..da31b36
--- /dev/null
+++ b/drivers/eeprom/qfprom.c
@@ -0,0 +1,75 @@
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
+	int rval;
+
+	eeprom = devm_kzalloc(dev, sizeof(*eeprom), GFP_KERNEL);
+	if (!eeprom)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	qfprom_regmap_config.max_register = resource_size(res) - 1;
+
+	eeprom->regmap = devm_regmap_init_mmio(dev, base,
+					       &qfprom_regmap_config);
+	if (IS_ERR(eeprom->regmap)) {
+		dev_err(dev, "regmap init failed\n");
+		return PTR_ERR(eeprom->regmap);
+	}
+
+	eeprom->dev = dev;
+	eeprom->stride = qfprom_regmap_config.reg_stride;
+	eeprom->size = resource_size(res) - 1;
+	rval = eeprom_register(eeprom);
+	if (rval)
+		return rval;
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
+MODULE_AUTHOR("Srinivas Kandagatla <srinivas.kandagatla@linaro.org>");
+MODULE_DESCRIPTION("Qualcomm QFPROM driver");
+MODULE_LICENSE("GPL2");
-- 
1.9.1
