From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 12/18] dt-bindings: Document the STM32 USART bindings
Date: Fri, 20 Feb 2015 19:01:11 +0100
Message-ID: <1424455277-29983-13-git-send-email-mcoquelin.stm32__22986.0408734114$1424455511$gmane$org@gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424455277-29983-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

This adds documentation of device tree bindings for the
STM32 USART

Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 .../devicetree/bindings/serial/st,stm32-usart.txt      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt

diff --git a/Documentation/devicetree/bindings/serial/st,stm32-usart.txt b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
new file mode 100644
index 0000000..e49b75ad
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
@@ -0,0 +1,18 @@
+* STMicroelectronics STM32 USART
+
+Required properties:
+- compatible: Should be "st,stm32-usart"
+- reg: The address and length of the peripheral registers space
+- interrupts: The interrupt line of the USART instance
+- clocks: The input clock of the USART instance
+- pinctrl: The reference on the pins configuration
+
+Example:
+usart1: usart@40011000 {
+	compatible = "st,stm32-usart";
+	reg = <0x40011000 0x400>;
+	interrupts = <37>;
+	clocks = <&clk_pclk2>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usart1>;
+};
-- 
1.9.1
