From: Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH v4 3/5] dt-bindings: video: Add documentation for rockchip vop
Date: Mon, 22 Sep 2014 18:57:09 +0800
Message-ID: <1411383429-1974-1-git-send-email-mark.yao@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411382820-1615-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dbehr-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Mark yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This adds binding documentation for Rockchip SoC VOP driver.

Signed-off-by: Mark Yao <mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---
Changes in v2:
- rename "lcdc" to "vop"
- add vop reset
- add iommu node
- add port for display-subsystem

Changes in v3: None

Changes in v4: None

 .../devicetree/bindings/video/rockchip-vop.txt     |   58 ++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-vop.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-vop.txt b/Documentation/devicetree/bindings/video/rockchip-vop.txt
new file mode 100644
index 0000000..d15351f
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-vop.txt
@@ -0,0 +1,58 @@
+device-tree bindings for rockchip soc display controller (vop)
+
+VOP (Visual Output Processor) is the Display Controller for the Rockchip
+series of SoCs which transfers the image data from a video memory
+buffer to an external LCD interface.
+
+Required properties:
+- compatible: value should be one of the following
+		"rockchip,rk3288-vop";
+
+- interrupts: should contain a list of all VOP IP block interrupts in the
+		 order: VSYNC, LCD_SYSTEM. The interrupt specifier
+		 format depends on the interrupt controller used.
+
+- clocks: must include clock specifiers corresponding to entries in the
+		clock-names property.
+
+- clock-names: Must contain
+		aclk_vop: for ddr buffer transfer.
+		hclk_vop: for ahb bus to R/W the phy regs.
+		dclk_vop: pixel clock.
+
+- resets: Must contain an entry for each entry in reset-names.
+  See ../reset/reset.txt for details.
+- reset-names: Must include the following entries:
+  - axi
+  - ahb
+  - dclk
+
+- iommus: required a iommu node
+
+- port: A port node with endpoint definitions as defined in
+  Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+SoC specific DT entry:
+	vopb: vopb@ff930000 {
+		compatible = "rockchip,rk3288-vop";
+		reg = <0xff930000 0x19c>;
+		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_VOP0>, <&cru DCLK_VOP0>, <&cru HCLK_VOP0>;
+		clock-names = "aclk_vop", "dclk_vop", "hclk_vop";
+		resets = <&cru SRST_LCDC1_AXI>, <&cru SRST_LCDC1_AHB>, <&cru SRST_LCDC1_DCLK>;
+		reset-names = "axi", "ahb", "dclk";
+		iommus = <&vopb_mmu>;
+		vopb_out: port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			vopb_out_edp: endpoint@0 {
+				reg = <0>;
+				remote-endpoint=<&edp_in_vopb>;
+			};
+			vopb_out_hdmi: endpoint@1 {
+				reg = <1>;
+				remote-endpoint=<&hdmi_in_vopb>;
+			};
+		};
+	};
-- 
1.7.9.5
