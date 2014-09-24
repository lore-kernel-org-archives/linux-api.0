From: Mark yao <mark.yao@rock-chips.com>
Subject: [PATCH v5 3/3] dt-bindings: video: Add documentation for rockchip vop
Date: Wed, 24 Sep 2014 10:13:48 +0800
Message-ID: <1411524828-14714-1-git-send-email-mark.yao@rock-chips.com>
References: <1411524672-14524-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1411524672-14524-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-doc-owner@vger.kernel.org
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com, Mark yao <mark.yao@rock-chips.com>
List-Id: linux-api@vger.kernel.org

This adds binding documentation for Rockchip SoC VOP driver.

Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
Changes in v2:
- rename "lcdc" to "vop"
- add vop reset
- add iommu node
- add port for display-subsystem

Changes in v3: None

Changes in v4: None

Changes in v5: None

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


