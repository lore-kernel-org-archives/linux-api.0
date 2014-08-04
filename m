From: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH 4/9] Add devicetree bindings for Rockchip lcd controller
Date: Mon,  4 Aug 2014 12:50:27 +0800
Message-ID: <1407127827-1741-1-git-send-email-yzq@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zwl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zhangqing-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---
 .../devicetree/bindings/video/rockchip-lcdc.txt    |   33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-lcdc.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-lcdc.txt b/Documentation/devicetree/bindings/video/rockchip-lcdc.txt
new file mode 100644
index 0000000..7fb2b73
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-lcdc.txt
@@ -0,0 +1,33 @@
+Device-Tree bindings for Rockchip SoC display controller (LCDC)
+
+LCDC (LCD Controller) is the Display Controller for the Rockchip
+series of SoCs which transfers the image data from a video memory
+buffer to an external LCD interface.
+
+Required properties:
+- compatible: value should be one of the following
+		"rockchip,rk3066-lcdc";
+		"rockchip,rk3188-lcdc";
+		"rockchip,rk3288-lcdc";
+
+- interrupts: should contain a list of all LCDC IP block interrupts in the
+		 order: VSYNC, LCD_SYSTEM. The interrupt specifier
+		 format depends on the interrupt controller used.
+
+- clocks: must include clock specifiers corresponding to entries in the
+		clock-names property.
+
+- clock-names: Must contain
+		aclk_lcdc: for ddr buffer transfer.
+		hclk_lcdc: for ahb bus to R/W the phy regs.
+		dclk_lcdc: pixel clock.
+
+Example:
+SoC specific DT entry:
+	lcdc1: lcdc@ff940000 {
+		compatible = "rockchip,rk3288-lcdc";
+		reg = <0xff940000 0x19c>;
+		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_LCDC1>, <&cru DCLK_LCDC1>, <&cru HCLK_LCDC1>;
+		clock-names = "aclk_lcdc", "dclk_lcdc", "hclk_lcdc";
+	};
-- 
1.7.9.5
