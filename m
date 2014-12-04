From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v4 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC in dts and Makefile
Date: Thu, 4 Dec 2014 19:34:18 +0800
Message-ID: <1417692860-18841-4-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836v4>
 <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-doc-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com, jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de, florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com, hytszk@gmail.com, grant.likely@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sprdlinux@freelists.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, arm@kernel.org
List-Id: linux-api@vger.kernel.org

From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>

Adds the device tree support for Spreadtrum SC9836 SoC which is based on
Sharkl64 platform.

Sharkl64 platform contains the common nodes of Spreadtrum's arm64-based SoCs.

Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
---
 arch/arm64/boot/dts/Makefile                  |    1 +
 arch/arm64/boot/dts/sprd-sc9836-openphone.dts |   85 ++++++++++++++++++++
 arch/arm64/boot/dts/sprd-sc9836.dtsi          |  102 ++++++++++++++++++++++++
 arch/arm64/boot/dts/sprd-sharkl64.dtsi        |  105 +++++++++++++++++++++++++
 4 files changed, 293 insertions(+)
 create mode 100644 arch/arm64/boot/dts/sprd-sc9836-openphone.dts
 create mode 100644 arch/arm64/boot/dts/sprd-sc9836.dtsi
 create mode 100644 arch/arm64/boot/dts/sprd-sharkl64.dtsi

diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index f8001a6..d0aff8a 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,4 +1,5 @@
 dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
+dtb-$(CONFIG_ARCH_SHARKL64) += sprd-sc9836-openphone.dtb
 dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
 dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
 
diff --git a/arch/arm64/boot/dts/sprd-sc9836-openphone.dts b/arch/arm64/boot/dts/sprd-sc9836-openphone.dts
new file mode 100644
index 0000000..484d714
--- /dev/null
+++ b/arch/arm64/boot/dts/sprd-sc9836-openphone.dts
@@ -0,0 +1,85 @@
+/*
+ * Spreadtrum SC9836 openphone board DTS file
+ *
+ * Copyright (C) 2014, Spreadtrum Communications Inc.
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
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
+#include "sprd-sc9836.dtsi"
+
+/ {
+	model = "Spreadtrum,SC9836 Openphone Board";
+
+	compatible = "sprd,sc9836-openphone", "sprd,sc9836";
+
+	aliases {
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+		serial3 = &uart3;
+	};
+
+	memory@80000000 {
+		device_type = "memory";
+		reg = <0 0x80000000 0 0x20000000>;
+	};
+
+	chosen {
+		stdout-path = &uart0;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
+
+&uart3 {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/sprd-sc9836.dtsi b/arch/arm64/boot/dts/sprd-sc9836.dtsi
new file mode 100644
index 0000000..1abf897
--- /dev/null
+++ b/arch/arm64/boot/dts/sprd-sc9836.dtsi
@@ -0,0 +1,102 @@
+/*
+ * Spreadtrum SC9836 SoC DTS file
+ *
+ * Copyright (C) 2014, Spreadtrum Communications Inc.
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
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
+#include "sprd-sharkl64.dtsi"
+
+/ {
+	compatible = "sprd,sc9836";
+
+	cpus {
+		#address-cells = <2>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			reg = <0x0 0x0>;
+			enable-method = "psci";
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			reg = <0x0 0x1>;
+			enable-method = "psci";
+		};
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			reg = <0x0 0x2>;
+			enable-method = "psci";
+		};
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			reg = <0x0 0x3>;
+			enable-method = "psci";
+		};
+	};
+
+	gic: interrupt-controller@12001000 {
+		compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0 0x12001000 0 0x1000>,
+		      <0 0x12002000 0 0x2000>,
+		      <0 0x12004000 0 0x2000>,
+		      <0 0x12006000 0 0x2000>;
+	};
+
+	psci {
+		compatible = "arm,psci-0.2", "arm,psci";
+		method = "smc";
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <1 13 0xff01>,
+			     <1 14 0xff01>,
+			     <1 11 0xff01>,
+			     <1 10 0xff01>;
+	};
+};
diff --git a/arch/arm64/boot/dts/sprd-sharkl64.dtsi b/arch/arm64/boot/dts/sprd-sharkl64.dtsi
new file mode 100644
index 0000000..d9ecfe9
--- /dev/null
+++ b/arch/arm64/boot/dts/sprd-sharkl64.dtsi
@@ -0,0 +1,105 @@
+/*
+ * Spreadtrum Sharkl64 platform DTS file
+ *
+ * Copyright (C) 2014, Spreadtrum Communications Inc.
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
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
+/ {
+	interrupt-parent = <&gic>;
+	#address-cells = <2>;
+	#size-cells = <2>;
+
+	soc {
+		compatible = "simple-bus";
+		reg = <0x0 0x0 0x0 0x80000000>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		ap_apb: apb@70000000 {
+			compatible = "simple-bus";
+			reg = <0x0 0x70000000 0x0 0x10000000>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges;
+
+			uart0: serial@70000000 {
+				compatible = "sprd,sc9836-uart";
+				reg = <0 0x70000000 0 0x100>;
+				interrupts = <0 2 0xf04>;
+				clocks = <&clk26mhz>;
+				status = "disabled";
+			};
+
+			uart1: serial@70100000 {
+				compatible = "sprd,sc9836-uart";
+				reg = <0 0x70100000 0 0x100>;
+				interrupts = <0 3 0xf04>;
+				clocks = <&clk26mhz>;
+				status = "disabled";
+			};
+
+			uart2: serial@70200000 {
+				compatible = "sprd,sc9836-uart";
+				reg = <0 0x70200000 0 0x100>;
+				interrupts = <0 2 0xf04>;
+				clocks = <&clk26mhz>;
+				status = "disabled";
+			};
+
+			uart3: serial@70300000 {
+				compatible = "sprd,sc9836-uart";
+				reg = <0 0x70300000 0 0x100>;
+				interrupts = <0 3 0xf04>;
+				clocks = <&clk26mhz>;
+				status = "disabled";
+			};
+		};
+	};
+
+	clocks {
+		clk26mhz: clk26mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <26000000>;
+		};
+	};
+};
-- 
1.7.9.5

