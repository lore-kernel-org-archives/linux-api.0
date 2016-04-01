From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v5 09/10] ARM: dts: introduce MPS2 AN399/AN400
Date: Fri,  1 Apr 2016 15:03:00 +0100
Message-ID: <1459519381-34441-10-git-send-email-vladimir.murzin@arm.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Application Notes 399 and 400 shares the same memory map and
features. Both are shipped with Cortex-M7 and have the same  peripheral
as AN385/AN386, but with different location of PSRAM and Ethernet
controller.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/boot/dts/Makefile       |    4 +-
 arch/arm/boot/dts/mps2-an399.dts |   92 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/mps2-an399.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 1efa5a2..c7a78c9 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -253,7 +253,9 @@ dtb-$(CONFIG_ARCH_MMP) += \
 dtb-$(CONFIG_MACH_MESON8B) += \
 	meson8b-mxq.dtb \
 	meson8b-odroidc1.dtb
-dtb-$(CONFIG_ARCH_MPS2) += mps2-an385.dtb
+dtb-$(CONFIG_ARCH_MPS2) += \
+	mps2-an385.dtb \
+	mps2-an399.dtb
 dtb-$(CONFIG_ARCH_MOXART) += \
 	moxart-uc7112lx.dtb
 dtb-$(CONFIG_SOC_IMX1) += \
diff --git a/arch/arm/boot/dts/mps2-an399.dts b/arch/arm/boot/dts/mps2-an399.dts
new file mode 100644
index 0000000..776595f
--- /dev/null
+++ b/arch/arm/boot/dts/mps2-an399.dts
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
+	model = "ARM MPS2 Application Note 399/400";
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
+		reg = <0x60000000 0x1000000>;
+	};
+
+	smb {
+		ethernet@1,0 {
+			compatible = "smsc,lan9220", "smsc,lan9115";
+			reg = <1 0x0 0x10000>;
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
-- 
1.7.9.5
