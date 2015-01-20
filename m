From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v5 2/5] mfd: max77693: Add defines for MAX77693 charger driver
Date: Tue, 20 Jan 2015 11:00:53 +0100
Message-ID: <1421748056-25735-3-git-send-email-k.kozlowski@samsung.com>
References: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1421748056-25735-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Prepare for adding support for Maxim 77693 charger by adding necessary
new defines.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Acked-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/mfd/max77693-private.h | 108 +++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 08dae01258b9..955dd990beaf 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -143,10 +143,118 @@ enum max77693_pmic_reg {
 #define FLASH_INT_FLED1_SHORT	BIT(3)
 #define FLASH_INT_OVER_CURRENT	BIT(4)
 
+/* Fast charge timer in in hours */
+#define DEFAULT_FAST_CHARGE_TIMER		4
+/* microamps */
+#define DEFAULT_TOP_OFF_THRESHOLD_CURRENT	150000
+/* minutes */
+#define DEFAULT_TOP_OFF_TIMER			30
+/* microvolts */
+#define DEFAULT_CONSTANT_VOLT			4200000
+/* microvolts */
+#define DEFAULT_MIN_SYSTEM_VOLT			3600000
+/* celsius */
+#define DEFAULT_THERMAL_REGULATION_TEMP		100
+/* microamps */
+#define DEFAULT_BATTERY_OVERCURRENT		3500000
+/* microvolts */
+#define DEFAULT_CHARGER_INPUT_THRESHOLD_VOLT	4300000
+
+/* MAX77693_CHG_REG_CHG_INT_OK register */
+#define CHG_INT_OK_BYP_SHIFT		0
+#define CHG_INT_OK_BAT_SHIFT		3
+#define CHG_INT_OK_CHG_SHIFT		4
+#define CHG_INT_OK_CHGIN_SHIFT		6
+#define CHG_INT_OK_DETBAT_SHIFT		7
+#define CHG_INT_OK_BYP_MASK		BIT(CHG_INT_OK_BYP_SHIFT)
+#define CHG_INT_OK_BAT_MASK		BIT(CHG_INT_OK_BAT_SHIFT)
+#define CHG_INT_OK_CHG_MASK		BIT(CHG_INT_OK_CHG_SHIFT)
+#define CHG_INT_OK_CHGIN_MASK		BIT(CHG_INT_OK_CHGIN_SHIFT)
+#define CHG_INT_OK_DETBAT_MASK		BIT(CHG_INT_OK_DETBAT_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_DETAILS_00 register */
+#define CHG_DETAILS_00_CHGIN_SHIFT	5
+#define CHG_DETAILS_00_CHGIN_MASK	(0x3 << CHG_DETAILS_00_CHGIN_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_DETAILS_01 register */
+#define CHG_DETAILS_01_CHG_SHIFT	0
+#define CHG_DETAILS_01_BAT_SHIFT	4
+#define CHG_DETAILS_01_TREG_SHIFT	7
+#define CHG_DETAILS_01_CHG_MASK		(0xf << CHG_DETAILS_01_CHG_SHIFT)
+#define CHG_DETAILS_01_BAT_MASK		(0x7 << CHG_DETAILS_01_BAT_SHIFT)
+#define CHG_DETAILS_01_TREG_MASK	BIT(7)
+
+/* MAX77693_CHG_REG_CHG_DETAILS_01/CHG field */
+enum max77693_charger_charging_state {
+	MAX77693_CHARGING_PREQUALIFICATION	= 0x0,
+	MAX77693_CHARGING_FAST_CONST_CURRENT,
+	MAX77693_CHARGING_FAST_CONST_VOLTAGE,
+	MAX77693_CHARGING_TOP_OFF,
+	MAX77693_CHARGING_DONE,
+	MAX77693_CHARGING_HIGH_TEMP,
+	MAX77693_CHARGING_TIMER_EXPIRED,
+	MAX77693_CHARGING_THERMISTOR_SUSPEND,
+	MAX77693_CHARGING_OFF,
+	MAX77693_CHARGING_RESERVED,
+	MAX77693_CHARGING_OVER_TEMP,
+	MAX77693_CHARGING_WATCHDOG_EXPIRED,
+};
+
+/* MAX77693_CHG_REG_CHG_DETAILS_01/BAT field */
+enum max77693_charger_battery_state {
+	MAX77693_BATTERY_NOBAT			= 0x0,
+	/* Dead-battery or low-battery prequalification */
+	MAX77693_BATTERY_PREQUALIFICATION,
+	MAX77693_BATTERY_TIMER_EXPIRED,
+	MAX77693_BATTERY_GOOD,
+	MAX77693_BATTERY_LOWVOLTAGE,
+	MAX77693_BATTERY_OVERVOLTAGE,
+	MAX77693_BATTERY_OVERCURRENT,
+	MAX77693_BATTERY_RESERVED,
+};
+
+/* MAX77693_CHG_REG_CHG_DETAILS_02 register */
+#define CHG_DETAILS_02_BYP_SHIFT	0
+#define CHG_DETAILS_02_BYP_MASK		(0xf << CHG_DETAILS_02_BYP_SHIFT)
+
 /* MAX77693 CHG_CNFG_00 register */
 #define CHG_CNFG_00_CHG_MASK		0x1
 #define CHG_CNFG_00_BUCK_MASK		0x4
 
+/* MAX77693_CHG_REG_CHG_CNFG_01 register */
+#define CHG_CNFG_01_FCHGTIME_SHIFT	0
+#define CHG_CNFG_01_CHGRSTRT_SHIFT	4
+#define CHG_CNFG_01_PQEN_SHIFT		7
+#define CHG_CNFG_01_FCHGTIME_MASK	(0x7 << CHG_CNFG_01_FCHGTIME_SHIFT)
+#define CHG_CNFG_01_CHGRSTRT_MASK	(0x3 << CHG_CNFG_01_CHGRSTRT_SHIFT)
+#define CHG_CNFG_01_PQEN_MAKS		BIT(CHG_CNFG_01_PQEN_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_03 register */
+#define CHG_CNFG_03_TOITH_SHIFT		0
+#define CHG_CNFG_03_TOTIME_SHIFT	3
+#define CHG_CNFG_03_TOITH_MASK		(0x7 << CHG_CNFG_03_TOITH_SHIFT)
+#define CHG_CNFG_03_TOTIME_MASK		(0x7 << CHG_CNFG_03_TOTIME_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_04 register */
+#define CHG_CNFG_04_CHGCVPRM_SHIFT	0
+#define CHG_CNFG_04_MINVSYS_SHIFT	5
+#define CHG_CNFG_04_CHGCVPRM_MASK	(0x1f << CHG_CNFG_04_CHGCVPRM_SHIFT)
+#define CHG_CNFG_04_MINVSYS_MASK	(0x7 << CHG_CNFG_04_MINVSYS_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_06 register */
+#define CHG_CNFG_06_CHGPROT_SHIFT	2
+#define CHG_CNFG_06_CHGPROT_MASK	(0x3 << CHG_CNFG_06_CHGPROT_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_07 register */
+#define CHG_CNFG_07_REGTEMP_SHIFT	5
+#define CHG_CNFG_07_REGTEMP_MASK	(0x3 << CHG_CNFG_07_REGTEMP_SHIFT)
+
+/* MAX77693_CHG_REG_CHG_CNFG_12 register */
+#define CHG_CNFG_12_B2SOVRC_SHIFT	0
+#define CHG_CNFG_12_VCHGINREG_SHIFT	3
+#define CHG_CNFG_12_B2SOVRC_MASK	(0x7 << CHG_CNFG_12_B2SOVRC_SHIFT)
+#define CHG_CNFG_12_VCHGINREG_MASK	(0x3 << CHG_CNFG_12_VCHGINREG_SHIFT)
+
 /* MAX77693 CHG_CNFG_09 Register */
 #define CHG_CNFG_09_CHGIN_ILIM_MASK	0x7F
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
