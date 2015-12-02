From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v1 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Wed,  2 Dec 2015 09:33:09 +0000
Message-ID: <1449048790-25859-10-git-send-email-vladimir.murzin@arm.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Application Notes 385 and 386 shares the same memory map and features
except the CPU is used. AN385 is supplied with Cortex-M3 CPU and AN386
is supplied with Cortex-M4.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/boot/dts/Makefile       |    1 +
 arch/arm/boot/dts/mps2-an385.dts |   90 +++++++++++++++
 arch/arm/boot/dts/mps2.dtsi      |  227 ++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 318 insertions(+)
 create mode 100644 arch/arm/boot/dts/mps2-an385.dts
 create mode 100644 arch/arm/boot/dts/mps2.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 30bbc37..4ef3720 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -237,6 +237,7 @@ dtb-$(CONFIG_ARCH_MMP) +=3D \
 dtb-$(CONFIG_MACH_MESON8B) +=3D \
 =09meson8b-mxq.dtb \
 =09meson8b-odroidc1.dtb
+dtb-$(CONFIG_ARCH_MPS2) +=3D mps2-an385.dtb
 dtb-$(CONFIG_ARCH_MOXART) +=3D \
 =09moxart-uc7112lx.dtb
 dtb-$(CONFIG_SOC_IMX1) +=3D \
diff --git a/arch/arm/boot/dts/mps2-an385.dts b/arch/arm/boot/dts/mps2-an38=
5.dts
new file mode 100644
index 0000000..ddb03d3
--- /dev/null
+++ b/arch/arm/boot/dts/mps2-an385.dts
@@ -0,0 +1,90 @@
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
+=09model =3D "ARM MPS2 Application Note 385/386";
+=09compatible =3D "arm,mps2";
+
+=09aliases {
+=09=09serial0 =3D &uart0;
+=09};
+
+=09chosen {
+=09=09bootargs =3D "init=3D/sbin/init earlycon";
+=09=09stdout-path =3D "serial0:9600n8";
+=09};
+
+=09memory {
+=09=09device_type =3D "memory";
+=09=09reg =3D <0x21000000 0x1000000>;
+=09};
+
+=09ethernet@40200000 {
+=09=09compatible =3D "smsc,lan9220", "smsc,lan9115";
+=09=09reg =3D <0x40200000 0x10000>;
+=09=09interrupts =3D <13>;
+=09=09interrupt-parent =3D <&nvic>;
+=09=09smsc,irq-active-high;
+=09};
+};
+
+&uart0 {
+=09status =3D "okay";
+};
+
+&timer0 {
+=09status =3D "okay";
+};
+
+&timer1 {
+=09status =3D "okay";
+};
+
+&wdt {
+=09status =3D "okay";
+};
diff --git a/arch/arm/boot/dts/mps2.dtsi b/arch/arm/boot/dts/mps2.dtsi
new file mode 100644
index 0000000..5d2c539
--- /dev/null
+++ b/arch/arm/boot/dts/mps2.dtsi
@@ -0,0 +1,227 @@
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
+=09oscclk0: clk-osc0 {
+=09=09compatible =3D "fixed-clock";
+=09=09#clock-cells =3D <0>;
+=09=09clock-frequency =3D <50000000>;
+=09};
+
+=09oscclk1: clk-osc1 {
+=09=09compatible =3D "fixed-clock";
+=09=09#clock-cells =3D <0>;
+=09=09clock-frequency =3D <24576000>;
+=09};
+
+=09oscclk2: clk-osc2 {
+=09=09compatible =3D "fixed-clock";
+=09=09#clock-cells =3D <0>;
+=09=09clock-frequency =3D <25000000>;
+=09};
+
+=09cfgclk: clk-cfg {
+=09=09compatible =3D "fixed-clock";
+=09=09#clock-cells =3D <0>;
+=09=09clock-frequency =3D <5000000>;
+=09};
+
+=09spicfgclk: clk-spicfg {
+=09=09compatible =3D "fixed-clock";
+=09=09#clock-cells =3D <0>;
+=09=09clock-frequency =3D <75000000>;
+=09};
+
+=09sysclk: clk-sys {
+=09=09compatible =3D "fixed-factor-clock";
+=09=09clocks =3D <&oscclk0>;
+=09=09#clock-cells =3D <0>;
+=09=09clock-div =3D <2>;
+=09=09clock-mult =3D <1>;
+=09};
+
+=09audmclk: clk-audm {
+=09=09compatible =3D "fixed-factor-clock";
+=09=09clocks =3D <&oscclk1>;
+=09=09#clock-cells =3D <0>;
+=09=09clock-div =3D <2>;
+=09=09clock-mult =3D <1>;
+=09};
+
+=09audsclk: clk-auds {
+=09=09compatible =3D "fixed-factor-clock";
+=09=09clocks =3D <&oscclk1>;
+=09=09#clock-cells =3D <0>;
+=09=09clock-div =3D <8>;
+=09=09clock-mult =3D <1>;
+=09};
+
+=09spiclcd: clk-cpiclcd {
+=09=09compatible =3D "fixed-factor-clock";
+=09=09clocks =3D <&oscclk0>;
+=09=09#clock-cells =3D <0>;
+=09=09clock-div =3D <2>;
+=09=09clock-mult =3D <1>;
+=09};
+
+=09spicon: clk-spicon {
+=09=09compatible =3D "fixed-factor-clock";
+=09=09clocks =3D <&oscclk0>;
+=09=09#clock-cells =3D <0>;
+=09=09clock-div =3D <2>;
+=09=09clock-mult =3D <1>;
+=09};
+
+=09i2cclcd: clk-i2cclcd {
+=09=09compatible =3D "fixed-factor-clock";
+=09=09clocks =3D <&oscclk0>;
+=09=09#clock-cells =3D <0>;
+=09=09clock-div =3D <2>;
+=09=09clock-mult =3D <1>;
+=09};
+
+=09i2caud: clk-i2caud {
+=09=09compatible =3D "fixed-factor-clock";
+=09=09clocks =3D <&oscclk0>;
+=09=09#clock-cells =3D <0>;
+=09=09clock-div =3D <2>;
+=09=09clock-mult =3D <1>;
+=09};
+
+=09soc {
+=09=09compatible =3D "simple-bus";
+=09=09ranges;
+
+=09=09apb {
+=09=09=09compatible =3D "simple-bus";
+=09=09=09#address-cells =3D <1>;
+=09=09=09#size-cells =3D <1>;
+=09=09=09ranges =3D <0 0x40000000 0x10000>;
+
+=09=09=09timer0: mps2-timer0@0 {
+=09=09=09=09compatible =3D "arm,mps2-timer";
+=09=09=09=09reg =3D <0x0 0x1000>;
+=09=09=09=09interrupts =3D <8>;
+=09=09=09=09clocks =3D <&sysclk>;
+=09=09=09=09status =3D "disabled";
+=09=09=09};
+
+=09=09=09timer1: mps2-timer1@1000 {
+=09=09=09=09compatible =3D "arm,mps2-timer";
+=09=09=09=09reg =3D <0x1000 0x1000>;
+=09=09=09=09interrupts =3D <9>;
+=09=09=09=09clocks =3D <&sysclk>;
+=09=09=09=09status =3D "disabled";
+=09=09=09};
+
+=09=09=09timer2: dual-timer@2000 {
+=09=09=09=09compatible =3D "arm,sp804";
+=09=09=09=09reg =3D <0x2000 0x1000>;
+=09=09=09=09clocks =3D <&sysclk>;
+=09=09=09=09interrupts =3D <10>;
+=09=09=09=09status =3D "disabled";
+=09=09=09};
+
+
+=09=09=09uart0: serial@4000 {
+=09=09=09=09compatible =3D "arm,mps2-uart";
+=09=09=09=09reg =3D <0x4000 0x1000>;
+=09=09=09=09interrupts =3D <0 1 12>;
+=09=09=09=09clocks =3D <&sysclk>;
+=09=09=09=09status =3D "disabled";
+=09=09=09};
+
+=09=09=09uart1: serial@5000 {
+=09=09=09=09compatible =3D "arm,mps2-uart";
+=09=09=09=09reg =3D <0x5000 0x1000>;
+=09=09=09=09interrupts =3D <2 3 12>;
+=09=09=09=09clocks =3D <&sysclk>;
+=09=09=09=09status =3D "disabled";
+=09=09=09};
+
+=09=09=09uart2: serial@6000 {
+=09=09=09=09compatible =3D "arm,mps2-uart";
+=09=09=09=09reg =3D <0x6000 0x1000>;
+=09=09=09=09interrupts =3D <4 5 12>;
+=09=09=09=09clocks =3D <&sysclk>;
+=09=09=09=09status =3D "disabled";
+=09=09=09};
+
+=09=09=09wdt: watchdog@8000 {
+=09=09=09=09compatible =3D "arm,sp805", "arm,primecell";
+=09=09=09=09arm,primecell-periphid =3D <0x00141805>;
+=09=09=09=09reg =3D <0x8000 0x1000>;
+=09=09=09=09interrupts =3D <0>;
+=09=09=09=09clocks =3D <&sysclk>;
+=09=09=09=09clock-names =3D "apb_pclk";
+=09=09=09=09status =3D "disabled";
+=09=09=09};
+=09=09};
+
+=09=09fpgaio {
+=09=09=09compatible =3D "syscon", "simple-mfd";
+=09=09=09reg =3D <0x40028000 0x10>;
+
+=09=09=09led@0 {
+=09=09=09=09compatible =3D "register-bit-led";
+=09=09=09=09offset =3D <0x0>;
+=09=09=09=09mask =3D <0x01>;
+=09=09=09=09label =3D "userled:0";
+=09=09=09=09linux,default-trigger =3D "heartbeat";
+=09=09=09=09default-state =3D "on";
+=09=09=09};
+
+=09=09=09led@1 {
+=09=09=09=09compatible =3D "register-bit-led";
+=09=09=09=09offset =3D <0x0>;
+=09=09=09=09mask =3D <0x02>;
+=09=09=09=09label =3D "userled:1";
+=09=09=09=09linux,default-trigger =3D "usr";
+=09=09=09=09default-state =3D "off";
+=09=09=09};
+=09=09};
+=09};
+};
--=20
1.7.9.5
