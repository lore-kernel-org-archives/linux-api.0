From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v6 11/14] power: bq24257: Allow input current limit sysfs access
Date: Thu, 24 Sep 2015 22:26:55 -0500
Message-ID: <1443151618-29742-12-git-send-email-dannenberg@ti.com>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443151618-29742-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch allows reading and writing of the input current limit through
the power supply's input_current_limit sysfs property. This allows
userspace to see what charger was detected (if the D+/D- USB signal-
based charger type detection is enabled) and to re-configure the maximum
current drawn from the external supply at runtime based on system-level
knowledge or user input. Note that upon charger disconnection and
re-connection the limit configured through firmware becomes active again
(or the D+/D- USB signal-based charger detection will be run again).

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
---
 drivers/power/bq24257_charger.c | 83 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 4 deletions(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index 146ef8b..b029fdf 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -267,6 +267,47 @@ enum bq24257_fault {
 	FAULT_INPUT_LDO_LOW,
 };
 
+static int bq24257_get_input_current_limit(struct bq24257_device *bq,
+					   union power_supply_propval *val)
+{
+	int ret;
+
+	ret = bq24257_field_read(bq, F_IILIMIT);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * The "External ILIM" and "Production & Test" modes are not exposed
+	 * through this driver and not being covered by the lookup table.
+	 * Should such a mode have become active let's return an error rather
+	 * than exceeding the bounds of the lookup table and returning
+	 * garbage.
+	 */
+	if (ret >= BQ24257_IILIMIT_MAP_SIZE)
+		return -ENODATA;
+
+	val->intval = bq24257_iilimit_map[ret];
+
+	return 0;
+}
+
+static int bq24257_set_input_current_limit(struct bq24257_device *bq,
+					const union power_supply_propval *val)
+{
+	/*
+	 * Address the case where the user manually sets an input current limit
+	 * while the charger auto-detection mechanism is is active. In this
+	 * case we want to abort and go straight to the user-specified value.
+	 */
+	if (bq->iilimit_autoset_enable)
+		cancel_delayed_work_sync(&bq->iilimit_setup_work);
+
+	return bq24257_field_write(bq, F_IILIMIT,
+				   bq24257_find_idx(val->intval,
+						    bq24257_iilimit_map,
+						    BQ24257_IILIMIT_MAP_SIZE));
+}
+
 static int bq24257_power_supply_get_property(struct power_supply *psy,
 					     enum power_supply_property psp,
 					     union power_supply_propval *val)
@@ -351,6 +392,9 @@ static int bq24257_power_supply_get_property(struct power_supply *psy,
 		val->intval = bq24257_iterm_map[bq->init_data.iterm];
 		break;
 
+	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
+		return bq24257_get_input_current_limit(bq, val);
+
 	default:
 		return -EINVAL;
 	}
@@ -358,6 +402,31 @@ static int bq24257_power_supply_get_property(struct power_supply *psy,
 	return 0;
 }
 
+static int bq24257_power_supply_set_property(struct power_supply *psy,
+					enum power_supply_property prop,
+					const union power_supply_propval *val)
+{
+	struct bq24257_device *bq = power_supply_get_drvdata(psy);
+
+	switch (prop) {
+	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
+		return bq24257_set_input_current_limit(bq, val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int bq24257_power_supply_property_is_writeable(struct power_supply *psy,
+					enum power_supply_property psp)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int bq24257_get_chip_state(struct bq24257_device *bq,
 				  struct bq24257_state *state)
 {
@@ -559,11 +628,14 @@ static void bq24257_handle_state_change(struct bq24257_device *bq,
 			ret = bq24257_field_write(bq, F_DPDM_EN, 1);
 			if (ret < 0)
 				goto error;
-			/* reset input current limit */
-			ret = bq24257_field_write(bq, F_IILIMIT, IILIMIT_500);
-			if (ret < 0)
-				goto error;
 		}
+		/*
+		 * When power is removed always return to the default input
+		 * current limit as configured during probe.
+		 */
+		ret = bq24257_field_write(bq, F_IILIMIT, bq->init_data.iilimit);
+		if (ret < 0)
+			goto error;
 	} else if (!old_state.power_good) {
 		dev_dbg(bq->dev, "Power inserted\n");
 		if (bq->iilimit_autoset_enable)
@@ -679,6 +751,7 @@ static enum power_supply_property bq24257_power_supply_props[] = {
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE,
 	POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX,
 	POWER_SUPPLY_PROP_CHARGE_TERM_CURRENT,
+	POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT,
 };
 
 static char *bq24257_charger_supplied_to[] = {
@@ -691,6 +764,8 @@ static const struct power_supply_desc bq24257_power_supply_desc = {
 	.properties = bq24257_power_supply_props,
 	.num_properties = ARRAY_SIZE(bq24257_power_supply_props),
 	.get_property = bq24257_power_supply_get_property,
+	.set_property = bq24257_power_supply_set_property,
+	.property_is_writeable = bq24257_power_supply_property_is_writeable,
 };
 
 static ssize_t bq24257_show_ovp_voltage(struct device *dev,
-- 
1.9.1
