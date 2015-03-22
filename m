From: NeilBrown <neil@brown.name>
Subject: [PATCH 12/14] twl4030_charger: add ac/mode to match usb/mode
Date: Mon, 23 Mar 2015 10:20:29 +1100
Message-ID: <20150322232029.23789.49855.stgit@notabene.brown>
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

This allows AC charging to be turned off, much like usb charging.
"continuous" mode is not available though.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 .../ABI/testing/sysfs-class-power-twl4030          |   10 ++++++
 drivers/power/twl4030_charger.c                    |   35 +++++++++++++++-----
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power-twl4030 b/Documentation/ABI/testing/sysfs-class-power-twl4030
index c27e8ca8c9db..35a211b9a172 100644
--- a/Documentation/ABI/testing/sysfs-class-power-twl4030
+++ b/Documentation/ABI/testing/sysfs-class-power-twl4030
@@ -33,3 +33,13 @@ Description:
 			 This is useful for unstable power sources
 			 such as bicycle dynamo, but care should
 			 be taken that battery is not over-charged.
+
+What: /sys/class/power_supply/twl4030_ac/mode
+Description:
+	Changing mode for 'ac' port.
+	Writing to this can disable charging.
+
+	Possible values are:
+		"auto" - draw power as appropriate for detected
+			 power source and battery status.
+		"off"  - do not draw any power.
diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 2c8d85102def..73c7cd96ebc1 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -114,7 +114,7 @@ struct twl4030_bci {
 	unsigned int		ichg_eoc, ichg_lo, ichg_hi;
 	unsigned int		usb_cur, ac_cur;
 	bool			ac_is_active;
-	int			usb_mode; /* charging mode requested */
+	int			usb_mode, ac_mode; /* charging mode requested */
 #define	CHARGE_OFF	0
 #define	CHARGE_AUTO	1
 #define	CHARGE_LINEAR	2
@@ -459,10 +459,13 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 /*
  * Enable/Disable AC Charge funtionality.
  */
-static int twl4030_charger_enable_ac(bool enable)
+static int twl4030_charger_enable_ac(struct twl4030_bci *bci, bool enable)
 {
 	int ret;
 
+	if (bci->ac_mode == CHARGE_OFF)
+		enable = false;
+
 	if (enable)
 		ret = twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOAC);
 	else
@@ -693,9 +696,17 @@ twl4030_bci_mode_store(struct device *dev, struct device_attribute *attr,
 		mode = 2;
 	else
 		return -EINVAL;
-	twl4030_charger_enable_usb(bci, false);
-	bci->usb_mode = mode;
-	status = twl4030_charger_enable_usb(bci, true);
+	if (dev == bci->ac.dev) {
+		if (mode == 2)
+			return -EINVAL;
+		twl4030_charger_enable_ac(bci, false);
+		bci->ac_mode = mode;
+		status = twl4030_charger_enable_ac(bci, true);
+	} else {
+		twl4030_charger_enable_usb(bci, false);
+		bci->usb_mode = mode;
+		status = twl4030_charger_enable_usb(bci, true);
+	}
 	return (status == 0) ? n : status;
 }
 
@@ -709,9 +720,13 @@ twl4030_bci_mode_show(struct device *dev,
 	struct twl4030_bci *bci = dev_get_drvdata(dev->parent);
 	int len = 0;
 	int i;
+	int mode = bci->usb_mode;
+
+	if (dev == bci->ac.dev)
+		mode = bci->ac_mode;
 
 	for (i = 0; i < ARRAY_SIZE(modes); i++)
-		if (bci->usb_mode == i)
+		if (mode == i)
 			len += snprintf(buf+len, PAGE_SIZE-len,
 					"[%s] ", modes[i]);
 		else
@@ -905,6 +920,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	else
 		bci->usb_cur = 100000;  /* 100mA */
 	bci->usb_mode = CHARGE_AUTO;
+	bci->ac_mode = CHARGE_AUTO;
 
 	bci->dev = &pdev->dev;
 	bci->irq_chg = platform_get_irq(pdev, 0);
@@ -993,10 +1009,12 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
 	if (device_create_file(bci->usb.dev, &dev_attr_mode))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
+	if (device_create_file(bci->ac.dev, &dev_attr_mode))
+		dev_warn(&pdev->dev, "could not create sysfs file\n");
 	if (device_create_file(bci->ac.dev, &dev_attr_max_current))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
 
-	twl4030_charger_enable_ac(true);
+	twl4030_charger_enable_ac(bci, true);
 	if (!IS_ERR_OR_NULL(bci->transceiver))
 		twl4030_bci_usb_ncb(&bci->usb_nb,
 				    bci->transceiver->last_event,
@@ -1016,13 +1034,14 @@ static int __exit twl4030_bci_remove(struct platform_device *pdev)
 {
 	struct twl4030_bci *bci = platform_get_drvdata(pdev);
 
-	twl4030_charger_enable_ac(false);
+	twl4030_charger_enable_ac(bci, false);
 	twl4030_charger_enable_usb(bci, false);
 	twl4030_charger_enable_backup(0, 0);
 
 	device_remove_file(bci->usb.dev, &dev_attr_max_current);
 	device_remove_file(bci->usb.dev, &dev_attr_mode);
 	device_remove_file(bci->ac.dev, &dev_attr_max_current);
+	device_remove_file(bci->ac.dev, &dev_attr_mode);
 	/* mask interrupts */
 	twl_i2c_write_u8(TWL4030_MODULE_INTERRUPTS, 0xff,
 			 TWL4030_INTERRUPTS_BCIIMR1A);
