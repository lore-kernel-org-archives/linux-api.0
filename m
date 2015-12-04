From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3/4] drm, ipu-v3: use https://linuxtv.org for LinuxTV URL
Date: Fri,  4 Dec 2015 10:46:22 -0200
Message-ID: <4a3d0cb06b3e4248ba4a659d7f2a7a8fa1a877fc.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
In-Reply-To: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Philipp Zabel <p.zabel@pengutronix.de>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

While https was always supported on linuxtv.org, only in
Dec 3 2015 the website is using valid certificates.

As we're planning to drop pure http support on some
future, change the references at DRM include and at
the ipu-v3 driver to point to the https://linuxtv.org
URL instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c | 2 +-
 include/uapi/drm/drm_fourcc.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 63eb16bf2cf0..883a314cd83a 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -161,7 +161,7 @@ static u32 ipu_ch_param_read_field(struct ipuv3_channel *ch, u32 wbs)
  * The DRM pixel formats and IPU internal representation are ordered the other
  * way around, with the first named component ordered at the most significant
  * bits. Further, V4L2 formats are not well defined:
- *     http://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html
+ *     https://linuxtv.org/downloads/v4l-dvb-apis/packed-rgb.html
  * We choose the interpretation which matches GStreamer behavior.
  */
 static int v4l2_pix_fmt_to_drm_fourcc(u32 pixelformat)
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 0b69a7753558..ee2d542c65f5 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -225,7 +225,7 @@
  * - multiple of 128 pixels for the width
  * - multiple of  32 pixels for the height
  *
- * For more information: see http://linuxtv.org/downloads/v4l-dvb-apis/re32.html
+ * For more information: see https://linuxtv.org/downloads/v4l-dvb-apis/re32.html
  */
 #define DRM_FORMAT_MOD_SAMSUNG_64_32_TILE	fourcc_mod_code(SAMSUNG, 1)
 
-- 
2.5.0
