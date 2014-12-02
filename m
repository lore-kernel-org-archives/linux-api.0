From: Mark Yao <mark.yao@rock-chips.com>
Subject: [PATCH v15 2/3] dt-bindings: video: Add for rockchip display subsytem
Date: Tue,  2 Dec 2014 17:16:55 +0800
Message-ID: <1417511815-7182-1-git-send-email-mark.yao@rock-chips.com>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-doc-owner@vger.kernel.org
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>, David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Randy Dunlap <rdunlap@infradead.org>, Grant Likely <grant.likely@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>, Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org, dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net, djkurtz@chromium.org, cf@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com, yxj@rock-chips.com, xw@rock-chips.com, Mark Yao <mark.yao@rock-chips.com>
List-Id: linux-api@vger.kernel.org

This add a display subsystem comprise the all display interface nodes.

Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
Changes in v2:
- add DRM master device node to list all display nodes that comprise
  the graphics subsystem.

Changes in v3: None

Changes in v4: None

Changes in v5: None

Changes in v6: None

Changes in v7: None

Changes in v8: None

Changes in v9: None

Changes in v10: None

Changes in v11: None

Changes in v12: None

Changes in v13: None

Changes in v14: None

Changes in v15: None

 .../devicetree/bindings/video/rockchip-drm.txt     |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-drm.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-drm.txt b/Documentation/devicetree/bindings/video/rockchip-drm.txt
new file mode 100644
index 0000000..7fff582
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-drm.txt
@@ -0,0 +1,19 @@
+Rockchip DRM master device
+================================
+
+The Rockchip DRM master device is a virtual device needed to list all
+vop devices or other display interface nodes that comprise the
+graphics subsystem.
+
+Required properties:
+- compatible: Should be "rockchip,display-subsystem"
+- ports: Should contain a list of phandles pointing to display interface port
+  of vop devices. vop definitions as defined in
+  Documentation/devicetree/bindings/video/rockchip-vop.txt
+
+example:
+
+display-subsystem {
+	compatible = "rockchip,display-subsystem";
+	ports = <&vopl_out>, <&vopb_out>;
+};
-- 
1.7.9.5


