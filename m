From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 08/10] eeprom: qfprom: Add bindings for qfprom
Date: Mon, 30 Mar 2015 22:58:32 +0100
Message-ID: <1427752712-17389-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds bindings for qfprom found in QCOM SOCs. QFPROM driver
is based on simple eeprom framework.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 .../devicetree/bindings/eeprom/qfprom.txt          | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/eeprom/qfprom.txt

diff --git a/Documentation/devicetree/bindings/eeprom/qfprom.txt b/Documentation/devicetree/bindings/eeprom/qfprom.txt
new file mode 100644
index 0000000..21a7104
--- /dev/null
+++ b/Documentation/devicetree/bindings/eeprom/qfprom.txt
@@ -0,0 +1,34 @@
+= Qualcomm QFPROM device tree bindings =
+
+This binding is intended to represent QFPROM which is found in most QCOM SOCs.
+
+Required properties:
+- compatible: should be "qcom,qfprom"
+- reg: Should contain registers location and length
+
+= Data cells =
+Are child nodes of qfprom, bindings of which as described in
+bindings/eeprom/eeprom.txt
+
+Example:
+
+	qfprom: qfprom@00700000 {
+		compatible 	= "qcom,qfprom";
+		reg		= <0x00700000 0x8000>;
+		...
+		/* Data cells */
+		tsens_calibration: calib@404 {
+			reg = <0x4404 0x10>;
+		};
+	};
+
+
+= Data consumers =
+Are device nodes which consume eeprom data cells.
+
+For example:
+
+	tsens {
+		...
+		calibration = <&tsens_calibration>;
+	};
-- 
1.9.1
