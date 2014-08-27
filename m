From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 3/8] charger: max14577: Add support for MAX77836 charger
Date: Wed, 27 Aug 2014 17:20:09 +0200
Message-ID: <1409152814-17302-4-git-send-email-k.kozlowski@samsung.com>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-reply-to: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Add support for MAX77836 charger to the max14577 driver. The MAX77836
charger is almost the same as 14577 model except:
 - No dead-battery detection;
 - Support for special charger (like in MAX77693);
 - Support for DX over-voltage protection (like in MAX77693);
 - Lower values of charging current (two times lower current for
   slow/fast charge, much lower EOC current);
 - Slightly different values in ChgTyp field of STATUS2 register. On
   MAX14577 0x6 is reserved and 0x7 dead battery. On the MAX77836 the
   0x6 means special charger and 0x7 is reserved. Regardless of these
   differences the driver maps them to one enum max14577_muic_charger_type.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/Kconfig            |  4 +--
 drivers/power/max14577_charger.c | 77 ++++++++++++++++++++++++++++++++--------
 2 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 73cfcdf28a36..69fa8a9ef7a6 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -325,11 +325,11 @@ config CHARGER_MANAGER
           with help of suspend_again support.
 
 config CHARGER_MAX14577
-	tristate "Maxim MAX14577 MUIC battery charger driver"
+	tristate "Maxim MAX14577/77836 battery charger driver"
 	depends on MFD_MAX14577
 	help
 	  Say Y to enable support for the battery charger control sysfs and
-	  platform data of MAX14577 MUICs.
+	  platform data of MAX14577/77836 MUICs.
 
 config CHARGER_MAX8997
 	tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index fad2a75b3604..19c8f42abf24 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -1,7 +1,7 @@
 /*
- * Battery charger driver for the Maxim 14577
+ * max14577_charger.c - Battery charger driver for the Maxim 14577/77836
  *
- * Copyright (C) 2013 Samsung Electronics
+ * Copyright (C) 2013,2014 Samsung Electronics
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -25,10 +25,35 @@ struct max14577_charger {
 	struct max14577	*max14577;
 	struct power_supply	charger;
 
-	unsigned int	charging_state;
-	unsigned int	battery_state;
+	unsigned int		charging_state;
+	unsigned int		battery_state;
 };
 
+/*
+ * Helper function for mapping values of STATUS2/CHGTYP register on max14577
+ * and max77836 chipsets to enum maxim_muic_charger_type.
+ */
+static enum max14577_muic_charger_type maxim_get_charger_type(
+		enum maxim_device_type dev_type, u8 val) {
+	switch (val) {
+	case MAX14577_CHARGER_TYPE_NONE:
+	case MAX14577_CHARGER_TYPE_USB:
+	case MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT:
+	case MAX14577_CHARGER_TYPE_DEDICATED_CHG:
+	case MAX14577_CHARGER_TYPE_SPECIAL_500MA:
+	case MAX14577_CHARGER_TYPE_SPECIAL_1A:
+		return val;
+	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
+	case MAX14577_CHARGER_TYPE_RESERVED:
+		if (dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+			val |= 0x8;
+		return val;
+	default:
+		WARN_ONCE(1, "max14577: Unsupported chgtyp register value 0x%02x", val);
+		return val;
+	}
+}
+
 static int max14577_get_charger_state(struct max14577_charger *chg)
 {
 	struct regmap *rmap = chg->max14577->regmap;
@@ -89,19 +114,23 @@ static int max14577_get_online(struct max14577_charger *chg)
 {
 	struct regmap *rmap = chg->max14577->regmap;
 	u8 reg_data;
+	enum max14577_muic_charger_type chg_type;
 
 	max14577_read_reg(rmap, MAX14577_MUIC_REG_STATUS2, &reg_data);
 	reg_data = ((reg_data & STATUS2_CHGTYP_MASK) >> STATUS2_CHGTYP_SHIFT);
-	switch (reg_data) {
+	chg_type = maxim_get_charger_type(chg->max14577->dev_type, reg_data);
+	switch (chg_type) {
 	case MAX14577_CHARGER_TYPE_USB:
 	case MAX14577_CHARGER_TYPE_DEDICATED_CHG:
 	case MAX14577_CHARGER_TYPE_SPECIAL_500MA:
 	case MAX14577_CHARGER_TYPE_SPECIAL_1A:
 	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
+	case MAX77836_CHARGER_TYPE_SPECIAL_BIAS:
 		return 1;
 	case MAX14577_CHARGER_TYPE_NONE:
 	case MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT:
 	case MAX14577_CHARGER_TYPE_RESERVED:
+	case MAX77836_CHARGER_TYPE_RESERVED:
 	default:
 		return 0;
 	}
@@ -118,10 +147,12 @@ static int max14577_get_battery_health(struct max14577_charger *chg)
 	struct regmap *rmap = chg->max14577->regmap;
 	int state = POWER_SUPPLY_HEALTH_GOOD;
 	u8 reg_data;
+	enum max14577_muic_charger_type chg_type;
 
 	max14577_read_reg(rmap, MAX14577_MUIC_REG_STATUS2, &reg_data);
 	reg_data = ((reg_data & STATUS2_CHGTYP_MASK) >> STATUS2_CHGTYP_SHIFT);
-	if (reg_data == MAX14577_CHARGER_TYPE_DEAD_BATTERY) {
+	chg_type = maxim_get_charger_type(chg->max14577->dev_type, reg_data);
+	if (chg_type == MAX14577_CHARGER_TYPE_DEAD_BATTERY) {
 		state = POWER_SUPPLY_HEALTH_DEAD;
 		goto state_set;
 	}
@@ -167,7 +198,7 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 			CDETCTRL1_CHGDETEN_MASK | CDETCTRL1_CHGTYPMAN_MASK,
 			reg_data);
 
-	/* Battery Fast-Charge Timer, from SM-V700: 6hrs */
+	/* Battery Fast-Charge Timer, set to: 6hrs */
 	reg_data = 0x3 << CHGCTRL1_TCHW_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL1, reg_data);
 
@@ -179,19 +210,22 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	reg_data |= 0x1 << CHGCTRL2_MBCHOSTEN_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL2, reg_data);
 
-	/* Battery-Charger Constant Voltage (CV) Mode, from SM-V700: 4.35V */
+	/* Battery-Charger Constant Voltage (CV) Mode, set to: 4.35V */
 	reg_data = 0xf << CHGCTRL3_MBCCVWRC_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL3, reg_data);
 
 	/*
-	 * Fast Battery-Charge Current Low, default 200-950mA
-	 * Fast Battery-Charge Current High, from SM-V700: 450mA
+	 * Fast Battery-Charge Current Low,
+	 * default 200-950mA (max14577) / 100-475mA (max77836)
+	 *
+	 * Fast Battery-Charge Current High,
+	 * set to 450mA (max14577) / 225mA (max77836)
 	 */
 	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
 	reg_data |= 0x5 << CHGCTRL4_MBCICHWRCH_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL4, reg_data);
 
-	/* End-of-Charge Current, from SM-V700: 50mA */
+	/* End-of-Charge Current, set to 50mA (max14577) / 7.5mA (max77836) */
 	reg_data = 0x0 << CHGCTRL5_EOCS_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL5, reg_data);
 
@@ -199,7 +233,7 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	reg_data = 0x0 << CHGCTRL6_AUTOSTOP_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL6, reg_data);
 
-	/* Overvoltage-Protection Threshold, from SM-V700: 6.5V */
+	/* Overvoltage-Protection Threshold, set to 6.5V */
 	reg_data = 0x2 << CHGCTRL7_OTPCGHCVS_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL7, reg_data);
 }
@@ -215,7 +249,11 @@ static enum power_supply_property max14577_charger_props[] = {
 	POWER_SUPPLY_PROP_MANUFACTURER,
 };
 
-static const char *model_name = "MAX14577";
+static const char * const model_names[] = {
+	[MAXIM_DEVICE_TYPE_UNKNOWN]	= "MAX14577-like",
+	[MAXIM_DEVICE_TYPE_MAX14577]	= "MAX14577",
+	[MAXIM_DEVICE_TYPE_MAX77836]	= "MAX77836",
+};
 static const char *manufacturer = "Maxim Integrated";
 
 static int max14577_charger_get_property(struct power_supply *psy,
@@ -244,7 +282,8 @@ static int max14577_charger_get_property(struct power_supply *psy,
 		val->intval = max14577_get_online(chg);
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
-		val->strval = model_name;
+		BUILD_BUG_ON(ARRAY_SIZE(model_names) != MAXIM_DEVICE_TYPE_NUM);
+		val->strval = model_names[chg->max14577->dev_type];
 		break;
 	case POWER_SUPPLY_PROP_MANUFACTURER:
 		val->strval = manufacturer;
@@ -296,6 +335,13 @@ static int max14577_charger_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max14577_charger_id[] = {
+	{ "max14577-charger", MAXIM_DEVICE_TYPE_MAX14577, },
+	{ "max77836-charger", MAXIM_DEVICE_TYPE_MAX77836, },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max14577_regulator_id);
+
 static struct platform_driver max14577_charger_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
@@ -303,9 +349,10 @@ static struct platform_driver max14577_charger_driver = {
 	},
 	.probe		= max14577_charger_probe,
 	.remove		= max14577_charger_remove,
+	.id_table	= max14577_charger_id,
 };
 module_platform_driver(max14577_charger_driver);
 
 MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
-MODULE_DESCRIPTION("MAXIM 14577 charger driver");
+MODULE_DESCRIPTION("Maxim 14577/77836 charger driver");
 MODULE_LICENSE("GPL");
-- 
1.9.1

