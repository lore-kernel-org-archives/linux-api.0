From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 1/9] regmap: Introduce regmap_get_max_register.
Date: Tue, 24 Mar 2015 22:29:39 +0000
Message-ID: <1427236179-18580-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch introduces regmap_get_max_register() function which would be
used by the infrastructures like eeprom framework built on top of
regmap.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/base/regmap/regmap.c | 12 ++++++++++++
 include/linux/regmap.h       |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d2f8a81..6fd234b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -2616,6 +2616,18 @@ int regmap_get_val_bytes(struct regmap *map)
 }
 EXPORT_SYMBOL_GPL(regmap_get_val_bytes);
 
+/*
+ * regmap_get_max_register(): Report the max register value
+ *
+ * Report the max register value, mainly intended to for use by
+ * generic infrastructure built on top of regmap.
+ */
+int regmap_get_max_register(struct regmap *map)
+{
+	return map->max_register ? : -EINVAL;
+}
+EXPORT_SYMBOL_GPL(regmap_get_max_register);
+
 int regmap_parse_val(struct regmap *map, const void *buf,
 			unsigned int *val)
 {
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4419b99..c46dbf3 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -433,6 +433,7 @@ int regmap_update_bits_check_async(struct regmap *map, unsigned int reg,
 				   unsigned int mask, unsigned int val,
 				   bool *change);
 int regmap_get_val_bytes(struct regmap *map);
+int regmap_get_max_register(struct regmap *map);
 int regmap_async_complete(struct regmap *map);
 bool regmap_can_raw_write(struct regmap *map);
 
@@ -676,6 +677,12 @@ static inline int regmap_get_val_bytes(struct regmap *map)
 	return -EINVAL;
 }
 
+static inline int regmap_get_max_register(struct regmap *map)
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
