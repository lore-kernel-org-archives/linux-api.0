From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 8/9] eeprom: qfprom: Add bindings for qfprom
Date: Tue, 24 Mar 2015 22:31:08 +0000
Message-ID: <1427236268-18882-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds bindings for qfprom found in QCOM SOCs. QFPROM driver
is based on simple eeprom framework.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 .../devicetree/bindings/eeprom/qfprom.txt          | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/eeprom/qfprom.txt

diff --git a/Documentation/devicetree/bindings/eeprom/qfprom.txt b/Documentation/devicetree/bindings/eeprom/qfprom.txt
new file mode 100644
index 0000000..d5baed6
--- /dev/null
+++ b/Documentation/devicetree/bindings/eeprom/qfprom.txt
@@ -0,0 +1,23 @@
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
+		reg		= <0x00700000 0x1000>;
+		...
+		/* Data cells */
+		tsens_calibration: calib@404 {
+			reg = <0x404 0x10>;
+		};
+	};
-- 
1.9.1
