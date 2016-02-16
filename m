From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v3 03/10] dt-bindings: document the MPS2 UART bindings
Date: Tue, 16 Feb 2016 10:08:08 +0000
Message-ID: <1455617295-23736-4-git-send-email-vladimir.murzin@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de
Cc: mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds documentation of device tree bindings for the
UART found on ARM MPS2 platform

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Rob Herring <robh@kernel.org
---
 .../devicetree/bindings/serial/arm,mps2-uart.txt   |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/arm,mps2-uart.txt

diff --git a/Documentation/devicetree/bindings/serial/arm,mps2-uart.txt b/Documentation/devicetree/bindings/serial/arm,mps2-uart.txt
new file mode 100644
index 0000000..b3f7cb1
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/arm,mps2-uart.txt
@@ -0,0 +1,22 @@
+ARM MPS2 UART
+
+Required properties:
+- compatible	: Should be "arm,mps2-uart"
+- reg		: Address and length of the register set
+- interrupts	: Reference to the UART RX, TX and overrun interrupts
+
+Required clocking property:
+- clocks	  : The input clock of the UART
+
+
+Examples:
+
+uart0: serial@40004000 {
+	compatible = "arm,mps2-uart";
+	reg = <0x40004000 0x1000>;
+	interrupts = <0 1 12>;
+	clocks = <&sysclk>;
+};
+
+
+
-- 
1.7.9.5
