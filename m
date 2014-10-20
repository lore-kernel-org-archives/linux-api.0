From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 4/5] power: max77693: Add charger driver for Maxim 77693
Date: Mon, 20 Oct 2014 14:34:48 +0200
Message-ID: <1413808489-3524-5-git-send-email-k.kozlowski@samsung.com>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1413808489-3524-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add new driver for Maxim 77693 switch-mode charger (part of max77693
MFD driver) providing power supply class information to userspace.

The charger has +20V tolerant input. Current input can be set from 0 to
2.58 A. The charger can deliver up to 2.1 A to the battery or 3.5 A to
the system (when supplying additional current from battery to system).

The driver is configured through DTS (battery and system related
settings) and sysfs entries (timers and top-off charging threshold).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/power/Kconfig            |   6 +
 drivers/power/Makefile           |   1 +
 drivers/power/max77693_charger.c | 763 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 770 insertions(+)
 create mode 100644 drivers/power/max77693_charger.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0108c2af005b..77e6cd7bb801 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -332,6 +332,12 @@ config CHARGER_MAX14577
 	  Say Y to enable support for the battery charger control sysfs and
 	  platform data of MAX14577/77836 MUICs.
 
+config CHARGER_MAX77693
+	tristate "Maxim MAX77693 battery charger driver"
+	depends on MFD_MAX77693
+	help
+	  Say Y to enable support for the Maxim MAX77693 battery charger.
+
 config CHARGER_MAX8997
 	tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
 	depends on MFD_MAX8997 && REGULATOR_MAX8997
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index dfa894273926..2d7ad66cc7d6 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_CHARGER_LP8788)	+= lp8788-charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
 obj-$(CONFIG_CHARGER_MAX14577)	+= max14577_charger.o
+obj-$(CONFIG_CHARGER_MAX77693)	+= max77693_charger.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
diff --git a/drivers/power/max77693_charger.c b/drivers/power/max77693_charger.c
new file mode 100644
index 000000000000..dfdbcc2f0795
--- /dev/null
+++ b/drivers/power/max77693_charger.c
@@ -0,0 +1,763 @@
+/*
+ * max77693_charger.c - Battery charger driver for the Maxim 77693
+ *
+ * Copyright (C) 2014 Samsung Electronics
+ * Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/regmap.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+
+static const char *max77693_charger_name		= "max77693-charger";
+static const char *max77693_charger_model		= "MAX77693";
+static const char *max77693_charger_manufacturer	= "Maxim Integrated";
+
+struct max77693_charger {
+	struct device		*dev;
+	struct max77693_dev	*max77693;
+	struct power_supply	charger;
+
+	struct max77693_charger_platform_data	*pdata;
+};
+
+static int max77693_get_charger_state(struct regmap *regmap)
+{
+	int state;
+	unsigned int data;
+
+	if (regmap_read(regmap, MAX77693_CHG_REG_CHG_DETAILS_01, &data) < 0)
+		return POWER_SUPPLY_STATUS_UNKNOWN;
+
+	data &= CHG_DETAILS_01_CHG_MASK;
+	data >>= CHG_DETAILS_01_CHG_SHIFT;
+
+	switch (data) {
+	case MAX77693_CHARGING_PREQUALIFICATION:
+	case MAX77693_CHARGING_FAST_CONST_CURRENT:
+	case MAX77693_CHARGING_FAST_CONST_VOLTAGE:
+	case MAX77693_CHARGING_TOP_OFF:
+	/* In high temp the charging current is reduced, but still charging */
+	case MAX77693_CHARGING_HIGH_TEMP:
+		state = POWER_SUPPLY_STATUS_CHARGING;
+		break;
+	case MAX77693_CHARGING_DONE:
+		state = POWER_SUPPLY_STATUS_FULL;
+		break;
+	case MAX77693_CHARGING_TIMER_EXPIRED:
+	case MAX77693_CHARGING_THERMISTOR_SUSPEND:
+		state = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		break;
+	case MAX77693_CHARGING_OFF:
+	case MAX77693_CHARGING_OVER_TEMP:
+	case MAX77693_CHARGING_WATCHDOG_EXPIRED:
+		state = POWER_SUPPLY_STATUS_DISCHARGING;
+		break;
+	case MAX77693_CHARGING_RESERVED:
+	default:
+		state = POWER_SUPPLY_STATUS_UNKNOWN;
+	}
+
+	return state;
+}
+
+static int max77693_get_charge_type(struct regmap *regmap)
+{
+	int state;
+	unsigned int data;
+
+	if (regmap_read(regmap, MAX77693_CHG_REG_CHG_DETAILS_01, &data) < 0)
+		return POWER_SUPPLY_CHARGE_TYPE_UNKNOWN;
+
+	data &= CHG_DETAILS_01_CHG_MASK;
+	data >>= CHG_DETAILS_01_CHG_SHIFT;
+
+	switch (data) {
+	case MAX77693_CHARGING_PREQUALIFICATION:
+	/*
+	 * Top-off: trickle or fast? In top-off the current varies between
+	 * 100 and 250 mA. It is higher than prequalification current.
+	 */
+	case MAX77693_CHARGING_TOP_OFF:
+		state = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+		break;
+	case MAX77693_CHARGING_FAST_CONST_CURRENT:
+	case MAX77693_CHARGING_FAST_CONST_VOLTAGE:
+	/* In high temp the charging current is reduced, but still charging */
+	case MAX77693_CHARGING_HIGH_TEMP:
+		state = POWER_SUPPLY_CHARGE_TYPE_FAST;
+		break;
+	case MAX77693_CHARGING_DONE:
+	case MAX77693_CHARGING_TIMER_EXPIRED:
+	case MAX77693_CHARGING_THERMISTOR_SUSPEND:
+	case MAX77693_CHARGING_OFF:
+	case MAX77693_CHARGING_OVER_TEMP:
+	case MAX77693_CHARGING_WATCHDOG_EXPIRED:
+		state = POWER_SUPPLY_CHARGE_TYPE_NONE;
+		break;
+	case MAX77693_CHARGING_RESERVED:
+	default:
+		state = POWER_SUPPLY_CHARGE_TYPE_UNKNOWN;
+	}
+
+	return state;
+}
+
+/*
+ * Supported health statuses:
+ *  - POWER_SUPPLY_HEALTH_DEAD
+ *  - POWER_SUPPLY_HEALTH_GOOD
+ *  - POWER_SUPPLY_HEALTH_OVERVOLTAGE
+ *  - POWER_SUPPLY_HEALTH_SAFETY_TIMER_EXPIRE
+ *  - POWER_SUPPLY_HEALTH_UNKNOWN
+ *  - POWER_SUPPLY_HEALTH_UNSPEC_FAILURE
+ */
+static int max77693_get_battery_health(struct regmap *regmap)
+{
+	int state;
+	unsigned int data;
+
+	if (regmap_read(regmap, MAX77693_CHG_REG_CHG_DETAILS_01, &data) < 0)
+		return POWER_SUPPLY_HEALTH_UNKNOWN;
+
+	data &= CHG_DETAILS_01_BAT_MASK;
+	data >>= CHG_DETAILS_01_BAT_SHIFT;
+
+	switch (data) {
+	case MAX77693_BATTERY_NOBAT:
+		state = POWER_SUPPLY_HEALTH_DEAD;
+		break;
+	case MAX77693_BATTERY_PREQUALIFICATION:
+	case MAX77693_BATTERY_GOOD:
+	case MAX77693_BATTERY_LOWVOLTAGE:
+		state = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	case MAX77693_BATTERY_TIMER_EXPIRED:
+		/*
+		 * Took longer to charge than expected, charging suspended.
+		 * Damaged battery?
+		 */
+		state = POWER_SUPPLY_HEALTH_SAFETY_TIMER_EXPIRE;
+		break;
+	case MAX77693_BATTERY_OVERVOLTAGE:
+		state = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
+		break;
+	case MAX77693_BATTERY_OVERCURRENT:
+		state = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		break;
+	case MAX77693_BATTERY_RESERVED:
+	default:
+		state = POWER_SUPPLY_HEALTH_UNKNOWN;
+		break;
+	}
+
+	return state;
+}
+
+static int max77693_get_present(struct regmap *regmap)
+{
+	unsigned int data;
+
+	/*
+	 * Read CHG_INT_OK register. High DETBAT bit here should be
+	 * equal to value 0x0 in CHG_DETAILS_01/BAT field.
+	 */
+	regmap_read(regmap, MAX77693_CHG_REG_CHG_INT_OK, &data);
+	if (data & CHG_INT_OK_DETBAT_MASK)
+		return 0;
+	return 1;
+}
+
+static int max77693_get_online(struct regmap *regmap)
+{
+	unsigned int data;
+
+	regmap_read(regmap, MAX77693_CHG_REG_CHG_INT_OK, &data);
+	if (data & CHG_INT_OK_CHGIN_MASK)
+		return 1;
+	return 0;
+}
+
+static enum power_supply_property max77693_charger_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
+static int max77693_charger_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	struct max77693_charger *chg = container_of(psy,
+						  struct max77693_charger,
+						  charger);
+	struct regmap *regmap = chg->max77693->regmap;
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = max77693_get_charger_state(regmap);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		val->intval = max77693_get_charge_type(regmap);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = max77693_get_battery_health(regmap);
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = max77693_get_present(regmap);
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = max77693_get_online(regmap);
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = max77693_charger_model;
+		break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = max77693_charger_manufacturer;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static ssize_t device_attr_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count,
+		int (*fn)(struct max77693_charger *, unsigned long))
+{
+	struct max77693_charger *chg = dev_get_drvdata(dev);
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	ret = fn(chg, val);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static ssize_t fast_charge_timer_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct max77693_charger *chg = dev_get_drvdata(dev);
+	unsigned int data, val;
+	int ret;
+
+	ret = regmap_read(chg->max77693->regmap, MAX77693_CHG_REG_CHG_CNFG_01,
+			&data);
+	if (ret < 0)
+		return ret;
+
+	data &= CHG_CNFG_01_FCHGTIME_MASK;
+	data >>= CHG_CNFG_01_FCHGTIME_SHIFT;
+	switch (data) {
+	case 0x1 ... 0x7:
+		/* Starting from 4 hours, step by 2 hours */
+		val = 4 + (data - 1) * 2;
+		break;
+	case 0x0:
+	default:
+		val = 0;
+		break;
+	}
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static int max77693_set_fast_charge_timer(struct max77693_charger *chg,
+		unsigned long hours)
+{
+	unsigned int data;
+
+	/*
+	 * 0x00 - disable
+	 * 0x01 - 4h
+	 * 0x02 - 6h
+	 * ...
+	 * 0x07 - 16h
+	 * Round down odd values.
+	 */
+	switch (hours) {
+	case 4 ... 16:
+		data = (hours - 4) / 2 + 1;
+		break;
+	case 0:
+		/* Disable */
+		data = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	data <<= CHG_CNFG_01_FCHGTIME_SHIFT;
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_01,
+			CHG_CNFG_01_FCHGTIME_MASK, data);
+}
+
+static ssize_t fast_charge_timer_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return device_attr_store(dev, attr, buf, count,
+			max77693_set_fast_charge_timer);
+}
+
+static ssize_t top_off_threshold_current_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct max77693_charger *chg = dev_get_drvdata(dev);
+	unsigned int data, val;
+	int ret;
+
+	ret = regmap_read(chg->max77693->regmap, MAX77693_CHG_REG_CHG_CNFG_03,
+			&data);
+	if (ret < 0)
+		return ret;
+
+	data &= CHG_CNFG_03_TOITH_MASK;
+	data >>= CHG_CNFG_03_TOITH_SHIFT;
+
+	if (data <= 0x04)
+		val = 100000 + data * 25000;
+	else
+		val = data * 50000;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static int max77693_set_top_off_threshold_current(struct max77693_charger *chg,
+		unsigned long uamp)
+{
+	unsigned int data;
+
+	if (uamp < 100000 || uamp > 350000)
+		return -EINVAL;
+
+	if (uamp <= 200000)
+		data = (uamp - 100000) / 25000;
+	else
+		/* (200000, 350000> */
+		data = uamp / 50000;
+
+	data <<= CHG_CNFG_03_TOITH_SHIFT;
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_03,
+			CHG_CNFG_03_TOITH_MASK, data);
+}
+
+static ssize_t top_off_threshold_current_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return device_attr_store(dev, attr, buf, count,
+			max77693_set_top_off_threshold_current);
+}
+
+static ssize_t top_off_timer_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct max77693_charger *chg = dev_get_drvdata(dev);
+	unsigned int data, val;
+	int ret;
+
+	ret = regmap_read(chg->max77693->regmap, MAX77693_CHG_REG_CHG_CNFG_03,
+			&data);
+	if (ret < 0)
+		return ret;
+
+	data &= CHG_CNFG_03_TOTIME_MASK;
+	data >>= CHG_CNFG_03_TOTIME_SHIFT;
+
+	val = data * 10;
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
+}
+
+static int max77693_set_top_off_timer(struct max77693_charger *chg,
+		unsigned long minutes)
+{
+	unsigned int data;
+
+	if (minutes > 70)
+		return -EINVAL;
+
+	data = minutes / 10;
+	data <<= CHG_CNFG_03_TOTIME_SHIFT;
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_03,
+			CHG_CNFG_03_TOTIME_MASK, data);
+}
+
+static ssize_t top_off_timer_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return device_attr_store(dev, attr, buf, count,
+			max77693_set_top_off_timer);
+}
+
+static DEVICE_ATTR_RW(fast_charge_timer);
+static DEVICE_ATTR_RW(top_off_threshold_current);
+static DEVICE_ATTR_RW(top_off_timer);
+
+static int max77693_set_constant_volt(struct max77693_charger *chg,
+		unsigned int uvolt)
+{
+	unsigned int data;
+
+	/*
+	 * 0x00 - 3.650 V
+	 * 0x01 - 3.675 V
+	 * ...
+	 * 0x1b - 4.325 V
+	 * 0x1c - 4.340 V
+	 * 0x1d - 4.350 V
+	 * 0x1e - 4.375 V
+	 * 0x1f - 4.400 V
+	 */
+	if (uvolt >= 3650000 && uvolt < 4340000)
+		data = (uvolt - 3650000) / 25000;
+	else if (uvolt >= 4340000 && uvolt < 4350000)
+		data = 0x1c;
+	else if (uvolt >= 4350000 && uvolt <= 4400000)
+		data = 0x1d + (uvolt - 4350000) / 25000;
+	else {
+		dev_err(chg->dev, "Wrong value for charging constant voltage\n");
+		return -EINVAL;
+	}
+
+	data <<= CHG_CNFG_04_CHGCVPRM_SHIFT;
+
+	dev_dbg(chg->dev, "Charging constant voltage: %u (0x%x)\n", uvolt,
+			data);
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_04,
+			CHG_CNFG_04_CHGCVPRM_MASK, data);
+}
+
+static int max77693_set_min_system_volt(struct max77693_charger *chg,
+		unsigned int uvolt)
+{
+	unsigned int data;
+
+	if (uvolt < 3000000 || uvolt > 3700000) {
+		dev_err(chg->dev, "Wrong value for minimum system regulation voltage\n");
+		return -EINVAL;
+	}
+
+	data = (uvolt - 3000000) / 100000;
+
+	data <<= CHG_CNFG_04_MINVSYS_SHIFT;
+
+	dev_dbg(chg->dev, "Minimum system regulation voltage: %u (0x%x)\n",
+			uvolt, data);
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_04,
+			CHG_CNFG_04_MINVSYS_MASK, data);
+}
+
+static int max77693_set_thermal_regulation_temp(struct max77693_charger *chg,
+		unsigned int cels)
+{
+	unsigned int data;
+
+	switch (cels) {
+	case 70:
+	case 85:
+	case 100:
+	case 115:
+		data = (cels - 70) / 15;
+		break;
+	default:
+		dev_err(chg->dev, "Wrong value for thermal regulation loop temperature\n");
+		return -EINVAL;
+	}
+
+	data <<= CHG_CNFG_07_REGTEMP_SHIFT;
+
+	dev_dbg(chg->dev, "Thermal regulation loop temperature: %u (0x%x)\n",
+			cels, data);
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_07,
+			CHG_CNFG_07_REGTEMP_MASK, data);
+}
+
+static int max77693_set_batttery_overcurrent(struct max77693_charger *chg,
+		unsigned int uamp)
+{
+	unsigned int data;
+
+	if (uamp && (uamp < 2000000 || uamp > 3500000)) {
+		dev_err(chg->dev, "Wrong value for battery overcurrent\n");
+		return -EINVAL;
+	}
+
+	if (uamp)
+		data = ((uamp - 2000000) / 250000) + 1;
+	else
+		data = 0; /* disable */
+
+	data <<= CHG_CNFG_12_B2SOVRC_SHIFT;
+
+	dev_dbg(chg->dev, "Battery overcurrent: %u (0x%x)\n", uamp, data);
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_12,
+			CHG_CNFG_12_B2SOVRC_MASK, data);
+}
+
+static int max77693_set_charge_input_threshold_volt(struct max77693_charger *chg,
+		unsigned int uvolt)
+{
+	unsigned int data;
+
+	switch (uvolt) {
+	case 4300000:
+		data = 0x0;
+		break;
+	case 4700000:
+	case 4800000:
+	case 4900000:
+		data = (uvolt - 4700000) / 100000;
+	default:
+		dev_err(chg->dev, "Wrong value for charge input voltage regulation threshold\n");
+		return -EINVAL;
+	}
+
+	data <<= CHG_CNFG_12_VCHGINREG_SHIFT;
+
+	dev_dbg(chg->dev, "Charge input voltage regulation threshold: %u (0x%x)\n",
+			uvolt, data);
+
+	return regmap_update_bits(chg->max77693->regmap,
+			MAX77693_CHG_REG_CHG_CNFG_12,
+			CHG_CNFG_12_VCHGINREG_MASK, data);
+}
+
+/*
+ * Sets charger registers to proper and safe default values.
+ */
+static int max77693_reg_init(struct max77693_charger *chg)
+{
+	int ret;
+	unsigned int data;
+
+	/* Unlock charger register protection */
+	data = (0x3 << CHG_CNFG_06_CHGPROT_SHIFT);
+	ret = regmap_update_bits(chg->max77693->regmap,
+				MAX77693_CHG_REG_CHG_CNFG_06,
+				CHG_CNFG_06_CHGPROT_MASK, data);
+	if (ret) {
+		dev_err(chg->dev, "Error unlocking registers: %d\n", ret);
+		return ret;
+	}
+
+	ret = max77693_set_fast_charge_timer(chg, DEFAULT_FAST_CHARGE_TIMER);
+	if (ret)
+		return ret;
+
+	ret = max77693_set_top_off_threshold_current(chg,
+			DEFAULT_TOP_OFF_THRESHOLD_CURRENT);
+	if (ret)
+		return ret;
+
+	ret = max77693_set_top_off_timer(chg, DEFAULT_TOP_OFF_TIMER);
+	if (ret)
+		return ret;
+
+	if (!chg->pdata)
+		return 0;
+
+	ret = max77693_set_constant_volt(chg,
+			chg->pdata->constant_volt);
+	if (ret)
+		return ret;
+
+	ret = max77693_set_min_system_volt(chg,
+			chg->pdata->min_system_volt);
+	if (ret)
+		return ret;
+
+	ret = max77693_set_thermal_regulation_temp(chg,
+			chg->pdata->thermal_regulation_temp);
+	if (ret)
+		return ret;
+
+	ret = max77693_set_batttery_overcurrent(chg,
+			chg->pdata->batttery_overcurrent);
+	if (ret)
+		return ret;
+
+	ret = max77693_set_charge_input_threshold_volt(chg,
+			chg->pdata->charge_input_threshold_volt);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static struct max77693_charger_platform_data *max77693_dt_init(
+		struct device *dev)
+{
+	struct max77693_charger_platform_data *pdata;
+	struct device_node *np = dev->of_node;
+
+	if (!np)
+		return NULL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	if (of_property_read_u32(np, "maxim,constant-microvolt",
+			&pdata->constant_volt))
+		pdata->constant_volt = DEFAULT_CONSTANT_VOLT;
+
+	if (of_property_read_u32(np, "maxim,min-system-microvolt",
+			&pdata->min_system_volt))
+		pdata->min_system_volt = DEFAULT_MIN_SYSTEM_VOLT;
+
+	if (of_property_read_u32(np, "maxim,thermal-regulation-celsius",
+			&pdata->thermal_regulation_temp))
+		pdata->thermal_regulation_temp = DEFAULT_THERMAL_REGULATION_TEMP;
+
+	if (of_property_read_u32(np, "maxim,battery-overcurrent-microamp",
+			&pdata->batttery_overcurrent))
+		pdata->batttery_overcurrent = DEFAULT_BATTERY_OVERCURRENT;
+
+	if (of_property_read_u32(np, "maxim,charge-input-threshold-microvolt",
+			&pdata->charge_input_threshold_volt))
+		pdata->charge_input_threshold_volt =
+			DEFAULT_CHARGER_INPUT_THRESHOLD_VOLT;
+
+	return pdata;
+}
+#else /* CONFIG_OF */
+static struct max77693_charger_platform_data *max77693_dt_init(
+		struct device *dev)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
+
+static int max77693_charger_probe(struct platform_device *pdev)
+{
+	struct max77693_charger *chg;
+	struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
+	int ret;
+
+	chg = devm_kzalloc(&pdev->dev, sizeof(*chg), GFP_KERNEL);
+	if (!chg)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, chg);
+	chg->dev = &pdev->dev;
+	chg->max77693 = max77693;
+
+	chg->pdata = max77693_dt_init(&pdev->dev);
+
+	ret = max77693_reg_init(chg);
+	if (ret)
+		return ret;
+
+	chg->charger.name = max77693_charger_name;
+	chg->charger.type = POWER_SUPPLY_TYPE_BATTERY;
+	chg->charger.properties = max77693_charger_props;
+	chg->charger.num_properties = ARRAY_SIZE(max77693_charger_props);
+	chg->charger.get_property = max77693_charger_get_property;
+
+	ret = device_create_file(&pdev->dev, &dev_attr_fast_charge_timer);
+	if (ret) {
+		dev_err(&pdev->dev, "failed: create fast charge timer sysfs entry\n");
+		goto err;
+	}
+
+	ret = device_create_file(&pdev->dev,
+			&dev_attr_top_off_threshold_current);
+	if (ret) {
+		dev_err(&pdev->dev, "failed: create top off current sysfs entry\n");
+		goto err;
+	}
+
+	ret = device_create_file(&pdev->dev, &dev_attr_top_off_timer);
+	if (ret) {
+		dev_err(&pdev->dev, "failed: create top off timer sysfs entry\n");
+		goto err;
+	}
+
+	ret = power_supply_register(&pdev->dev, &chg->charger);
+	if (ret) {
+		dev_err(&pdev->dev, "failed: power supply register\n");
+		goto err;
+	}
+
+	return 0;
+
+err:
+	device_remove_file(&pdev->dev, &dev_attr_top_off_timer);
+	device_remove_file(&pdev->dev, &dev_attr_top_off_threshold_current);
+	device_remove_file(&pdev->dev, &dev_attr_fast_charge_timer);
+
+	return ret;
+}
+
+static int max77693_charger_remove(struct platform_device *pdev)
+{
+	struct max77693_charger *chg = platform_get_drvdata(pdev);
+
+	device_remove_file(&pdev->dev, &dev_attr_top_off_timer);
+	device_remove_file(&pdev->dev, &dev_attr_top_off_threshold_current);
+	device_remove_file(&pdev->dev, &dev_attr_fast_charge_timer);
+
+	power_supply_unregister(&chg->charger);
+
+	return 0;
+}
+
+static const struct platform_device_id max77693_charger_id[] = {
+	{ "max77693-charger", 0, },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max77693_charger_id);
+
+static struct platform_driver max77693_charger_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "max77693-charger",
+	},
+	.probe		= max77693_charger_probe,
+	.remove		= max77693_charger_remove,
+	.id_table	= max77693_charger_id,
+};
+module_platform_driver(max77693_charger_driver);
+
+MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>");
+MODULE_DESCRIPTION("Maxim 77693 charger driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
