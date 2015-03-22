From: NeilBrown <neil@brown.name>
Subject: [PATCH 06/14] twl4030_charger: allow fine control of charger
 current.
Date: Mon, 23 Mar 2015 10:20:29 +1100
Message-ID: <20150322232028.23789.12970.stgit@notabene.brown>
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

The twl4030 allows control of the incoming current.
Part of this control is a 'CGAIN' setting which doubles
the range for half the precision.  This control affects
several different current setting, so all need to be updated
at once when CGAIN is changed.

With this patch, all of these current setting are managed
by the driver, but most are left at their default settings.

The current drawn is set to 500mA if the allow_usb module parameter is
set, and to 100mA otherwise.
More fine control will appear in later patches.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/power/twl4030_charger.c |  168 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 160 insertions(+), 8 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index c9a7efbb9141..02d677ef63e2 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -31,6 +31,11 @@
 #define TWL4030_BCIMFSTS4	0x10
 #define TWL4030_BCICTL1		0x23
 #define TWL4030_BB_CFG		0x12
+#define TWL4030_BCIIREF1	0x27
+#define TWL4030_BCIIREF2	0x28
+#define TWL4030_BCIMFKEY	0x11
+#define TWL4030_BCIMFTH8	0x1d
+#define TWL4030_BCIMFTH9	0x1e
 
 #define TWL4030_BCIMFSTS1	0x01
 
@@ -95,6 +100,12 @@ struct twl4030_bci {
 	int			irq_bci;
 	int			usb_enabled;
 
+	/*
+	 * ichg values in uA. If any are 'large', we set CGAIN to
+	 * '1' which doubles the range for half the precision.
+	 */
+	unsigned int		ichg_eoc, ichg_lo, ichg_hi, cur;
+
 	unsigned long		event;
 };
 
@@ -211,6 +222,146 @@ static int ua2regval(int ua, bool cgain)
 	return ret;
 }
 
+static int twl4030_charger_update_current(struct twl4030_bci *bci)
+{
+	int status;
+	unsigned reg, cur_reg;
+	u8 bcictl1, oldreg, fullreg;
+	bool cgain = false;
+	u8 boot_bci;
+
+	/* First, check thresholds and see if cgain is needed */
+	if (bci->ichg_eoc >= 200000)
+		cgain = true;
+	if (bci->ichg_lo >= 400000)
+		cgain = true;
+	if (bci->ichg_hi >= 820000)
+		cgain = true;
+	if (bci->cur > 852000)
+		cgain = true;
+
+	status = twl4030_bci_read(TWL4030_BCICTL1, &bcictl1);
+	if (status < 0)
+		return status;
+	if (twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &boot_bci,
+			    TWL4030_PM_MASTER_BOOT_BCI) < 0)
+		boot_bci = 0;
+	boot_bci &= 7;
+
+	if ((!!cgain) != !!(bcictl1 & TWL4030_CGAIN))
+		/* Need to turn for charging while we change the
+		 * CGAIN bit.  Leave it off while everything is
+		 * updated.
+		 */
+		twl4030_clear_set_boot_bci(boot_bci, 0);
+
+	/*
+	 * For ichg_eoc, the hardware only supports reg values matching
+	 * 100XXXX000, and requires the XXXX be stored in the high nibble
+	 * of TWL4030_BCIMFTH8
+	 */
+	reg = ua2regval(bci->ichg_eoc, cgain);
+	if (reg > 0x278)
+		reg = 0x278;
+	if (reg < 0x200)
+		reg = 0x200;
+	reg = (reg >> 3) & 0xf;
+	fullreg = reg << 4;
+
+	/*
+	 * For ichg_lo, reg value must match 10XXXX0000.
+	 * XXXX is stored in low nibble of TWL4030_BCIMFTH8
+	 */
+	reg = ua2regval(bci->ichg_lo, cgain);
+	if (reg > 0x2F0)
+		reg = 0x2F0;
+	if (reg < 0x200)
+		reg = 0x200;
+	reg = (reg >> 4) & 0xf;
+	fullreg |= reg;
+
+	/* ichg_eoc and ichg_lo live in same register */
+	status = twl4030_bci_read(TWL4030_BCIMFTH8, &oldreg);
+	if (status < 0)
+		return status;
+	if (oldreg != fullreg) {
+		status = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0xF4,
+					  TWL4030_BCIMFKEY);
+		if (status < 0)
+			return status;
+		twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
+				 fullreg, TWL4030_BCIMFTH8);
+	}
+
+	/* ichg_hi threshold must be 1XXXX01100 (I think) */
+	reg = ua2regval(bci->ichg_hi, cgain);
+	if (reg > 0x3E0)
+		reg = 0x3E0;
+	if (reg < 0x200)
+		reg = 0x200;
+	fullreg = (reg >> 5) & 0xF;
+	fullreg <<= 4;
+	status = twl4030_bci_read(TWL4030_BCIMFTH9, &oldreg);
+	if (status < 0)
+		return status;
+	if ((oldreg & 0xF0) != fullreg) {
+		fullreg |= (oldreg & 0x0F);
+		status = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0xE7,
+					  TWL4030_BCIMFKEY);
+		if (status < 0)
+			return status;
+		twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
+				 fullreg, TWL4030_BCIMFTH9);
+	}
+
+	/*
+	 * And finally, set the current.  This is stored in
+	 * two registers.
+	 */
+	reg = ua2regval(bci->cur, cgain);
+	/* we have only 10 bits */
+	if (reg > 0x3ff)
+		reg = 0x3ff;
+	status = twl4030_bci_read(TWL4030_BCIIREF1, &oldreg);
+	if (status < 0)
+		return status;
+	cur_reg = oldreg;
+	status = twl4030_bci_read(TWL4030_BCIIREF2, &oldreg);
+	if (status < 0)
+		return status;
+	cur_reg |= oldreg << 8;
+	if (reg != oldreg) {
+		/* disable write protection for one write access for
+		 * BCIIREF */
+		status = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0xE7,
+					  TWL4030_BCIMFKEY);
+		if (status < 0)
+			return status;
+		status = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
+					  (reg & 0x100) ? 3 : 2,
+					  TWL4030_BCIIREF2);
+		if (status < 0)
+			return status;
+		/* disable write protection for one write access for
+		 * BCIIREF */
+		status = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE, 0xE7,
+					  TWL4030_BCIMFKEY);
+		if (status < 0)
+			return status;
+		status = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
+					  reg & 0xff,
+					  TWL4030_BCIIREF1);
+	}
+	if ((!!cgain) != !!(bcictl1 & TWL4030_CGAIN)) {
+		/* Flip CGAIN and re-enable charging */
+		bcictl1 ^= TWL4030_CGAIN;
+		twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
+				 bcictl1, TWL4030_BCICTL1);
+		twl4030_clear_set_boot_bci(0, boot_bci);
+	}
+	return 0;
+}
+
 /*
  * Enable/Disable USB Charge functionality.
  */
@@ -219,14 +370,6 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 	int ret;
 
 	if (enable && !IS_ERR_OR_NULL(bci->transceiver)) {
-		/*
-		 * Until we can find out what current the device can provide,
-		 * require a module param to enable USB charging.
-		 */
-		if (!allow_usb) {
-			dev_warn(bci->dev, "USB charging is disabled.\n");
-			return -EACCES;
-		}
 
 		/* Need to keep phy powered */
 		if (!bci->usb_enabled) {
@@ -562,6 +705,14 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	if (!pdata)
 		pdata = twl4030_bci_parse_dt(&pdev->dev);
 
+	bci->ichg_eoc = 80100; /* Stop charging when current drops to here */
+	bci->ichg_lo = 241000; /* Low threshold */
+	bci->ichg_hi = 500000; /* High threshold */
+	if (allow_usb)
+		bci->cur = 500000;  /* 500mA */
+	else
+		bci->cur = 100000;  /* 100mA */
+
 	bci->dev = &pdev->dev;
 	bci->irq_chg = platform_get_irq(pdev, 0);
 	bci->irq_bci = platform_get_irq(pdev, 1);
@@ -644,6 +795,7 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
 	if (ret < 0)
 		dev_warn(&pdev->dev, "failed to unmask interrupts: %d\n", ret);
 
+	twl4030_charger_update_current(bci);
 	twl4030_charger_enable_ac(true);
 	if (!IS_ERR_OR_NULL(bci->transceiver))
 		twl4030_bci_usb_ncb(&bci->usb_nb,
