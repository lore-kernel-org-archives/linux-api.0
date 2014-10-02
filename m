From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/7] devicetree: mfd: max77693: Document new bindings for
 charger
Date: Thu, 02 Oct 2014 14:22:04 +0200
Message-ID: <1412252528-30148-4-git-send-email-k.kozlowski@samsung.com>
References: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Document new device tree bindings for for Maxim 77693 charger driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/max77693.txt | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc417bf..d0c3d787df12 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,42 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+- charger : Node configuring the charger driver.
+  If present, required properties:
+  - compatible : Must be "maxim,max77693-charger".
+
+  Optional properties (if not set, defaults will be used):
+  - maxim,constant-microvolt : Battery constant voltage in uV. The charger
+    will operate in fast charge constant current mode till battery voltage
+    reaches this level. Then the charger will switch to fast charge constant
+    voltage mode. Also vsys (system voltage) will be set to this value when
+    DC power is supplied but charger is not enabled.
+    Valid values: 3650000 - 4400000, step by 25000 (rounded down)
+    Default: 4200000
+
+  - maxim,min-system-microvolt : Minimal system voltage in uV.
+    Valid values: 3000000 - 3700000, step by 100000 (rounded down)
+    Default: 3600000
+
+  - maxim,thermal-regulation-celsius : Temperature in Celsius for entering
+    high temperature charging mode. If die temperature exceeds this value
+    the charging current will be reduced by 105 mA/Celsius.
+    Valid values: 70, 85, 100, 115
+    Default: 100
+
+  - maxim,battery-overcurrent-microamp : Overcurrent protection threshold
+    in uA (current from battery to system).
+    Valid values: 2000000 - 3500000, step by 250000 (rounded down)
+    Default: 3500000
+
+  - maxim,charge-input-threshold-microvolt : Threshold voltage in uV for
+    triggering input voltage regulation loop. If input voltage decreases
+    below this value, the input current will be reduced to reach the
+    threshold voltage.
+    Valid values: 4300000, 4700000, 4800000, 4900000
+    Default: 4300000
+
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +88,14 @@ Example:
 					regulator-boot-on;
 			};
 		};
+
+		charger {
+			compatible = "maxim,max77693-charger";
+
+			maxim,constant-microvolt = <4200000>;
+			maxim,min-system-microvolt = <3600000>;
+			maxim,thermal-regulation-celsius = <75>;
+			maxim,battery-overcurrent-microamp = <3000000>;
+			maxim,charge-input-threshold-microvolt = <4300000>;
+		};
 	};
-- 
1.9.1
