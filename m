From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 3/6] eeprom: Add bindings for simple eeprom framework
Date: Thu,  5 Mar 2015 09:46:05 +0000
Message-ID: <1425548765-13019-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, andrew@lunn.ch, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch adds bindings for simple eeprom framework which allows eeprom
consumers to talk to eeprom providers to get access to eeprom cell data.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
[Maxime Ripard: intial version of eeprom framework]
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 .../devicetree/bindings/eeprom/eeprom.txt          | 70 ++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt

diff --git a/Documentation/devicetree/bindings/eeprom/eeprom.txt b/Documentation/devicetree/bindings/eeprom/eeprom.txt
new file mode 100644
index 0000000..dbfb95c
--- /dev/null
+++ b/Documentation/devicetree/bindings/eeprom/eeprom.txt
@@ -0,0 +1,70 @@
+= EEPROM Data Device Tree Bindings =
+
+This binding is intended to represent the location of hardware
+configuration data stored in EEPROMs.
+
+On a significant proportion of boards, the manufacturer has stored
+some data on an EEPROM-like device, for the OS to be able to retrieve
+these information and act upon it. Obviously, the OS has to know
+about where to retrieve these data from, and where they are stored on
+the storage device.
+
+This document is here to document this.
+
+= Data providers =
+Contains bindings specific to provider drivers and data cells as children
+to this node.
+
+= Data cells =
+These are the child nodes of the provider which contain data cell
+information like offset and size in eeprom provider.
+
+Required properties:
+reg:	specifies the offset in byte within that storage device, and the length
+	in bytes of the data we care about.
+	There could be more then one offset-length pairs in this property.
+
+Optional properties:
+As required by specific data parsers/interpreters.
+
+For example:
+
+	/* Provider */
+	qfprom: qfprom@00700000 {
+		compatible 	= "qcom,qfprom";
+		reg		= <0x00700000 0x1000>;
+		...
+
+		/* Data cells */
+		tsens_calibration: calib@404 {
+			reg = <0x404 0x10>;
+		};
+
+		serial_number: sn {
+			reg = <0x104 0x4>, <0x204 0x4>, <0x30c 0x4>;
+
+		};
+		...
+	};
+
+= Data consumers =
+Are drivers which consume eeprom data cells.
+
+Required properties:
+
+eeproms: List of phandle and data cell the device might be interested in.
+
+Optional properties:
+
+eeprom-names: List of data cell name strings sorted in the same order
+ 	      as the resets property. Consumers drivers will use
+ 	      eeprom-names to differentiate between multiple cells,
+ 	      and hence being able to know what these cells are for.
+
+For example:
+
+	tsens {
+		...
+		eeproms = <&tsens_calibration>;
+		eeprom-names = "calibration";
+	};
-- 
1.9.1
