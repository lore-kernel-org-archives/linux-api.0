From: NeilBrown <neil@brown.name>
Subject: [PATCH 02/14] twl4030_charger: use devres for power_supply_register
 and kzalloc.
Date: Mon, 23 Mar 2015 10:20:28 +1100
Message-ID: <20150322232028.23789.38570.stgit@notabene.brown>
References: <20150322231635.23789.70149.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <20150322231635.23789.70149.stgit@notabene.brown>
Sender: linux-omap-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb@suse.de>

Final allocations/registrations are now managed by devres.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/power/twl4030_charger.c |   32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 58996d252ecf..7b6c4000cd30 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -565,7 +565,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	int ret;
 	u32 reg;
 
-	bci = kzalloc(sizeof(*bci), GFP_KERNEL);
+	bci = devm_kzalloc(&pdev->dev, sizeof(*bci), GFP_KERNEL);
 	if (bci == NULL)
 		return -ENOMEM;
 
@@ -580,7 +580,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	ret = twl4030_is_battery_present(bci);
 	if  (ret) {
 		dev_crit(&pdev->dev, "Battery was not detected:%d\n", ret);
-		goto fail_no_battery;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, bci);
@@ -590,10 +590,10 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	bci->ac.num_properties = ARRAY_SIZE(twl4030_charger_props);
 	bci->ac.get_property = twl4030_bci_get_property;
 
-	ret = power_supply_register(&pdev->dev, &bci->ac);
+	ret = devm_power_supply_register(&pdev->dev, &bci->ac);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register ac: %d\n", ret);
-		goto fail_register_ac;
+		return ret;
 	}
 
 	bci->usb.name = "twl4030_usb";
@@ -604,10 +604,10 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 
 	bci->usb_reg = regulator_get(bci->dev, "bci3v1");
 
-	ret = power_supply_register(&pdev->dev, &bci->usb);
+	ret = devm_power_supply_register(&pdev->dev, &bci->usb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register usb: %d\n", ret);
-		goto fail_register_usb;
+		return ret;
 	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, bci->irq_chg, NULL,
@@ -616,7 +616,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "could not request irq %d, status %d\n",
 			bci->irq_chg, ret);
-		goto fail;
+		return ret;
 	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, bci->irq_bci, NULL,
@@ -624,7 +624,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "could not request irq %d, status %d\n",
 			bci->irq_bci, ret);
-		goto fail;
+		return ret;
 	}
 
 	INIT_WORK(&bci->work, twl4030_bci_usb_work);
@@ -647,7 +647,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 			       TWL4030_INTERRUPTS_BCIIMR1A);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to unmask interrupts: %d\n", ret);
-		goto fail;
+		return ret;
 	}
 
 	reg = ~(u32)(TWL4030_VBATOV | TWL4030_VBUSOV | TWL4030_ACCHGOV);
@@ -665,16 +665,6 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 		twl4030_charger_enable_backup(0, 0);
 
 	return 0;
-
-fail:
-	power_supply_unregister(&bci->usb);
-fail_register_usb:
-	power_supply_unregister(&bci->ac);
-fail_register_ac:
-fail_no_battery:
-	kfree(bci);
-
-	return ret;
 }
 
 static int __exit twl4030_bci_remove(struct platform_device *pdev)
@@ -691,10 +681,6 @@ static int __exit twl4030_bci_remove(struct platform_device *pdev)
 	twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, 0xff,
 			 TWL4030_INTERRUPTS_BCIIMR2A);
 
-	power_supply_unregister(&bci->usb);
-	power_supply_unregister(&bci->ac);
-	kfree(bci);
-
 	return 0;
 }
 


