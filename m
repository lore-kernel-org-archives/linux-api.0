From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v6 2/9] nvmem: Add a simple NVMEM framework for consumers
Date: Tue, 23 Jun 2015 00:08:38 +0100
Message-ID: <1435014518-26223-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435014459-26138-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds just consumers part of the framework just to enable easy
review.

Up until now, nvmem drivers were stored in drivers/misc, where they all
had to duplicate pretty much the same code to register a sysfs file,
allow in-kernel users to access the content of the devices they were
driving, etc.

This was also a problem as far as other in-kernel users were involved,
since the solutions used were pretty much different from on driver to
another, there was a rather big abstraction leak.

This introduction of this framework aims at solving this. It also
introduces DT representation for consumer devices to go get the data they
require (MAC Addresses, SoC/Revision ID, part numbers, and so on) from
the nvmems.

Having regmap interface to this framework would give much better
abstraction for nvmems on different buses.

Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
[Maxime Ripard: intial version of the framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/nvmem/core.c           | 415 +++++++++++++++++++++++++++++++++++++++++
 include/linux/nvmem-consumer.h |  75 ++++++++
 2 files changed, 490 insertions(+)
 create mode 100644 include/linux/nvmem-consumer.h

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 17a826d..78cd5c8 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -16,6 +16,7 @@
 
 #include <linux/device.h>
 #include <linux/nvmem-provider.h>
+#include <linux/nvmem-consumer.h>
 #include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
@@ -379,6 +380,420 @@ int nvmem_unregister(struct nvmem_device *nvmem)
 }
 EXPORT_SYMBOL_GPL(nvmem_unregister);
 
+static struct nvmem_device *__nvmem_device_get(struct device_node *np,
+					       struct nvmem_cell **cellp,
+					       const char *cell_id)
+{
+	struct nvmem_device *nvmem = NULL;
+
+	mutex_lock(&nvmem_mutex);
+
+	if (np) {
+		nvmem = of_nvmem_find(np);
+		if (!nvmem) {
+			mutex_unlock(&nvmem_mutex);
+			return ERR_PTR(-EPROBE_DEFER);
+		}
+	} else {
+		struct nvmem_cell *cell = nvmem_find_cell(cell_id);
+
+		if (cell) {
+			nvmem = cell->nvmem;
+			*cellp = cell;
+		}
+
+		if (!nvmem) {
+			mutex_unlock(&nvmem_mutex);
+			return ERR_PTR(-ENOENT);
+		}
+	}
+
+	nvmem->users++;
+	mutex_unlock(&nvmem_mutex);
+
+	if (!try_module_get(nvmem->owner)) {
+		dev_err(&nvmem->dev,
+			"could not increase module refcount for cell %s\n",
+			nvmem->name);
+
+		mutex_lock(&nvmem_mutex);
+		nvmem->users--;
+		mutex_unlock(&nvmem_mutex);
+
+		return ERR_PTR(-EINVAL);
+	}
+
+	return nvmem;
+}
+
+static void __nvmem_device_put(struct nvmem_device *nvmem)
+{
+	module_put(nvmem->owner);
+	mutex_lock(&nvmem_mutex);
+	nvmem->users--;
+	mutex_unlock(&nvmem_mutex);
+}
+
+static struct nvmem_cell *nvmem_cell_get_from_list(const char *cell_id)
+{
+	struct nvmem_cell *cell = NULL;
+	struct nvmem_device *nvmem;
+
+	nvmem = __nvmem_device_get(NULL, &cell, cell_id);
+	if (IS_ERR(nvmem))
+		return ERR_CAST(nvmem);
+
+
+	return cell;
+
+}
+/**
+ * of_nvmem_cell_get() - Get a nvmem cell from given device node and cell id
+ *
+ * @dev node: Device tree node that uses the nvmem cell
+ * @id: nvmem cell name from nvmem-cell-names property.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct nvmem_cell.  The nvmem_cell will be freed by the
+ * nvmem_cell_put().
+ */
+struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
+					    const char *name)
+{
+	struct device_node *cell_np, *nvmem_np;
+	struct nvmem_cell *cell;
+	struct nvmem_device *nvmem;
+	const __be32 *addr;
+	int rval, len, index;
+
+	index = of_property_match_string(np, "nvmem-cell-names", name);
+
+	cell_np = of_parse_phandle(np, "nvmem-cell", index);
+	if (!cell_np)
+		return ERR_PTR(-EINVAL);
+
+	nvmem_np = of_get_next_parent(cell_np);
+	if (!nvmem_np)
+		return ERR_PTR(-EINVAL);
+
+	nvmem = __nvmem_device_get(nvmem_np, NULL, NULL);
+	if (IS_ERR(nvmem))
+		return ERR_CAST(nvmem);
+
+	addr = of_get_property(cell_np, "reg", &len);
+	if (!addr || (len < 2 * sizeof(int))) {
+		dev_err(&nvmem->dev, "nvmem: invalid reg on %s\n",
+			cell_np->full_name);
+		rval  = -EINVAL;
+		goto err_mem;
+	}
+
+	cell = kzalloc(sizeof(*cell), GFP_KERNEL);
+	if (!cell) {
+		rval = -ENOMEM;
+		goto err_mem;
+	}
+
+	cell->nvmem = nvmem;
+	cell->offset = be32_to_cpup(addr++);
+	cell->bytes = be32_to_cpup(addr);
+	cell->name = cell_np->name;
+
+	of_property_read_u32(cell_np, "bit-offset", &cell->bit_offset);
+	of_property_read_u32(cell_np, "nbits", &cell->nbits);
+
+	if (cell->nbits)
+		cell->bytes = DIV_ROUND_UP(cell->nbits + cell->bit_offset,
+					   BITS_PER_BYTE);
+
+	if (!IS_ALIGNED(cell->offset, nvmem->stride)) {
+			dev_err(&nvmem->dev,
+				"cell %s unaligned to nvmem stride %d\n",
+				cell->name, nvmem->stride);
+		rval  = -EINVAL;
+		goto err_sanity;
+	}
+
+	nvmem_cell_add(cell);
+
+	return cell;
+
+err_sanity:
+	kfree(cell);
+
+err_mem:
+	__nvmem_device_put(nvmem);
+
+	return ERR_PTR(rval);
+
+}
+EXPORT_SYMBOL_GPL(of_nvmem_cell_get);
+
+/**
+ * nvmem_cell_get() - Get nvmem cell of device form a given cell name
+ *
+ * @dev node: Device tree node that uses the nvmem cell
+ * @id: nvmem cell name to get.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct nvmem_cell.  The nvmem_cell will be freed by the
+ * nvmem_cell_put().
+ */
+struct nvmem_cell *nvmem_cell_get(struct device *dev, const char *cell_id)
+{
+	struct nvmem_cell *cell;
+
+	if (dev->of_node) { /* try dt first */
+		cell = of_nvmem_cell_get(dev->of_node, cell_id);
+		if (!IS_ERR(cell) || PTR_ERR(cell) == -EPROBE_DEFER)
+			return cell;
+	}
+
+	return nvmem_cell_get_from_list(cell_id);
+
+}
+EXPORT_SYMBOL_GPL(nvmem_cell_get);
+
+static void devm_nvmem_cell_release(struct device *dev, void *res)
+{
+	nvmem_cell_put(*(struct nvmem_cell **)res);
+}
+
+/**
+ * devm_nvmem_cell_get() - Get nvmem cell of device form a given id
+ *
+ * @dev node: Device tree node that uses the nvmem cell
+ * @id: nvmem id in nvmem-names property.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct nvmem_cell.  The nvmem_cell will be freed by the
+ * automatically once the device is freed.
+ */
+struct nvmem_cell *devm_nvmem_cell_get(struct device *dev, const char *id)
+{
+	struct nvmem_cell **ptr, *cell;
+
+	ptr = devres_alloc(devm_nvmem_cell_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	cell = nvmem_cell_get(dev, id);
+	if (!IS_ERR(cell)) {
+		*ptr = cell;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return cell;
+}
+EXPORT_SYMBOL_GPL(devm_nvmem_cell_get);
+
+static int devm_nvmem_cell_match(struct device *dev, void *res, void *data)
+{
+	struct nvmem_cell **c = res;
+
+	if (!c || !*c) {
+		WARN_ON(!c || !*c);
+		return 0;
+	}
+	return *c == data;
+}
+
+/**
+ * devm_nvmem_cell_put() - Release previously allocated nvmem cell
+ * from devm_nvmem_cell_get.
+ *
+ * @cell: Previously allocated nvmem cell by devm_nvmem_cell_get()
+ */
+void devm_nvmem_cell_put(struct device *dev, struct nvmem_cell *cell)
+{
+	int ret;
+
+	ret = devres_release(dev, devm_nvmem_cell_release, devm_nvmem_cell_match, cell);
+
+	WARN_ON(ret);
+}
+EXPORT_SYMBOL(devm_nvmem_cell_put);
+
+/**
+ * nvmem_cell_put() - Release previously allocated nvmem cell.
+ *
+ * @cell: Previously allocated nvmem cell by nvmem_cell_get()
+ */
+void nvmem_cell_put(struct nvmem_cell *cell)
+{
+	struct nvmem_device *nvmem = cell->nvmem;
+
+	__nvmem_device_put(nvmem);
+	nvmem_cell_drop(cell);
+}
+EXPORT_SYMBOL_GPL(nvmem_cell_put);
+
+static inline void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell,
+						    void *buf)
+{
+	u8 *p, *b;
+	int i, bit_offset = cell->bit_offset;
+
+	p = b = buf;
+	if (bit_offset) {
+		/* First shift */
+		*b++ >>= bit_offset;
+
+		/* setup rest of the bytes if any */
+		for (i = 1; i < cell->bytes; i++) {
+			/* Get bits from next byte and shift them towards msb */
+			*p |= *b << (BITS_PER_BYTE - bit_offset);
+
+			p = b;
+			*b++ >>= bit_offset;
+		}
+
+		/* result fits in less bytes */
+		if (cell->bytes != DIV_ROUND_UP(cell->nbits, BITS_PER_BYTE))
+			*p-- = 0;
+	}
+	/* clear msb bits if any leftover in the last byte */
+	*p &= GENMASK((cell->nbits%BITS_PER_BYTE) - 1, 0);
+}
+
+static int __nvmem_cell_read(struct nvmem_device *nvmem,
+		      struct nvmem_cell *cell,
+		      void *buf, ssize_t *len)
+{
+	int rc;
+
+	rc = regmap_raw_read(nvmem->regmap, cell->offset, buf, cell->bytes);
+
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	/* shift bits in-place */
+	if (cell->bit_offset || cell->bit_offset)
+		nvmem_shift_read_buffer_in_place(cell, buf);
+
+	*len = cell->bytes;
+
+	return *len;
+}
+/**
+ * nvmem_cell_read() - Read a given nvmem cell
+ *
+ * @cell: nvmem cell to be read.
+ * @len: pointer to length of cell which will be populated on successful read.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a char * bufffer.  The buffer should be freed by the consumer with a
+ * kfree().
+ */
+void *nvmem_cell_read(struct nvmem_cell *cell, ssize_t *len)
+{
+	struct nvmem_device *nvmem = cell->nvmem;
+	u8 *buf;
+	int rc;
+
+	if (!nvmem || !nvmem->regmap)
+		return ERR_PTR(-EINVAL);
+
+	buf = kzalloc(cell->bytes, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	rc = __nvmem_cell_read(nvmem, cell, buf, len);
+	if (IS_ERR_VALUE(rc)) {
+		kfree(buf);
+		return ERR_PTR(rc);
+	}
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(nvmem_cell_read);
+
+static inline void *nvmem_cell_prepare_write_buffer(struct nvmem_cell *cell,
+						    u8 *_buf, int len)
+{
+	struct nvmem_device *nvmem = cell->nvmem;
+	int i, rc, nbits, bit_offset = cell->bit_offset;
+	u8 v, *p, *buf, *b, pbyte, pbits;
+
+	nbits = cell->nbits;
+	buf = kzalloc(cell->bytes, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(buf, _buf, len);
+	p = b = buf;
+
+	if (bit_offset) {
+		pbyte = *b;
+		*b <<= bit_offset;
+
+		/* setup the first byte with lsb bits from nvmem */
+		rc = regmap_raw_read(nvmem->regmap, cell->offset, &v, 1);
+		*b++ |= GENMASK(bit_offset - 1, 0) & v;
+
+		/* setup rest of the byte if any */
+		for (i = 1; i < cell->bytes; i++) {
+			/* Get last byte bits and shift them towards lsb */
+			pbits = pbyte >> (BITS_PER_BYTE - 1 - bit_offset);
+			pbyte = *b;
+			p = b;
+			*b <<= bit_offset;
+			*b++ |= pbits;
+		}
+	}
+
+	/* if it's not end on byte boundary */
+	if ((nbits + bit_offset) % BITS_PER_BYTE) {
+		/* setup the last byte with msb bits from nvmem */
+		rc = regmap_raw_read(nvmem->regmap,
+				    cell->offset + cell->bytes - 1, &v, 1);
+		*p |= GENMASK(7, (nbits + bit_offset) % BITS_PER_BYTE) & v;
+
+	}
+
+	return buf;
+}
+
+/**
+ * nvmem_cell_write() - Write to a given nvmem cell
+ *
+ * @cell: nvmem cell to be written.
+ * @buf: Buffer to be written.
+ * @len: length of buffer to be written to nvmem cell.
+ *
+ * The return value will be an length of bytes written or non zero on failure.
+ */
+int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len)
+{
+	struct nvmem_device *nvmem = cell->nvmem;
+	int rc;
+	void *wbuf = buf;
+
+	if (!nvmem || !nvmem->regmap || nvmem->read_only ||
+	    (cell->bit_offset == 0 && len != cell->bytes))
+		return -EINVAL;
+
+	if (cell->bit_offset || cell->nbits) {
+		wbuf = nvmem_cell_prepare_write_buffer(cell, buf, len);
+		if (IS_ERR(wbuf))
+			return PTR_ERR(wbuf);
+	}
+
+	rc = regmap_raw_write(nvmem->regmap, cell->offset, wbuf, cell->bytes);
+
+	/* free the tmp buffer */
+	if (cell->bit_offset)
+		kfree(wbuf);
+
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(nvmem_cell_write);
+
 static int __init nvmem_init(void)
 {
 	return class_register(&nvmem_class);
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
new file mode 100644
index 0000000..123af62
--- /dev/null
+++ b/include/linux/nvmem-consumer.h
@@ -0,0 +1,75 @@
+/*
+ * nvmem framework consumer.
+ *
+ * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _LINUX_NVMEM_CONSUMER_H
+#define _LINUX_NVMEM_CONSUMER_H
+
+struct device;
+/* consumer cookie */
+struct nvmem_cell;
+
+#if IS_ENABLED(CONFIG_NVMEM)
+
+/* Cell based interface */
+struct nvmem_cell *nvmem_cell_get(struct device *dev, const char *name);
+struct nvmem_cell *devm_nvmem_cell_get(struct device *dev, const char *name);
+void nvmem_cell_put(struct nvmem_cell *cell);
+void devm_nvmem_cell_put(struct device *dev, struct nvmem_cell *cell);
+void *nvmem_cell_read(struct nvmem_cell *cell, ssize_t *len);
+int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len);
+
+#else
+
+static inline struct nvmem_cell *nvmem_cell_get(struct device *dev,
+						const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct nvmem_cell *devm_nvmem_cell_get(struct device *dev,
+				       const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void devm_nvmem_cell_put(struct device *dev,
+				       struct nvmem_cell *cell)
+{
+
+}
+static inline void nvmem_cell_put(struct nvmem_cell *cell)
+{
+}
+
+static inline char *nvmem_cell_read(struct nvmem_cell *cell, ssize_t *len)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline int nvmem_cell_write(struct nvmem_cell *cell,
+				    const char *buf, ssize_t len)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_NVMEM */
+
+#if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)
+struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
+				     const char *name);
+#else
+static inline struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
+				     const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+#endif /* CONFIG_NVMEM && CONFIG_OF */
+
+#endif  /* ifndef _LINUX_NVMEM_CONSUMER_H */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
