From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v4 2/5] Documentation: DT: Add bindings for Spreadtrum SoC Platform
Date: Thu, 4 Dec 2014 19:34:17 +0800
Message-ID: <1417692860-18841-3-git-send-email-chunyan.zhang@spreadtrum.com>
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

Adds Spreadtrum's prefix "sprd" to vendor-prefixes file.
Adds the devicetree binding documentations for Spreadtrum's sc9836-uart
and SC9836 SoC based on the Sharkl64 Platform which is a 64-bit SoC
Platform of Spreadtrum.

Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
---
 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +++++++++++
 .../devicetree/bindings/serial/sprd-uart.txt       |    9 +++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 3 files changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt

diff --git a/Documentation/devicetree/bindings/arm/sprd.txt b/Documentation/devicetree/bindings/arm/sprd.txt
new file mode 100644
index 0000000..31a629d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/sprd.txt
@@ -0,0 +1,11 @@
+Spreadtrum SoC Platforms Device Tree Bindings
+----------------------------------------------------
+
+Sharkl64 is a Spreadtrum's SoC Platform which is based
+on ARM 64-bit processor.
+
+SC9836 openphone board with SC9836 SoC based on the
+Sharkl64 Platform shall have the following properties.
+
+Required root node properties:
+        - compatible = "sprd,sc9836-openphone", "sprd,sc9836";
diff --git a/Documentation/devicetree/bindings/serial/sprd-uart.txt b/Documentation/devicetree/bindings/serial/sprd-uart.txt
new file mode 100644
index 0000000..9000e2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
@@ -0,0 +1,9 @@
+* Spreadtrum serial UART
+
+Required properties:
+- compatible: must be "sprd,sc9836-uart"
+- reg: offset and length of the register set for the device
+- interrupts: exactly one interrupt specifier
+
+Optional properties:
+- clocks: phandles to input clocks.
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 723999d..ce99ecdfb 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -142,6 +142,7 @@ snps 	Synopsys, Inc.
 solidrun	SolidRun
 sony	Sony Corporation
 spansion	Spansion Inc.
+sprd	Spreadtrum Communications Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
-- 
1.7.9.5

