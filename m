From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v6 04/14] power: bq24257: Add basic support for bq24250/bq24251
Date: Thu, 24 Sep 2015 22:26:48 -0500
Message-ID: <1443151618-29742-5-git-send-email-dannenberg@ti.com>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443151618-29742-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds basic support for bq24250 and bq24251 which are very
similar to the bq24257 the driver was originally written for. Basic
support means the ability to select a device through Kconfig, DT and
ACPI, an instance variable allowing to check which chip is active, and
the reporting back of the selected device through the model_name power
supply sysfs property.

This patch by itself is not sufficient to actually use those two added
devices in a real-world setting due to some feature differences which
are addressed by other patches in this series.

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
---
 drivers/power/Kconfig           |  5 ++--
 drivers/power/bq24257_charger.c | 52 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index eeb5776..9e68853 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -409,12 +409,13 @@ config CHARGER_BQ24190
 	  Say Y to enable support for the TI BQ24190 battery charger.
 
 config CHARGER_BQ24257
-	tristate "TI BQ24257 battery charger driver"
+	tristate "TI BQ24250/24251/24257 battery charger driver"
 	depends on I2C
 	depends on GPIOLIB || COMPILE_TEST
 	depends on REGMAP_I2C
 	help
-	  Say Y to enable support for the TI BQ24257 battery charger.
+	  Say Y to enable support for the TI BQ24250, BQ24251, and BQ24257 battery
+	  chargers.
 
 config CHARGER_BQ24735
 	tristate "TI BQ24735 battery charger support"
diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index d8939dc..77c895f 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -13,6 +13,10 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
+ * Datasheets:
+ * http://www.ti.com/product/bq24250
+ * http://www.ti.com/product/bq24251
+ * http://www.ti.com/product/bq24257
  */
 
 #include <linux/module.h>
@@ -40,6 +44,22 @@
 
 #define BQ24257_ILIM_SET_DELAY		1000	/* msec */
 
+/*
+ * When adding support for new devices make sure that enum bq2425x_chip and
+ * bq2425x_chip_name[] always stay in sync!
+ */
+enum bq2425x_chip {
+	BQ24250,
+	BQ24251,
+	BQ24257,
+};
+
+static const char *const bq2425x_chip_name[] = {
+	"bq24250",
+	"bq24251",
+	"bq24257",
+};
+
 enum bq24257_fields {
 	F_WD_FAULT, F_WD_EN, F_STAT, F_FAULT,			    /* REG 1 */
 	F_RESET, F_IILIMIT, F_EN_STAT, F_EN_TERM, F_CE, F_HZ_MODE,  /* REG 2 */
@@ -70,6 +90,8 @@ struct bq24257_device {
 	struct device *dev;
 	struct power_supply *charger;
 
+	enum bq2425x_chip chip;
+
 	struct regmap *rmap;
 	struct regmap_field *rmap_fields[F_MAX_FIELDS];
 
@@ -248,6 +270,10 @@ static int bq24257_power_supply_get_property(struct power_supply *psy,
 		val->strval = BQ24257_MANUFACTURER;
 		break;
 
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = bq2425x_chip_name[bq->chip];
+		break;
+
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = state.power_good;
 		break;
@@ -561,6 +587,7 @@ static int bq24257_hw_init(struct bq24257_device *bq)
 
 static enum power_supply_property bq24257_power_supply_props[] = {
 	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_ONLINE,
 	POWER_SUPPLY_PROP_HEALTH,
@@ -645,6 +672,7 @@ static int bq24257_probe(struct i2c_client *client,
 {
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
 	struct device *dev = &client->dev;
+	const struct acpi_device_id *acpi_id;
 	struct bq24257_device *bq;
 	int ret;
 	int i;
@@ -661,6 +689,18 @@ static int bq24257_probe(struct i2c_client *client,
 	bq->client = client;
 	bq->dev = dev;
 
+	if (ACPI_HANDLE(dev)) {
+		acpi_id = acpi_match_device(dev->driver->acpi_match_table,
+					    &client->dev);
+		if (!acpi_id) {
+			dev_err(dev, "Failed to match ACPI device\n");
+			return -ENODEV;
+		}
+		bq->chip = (enum bq2425x_chip)acpi_id->driver_data;
+	} else {
+		bq->chip = (enum bq2425x_chip)id->driver_data;
+	}
+
 	mutex_init(&bq->lock);
 
 	bq->rmap = devm_regmap_init_i2c(client, &bq24257_regmap_config);
@@ -723,7 +763,7 @@ static int bq24257_probe(struct i2c_client *client,
 					bq24257_irq_handler_thread,
 					IRQF_TRIGGER_FALLING |
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-					"bq24257", bq);
+					bq2425x_chip_name[bq->chip], bq);
 	if (ret) {
 		dev_err(dev, "Failed to request IRQ #%d\n", client->irq);
 		return ret;
@@ -796,19 +836,25 @@ static const struct dev_pm_ops bq24257_pm = {
 };
 
 static const struct i2c_device_id bq24257_i2c_ids[] = {
-	{ "bq24257", 0 },
+	{ "bq24250", BQ24250 },
+	{ "bq24251", BQ24251 },
+	{ "bq24257", BQ24257 },
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, bq24257_i2c_ids);
 
 static const struct of_device_id bq24257_of_match[] = {
+	{ .compatible = "ti,bq24250", },
+	{ .compatible = "ti,bq24251", },
 	{ .compatible = "ti,bq24257", },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bq24257_of_match);
 
 static const struct acpi_device_id bq24257_acpi_match[] = {
-	{"BQ242570", 0},
+	{ "BQ242500", BQ24250 },
+	{ "BQ242510", BQ24251 },
+	{ "BQ242570", BQ24257 },
 	{},
 };
 MODULE_DEVICE_TABLE(acpi, bq24257_acpi_match);
-- 
1.9.1
