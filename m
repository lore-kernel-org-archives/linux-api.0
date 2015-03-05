From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 1/6] eeprom: Add a simple EEPROM framework for eeprom providers
Date: Thu,  5 Mar 2015 09:45:41 +0000
Message-ID: <1425548741-12930-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, andrew@lunn.ch, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds just providers part of the framework just to enable easy
review.

Up until now, EEPROM drivers were stored in drivers/misc, where they all had to
duplicate pretty much the same code to register a sysfs file, allow in-kernel
users to access the content of the devices they were driving, etc.

This was also a problem as far as other in-kernel users were involved, since
the solutions used were pretty much different from on driver to another, there
was a rather big abstraction leak.

This introduction of this framework aims at solving this. It also introduces DT
representation for consumer devices to go get the data they require (MAC
Addresses, SoC/Revision ID, part numbers, and so on) from the EEPROMs.

Having regmap interface to this framework would give much better
abstraction for eeproms on different buses.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
[Maxime Ripard: intial version of eeprom framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/Kconfig                 |   2 +
 drivers/Makefile                |   1 +
 drivers/eeprom/Kconfig          |  20 ++++
 drivers/eeprom/Makefile         |   9 ++
 drivers/eeprom/core.c           | 208 ++++++++++++++++++++++++++++++++++++++++
 include/linux/eeprom-provider.h |  47 +++++++++
 6 files changed, 287 insertions(+)
 create mode 100644 drivers/eeprom/Kconfig
 create mode 100644 drivers/eeprom/Makefile
 create mode 100644 drivers/eeprom/core.c
 create mode 100644 include/linux/eeprom-provider.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index c70d6e4..d7afc82 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -184,4 +184,6 @@ source "drivers/thunderbolt/Kconfig"
 
 source "drivers/android/Kconfig"
 
+source "drivers/eeprom/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 527a6da..57eb5b0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -165,3 +165,4 @@ obj-$(CONFIG_RAS)		+= ras/
 obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
 obj-$(CONFIG_CORESIGHT)		+= coresight/
 obj-$(CONFIG_ANDROID)		+= android/
+obj-$(CONFIG_EEPROM)		+= eeprom/
diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
new file mode 100644
index 0000000..d00f7d2
--- /dev/null
+++ b/drivers/eeprom/Kconfig
@@ -0,0 +1,20 @@
+menuconfig EEPROM
+	bool "EEPROM Support"
+	depends on OF
+	select REGMAP
+	help
+	  Support for EEPROM alike devices.
+
+	  This framework is designed to provide a generic interface to EEPROM
+	  from both the Linux Kernel and the userspace.
+
+	  If unsure, say no.
+
+if EEPROM
+
+config EEPROM_DEBUG
+	bool "EEPROM debug support"
+	help
+	  Say yes here to enable debugging support.
+
+endif
diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
new file mode 100644
index 0000000..e130079
--- /dev/null
+++ b/drivers/eeprom/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for eeprom drivers.
+#
+
+ccflags-$(CONFIG_EEPROM_DEBUG) += -DDEBUG
+
+obj-$(CONFIG_EEPROM)		+= core.o
+
+# Devices
diff --git a/drivers/eeprom/core.c b/drivers/eeprom/core.c
new file mode 100644
index 0000000..243e466
--- /dev/null
+++ b/drivers/eeprom/core.c
@@ -0,0 +1,208 @@
+/*
+ * EEPROM framework core.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
+ * Copyright (C) 2013 Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/device.h>
+#include <linux/eeprom-provider.h>
+#include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+struct eeprom_device {
+	struct regmap		*regmap;
+	int			stride;
+	size_t			size;
+
+	struct module		*owner;
+	struct device		dev;
+	int			id;
+	atomic_t		users;
+};
+
+static DEFINE_MUTEX(eeprom_mutex);
+static DEFINE_IDA(eeprom_ida);
+
+#define to_eeprom(d) container_of(d, struct eeprom_device, dev)
+
+static ssize_t bin_attr_eeprom_read(struct file *filp, struct kobject *kobj,
+				    struct bin_attribute *attr,
+				    char *buf, loff_t offset, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct eeprom_device *eeprom = to_eeprom(dev);
+	int rc;
+
+	if (offset > eeprom->size)
+		return -EINVAL;
+
+	if (offset + count > eeprom->size)
+		count = eeprom->size - offset;
+
+	rc = regmap_bulk_read(eeprom->regmap, offset,
+			      buf, count/eeprom->stride);
+
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	return count - count % eeprom->stride;
+}
+
+static ssize_t bin_attr_eeprom_write(struct file *filp, struct kobject *kobj,
+				     struct bin_attribute *attr,
+				     char *buf, loff_t offset, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct eeprom_device *eeprom = to_eeprom(dev);
+	int rc;
+
+	if (offset > eeprom->size)
+		return -EINVAL;
+
+	if (offset + count > eeprom->size)
+		count = eeprom->size - offset;
+
+	rc = regmap_bulk_write(eeprom->regmap, offset,
+			       buf, count/eeprom->stride);
+
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	return count - count % eeprom->stride;
+}
+
+static struct bin_attribute bin_attr_eeprom = {
+	.attr	= {
+		.name	= "eeprom",
+		.mode	= S_IWUSR | S_IRUGO,
+	},
+	.read	= bin_attr_eeprom_read,
+	.write	= bin_attr_eeprom_write,
+};
+
+static struct bin_attribute *eeprom_bin_attributes[] = {
+	&bin_attr_eeprom,
+	NULL,
+};
+
+static const struct attribute_group eeprom_bin_group = {
+	.bin_attrs	= eeprom_bin_attributes,
+};
+
+static const struct attribute_group *eeprom_dev_groups[] = {
+	&eeprom_bin_group,
+	NULL,
+};
+
+static void eeprom_release(struct device *dev)
+{
+	kfree(to_eeprom(dev));
+}
+
+static struct class eeprom_class = {
+	.name		= "eeprom",
+	.dev_groups	= eeprom_dev_groups,
+	.dev_release	= eeprom_release,
+};
+
+/**
+ * eeprom_register(): Register a eeprom device for given eeprom.
+ * Also creates an binary entry in /sys/class/eeprom/name-id/eeprom
+ *
+ * @eeprom: eeprom device that needs to be created
+ *
+ * The return value will be an error code on error or a zero on success.
+ * The eeprom_device and sysfs entery will be freed by the eeprom_unregister().
+ */
+
+struct eeprom_device *eeprom_register(struct eeprom_config *config)
+{
+	struct eeprom_device *eeprom;
+	int rval;
+
+	if (!config->regmap || !config->size) {
+		dev_err(config->dev, "Regmap not found\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	eeprom = kzalloc(sizeof(*eeprom), GFP_KERNEL);
+	if (!eeprom)
+		return ERR_PTR(-ENOMEM);
+
+	eeprom->id = ida_simple_get(&eeprom_ida, 0, 0, GFP_KERNEL);
+	if (eeprom->id < 0)
+		return ERR_PTR(eeprom->id);
+
+	eeprom->owner = config->owner;
+	eeprom->regmap = config->regmap;
+	eeprom->stride = config->stride;
+	eeprom->size = config->size;
+	eeprom->dev.class = &eeprom_class;
+	eeprom->dev.parent = config->dev;
+	eeprom->dev.of_node = config->dev ? config->dev->of_node : NULL;
+	dev_set_name(&eeprom->dev, "%s%d",
+		     config->name ? : "eeprom", config->id);
+
+	device_initialize(&eeprom->dev);
+
+	dev_dbg(&eeprom->dev, "Registering eeprom device %s\n",
+		dev_name(&eeprom->dev));
+
+	rval = device_add(&eeprom->dev);
+	if (rval)
+		return ERR_PTR(rval);
+
+	return eeprom;
+}
+EXPORT_SYMBOL(eeprom_register);
+
+/**
+ * eeprom_unregister(): Unregister previously registered eeprom device
+ *
+ * @eeprom: Pointer to previously registered eeprom device.
+ *
+ * The return value will be an non zero on error or a zero on success.
+ */
+int eeprom_unregister(struct eeprom_device *eeprom)
+{
+	mutex_lock(&eeprom_mutex);
+	if (atomic_read(&eeprom->users)) {
+		mutex_unlock(&eeprom_mutex);
+		return -EBUSY;
+	}
+
+	device_del(&eeprom->dev);
+	mutex_unlock(&eeprom_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(eeprom_unregister);
+
+static int eeprom_init(void)
+{
+	return class_register(&eeprom_class);
+}
+
+static void eeprom_exit(void)
+{
+	class_unregister(&eeprom_class);
+}
+
+subsys_initcall(eeprom_init);
+module_exit(eeprom_exit);
+
+MODULE_AUTHOR("Srinivas Kandagatla <srinivas.kandagatla@linaro.org");
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
+MODULE_DESCRIPTION("EEPROM Driver Core");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/eeprom-provider.h b/include/linux/eeprom-provider.h
new file mode 100644
index 0000000..51dc654
--- /dev/null
+++ b/include/linux/eeprom-provider.h
@@ -0,0 +1,47 @@
+/*
+ * EEPROM framework provider.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
+ * Copyright (C) 2013 Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _LINUX_EEPROM_PROVIDER_H
+#define _LINUX_EEPROM_PROVIDER_H
+
+#include <linux/regmap.h>
+
+struct eeprom_device;
+
+struct eeprom_config {
+	struct device		*dev;
+	struct regmap		*regmap;
+	const char		*name;
+	int			id;
+	int			stride;
+	size_t			size;
+	struct module		*owner;
+};
+
+#ifdef CONFIG_EEPROM
+
+struct eeprom_device *eeprom_register(struct eeprom_config *cfg);
+int eeprom_unregister(struct eeprom_device *eeprom);
+
+#else
+
+static inline struct eeprom_device *eeprom_register(struct eeprom_config *cfg)
+{
+	return NULL;
+}
+static inline int eeprom_unregister(struct eeprom_device *eeprom)
+{
+	return -ENOSYS;
+}
+
+#endif /* CONFIG_EEPROM */
+
+#endif  /* ifndef _LINUX_EEPROM_PROVIDER_H */
-- 
1.9.1
