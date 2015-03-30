From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for eeprom consumers
Date: Mon, 30 Mar 2015 22:57:50 +0100
Message-ID: <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427752492-17039-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds just consumers part of the framework just to enable easy
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
[Maxime Ripard: intial version of the framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/eeprom/core.c           | 271 ++++++++++++++++++++++++++++++++++++++++
 include/linux/eeprom-consumer.h |  61 +++++++++
 2 files changed, 332 insertions(+)
 create mode 100644 include/linux/eeprom-consumer.h

diff --git a/drivers/eeprom/core.c b/drivers/eeprom/core.c
index a2c7e6c..7065275 100644
--- a/drivers/eeprom/core.c
+++ b/drivers/eeprom/core.c
@@ -16,6 +16,7 @@
 
 #include <linux/device.h>
 #include <linux/eeprom-provider.h>
+#include <linux/eeprom-consumer.h>
 #include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
@@ -38,6 +39,13 @@ struct eeprom_device {
 	int			users;
 };
 
+struct eeprom_cell {
+	struct eeprom_device	*eeprom;
+	int			nblocks;
+	int			size;
+	struct eeprom_block	blocks[0];
+};
+
 static DEFINE_MUTEX(eeprom_mutex);
 static DEFINE_IDA(eeprom_ida);
 
@@ -130,6 +138,37 @@ static struct class eeprom_class = {
 	.dev_release	= eeprom_release,
 };
 
+static int of_eeprom_match(struct device *dev, const void *eeprom_np)
+{
+	return dev->of_node == eeprom_np;
+}
+
+static struct eeprom_device *of_eeprom_find(struct device_node *eeprom_np)
+{
+	struct device *d;
+
+	if (!eeprom_np)
+		return NULL;
+
+	d = class_find_device(&eeprom_class, NULL, eeprom_np, of_eeprom_match);
+
+	return d ? to_eeprom(d) : NULL;
+}
+
+static int eeprom_match(struct device *dev, const void *data)
+{
+	return !strcmp(dev_name(dev), (const char *)data);
+}
+
+static struct eeprom_device *eeprom_find(const char *name)
+{
+	struct device *d;
+
+	d = class_find_device(&eeprom_class, NULL, (void *)name, eeprom_match);
+
+	return d ? to_eeprom(d) : NULL;
+}
+
 /**
  * eeprom_register(): Register a eeprom device for given eeprom.
  * Also creates an binary entry in /sys/class/eeprom/name-id/eeprom
@@ -214,6 +253,238 @@ int eeprom_unregister(struct eeprom_device *eeprom)
 }
 EXPORT_SYMBOL_GPL(eeprom_unregister);
 
+static int eeprom_cell_sanity_check(struct eeprom_cell *cell)
+{
+	struct eeprom_device *eeprom = cell->eeprom;
+	int i;
+
+	/* byte aligned, no need to check for stride sanity */
+	if (eeprom->stride == 1)
+		return 0;
+
+	for (i = 0; i < cell->nblocks; i++) {
+		if (!IS_ALIGNED(cell->blocks[i].offset, eeprom->stride)) {
+			dev_err(&eeprom->dev,
+				"cell unaligned to eeprom stride %d\n",
+				eeprom->stride);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static struct eeprom_cell *__eeprom_cell_get(struct device_node *cell_np,
+					     const char *ename,
+					     struct eeprom_block *blocks,
+					     int nblocks)
+{
+	struct eeprom_cell *cell;
+	struct eeprom_device *eeprom;
+	struct property *prop;
+	const __be32 *vp;
+	u32 pv;
+	int i, rval;
+
+	mutex_lock(&eeprom_mutex);
+
+	eeprom = cell_np ? of_eeprom_find(cell_np->parent) : eeprom_find(ename);
+	if (!eeprom) {
+		mutex_unlock(&eeprom_mutex);
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+
+	eeprom->users++;
+	mutex_unlock(&eeprom_mutex);
+
+	if (!try_module_get(eeprom->owner)) {
+		dev_err(&eeprom->dev,
+			"could not increase module refcount for cell %s\n",
+			ename);
+		rval = -EINVAL;
+		goto err_mod;
+	}
+
+	if (cell_np)
+		nblocks = of_property_count_u32_elems(cell_np, "reg") / 2;
+
+	cell = kzalloc(sizeof(*cell) + nblocks * sizeof(*blocks), GFP_KERNEL);
+	if (!cell) {
+		rval = -ENOMEM;
+		goto err_mem;
+	}
+
+	cell->nblocks = nblocks;
+	cell->eeprom = eeprom;
+	cell->size = 0;
+	i = 0;
+
+	if (cell_np) {
+		of_property_for_each_u32(cell_np, "reg", prop, vp, pv) {
+			cell->blocks[i].offset = pv;
+			vp = of_prop_next_u32(prop, vp, &pv);
+			cell->blocks[i].count = pv;
+			cell->size += pv;
+			i++;
+		}
+	} else {
+		memcpy(cell->blocks, blocks, nblocks * sizeof(*blocks));
+		for (; i < nblocks; i++)
+			cell->size += blocks[i].count;
+	}
+
+	if (IS_ERR_VALUE(eeprom_cell_sanity_check(cell))) {
+		rval  = -EINVAL;
+		goto err_sanity;
+	}
+
+	return cell;
+
+err_sanity:
+	kfree(cell);
+
+err_mem:
+	module_put(eeprom->owner);
+
+err_mod:
+	mutex_lock(&eeprom_mutex);
+	eeprom->users--;
+	mutex_unlock(&eeprom_mutex);
+
+	return ERR_PTR(rval);
+
+}
+
+/**
+ * eeprom_cell_get(): Get eeprom cell of device form a given eeprom name
+ * and blocks.
+ *
+ * @ename: eeprom device name that needs to be looked-up.
+ * @blocks: eeprom blocks containing offset and length information.
+ * @nblocks: number of eeprom blocks.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct eeprom_cell.  The eeprom_cell will be freed by the
+ * eeprom_cell_put().
+ */
+struct eeprom_cell *eeprom_cell_get(const char *ename,
+				    struct eeprom_block *blocks, int nblocks)
+{
+	return __eeprom_cell_get(NULL, ename, blocks, nblocks);
+}
+EXPORT_SYMBOL_GPL(eeprom_cell_get);
+
+/**
+ * of_eeprom_cell_get(): Get eeprom cell of device form a given index
+ *
+ * @dev node: Device tree node that uses the eeprom cell
+ * @index: eeprom index in eeproms property.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct eeprom_cell.  The eeprom_cell will be freed by the
+ * eeprom_cell_put().
+ */
+struct eeprom_cell *of_eeprom_cell_get(struct device_node *np, const char *name)
+{
+	struct device_node *cell_np;
+
+	cell_np = of_parse_phandle(np, name, 0);
+	if (!cell_np)
+		return ERR_PTR(-EINVAL);
+
+	return __eeprom_cell_get(cell_np, NULL, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(of_eeprom_cell_get);
+
+/**
+ * eeprom_cell_put(): Release previously allocated eeprom cell.
+ *
+ * @cell: Previously allocated eeprom cell by eeprom_cell_get()
+ * or of_eeprom_cell_get().
+ */
+void eeprom_cell_put(struct eeprom_cell *cell)
+{
+	struct eeprom_device *eeprom = cell->eeprom;
+
+	mutex_lock(&eeprom_mutex);
+	eeprom->users--;
+	mutex_unlock(&eeprom_mutex);
+	module_put(eeprom->owner);
+	kfree(cell);
+}
+EXPORT_SYMBOL_GPL(eeprom_cell_put);
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
+char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len)
+{
+	struct eeprom_device *eeprom = cell->eeprom;
+	char *buf;
+	int rc, i, offset = 0;
+
+	if (!eeprom || !eeprom->regmap)
+		return ERR_PTR(-EINVAL);
+
+	buf = kzalloc(cell->size, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < cell->nblocks; i++) {
+		rc = regmap_raw_read(eeprom->regmap, cell->blocks[i].offset,
+				      buf + offset, cell->blocks[i].count);
+
+		if (IS_ERR_VALUE(rc)) {
+			kfree(buf);
+			return ERR_PTR(rc);
+		}
+		offset += cell->blocks[i].count;
+	}
+
+	*len = cell->size;
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(eeprom_cell_read);
+
+/**
+ * eeprom_cell_write(): Write to a given eeprom cell
+ *
+ * @cell: eeprom cell to be written.
+ * @buf: Buffer to be written.
+ * @len: length of buffer to be written to eeprom cell.
+ *
+ * The return value will be an length of bytes written or non zero on failure.
+ */
+int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len)
+{
+	struct eeprom_device *eeprom = cell->eeprom;
+	int i, rc, offset = 0;
+
+	if (!eeprom || !eeprom->regmap || len != cell->size)
+		return -EINVAL;
+
+	for (i = 0; i < cell->nblocks; i++) {
+		rc = regmap_raw_write(eeprom->regmap, cell->blocks[i].offset,
+				       buf + offset, cell->blocks[i].count);
+
+		if (IS_ERR_VALUE(rc))
+			return rc;
+
+		offset += cell->blocks[i].count;
+	}
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(eeprom_cell_write);
+
 static int eeprom_init(void)
 {
 	return class_register(&eeprom_class);
diff --git a/include/linux/eeprom-consumer.h b/include/linux/eeprom-consumer.h
new file mode 100644
index 0000000..effa417
--- /dev/null
+++ b/include/linux/eeprom-consumer.h
@@ -0,0 +1,61 @@
+/*
+ * EEPROM framework consumer.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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
+struct eeprom_block {
+	loff_t offset;
+	size_t count;
+};
+#if IS_ENABLED(CONFIG_EEPROM)
+struct eeprom_cell *eeprom_cell_get(const char *ename,
+				    struct eeprom_block *blocks, int nblocks);
+void eeprom_cell_put(struct eeprom_cell *cell);
+char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len);
+int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len);
+#else
+
+static inline struct eeprom_cell *eeprom_cell_get(const char *ename,
+				    struct eeprom_block *blocks, int nblocks)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void eeprom_cell_put(struct eeprom_cell *cell)
+{
+}
+
+static inline char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline int eeprom_cell_write(struct eeprom_cell *cell,
+				    const char *buf, ssize_t len)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_EEPROM */
+
+#if IS_ENABLED(CONFIG_EEPROM) && IS_ENABLED(CONFIG_OF)
+struct eeprom_cell *of_eeprom_cell_get(struct device_node *dev,
+				       const char *property);
+#else
+static inline struct eeprom_cell *of_eeprom_cell_get(struct device_node *np,
+						     const char *property)
+{
+	return ERR_PTR(-ENOSYS);
+}
+#endif
+#endif  /* ifndef _LINUX_EEPROM_CONSUMER_H */
-- 
1.9.1
