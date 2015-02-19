From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Thu, 19 Feb 2015 17:08:28 +0000
Message-ID: <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

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
[srinivas.kandagatla: Moved to regmap based and cleanedup apis]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 .../devicetree/bindings/eeprom/eeprom.txt          |  48 ++++
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/eeprom/Kconfig                             |  19 ++
 drivers/eeprom/Makefile                            |   9 +
 drivers/eeprom/core.c                              | 290 +++++++++++++++++++++
 include/linux/eeprom-consumer.h                    |  73 ++++++
 include/linux/eeprom-provider.h                    |  51 ++++
 8 files changed, 493 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
 create mode 100644 drivers/eeprom/Kconfig
 create mode 100644 drivers/eeprom/Makefile
 create mode 100644 drivers/eeprom/core.c
 create mode 100644 include/linux/eeprom-consumer.h
 create mode 100644 include/linux/eeprom-provider.h

diff --git a/Documentation/devicetree/bindings/eeprom/eeprom.txt b/Documentation/devicetree/bindings/eeprom/eeprom.txt
new file mode 100644
index 0000000..9ec1ec2
--- /dev/null
+++ b/Documentation/devicetree/bindings/eeprom/eeprom.txt
@@ -0,0 +1,48 @@
+= EEPROM Data Device Tree Bindings =
+
+This binding is intended to represent the location of hardware
+configuration data stored in EEPROMs.
+
+On a significant proportion of boards, the manufacturer has stored
+some data on an EEPROM-like device, for the OS to be able to retrieve
+these information and act upon it. Obviously, the OS has to know
+about where to retrieve these data from, and where they are stored on
+the storage device.
+
+This document is here to document this.
+
+= Data providers =
+
+Required properties:
+#eeprom-cells:	Number of cells in an eeprom specifier; The common
+		case is 2.
+
+For example:
+
+	at24: eeprom@42 {
+		#eeprom-cells = <2>;
+	};
+
+= Data consumers =
+
+Required properties:
+
+eeproms: List of phandle and data cell specifier triplet, one triplet
+	 for each data cell the device might be interested in. The
+	 triplet consists of the phandle to the eeprom provider, then
+	 the offset in byte within that storage device, and the length
+	 in byte of the data we care about.
+
+Optional properties:
+
+eeprom-names: List of data cell name strings sorted in the same order
+ 	      as the resets property. Consumers drivers will use
+ 	      eeprom-names to differentiate between multiple cells,
+ 	      and hence being able to know what these cells are for.
+
+For example:
+
+	device {
+		eeproms = <&at24 14 42>;
+		eeprom-names = "soc-rev-id";
+	};
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
index 0000000..2c5452a
--- /dev/null
+++ b/drivers/eeprom/Kconfig
@@ -0,0 +1,19 @@
+menuconfig EEPROM
+	bool "EEPROM Support"
+	depends on OF
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
index 0000000..bc877a6
--- /dev/null
+++ b/drivers/eeprom/core.c
@@ -0,0 +1,290 @@
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
+#include <linux/eeprom-consumer.h>
+#include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+struct eeprom_cell {
+	struct eeprom_device *eeprom;
+	loff_t offset;
+	size_t count;
+};
+
+static DEFINE_MUTEX(eeprom_list_mutex);
+static LIST_HEAD(eeprom_list);
+static DEFINE_IDA(eeprom_ida);
+
+static ssize_t bin_attr_eeprom_read_write(struct kobject *kobj,
+				    char *buf, loff_t offset,
+				    size_t count, bool read)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct eeprom_device *eeprom = container_of(dev, struct eeprom_device,
+						    edev);
+	int rc;
+
+	if (offset > eeprom->size)
+		return 0;
+
+	if (offset + count > eeprom->size)
+		count = eeprom->size - offset;
+
+	if (read)
+		rc = regmap_bulk_read(eeprom->regmap, offset,
+				      buf, count/eeprom->stride);
+	else
+		rc = regmap_bulk_write(eeprom->regmap, offset,
+				       buf, count/eeprom->stride);
+
+	if (IS_ERR_VALUE(rc))
+		return 0;
+
+	return count;
+}
+
+static ssize_t bin_attr_eeprom_read(struct file *filp, struct kobject *kobj,
+				    struct bin_attribute *attr,
+				    char *buf, loff_t offset, size_t count)
+{
+	return bin_attr_eeprom_read_write(kobj, buf, offset, count, true);
+}
+
+static ssize_t bin_attr_eeprom_write(struct file *filp, struct kobject *kobj,
+				     struct bin_attribute *attr,
+				     char *buf, loff_t offset, size_t count)
+{
+	return bin_attr_eeprom_read_write(kobj, buf, offset, count, false);
+}
+
+static struct bin_attribute bin_attr_eeprom = {
+	.attr	= {
+		.name	= "eeprom",
+		.mode	= 0660,
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
+static struct class eeprom_class = {
+	.name		= "eeprom",
+	.dev_groups	= eeprom_dev_groups,
+};
+
+int eeprom_register(struct eeprom_device *eeprom)
+{
+	int rval;
+
+	if (!eeprom->regmap || !eeprom->size) {
+		dev_err(eeprom->dev, "Regmap not found\n");
+		return -EINVAL;
+	}
+
+	eeprom->id = ida_simple_get(&eeprom_ida, 0, 0, GFP_KERNEL);
+	if (eeprom->id < 0)
+		return eeprom->id;
+
+	eeprom->edev.class = &eeprom_class;
+	eeprom->edev.parent = eeprom->dev;
+	eeprom->edev.of_node = eeprom->dev ? eeprom->dev->of_node : NULL;
+	dev_set_name(&eeprom->edev, "eeprom%d", eeprom->id);
+
+	device_initialize(&eeprom->edev);
+
+	dev_dbg(&eeprom->edev, "Registering eeprom device %s\n",
+		dev_name(&eeprom->edev));
+
+	rval = device_add(&eeprom->edev);
+	if (rval)
+		return rval;
+
+	mutex_lock(&eeprom_list_mutex);
+	list_add(&eeprom->list, &eeprom_list);
+	mutex_unlock(&eeprom_list_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(eeprom_register);
+
+int eeprom_unregister(struct eeprom_device *eeprom)
+{
+	device_del(&eeprom->edev);
+
+	mutex_lock(&eeprom_list_mutex);
+	list_del(&eeprom->list);
+	mutex_unlock(&eeprom_list_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL(eeprom_unregister);
+
+static struct eeprom_cell *__eeprom_cell_get(struct device_node *node,
+					     int index)
+{
+	struct of_phandle_args args;
+	struct eeprom_cell *cell;
+	struct eeprom_device *e, *eeprom = NULL;
+	int ret;
+
+	ret = of_parse_phandle_with_args(node, "eeproms",
+					 "#eeprom-cells", index, &args);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (args.args_count != 2)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&eeprom_list_mutex);
+
+	list_for_each_entry(e, &eeprom_list, list) {
+		if (args.np == e->edev.of_node) {
+			eeprom = e;
+			break;
+		}
+	}
+	mutex_unlock(&eeprom_list_mutex);
+
+	if (!eeprom)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	cell = kzalloc(sizeof(*cell), GFP_KERNEL);
+	if (!cell)
+		return ERR_PTR(-ENOMEM);
+
+	cell->eeprom = eeprom;
+	cell->offset = args.args[0];
+	cell->count = args.args[1];
+
+	return cell;
+}
+
+static struct eeprom_cell *__eeprom_cell_get_byname(struct device_node *node,
+						    const char *id)
+{
+	int index = 0;
+
+	if (id)
+		index = of_property_match_string(node,
+						 "eeprom-names",
+						 id);
+	return __eeprom_cell_get(node, index);
+
+}
+
+struct eeprom_cell *eeprom_cell_get(struct device *dev, int index)
+{
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
+	/* First, attempt to retrieve the cell through the DT */
+	if (dev->of_node)
+		return __eeprom_cell_get(dev->of_node, index);
+
+	/* We don't support anything else yet */
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL(eeprom_cell_get);
+
+struct eeprom_cell *eeprom_cell_get_byname(struct device *dev, const char *id)
+{
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
+	if (id && dev->of_node)
+		return __eeprom_cell_get_byname(dev->of_node, id);
+
+	/* We don't support anything else yet */
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL(eeprom_cell_get_byname);
+
+void eeprom_cell_put(struct eeprom_cell *cell)
+{
+	kfree(cell);
+}
+EXPORT_SYMBOL(eeprom_cell_put);
+
+char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len)
+{
+	struct eeprom_device *eeprom = cell->eeprom;
+	char *buf;
+	int rc;
+
+	if (!eeprom || !eeprom->regmap)
+		return ERR_PTR(-EINVAL);
+
+	buf = kzalloc(cell->count, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	rc = regmap_bulk_read(eeprom->regmap, cell->offset,
+			      buf, cell->count/eeprom->stride);
+	if (IS_ERR_VALUE(rc)) {
+		kfree(buf);
+		return ERR_PTR(rc);
+	}
+
+	*len = cell->count;
+
+	return buf;
+}
+EXPORT_SYMBOL(eeprom_cell_read);
+
+int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len)
+{
+	struct eeprom_device *eeprom = cell->eeprom;
+
+	if (!eeprom || !eeprom->regmap)
+		return -EINVAL;
+
+	return regmap_bulk_write(eeprom->regmap, cell->offset,
+				 buf, cell->count/eeprom->stride);
+}
+EXPORT_SYMBOL(eeprom_cell_write);
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
+MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
+MODULE_DESCRIPTION("EEPROM Driver Core");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/eeprom-consumer.h b/include/linux/eeprom-consumer.h
new file mode 100644
index 0000000..706ae9d
--- /dev/null
+++ b/include/linux/eeprom-consumer.h
@@ -0,0 +1,73 @@
+/*
+ * EEPROM framework consumer.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
+ * Copyright (C) 2013 Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _LINUX_EEPROM_CONSUMER_H
+#define _LINUX_EEPROM_CONSUMER_H
+
+struct eeprom_cell;
+
+/**
+ * eeprom_cell_get(): Get eeprom cell of device form a given index.
+ *
+ * @dev: Device that will be interacted with
+ * @index: Index of the eeprom cell.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct eeprom_cell.  The eeprom_cell will be freed by the
+ * eeprom_cell_put().
+ */
+struct eeprom_cell *eeprom_cell_get(struct device *dev, int index);
+
+/**
+ * eeprom_cell_get(): Get eeprom cell of device form a given name.
+ *
+ * @dev: Device that will be interacted with
+ * @name: Name of the eeprom cell.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct eeprom_cell.  The eeprom_cell will be freed by the
+ * eeprom_cell_put().
+ */
+struct eeprom_cell *eeprom_cell_get_byname(struct device *dev,
+					   const char *name);
+
+/**
+ * eeprom_cell_put(): Release previously allocated eeprom cell.
+ *
+ * @cell: Previously allocated eeprom cell by eeprom_cell_get()
+ * or eeprom_cell_get_byname().
+ */
+void eeprom_cell_put(struct eeprom_cell *cell);
+
+/**
+ * eeprom_cell_read(): Read a given eeprom cell
+ *
+ * @cell: eeprom cell to be read.
+ * @len: pointer to length of cell which will be populated on successful read.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a char * bufffer.  The buffer should be freed by the consumer with a
+ * kfree().
+ */
+char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len);
+
+/**
+ * eeprom_cell_write(): Write to a given eeprom cell
+ *
+ * @cell: eeprom cell to be written.
+ * @buf: Buffer to be written.
+ * @len: length of buffer to be written to eeprom cell.
+ *
+ * The return value will be an non zero on error or a zero on successful write.
+ */
+int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len);
+
+#endif  /* ifndef _LINUX_EEPROM_CONSUMER_H */
diff --git a/include/linux/eeprom-provider.h b/include/linux/eeprom-provider.h
new file mode 100644
index 0000000..3943c2f
--- /dev/null
+++ b/include/linux/eeprom-provider.h
@@ -0,0 +1,51 @@
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
+#include <linux/device.h>
+#include <linux/regmap.h>
+#include <linux/list.h>
+
+struct eeprom_device {
+	struct regmap		*regmap;
+	int			stride;
+	size_t			size;
+	struct device		*dev;
+
+	/* Internal to framework */
+	struct device		edev;
+	int			id;
+	struct list_head	list;
+};
+
+/**
+ * eeprom_register(): Register a eeprom device for given eeprom.
+ * Also creates an binary entry in /sys/class/eeprom/eeprom[id]/eeprom
+ *
+ * @eeprom: eeprom device that needs to be created
+ *
+ * The return value will be an error code on error or a zero on success.
+ * The eeprom_device and sysfs entery will be freed by the eeprom_unregister().
+ */
+int eeprom_register(struct eeprom_device *eeprom);
+
+/**
+ * eeprom_unregister(): Unregister previously registered eeprom device
+ *
+ * @eeprom: Pointer to previously registered eeprom device.
+ *
+ * The return value will be an non zero on error or a zero on success.
+ */
+int eeprom_unregister(struct eeprom_device *eeprom);
+
+#endif  /* ifndef _LINUX_EEPROM_PROVIDER_H */
-- 
1.9.1
