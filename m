From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v7 3/9] nvmem: Add nvmem_device based consumer apis.
Date: Fri, 10 Jul 2015 10:45:05 +0100
Message-ID: <1436521505-10779-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stefan.wahren@i2se.com, devicetree@vger.kernel.org, arnd@arndb.de, linux-api@vger.kernel.org, s.hauer@pengutronix.de, sboyd@codeaurora.org, linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, pantelis.antoniou@konsulko.com, Mark Brown <broonie@kernel.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Kumar Gala <galak@codeaurora.org>, mporter@konsulko.com, linux-arm-msm@vger.kernel.org, wxt@rock-chips.com
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
 drivers/nvmem/core.c           | 259 +++++++++++++++++++++++++++++++++++++++++
 include/linux/nvmem-consumer.h |  79 +++++++++++++
 include/linux/nvmem-provider.h |  10 +-
 3 files changed, 340 insertions(+), 8 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index f429ad4..92df617 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -417,6 +417,149 @@ static void __nvmem_device_put(struct nvmem_device *nvmem)
 	mutex_unlock(&nvmem_mutex);
 }
 
+static int nvmem_match(struct device *dev, void *data)
+{
+	return !strcmp(dev_name(dev), data);
+}
+
+static struct nvmem_device *nvmem_find(const char *name)
+{
+	struct device *d;
+
+	d = bus_find_device(&nvmem_bus_type, NULL, (void *)name, nvmem_match);
+
+	return d ? to_nvmem_device(d) : NULL;
+}
+
+#if IS_ENABLED(CONFIG_NVMEM) && IS_ENABLED(CONFIG_OF)
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
+#endif
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
+
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
@@ -781,6 +924,122 @@ int nvmem_cell_write(struct nvmem_cell *cell, void *buf, size_t len)
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
+ssize_t nvmem_device_cell_read(struct nvmem_device *nvmem,
+			   struct nvmem_cell_info *info, void *buf)
+{
+	struct nvmem_cell cell;
+	int rc;
+	ssize_t len;
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
 	return bus_register(&nvmem_bus_type);
diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
index 90bf4c3..8aaaedf 100644
--- a/include/linux/nvmem-consumer.h
+++ b/include/linux/nvmem-consumer.h
@@ -16,6 +16,15 @@ struct device;
 struct device_node;
 /* consumer cookie */
 struct nvmem_cell;
+struct nvmem_device;
+
+struct nvmem_cell_info {
+	const char		*name;
+	unsigned int		offset;
+	unsigned int		bytes;
+	unsigned int		bit_offset;
+	unsigned int		nbits;
+};
 
 #if IS_ENABLED(CONFIG_NVMEM)
 
@@ -27,6 +36,21 @@ void devm_nvmem_cell_put(struct device *dev, struct nvmem_cell *cell);
 void *nvmem_cell_read(struct nvmem_cell *cell, size_t *len);
 int nvmem_cell_write(struct nvmem_cell *cell, void *buf, size_t len);
 
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
+ssize_t nvmem_device_cell_read(struct nvmem_device *nvmem,
+			   struct nvmem_cell_info *info, void *buf);
+int nvmem_device_cell_write(struct nvmem_device *nvmem,
+			    struct nvmem_cell_info *info, void *buf);
+
 #else
 
 static inline struct nvmem_cell *nvmem_cell_get(struct device *dev,
@@ -60,17 +84,72 @@ static inline int nvmem_cell_write(struct nvmem_cell *cell,
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
+static inline ssize_t nvmem_device_cell_read(struct nvmem_device *nvmem,
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
