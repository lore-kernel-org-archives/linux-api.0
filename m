From: Andreas Dannenberg <dannenberg@ti.com>
Subject: [PATCH v8 03/14] power: bq24257: Use managed power supply register
Date: Mon, 28 Sep 2015 17:33:51 -0500
Message-ID: <1443479642-23712-4-git-send-email-dannenberg@ti.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>
List-Id: linux-api@vger.kernel.org

Use the devm_* managed version of the function to register the power
supply and remove the associated unregister function. This will simplify
error handling moving forward as it allows the unregister to happen
automatically. It also saves a few lines of code.

As this changes the order of putting the bq24257 into reset vs.
unregistering the power-supply during driver remove re-tested various
driver unload scenario to make sure that this doesn't cause any
unintended side effects such as erroneous interrupts.

Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/bq24257_charger.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index d2d077c..6757b41 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -590,8 +590,10 @@ static int bq24257_power_supply_init(struct bq24257_device *bq)
 	psy_cfg.supplied_to = bq24257_charger_supplied_to;
 	psy_cfg.num_supplicants = ARRAY_SIZE(bq24257_charger_supplied_to);
 
-	bq->charger = power_supply_register(bq->dev, &bq24257_power_supply_desc,
-					    &psy_cfg);
+	bq->charger = devm_power_supply_register(bq->dev,
+						 &bq24257_power_supply_desc,
+						 &psy_cfg);
+
 	if (IS_ERR(bq->charger))
 		return PTR_ERR(bq->charger);
 
@@ -742,8 +744,6 @@ static int bq24257_remove(struct i2c_client *client)
 
 	cancel_delayed_work_sync(&bq->iilimit_setup_work);
 
-	power_supply_unregister(bq->charger);
-
 	bq24257_field_write(bq, F_RESET, 1); /* reset to defaults */
 
 	return 0;
-- 
1.9.1

