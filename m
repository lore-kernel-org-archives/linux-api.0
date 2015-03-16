From: =?UTF-8?q?S=C3=A9bastien=20Szymanski?=
	<sebastien.szymanski@armadeus.com>
Subject: [PATCH 1/2] drm_modes: videomode: add pos/neg pixel clock polarity flag
Date: Mon, 16 Mar 2015 18:29:03 +0100
Message-ID: <1426526944-16762-1-git-send-email-sebastien.szymanski@armadeus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Philipp Zabel <p.zabel@pengutronix.de>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: =?UTF-8?q?S=C3=A9bastien=20Szymanski?= <sebastien.szymanski@armadeus.com>, Steve Longerbeam <steve_longerbeam@mentor.com>
List-Id: linux-api@vger.kernel.org

=46rom: Steve Longerbeam <steve_longerbeam@mentor.com>

[S=C3=A9bastien - rebase, update drm_display_mode_to_videomode function=
]

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus.c=
om>
---
 drivers/gpu/drm/drm_modes.c | 8 ++++++++
 include/uapi/drm/drm_mode.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 487d0e3..464828f 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -611,6 +611,10 @@ void drm_display_mode_from_videomode(const struct =
videomode *vm,
 		dmode->flags |=3D DRM_MODE_FLAG_DBLSCAN;
 	if (vm->flags & DISPLAY_FLAGS_DOUBLECLK)
 		dmode->flags |=3D DRM_MODE_FLAG_DBLCLK;
+	if (vm->flags & DISPLAY_FLAGS_PIXDATA_POSEDGE)
+		dmode->flags |=3D DRM_MODE_FLAG_PCLK;
+	else if (vm->flags & DISPLAY_FLAGS_PIXDATA_NEGEDGE)
+		dmode->flags |=3D DRM_MODE_FLAG_NCLK;
 	drm_mode_set_name(dmode);
 }
 EXPORT_SYMBOL_GPL(drm_display_mode_from_videomode);
@@ -652,6 +656,10 @@ void drm_display_mode_to_videomode(const struct dr=
m_display_mode *dmode,
 		vm->flags |=3D DISPLAY_FLAGS_DOUBLESCAN;
 	if (dmode->flags & DRM_MODE_FLAG_DBLCLK)
 		vm->flags |=3D DISPLAY_FLAGS_DOUBLECLK;
+	if (dmode->flags & DRM_MODE_FLAG_PCLK)
+		vm->flags |=3D DISPLAY_FLAGS_PIXDATA_POSEDGE;
+	else if (dmode->flags & DRM_MODE_FLAG_NCLK)
+		vm->flags |=3D DISPLAY_FLAGS_PIXDATA_NEGEDGE;
 }
 EXPORT_SYMBOL_GPL(drm_display_mode_to_videomode);
=20
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index ca788e0..1abb2fc 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -72,6 +72,10 @@
 #define  DRM_MODE_FLAG_3D_L_DEPTH_GFX_GFX_DEPTH	(6<<14)
 #define  DRM_MODE_FLAG_3D_TOP_AND_BOTTOM	(7<<14)
 #define  DRM_MODE_FLAG_3D_SIDE_BY_SIDE_HALF	(8<<14)
+/* drive data on rising pixclk edge */
+#define DRM_MODE_FLAG_PCLK			(1<<19)
+/* drive data on falling pixclk edge */
+#define DRM_MODE_FLAG_NCLK			(1<<20)
=20
=20
 /* DPMS flags */
--=20
2.0.5
