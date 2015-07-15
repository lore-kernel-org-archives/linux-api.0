From: Manfred Schlaegl <manfred.schlaegl-RbZlAiThDcE@public.gmane.org>
Subject: [RFC PATCH 1/2] drm: add support for for clk and de polarity
Date: Wed, 15 Jul 2015 17:50:18 +0200
Message-ID: <55A6813A.8090706@gmx.at>
References: <55A67FDB.8010602@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A67FDB.8010602-RbZlAiThDcE@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manfred Schlaegl <manfred.schlaegl-hfTNJOUbDMh54TAoqtyWWQ@public.gmane.org>, Steve Longerbeam <slongerbeam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Deepak Das <deepak_das-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Jiada Wang <jiada_wang-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

To get full support for parallel and LVDS displays with drm:
Add representation for clock and data enable polarity in drm_display_mode
flags (similar to HSYNC/VSYNC polarity) and update conversion functions
from/to videomode accordingly.

This is especially important for embedded devices where parallel(RGB) and
LVDS displays are still widely used and drm already plays an important
role.

Tested on Freescale i.MX53(parallel) and i.MX6(LVDS).

Background:
There was the ability to set polarity of clock and data enable signals
in devicetree(display-timing), struct display_timing and struct videomode,
but there was no representation for this in struct drm_display_mode.
Example on Freescale i.MX53/i.MX6 SoC's:
 * A parallel display using different clock polarity is set up using
   display-timing in devicetree
 * ipuv3 parallel outputs clock with wrong polarity

Signed-off-by: Manfred Schlaegl <manfred.schlaegl-RbZlAiThDcE@public.gmane.org>
---
 drivers/gpu/drm/drm_modes.c | 16 ++++++++++++++++
 include/uapi/drm/drm_mode.h |  5 +++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index cd74a09..dbb28b7 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -605,6 +605,14 @@ void drm_display_mode_from_videomode(const struct videomode *vm,
 		dmode->flags |= DRM_MODE_FLAG_PVSYNC;
 	else if (vm->flags & DISPLAY_FLAGS_VSYNC_LOW)
 		dmode->flags |= DRM_MODE_FLAG_NVSYNC;
+	if (vm->flags & DISPLAY_FLAGS_DE_HIGH)
+		dmode->flags |= DRM_MODE_FLAG_PDE;
+	else if (vm->flags & DISPLAY_FLAGS_DE_LOW)
+		dmode->flags |= DRM_MODE_FLAG_NDE;
+	if (vm->flags & DISPLAY_FLAGS_PIXDATA_POSEDGE)
+		dmode->flags |= DRM_MODE_FLAG_PPIXDATA;
+	else if (vm->flags & DISPLAY_FLAGS_PIXDATA_NEGEDGE)
+		dmode->flags |= DRM_MODE_FLAG_NPIXDATA;
 	if (vm->flags & DISPLAY_FLAGS_INTERLACED)
 		dmode->flags |= DRM_MODE_FLAG_INTERLACE;
 	if (vm->flags & DISPLAY_FLAGS_DOUBLESCAN)
@@ -646,6 +654,14 @@ void drm_display_mode_to_videomode(const struct drm_display_mode *dmode,
 		vm->flags |= DISPLAY_FLAGS_VSYNC_HIGH;
 	else if (dmode->flags & DRM_MODE_FLAG_NVSYNC)
 		vm->flags |= DISPLAY_FLAGS_VSYNC_LOW;
+	if (dmode->flags & DRM_MODE_FLAG_PDE)
+		vm->flags |= DISPLAY_FLAGS_DE_HIGH;
+	else if (dmode->flags & DRM_MODE_FLAG_NDE)
+		vm->flags |= DISPLAY_FLAGS_DE_LOW;
+	if (dmode->flags & DRM_MODE_FLAG_PPIXDATA)
+		vm->flags |= DISPLAY_FLAGS_PIXDATA_POSEDGE;
+	else if (dmode->flags & DRM_MODE_FLAG_NPIXDATA)
+		vm->flags |= DISPLAY_FLAGS_PIXDATA_NEGEDGE;
 	if (dmode->flags & DRM_MODE_FLAG_INTERLACE)
 		vm->flags |= DISPLAY_FLAGS_INTERLACED;
 	if (dmode->flags & DRM_MODE_FLAG_DBLSCAN)
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index 359107a..cb4912b 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -72,6 +72,11 @@
 #define  DRM_MODE_FLAG_3D_L_DEPTH_GFX_GFX_DEPTH	(6<<14)
 #define  DRM_MODE_FLAG_3D_TOP_AND_BOTTOM	(7<<14)
 #define  DRM_MODE_FLAG_3D_SIDE_BY_SIDE_HALF	(8<<14)
+/* flags for display data enable and clock polarity */
+#define DRM_MODE_FLAG_PDE			(1<<19)
+#define DRM_MODE_FLAG_NDE			(1<<20)
+#define DRM_MODE_FLAG_PPIXDATA			(1<<21)
+#define DRM_MODE_FLAG_NPIXDATA			(1<<22)
 
 
 /* DPMS flags */
-- 
2.1.4
