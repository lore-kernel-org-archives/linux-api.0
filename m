From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH 3/5] doc: dt: beaglebone cape manager bindings.
Date: Wed, 13 May 2015 10:59:43 +0300
Message-ID: <1431503985-31853-4-git-send-email-pantelis.antoniou@konsulko.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Robert Nelson <robertcnelson@gmail.com>, Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Jonathan Corbet <corbet@lwn.net>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Guenter Roeck <linux@roeck-us.net>, Geert Uytterhoeven <geert+renesas@glider.be>, =?UTF-8?q?Beno=C3=AEt=20Cousso?= <bcousson@baylibre.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Bindings document for the beaglebone cape manager.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 .../devicetree/bindings/misc/bone_capemgr.txt      | 123 +++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/bone_capemgr.txt

diff --git a/Documentation/devicetree/bindings/misc/bone_capemgr.txt b/Documentation/devicetree/bindings/misc/bone_capemgr.txt
new file mode 100644
index 0000000..006f50c
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/bone_capemgr.txt
@@ -0,0 +1,123 @@
+* Beaglebone cape manager driver
+
+Required properties:
+- compatible: "ti,bone-capemgr"
+- eeprom: phandle to the EEPROM baseboard.
+          The EEPROM framework interface is use to obtain the data.
+
+Required children nodes:
+
+- baseboardmaps: Contains nodes, which each of the them defines a mapping from
+		 the baseboard EEPROM board-name ID to a DT friendly compatible
+		 string.
+
+  - board-name:      The baseboard EEPROM board name, i.e. A335BONE for the original
+		     beaglebone white.
+  - compatible-name: The DT friendly compatible string to be used for matching
+		     compatible capes, i.e. "ti,beaglebone"
+
+
+ - slots: Defines the slots (I2C addresses) that capes are available.
+  - eeprom: phandle to the EEPROM cape.
+            The EEPROM framework interface is used to obtain the data.
+
+- Example of a beaglebone cape-manager:
+
+bone_capemgr {
+	compatible = "ti,bone-capemgr";
+	status = "okay";
+
+	eeprom = <&baseboard_eeprom>;
+
+	/* map board revisions to compatible definitions */
+	baseboardmaps {
+		baseboard_beaglebone: board@0 {
+			board-name = "A335BONE";
+			compatible-name = "ti,beaglebone";
+		};
+
+		baseboard_beaglebone_black: board@1 {
+			board-name = "A335BNLT";
+			compatible-name = "ti,beaglebone-black";
+		};
+	};
+
+	/* only 4 slots defined */
+	slots {
+		slot@0 {
+			eeprom = <&cape_eeprom0>;
+		};
+
+		slot@1 {
+			eeprom = <&cape_eeprom1>;
+		};
+
+		slot@2 {
+			eeprom = <&cape_eeprom2>;
+		};
+
+		slot@3 {
+			eeprom = <&cape_eeprom3>;
+		};
+	};
+};
+
+The format of the cape to be loaded is in a standard overlay format with
+the following root properties that are interpreted by the cape manager:
+
+Required properties:
+ - compatible: Should be compatible to the baseboard according to the
+               baseboard map value, i.e. "ti,beaglebone".
+ - part-numer: Should contain the part-number as stored in the EEPROM.
+ - version:    Should contain a list of all the version that are supported
+               by the single cape dtbo, i.e. "00A1".
+
+Optional properties:
+ - exclusive-use: A string list which state the resources this cape requires.
+                  No processing or matching to anything regarding the internal
+		  kernel state is performed; it's purpose is to guard against
+		  conflicts with other capes.
+ - priority:      A priority to be assigned when loading a cape. A lower value
+                  has higher priority. The purpose of the priority is to control
+		  which cape is loaded first in case of a conflict.
+
+- Example of a serial cape:
+
+/dts-v1/;
+/plugin/;
+/ {
+        compatible = "ti,beaglebone", "ti,beaglebone-black";
+
+        /* identification */
+        part-number = "BB-BONE-SERL-03";
+        version = "00A1";
+
+        /* state the resources this cape uses */
+        exclusive-use =
+                /* the pin header uses */
+                "P9.21",        /* uart2_txd */
+                "P9.22",        /* uart2_rxd */
+                /* the hardware ip uses */
+                "uart2";
+
+        fragment@0 {
+                target = <&am33xx_pinmux>;
+                __overlay__ {
+                        bb_uart2_pins: pinmux_bb_uart2_pins {
+                                pinctrl-single,pins = <
+                                        0x150 0x21      /* spi0_sclk.uart2_rxd | MODE1 */
+                                        0x154 0x01      /* spi0_d0.uart2_txd | MODE1 */
+                                >;
+                        };
+                };
+        };
+
+        fragment@1 {
+                target = <&uart2>;
+                __overlay__ {
+                        status = "okay";
+                        pinctrl-names = "default";
+                        pinctrl-0 = <&bb_uart2_pins>;
+                };
+        };
+};
-- 
1.7.12
