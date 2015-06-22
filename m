From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v6 3/9] nvmem: Add nvmem_device based consumer apis.
Date: Tue, 23 Jun 2015 00:08:47 +0100
Message-ID: <1435014527-26265-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds read/write apis which are based on nvmem_device. It is
common that the drivers like omap cape manager or qcom cpr driver to
access bytes directly at particular offset in the eeprom and not from
nvmem cell info in DT. These driver would need to get access to the nvmem
directly, which is what these new APIS provide.

These wrapper apis would help such users to avoid code duplication in
there drivers and also avoid them reading a big eeprom blob and parsing
it internally in there driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/nvmem/core.c           | 256 +++++++++++++++++++++++++++++++++++++++++
 include/linux/nvmem-consumer.h |  79 +++++++++++++
 include/linux/nvmem-provider.h |  10 +-
 3 files changed, 337 insertions(+), 8 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 78cd5c8..82b564c 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -434,6 +434,147 @@ static void __nvmem_device_put(struct nvmem_device *nvmem)
 	mutex_unlock(&nvmem_mutex);
 }
 
+static int nvmem_match(struct device *dev, const void *data)
+{
+	return !strcmp(dev_name(dev), data);
+}
+
+static struct nvmem_device *nvmem_find(const char *name)
+{
+	struct device *d;
+
+	d = class_find_device(&nvmem_class, NULL, name, nvmem_match);
+
+	return d ? to_nvmem_device(d) : NULL;
+}
+
+/**
+ * of_nvmem_device_get() - Get nvmem device from a given id
+ *
+ * @dev node: Device tree node that uses the nvmem device
+ * @id: nvmem name from nvmem-names property.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct nvmem_device.
+ */
+struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
+{
+
+	struct device_node *nvmem_np;
+	int index;
+
+	index = of_property_match_string(np, "nvmem-names", id);
+
+	nvmem_np = of_parse_phandle(np, "nvmem", index);
+	if (!nvmem_np)
+		return ERR_PTR(-EINVAL);
+
+	return __nvmem_device_get(nvmem_np, NULL, NULL);
+
+}
+EXPORT_SYMBOL_GPL(of_nvmem_device_get);
+
+
+/**
+ * nvmem_device_get() - Get nvmem device from a given id
+ *
+ * @dev : Device that uses the nvmem device
+ * @id: nvmem name from nvmem-names property.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct nvmem_device.
+ */
+struct nvmem_device *nvmem_device_get(struct device *dev, const char *dev_name)
+{
+	if (dev->of_node) { /* try dt first */
+		struct nvmem_device *nvmem;
+
+		nvmem = of_nvmem_device_get(dev->of_node, dev_name);
+
+		if (!IS_ERR(nvmem) || PTR_ERR(nvmem) == -EPROBE_DEFER)
+			return nvmem;
+
+	}
+
+	return nvmem_find(dev_name);
+
+}
+EXPORT_SYMBOL_GPL(nvmem_device_get);
+
+static int devm_nvmem_device_match(struct device *dev, void *res, void *data)
+{
+	struct nvmem_device **nvmem = res;
+	if (!nvmem || !*nvmem) {
+		WARN_ON(!nvmem || !*nvmem);
+		return 0;
+	}
+	return *nvmem == data;
+}
+
+static void devm_nvmem_device_release(struct device *dev, void *res)
+{
+	nvmem_device_put(*(struct nvmem_device **)res);
+}
+
+/**
+ * devm_nvmem_device_put() - put alredy got nvmem device
+ *
+ * @nvmem: pointer to nvmem device allocated by devm_nvmem_cell_get(),
+ * that needs to be released.
+ */
+void devm_nvmem_device_put(struct device *dev, struct nvmem_device *nvmem)
+{
+	int ret;
+
+	ret = devres_release(dev, devm_nvmem_device_release,
+			     devm_nvmem_device_match, nvmem);
+
+	WARN_ON(ret);
+
+}
+EXPORT_SYMBOL_GPL(devm_nvmem_device_put);
+
+/**
+ * nvmem_device_put() - put alredy got nvmem device
+ *
+ * @nvmem: pointer to nvmem device that needs to be released.
+ */
+void nvmem_device_put(struct nvmem_device *nvmem)
+{
+	__nvmem_device_put(nvmem);
+}
+EXPORT_SYMBOL_GPL(nvmem_device_put);
+
+/**
+ * devm_nvmem_device_get() - Get nvmem cell of device form a given id
+ *
+ * @dev node: Device tree node that uses the nvmem cell
+ * @id: nvmem name in nvmems property.
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct nvmem_cell.  The nvmem_cell will be freed by the
+ * automatically once the device is freed.
+ */
+struct nvmem_device *devm_nvmem_device_get(struct device *dev, const char *id)
+{
+	struct nvmem_device **ptr, *nvmem;
+
+	ptr = devres_alloc(devm_nvmem_device_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	nvmem = nvmem_device_get(dev, id);
+	if (!IS_ERR(nvmem)) {
+		*ptr = nvmem;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return nvmem;
+}
+EXPORT_SYMBOL_GPL(devm_nvmem_device_get);
+
 static struct nvmem_cell *nvmem_cell_get_from_list(const char *cell_id)
 {
 	struct nvmem_cell *cell = NULL;
@@ -794,6 +935,121 @@ int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len)
 }
 EXPORT_SYMBOL_GPL(nvmem_cell_write);
 
+/**
+ * nvmem_device_cell_read() - Read a given nvmem device and cell
+ *
+ * @nvmem: nvmem device to read from.
+ * @info: nvmem cell info to be read.
+ * @buf: buffer pointer which will be populated on successful read.
+ *
+ * The return value would be length of successful bytes read on success
+ * and error code in error cases.
+ */
+int nvmem_device_cell_read(struct nvmem_device *nvmem,
+			   struct nvmem_cell_info *info, void *buf)
+{
+	struct nvmem_cell cell;
+	int rc, len;
+
+	if (!nvmem || !nvmem->regmap)
+		return -EINVAL;
+
+	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	rc = __nvmem_cell_read(nvmem, &cell, buf, &len);
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(nvmem_device_cell_read);
+
+/**
+ * nvmem_device_cell_write() - Write cell to a given nvmem device
+ *
+ * @nvmem: nvmem device to be written to.
+ * @info: nvmem cell info to be written
+ * @buf: buffer to be written to cell.
+ *
+ * The return value will be an length of bytes written or non zero on failure.
+ * */
+int nvmem_device_cell_write(struct nvmem_device *nvmem,
+			    struct nvmem_cell_info *info, void *buf)
+{
+	struct nvmem_cell cell;
+	int rc;
+
+	if (!nvmem || !nvmem->regmap)
+		return -EINVAL;
+
+	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	return nvmem_cell_write(&cell, buf, cell.bytes);
+}
+EXPORT_SYMBOL_GPL(nvmem_device_cell_write);
+
+/**
+ * nvmem_device_read() - Read from a given nvmem device
+ *
+ * @nvmem: nvmem device to read from.
+ * @offset: offset in nvmem device.
+ * @bytes: number of bytes to read.
+ * @buf: buffer pointer which will be populated on successful read.
+ *
+ * The return value would be length of successful bytes read on success
+ * and error code in error cases.
+ */
+int nvmem_device_read(struct nvmem_device *nvmem,
+		      unsigned int offset,
+		      size_t bytes, void *buf)
+{
+	int rc;
+
+	if (!nvmem || !nvmem->regmap)
+		return -EINVAL;
+
+	rc = regmap_raw_read(nvmem->regmap, offset, buf, bytes);
+
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+	return bytes;
+}
+EXPORT_SYMBOL_GPL(nvmem_device_read);
+
+/**
+ * nvmem_device_write() - Write cell to a given nvmem device
+ *
+ * @nvmem: nvmem device to be written to.
+ * @offset: offset in nvmem device.
+ * @bytes: number of bytes to write.
+ * @buf: buffer to be written.
+ *
+ * The return value will be an length of bytes written or non zero on failure.
+ * */
+int nvmem_device_write(struct nvmem_device *nvmem,
+		       unsigned int offset,
+		       size_t bytes, void *buf)
+{
+	int rc;
+
+	if (!nvmem || !nvmem->regmap)
+		return -EINVAL;
+
+	rc = regmap_raw_write(nvmem->regmap, offset, buf, bytes);
+
+	if (IS_ERR_VALUE(rc))
+		return rc;
+
+
+	return bytes;
+}
+EXPORT_SYMBOL_GPL(nvmem_device_write);
+
 static int __init nvmem_init(void)
 {
 	return class_register(&nvmem_class);
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 123af62..f9acc43 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -15,6 +15,15 @@
 struct device;
 /* consumer cookie */
 struct nvmem_cell;
+struct nvmem_device;
+
+struct nvmem_cell_info {
+	const char		*name;
+	int			offset;
+	int			bytes;
+	int			bit_offset;
+	int			nbits;
+};
 
 #if IS_ENABLED(CONFIG_NVMEM)
 
@@ -26,6 +35,21 @@ void devm_nvmem_cell_put(struct device *dev, struct nvmem_cell *cell);
 void *nvmem_cell_read(struct nvmem_cell *cell, ssize_t *len);
 int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len);
 
+/* direct nvmem device read/write interface */
+struct nvmem_device *nvmem_device_get(struct device *dev, const char *name);
+struct nvmem_device *devm_nvmem_device_get(struct device *dev,
+					   const char *name);
+void nvmem_device_put(struct nvmem_device *nvmem);
+void devm_nvmem_device_put(struct device *dev, struct nvmem_device *nvmem);
+int nvmem_device_read(struct nvmem_device *nvmem, unsigned int offset,
+		      size_t bytes, void *buf);
+int nvmem_device_write(struct nvmem_device *nvmem, unsigned int offset,
+		       size_t bytes, void *buf);
+int nvmem_device_cell_read(struct nvmem_device *nvmem,
+			   struct nvmem_cell_info *info, void *buf);
+int nvmem_device_cell_write(struct nvmem_device *nvmem,
+			    struct nvmem_cell_info *info, void *buf);
+
 #else
 
 static inline struct nvmem_cell *nvmem_cell_get(struct device *dev,
@@ -59,17 +83,72 @@ static inline int nvmem_cell_write(struct nvmem_cell *cell,
 {
 	return -ENOSYS;
 }
+
+static inline struct nvmem_device *nvmem_device_get(struct device *dev,
+						    const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct nvmem_device *devm_nvmem_device_get(struct device *dev,
+							 const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void nvmem_device_put(struct nvmem_device *nvmem)
+{
+}
+
+static inline void devm_nvmem_device_put(struct device *dev,
+					 struct nvmem_device *nvmem)
+{
+}
+
+static inline int nvmem_device_cell_read(struct nvmem_device *nvmem,
+					 struct nvmem_cell_info *info,
+					 void *buf)
+{
+	return -ENOSYS;
+}
+
+static inline int nvmem_device_cell_write(struct nvmem_device *nvmem,
+					  struct nvmem_cell_info *info,
+					  void *buf)
+{
+	return -ENOSYS;
+}
+
+static inline int nvmem_device_read(struct nvmem_device *nvmem,
+				    unsigned int offset, size_t bytes, void *buf)
+{
+	return -ENOSYS;
+}
+
+static inline int nvmem_device_write(struct nvmem_device *nvmem,
+				     unsigned int offset, size_t bytes, void *buf)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_NVMEM */
 
 #if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)
 struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
 				     const char *name);
+struct nvmem_device *of_nvmem_device_get(struct device_node *np,
+					 const char *name);
 #else
 static inline struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
 				     const char *name)
 {
 	return ERR_PTR(-ENOSYS);
 }
+
+static inline struct nvmem_device *of_nvmem_device_get(struct device_node *np,
+						       const char *name)
+{
+	return ERR_PTR(-ENOSYS);
+}
 #endif /* CONFIG_NVMEM && CONFIG_OF */
 
 #endif  /* ifndef _LINUX_NVMEM_CONSUMER_H */
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index f589d3b..74eed42 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -12,15 +12,9 @@
 #ifndef _LINUX_NVMEM_PROVIDER_H
 #define _LINUX_NVMEM_PROVIDER_H
 
-struct nvmem_device;
+#include <linux/nvmem-consumer.h>
 
-struct nvmem_cell_info {
-	const char		*name;
-	int			offset;
-	int			bytes;
-	int			bit_offset;
-	int			nbits;
-};
+struct nvmem_device;
 
 struct nvmem_config {
 	struct device		*dev;
-- 
1.9.1
