From: NeilBrown <neil@brown.name>
Subject: [PATCH 13/14] twl4030_charger: Increase current carefully while
 watching voltage.
Date: Mon, 23 Mar 2015 10:20:29 +1100
Message-ID: <20150322232029.23789.30185.stgit@notabene.brown>
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

The USB Battery Charging spec (BC1.2) suggests a dedicated
charging port can deliver from 0.5 to 5.0A at between 4.75 and 5.25
volts.

To choose the "correct" current voltage setting requires a trial
and error approach: try to draw current and see if the voltage drops
too low.

Even with a configured Standard Downstream Port, it may not be possible
to reliably pull 500mA - depending on cable quality and source
quality I have reports of charging failure due to the voltage dropping
too low.

To address both these concerns, this patch introduce incremental
current setting.
The current pull from VBUS is increased in steps of 20mA every 100ms
until the target is reached or until the measure voltage drops below
4.75V.  If the voltage does go too low, the target current is reduced
by 20mA and kept there.

This applies to currents selected automatically, or to values
set via sysfs.  So setting a large value will cause the maximum
available to be used - up to the limit of 1.7A imposed by the
hardware.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/power/twl4030_charger.c |   68 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 8 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 73c7cd96ebc1..d0199495dddc 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -119,6 +119,18 @@ struct twl4030_bci {
 #define	CHARGE_AUTO	1
 #define	CHARGE_LINEAR	2
 
+	/* When setting the USB current we slowly increase the
+	 * requested current until target is reached or the voltage
+	 * drops below 4.75V.  In the latter case we step back one
+	 * step.
+	 */
+	unsigned int		usb_cur_target;
+	struct delayed_work	current_worker;
+#define	USB_CUR_STEP	20000	/* 20mA at a time */
+#define	USB_MIN_VOLT	4750000	/* 4.75V */
+#define	USB_CUR_DELAY	msecs_to_jiffies(100)
+#define	USB_MAX_CURRENT	1700000 /* TWL4030 caps at 1.7A */
+
 	unsigned long		event;
 };
 
@@ -257,6 +269,12 @@ static int twl4030_charger_update_current(struct twl4030_bci *bci)
 	} else {
 		cur = bci->usb_cur;
 		bci->ac_is_active = false;
+		if (cur > bci->usb_cur_target) {
+			cur = bci->usb_cur_target;
+			bci->usb_cur = cur;
+		}
+		if (cur < bci->usb_cur_target)
+			schedule_delayed_work(&bci->current_worker, USB_CUR_DELAY);
 	}
 
 	/* First, check thresholds and see if cgain is needed */
@@ -391,6 +409,38 @@ static int twl4030_charger_update_current(struct twl4030_bci *bci)
 	return 0;
 }
 
+static void twl4030_current_worker(struct work_struct *data)
+{
+	int v;
+	int res;
+	struct twl4030_bci *bci = container_of(data, struct twl4030_bci,
+					       current_worker.work);
+
+	res = twl4030bci_read_adc_val(TWL4030_BCIVBUS);
+	if (res < 0)
+		v = 0;
+	else
+		/* BCIVBUS uses ADCIN8, 7/1023 V/step */
+		v = res * 6843;
+
+	printk("v=%d cur=%d target=%d\n", v, bci->usb_cur,
+	       bci->usb_cur_target);
+
+	if (v < USB_MIN_VOLT) {
+		/* Back up and stop adjusting. */
+		bci->usb_cur -= USB_CUR_STEP;
+		bci->usb_cur_target = bci->usb_cur;
+	} else if (bci->usb_cur >= bci->usb_cur_target ||
+		   bci->usb_cur + USB_CUR_STEP > USB_MAX_CURRENT) {
+		/* Reached target and voltage is OK - stop */
+		return;
+	} else {
+		bci->usb_cur += USB_CUR_STEP;
+		schedule_delayed_work(&bci->current_worker, USB_CUR_DELAY);
+	}
+	twl4030_charger_update_current(bci);
+}
+
 /*
  * Enable/Disable USB Charge functionality.
  */
@@ -451,6 +501,7 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 			pm_runtime_put_autosuspend(bci->transceiver->dev);
 			bci->usb_enabled = 0;
 		}
+		bci->usb_cur = 0;
 	}
 
 	return ret;
@@ -599,7 +650,7 @@ twl4030_bci_max_current_store(struct device *dev, struct device_attribute *attr,
 	if (dev == bci->ac.dev)
 		bci->ac_cur = cur;
 	else
-		bci->usb_cur = cur;
+		bci->usb_cur_target = cur;
 
 	twl4030_charger_update_current(bci);
 	return n;
@@ -621,7 +672,7 @@ static ssize_t twl4030_bci_max_current_show(struct device *dev,
 			cur = bci->ac_cur;
 	} else {
 		if (bci->ac_is_active)
-			cur = bci->usb_cur;
+			cur = bci->usb_cur_target;
 	}
 	if (cur < 0) {
 		cur = twl4030bci_read_adc_val(TWL4030_BCIIREF1);
@@ -664,14 +715,14 @@ static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long val,
 
 	/* reset current on each 'plug' event */
 	if (allow_usb)
-		bci->usb_cur = 500000;
+		bci->usb_cur_target = 500000;
 	else
-		bci->usb_cur = 100000;
+		bci->usb_cur_target = 100000;
 
 	bci->event = val;
 	if (val == USB_EVENT_ENUMERATED && vbus_draw &&
-	    *vbus_draw * 1000 > bci->usb_cur)
-		bci->usb_cur = *vbus_draw * 1000;
+	    *vbus_draw * 1000 > bci->usb_cur_target)
+		bci->usb_cur_target = *vbus_draw * 1000;
 	schedule_work(&bci->work);
 
 	return NOTIFY_OK;
@@ -916,9 +967,9 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	bci->ichg_hi = 500000; /* High threshold */
 	bci->ac_cur = 500000; /* 500mA */
 	if (allow_usb)
-		bci->usb_cur = 500000;  /* 500mA */
+		bci->usb_cur_target = 500000;  /* 500mA */
 	else
-		bci->usb_cur = 100000;  /* 100mA */
+		bci->usb_cur_target = 100000;  /* 100mA */
 	bci->usb_mode = CHARGE_AUTO;
 	bci->ac_mode = CHARGE_AUTO;
 
@@ -976,6 +1027,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	}
 
 	INIT_WORK(&bci->work, twl4030_bci_usb_work);
+	INIT_DELAYED_WORK(&bci->current_worker, twl4030_current_worker);
 
 	bci->usb_nb.notifier_call = twl4030_bci_usb_ncb;
 	if (bci->dev->of_node) {
