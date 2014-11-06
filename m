From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v3 2/4] mfd: max77693: Add defines for MAX77693 charger
 driver
Date: Thu, 06 Nov 2014 16:11:58 +0100
Message-ID: <1415286720-6358-3-git-send-email-k.kozlowski@samsung.com>
References: <1415286720-6358-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1415286720-6358-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Prepare for adding support for Maxim 77693 charger by adding necessary
new defines and structure for device tree parsed data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693-private.h | 108 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   8 +++
 2 files changed, 116 insertions(+)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 6392a1565452..7952a12ad64b 100644
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
 
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585cd874..88ef24b28294 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -63,6 +63,14 @@ struct max77693_muic_platform_data {
 	int path_uart;
 };
 
+struct max77693_charger_platform_data {
+	u32 constant_volt;
+	u32 min_system_volt;
+	u32 thermal_regulation_temp;
+	u32 batttery_overcurrent;
+	u32 charge_input_threshold_volt;
+};
+
 /* MAX77693 led flash */
 
 /* triggers */
-- 
1.9.1
