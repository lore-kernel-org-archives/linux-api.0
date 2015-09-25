From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v7 09/15] power: bq24257: Add SW-based approach for Power Good determination
Date: Fri, 25 Sep 2015 10:54:14 -0500
Message-ID: <1443196460-26156-10-git-send-email-dannenberg@ti.com>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443196460-26156-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

A software-based approach for determining the charger's input voltage
"Power Good" state is introduced for devices like the bq24250 which
don't have a dedicated hardware pin for that purpose. This SW-based
approach is also used for other devices (with dedicated PG pin) as a
fall back solution if that pin is not configured to be used through
"pg-gpios".

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
---
 drivers/power/bq24257_charger.c | 49 ++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index 7bbff80..5800697 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -359,7 +359,26 @@ static int bq24257_get_chip_state(struct bq24257_device *bq,
 
 	state->fault = ret;
 
-	state->power_good = !gpiod_get_value_cansleep(bq->pg);
+	if (bq->pg)
+		state->power_good = !gpiod_get_value_cansleep(bq->pg);
+	else
+		/*
+		 * If we have a chip without a dedicated power-good GPIO or
+		 * some other explicit bit that would provide this information
+		 * assume the power is good if there is no supply related
+		 * fault - and not good otherwise. There is a possibility for
+		 * other errors to mask that power in fact is not good but this
+		 * is probably the best we can do here.
+		 */
+		switch (state->fault) {
+		case FAULT_INPUT_OVP:
+		case FAULT_INPUT_UVLO:
+		case FAULT_INPUT_LDO_LOW:
+			state->power_good = false;
+			break;
+		default:
+			state->power_good = true;
+		}
 
 	return 0;
 }
@@ -651,15 +670,18 @@ static int bq24257_power_supply_init(struct bq24257_device *bq)
 	return PTR_ERR_OR_ZERO(bq->charger);
 }
 
-static int bq24257_pg_gpio_probe(struct bq24257_device *bq)
+static void bq24257_pg_gpio_probe(struct bq24257_device *bq)
 {
-	bq->pg = devm_gpiod_get_index(bq->dev, BQ24257_PG_GPIO, 0, GPIOD_IN);
+	bq->pg = devm_gpiod_get_optional(bq->dev, BQ24257_PG_GPIO, GPIOD_IN);
+
 	if (IS_ERR(bq->pg)) {
-		dev_err(bq->dev, "could not probe PG pin\n");
-		return PTR_ERR(bq->pg);
+		dev_err(bq->dev, "error probing PG pin\n");
+		bq->pg = NULL;
+		return;
 	}
 
-	return 0;
+	if (bq->pg)
+		dev_dbg(bq->dev, "probed PG pin = %d\n", desc_to_gpio(bq->pg));
 }
 
 static int bq24257_fw_probe(struct bq24257_device *bq)
@@ -789,10 +811,17 @@ static int bq24257_probe(struct i2c_client *client,
 		INIT_DELAYED_WORK(&bq->iilimit_setup_work,
 				  bq24257_iilimit_setup_work);
 
-	/* we can only check Power Good status by probing the PG pin */
-	ret = bq24257_pg_gpio_probe(bq);
-	if (ret < 0)
-		return ret;
+	/*
+	 * The BQ24250 doesn't have a dedicated Power Good (PG) pin so let's
+	 * not probe for it and instead use a SW-based approach to determine
+	 * the PG state. We also use a SW-based approach for all other devices
+	 * if the PG pin is either not defined or can't be probed.
+	 */
+	if (bq->chip != BQ24250)
+		bq24257_pg_gpio_probe(bq);
+
+	if (!bq->pg)
+		dev_info(bq->dev, "using SW-based power-good detection\n");
 
 	/* reset all registers to defaults */
 	ret = bq24257_field_write(bq, F_RESET, 1);
-- 
1.9.1
