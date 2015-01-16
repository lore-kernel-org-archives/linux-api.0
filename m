From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v5 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC in
 dts and Makefile
Date: Fri, 16 Jan 2015 18:00:09 +0800
Message-ID: <1421402411-3479-4-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836-v5>
 <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: gregkh@linuxfoundation.org, mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com, jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de, florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com, hytszk@gmail.com, grant.likely@linaro.org, antonynpavlov@gmail.com, Joel.Schopp@amd.com, Suravee.Suthikulpanit@amd.com, shawn.guo@linaro.org, lea.yan@linaro.org, jorge.ramirez-ortiz@linaro.org, lee.jones@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>

Adds the device tree support for Spreadtrum SC9836 SoC which is based on
Sharkl64 platform.

Sharkl64 platform contains the common nodes of Spreadtrum's arm64-based SoCs.

Signed-off-by: Zhizhou Zhang <zhizhou.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
---
 arch/arm64/boot/dts/Makefile                  |    1 +
 arch/arm64/boot/dts/sprd/Makefile             |    5 ++
 arch/arm64/boot/dts/sprd/sc9836-openphone.dts |   49 +++++++++++++++++
 arch/arm64/boot/dts/sprd/sc9836.dtsi          |   73 +++++++++++++++++++++++++
 arch/arm64/boot/dts/sprd/sharkl64.dtsi        |   67 +++++++++++++++++++++++
 5 files changed, 195 insertions(+)
 create mode 100644 arch/arm64/boot/dts/sprd/Makefile
 create mode 100644 arch/arm64/boot/dts/sprd/sc9836-openphone.dts
 create mode 100644 arch/arm64/boot/dts/sprd/sc9836.dtsi
 create mode 100644 arch/arm64/boot/dts/sprd/sharkl64.dtsi

diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index 3b8d427..806a717 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -2,6 +2,7 @@ dts-dirs += amd
 dts-dirs += apm
 dts-dirs += arm
 dts-dirs += cavium
+dts-dirs += sprd
 
 always		:= $(dtb-y)
 subdir-y	:= $(dts-dirs)
diff --git a/arch/arm64/boot/dts/sprd/Makefile b/arch/arm64/boot/dts/sprd/Makefile
new file mode 100644
index 0000000..b658c5e
--- /dev/null
+++ b/arch/arm64/boot/dts/sprd/Makefile
@@ -0,0 +1,5 @@
+dtb-$(CONFIG_ARCH_SPRD) += sc9836-openphone.dtb
+
+always		:= $(dtb-y)
+subdir-y	:= $(dts-dirs)
+clean-files	:= *.dtb
diff --git a/arch/arm64/boot/dts/sprd/sc9836-openphone.dts b/arch/arm64/boot/dts/sprd/sc9836-openphone.dts
new file mode 100644
index 0000000..b8a69b2
--- /dev/null
+++ b/arch/arm64/boot/dts/sprd/sc9836-openphone.dts
@@ -0,0 +1,49 @@
+/*
+ * Spreadtrum SC9836 openphone board DTS file
+ *
+ * Copyright (C) 2014, Spreadtrum Communications Inc.
+ *
+ * This file is licensed under a dual GPLv2 or X11 license.
+ */
+
+/dts-v1/;
+
+#include "sc9836.dtsi"
+
+/ {
+	model = "Spreadtrum SC9836 Openphone Board";
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
diff --git a/arch/arm64/boot/dts/sprd/sc9836.dtsi b/arch/arm64/boot/dts/sprd/sc9836.dtsi
new file mode 100644
index 0000000..2559d09
--- /dev/null
+++ b/arch/arm64/boot/dts/sprd/sc9836.dtsi
@@ -0,0 +1,73 @@
+/*
+ * Spreadtrum SC9836 SoC DTS file
+ *
+ * Copyright (C) 2014, Spreadtrum Communications Inc.
+ *
+ * This file is licensed under a dual GPLv2 or X11 license.
+ */
+
+#include "sharkl64.dtsi"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
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
+
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			reg = <0x0 0x1>;
+			enable-method = "psci";
+		};
+
+		cpu@2 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			reg = <0x0 0x2>;
+			enable-method = "psci";
+		};
+
+		cpu@3 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a53", "arm,armv8";
+			reg = <0x0 0x3>;
+			enable-method = "psci";
+		};
+	};
+
+	gic: interrupt-controller@12001000 {
+		compatible = "arm,gic-400";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0 0x12001000 0 0x1000>,
+		      <0 0x12002000 0 0x2000>,
+		      <0 0x12004000 0 0x2000>,
+		      <0 0x12006000 0 0x2000>;
+	};
+
+	psci {
+		compatible	= "arm,psci";
+		method		= "smc";
+		cpu_on		= <0xc4000003>;
+		cpu_off		= <0x84000002>;
+		cpu_suspend	= <0xc4000001>;
+	};
+
+	timer {
+		compatible = "arm,armv8-timer";
+		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
+	};
+};
diff --git a/arch/arm64/boot/dts/sprd/sharkl64.dtsi b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
new file mode 100644
index 0000000..b08989d
--- /dev/null
+++ b/arch/arm64/boot/dts/sprd/sharkl64.dtsi
@@ -0,0 +1,67 @@
+/*
+ * Spreadtrum Sharkl64 platform DTS file
+ *
+ * Copyright (C) 2014, Spreadtrum Communications Inc.
+ *
+ * This file is licensed under a dual GPLv2 or X11 license.
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
+	clk26mhz: clk26mhz {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <26000000>;
+	};
+};
-- 
1.7.9.5
