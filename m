From: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Subject: [PATCH 11/14] twl4030_charger: add software controlled linear
 charging mode.
Date: Mon, 23 Mar 2015 10:20:29 +1100
Message-ID: <20150322232029.23789.89694.stgit@notabene.brown>
References: <20150322231635.23789.70149.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150322231635.23789.70149.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, inux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

Add a 'continuous' option for usb charging which enables
the "linear" charging mode of the twl4030.

Linear charging does a good job with not-so-reliable power sources.
Auto mode does not work well as it switches off when voltage drops
momentarily.  Care must be taken not to over-charge.

It was used with a bike hub dynamo since a year or so. In that case
there are automatically charging stops when the cyclist needs a break.

Orignal-by: Andreas Kemnade <andreas-cLv4Z9ELZ06ZuzBka8ofvg@public.gmane.org>
Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
---
 .../ABI/testing/sysfs-class-power-twl4030          |    9 +++
 drivers/power/twl4030_charger.c                    |   55 ++++++++++++++++++--
 2 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power-twl4030 b/Documentation/ABI/testing/sysfs-class-power-twl4030
index 390db7a55231..c27e8ca8c9db 100644
--- a/Documentation/ABI/testing/sysfs-class-power-twl4030
+++ b/Documentation/ABI/testing/sysfs-class-power-twl4030
@@ -24,3 +24,12 @@ Description:
 		"auto" - draw power as appropriate for detected
 			 power source and battery status.
 		"off"  - do not draw any power.
+		"continuous"
+		       - activate mode described as "linear" in
+		         TWL data sheets.  This uses whatever
+			 current is available and doesn't switch off
+			 when voltage drops.
+
+			 This is useful for unstable power sources
+			 such as bicycle dynamo, but care should
+			 be taken that battery is not over-charged.
diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 802cdd6d3e00..2c8d85102def 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -24,6 +24,8 @@
 #include <linux/usb/otg.h>
 #include <linux/i2c/twl4030-madc.h>
 
+#define TWL4030_BCIMDEN		0x00
+#define TWL4030_BCIMDKEY	0x01
 #define TWL4030_BCIMSTATEC	0x02
 #define TWL4030_BCIICHG		0x08
 #define TWL4030_BCIVAC		0x0a
@@ -35,13 +37,16 @@
 #define TWL4030_BCIIREF1	0x27
 #define TWL4030_BCIIREF2	0x28
 #define TWL4030_BCIMFKEY	0x11
+#define TWL4030_BCIMFEN3	0x14
 #define TWL4030_BCIMFTH8	0x1d
 #define TWL4030_BCIMFTH9	0x1e
+#define TWL4030_BCIWDKEY	0x21
 
 #define TWL4030_BCIMFSTS1	0x01
 
 #define TWL4030_BCIAUTOWEN	BIT(5)
 #define TWL4030_CONFIG_DONE	BIT(4)
+#define TWL4030_CVENAC		BIT(2)
 #define TWL4030_BCIAUTOUSB	BIT(1)
 #define TWL4030_BCIAUTOAC	BIT(0)
 #define TWL4030_CGAIN		BIT(5)
@@ -112,12 +117,13 @@ struct twl4030_bci {
 	int			usb_mode; /* charging mode requested */
 #define	CHARGE_OFF	0
 #define	CHARGE_AUTO	1
+#define	CHARGE_LINEAR	2
 
 	unsigned long		event;
 };
 
 /* strings for 'usb_mode' values */
-static char *modes[] = { "off", "auto" };
+static char *modes[] = { "off", "auto", "continuous" };
 
 /*
  * clear and set bits on an given register on a given module
@@ -404,16 +410,42 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 			bci->usb_enabled = 1;
 		}
 
-		/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
-		ret = twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOUSB);
-		if (ret < 0)
-			return ret;
+		if (bci->usb_mode == CHARGE_AUTO)
+			/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
+			ret = twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOUSB);
 
 		/* forcing USBFASTMCHG(BCIMFSTS4[2]) to 1 */
 		ret = twl4030_clear_set(TWL_MODULE_MAIN_CHARGE, 0,
 			TWL4030_USBFASTMCHG, TWL4030_BCIMFSTS4);
+		if (bci->usb_mode == CHARGE_LINEAR) {
+			twl4030_clear_set_boot_bci(TWL4030_BCIAUTOAC|TWL4030_CVENAC, 0);
+			/* Watch dog key: WOVF acknowledge */
+			ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0x33,
+					       TWL4030_BCIWDKEY);
+			/* 0x24 + EKEY6: off mode */
+			ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0x2a,
+					       TWL4030_BCIMDKEY);
+			/* EKEY2: Linear charge: USB path */
+			ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0x26,
+					       TWL4030_BCIMDKEY);
+			/* WDKEY5: stop watchdog count */
+			ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0xf3,
+					       TWL4030_BCIWDKEY);
+			/* enable MFEN3 access */
+			ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0x9c,
+					       TWL4030_BCIMFKEY);
+			 /* ICHGEOCEN - end-of-charge monitor (current < 80mA)
+			  *                      (charging continues)
+			  * ICHGLOWEN - current level monitor (charge continues)
+			  * don't monitor over-current or heat save
+			  */
+			ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0xf0,
+					       TWL4030_BCIMFEN3);
+		}
 	} else {
 		ret = twl4030_clear_set_boot_bci(TWL4030_BCIAUTOUSB, 0);
+		ret |= twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0x2a,
+					TWL4030_BCIMDKEY);
 		if (bci->usb_enabled) {
 			pm_runtime_mark_last_busy(bci->transceiver->dev);
 			pm_runtime_put_autosuspend(bci->transceiver->dev);
@@ -657,6 +689,8 @@ twl4030_bci_mode_store(struct device *dev, struct device_attribute *attr,
 		mode = 0;
 	else if (sysfs_streq(buf, modes[1]))
 		mode = 1;
+	else if (sysfs_streq(buf, modes[2]))
+		mode = 2;
 	else
 		return -EINVAL;
 	twl4030_charger_enable_usb(bci, false);
@@ -755,6 +789,17 @@ static int twl4030_bci_get_property(struct power_supply *psy,
 		is_charging = state & TWL4030_MSTATEC_USB;
 	else
 		is_charging = state & TWL4030_MSTATEC_AC;
+	if (!is_charging) {
+		u8 s;
+		twl4030_bci_read(TWL4030_BCIMDEN, &s);
+		if (psy->type == POWER_SUPPLY_TYPE_USB)
+			is_charging = s & 1;
+		else
+			is_charging = s & 2;
+		if (is_charging)
+			/* A little white lie */
+			state = TWL4030_MSTATEC_QUICK1;
+	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
