From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v9 3/5] dt-bindings: Document the STM32 USART bindings
Date: Fri, 22 May 2015 23:03:34 +0200
Message-ID: <1432328616-16964-4-git-send-email-mcoquelin.stm32@gmail.com>
References: <1432328616-16964-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432328616-16964-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Kamil Lulko <rev13@wp.pl>, u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds documentation of device tree bindings for the
STM32 USART

Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 .../devicetree/bindings/serial/st,stm32-usart.txt  | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt

diff --git a/Documentation/devicetree/bindings/serial/st,stm32-usart.txt b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
new file mode 100644
index 0000000..8480a76
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
@@ -0,0 +1,32 @@
+* STMicroelectronics STM32 USART
+
+Required properties:
+- compatible: Can be either "st,stm32-usart" or "st,stm32-uart" depending on
+whether the device supports synchronous mode.
+- reg: The address and length of the peripheral registers space
+- interrupts: The interrupt line of the USART instance
+- clocks: The input clock of the USART instance
+
+Optional properties:
+- pinctrl: The reference on the pins configuration
+- auto-flow-control: bool flag to enable hardware flow control.
+
+Examples:
+usart4: serial@40004c00 {
+	compatible = "st,stm32-uart";
+	reg = <0x40004c00 0x400>;
+	interrupts = <52>;
+	clocks = <&clk_pclk1>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usart4>;
+};
+
+usart2: serial@40004400 {
+	compatible = "st,stm32-usart", "st,stm32-uart";
+	reg = <0x40004400 0x400>;
+	interrupts = <38>;
+	clocks = <&clk_pclk1>;
+	auto-flow-control;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usart2 &pinctrl_usart2_rtscts>;
+};
-- 
1.9.1
