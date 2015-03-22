From: NeilBrown <neil@brown.name>
Subject: [PATCH 01/14] twl4030_charger: use devm_request_threaded_irq
Date: Mon, 23 Mar 2015 10:20:28 +1100
Message-ID: <20150322232028.23789.97241.stgit@notabene.brown>
References: <20150322231635.23789.70149.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150322231635.23789.70149.stgit@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb@suse.de>

This simplifies the error paths.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/power/twl4030_charger.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index b07f4e2f2dde..58996d252ecf 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -610,21 +610,21 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 		goto fail_register_usb;
 	}
 
-	ret = request_threaded_irq(bci->irq_chg, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, bci->irq_chg, NULL,
 			twl4030_charger_interrupt, IRQF_ONESHOT, pdev->name,
 			bci);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "could not request irq %d, status %d\n",
 			bci->irq_chg, ret);
-		goto fail_chg_irq;
+		goto fail;
 	}
 
-	ret = request_threaded_irq(bci->irq_bci, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, bci->irq_bci, NULL,
 			twl4030_bci_interrupt, IRQF_ONESHOT, pdev->name, bci);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "could not request irq %d, status %d\n",
 			bci->irq_bci, ret);
-		goto fail_bci_irq;
+		goto fail;
 	}
 
 	INIT_WORK(&bci->work, twl4030_bci_usb_work);
@@ -647,7 +647,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 			       TWL4030_INTERRUPTS_BCIIMR1A);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to unmask interrupts: %d\n", ret);
-		goto fail_unmask_interrupts;
+		goto fail;
 	}
 
 	reg = ~(u32)(TWL4030_VBATOV | TWL4030_VBUSOV | TWL4030_ACCHGOV);
@@ -666,11 +666,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail_unmask_interrupts:
-	free_irq(bci->irq_bci, bci);
-fail_bci_irq:
-	free_irq(bci->irq_chg, bci);
-fail_chg_irq:
+fail:
 	power_supply_unregister(&bci->usb);
 fail_register_usb:
 	power_supply_unregister(&bci->ac);
@@ -695,8 +691,6 @@ static int __exit twl4030_bci_remove(struct platform_device *pdev)
 	twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, 0xff,
 			 TWL4030_INTERRUPTS_BCIIMR2A);
 
-	free_irq(bci->irq_bci, bci);
-	free_irq(bci->irq_chg, bci);
 	power_supply_unregister(&bci->usb);
 	power_supply_unregister(&bci->ac);
 	kfree(bci);
