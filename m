From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom providers
Date: Fri, 13 Mar 2015 09:50:14 +0000
Message-ID: <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426240157-2383-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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

Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
[Maxime Ripard: intial version of eeprom framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/Kconfig                 |   2 +
 drivers/Makefile                |   1 +
 drivers/eeprom/Kconfig          |  11 +++
 drivers/eeprom/Makefile         |   5 +
 drivers/eeprom/core.c           | 213 ++++++++++++++++++++++++++++++++++++++++
 include/linux/eeprom-provider.h |  47 +++++++++
 6 files changed, 279 insertions(+)
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
index 0000000..21e1847
--- /dev/null
+++ b/drivers/eeprom/Kconfig
@@ -0,0 +1,11 @@
+menuconfig EEPROM
+	tristate "EEPROM Support"
+	depends on OF
+	select REGMAP
+	help
+	  Support for EEPROM alike devices.
+
+	  This framework is designed to provide a generic interface to EEPROM
+	  from both the Linux Kernel and the userspace.
+
+	  If unsure, say no.
diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
new file mode 100644
index 0000000..250c95a
--- /dev/null
+++ b/drivers/eeprom/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for eeprom drivers.
+#
+
+obj-$(CONFIG_EEPROM)		+= core.o
diff --git a/drivers/eeprom/core.c b/drivers/eeprom/core.c
new file mode 100644
index 0000000..a9839de
--- /dev/null
+++ b/drivers/eeprom/core.c
@@ -0,0 +1,213 @@
+/*
+ * EEPROM framework core.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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
+	int			users;
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
+EXPORT_SYMBOL_GPL(eeprom_register);
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
+	if (eeprom->users) {
+		mutex_unlock(&eeprom_mutex);
+		return -EBUSY;
+	}
+	mutex_unlock(&eeprom_mutex);
+
+	device_del(&eeprom->dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eeprom_unregister);
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
+MODULE_AUTHOR("Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org");
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org");
+MODULE_DESCRIPTION("EEPROM Driver Core");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/eeprom-provider.h b/include/linux/eeprom-provider.h
new file mode 100644
index 0000000..21afdaa
--- /dev/null
+++ b/include/linux/eeprom-provider.h
@@ -0,0 +1,47 @@
+/*
+ * EEPROM framework provider.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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
+#if IS_ENABLED(CONFIG_EEPROM)
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
