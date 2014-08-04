From: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Subject: [PATCH 2/9] Add devicetree bindings for panels used by the Rockchip DRM
Date: Mon,  4 Aug 2014 12:47:00 +0800
Message-ID: <1407127620-1654-1-git-send-email-yzq@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rom Lemarchand <romlem-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, djkurtz-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, xjq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kfx-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cym-TNX95d0MmH7DzftRWevZcw@public.gmane.org, cf-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zwl-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xxm-TNX95d0MmH7DzftRWevZcw@public.gmane.org, huangtao-TNX95d0MmH7DzftRWevZcw@public.gmane.org, kever.yang-TNX95d0MmH7DzftRWevZcw@public.gmane.org, zhangqing-TNX95d0MmH7DzftRWevZcw@public.gmane.org, yxj-TNX95d0MmH7DzftRWevZcw@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, xw-TNX95d0MmH7DzftRWevZcw@public.gmane.org, mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: mark yao <yzq-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
---
 .../devicetree/bindings/video/rockchip-panel.txt   |   52 ++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-panel.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-panel.txt b/Documentation/devicetree/bindings/video/rockchip-panel.txt
new file mode 100644
index 0000000..9fc200a
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-panel.txt
@@ -0,0 +1,52 @@
+Rockchip LCD Display interface
+================================
+Required properties:
+-compatible: "rockchip,rockchip-panel";
+
+- rockchip,output-face: lcdc display mode value should set as following
+		"r8g8b8": 24bit display port, R8 G8 B8
+		"r6g6b6": 18bit display port, R6 G6 B6
+		"r5g6b5": 16bit display port, R5 G6 B5
+
+Optional properties:
+- display-timings: timings for the connected panel as described by
+	Documentation/devicetree/bindings/video/display-timing.txt
+Optional properties:
+- rockchip,power-gpios: gpio to power on or off the LCD (as many as needed)
+- lcdc-vcc18: Defined if power supply of lcd controller is 1.8v,
+		Not defined if power supply of lcd controller is 3.3v.
+- output-dither: support dithering the output color.
+- color-swap-rb: swap R and B color per pixel.
+- color-swap-rg: swap R and G color per pixel.
+- color-swap-bg: swap B and G color per pixel.
+
+Example:
+	panel {
+		compatible = "rockchip,rockchip-panel";
+		rockchip,output-face = "r6g6b6";
+
+		enable-gpios = <&gpio7 3 GPIO_ACTIVE_HIGH
+				&gpio7 4 GPIO_ACTIVE_HIGH>;
+		output-dither;
+
+		display-timings {
+			native-mode = <&timing_disp0>;
+
+			timing_disp0: 1280x800 {
+				clock-frequency = <71000000>;
+				hactive = <1280>;
+				vactive = <800>;
+				hback-porch = <100>;
+				hfront-porch = <18>;
+				vback-porch = <8>;
+				vfront-porch = <6>;
+				hsync-len = <10>;
+				vsync-len = <2>;
+				hsync-active = <0>;
+				vsync-active = <0>;
+				de-active = <0>;
+				pixelclk-active = <0>;
+			};
+		};
+
+	};
-- 
1.7.9.5
