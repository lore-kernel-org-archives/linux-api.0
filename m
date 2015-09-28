From: Andreas Dannenberg <dannenberg@ti.com>
Subject: [PATCH v8 09/14] power: bq24257: Add over voltage protection setting support
Date: Mon, 28 Sep 2015 17:33:57 -0500
Message-ID: <1443479642-23712-10-git-send-email-dannenberg@ti.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>
List-Id: linux-api@vger.kernel.org

A new optional device property called "ti,ovp-voltage" is introduced to
allow configuring the input over voltage protection setting.

This commit also adds the basic sysfs support for custom properties
which is being used to allow userspace to read the current ovp-voltage
setting.

Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/power/bq24257_charger.c | 67 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index 15e0e93..b617c3a 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -78,6 +78,7 @@ struct bq24257_init_data {
 	u8 vbat;	/* regulation voltage  */
 	u8 iterm;	/* termination current */
 	u8 iilimit;	/* input current limit */
+	u8 vovp;	/* over voltage protection voltage */
 };
 
 struct bq24257_state {
@@ -200,6 +201,13 @@ static const u32 bq24257_iilimit_map[] = {
 
 #define BQ24257_IILIMIT_MAP_SIZE	ARRAY_SIZE(bq24257_iilimit_map)
 
+static const u32 bq24257_vovp_map[] = {
+	6000000, 6500000, 7000000, 8000000, 9000000, 9500000, 10000000,
+	10500000
+};
+
+#define BQ24257_VOVP_MAP_SIZE		ARRAY_SIZE(bq24257_vovp_map)
+
 static int bq24257_field_read(struct bq24257_device *bq,
 			      enum bq24257_fields field_id)
 {
@@ -415,6 +423,17 @@ enum bq24257_in_ilimit {
 	IILIMIT_NONE,
 };
 
+enum bq24257_vovp {
+	VOVP_6000,
+	VOVP_6500,
+	VOVP_7000,
+	VOVP_8000,
+	VOVP_9000,
+	VOVP_9500,
+	VOVP_10000,
+	VOVP_10500
+};
+
 enum bq24257_port_type {
 	PORT_TYPE_DCP,		/* Dedicated Charging Port */
 	PORT_TYPE_CDP,		/* Charging Downstream Port */
@@ -586,7 +605,8 @@ static int bq24257_hw_init(struct bq24257_device *bq)
 	} init_data[] = {
 		{F_ICHG, bq->init_data.ichg},
 		{F_VBAT, bq->init_data.vbat},
-		{F_ITERM, bq->init_data.iterm}
+		{F_ITERM, bq->init_data.iterm},
+		{F_VOVP, bq->init_data.vovp},
 	};
 
 	/*
@@ -656,6 +676,28 @@ static const struct power_supply_desc bq24257_power_supply_desc = {
 	.get_property = bq24257_power_supply_get_property,
 };
 
+static ssize_t bq24257_show_ovp_voltage(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct bq24257_device *bq = power_supply_get_drvdata(psy);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 bq24257_vovp_map[bq->init_data.vovp]);
+}
+
+static DEVICE_ATTR(ovp_voltage, S_IRUGO, bq24257_show_ovp_voltage, NULL);
+
+static struct attribute *bq24257_charger_attr[] = {
+	&dev_attr_ovp_voltage.attr,
+	NULL,
+};
+
+static const struct attribute_group bq24257_attr_group = {
+	.attrs = bq24257_charger_attr,
+};
+
 static int bq24257_power_supply_init(struct bq24257_device *bq)
 {
 	struct power_supply_config psy_cfg = { .drv_data = bq, };
@@ -734,6 +776,15 @@ static int bq24257_fw_probe(struct bq24257_device *bq)
 						 bq24257_iilimit_map,
 						 BQ24257_IILIMIT_MAP_SIZE);
 
+	ret = device_property_read_u32(bq->dev, "ti,ovp-voltage",
+				       &property);
+	if (ret < 0)
+		bq->init_data.vovp = VOVP_6500;
+	else
+		bq->init_data.vovp = bq24257_find_idx(property,
+						      bq24257_vovp_map,
+						      BQ24257_VOVP_MAP_SIZE);
+
 	return 0;
 }
 
@@ -859,10 +910,18 @@ static int bq24257_probe(struct i2c_client *client,
 	}
 
 	ret = bq24257_power_supply_init(bq);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "Failed to register power supply\n");
+		return ret;
+	}
 
-	return ret;
+	ret = sysfs_create_group(&bq->charger->dev.kobj, &bq24257_attr_group);
+	if (ret < 0) {
+		dev_err(dev, "Can't create sysfs entries\n");
+		return ret;
+	}
+
+	return 0;
 }
 
 static int bq24257_remove(struct i2c_client *client)
@@ -872,6 +931,8 @@ static int bq24257_remove(struct i2c_client *client)
 	if (bq->iilimit_autoset_enable)
 		cancel_delayed_work_sync(&bq->iilimit_setup_work);
 
+	sysfs_remove_group(&bq->charger->dev.kobj, &bq24257_attr_group);
+
 	bq24257_field_write(bq, F_RESET, 1); /* reset to defaults */
 
 	return 0;
-- 
1.9.1

