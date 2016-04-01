From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v5 08/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Fri,  1 Apr 2016 15:02:59 +0100
Message-ID: <1459519381-34441-9-git-send-email-vladimir.murzin@arm.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Application Notes 385 and 386 shares the same memory map and features
except the CPU is used. AN385 is supplied with Cortex-M3 CPU and AN386
is supplied with Cortex-M4.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/Makefile       |    1 +
 arch/arm/boot/dts/mps2-an385.dts |   92 +++++++++++++++
 arch/arm/boot/dts/mps2.dtsi      |  242 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 335 insertions(+)
 create mode 100644 arch/arm/boot/dts/mps2-an385.dts
 create mode 100644 arch/arm/boot/dts/mps2.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 95c1923..1efa5a2 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -253,6 +253,7 @@ dtb-$(CONFIG_ARCH_MMP) += \
 dtb-$(CONFIG_MACH_MESON8B) += \
 	meson8b-mxq.dtb \
 	meson8b-odroidc1.dtb
+dtb-$(CONFIG_ARCH_MPS2) += mps2-an385.dtb
 dtb-$(CONFIG_ARCH_MOXART) += \
 	moxart-uc7112lx.dtb
 dtb-$(CONFIG_SOC_IMX1) += \
diff --git a/arch/arm/boot/dts/mps2-an385.dts b/arch/arm/boot/dts/mps2-an385.dts
new file mode 100644
index 0000000..d7cb594
--- /dev/null
+++ b/arch/arm/boot/dts/mps2-an385.dts
@@ -0,0 +1,92 @@
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Vladimir Murzin <vladimir.murzin@arm.com>
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
+
+#include "mps2.dtsi"
+
+/ {
+	model = "ARM MPS2 Application Note 385/386";
+	compatible = "arm,mps2";
+
+	aliases {
+		serial0 = &uart0;
+	};
+
+	chosen {
+		bootargs = "rdinit=/sbin/init earlycon";
+		stdout-path = "serial0:9600n8";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x21000000 0x1000000>;
+	};
+
+	smb {
+		ethernet@0,0 {
+			compatible = "smsc,lan9220", "smsc,lan9115";
+			reg = <0 0x0 0x10000>;
+			interrupts = <13>;
+			interrupt-parent = <&nvic>;
+			smsc,irq-active-high;
+		};
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&timer0 {
+	status = "okay";
+};
+
+&timer1 {
+	status = "okay";
+};
+
+&wdt {
+	status = "okay";
+};
diff --git a/arch/arm/boot/dts/mps2.dtsi b/arch/arm/boot/dts/mps2.dtsi
new file mode 100644
index 0000000..6c84ca3
--- /dev/null
+++ b/arch/arm/boot/dts/mps2.dtsi
@@ -0,0 +1,242 @@
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Vladimir Murzin <vladimir.murzin@arm.com>
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
+
+/ {
+	oscclk0: clk-osc0 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <50000000>;
+	};
+
+	oscclk1: clk-osc1 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <24576000>;
+	};
+
+	oscclk2: clk-osc2 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <25000000>;
+	};
+
+	cfgclk: clk-cfg {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <5000000>;
+	};
+
+	spicfgclk: clk-spicfg {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <75000000>;
+	};
+
+	sysclk: clk-sys {
+		compatible = "fixed-factor-clock";
+		clocks = <&oscclk0>;
+		#clock-cells = <0>;
+		clock-div = <2>;
+		clock-mult = <1>;
+	};
+
+	audmclk: clk-audm {
+		compatible = "fixed-factor-clock";
+		clocks = <&oscclk1>;
+		#clock-cells = <0>;
+		clock-div = <2>;
+		clock-mult = <1>;
+	};
+
+	audsclk: clk-auds {
+		compatible = "fixed-factor-clock";
+		clocks = <&oscclk1>;
+		#clock-cells = <0>;
+		clock-div = <8>;
+		clock-mult = <1>;
+	};
+
+	spiclcd: clk-cpiclcd {
+		compatible = "fixed-factor-clock";
+		clocks = <&oscclk0>;
+		#clock-cells = <0>;
+		clock-div = <2>;
+		clock-mult = <1>;
+	};
+
+	spicon: clk-spicon {
+		compatible = "fixed-factor-clock";
+		clocks = <&oscclk0>;
+		#clock-cells = <0>;
+		clock-div = <2>;
+		clock-mult = <1>;
+	};
+
+	i2cclcd: clk-i2cclcd {
+		compatible = "fixed-factor-clock";
+		clocks = <&oscclk0>;
+		#clock-cells = <0>;
+		clock-div = <2>;
+		clock-mult = <1>;
+	};
+
+	i2caud: clk-i2caud {
+		compatible = "fixed-factor-clock";
+		clocks = <&oscclk0>;
+		#clock-cells = <0>;
+		clock-div = <2>;
+		clock-mult = <1>;
+	};
+
+	soc {
+		compatible = "simple-bus";
+		ranges;
+
+		apb {
+			compatible = "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x40000000 0x10000>;
+
+			timer0: mps2-timer0@0 {
+				compatible = "arm,mps2-timer";
+				reg = <0x0 0x1000>;
+				interrupts = <8>;
+				clocks = <&sysclk>;
+				status = "disabled";
+			};
+
+			timer1: mps2-timer1@1000 {
+				compatible = "arm,mps2-timer";
+				reg = <0x1000 0x1000>;
+				interrupts = <9>;
+				clocks = <&sysclk>;
+				status = "disabled";
+			};
+
+			timer2: dual-timer@2000 {
+				compatible = "arm,sp804";
+				reg = <0x2000 0x1000>;
+				clocks = <&sysclk>;
+				interrupts = <10>;
+				status = "disabled";
+			};
+
+
+			uart0: serial@4000 {
+				compatible = "arm,mps2-uart";
+				reg = <0x4000 0x1000>;
+				interrupts = <0 1 12>;
+				clocks = <&sysclk>;
+				status = "disabled";
+			};
+
+			uart1: serial@5000 {
+				compatible = "arm,mps2-uart";
+				reg = <0x5000 0x1000>;
+				interrupts = <2 3 12>;
+				clocks = <&sysclk>;
+				status = "disabled";
+			};
+
+			uart2: serial@6000 {
+				compatible = "arm,mps2-uart";
+				reg = <0x6000 0x1000>;
+				interrupts = <4 5 12>;
+				clocks = <&sysclk>;
+				status = "disabled";
+			};
+
+			wdt: watchdog@8000 {
+				compatible = "arm,sp805", "arm,primecell";
+				arm,primecell-periphid = <0x00141805>;
+				reg = <0x8000 0x1000>;
+				interrupts = <0>;
+				clocks = <&sysclk>;
+				clock-names = "apb_pclk";
+				status = "disabled";
+			};
+		};
+	};
+
+	fpga {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0x40020000 0x10000>;
+
+		fpgaio@8000 {
+			compatible = "syscon", "simple-mfd";
+			reg = <0x8000 0x10>;
+
+			led@0 {
+				compatible = "register-bit-led";
+				offset = <0x0>;
+				mask = <0x01>;
+				label = "userled:0";
+				linux,default-trigger = "heartbeat";
+				default-state = "on";
+			};
+
+			led@1 {
+				compatible = "register-bit-led";
+				offset = <0x0>;
+				mask = <0x02>;
+				label = "userled:1";
+				linux,default-trigger = "usr";
+				default-state = "off";
+			};
+		};
+	};
+
+	smb {
+		compatible = "simple-bus";
+		#address-cells = <2>;
+		#size-cells = <1>;
+		ranges = <0 0 0x40200000 0x10000>,
+			 <1 0 0xa0000000 0x10000>;
+	};
+};
-- 
1.7.9.5
