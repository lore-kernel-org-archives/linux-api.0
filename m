From: Andreas Dannenberg <dannenberg@ti.com>
Subject: [PATCH v6 06/14] power: bq24257: Allow manual setting of input current limit
Date: Thu, 24 Sep 2015 22:26:50 -0500
Message-ID: <1443151618-29742-7-git-send-email-dannenberg@ti.com>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>
List-Id: linux-api@vger.kernel.org

A new optional device property called "ti,current-limit" is introduced
to allow disabling the D+/D- USB signal-based charger type auto-
detection algorithm used to set the input current limit and instead to
use a fixed input current limit.

Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
---
 drivers/power/bq24257_charger.c | 86 +++++++++++++++++++++++++++++++++--------
 1 file changed, 70 insertions(+), 16 deletions(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index ac471cd..6daaac2 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -77,6 +77,7 @@ struct bq24257_init_data {
 	u8 ichg;	/* charge current      */
 	u8 vbat;	/* regulation voltage  */
 	u8 iterm;	/* termination current */
+	u8 iilimit;	/* input current limit */
 };
 
 struct bq24257_state {
@@ -103,6 +104,8 @@ struct bq24257_device {
 	struct bq24257_state state;
 
 	struct mutex lock; /* protect state data */
+
+	bool iilimit_autoset_enable;
 };
 
 static bool bq24257_is_volatile_reg(struct device *dev, unsigned int reg)
@@ -191,6 +194,12 @@ static const u32 bq24257_iterm_map[] = {
 
 #define BQ24257_ITERM_MAP_SIZE		ARRAY_SIZE(bq24257_iterm_map)
 
+static const u32 bq24257_iilimit_map[] = {
+	100000, 150000, 500000, 900000, 1500000, 2000000
+};
+
+#define BQ24257_IILIMIT_MAP_SIZE	ARRAY_SIZE(bq24257_iilimit_map)
+
 static int bq24257_field_read(struct bq24257_device *bq,
 			      enum bq24257_fields field_id)
 {
@@ -480,19 +489,24 @@ static void bq24257_handle_state_change(struct bq24257_device *bq,
 	old_state = bq->state;
 	mutex_unlock(&bq->lock);
 
+	/*
+	 * Handle BQ2425x state changes observing whether the D+/D- based input
+	 * current limit autoset functionality is enabled.
+	 */
 	if (!new_state->power_good) {
 		dev_dbg(bq->dev, "Power removed\n");
-		cancel_delayed_work_sync(&bq->iilimit_setup_work);
-
-		/* activate D+/D- port detection algorithm */
-		ret = bq24257_field_write(bq, F_DPDM_EN, 1);
-		if (ret < 0)
-			goto error;
-
-		/* reset input current limit */
-		ret = bq24257_field_write(bq, F_IILIMIT, IILIMIT_500);
-		if (ret < 0)
-			goto error;
+		if (bq->iilimit_autoset_enable) {
+			cancel_delayed_work_sync(&bq->iilimit_setup_work);
+
+			/* activate D+/D- port detection algorithm */
+			ret = bq24257_field_write(bq, F_DPDM_EN, 1);
+			if (ret < 0)
+				goto error;
+			/* reset input current limit */
+			ret = bq24257_field_write(bq, F_IILIMIT, IILIMIT_500);
+			if (ret < 0)
+				goto error;
+		}
 	} else if (!old_state.power_good) {
 		dev_dbg(bq->dev, "Power inserted\n");
 		if (bq->iilimit_autoset_enable)
@@ -577,7 +591,16 @@ static int bq24257_hw_init(struct bq24257_device *bq)
 	bq->state = state;
 	mutex_unlock(&bq->lock);
 
-	if (!state.power_good)
+	if (!bq->iilimit_autoset_enable) {
+		dev_dbg(bq->dev, "manually setting iilimit = %u\n",
+			bq->init_data.iilimit);
+
+		/* program fixed input current limit */
+		ret = bq24257_field_write(bq, F_IILIMIT,
+					  bq->init_data.iilimit);
+		if (ret < 0)
+			return ret;
+	} else if (!state.power_good)
 		/* activate D+/D- detection algorithm */
 		ret = bq24257_field_write(bq, F_DPDM_EN, 1);
 	else if (state.fault != FAULT_NO_BAT)
@@ -642,6 +665,7 @@ static int bq24257_fw_probe(struct bq24257_device *bq)
 	int ret;
 	u32 property;
 
+	/* Required properties */
 	ret = device_property_read_u32(bq->dev, "ti,charge-current", &property);
 	if (ret < 0)
 		return ret;
@@ -665,6 +689,24 @@ static int bq24257_fw_probe(struct bq24257_device *bq)
 	bq->init_data.iterm = bq24257_find_idx(property, bq24257_iterm_map,
 					       BQ24257_ITERM_MAP_SIZE);
 
+	/* Optional properties. If not provided use reasonable default. */
+	ret = device_property_read_u32(bq->dev, "ti,current-limit",
+				       &property);
+	if (ret < 0) {
+		bq->iilimit_autoset_enable = true;
+
+		/*
+		 * Explicitly set a default value which will be needed for
+		 * devices that don't support the automatic setting of the input
+		 * current limit through the charger type detection mechanism.
+		 */
+		bq->init_data.iilimit = IILIMIT_500;
+	} else
+		bq->init_data.iilimit =
+				bq24257_find_idx(property,
+						 bq24257_iilimit_map,
+						 BQ24257_IILIMIT_MAP_SIZE);
+
 	return 0;
 }
 
@@ -723,8 +765,6 @@ static int bq24257_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, bq);
 
-	INIT_DELAYED_WORK(&bq->iilimit_setup_work, bq24257_iilimit_setup_work);
-
 	if (!dev->platform_data) {
 		ret = bq24257_fw_probe(bq);
 		if (ret < 0) {
@@ -735,6 +775,18 @@ static int bq24257_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
+	/*
+	 * The BQ24250 doesn't support the D+/D- based charger type detection
+	 * used for the automatic setting of the input current limit setting so
+	 * explicitly disable that feature.
+	 */
+	if (bq->chip == BQ24250)
+		bq->iilimit_autoset_enable = false;
+
+	if (bq->iilimit_autoset_enable)
+		INIT_DELAYED_WORK(&bq->iilimit_setup_work,
+				  bq24257_iilimit_setup_work);
+
 	/* we can only check Power Good status by probing the PG pin */
 	ret = bq24257_pg_gpio_probe(bq);
 	if (ret < 0)
@@ -781,7 +833,8 @@ static int bq24257_remove(struct i2c_client *client)
 {
 	struct bq24257_device *bq = i2c_get_clientdata(client);
 
-	cancel_delayed_work_sync(&bq->iilimit_setup_work);
+	if (bq->iilimit_autoset_enable)
+		cancel_delayed_work_sync(&bq->iilimit_setup_work);
 
 	power_supply_unregister(bq->charger);
 
@@ -796,7 +849,8 @@ static int bq24257_suspend(struct device *dev)
 	struct bq24257_device *bq = dev_get_drvdata(dev);
 	int ret = 0;
 
-	cancel_delayed_work_sync(&bq->iilimit_setup_work);
+	if (bq->iilimit_autoset_enable)
+		cancel_delayed_work_sync(&bq->iilimit_setup_work);
 
 	/* reset all registers to default (and activate standalone mode) */
 	ret = bq24257_field_write(bq, F_RESET, 1);
-- 
1.9.1

