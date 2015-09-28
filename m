From: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Subject: [PATCH v8 01/14] dt: power: bq24257-charger: Cover additional devices
Date: Mon, 28 Sep 2015 17:33:49 -0500
Message-ID: <1443479642-23712-2-git-send-email-dannenberg@ti.com>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443479642-23712-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Extend the bq24257 charger's device tree documentation to cover the
bq24250 and bq24251 devices as well feature additions.

Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 .../devicetree/bindings/power/bq24257.txt          | 53 ++++++++++++++++++++--
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/bq24257.txt b/Documentation/devicetree/bindings/power/bq24257.txt
index 5c9d394..d693702 100644
--- a/Documentation/devicetree/bindings/power/bq24257.txt
+++ b/Documentation/devicetree/bindings/power/bq24257.txt
@@ -1,21 +1,64 @@
-Binding for TI bq24257 Li-Ion Charger
+Binding for TI bq24250/bq24251/bq24257 Li-Ion Charger
 
 Required properties:
 - compatible: Should contain one of the following:
+ * "ti,bq24250"
+ * "ti,bq24251"
  * "ti,bq24257"
-- reg:			   integer, i2c address of the device.
+- reg: integer, i2c address of the device.
+- interrupt-parent: Should be the phandle for the interrupt controller. Use in
+    conjunction with "interrupts".
+- interrupts: Interrupt mapping for GPIO IRQ (configure for both edges). Use in
+    conjunction with "interrupt-parent".
 - ti,battery-regulation-voltage: integer, maximum charging voltage in uV.
-- ti,charge-current:	   integer, maximum charging current in uA.
-- ti,termination-current:  integer, charge will be terminated when current in
-			   constant-voltage phase drops below this value (in uA).
+- ti,charge-current: integer, maximum charging current in uA.
+- ti,termination-current: integer, charge will be terminated when current in
+    constant-voltage phase drops below this value (in uA).
+
+Optional properties:
+- pg-gpios: GPIO used for connecting the bq2425x device PG (Power Good) pin.
+    This pin is not available on all devices however it should be used if
+    possible as this is the recommended way to obtain the charger's input PG
+    state. If this pin is not specified a software-based approach for PG
+    detection is used.
+- ti,current-limit: The maximum current to be drawn from the charger's input
+    (in uA). If this property is not specified, the input limit current is
+    set automatically using USB D+/D- signal based charger type detection.
+    If the hardware does not support the D+/D- based detection, a default
+    of 500,000 is used (=500mA) instead.
+- ti,ovp-voltage: Configures the over voltage protection voltage (in uV). If
+    not specified a default of 6,5000,000 (=6.5V) is used.
+- ti,in-dpm-voltage: Configures the threshold input voltage for the dynamic
+    power path management (in uV). If not specified a default of 4,360,000
+    (=4.36V) is used.
 
 Example:
 
 bq24257 {
 	compatible = "ti,bq24257";
 	reg = <0x6a>;
+	interrupt-parent = <&gpio1>;
+	interrupts = <16 IRQ_TYPE_EDGE_BOTH>;
+
+	pg-gpios = <&gpio1 28 GPIO_ACTIVE_HIGH>;
 
 	ti,battery-regulation-voltage = <4200000>;
 	ti,charge-current = <1000000>;
 	ti,termination-current = <50000>;
 };
+
+Example:
+
+bq24250 {
+	compatible = "ti,bq24250";
+	reg = <0x6a>;
+	interrupt-parent = <&gpio1>;
+	interrupts = <16 IRQ_TYPE_EDGE_BOTH>;
+
+	ti,battery-regulation-voltage = <4200000>;
+	ti,charge-current = <500000>;
+	ti,termination-current = <50000>;
+	ti,current-limit = <900000>;
+	ti,ovp-voltage = <9500000>;
+	ti,in-dpm-voltage = <4440000>;
+};
-- 
1.9.1
