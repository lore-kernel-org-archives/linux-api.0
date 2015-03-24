From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 6/9] eeprom: sunxi: Move the SID driver to the eeprom framework
Date: Tue, 24 Mar 2015 22:30:41 +0000
Message-ID: <1427236241-18798-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

Now that we have the EEPROM framework, we can consolidate the common driver
code. Move the driver to the framework, and hopefully, it will fix the sysfs
file creation race.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
[srinivas.kandagatla: Moved to regmap based EEPROM framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 Documentation/ABI/testing/sysfs-driver-sunxi-sid   |  22 ---
 .../bindings/eeprom/allwinner,sunxi-sid.txt        |  21 +++
 .../bindings/misc/allwinner,sunxi-sid.txt          |  17 ---
 drivers/eeprom/Kconfig                             |  15 ++
 drivers/eeprom/Makefile                            |   4 +
 drivers/eeprom/sunxi-sid.c                         | 136 ++++++++++++++++++
 drivers/misc/eeprom/Kconfig                        |  13 --
 drivers/misc/eeprom/Makefile                       |   1 -
 drivers/misc/eeprom/sunxi_sid.c                    | 156 ---------------------
 9 files changed, 176 insertions(+), 209 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
 create mode 100644 Documentation/devicetree/bindings/eeprom/allwinner,sunxi-sid.txt
 delete mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
 create mode 100644 drivers/eeprom/sunxi-sid.c
 delete mode 100644 drivers/misc/eeprom/sunxi_sid.c

diff --git a/Documentation/ABI/testing/sysfs-driver-sunxi-sid b/Documentation/ABI/testing/sysfs-driver-sunxi-sid
deleted file mode 100644
index ffb9536..0000000
--- a/Documentation/ABI/testing/sysfs-driver-sunxi-sid
+++ /dev/null
@@ -1,22 +0,0 @@
-What:		/sys/devices/*/<our-device>/eeprom
-Date:		August 2013
-Contact:	Oliver Schinagl <oliver@schinagl.nl>
-Description:	read-only access to the SID (Security-ID) on current
-		A-series SoC's from Allwinner. Currently supports A10, A10s, A13
-		and A20 CPU's. The earlier A1x series of SoCs exports 16 bytes,
-		whereas the newer A20 SoC exposes 512 bytes split into sections.
-		Besides the 16 bytes of SID, there's also an SJTAG area,
-		HDMI-HDCP key and some custom keys. Below a quick overview, for
-		details see the user manual:
-		0x000  128 bit root-key (sun[457]i)
-		0x010  128 bit boot-key (sun7i)
-		0x020   64 bit security-jtag-key (sun7i)
-		0x028   16 bit key configuration (sun7i)
-		0x02b   16 bit custom-vendor-key (sun7i)
-		0x02c  320 bit low general key (sun7i)
-		0x040   32 bit read-control access (sun7i)
-		0x064  224 bit low general key (sun7i)
-		0x080 2304 bit HDCP-key (sun7i)
-		0x1a0  768 bit high general key (sun7i)
-Users:		any user space application which wants to read the SID on
-		Allwinner's A-series of CPU's.
diff --git a/Documentation/devicetree/bindings/eeprom/allwinner,sunxi-sid.txt b/Documentation/devicetree/bindings/eeprom/allwinner,sunxi-sid.txt
new file mode 100644
index 0000000..cceaaf6
--- /dev/null
+++ b/Documentation/devicetree/bindings/eeprom/allwinner,sunxi-sid.txt
@@ -0,0 +1,21 @@
+Allwinner sunxi-sid
+
+Required properties:
+- compatible: "allwinner,sun4i-a10-sid" or "allwinner,sun7i-a20-sid"
+- reg: Should contain registers location and length
+
+= Data cells =
+Are child nodes of qfprom, bindings of which as described in
+bindings/eeprom/eeprom.txt
+
+Example for sun4i:
+	sid@01c23800 {
+		compatible = "allwinner,sun4i-a10-sid";
+		reg = <0x01c23800 0x10>
+	};
+
+Example for sun7i:
+	sid@01c23800 {
+		compatible = "allwinner,sun7i-a20-sid";
+		reg = <0x01c23800 0x200>
+	};
diff --git a/Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt b/Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
deleted file mode 100644
index fabdf64..0000000
--- a/Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-Allwinner sunxi-sid
-
-Required properties:
-- compatible: "allwinner,sun4i-a10-sid" or "allwinner,sun7i-a20-sid"
-- reg: Should contain registers location and length
-
-Example for sun4i:
-	sid@01c23800 {
-		compatible = "allwinner,sun4i-a10-sid";
-		reg = <0x01c23800 0x10>
-	};
-
-Example for sun7i:
-	sid@01c23800 {
-		compatible = "allwinner,sun7i-a20-sid";
-		reg = <0x01c23800 0x200>
-	};
diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
index 21e1847..ad396c1 100644
--- a/drivers/eeprom/Kconfig
+++ b/drivers/eeprom/Kconfig
@@ -9,3 +9,18 @@ menuconfig EEPROM
 	  from both the Linux Kernel and the userspace.
 
 	  If unsure, say no.
+
+if EEPROM
+
+config EEPROM_SUNXI_SID
+	tristate "Allwinner SoCs SID support"
+	depends on ARCH_SUNXI
+	select REGMAP_MMIO
+	help
+	  This is a driver for the 'security ID' available on various Allwinner
+	  devices.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called eeprom-sunxi-sid.
+
+endif
diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
index 51a727f..184aa53 100644
--- a/drivers/eeprom/Makefile
+++ b/drivers/eeprom/Makefile
@@ -4,3 +4,7 @@
 
 obj-$(CONFIG_EEPROM)		+= eeprom_core.o
 eeprom_core-y			:= core.o
+
+# Devices
+obj-$(CONFIG_EEPROM_SUNXI_SID)	+= eeprom-sunxi-sid.o
+eeprom-sunxi-sid-y		:= sunxi-sid.o
diff --git a/drivers/eeprom/sunxi-sid.c b/drivers/eeprom/sunxi-sid.c
new file mode 100644
index 0000000..dd7238d
--- /dev/null
+++ b/drivers/eeprom/sunxi-sid.c
@@ -0,0 +1,136 @@
+/*
+ * Allwinner sunXi SoCs Security ID support.
+ *
+ * Copyright (c) 2013 Oliver Schinagl <oliver@schinagl.nl>
+ * Copyright (C) 2014 Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/eeprom-provider.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+struct eeprom_sid {
+	void __iomem	*membase;
+	struct eeprom_device *eeprom;
+};
+
+static struct eeprom_config econfig = {
+	.name = "sunix-sid",
+};
+
+/* We read the entire key, due to a 32 bit read alignment requirement. Since we
+ * want to return the requested byte, this results in somewhat slower code and
+ * uses 4 times more reads as needed but keeps code simpler. Since the SID is
+ * only very rarely probed, this is not really an issue.
+ */
+static int sunxi_sid_reg_read(void *context,
+			      unsigned int offset, unsigned int *val)
+{
+	struct eeprom_sid *sid  = context;
+	u32 sid_key;
+
+	sid_key = ioread32be(sid->membase + round_down(offset, 4));
+	sid_key >>= (offset % 4) * 8;
+
+	*val = sid_key;
+
+	return 0;
+}
+
+static bool sunxi_sid_writeable_reg(struct device *dev, unsigned int reg)
+{
+	return false;
+}
+
+static const struct of_device_id sunxi_sid_of_match[] = {
+	{ .compatible = "allwinner,sun4i-a10-sid", .data = (void *)16},
+	{ .compatible = "allwinner,sun7i-a20-sid", .data = (void *)512},
+	{/* sentinel */},
+};
+MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
+
+static struct regmap_config sunxi_sid_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 8,
+	.reg_stride = 1,
+	.reg_read = sunxi_sid_reg_read,
+	.writeable_reg = sunxi_sid_writeable_reg,
+};
+
+static int sunxi_sid_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *device;
+	struct eeprom_sid *sid;
+	struct resource *res;
+	struct eeprom_device *eeprom;
+	struct device *dev = &pdev->dev;
+	struct regmap *regmap;
+
+	sid = devm_kzalloc(dev, sizeof(*sid), GFP_KERNEL);
+	if (!sid)
+		return -ENOMEM;
+
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sid->membase = devm_ioremap_resource(dev, res);
+	if (IS_ERR(sid->membase))
+		return PTR_ERR(sid->membase);
+
+	device = of_match_device(sunxi_sid_of_match, dev);
+	if (!device)
+		return -ENODEV;
+
+	sunxi_sid_regmap_config.max_register = (unsigned int)device->data - 1;
+
+	regmap = devm_regmap_init(dev, NULL,
+					  sid, &sunxi_sid_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	econfig.dev = dev;
+	econfig.owner = THIS_MODULE;
+
+	eeprom = eeprom_register(&econfig);
+	if (IS_ERR(eeprom))
+		return PTR_ERR(eeprom);
+
+	platform_set_drvdata(pdev, eeprom);
+
+	return 0;
+}
+
+static int sunxi_sid_remove(struct platform_device *pdev)
+{
+	struct eeprom_device *eeprom = platform_get_drvdata(pdev);
+
+	return eeprom_unregister(eeprom);
+}
+
+static struct platform_driver sunxi_sid_driver = {
+	.probe = sunxi_sid_probe,
+	.remove = sunxi_sid_remove,
+	.driver = {
+		.name = "eeprom-sunxi-sid",
+		.of_match_table = sunxi_sid_of_match,
+	},
+};
+module_platform_driver(sunxi_sid_driver);
+
+MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
+MODULE_DESCRIPTION("Allwinner sunxi security id driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index 9536852f..04f2e1f 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -96,17 +96,4 @@ config EEPROM_DIGSY_MTC_CFG
 
 	  If unsure, say N.
 
-config EEPROM_SUNXI_SID
-	tristate "Allwinner sunxi security ID support"
-	depends on ARCH_SUNXI && SYSFS
-	help
-	  This is a driver for the 'security ID' available on various Allwinner
-	  devices.
-
-	  Due to the potential risks involved with changing e-fuses,
-	  this driver is read-only.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called sunxi_sid.
-
 endmenu
diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
index 9507aec..fc1e81d 100644
--- a/drivers/misc/eeprom/Makefile
+++ b/drivers/misc/eeprom/Makefile
@@ -4,5 +4,4 @@ obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
-obj-$(CONFIG_EEPROM_SUNXI_SID)	+= sunxi_sid.o
 obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_sid.c
deleted file mode 100644
index 8385177..0000000
--- a/drivers/misc/eeprom/sunxi_sid.c
+++ /dev/null
@@ -1,156 +0,0 @@
-/*
- * Copyright (c) 2013 Oliver Schinagl <oliver@schinagl.nl>
- * http://www.linux-sunxi.org
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * This driver exposes the Allwinner security ID, efuses exported in byte-
- * sized chunks.
- */
-
-#include <linux/compiler.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/export.h>
-#include <linux/fs.h>
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/kobject.h>
-#include <linux/module.h>
-#include <linux/of_device.h>
-#include <linux/platform_device.h>
-#include <linux/random.h>
-#include <linux/slab.h>
-#include <linux/stat.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-
-#define DRV_NAME "sunxi-sid"
-
-struct sunxi_sid_data {
-	void __iomem *reg_base;
-	unsigned int keysize;
-};
-
-/* We read the entire key, due to a 32 bit read alignment requirement. Since we
- * want to return the requested byte, this results in somewhat slower code and
- * uses 4 times more reads as needed but keeps code simpler. Since the SID is
- * only very rarely probed, this is not really an issue.
- */
-static u8 sunxi_sid_read_byte(const struct sunxi_sid_data *sid_data,
-			      const unsigned int offset)
-{
-	u32 sid_key;
-
-	if (offset >= sid_data->keysize)
-		return 0;
-
-	sid_key = ioread32be(sid_data->reg_base + round_down(offset, 4));
-	sid_key >>= (offset % 4) * 8;
-
-	return sid_key; /* Only return the last byte */
-}
-
-static ssize_t sid_read(struct file *fd, struct kobject *kobj,
-			struct bin_attribute *attr, char *buf,
-			loff_t pos, size_t size)
-{
-	struct platform_device *pdev;
-	struct sunxi_sid_data *sid_data;
-	int i;
-
-	pdev = to_platform_device(kobj_to_dev(kobj));
-	sid_data = platform_get_drvdata(pdev);
-
-	if (pos < 0 || pos >= sid_data->keysize)
-		return 0;
-	if (size > sid_data->keysize - pos)
-		size = sid_data->keysize - pos;
-
-	for (i = 0; i < size; i++)
-		buf[i] = sunxi_sid_read_byte(sid_data, pos + i);
-
-	return i;
-}
-
-static struct bin_attribute sid_bin_attr = {
-	.attr = { .name = "eeprom", .mode = S_IRUGO, },
-	.read = sid_read,
-};
-
-static int sunxi_sid_remove(struct platform_device *pdev)
-{
-	device_remove_bin_file(&pdev->dev, &sid_bin_attr);
-	dev_dbg(&pdev->dev, "driver unloaded\n");
-
-	return 0;
-}
-
-static const struct of_device_id sunxi_sid_of_match[] = {
-	{ .compatible = "allwinner,sun4i-a10-sid", .data = (void *)16},
-	{ .compatible = "allwinner,sun7i-a20-sid", .data = (void *)512},
-	{/* sentinel */},
-};
-MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
-
-static int sunxi_sid_probe(struct platform_device *pdev)
-{
-	struct sunxi_sid_data *sid_data;
-	struct resource *res;
-	const struct of_device_id *of_dev_id;
-	u8 *entropy;
-	unsigned int i;
-
-	sid_data = devm_kzalloc(&pdev->dev, sizeof(struct sunxi_sid_data),
-				GFP_KERNEL);
-	if (!sid_data)
-		return -ENOMEM;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	sid_data->reg_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(sid_data->reg_base))
-		return PTR_ERR(sid_data->reg_base);
-
-	of_dev_id = of_match_device(sunxi_sid_of_match, &pdev->dev);
-	if (!of_dev_id)
-		return -ENODEV;
-	sid_data->keysize = (int)of_dev_id->data;
-
-	platform_set_drvdata(pdev, sid_data);
-
-	sid_bin_attr.size = sid_data->keysize;
-	if (device_create_bin_file(&pdev->dev, &sid_bin_attr))
-		return -ENODEV;
-
-	entropy = kzalloc(sizeof(u8) * sid_data->keysize, GFP_KERNEL);
-	for (i = 0; i < sid_data->keysize; i++)
-		entropy[i] = sunxi_sid_read_byte(sid_data, i);
-	add_device_randomness(entropy, sid_data->keysize);
-	kfree(entropy);
-
-	dev_dbg(&pdev->dev, "loaded\n");
-
-	return 0;
-}
-
-static struct platform_driver sunxi_sid_driver = {
-	.probe = sunxi_sid_probe,
-	.remove = sunxi_sid_remove,
-	.driver = {
-		.name = DRV_NAME,
-		.of_match_table = sunxi_sid_of_match,
-	},
-};
-module_platform_driver(sunxi_sid_driver);
-
-MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
-MODULE_DESCRIPTION("Allwinner sunxi security id driver");
-MODULE_LICENSE("GPL");
-- 
1.9.1
