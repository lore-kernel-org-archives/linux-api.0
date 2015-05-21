From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v5 02/11] regmap: Introduce regmap_get_reg_stride.
Date: Thu, 21 May 2015 17:42:54 +0100
Message-ID: <1432226574-8733-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, pantelis.antoniou@konsulko.com, mporter@konsulko.com
List-Id: linux-api@vger.kernel.org

This patch introduces regmap_get_reg_stride() function which would
be used by the infrastructures like nvmem framework built on top of
regmap. Mostly this function would be used for sanity checks on inputs
within such infrastructure.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/base/regmap/regmap.c | 12 ++++++++++++
 include/linux/regmap.h       |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d6c8404..e5eef6f 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2625,6 +2625,18 @@ int regmap_get_max_register(struct regmap *map)
 }
 EXPORT_SYMBOL_GPL(regmap_get_max_register);
 
+/**
+ * regmap_get_reg_stride(): Report the register address stride
+ *
+ * Report the register address stride, mainly intended to for use by
+ * generic infrastructure built on top of regmap.
+ */
+int regmap_get_reg_stride(struct regmap *map)
+{
+	return map->reg_stride;
+}
+EXPORT_SYMBOL_GPL(regmap_get_reg_stride);
+
 int regmap_parse_val(struct regmap *map, const void *buf,
 			unsigned int *val)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 2d87ded..59c55ea 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -434,6 +434,7 @@ int regmap_update_bits_check_async(struct regmap *map, unsigned int reg,
 				   bool *change);
 int regmap_get_val_bytes(struct regmap *map);
 int regmap_get_max_register(struct regmap *map);
+int regmap_get_reg_stride(struct regmap *map);
 int regmap_async_complete(struct regmap *map);
 bool regmap_can_raw_write(struct regmap *map);
 
@@ -683,6 +684,12 @@ static inline int regmap_get_max_register(struct regmap *map)
 	return -EINVAL;
 }
 
+static inline int regmap_get_reg_stride(struct regmap *map)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline int regcache_sync(struct regmap *map)
 {
 	WARN_ONCE(1, "regmap API is disabled");
-- 
1.9.1
