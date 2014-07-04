From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 2/6] regulator/mfd: max14577: Export symbols for calculating
 charger current
Date: Fri, 04 Jul 2014 12:12:41 +0200
Message-ID: <1404468765-10818-3-git-send-email-k.kozlowski@samsung.com>
References: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1404468765-10818-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch prepares for changing the max14577 charger driver to allow
configuring battery-dependent settings from DTS.

The patch moves from regulator driver to MFD core driver and exports:
 - function for calculating register value for charger's current;
 - table of limits for chargers (MAX14577, MAX77836).

Previously they were used only by the max14577 regulator driver. In next
patch the charger driver will use them as well. Exporting them will
reduce unnecessary code duplication.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Acked-by: Mark Brown <broonie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/mfd/max14577.c               | 95 ++++++++++++++++++++++++++++++++++++
 drivers/regulator/max14577.c         | 80 ++----------------------------
 include/linux/mfd/max14577-private.h | 22 ++++-----
 include/linux/mfd/max14577.h         | 23 +++++++++
 4 files changed, 133 insertions(+), 87 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 4a5e885383f8..e6f25aa0ded8 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -26,6 +26,87 @@
 #include <linux/mfd/max14577.h>
 #include <linux/mfd/max14577-private.h>
 
+/*
+ * Table of valid charger currents for different Maxim chipsets.
+ * It is placed here because it is used by both charger and regulator driver.
+ */
+const struct maxim_charger_current maxim_charger_currents[] = {
+	[MAXIM_DEVICE_TYPE_UNKNOWN] = { 0, 0, 0, 0 },
+	[MAXIM_DEVICE_TYPE_MAX14577] = {
+		.min		= MAX14577_CHARGER_CURRENT_LIMIT_MIN,
+		.high_start	= MAX14577_CHARGER_CURRENT_LIMIT_HIGH_START,
+		.high_step	= MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP,
+		.max		= MAX14577_CHARGER_CURRENT_LIMIT_MAX,
+	},
+	[MAXIM_DEVICE_TYPE_MAX77836] = {
+		.min		= MAX77836_CHARGER_CURRENT_LIMIT_MIN,
+		.high_start	= MAX77836_CHARGER_CURRENT_LIMIT_HIGH_START,
+		.high_step	= MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP,
+		.max		= MAX77836_CHARGER_CURRENT_LIMIT_MAX,
+	},
+};
+EXPORT_SYMBOL_GPL(maxim_charger_currents);
+
+/*
+ * maxim_charger_calc_reg_current - Calculate register value for current
+ * @limits:	constraints for charger, matching the MBCICHWRC register
+ * @min_ua:	minimal requested current, micro Amps
+ * @max_ua:	maximum requested current, micro Amps
+ * @dst:	destination to store calculated register value
+ *
+ * Calculates the value of MBCICHWRC (Fast Battery Charge Current) register
+ * for given current and stores it under pointed 'dst'. The stored value
+ * combines low bit (MBCICHWRCL) and high bits (MBCICHWRCH). It is also
+ * properly shifted.
+ *
+ * The calculated register value matches the current which:
+ *  - is always between <limits.min, limits.max>;
+ *  - is always less or equal to max_ua;
+ *  - is the highest possible value;
+ *  - may be lower than min_ua.
+ *
+ * On success returns 0. On error returns -EINVAL (requested min/max current
+ * is outside of given charger limits) and 'dst' is not set.
+ */
+int maxim_charger_calc_reg_current(const struct maxim_charger_current *limits,
+		unsigned int min_ua, unsigned int max_ua, u8 *dst)
+{
+	unsigned int current_bits = 0xf;
+
+	if (min_ua > max_ua)
+		return -EINVAL;
+
+	if (min_ua > limits->max || max_ua < limits->min)
+		return -EINVAL;
+
+	if (max_ua < limits->high_start) {
+		/*
+		 * Less than high_start, so set the minimal current
+		 * (turn Low Bit off, 0 as high bits).
+		 */
+		*dst = 0x0;
+		return 0;
+	}
+
+	/* max_ua is in range: <high_start, infinite>, cut it to limits.max */
+	max_ua = min(limits->max, max_ua);
+	max_ua -= limits->high_start;
+	/*
+	 * There is no risk of overflow 'max_ua' here because:
+	 *  - max_ua >= limits.high_start
+	 *  - BUILD_BUG checks that 'limits' are: max >= high_start + high_step
+	 */
+	current_bits = max_ua / limits->high_step;
+
+	/* Turn Low Bit on (use range <limits.high_start, limits.max>) ... */
+	*dst = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
+	/* and set proper High Bits */
+	*dst |= current_bits << CHGCTRL4_MBCICHWRCH_SHIFT;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(maxim_charger_calc_reg_current);
+
 static const struct mfd_cell max14577_devs[] = {
 	{
 		.name = "max14577-muic",
@@ -463,6 +544,20 @@ static int __init max14577_i2c_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(max14577_i2c_id) != MAXIM_DEVICE_TYPE_NUM);
 	BUILD_BUG_ON(ARRAY_SIZE(max14577_dt_match) != MAXIM_DEVICE_TYPE_NUM);
 
+	/* Valid charger current values must be provided for each chipset */
+	BUILD_BUG_ON(ARRAY_SIZE(maxim_charger_currents) != MAXIM_DEVICE_TYPE_NUM);
+
+	/* Check for valid values for charger */
+	BUILD_BUG_ON(MAX14577_CHARGER_CURRENT_LIMIT_HIGH_START +
+			MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP * 0xf !=
+			MAX14577_CHARGER_CURRENT_LIMIT_MAX);
+	BUILD_BUG_ON(MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP == 0);
+
+	BUILD_BUG_ON(MAX77836_CHARGER_CURRENT_LIMIT_HIGH_START +
+			MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP * 0xf !=
+			MAX77836_CHARGER_CURRENT_LIMIT_MAX);
+	BUILD_BUG_ON(MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP == 0);
+
 	return i2c_add_driver(&max14577_i2c_driver);
 }
 subsys_initcall(max14577_i2c_init);
diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 5d9c605cf534..0ff5a20ac958 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -22,42 +22,6 @@
 #include <linux/mfd/max14577-private.h>
 #include <linux/regulator/of_regulator.h>
 
-/*
- * Valid limits of current for max14577 and max77836 chargers.
- * They must correspond to MBCICHWRCL and MBCICHWRCH fields in CHGCTRL4
- * register for given chipset.
- */
-struct maxim_charger_current {
-	/* Minimal current, set in CHGCTRL4/MBCICHWRCL, uA */
-	unsigned int min;
-	/*
-	 * Minimal current when high setting is active,
-	 * set in CHGCTRL4/MBCICHWRCH, uA
-	 */
-	unsigned int high_start;
-	/* Value of one step in high setting, uA */
-	unsigned int high_step;
-	/* Maximum current of high setting, uA */
-	unsigned int max;
-};
-
-/* Table of valid charger currents for different Maxim chipsets */
-static const struct maxim_charger_current maxim_charger_currents[] = {
-	[MAXIM_DEVICE_TYPE_UNKNOWN] = { 0, 0, 0, 0 },
-	[MAXIM_DEVICE_TYPE_MAX14577] = {
-		.min		= MAX14577_REGULATOR_CURRENT_LIMIT_MIN,
-		.high_start	= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START,
-		.high_step	= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP,
-		.max		= MAX14577_REGULATOR_CURRENT_LIMIT_MAX,
-	},
-	[MAXIM_DEVICE_TYPE_MAX77836] = {
-		.min		= MAX77836_REGULATOR_CURRENT_LIMIT_MIN,
-		.high_start	= MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START,
-		.high_step	= MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP,
-		.max		= MAX77836_REGULATOR_CURRENT_LIMIT_MAX,
-	},
-};
-
 static int max14577_reg_is_enabled(struct regulator_dev *rdev)
 {
 	int rid = rdev_get_id(rdev);
@@ -103,8 +67,8 @@ static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
 static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 		int min_uA, int max_uA)
 {
-	int i, current_bits = 0xf;
 	u8 reg_data;
+	int ret;
 	struct max14577 *max14577 = rdev_get_drvdata(rdev);
 	const struct maxim_charger_current *limits =
 		&maxim_charger_currents[max14577->dev_type];
@@ -112,35 +76,9 @@ static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 	if (rdev_get_id(rdev) != MAX14577_CHARGER)
 		return -EINVAL;
 
-	if (min_uA > limits->max || max_uA < limits->min)
-		return -EINVAL;
-
-	if (max_uA < limits->high_start) {
-		/*
-		 * Less than high_start,
-		 * so set the minimal current (turn only Low Bit off)
-		 */
-		u8 reg_data = 0x0 << CHGCTRL4_MBCICHWRCL_SHIFT;
-		return max14577_update_reg(rdev->regmap,
-				MAX14577_CHG_REG_CHG_CTRL4,
-				CHGCTRL4_MBCICHWRCL_MASK, reg_data);
-	}
-
-	/*
-	 * max_uA is in range: <high_start, inifinite>, so search for
-	 * valid current starting from maximum current.
-	 */
-	for (i = limits->max; i >= limits->high_start; i -= limits->high_step) {
-		if (i <= max_uA)
-			break;
-		current_bits--;
-	}
-	BUG_ON(current_bits < 0); /* Cannot happen */
-
-	/* Turn Low Bit on (use range high_start-max)... */
-	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
-	/* and set proper High Bits */
-	reg_data |= current_bits << CHGCTRL4_MBCICHWRCH_SHIFT;
+	ret = maxim_charger_calc_reg_current(limits, min_uA, max_uA, &reg_data);
+	if (ret)
+		return ret;
 
 	return max14577_update_reg(rdev->regmap, MAX14577_CHG_REG_CHG_CTRL4,
 			CHGCTRL4_MBCICHWRCL_MASK | CHGCTRL4_MBCICHWRCH_MASK,
@@ -442,16 +380,6 @@ static struct platform_driver max14577_regulator_driver = {
 
 static int __init max14577_regulator_init(void)
 {
-	/* Check for valid values for charger */
-	BUILD_BUG_ON(MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
-			MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
-			MAX14577_REGULATOR_CURRENT_LIMIT_MAX);
-	BUILD_BUG_ON(MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START +
-			MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
-			MAX77836_REGULATOR_CURRENT_LIMIT_MAX);
-	/* Valid charger current values must be provided for each chipset */
-	BUILD_BUG_ON(ARRAY_SIZE(maxim_charger_currents) != MAXIM_DEVICE_TYPE_NUM);
-
 	BUILD_BUG_ON(ARRAY_SIZE(max14577_supported_regulators) != MAX14577_REGULATOR_NUM);
 	BUILD_BUG_ON(ARRAY_SIZE(max77836_supported_regulators) != MAX77836_REGULATOR_NUM);
 
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index d6f321699b89..7d514839c764 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -281,17 +281,17 @@ enum max14577_charger_reg {
 #define CHGCTRL7_OTPCGHCVS_SHIFT	0
 #define CHGCTRL7_OTPCGHCVS_MASK		(0x3 << CHGCTRL7_OTPCGHCVS_SHIFT)
 
-/* MAX14577 regulator current limits (as in CHGCTRL4 register), uA */
-#define MAX14577_REGULATOR_CURRENT_LIMIT_MIN		 90000
-#define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START	200000
-#define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 50000
-#define MAX14577_REGULATOR_CURRENT_LIMIT_MAX		950000
-
-/* MAX77836 regulator current limits (as in CHGCTRL4 register), uA */
-#define MAX77836_REGULATOR_CURRENT_LIMIT_MIN		 45000
-#define MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START	100000
-#define MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 25000
-#define MAX77836_REGULATOR_CURRENT_LIMIT_MAX		475000
+/* MAX14577 charger current limits (as in CHGCTRL4 register), uA */
+#define MAX14577_CHARGER_CURRENT_LIMIT_MIN		 90000U
+#define MAX14577_CHARGER_CURRENT_LIMIT_HIGH_START	200000U
+#define MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP	 50000U
+#define MAX14577_CHARGER_CURRENT_LIMIT_MAX		950000U
+
+/* MAX77836 charger current limits (as in CHGCTRL4 register), uA */
+#define MAX77836_CHARGER_CURRENT_LIMIT_MIN		 45000U
+#define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_START	100000U
+#define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP	 25000U
+#define MAX77836_CHARGER_CURRENT_LIMIT_MAX		475000U
 
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index c83fbed1c7b6..3c098d57b1d1 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -74,4 +74,27 @@ struct max14577_platform_data {
 	struct max14577_regulator_platform_data *regulators;
 };
 
+/*
+ * Valid limits of current for max14577 and max77836 chargers.
+ * They must correspond to MBCICHWRCL and MBCICHWRCH fields in CHGCTRL4
+ * register for given chipset.
+ */
+struct maxim_charger_current {
+	/* Minimal current, set in CHGCTRL4/MBCICHWRCL, uA */
+	unsigned int min;
+	/*
+	 * Minimal current when high setting is active,
+	 * set in CHGCTRL4/MBCICHWRCH, uA
+	 */
+	unsigned int high_start;
+	/* Value of one step in high setting, uA */
+	unsigned int high_step;
+	/* Maximum current of high setting, uA */
+	unsigned int max;
+};
+
+extern const struct maxim_charger_current maxim_charger_currents[];
+extern int maxim_charger_calc_reg_current(const struct maxim_charger_current *limits,
+		unsigned int min_ua, unsigned int max_ua, u8 *dst);
+
 #endif /* __MAX14577_H__ */
-- 
1.9.1
