From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: [PATCH v4 2/8] mfd: da9150: Add DT binding documentation for core
Date: Tue, 25 Nov 2014 18:25:25 +0000
Message-ID: <0fc61953ef0d2d6a7d5c63dae201903570d07276.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
List-Id: linux-api@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/devicetree/bindings/mfd/da9150.txt | 43 ++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt

diff --git a/Documentation/devicetree/bindings/mfd/da9150.txt b/Documentation/devicetree/bindings/mfd/da9150.txt
new file mode 100644
index 0000000..d0588ea
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/da9150.txt
@@ -0,0 +1,43 @@
+Dialog Semiconductor DA9150 Combined Charger/Fuel-Gauge MFD bindings
+
+DA9150 consists of a group of sub-devices:
+
+Device			 Description
+------			 -----------
+da9150-gpadc		: General Purpose ADC
+da9150-charger		: Battery Charger
+
+======
+
+Required properties:
+- compatible : Should be "dlg,da9150"
+- reg: Specifies the I2C slave address
+- interrupt-parent: Specifies the phandle of the interrupt controller to which
+  the IRQs from da9150 are delivered to.
+- interrupts: IRQ line info for da9150 chip.
+- interrupt-controller: da9150 has internal IRQs (own IRQ domain).
+  (See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt for
+   further information relating to interrupt properties)
+
+Sub-devices:
+- da9150-gpadc: See Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
+- da9150-charger: See Documentation/devicetree/bindings/power/da9150-charger.txt
+
+
+Example:
+
+	charger_fg: da9150@58 {
+		compatible = "dlg,da9150";
+		reg = <0x58>;
+		interrupt-parent = <&gpio6>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-controller;
+
+		gpadc: da9150-gpadc {
+			...
+		};
+
+		da9150-charger {
+			...
+		};
+	};
--
1.9.3
