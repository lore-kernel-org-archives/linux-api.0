From: =?UTF-8?q?S=C3=A9bastien=20Szymanski?=
	<sebastien.szymanski-d2DlULPkwbNWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] imx-drm: ipuv3-crtc: Use DRM mode flags to configure pixel clock polarity
Date: Mon, 16 Mar 2015 18:29:04 +0100
Message-ID: <1426526944-16762-2-git-send-email-sebastien.szymanski@armadeus.com>
References: <1426526944-16762-1-git-send-email-sebastien.szymanski@armadeus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426526944-16762-1-git-send-email-sebastien.szymanski-d2DlULPkwbNWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?S=C3=A9bastien=20Szymanski?= <sebastien.szymanski-d2DlULPkwbNWk0Htik3J/w@public.gmane.org>, Mohsin Kazmi <mohsin_kazmi-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Steve Longerbeam <steve_longerbeam-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46rom: Steve Longerbeam <steve_longerbeam-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>

Previously, pixel clock polarity was hardcoded and wasn't configurable.
This patch adds support to configure the pixel clock polarity from the
DRM mode flags.

[S=C3=A9bastien - rebase]

Signed-off-by: Mohsin Kazmi <mohsin_kazmi-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Steve Longerbeam <steve_longerbeam-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus.c=
om>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipu=
v3-crtc.c
index 98551e3..71f888b 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -171,10 +171,12 @@ static int ipu_crtc_mode_set(struct drm_crtc *crt=
c,
 	else
 		sig_cfg.clkflags =3D 0;
=20
+	if (mode->flags & DRM_MODE_FLAG_PCLK)
+		sig_cfg.clk_pol =3D 1;
+
 	out_pixel_fmt =3D ipu_crtc->interface_pix_fmt;
=20
 	sig_cfg.enable_pol =3D 1;
-	sig_cfg.clk_pol =3D 0;
 	sig_cfg.pixel_fmt =3D out_pixel_fmt;
 	sig_cfg.v_to_h_sync =3D 0;
 	sig_cfg.hsync_pin =3D ipu_crtc->di_hsync_pin;
--=20
2.0.5
