From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
Subject: [RFC PATCH 2/2] gpu: ipu-v3: use clock and de polarity from videomode
Date: Wed, 15 Jul 2015 17:51:27 +0200
Message-ID: <55A6817F.4000205@gmx.at>
References: <55A67FDB.8010602@gmx.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55A67FDB.8010602@gmx.at>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Philipp Zabel <p.zabel@pengutronix.de>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Manfred Schlaegl <manfred.schlaegl@ginzinger.com>, Steve Longerbeam <slongerbeam@gmail.com>, Deepak Das <deepak_das@mentor.com>, Jiada Wang <jiada_wang@mentor.com>, linux-fbdev@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch depends on "drm: add support for for clk and de polarity".
Since "drm: add support for for clk and de polarity", clock and data
polarity set in devicetree are passed correctly through drm_display_mode
to videomode flags used by ipuv3.
Removes custom configuration flags for clock and de polarities and use
polarity flags from given videomode.
Keeps compatibility to current settings and device tree descriptions,
by setting data enable polarity to high, if not explicitly set to low by
flags.

display-timings                 resulting polarity of pixel clock
                                past    now
pixelclk-active unset           0       0
pixelclk-active = 0             0       0
pixelclk-active = 1             0       1       <--- corrected

display-timings                 resulting polarity of data enable
                                past    now
de-active unset                 1       1
de-active = 0                   1       0       <--- corrected
de-active = 1                   1       1

Tested on Freescale i.MX53(parallel) and i.MX6(LVDS).

Signed-off-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
---
 drivers/gpu/drm/imx/ipuv3-crtc.c | 2 --
 drivers/gpu/ipu-v3/ipu-di.c      | 4 ++--
 include/video/imx-ipu-v3.h       | 2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 7bc8301..6813271 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -172,8 +172,6 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 	else
 		sig_cfg.clkflags = 0;
 
-	sig_cfg.enable_pol = 1;
-	sig_cfg.clk_pol = 0;
 	sig_cfg.bus_format = ipu_crtc->bus_format;
 	sig_cfg.v_to_h_sync = 0;
 	sig_cfg.hsync_pin = ipu_crtc->di_hsync_pin;
diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
index 2970c6b..0b1a7d2 100644
--- a/drivers/gpu/ipu-v3/ipu-di.c
+++ b/drivers/gpu/ipu-v3/ipu-di.c
@@ -621,7 +621,7 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 		}
 	}
 
-	if (sig->clk_pol)
+	if (sig->mode.flags & DISPLAY_FLAGS_PIXDATA_POSEDGE)
 		di_gen |= DI_GEN_POLARITY_DISP_CLK;
 
 	ipu_di_write(di, di_gen, DI_GENERAL);
@@ -632,7 +632,7 @@ int ipu_di_init_sync_panel(struct ipu_di *di, struct ipu_di_signal_cfg *sig)
 	reg = ipu_di_read(di, DI_POL);
 	reg &= ~(DI_POL_DRDY_DATA_POLARITY | DI_POL_DRDY_POLARITY_15);
 
-	if (sig->enable_pol)
+	if (!(sig->mode.flags & DISPLAY_FLAGS_DE_LOW))
 		reg |= DI_POL_DRDY_POLARITY_15;
 	if (sig->data_pol)
 		reg |= DI_POL_DRDY_DATA_POLARITY;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 85dedca..4178fa2 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -34,8 +34,6 @@ enum ipuv3_type {
  */
 struct ipu_di_signal_cfg {
 	unsigned data_pol:1;	/* true = inverted */
-	unsigned clk_pol:1;	/* true = rising edge */
-	unsigned enable_pol:1;
 
 	struct videomode mode;
 
-- 
2.1.4
