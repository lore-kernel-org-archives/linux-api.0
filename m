From: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v4 5/8] power: Add support for DA9150 Charger
Date: Tue, 25 Nov 2014 18:25:32 +0000
Message-ID: <5dceb4afb64d977846ca47e365c38a6faed51693.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1416938054.git.Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, support.opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch adds support for DA9150 Charger & Fuel-Gauge IC Charger.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
---
 drivers/power/Kconfig          |  12 +
 drivers/power/Makefile         |   1 +
 drivers/power/da9150-charger.c | 666 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 679 insertions(+)
 create mode 100644 drivers/power/da9150-charger.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0108c2a..eb79a7a 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -192,6 +192,18 @@ config BATTERY_DA9052
 	  Say Y here to enable support for batteries charger integrated into
 	  DA9052 PMIC.

+config CHARGER_DA9150
+	tristate "Dialog Semiconductor DA9150 Charger support"
+	depends on MFD_DA9150
+	depends on DA9150_GPADC
+	depends on IIO
+	help
+	  Say Y here to enable support for charger unit of the DA9150
+	  Integrated Charger & Fuel-Gauge IC.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called da9150-charger.
+
 config BATTERY_MAX17040
 	tristate "Maxim MAX17040 Fuel Gauge"
 	depends on I2C
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index dfa8942..0c1896d 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_BATTERY_SBS)	+= sbs-battery.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_DA9052)	+= da9052-battery.o
+obj-$(CONFIG_CHARGER_DA9150)	+= da9150-charger.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
diff --git a/drivers/power/da9150-charger.c b/drivers/power/da9150-charger.c
new file mode 100644
index 0000000..9b1826d
--- /dev/null
+++ b/drivers/power/da9150-charger.c
@@ -0,0 +1,666 @@
+/*
+ * DA9150 Charger Driver
+ *
+ * Copyright (c) 2014 Dialog Semiconductor
+ *
+ * Author: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/interrupt.h>
+#include <linux/power_supply.h>
+#include <linux/notifier.h>
+#include <linux/usb/phy.h>
+#include <linux/iio/consumer.h>
+#include <linux/mfd/da9150/core.h>
+#include <linux/mfd/da9150/registers.h>
+
+/* Private data */
+struct da9150_charger {
+	struct da9150 *da9150;
+	struct device *dev;
+
+	struct power_supply usb;
+	struct power_supply battery;
+	struct power_supply *supply_online;
+
+	struct usb_phy *usb_phy;
+	struct notifier_block otg_nb;
+	struct work_struct otg_work;
+	unsigned long usb_event;
+
+	struct iio_channel *ibus_chan;
+	struct iio_channel *vbus_chan;
+	struct iio_channel *tjunc_chan;
+	struct iio_channel *vbat_chan;
+};
+
+static inline int da9150_charger_supply_online(struct da9150_charger *charger,
+					       struct power_supply *psy,
+					       union power_supply_propval *val)
+{
+	val->intval = (psy == charger->supply_online) ? 1 : 0;
+
+	return 0;
+}
+
+/* Charger Properties */
+static int da9150_charger_vbus_voltage_now(struct da9150_charger *charger,
+					   union power_supply_propval *val)
+{
+	int v_val, ret;
+
+	/* Read processed value - mV units */
+	ret = iio_read_channel_processed(charger->vbus_chan, &v_val);
+	if (ret < 0)
+		return ret;
+
+	/* Convert voltage to expected uV units */
+	val->intval = v_val * 1000;
+
+	return 0;
+}
+
+static int da9150_charger_ibus_current_avg(struct da9150_charger *charger,
+					   union power_supply_propval *val)
+{
+	int i_val, ret;
+
+	/* Read processed value - mA units */
+	ret = iio_read_channel_processed(charger->ibus_chan, &i_val);
+	if (ret < 0)
+		return ret;
+
+	/* Convert current to expected uA units */
+	val->intval = i_val * 1000;
+
+	return 0;
+}
+
+static int da9150_charger_tjunc_temp(struct da9150_charger *charger,
+				     union power_supply_propval *val)
+{
+	int t_val, ret;
+
+	/* Read processed value - 0.001 degrees C units */
+	ret = iio_read_channel_processed(charger->tjunc_chan, &t_val);
+	if (ret < 0)
+		return ret;
+
+	/* Convert temp to expect 0.1 degrees C units */
+	val->intval = t_val / 100;
+
+	return 0;
+}
+
+static enum power_supply_property da9150_charger_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+static int da9150_charger_get_prop(struct power_supply *psy,
+				   enum power_supply_property psp,
+				   union power_supply_propval *val)
+{
+	struct da9150_charger *charger = dev_get_drvdata(psy->dev->parent);
+	int ret;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = da9150_charger_supply_online(charger, psy, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = da9150_charger_vbus_voltage_now(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		ret = da9150_charger_ibus_current_avg(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		ret = da9150_charger_tjunc_temp(charger, val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/* Battery Properties */
+static int da9150_charger_battery_status(struct da9150_charger *charger,
+					 union power_supply_propval *val)
+{
+	u8 reg;
+
+	/* Check to see if battery is discharging */
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_H);
+
+	if (((reg & DA9150_VBUS_STAT_MASK) == DA9150_VBUS_STAT_OFF) ||
+	    ((reg & DA9150_VBUS_STAT_MASK) == DA9150_VBUS_STAT_WAIT)) {
+		val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+
+		return 0;
+	}
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+
+	/* Now check for other states */
+	switch (reg & DA9150_CHG_STAT_MASK) {
+	case DA9150_CHG_STAT_ACT:
+	case DA9150_CHG_STAT_PRE:
+	case DA9150_CHG_STAT_CC:
+	case DA9150_CHG_STAT_CV:
+		val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		break;
+	case DA9150_CHG_STAT_OFF:
+	case DA9150_CHG_STAT_SUSP:
+	case DA9150_CHG_STAT_TEMP:
+	case DA9150_CHG_STAT_TIME:
+	case DA9150_CHG_STAT_BAT:
+		val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		break;
+	case DA9150_CHG_STAT_FULL:
+		val->intval = POWER_SUPPLY_STATUS_FULL;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		break;
+	}
+
+	return 0;
+}
+
+static int da9150_charger_battery_health(struct da9150_charger *charger,
+					 union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+
+	/* Check if temperature limit reached */
+	switch (reg & DA9150_CHG_TEMP_MASK) {
+	case DA9150_CHG_TEMP_UNDER:
+		val->intval = POWER_SUPPLY_HEALTH_COLD;
+		return 0;
+	case DA9150_CHG_TEMP_OVER:
+		val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		return 0;
+	default:
+		break;
+	}
+
+	/* Check for other health states */
+	switch (reg & DA9150_CHG_STAT_MASK) {
+	case DA9150_CHG_STAT_ACT:
+	case DA9150_CHG_STAT_PRE:
+		val->intval = POWER_SUPPLY_HEALTH_DEAD;
+		break;
+	case DA9150_CHG_STAT_TIME:
+		val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	}
+
+	return 0;
+}
+
+static int da9150_charger_battery_present(struct da9150_charger *charger,
+					  union power_supply_propval *val)
+{
+	u8 reg;
+
+	/* Check if battery present or removed */
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+	if ((reg & DA9150_CHG_STAT_MASK) == DA9150_CHG_STAT_BAT)
+		val->intval = 0;
+	else
+		val->intval = 1;
+
+	return 0;
+}
+
+static int da9150_charger_battery_charge_type(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_J);
+
+	switch (reg & DA9150_CHG_STAT_MASK) {
+	case DA9150_CHG_STAT_CC:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_FAST;
+		break;
+	case DA9150_CHG_STAT_ACT:
+	case DA9150_CHG_STAT_PRE:
+	case DA9150_CHG_STAT_CV:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_NONE;
+		break;
+	}
+
+	return 0;
+}
+
+static int da9150_charger_battery_voltage_min(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_PPR_CHGCTRL_C);
+
+	/* Value starts at 2500 mV, 50 mV increments, presented in uV */
+	val->intval = ((reg & DA9150_CHG_VFAULT_MASK) * 50000) + 2500000;
+
+	return 0;
+}
+
+static int da9150_charger_battery_voltage_now(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	int v_val, ret;
+
+	/* Read processed value - mV units */
+	ret = iio_read_channel_processed(charger->vbat_chan, &v_val);
+	if (ret < 0)
+		return ret;
+
+	val->intval = v_val * 1000;
+
+	return 0;
+}
+
+static int da9150_charger_battery_current_max(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	int reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_PPR_CHGCTRL_D);
+
+	/* 25mA increments */
+	val->intval = reg * 25000;
+
+	return 0;
+}
+
+static int da9150_charger_battery_voltage_max(struct da9150_charger *charger,
+					      union power_supply_propval *val)
+{
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_PPR_CHGCTRL_B);
+
+	/* Value starts at 3650 mV, 25 mV increments, presented in uV */
+	val->intval = ((reg & DA9150_CHG_VBAT_MASK) * 25000) + 3650000;
+	return 0;
+}
+
+static enum power_supply_property da9150_charger_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX,
+	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
+};
+
+static int da9150_charger_battery_get_prop(struct power_supply *psy,
+					   enum power_supply_property psp,
+					   union power_supply_propval *val)
+{
+	struct da9150_charger *charger = dev_get_drvdata(psy->dev->parent);
+	int ret;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = da9150_charger_battery_status(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = da9150_charger_supply_online(charger, psy, val);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		ret = da9150_charger_battery_health(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		ret = da9150_charger_battery_present(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		ret = da9150_charger_battery_charge_type(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		ret = da9150_charger_battery_voltage_min(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = da9150_charger_battery_voltage_now(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_CURRENT_MAX:
+		ret = da9150_charger_battery_current_max(charger, val);
+		break;
+	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX:
+		ret = da9150_charger_battery_voltage_max(charger, val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static irqreturn_t da9150_charger_chg_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+
+	power_supply_changed(&charger->battery);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t da9150_charger_tjunc_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+
+	/* Nothing we can really do except report this. */
+	dev_crit(charger->dev, "TJunc over temperature!!!\n");
+	power_supply_changed(&charger->usb);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t da9150_charger_vfault_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+
+	/* Nothing we can really do except report this. */
+	dev_crit(charger->dev, "VSYS under voltage!!!\n");
+	power_supply_changed(&charger->usb);
+	power_supply_changed(&charger->battery);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t da9150_charger_vbus_irq(int irq, void *data)
+{
+	struct da9150_charger *charger = data;
+	u8 reg;
+
+	reg = da9150_reg_read(charger->da9150, DA9150_STATUS_H);
+
+	/* Charger plugged in or battery only */
+	switch (reg & DA9150_VBUS_STAT_MASK) {
+	case DA9150_VBUS_STAT_OFF:
+	case DA9150_VBUS_STAT_WAIT:
+		charger->supply_online = &charger->battery;
+		break;
+	case DA9150_VBUS_STAT_CHG:
+		charger->supply_online = &charger->usb;
+		break;
+	default:
+		dev_warn(charger->dev, "Unknown VBUS state - reg = 0x%x\n",
+			 reg);
+		charger->supply_online = NULL;
+		break;
+	}
+
+	power_supply_changed(&charger->usb);
+	power_supply_changed(&charger->battery);
+
+	return IRQ_HANDLED;
+}
+
+static void da9150_charger_otg_work(struct work_struct *data)
+{
+	struct da9150_charger *charger =
+		container_of(data, struct da9150_charger, otg_work);
+
+	switch (charger->usb_event) {
+	case USB_EVENT_ID:
+		/* Enable OTG Boost */
+		da9150_set_bits(charger->da9150, DA9150_PPR_BKCTRL_A,
+				DA9150_VBUS_MODE_MASK, DA9150_VBUS_MODE_OTG);
+		break;
+	case USB_EVENT_NONE:
+		/* Revert to charge mode */
+		power_supply_changed(&charger->usb);
+		power_supply_changed(&charger->battery);
+		da9150_set_bits(charger->da9150, DA9150_PPR_BKCTRL_A,
+				DA9150_VBUS_MODE_MASK, DA9150_VBUS_MODE_CHG);
+		break;
+	}
+}
+
+static int da9150_charger_otg_ncb(struct notifier_block *nb, unsigned long val,
+				  void *priv)
+{
+	struct da9150_charger *charger =
+		container_of(nb, struct da9150_charger, otg_nb);
+
+	dev_dbg(charger->dev, "DA9150 OTG notify %lu\n", val);
+
+	charger->usb_event = val;
+	schedule_work(&charger->otg_work);
+
+	return NOTIFY_OK;
+}
+
+static int da9150_charger_register_irq(struct platform_device *pdev,
+				       irq_handler_t handler,
+				       const char *irq_name)
+{
+	struct device *dev = &pdev->dev;
+	struct da9150_charger *charger = platform_get_drvdata(pdev);
+	int irq, ret;
+
+	irq = platform_get_irq_byname(pdev, irq_name);
+	if (irq < 0) {
+		dev_err(dev, "Failed to get IRQ CHG_STATUS: %d\n", irq);
+		return irq;
+	}
+
+	ret = devm_request_threaded_irq(dev, irq, NULL, handler, IRQF_ONESHOT,
+					irq_name, charger);
+	if (ret)
+		dev_err(dev, "Failed to request IRQ %d: %d\n", irq, ret);
+
+	return ret;
+}
+
+static int da9150_charger_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
+	struct da9150_charger *charger;
+	struct power_supply *usb, *battery;
+	u8 reg;
+	int ret;
+
+	charger = devm_kzalloc(dev, sizeof(struct da9150_charger), GFP_KERNEL);
+	if (charger == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, charger);
+	charger->da9150 = da9150;
+	charger->dev = dev;
+
+	/* Acquire ADC channels */
+	charger->ibus_chan = iio_channel_get(dev, "CHAN_IBUS");
+	if (IS_ERR(charger->ibus_chan)) {
+		ret = PTR_ERR(charger->ibus_chan);
+		goto ibus_chan_fail;
+	}
+
+	charger->vbus_chan = iio_channel_get(dev, "CHAN_VBUS");
+	if (IS_ERR(charger->vbus_chan)) {
+		ret = PTR_ERR(charger->vbus_chan);
+		goto vbus_chan_fail;
+	}
+
+	charger->tjunc_chan = iio_channel_get(dev, "CHAN_TJUNC");
+	if (IS_ERR(charger->tjunc_chan)) {
+		ret = PTR_ERR(charger->tjunc_chan);
+		goto tjunc_chan_fail;
+	}
+
+	charger->vbat_chan = iio_channel_get(dev, "CHAN_VBAT");
+	if (IS_ERR(charger->vbat_chan)) {
+		ret = PTR_ERR(charger->vbat_chan);
+		goto vbat_chan_fail;
+	}
+
+	/* Register power supplies */
+	usb = &charger->usb;
+	battery = &charger->battery;
+
+	usb->name = "da9150-usb",
+	usb->type = POWER_SUPPLY_TYPE_USB;
+	usb->properties = da9150_charger_props;
+	usb->num_properties = ARRAY_SIZE(da9150_charger_props);
+	usb->get_property = da9150_charger_get_prop;
+	ret = power_supply_register(dev, usb);
+	if (ret)
+		goto usb_fail;
+
+	battery->name = "da9150-battery";
+	battery->type = POWER_SUPPLY_TYPE_BATTERY;
+	battery->properties = da9150_charger_bat_props;
+	battery->num_properties = ARRAY_SIZE(da9150_charger_bat_props);
+	battery->get_property = da9150_charger_battery_get_prop;
+	ret = power_supply_register(dev, battery);
+	if (ret)
+		goto battery_fail;
+
+	/* Get initial online supply */
+	reg = da9150_reg_read(da9150, DA9150_STATUS_H);
+
+	switch (reg & DA9150_VBUS_STAT_MASK) {
+	case DA9150_VBUS_STAT_OFF:
+	case DA9150_VBUS_STAT_WAIT:
+		charger->supply_online = &charger->battery;
+		break;
+	case DA9150_VBUS_STAT_CHG:
+		charger->supply_online = &charger->usb;
+		break;
+	default:
+		dev_warn(dev, "Unknown VBUS state - reg = 0x%x\n", reg);
+		charger->supply_online = NULL;
+		break;
+	}
+
+	/* Setup OTG reporting & configuration */
+	charger->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	if (!IS_ERR_OR_NULL(charger->usb_phy)) {
+		INIT_WORK(&charger->otg_work, da9150_charger_otg_work);
+		charger->otg_nb.notifier_call = da9150_charger_otg_ncb;
+		usb_register_notifier(charger->usb_phy, &charger->otg_nb);
+	}
+
+	/* Register IRQs */
+	ret = da9150_charger_register_irq(pdev, da9150_charger_chg_irq,
+					  "CHG_STATUS");
+	if (ret < 0)
+		goto irq_fail;
+
+	ret = da9150_charger_register_irq(pdev, da9150_charger_tjunc_irq,
+					  "CHG_TJUNC");
+	if (ret < 0)
+		goto irq_fail;
+
+	ret = da9150_charger_register_irq(pdev, da9150_charger_vfault_irq,
+					  "CHG_VFAULT");
+	if (ret < 0)
+		goto irq_fail;
+
+	ret = da9150_charger_register_irq(pdev, da9150_charger_vbus_irq,
+					  "CHG_VBUS");
+	if (ret < 0)
+		goto irq_fail;
+
+	return 0;
+
+irq_fail:
+	if (!IS_ERR_OR_NULL(charger->usb_phy))
+		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+battery_fail:
+	power_supply_unregister(usb);
+
+usb_fail:
+	iio_channel_release(charger->vbat_chan);
+
+vbat_chan_fail:
+	iio_channel_release(charger->tjunc_chan);
+
+tjunc_chan_fail:
+	iio_channel_release(charger->vbus_chan);
+
+vbus_chan_fail:
+	iio_channel_release(charger->ibus_chan);
+
+ibus_chan_fail:
+	return ret;
+}
+
+static int da9150_charger_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct da9150_charger *charger = platform_get_drvdata(pdev);
+	int irq;
+
+	/* Make sure IRQs are released before unregistering power supplies */
+	irq = platform_get_irq_byname(pdev, "CHG_VBUS");
+	devm_free_irq(dev, irq, charger);
+
+	irq = platform_get_irq_byname(pdev, "CHG_VFAULT");
+	devm_free_irq(dev, irq, charger);
+
+	irq = platform_get_irq_byname(pdev, "CHG_TJUNC");
+	devm_free_irq(dev, irq, charger);
+
+	irq = platform_get_irq_byname(pdev, "CHG_STATUS");
+	devm_free_irq(dev, irq, charger);
+
+	if (!IS_ERR_OR_NULL(charger->usb_phy))
+		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+
+	power_supply_unregister(&charger->battery);
+	power_supply_unregister(&charger->usb);
+
+	/* Release ADC channels */
+	iio_channel_release(charger->ibus_chan);
+	iio_channel_release(charger->vbus_chan);
+	iio_channel_release(charger->tjunc_chan);
+	iio_channel_release(charger->vbat_chan);
+
+	return 0;
+}
+
+static struct platform_driver da9150_charger_driver = {
+	.driver = {
+		.name = "da9150-charger",
+	},
+	.probe = da9150_charger_probe,
+	.remove = da9150_charger_remove,
+};
+
+module_platform_driver(da9150_charger_driver);
+
+MODULE_DESCRIPTION("Charger Driver for DA9150");
+MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>");
+MODULE_LICENSE("GPL");
--
1.9.3
