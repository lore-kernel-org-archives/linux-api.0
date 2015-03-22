From: NeilBrown <neil@brown.name>
Subject: [PATCH 05/14] twl4030_charger: split uA calculation into a function.
Date: Mon, 23 Mar 2015 10:20:28 +1100
Message-ID: <20150322232028.23789.60327.stgit@notabene.brown>
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

We will need this calculation in other places, so
create functions to map between register value and uA value.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/power/twl4030_charger.c |   48 ++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 0e62a5ae56a3..c9a7efbb9141 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -178,6 +178,40 @@ static int twl4030_is_battery_present(struct twl4030_bci *bci)
 }
 
 /*
+ * TI provided formulas:
+ * CGAIN == 0: ICHG = (BCIICHG * 1.7) / (2^10 - 1) - 0.85
+ * CGAIN == 1: ICHG = (BCIICHG * 3.4) / (2^10 - 1) - 1.7
+ * Here we use integer approximation of:
+ * CGAIN == 0: val * 1.6618 - 0.85 * 1000
+ * CGAIN == 1: (val * 1.6618 - 0.85 * 1000) * 2
+ */
+/*
+ * convert twl register value for currents into uA
+ */
+static int regval2ua(int regval, bool cgain)
+{
+	if (cgain)
+		return (regval * 16618 - 8500 * 1000) / 5;
+	else
+		return (regval * 16618 - 8500 * 1000) / 10;
+}
+
+/*
+ * convert uA currents into twl register value
+ */
+static int ua2regval(int ua, bool cgain)
+{
+	int ret;
+	if (cgain)
+		ua /= 2;
+	ret = (ua * 10 + 8500 * 1000) / 16618;
+	/* rounding problems */
+	if (ret < 512)
+		ret = 512;
+	return ret;
+}
+
+/*
  * Enable/Disable USB Charge functionality.
  */
 static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
@@ -366,14 +400,6 @@ static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long val,
 	return NOTIFY_OK;
 }
 
-/*
- * TI provided formulas:
- * CGAIN == 0: ICHG = (BCIICHG * 1.7) / (2^10 - 1) - 0.85
- * CGAIN == 1: ICHG = (BCIICHG * 3.4) / (2^10 - 1) - 1.7
- * Here we use integer approximation of:
- * CGAIN == 0: val * 1.6618 - 0.85
- * CGAIN == 1: (val * 1.6618 - 0.85) * 2
- */
 static int twl4030_charger_get_current(void)
 {
 	int curr;
@@ -388,11 +414,7 @@ static int twl4030_charger_get_current(void)
 	if (ret)
 		return ret;
 
-	ret = (curr * 16618 - 850 * 10000) / 10;
-	if (bcictl1 & TWL4030_CGAIN)
-		ret *= 2;
-
-	return ret;
+	return regval2ua(curr, bcictl1 & TWL4030_CGAIN);
 }
 
 /*
