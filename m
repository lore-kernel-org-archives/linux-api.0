From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v6 7/8] devicetree: mfd: max14577: Add device tree bindings
 document
Date: Fri, 12 Sep 2014 08:53:59 +0200
Message-ID: <1410504840-23543-8-git-send-email-k.kozlowski@samsung.com>
References: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Add document describing device tree bindings for MAX14577 MFD
drivers: MFD core, extcon, regulator and charger.

Both MAX14577 and MAX77836 chipsets are documented.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: devicetree@vger.kernel.org
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/devicetree/bindings/mfd/max14577.txt | 146 +++++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

diff --git a/Documentation/devicetree/bindings/mfd/max14577.txt b/Documentation/devicetree/bindings/mfd/max14577.txt
new file mode 100644
index 000000000000..236264c10b92
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max14577.txt
@@ -0,0 +1,146 @@
+Maxim MAX14577/77836 Multi-Function Device
+
+MAX14577 is a Multi-Function Device with Micro-USB Interface Circuit, Li+
+Battery Charger and SFOUT LDO output for powering USB devices. It is
+interfaced to host controller using I2C.
+
+MAX77836 additionally contains PMIC (with two LDO regulators) and Fuel Gauge.
+
+
+Required properties:
+- compatible : Must be "maxim,max14577" or "maxim,max77836".
+- reg : I2C slave address for the max14577 chip (0x25 for max14577/max77836)
+- interrupts : IRQ line for the chip.
+- interrupt-parent :  The parent interrupt controller.
+
+
+Required nodes:
+ - charger :
+	Node for configuring the charger driver.
+	Required properties:
+		- compatible : "maxim,max14577-charger"
+			or "maxim,max77836-charger"
+		- maxim,fast-charge-uamp : Current in uA for Fast Charge;
+			Valid values:
+			- for max14577: 90000 - 950000;
+			- for max77836: 45000 - 475000;
+		- maxim,eoc-uamp : Current in uA for End-Of-Charge mode;
+			Valid values:
+			- for max14577: 50000 - 200000;
+			- for max77836: 5000 - 100000;
+		- maxim,ovp-uvolt : OverVoltage Protection Threshold in uV;
+			In an overvoltage condition, INT asserts and charging
+			stops. Valid values:
+			- 6000000, 6500000, 7000000, 7500000;
+		- maxim,constant-uvolt : Battery Constant Voltage in uV;
+			Valid values:
+			- 4000000 - 4280000 (step by 20000);
+			- 4350000;
+
+
+Optional nodes:
+- max14577-muic/max77836-muic :
+	Node used only by extcon consumers.
+	Required properties:
+		- compatible : "maxim,max14577-muic" or "maxim,max77836-muic"
+
+- regulators :
+	Required properties:
+		- compatible : "maxim,max14577-regulator"
+			or "maxim,max77836-regulator"
+
+	May contain a sub-node per regulator from the list below. Each
+	sub-node should contain the constraints and initialization information
+	for that regulator. See regulator.txt for a description of standard
+	properties for these sub-nodes.
+
+	List of valid regulator names:
+	- for max14577: CHARGER, SAFEOUT.
+	- for max77836: CHARGER, SAFEOUT, LDO1, LDO2.
+
+	The SAFEOUT is a fixed voltage regulator so there is no need to specify
+	voltages for it.
+
+
+Example:
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+max14577@25 {
+	compatible = "maxim,max14577";
+	reg = <0x25>;
+	interrupt-parent = <&gpx1>;
+	interrupts = <5 IRQ_TYPE_NONE>;
+
+	muic: max14577-muic {
+		compatible = "maxim,max14577-muic";
+	};
+
+	regulators {
+		compatible = "maxim,max14577-regulator";
+
+		SAFEOUT {
+			regulator-name = "SAFEOUT";
+		};
+		CHARGER {
+			regulator-name = "CHARGER";
+			regulator-min-microamp = <90000>;
+			regulator-max-microamp = <950000>;
+			regulator-boot-on;
+		};
+	};
+
+	charger {
+		compatible = "maxim,max14577-charger";
+
+		maxim,constant-uvolt = <4350000>;
+		maxim,fast-charge-uamp = <450000>;
+		maxim,eoc-uamp = <50000>;
+		maxim,ovp-uvolt = <6500000>;
+	};
+};
+
+
+max77836@25 {
+	compatible = "maxim,max77836";
+	reg = <0x25>;
+	interrupt-parent = <&gpx1>;
+	interrupts = <5 IRQ_TYPE_NONE>;
+
+	muic: max77836-muic {
+		compatible = "maxim,max77836-muic";
+	};
+
+	regulators {
+		compatible = "maxim,max77836-regulator";
+
+		SAFEOUT {
+			regulator-name = "SAFEOUT";
+		};
+		CHARGER {
+			regulator-name = "CHARGER";
+			regulator-min-microamp = <90000>;
+			regulator-max-microamp = <950000>;
+			regulator-boot-on;
+		};
+		LDO1 {
+			regulator-name = "LDO1";
+			regulator-min-microvolt = <2700000>;
+			regulator-max-microvolt = <2700000>;
+		};
+		LDO2 {
+			regulator-name = "LDO2";
+			regulator-min-microvolt = <800000>;
+			regulator-max-microvolt = <3950000>;
+		};
+	};
+
+	charger {
+		compatible = "maxim,max77836-charger";
+
+		maxim,constant-uvolt = <4350000>;
+		maxim,fast-charge-uamp = <225000>;
+		maxim,eoc-uamp = <7500>;
+		maxim,ovp-uvolt = <6500000>;
+	};
+};
-- 
1.9.1
