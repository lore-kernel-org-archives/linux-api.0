From: Mark yao <mark.yao@rock-chips.com>
Subject: [PATCH v2 4/5] dt-bindings: video: Add documentation for rockchip edp
Date: Thu, 18 Sep 2014 17:41:07 +0800
Message-ID: <1411033268-9410-1-git-send-email-mark.yao@rock-chips.com>
References: <1411032884-9233-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1411032884-9233-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-doc-owner@vger.kernel.org
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com, Mark yao <mark.yao@rock-chips.com>, Jeff Chen <jeff.chen@rock-chips.com>
List-Id: linux-api@vger.kernel.org

Add binding documentation for Rockchip SoC EDP driver.

Signed-off-by: Jeff Chen <jeff.chen@rock-chips.com>
Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
changes in v2:
- add edp reset
- add panel node
- add port for display-subsystem

 .../devicetree/bindings/video/rockchip-edp.txt     |   50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-edp.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-edp.txt b/Documentation/devicetree/bindings/video/rockchip-edp.txt
new file mode 100644
index 0000000..515e806
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-edp.txt
@@ -0,0 +1,50 @@
+Rockchip RK3288 EDP interface
+================================
+
+Required properties:
+- compatible: "rockchip,rk3288-edp";
+
+- reg: physical base address of the controller and length
+- clocks: from common clock binding: handle to dp clock.
+	of memory mapped region.
+- clock-names: from common clock binding:
+	Required elements: "clk_edp"
+			"clk_edp_24m"
+			"pclk_edp"
+- resets: Must contain an entry for each entry in reset-names.
+	See ../reset/reset.txt for details.
+- reset-names: Must include the name "edp"
+
+- rockchip,grf: this soc should set GRF regs, so need get grf here.
+- rockchip,panel: required a simple panel node as described by
+	Documentation/devicetree/bindings/panel/simple-panel.txt
+
+- ports: contain a port node with endpoint definitions as defined in
+  Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+	edp: edp@ff970000 {
+		compatible = "rockchip,rk3288-edp";
+		reg = <0xff970000 0x4000>;
+		interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_EDP>, <&cru SCLK_EDP_24M>, <&cru PCLK_EDP_CTRL>;
+		clock-names = "clk_edp", "clk_edp_24m", "pclk_edp";
+		rockchip,grf = <&grf>;
+		resets = <&cru 111>;
+		reset-names = "edp";
+		rockchip,panel = <&panel>;
+		ports {
+			edp_in: port {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				edp_in_vopb: endpoint@0 {
+					reg = <0>;
+					remote-endpoint = <&vopb_out_edp>;
+				};
+				edp_in_vopl: endpoint@1 {
+					reg = <1>;
+					remote-endpoint = <&vopl_out_edp>;
+				};
+			};
+		};
+	};
-- 
1.7.9.5


