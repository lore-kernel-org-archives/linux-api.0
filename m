From: Andreas Dannenberg <dannenberg@ti.com>
Subject: [PATCH v6 02/14] power: bq24257: Remove IRQ config through stat-gpios
Date: Thu, 24 Sep 2015 22:26:46 -0500
Message-ID: <1443151618-29742-3-git-send-email-dannenberg@ti.com>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>
List-Id: linux-api@vger.kernel.org

At the time the driver was written GpioInt resources in ACPI were not
passed to the driver in client->irq, as opposed to DT enumeration. To
accommodate this use case, a "stat-gpios" property was introduced to
allow configuring the IRQ.

However this issue with ACPI was fixed in commit "845c877 i2c / ACPI:
Assign IRQ for devices that have GpioInt automatically" and makes this
workaround no longer necessary, hence we can remove the support for the
"stat-gpios" property and the associated code from the bq24257 driver.

Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
---
 drivers/power/bq24257_charger.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index 5859bc7..69b53d0 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -36,7 +36,6 @@
 #define BQ24257_REG_7			0x06
 
 #define BQ24257_MANUFACTURER		"Texas Instruments"
-#define BQ24257_STAT_IRQ		"stat"
 #define BQ24257_PG_GPIO			"pg"
 
 #define BQ24257_ILIM_SET_DELAY		1000	/* msec */
@@ -606,19 +605,6 @@ static int bq24257_power_supply_init(struct bq24257_device *bq)
 	return 0;
 }
 
-static int bq24257_irq_probe(struct bq24257_device *bq)
-{
-	struct gpio_desc *stat_irq;
-
-	stat_irq = devm_gpiod_get_index(bq->dev, BQ24257_STAT_IRQ, 0, GPIOD_IN);
-	if (IS_ERR(stat_irq)) {
-		dev_err(bq->dev, "could not probe stat_irq pin\n");
-		return PTR_ERR(stat_irq);
-	}
-
-	return gpiod_to_irq(stat_irq);
-}
-
 static int bq24257_pg_gpio_probe(struct bq24257_device *bq)
 {
 	bq->pg = devm_gpiod_get_index(bq->dev, BQ24257_PG_GPIO, 0, GPIOD_IN);
@@ -740,21 +726,15 @@ static int bq24257_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	if (client->irq <= 0)
-		client->irq = bq24257_irq_probe(bq);
-
-	if (client->irq < 0) {
-		dev_err(dev, "no irq resource found\n");
-		return client->irq;
-	}
-
 	ret = devm_request_threaded_irq(dev, client->irq, NULL,
 					bq24257_irq_handler_thread,
 					IRQF_TRIGGER_FALLING |
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
-					BQ24257_STAT_IRQ, bq);
-	if (ret)
+					"bq24257", bq);
+	if (ret) {
+		dev_err(dev, "Failed to request IRQ #%d\n", client->irq);
 		return ret;
+	}
 
 	ret = bq24257_power_supply_init(bq);
 	if (ret < 0)
-- 
1.9.1

