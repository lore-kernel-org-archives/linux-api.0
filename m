From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Sat,  9 May 2015 09:53:56 +0200
Message-ID: <1431158038-3813-15-git-send-email-mcoquelin.stm32@gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, lee.jones@linaro.org, Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

The STMicrolectornics's STM32F429 MCU has the following main features:
 - Cortex-M4 core running up to @180MHz
 - 2MB internal flash, 256KBytes internal RAM
 - FMC controller to connect SDRAM, NOR and NAND memories
 - SD/MMC/SDIO support
 - Ethernet controller
 - USB OTFG FS & HS controllers
 - I2C, SPI, CAN busses support
 - Several 16 & 32 bits general purpose timers
 - Serial Audio interface
 - LCD controller

Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 arch/arm/boot/dts/Makefile            |   1 +
 arch/arm/boot/dts/stm32f429-disco.dts |  71 +++++++++++
 arch/arm/boot/dts/stm32f429.dtsi      | 227 ++++++++++++++++++++++++++++++++++
 3 files changed, 299 insertions(+)
 create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
 create mode 100644 arch/arm/boot/dts/stm32f429.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 86217db..db1d8c6 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -520,6 +520,7 @@ dtb-$(CONFIG_ARCH_STI) += \
 	stih416-b2020.dtb \
 	stih416-b2020e.dtb \
 	stih418-b2199.dtb
+dtb-$(CONFIG_ARCH_STM32)+= stm32f429-disco.dtb
 dtb-$(CONFIG_MACH_SUN4I) += \
 	sun4i-a10-a1000.dtb \
 	sun4i-a10-ba10-tvbox.dtb \
diff --git a/arch/arm/boot/dts/stm32f429-disco.dts b/arch/arm/boot/dts/stm32f429-disco.dts
new file mode 100644
index 0000000..6b9aa59
--- /dev/null
+++ b/arch/arm/boot/dts/stm32f429-disco.dts
@@ -0,0 +1,71 @@
+/*
+ * Copyright 2015 - Maxime Coquelin <mcoquelin.stm32@gmail.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this file; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+/dts-v1/;
+#include "stm32f429.dtsi"
+
+/ {
+	model = "STMicroelectronics STM32F429i-DISCO board";
+	compatible = "st,stm32f429i-disco", "st,stm32f429";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 root=/dev/ram rdinit=/linuxrc";
+		linux,stdout-path = &usart1;
+	};
+
+	memory {
+		reg = <0x90000000 0x800000>;
+	};
+
+	aliases {
+		serial0 = &usart1;
+	};
+};
+
+&usart1 {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
new file mode 100644
index 0000000..2719f3a
--- /dev/null
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -0,0 +1,227 @@
+/*
+ * Copyright 2015 - Maxime Coquelin <mcoquelin.stm32@gmail.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this file; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "armv7-m.dtsi"
+#include  <dt-bindings/mfd/stm32f4-rcc.h>
+
+/ {
+	clocks {
+		clk_sysclk: clk-sysclk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <180000000>;
+		};
+
+		clk_hclk: clk-hclk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <180000000>;
+		};
+
+		clk_pclk1: clk-pclk1 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <45000000>;
+		};
+
+		clk_pclk2: clk-pclk2 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <90000000>;
+		};
+
+		clk_pmtr1: clk-pmtr1 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <90000000>;
+		};
+
+		clk_pmtr2: clk-pmtr2 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <180000000>;
+		};
+
+		clk_systick: clk-systick {
+			compatible = "fixed-factor-clock";
+			clocks = <&clk_hclk>;
+			#clock-cells = <0>;
+			clock-div = <8>;
+			clock-mult = <1>;
+		};
+	};
+
+	soc {
+		timer2: timer@40000000 {
+			compatible = "st,stm32-timer";
+			reg = <0x40000000 0x400>;
+			interrupts = <28>;
+			resets = <&rcc STM32F4_APB1_RESET(TIM2)>;
+			clocks = <&clk_pmtr1>;
+			status = "disabled";
+		};
+
+		timer3: timer@40000400 {
+			compatible = "st,stm32-timer";
+			reg = <0x40000400 0x400>;
+			interrupts = <29>;
+			resets = <&rcc STM32F4_APB1_RESET(TIM3)>;
+			clocks = <&clk_pmtr1>;
+			status = "disabled";
+		};
+
+		timer4: timer@40000800 {
+			compatible = "st,stm32-timer";
+			reg = <0x40000800 0x400>;
+			interrupts = <30>;
+			resets = <&rcc STM32F4_APB1_RESET(TIM4)>;
+			clocks = <&clk_pmtr1>;
+			status = "disabled";
+		};
+
+		timer5: timer@40000c00 {
+			compatible = "st,stm32-timer";
+			reg = <0x40000c00 0x400>;
+			interrupts = <50>;
+			resets = <&rcc STM32F4_APB1_RESET(TIM5)>;
+			clocks = <&clk_pmtr1>;
+		};
+
+		timer6: timer@40001000 {
+			compatible = "st,stm32-timer";
+			reg = <0x40001000 0x400>;
+			interrupts = <54>;
+			resets = <&rcc STM32F4_APB1_RESET(TIM6)>;
+			clocks = <&clk_pmtr1>;
+			status = "disabled";
+		};
+
+		timer7: timer@40001400 {
+			compatible = "st,stm32-timer";
+			reg = <0x40001400 0x400>;
+			interrupts = <55>;
+			resets = <&rcc STM32F4_APB1_RESET(TIM7)>;
+			clocks = <&clk_pmtr1>;
+			status = "disabled";
+		};
+
+		usart2: serial@40004400 {
+			compatible = "st,stm32-usart", "st,stm32-uart";
+			reg = <0x40004400 0x400>;
+			interrupts = <38>;
+			clocks = <&clk_pclk1>;
+			status = "disabled";
+		};
+
+		usart3: serial@40004800 {
+			compatible = "st,stm32-usart", "st,stm32-uart";
+			reg = <0x40004800 0x400>;
+			interrupts = <39>;
+			clocks = <&clk_pclk1>;
+			status = "disabled";
+		};
+
+		usart4: serial@40004c00 {
+			compatible = "st,stm32-uart";
+			reg = <0x40004c00 0x400>;
+			interrupts = <52>;
+			clocks = <&clk_pclk1>;
+			status = "disabled";
+		};
+
+		usart5: serial@40005000 {
+			compatible = "st,stm32-uart";
+			reg = <0x40005000 0x400>;
+			interrupts = <53>;
+			clocks = <&clk_pclk1>;
+			status = "disabled";
+		};
+
+		usart7: serial@40007800 {
+			compatible = "st,stm32-usart", "st,stm32-uart";
+			reg = <0x40007800 0x400>;
+			interrupts = <82>;
+			clocks = <&clk_pclk1>;
+			status = "disabled";
+		};
+
+		usart8: serial@40007c00 {
+			compatible = "st,stm32-usart", "st,stm32-uart";
+			reg = <0x40007c00 0x400>;
+			interrupts = <83>;
+			clocks = <&clk_pclk1>;
+			status = "disabled";
+		};
+
+		usart1: serial@40011000 {
+			compatible = "st,stm32-usart", "st,stm32-uart";
+			reg = <0x40011000 0x400>;
+			interrupts = <37>;
+			clocks = <&clk_pclk2>;
+			status = "disabled";
+		};
+
+		usart6: serial@40011400 {
+			compatible = "st,stm32-usart", "st,stm32-uart";
+			reg = <0x40011400 0x400>;
+			interrupts = <71>;
+			clocks = <&clk_pclk2>;
+			status = "disabled";
+		};
+
+		rcc: rcc@40023810 {
+			#reset-cells = <1>;
+			compatible = "st,stm32-rcc";
+			reg = <0x40023800 0x400>;
+		};
+	};
+};
+
+&systick {
+	clocks = <&clk_systick>;
+	status = "okay";
+};
-- 
1.9.1
