From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v5 2/5] Documentation: DT: Add bindings for Spreadtrum SoC
 Platform
Date: Fri, 16 Jan 2015 18:00:08 +0800
Message-ID: <1421402411-3479-3-git-send-email-chunyan.zhang@spreadtrum.com>
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

Adds Spreadtrum's prefix "sprd" to vendor-prefixes file.
Adds the devicetree binding documentations for Spreadtrum's sc9836-uart
and SC9836 SoC based on the Sharkl64 Platform which is a 64-bit SoC
Platform of Spreadtrum.

Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
---
 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +++++++++++
 .../devicetree/bindings/serial/sprd-uart.txt       |    7 +++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 3 files changed, 19 insertions(+)
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
index 0000000..2aff0f2
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
@@ -0,0 +1,7 @@
+* Spreadtrum serial UART
+
+Required properties:
+- compatible: must be "sprd,sc9836-uart"
+- reg: offset and length of the register set for the device
+- interrupts: exactly one interrupt specifier
+- clocks: phandles to input clocks.
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index b1df0ad..0a8384f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -153,6 +153,7 @@ snps	Synopsys, Inc.
 solidrun	SolidRun
 sony	Sony Corporation
 spansion	Spansion Inc.
+sprd	Spreadtrum Communications Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
-- 
1.7.9.5
