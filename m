From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 06/10] [media] platform: Make use of media_bus_format enum
Date: Fri,  7 Nov 2014 15:07:45 +0100
Message-ID: <1415369269-5064-7-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Reference new definitions in all platform drivers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 Documentation/video4linux/soc-camera.txt           |   2 +-
 arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   4 +-
 arch/arm/mach-davinci/dm355.c                      |   7 +-
 arch/arm/mach-davinci/dm365.c                      |   7 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   2 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  14 +--
 drivers/media/platform/davinci/vpbe.c              |   2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   4 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   8 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   2 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |  14 +--
 drivers/media/platform/exynos4-is/fimc-core.h      |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |  16 +--
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |  26 ++---
 drivers/media/platform/exynos4-is/fimc-lite.c      |  14 +--
 drivers/media/platform/exynos4-is/fimc-reg.c       |  14 +--
 drivers/media/platform/exynos4-is/mipi-csis.c      |  14 +--
 drivers/media/platform/marvell-ccic/mcam-core.c    |  21 ++--
 drivers/media/platform/marvell-ccic/mcam-core.h    |   2 +-
 drivers/media/platform/omap3isp/ispccdc.c          | 112 ++++++++++-----------
 drivers/media/platform/omap3isp/ispccp2.c          |  18 ++--
 drivers/media/platform/omap3isp/ispcsi2.c          |  42 ++++----
 drivers/media/platform/omap3isp/isppreview.c       |  60 ++++++-----
 drivers/media/platform/omap3isp/ispresizer.c       |  19 ++--
 drivers/media/platform/omap3isp/ispvideo.c         |  95 +++++++++--------
 drivers/media/platform/omap3isp/ispvideo.h         |  10 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |  10 +-
 drivers/media/platform/s3c-camif/camif-regs.c      |   8 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   2 +-
 drivers/media/platform/sh_vou.c                    |   8 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |  22 ++--
 drivers/media/platform/soc_camera/mx2_camera.c     |  26 +++--
 drivers/media/platform/soc_camera/mx3_camera.c     |   6 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |  36 +++----
 drivers/media/platform/soc_camera/pxa_camera.c     |  16 +--
 drivers/media/platform/soc_camera/rcar_vin.c       |  14 +--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  20 ++--
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  38 +++----
 drivers/media/platform/soc_camera/soc_camera.c     |   2 +-
 .../platform/soc_camera/soc_camera_platform.c      |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |  78 +++++++-------
 drivers/media/platform/via-camera.c                |   8 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |  14 +--
 drivers/media/platform/vsp1/vsp1_hsit.c            |  12 +--
 drivers/media/platform/vsp1/vsp1_lif.c             |  10 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |  14 +--
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  10 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |  12 +--
 drivers/media/platform/vsp1/vsp1_uds.c             |  10 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  42 ++++----
 include/media/davinci/vpbe.h                       |   2 +-
 include/media/davinci/vpbe_venc.h                  |   5 +-
 include/media/exynos-fimc.h                        |   2 +-
 include/media/soc_camera.h                         |   2 +-
 include/media/soc_mediabus.h                       |   6 +-
 59 files changed, 483 insertions(+), 495 deletions(-)

diff --git a/Documentation/video4linux/soc-camera.txt b/Documentation/video4linux/soc-camera.txt
index daa9e2a..84f41cf 100644
--- a/Documentation/video4linux/soc-camera.txt
+++ b/Documentation/video4linux/soc-camera.txt
@@ -151,7 +151,7 @@ they are transferred over a media bus. Soc-camera provides support to
 conveniently manage these formats. A table of standard transformations is
 maintained by soc-camera core, which describes, what FOURCC pixel format will
 be obtained, if a media-bus pixel format is stored in memory according to
-certain rules. E.g. if V4L2_MBUS_FMT_YUYV8_2X8 data is sampled with 8 bits per
+certain rules. E.g. if MEDIA_BUS_FMT_YUYV8_2X8 data is sampled with 8 bits per
 sample and stored in memory in the little-endian order with no gaps between
 bytes, data in memory will represent the V4L2_PIX_FMT_YUYV FOURCC format. These
 standard transformations will be used by soc-camera or by camera host drivers to
diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 06d63d5..b46b4d2 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -294,7 +294,7 @@ static struct vpbe_output dm355evm_vpbe_outputs[] = {
 		.default_mode	= "ntsc",
 		.num_modes	= ARRAY_SIZE(dm355evm_enc_preset_timing),
 		.modes		= dm355evm_enc_preset_timing,
-		.if_params	= V4L2_MBUS_FMT_FIXED,
+		.if_params	= MEDIA_BUS_FMT_FIXED,
 	},
 };
 
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index e08a868..a756003 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -485,7 +485,7 @@ static struct vpbe_output dm365evm_vpbe_outputs[] = {
 		.default_mode	= "ntsc",
 		.num_modes	= ARRAY_SIZE(dm365evm_enc_std_timing),
 		.modes		= dm365evm_enc_std_timing,
-		.if_params	= V4L2_MBUS_FMT_FIXED,
+		.if_params	= MEDIA_BUS_FMT_FIXED,
 	},
 	{
 		.output		= {
@@ -498,7 +498,7 @@ static struct vpbe_output dm365evm_vpbe_outputs[] = {
 		.default_mode	= "480p59_94",
 		.num_modes	= ARRAY_SIZE(dm365evm_enc_preset_timing),
 		.modes		= dm365evm_enc_preset_timing,
-		.if_params	= V4L2_MBUS_FMT_FIXED,
+		.if_params	= MEDIA_BUS_FMT_FIXED,
 	},
 };
 
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 2f3ed3a..9cbeda7 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -785,14 +785,13 @@ static struct resource dm355_v4l2_disp_resources[] = {
 	},
 };
 
-static int dm355_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
-			    int field)
+static int dm355_vpbe_setup_pinmux(u32 if_type, int field)
 {
 	switch (if_type) {
-	case V4L2_MBUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
 		davinci_cfg_reg(DM355_VOUT_FIELD_G70);
 		break;
-	case V4L2_MBUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
 		if (field)
 			davinci_cfg_reg(DM355_VOUT_FIELD);
 		else
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 0ae8114..e3a3c54 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -1306,16 +1306,15 @@ static struct resource dm365_v4l2_disp_resources[] = {
 	},
 };
 
-static int dm365_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
-			    int field)
+static int dm365_vpbe_setup_pinmux(u32 if_type, int field)
 {
 	switch (if_type) {
-	case V4L2_MBUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
 		davinci_cfg_reg(DM365_VOUT_FIELD_G81);
 		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
 		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
 		break;
-	case V4L2_MBUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
 		if (field)
 			davinci_cfg_reg(DM365_VOUT_FIELD);
 		else
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index ca5d34b..a673624 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -1153,7 +1153,7 @@ static struct soc_camera_platform_info camera_info = {
 	.format_name = "UYVY",
 	.format_depth = 16,
 	.format = {
-		.code = V4L2_MBUS_FMT_UYVY8_2X8,
+		.code = MEDIA_BUS_FMT_UYVY8_2X8,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 		.field = V4L2_FIELD_NONE,
 		.width = 640,
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 5620e33..d4b01d4 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -338,7 +338,7 @@ static struct soc_camera_platform_info camera_info = {
 	.format_name = "UYVY",
 	.format_depth = 16,
 	.format = {
-		.code = V4L2_MBUS_FMT_UYVY8_2X8,
+		.code = MEDIA_BUS_FMT_UYVY8_2X8,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 		.field = V4L2_FIELD_NONE,
 		.width = 640,
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 9b5daa6..b3345b3 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -49,7 +49,7 @@
 struct bcap_format {
 	char *desc;
 	u32 pixelformat;
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 	int bpp; /* bits per pixel */
 	int dlen; /* data length for ppi in bits */
 };
@@ -116,35 +116,35 @@ static const struct bcap_format bcap_formats[] = {
 	{
 		.desc        = "YCbCr 4:2:2 Interleaved UYVY",
 		.pixelformat = V4L2_PIX_FMT_UYVY,
-		.mbus_code   = V4L2_MBUS_FMT_UYVY8_2X8,
+		.mbus_code   = MEDIA_BUS_FMT_UYVY8_2X8,
 		.bpp         = 16,
 		.dlen        = 8,
 	},
 	{
 		.desc        = "YCbCr 4:2:2 Interleaved YUYV",
 		.pixelformat = V4L2_PIX_FMT_YUYV,
-		.mbus_code   = V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code   = MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp         = 16,
 		.dlen        = 8,
 	},
 	{
 		.desc        = "YCbCr 4:2:2 Interleaved UYVY",
 		.pixelformat = V4L2_PIX_FMT_UYVY,
-		.mbus_code   = V4L2_MBUS_FMT_UYVY8_1X16,
+		.mbus_code   = MEDIA_BUS_FMT_UYVY8_1X16,
 		.bpp         = 16,
 		.dlen        = 16,
 	},
 	{
 		.desc        = "RGB 565",
 		.pixelformat = V4L2_PIX_FMT_RGB565,
-		.mbus_code   = V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.mbus_code   = MEDIA_BUS_FMT_RGB565_2X8_LE,
 		.bpp         = 16,
 		.dlen        = 8,
 	},
 	{
 		.desc        = "RGB 444",
 		.pixelformat = V4L2_PIX_FMT_RGB444,
-		.mbus_code   = V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
+		.mbus_code   = MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
 		.bpp         = 16,
 		.dlen        = 8,
 	},
@@ -161,7 +161,7 @@ static struct bcap_buffer *to_bcap_vb(struct vb2_buffer *vb)
 
 static int bcap_init_sensor_formats(struct bcap_device *bcap_dev)
 {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	struct bcap_format *sf;
 	unsigned int num_formats = 0;
 	int i, j;
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 33b9660..c5ab85f 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -227,7 +227,7 @@ static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
 			vpbe_current_encoder_info(vpbe_dev);
 	struct vpbe_config *cfg = vpbe_dev->cfg;
 	struct venc_platform_data *venc_device = vpbe_dev->venc_device;
-	enum v4l2_mbus_pixelcode if_params;
+	u32 if_params;
 	int enc_out_index;
 	int sd_index;
 	int ret = 0;
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index de55f47..3d0e3ae 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -414,13 +414,13 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 		/* assume V4L2_PIX_FMT_UYVY as default */
 		pix->pixelformat = V4L2_PIX_FMT_UYVY;
 		v4l2_fill_mbus_format(&mbus_fmt, pix,
-				V4L2_MBUS_FMT_YUYV10_2X10);
+				MEDIA_BUS_FMT_YUYV10_2X10);
 	} else {
 		pix->field = V4L2_FIELD_NONE;
 		/* assume V4L2_PIX_FMT_SBGGR8 */
 		pix->pixelformat = V4L2_PIX_FMT_SBGGR8;
 		v4l2_fill_mbus_format(&mbus_fmt, pix,
-				V4L2_MBUS_FMT_SBGGR8_1X8);
+				MEDIA_BUS_FMT_SBGGR8_1X8);
 	}
 
 	/* if sub device supports g_mbus_fmt, override the defaults */
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index b4c9f1d..91d226b 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -54,7 +54,7 @@ static const struct gsc_fmt gsc_formats[] = {
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 	}, {
 		.name		= "YUV 4:2:2 packed, CbYCrY",
 		.pixelformat	= V4L2_PIX_FMT_UYVY,
@@ -64,7 +64,7 @@ static const struct gsc_fmt gsc_formats[] = {
 		.corder		= GSC_CBCR,
 		.num_planes	= 1,
 		.num_comp	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_UYVY8_2X8,
 	}, {
 		.name		= "YUV 4:2:2 packed, CrYCbY",
 		.pixelformat	= V4L2_PIX_FMT_VYUY,
@@ -74,7 +74,7 @@ static const struct gsc_fmt gsc_formats[] = {
 		.corder		= GSC_CRCB,
 		.num_planes	= 1,
 		.num_comp	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_VYUY8_2X8,
 	}, {
 		.name		= "YUV 4:2:2 packed, YCrYCb",
 		.pixelformat	= V4L2_PIX_FMT_YVYU,
@@ -84,7 +84,7 @@ static const struct gsc_fmt gsc_formats[] = {
 		.corder		= GSC_CRCB,
 		.num_planes	= 1,
 		.num_comp	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YVYU8_2X8,
 	}, {
 		.name		= "YUV 4:4:4 planar, YCbYCr",
 		.pixelformat	= V4L2_PIX_FMT_YUV32,
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index ef0a656..0abdb17 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -117,7 +117,7 @@ enum gsc_yuv_fmt {
  * @flags: flags indicating which operation mode format applies to
  */
 struct gsc_fmt {
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 	char	*name;
 	u32	pixelformat;
 	u32	color;
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 3d2babd..8a2fd8c 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -749,7 +749,7 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
 		return -EINVAL;
 	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
 	f->pixelformat = fmt->fourcc;
-	if (fmt->fourcc == V4L2_MBUS_FMT_JPEG_1X8)
+	if (fmt->fourcc == MEDIA_BUS_FMT_JPEG_1X8)
 		f->flags |= V4L2_FMT_FLAG_COMPRESSED;
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index aee92d9..dbd74d8 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -81,7 +81,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.flags		= FMT_FLAGS_M2M_OUT | FMT_HAS_ALPHA,
 	}, {
 		.name		= "YUV 4:4:4",
-		.mbus_code	= V4L2_MBUS_FMT_YUV10_1X30,
+		.mbus_code	= MEDIA_BUS_FMT_YUV10_1X30,
 		.flags		= FMT_FLAGS_WRITEBACK,
 	}, {
 		.name		= "YUV 4:2:2 packed, YCbYCr",
@@ -90,7 +90,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.color		= FIMC_FMT_YCBYCR422,
 		.memplanes	= 1,
 		.colplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
 		.name		= "YUV 4:2:2 packed, CbYCrY",
@@ -99,7 +99,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.color		= FIMC_FMT_CBYCRY422,
 		.memplanes	= 1,
 		.colplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_UYVY8_2X8,
 		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
 		.name		= "YUV 4:2:2 packed, CrYCbY",
@@ -108,7 +108,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.color		= FIMC_FMT_CRYCBY422,
 		.memplanes	= 1,
 		.colplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_VYUY8_2X8,
 		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
 		.name		= "YUV 4:2:2 packed, YCrYCb",
@@ -117,7 +117,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.color		= FIMC_FMT_YCRYCB422,
 		.memplanes	= 1,
 		.colplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YVYU8_2X8,
 		.flags		= FMT_FLAGS_M2M | FMT_FLAGS_CAM,
 	}, {
 		.name		= "YUV 4:2:2 planar, Y/Cb/Cr",
@@ -190,7 +190,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.depth		= { 8 },
 		.memplanes	= 1,
 		.colplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_JPEG_1X8,
+		.mbus_code	= MEDIA_BUS_FMT_JPEG_1X8,
 		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
 	}, {
 		.name		= "S5C73MX interleaved UYVY/JPEG",
@@ -200,7 +200,7 @@ static struct fimc_fmt fimc_formats[] = {
 		.memplanes	= 2,
 		.colplanes	= 1,
 		.mdataplanes	= 0x2, /* plane 1 holds frame meta data */
-		.mbus_code	= V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8,
+		.mbus_code	= MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8,
 		.flags		= FMT_FLAGS_CAM | FMT_FLAGS_COMPRESSED,
 	},
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 6c75c6c..7328f08 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -579,8 +579,8 @@ static inline bool fimc_jpeg_fourcc(u32 pixelformat)
 
 static inline bool fimc_user_defined_mbus_fmt(u32 code)
 {
-	return (code == V4L2_MBUS_FMT_JPEG_1X8 ||
-		code == V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8);
+	return (code == MEDIA_BUS_FMT_JPEG_1X8 ||
+		code == MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8);
 }
 
 /* Return the alpha component bit mask */
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index be62d6b..60c7449 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -41,21 +41,21 @@ static const struct fimc_fmt fimc_isp_formats[FIMC_ISP_NUM_FORMATS] = {
 		.depth		= { 8 },
 		.color		= FIMC_FMT_RAW8,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_SGRBG8_1X8,
+		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
 	}, {
 		.name		= "RAW10 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG10,
 		.depth		= { 10 },
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
+		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
 	}, {
 		.name		= "RAW12 (GRBG)",
 		.fourcc		= V4L2_PIX_FMT_SGRBG12,
 		.depth		= { 12 },
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
+		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
 	},
 };
 
@@ -149,7 +149,7 @@ static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
 
 		if (fmt->pad == FIMC_ISP_SD_PAD_SRC_FIFO) {
 			mf->colorspace = V4L2_COLORSPACE_JPEG;
-			mf->code = V4L2_MBUS_FMT_YUV10_1X30;
+			mf->code = MEDIA_BUS_FMT_YUV10_1X30;
 		}
 	}
 
@@ -175,7 +175,7 @@ static void __isp_subdev_try_format(struct fimc_isp *isp,
 				FIMC_ISP_SINK_WIDTH_MAX, 0,
 				&mf->height, FIMC_ISP_SINK_HEIGHT_MIN,
 				FIMC_ISP_SINK_HEIGHT_MAX, 0, 0);
-		mf->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		mf->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	} else {
 		if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 			format = v4l2_subdev_get_try_format(fh,
@@ -188,7 +188,7 @@ static void __isp_subdev_try_format(struct fimc_isp *isp,
 		mf->height = format->height - FIMC_ISP_CAC_MARGIN_HEIGHT;
 
 		if (fmt->pad == FIMC_ISP_SD_PAD_SRC_FIFO) {
-			mf->code = V4L2_MBUS_FMT_YUV10_1X30;
+			mf->code = MEDIA_BUS_FMT_YUV10_1X30;
 			mf->colorspace = V4L2_COLORSPACE_JPEG;
 		} else {
 			mf->code = format->code;
@@ -680,11 +680,11 @@ static void __isp_subdev_set_default_format(struct fimc_isp *isp)
 				FIMC_ISP_CAC_MARGIN_WIDTH;
 	isp->sink_fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT +
 				FIMC_ISP_CAC_MARGIN_HEIGHT;
-	isp->sink_fmt.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	isp->sink_fmt.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
 	isp->src_fmt.width = DEFAULT_PREVIEW_STILL_WIDTH;
 	isp->src_fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT;
-	isp->src_fmt.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	isp->src_fmt.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	__is_set_frame_size(is, &isp->src_fmt);
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index bc3ec7d..0477716 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -112,24 +112,24 @@ void flite_hw_set_test_pattern(struct fimc_lite *dev, bool on)
 }
 
 static const u32 src_pixfmt_map[8][3] = {
-	{ V4L2_MBUS_FMT_YUYV8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_YCBYCR,
+	{ MEDIA_BUS_FMT_YUYV8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_YCBYCR,
 	  FLITE_REG_CIGCTRL_YUV422_1P },
-	{ V4L2_MBUS_FMT_YVYU8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_YCRYCB,
+	{ MEDIA_BUS_FMT_YVYU8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_YCRYCB,
 	  FLITE_REG_CIGCTRL_YUV422_1P },
-	{ V4L2_MBUS_FMT_UYVY8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_CBYCRY,
+	{ MEDIA_BUS_FMT_UYVY8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_CBYCRY,
 	  FLITE_REG_CIGCTRL_YUV422_1P },
-	{ V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_CRYCBY,
+	{ MEDIA_BUS_FMT_VYUY8_2X8, FLITE_REG_CISRCSIZE_ORDER422_IN_CRYCBY,
 	  FLITE_REG_CIGCTRL_YUV422_1P },
-	{ V4L2_MBUS_FMT_SGRBG8_1X8, 0, FLITE_REG_CIGCTRL_RAW8 },
-	{ V4L2_MBUS_FMT_SGRBG10_1X10, 0, FLITE_REG_CIGCTRL_RAW10 },
-	{ V4L2_MBUS_FMT_SGRBG12_1X12, 0, FLITE_REG_CIGCTRL_RAW12 },
-	{ V4L2_MBUS_FMT_JPEG_1X8, 0, FLITE_REG_CIGCTRL_USER(1) },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, 0, FLITE_REG_CIGCTRL_RAW8 },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, 0, FLITE_REG_CIGCTRL_RAW10 },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, 0, FLITE_REG_CIGCTRL_RAW12 },
+	{ MEDIA_BUS_FMT_JPEG_1X8, 0, FLITE_REG_CIGCTRL_USER(1) },
 };
 
 /* Set camera input pixel format and resolution */
 void flite_hw_set_source_format(struct fimc_lite *dev, struct flite_frame *f)
 {
-	enum v4l2_mbus_pixelcode pixelcode = f->fmt->mbus_code;
+	u32 pixelcode = f->fmt->mbus_code;
 	int i = ARRAY_SIZE(src_pixfmt_map);
 	u32 cfg;
 
@@ -232,10 +232,10 @@ static void flite_hw_set_pack12(struct fimc_lite *dev, int on)
 static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
 {
 	static const u32 pixcode[4][2] = {
-		{ V4L2_MBUS_FMT_YUYV8_2X8, FLITE_REG_CIODMAFMT_YCBYCR },
-		{ V4L2_MBUS_FMT_YVYU8_2X8, FLITE_REG_CIODMAFMT_YCRYCB },
-		{ V4L2_MBUS_FMT_UYVY8_2X8, FLITE_REG_CIODMAFMT_CBYCRY },
-		{ V4L2_MBUS_FMT_VYUY8_2X8, FLITE_REG_CIODMAFMT_CRYCBY },
+		{ MEDIA_BUS_FMT_YUYV8_2X8, FLITE_REG_CIODMAFMT_YCBYCR },
+		{ MEDIA_BUS_FMT_YVYU8_2X8, FLITE_REG_CIODMAFMT_YCRYCB },
+		{ MEDIA_BUS_FMT_UYVY8_2X8, FLITE_REG_CIODMAFMT_CBYCRY },
+		{ MEDIA_BUS_FMT_VYUY8_2X8, FLITE_REG_CIODMAFMT_CRYCBY },
 	};
 	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
 	int i = ARRAY_SIZE(pixcode);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index a97d235..b7dca8b 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -48,7 +48,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.depth		= { 16 },
 		.color		= FIMC_FMT_YCBYCR422,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "YUV 4:2:2 packed, CbYCrY",
@@ -57,7 +57,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.depth		= { 16 },
 		.color		= FIMC_FMT_CBYCRY422,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_UYVY8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_UYVY8_2X8,
 		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "YUV 4:2:2 packed, CrYCbY",
@@ -66,7 +66,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.depth		= { 16 },
 		.color		= FIMC_FMT_CRYCBY422,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_VYUY8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_VYUY8_2X8,
 		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "YUV 4:2:2 packed, YCrYCb",
@@ -75,7 +75,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.depth		= { 16 },
 		.color		= FIMC_FMT_YCRYCB422,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_YVYU8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YVYU8_2X8,
 		.flags		= FMT_FLAGS_YUV,
 	}, {
 		.name		= "RAW8 (GRBG)",
@@ -84,7 +84,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.depth		= { 8 },
 		.color		= FIMC_FMT_RAW8,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_SGRBG8_1X8,
+		.mbus_code	= MEDIA_BUS_FMT_SGRBG8_1X8,
 		.flags		= FMT_FLAGS_RAW_BAYER,
 	}, {
 		.name		= "RAW10 (GRBG)",
@@ -93,7 +93,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW10,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_SGRBG10_1X10,
+		.mbus_code	= MEDIA_BUS_FMT_SGRBG10_1X10,
 		.flags		= FMT_FLAGS_RAW_BAYER,
 	}, {
 		.name		= "RAW12 (GRBG)",
@@ -102,7 +102,7 @@ static const struct fimc_fmt fimc_lite_formats[] = {
 		.depth		= { 16 },
 		.color		= FIMC_FMT_RAW12,
 		.memplanes	= 1,
-		.mbus_code	= V4L2_MBUS_FMT_SGRBG12_1X12,
+		.mbus_code	= MEDIA_BUS_FMT_SGRBG12_1X12,
 		.flags		= FMT_FLAGS_RAW_BAYER,
 	},
 };
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index 2d77fd8..df0cbcb 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -592,10 +592,10 @@ struct mbus_pixfmt_desc {
 };
 
 static const struct mbus_pixfmt_desc pix_desc[] = {
-	{ V4L2_MBUS_FMT_YUYV8_2X8, FIMC_REG_CISRCFMT_ORDER422_YCBYCR, 8 },
-	{ V4L2_MBUS_FMT_YVYU8_2X8, FIMC_REG_CISRCFMT_ORDER422_YCRYCB, 8 },
-	{ V4L2_MBUS_FMT_VYUY8_2X8, FIMC_REG_CISRCFMT_ORDER422_CRYCBY, 8 },
-	{ V4L2_MBUS_FMT_UYVY8_2X8, FIMC_REG_CISRCFMT_ORDER422_CBYCRY, 8 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, FIMC_REG_CISRCFMT_ORDER422_YCBYCR, 8 },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, FIMC_REG_CISRCFMT_ORDER422_YCRYCB, 8 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, FIMC_REG_CISRCFMT_ORDER422_CRYCBY, 8 },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, FIMC_REG_CISRCFMT_ORDER422_CBYCRY, 8 },
 };
 
 int fimc_hw_set_camera_source(struct fimc_dev *fimc,
@@ -689,11 +689,11 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 
 		/* TODO: add remaining supported formats. */
 		switch (vid_cap->ci_fmt.code) {
-		case V4L2_MBUS_FMT_VYUY8_2X8:
+		case MEDIA_BUS_FMT_VYUY8_2X8:
 			tmp = FIMC_REG_CSIIMGFMT_YCBCR422_8BIT;
 			break;
-		case V4L2_MBUS_FMT_JPEG_1X8:
-		case V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8:
+		case MEDIA_BUS_FMT_JPEG_1X8:
+		case MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8:
 			tmp = FIMC_REG_CSIIMGFMT_USER(1);
 			cfg |= FIMC_REG_CIGCTRL_CAM_JPEG;
 			break;
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index db6fd14..2f3fdfb 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -238,34 +238,34 @@ struct csis_state {
  */
 struct csis_pix_format {
 	unsigned int pix_width_alignment;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	u32 fmt_reg;
 	u8 data_alignment;
 };
 
 static const struct csis_pix_format s5pcsis_formats[] = {
 	{
-		.code = V4L2_MBUS_FMT_VYUY8_2X8,
+		.code = MEDIA_BUS_FMT_VYUY8_2X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_YCBCR422_8BIT,
 		.data_alignment = 32,
 	}, {
-		.code = V4L2_MBUS_FMT_JPEG_1X8,
+		.code = MEDIA_BUS_FMT_JPEG_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
 		.data_alignment = 32,
 	}, {
-		.code = V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8,
+		.code = MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
 		.data_alignment = 32,
 	}, {
-		.code = V4L2_MBUS_FMT_SGRBG8_1X8,
+		.code = MEDIA_BUS_FMT_SGRBG8_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_RAW8,
 		.data_alignment = 24,
 	}, {
-		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
 		.fmt_reg = S5PCSIS_CFG_FMT_RAW10,
 		.data_alignment = 24,
 	}, {
-		.code = V4L2_MBUS_FMT_SGRBG12_1X12,
+		.code = MEDIA_BUS_FMT_SGRBG12_1X12,
 		.fmt_reg = S5PCSIS_CFG_FMT_RAW12,
 		.data_alignment = 24,
 	}
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 7a86c77..f0eeb6c 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -106,61 +106,61 @@ static struct mcam_format_struct {
 	__u32 pixelformat;
 	int bpp;   /* Bytes per pixel */
 	bool planar;
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 } mcam_formats[] = {
 	{
 		.desc		= "YUYV 4:2:2",
 		.pixelformat	= V4L2_PIX_FMT_YUYV,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 		.planar		= false,
 	},
 	{
 		.desc		= "UYVY 4:2:2",
 		.pixelformat	= V4L2_PIX_FMT_UYVY,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 		.planar		= false,
 	},
 	{
 		.desc		= "YUV 4:2:2 PLANAR",
 		.pixelformat	= V4L2_PIX_FMT_YUV422P,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 		.planar		= true,
 	},
 	{
 		.desc		= "YUV 4:2:0 PLANAR",
 		.pixelformat	= V4L2_PIX_FMT_YUV420,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 		.planar		= true,
 	},
 	{
 		.desc		= "YVU 4:2:0 PLANAR",
 		.pixelformat	= V4L2_PIX_FMT_YVU420,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 		.planar		= true,
 	},
 	{
 		.desc		= "RGB 444",
 		.pixelformat	= V4L2_PIX_FMT_RGB444,
-		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
+		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
 		.bpp		= 2,
 		.planar		= false,
 	},
 	{
 		.desc		= "RGB 565",
 		.pixelformat	= V4L2_PIX_FMT_RGB565,
-		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.mbus_code	= MEDIA_BUS_FMT_RGB565_2X8_LE,
 		.bpp		= 2,
 		.planar		= false,
 	},
 	{
 		.desc		= "Raw RGB Bayer",
 		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
-		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
+		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
 		.bpp		= 1,
 		.planar		= false,
 	},
@@ -190,8 +190,7 @@ static const struct v4l2_pix_format mcam_def_pix_format = {
 	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
 };
 
-static const enum v4l2_mbus_pixelcode mcam_def_mbus_code =
-					V4L2_MBUS_FMT_YUYV8_2X8;
+static const u32 mcam_def_mbus_code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 
 /*
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index e0e628c..60a8e1c 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -183,7 +183,7 @@ struct mcam_camera {
 
 	/* Current operating parameters */
 	struct v4l2_pix_format pix_format;
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 
 	/* Locks */
 	struct mutex s_mutex; /* Access to this structure */
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 81a9dc0..587489a 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -36,23 +36,23 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		  unsigned int pad, enum v4l2_subdev_format_whence which);
 
 static const unsigned int ccdc_fmts[] = {
-	V4L2_MBUS_FMT_Y8_1X8,
-	V4L2_MBUS_FMT_Y10_1X10,
-	V4L2_MBUS_FMT_Y12_1X12,
-	V4L2_MBUS_FMT_SGRBG8_1X8,
-	V4L2_MBUS_FMT_SRGGB8_1X8,
-	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_SGBRG8_1X8,
-	V4L2_MBUS_FMT_SGRBG10_1X10,
-	V4L2_MBUS_FMT_SRGGB10_1X10,
-	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_SGBRG10_1X10,
-	V4L2_MBUS_FMT_SGRBG12_1X12,
-	V4L2_MBUS_FMT_SRGGB12_1X12,
-	V4L2_MBUS_FMT_SBGGR12_1X12,
-	V4L2_MBUS_FMT_SGBRG12_1X12,
-	V4L2_MBUS_FMT_YUYV8_2X8,
-	V4L2_MBUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_Y8_1X8,
+	MEDIA_BUS_FMT_Y10_1X10,
+	MEDIA_BUS_FMT_Y12_1X12,
+	MEDIA_BUS_FMT_SGRBG8_1X8,
+	MEDIA_BUS_FMT_SRGGB8_1X8,
+	MEDIA_BUS_FMT_SBGGR8_1X8,
+	MEDIA_BUS_FMT_SGBRG8_1X8,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SBGGR10_1X10,
+	MEDIA_BUS_FMT_SGBRG10_1X10,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_SRGGB12_1X12,
+	MEDIA_BUS_FMT_SBGGR12_1X12,
+	MEDIA_BUS_FMT_SGBRG12_1X12,
+	MEDIA_BUS_FMT_YUYV8_2X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
 };
 
 /*
@@ -266,10 +266,10 @@ static int __ccdc_lsc_enable(struct isp_ccdc_device *ccdc, int enable)
 		__ccdc_get_format(ccdc, NULL, CCDC_PAD_SINK,
 				  V4L2_SUBDEV_FORMAT_ACTIVE);
 
-	if ((format->code != V4L2_MBUS_FMT_SGRBG10_1X10) &&
-	    (format->code != V4L2_MBUS_FMT_SRGGB10_1X10) &&
-	    (format->code != V4L2_MBUS_FMT_SBGGR10_1X10) &&
-	    (format->code != V4L2_MBUS_FMT_SGBRG10_1X10))
+	if ((format->code != MEDIA_BUS_FMT_SGRBG10_1X10) &&
+	    (format->code != MEDIA_BUS_FMT_SRGGB10_1X10) &&
+	    (format->code != MEDIA_BUS_FMT_SBGGR10_1X10) &&
+	    (format->code != MEDIA_BUS_FMT_SGBRG10_1X10))
 		return -EINVAL;
 
 	if (enable)
@@ -971,8 +971,8 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 
 	format = &ccdc->formats[CCDC_PAD_SINK];
 
-	if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
-	    format->code == V4L2_MBUS_FMT_UYVY8_2X8) {
+	if (format->code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+	    format->code == MEDIA_BUS_FMT_UYVY8_2X8) {
 		/* According to the OMAP3 TRM the input mode only affects SYNC
 		 * mode, enabling BT.656 mode should take precedence. However,
 		 * in practice setting the input mode to YCbCr data on 8 bits
@@ -1020,7 +1020,7 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
 	/* The CCDC_CFG.Y8POS bit is used in YCbCr8 input mode only. The
 	 * hardware seems to ignore it in all other input modes.
 	 */
-	if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
+	if (format->code == MEDIA_BUS_FMT_UYVY8_2X8)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
 			    ISPCCDC_CFG_Y8POS);
 	else
@@ -1168,9 +1168,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	if (ccdc->bt656)
 		bridge = ISPCTRL_PAR_BRIDGE_DISABLE;
-	else if (fmt_info->code == V4L2_MBUS_FMT_YUYV8_2X8)
+	else if (fmt_info->code == MEDIA_BUS_FMT_YUYV8_2X8)
 		bridge = ISPCTRL_PAR_BRIDGE_LENDIAN;
-	else if (fmt_info->code == V4L2_MBUS_FMT_UYVY8_2X8)
+	else if (fmt_info->code == MEDIA_BUS_FMT_UYVY8_2X8)
 		bridge = ISPCTRL_PAR_BRIDGE_BENDIAN;
 	else
 		bridge = ISPCTRL_PAR_BRIDGE_DISABLE;
@@ -1199,16 +1199,16 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 
 	/* Mosaic filter */
 	switch (format->code) {
-	case V4L2_MBUS_FMT_SRGGB10_1X10:
-	case V4L2_MBUS_FMT_SRGGB12_1X12:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SRGGB12_1X12:
 		ccdc_pattern = ccdc_srggb_pattern;
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
-	case V4L2_MBUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
 		ccdc_pattern = ccdc_sbggr_pattern;
 		break;
-	case V4L2_MBUS_FMT_SGBRG10_1X10:
-	case V4L2_MBUS_FMT_SGBRG12_1X12:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGBRG12_1X12:
 		ccdc_pattern = ccdc_sgbrg_pattern;
 		break;
 	default:
@@ -1267,7 +1267,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	/* The CCDC outputs data in UYVY order by default. Swap bytes to get
 	 * YUYV.
 	 */
-	if (format->code == V4L2_MBUS_FMT_YUYV8_1X16)
+	if (format->code == MEDIA_BUS_FMT_YUYV8_1X16)
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
 			    ISPCCDC_CFG_BSWD);
 	else
@@ -1967,7 +1967,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		enum v4l2_subdev_format_whence which)
 {
 	const struct isp_format_info *info;
-	enum v4l2_mbus_pixelcode pixelcode;
+	u32 pixelcode;
 	unsigned int width = fmt->width;
 	unsigned int height = fmt->height;
 	struct v4l2_rect *crop;
@@ -1983,7 +1983,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(ccdc_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
 		/* Clamp the input size. */
 		fmt->width = clamp_t(u32, width, 32, 4096);
@@ -2007,19 +2007,19 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		 * configured to pack bytes in BT.656, hiding the inaccuracy.
 		 * In all cases bytes can be swapped.
 		 */
-		if (fmt->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
-		    fmt->code == V4L2_MBUS_FMT_UYVY8_2X8) {
+		if (fmt->code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+		    fmt->code == MEDIA_BUS_FMT_UYVY8_2X8) {
 			/* Use the user requested format if YUV. */
-			if (pixelcode == V4L2_MBUS_FMT_YUYV8_2X8 ||
-			    pixelcode == V4L2_MBUS_FMT_UYVY8_2X8 ||
-			    pixelcode == V4L2_MBUS_FMT_YUYV8_1X16 ||
-			    pixelcode == V4L2_MBUS_FMT_UYVY8_1X16)
+			if (pixelcode == MEDIA_BUS_FMT_YUYV8_2X8 ||
+			    pixelcode == MEDIA_BUS_FMT_UYVY8_2X8 ||
+			    pixelcode == MEDIA_BUS_FMT_YUYV8_1X16 ||
+			    pixelcode == MEDIA_BUS_FMT_UYVY8_1X16)
 				fmt->code = pixelcode;
 
-			if (fmt->code == V4L2_MBUS_FMT_YUYV8_2X8)
-				fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
-			else if (fmt->code == V4L2_MBUS_FMT_UYVY8_2X8)
-				fmt->code = V4L2_MBUS_FMT_UYVY8_1X16;
+			if (fmt->code == MEDIA_BUS_FMT_YUYV8_2X8)
+				fmt->code = MEDIA_BUS_FMT_YUYV8_1X16;
+			else if (fmt->code == MEDIA_BUS_FMT_UYVY8_2X8)
+				fmt->code = MEDIA_BUS_FMT_UYVY8_1X16;
 		}
 
 		/* Hardcode the output size to the crop rectangle size. */
@@ -2047,8 +2047,8 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		fmt->code = info->truncated;
 
 		/* YUV formats are not supported by the video port. */
-		if (fmt->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
-		    fmt->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		if (fmt->code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+		    fmt->code == MEDIA_BUS_FMT_UYVY8_2X8)
 			fmt->code = 0;
 
 		/* The number of lines that can be clocked out from the video
@@ -2083,7 +2083,7 @@ static void ccdc_try_crop(struct isp_ccdc_device *ccdc,
 	 * to keep the Bayer pattern.
 	 */
 	info = omap3isp_video_format_info(sink->code);
-	if (info->flavor != V4L2_MBUS_FMT_Y8_1X8) {
+	if (info->flavor != MEDIA_BUS_FMT_Y8_1X8) {
 		crop->left &= ~1;
 		crop->top &= ~1;
 	}
@@ -2103,7 +2103,7 @@ static void ccdc_try_crop(struct isp_ccdc_device *ccdc,
 			       sink->height - crop->top);
 
 	/* Odd width/height values don't make sense for Bayer formats. */
-	if (info->flavor != V4L2_MBUS_FMT_Y8_1X8) {
+	if (info->flavor != MEDIA_BUS_FMT_Y8_1X8) {
 		crop->width &= ~1;
 		crop->height &= ~1;
 	}
@@ -2135,13 +2135,13 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
 		format = __ccdc_get_format(ccdc, fh, code->pad,
 					   V4L2_SUBDEV_FORMAT_TRY);
 
-		if (format->code == V4L2_MBUS_FMT_YUYV8_2X8 ||
-		    format->code == V4L2_MBUS_FMT_UYVY8_2X8) {
+		if (format->code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+		    format->code == MEDIA_BUS_FMT_UYVY8_2X8) {
 			/* In YUV mode the CCDC can swap bytes. */
 			if (code->index == 0)
-				code->code = V4L2_MBUS_FMT_YUYV8_1X16;
+				code->code = MEDIA_BUS_FMT_YUYV8_1X16;
 			else if (code->index == 1)
-				code->code = V4L2_MBUS_FMT_UYVY8_1X16;
+				code->code = MEDIA_BUS_FMT_UYVY8_1X16;
 			else
 				return -EINVAL;
 		} else {
@@ -2383,9 +2383,7 @@ static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
  * return true if the combination is possible
  * return false otherwise
  */
-static bool ccdc_is_shiftable(enum v4l2_mbus_pixelcode in,
-			      enum v4l2_mbus_pixelcode out,
-			      unsigned int additional_shift)
+static bool ccdc_is_shiftable(u32 in, u32 out, unsigned int additional_shift)
 {
 	const struct isp_format_info *in_info, *out_info;
 
@@ -2452,7 +2450,7 @@ static int ccdc_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = CCDC_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	ccdc_set_format(sd, fh, &format);
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 9cb49b3..f4aedb3 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -289,10 +289,10 @@ static void ccp2_lcx_config(struct isp_ccp2_device *ccp2,
 	u32 val, format;
 
 	switch (config->format) {
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
 		format = ISPCCP2_LCx_CTRL_FORMAT_RAW8_DPCM10_VP;
 		break;
-	case V4L2_MBUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
 	default:
 		format = ISPCCP2_LCx_CTRL_FORMAT_RAW10_VP;	/* RAW10+VP */
 		break;
@@ -438,7 +438,7 @@ static void ccp2_mem_configure(struct isp_ccp2_device *ccp2,
 	u32 val, hwords;
 
 	if (sink_pixcode != source_pixcode &&
-	    sink_pixcode == V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
+	    sink_pixcode == MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8)
 		dpcm_decompress = 1;
 
 	ccp2_pwr_cfg(ccp2);
@@ -604,8 +604,8 @@ void omap3isp_ccp2_isr(struct isp_ccp2_device *ccp2)
  */
 
 static const unsigned int ccp2_fmts[] = {
-	V4L2_MBUS_FMT_SGRBG10_1X10,
-	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 };
 
 /*
@@ -643,8 +643,8 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 
 	switch (pad) {
 	case CCP2_PAD_SINK:
-		if (fmt->code != V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		if (fmt->code != MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8)
+			fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
 		if (ccp2->input == CCP2_INPUT_SENSOR) {
 			fmt->width = clamp_t(u32, fmt->width,
@@ -671,7 +671,7 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 		 */
 		format = __ccp2_get_format(ccp2, fh, CCP2_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
-		fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 		break;
 	}
 
@@ -808,7 +808,7 @@ static int ccp2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = CCP2_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	ccp2_set_format(sd, fh, &format);
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 6530b25..09c686d 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -78,15 +78,15 @@ static void csi2_recv_config(struct isp_device *isp,
 }
 
 static const unsigned int csi2_input_fmts[] = {
-	V4L2_MBUS_FMT_SGRBG10_1X10,
-	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
-	V4L2_MBUS_FMT_SRGGB10_1X10,
-	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8,
-	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
-	V4L2_MBUS_FMT_SGBRG10_1X10,
-	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
-	V4L2_MBUS_FMT_YUYV8_2X8,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SBGGR10_1X10,
+	MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SGBRG10_1X10,
+	MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_YUYV8_2X8,
 };
 
 /* To set the format on the CSI2 requires a mapping function that takes
@@ -171,19 +171,19 @@ static u16 csi2_ctx_map_format(struct isp_csi2_device *csi2)
 	int fmtidx, destidx, is_3630;
 
 	switch (fmt->code) {
-	case V4L2_MBUS_FMT_SGRBG10_1X10:
-	case V4L2_MBUS_FMT_SRGGB10_1X10:
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
-	case V4L2_MBUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
 		fmtidx = 0;
 		break;
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8:
 		fmtidx = 1;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		fmtidx = 2;
 		break;
 	default:
@@ -843,7 +843,7 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
-	enum v4l2_mbus_pixelcode pixelcode;
+	u32 pixelcode;
 	struct v4l2_mbus_framefmt *format;
 	const struct isp_format_info *info;
 	unsigned int i;
@@ -858,7 +858,7 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(csi2_input_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
 		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
 		fmt->height = clamp_t(u32, fmt->height, 1, 8191);
@@ -1029,7 +1029,7 @@ static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = CSI2_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	csi2_set_format(sd, fh, &format);
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 605f57e..dd9eed4 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -964,18 +964,16 @@ static void preview_setup_hw(struct isp_prev_device *prev, u32 update,
  * @prev: pointer to previewer private structure
  * @pixelcode: pixel code
  */
-static void
-preview_config_ycpos(struct isp_prev_device *prev,
-		     enum v4l2_mbus_pixelcode pixelcode)
+static void preview_config_ycpos(struct isp_prev_device *prev, u32 pixelcode)
 {
 	struct isp_device *isp = to_isp_device(prev);
 	enum preview_ycpos_mode mode;
 
 	switch (pixelcode) {
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		mode = YCPOS_CrYCbY;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 		mode = YCPOS_YCrYCb;
 		break;
 	default:
@@ -1028,16 +1026,16 @@ static void preview_config_input_format(struct isp_prev_device *prev,
 			    ISPPRV_PCR_WIDTH);
 
 	switch (info->flavor) {
-	case V4L2_MBUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
 		prev->params.cfa_order = 0;
 		break;
-	case V4L2_MBUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
 		prev->params.cfa_order = 1;
 		break;
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
 		prev->params.cfa_order = 2;
 		break;
-	case V4L2_MBUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
 		prev->params.cfa_order = 3;
 		break;
 	default:
@@ -1078,8 +1076,8 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
-	if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
-	    format->code != V4L2_MBUS_FMT_Y10_1X10) {
+	if (format->code != MEDIA_BUS_FMT_Y8_1X8 &&
+	    format->code != MEDIA_BUS_FMT_Y10_1X10) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;
@@ -1709,21 +1707,21 @@ __preview_get_crop(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
 
 /* previewer format descriptions */
 static const unsigned int preview_input_fmts[] = {
-	V4L2_MBUS_FMT_Y8_1X8,
-	V4L2_MBUS_FMT_SGRBG8_1X8,
-	V4L2_MBUS_FMT_SRGGB8_1X8,
-	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_SGBRG8_1X8,
-	V4L2_MBUS_FMT_Y10_1X10,
-	V4L2_MBUS_FMT_SGRBG10_1X10,
-	V4L2_MBUS_FMT_SRGGB10_1X10,
-	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_SGBRG10_1X10,
+	MEDIA_BUS_FMT_Y8_1X8,
+	MEDIA_BUS_FMT_SGRBG8_1X8,
+	MEDIA_BUS_FMT_SRGGB8_1X8,
+	MEDIA_BUS_FMT_SBGGR8_1X8,
+	MEDIA_BUS_FMT_SGBRG8_1X8,
+	MEDIA_BUS_FMT_Y10_1X10,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SBGGR10_1X10,
+	MEDIA_BUS_FMT_SGBRG10_1X10,
 };
 
 static const unsigned int preview_output_fmts[] = {
-	V4L2_MBUS_FMT_UYVY8_1X16,
-	V4L2_MBUS_FMT_YUYV8_1X16,
+	MEDIA_BUS_FMT_UYVY8_1X16,
+	MEDIA_BUS_FMT_YUYV8_1X16,
 };
 
 /*
@@ -1742,7 +1740,7 @@ static void preview_try_format(struct isp_prev_device *prev,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
-	enum v4l2_mbus_pixelcode pixelcode;
+	u32 pixelcode;
 	struct v4l2_rect *crop;
 	unsigned int i;
 
@@ -1774,7 +1772,7 @@ static void preview_try_format(struct isp_prev_device *prev,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(preview_input_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 		break;
 
 	case PREV_PAD_SOURCE:
@@ -1782,13 +1780,13 @@ static void preview_try_format(struct isp_prev_device *prev,
 		*fmt = *__preview_get_format(prev, fh, PREV_PAD_SINK, which);
 
 		switch (pixelcode) {
-		case V4L2_MBUS_FMT_YUYV8_1X16:
-		case V4L2_MBUS_FMT_UYVY8_1X16:
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_UYVY8_1X16:
 			fmt->code = pixelcode;
 			break;
 
 		default:
-			fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
+			fmt->code = MEDIA_BUS_FMT_YUYV8_1X16;
 			break;
 		}
 
@@ -1843,8 +1841,8 @@ static void preview_try_crop(struct isp_prev_device *prev,
 	 * and no columns in other modes. Increase the margins based on the sink
 	 * format.
 	 */
-	if (sink->code != V4L2_MBUS_FMT_Y8_1X8 &&
-	    sink->code != V4L2_MBUS_FMT_Y10_1X10) {
+	if (sink->code != MEDIA_BUS_FMT_Y8_1X8 &&
+	    sink->code != MEDIA_BUS_FMT_Y10_1X10) {
 		left += 2;
 		right -= 2;
 		top += 2;
@@ -2092,7 +2090,7 @@ static int preview_init_formats(struct v4l2_subdev *sd,
 	memset(&format, 0, sizeof(format));
 	format.pad = PREV_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	preview_set_format(sd, fh, &format);
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 05d1ace..2b9bc48 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -198,17 +198,16 @@ static void resizer_set_bilinear(struct isp_res_device *res,
  * @res: Device context.
  * @pixelcode: pixel code.
  */
-static void resizer_set_ycpos(struct isp_res_device *res,
-			      enum v4l2_mbus_pixelcode pixelcode)
+static void resizer_set_ycpos(struct isp_res_device *res, u32 pixelcode)
 {
 	struct isp_device *isp = to_isp_device(res);
 
 	switch (pixelcode) {
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		isp_reg_set(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
 			    ISPRSZ_CNT_YCPOS);
 		break;
-	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 		isp_reg_clr(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
 			    ISPRSZ_CNT_YCPOS);
 		break;
@@ -1348,8 +1347,8 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 
 /* resizer pixel formats */
 static const unsigned int resizer_formats[] = {
-	V4L2_MBUS_FMT_UYVY8_1X16,
-	V4L2_MBUS_FMT_YUYV8_1X16,
+	MEDIA_BUS_FMT_UYVY8_1X16,
+	MEDIA_BUS_FMT_YUYV8_1X16,
 };
 
 static unsigned int resizer_max_in_width(struct isp_res_device *res)
@@ -1385,9 +1384,9 @@ static void resizer_try_format(struct isp_res_device *res,
 
 	switch (pad) {
 	case RESZ_PAD_SINK:
-		if (fmt->code != V4L2_MBUS_FMT_YUYV8_1X16 &&
-		    fmt->code != V4L2_MBUS_FMT_UYVY8_1X16)
-			fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
+		if (fmt->code != MEDIA_BUS_FMT_YUYV8_1X16 &&
+		    fmt->code != MEDIA_BUS_FMT_UYVY8_1X16)
+			fmt->code = MEDIA_BUS_FMT_YUYV8_1X16;
 
 		fmt->width = clamp_t(u32, fmt->width, MIN_IN_WIDTH,
 				     resizer_max_in_width(res));
@@ -1571,7 +1570,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 	memset(&format, 0, sizeof(format));
 	format.pad = RESZ_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_YUYV8_1X16;
+	format.format.code = MEDIA_BUS_FMT_YUYV8_1X16;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	resizer_set_format(sd, fh, &format);
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index bc38c88..b463fe1 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -39,74 +39,74 @@
  * corresponding in-memory formats to the table below!!!
  */
 static struct isp_format_info formats[] = {
-	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
+	{ MEDIA_BUS_FMT_Y8_1X8, MEDIA_BUS_FMT_Y8_1X8,
+	  MEDIA_BUS_FMT_Y8_1X8, MEDIA_BUS_FMT_Y8_1X8,
 	  V4L2_PIX_FMT_GREY, 8, 1, },
-	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
-	  V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y8_1X8,
+	{ MEDIA_BUS_FMT_Y10_1X10, MEDIA_BUS_FMT_Y10_1X10,
+	  MEDIA_BUS_FMT_Y10_1X10, MEDIA_BUS_FMT_Y8_1X8,
 	  V4L2_PIX_FMT_Y10, 10, 2, },
-	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
-	  V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y8_1X8,
+	{ MEDIA_BUS_FMT_Y12_1X12, MEDIA_BUS_FMT_Y10_1X10,
+	  MEDIA_BUS_FMT_Y12_1X12, MEDIA_BUS_FMT_Y8_1X8,
 	  V4L2_PIX_FMT_Y12, 12, 2, },
-	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SBGGR8_1X8,
+	  MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SBGGR8_1X8,
 	  V4L2_PIX_FMT_SBGGR8, 8, 1, },
-	{ V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
+	  MEDIA_BUS_FMT_SGBRG8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
 	  V4L2_PIX_FMT_SGBRG8, 8, 1, },
-	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SGRBG8_1X8,
+	  MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SGRBG8_1X8,
 	  V4L2_PIX_FMT_SGRBG8, 8, 1, },
-	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
+	  MEDIA_BUS_FMT_SRGGB8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
 	  V4L2_PIX_FMT_SRGGB8, 8, 1, },
-	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8,
-	  V4L2_MBUS_FMT_SBGGR10_1X10, 0,
+	{ MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
+	  MEDIA_BUS_FMT_SBGGR10_1X10, 0,
 	  V4L2_PIX_FMT_SBGGR10DPCM8, 8, 1, },
-	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8,
-	  V4L2_MBUS_FMT_SGBRG10_1X10, 0,
+	{ MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
+	  MEDIA_BUS_FMT_SGBRG10_1X10, 0,
 	  V4L2_PIX_FMT_SGBRG10DPCM8, 8, 1, },
-	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
-	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
+	{ MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+	  MEDIA_BUS_FMT_SGRBG10_1X10, 0,
 	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, 1, },
-	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8,
-	  V4L2_MBUS_FMT_SRGGB10_1X10, 0,
+	{ MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
+	  MEDIA_BUS_FMT_SRGGB10_1X10, 0,
 	  V4L2_PIX_FMT_SRGGB10DPCM8, 8, 1, },
-	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
-	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10,
+	  MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SBGGR8_1X8,
 	  V4L2_PIX_FMT_SBGGR10, 10, 2, },
-	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
-	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG8_1X8,
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10,
+	  MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SGBRG8_1X8,
 	  V4L2_PIX_FMT_SGBRG10, 10, 2, },
-	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
-	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG8_1X8,
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10,
+	  MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SGRBG8_1X8,
 	  V4L2_PIX_FMT_SGRBG10, 10, 2, },
-	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
-	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB8_1X8,
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10,
+	  MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SRGGB8_1X8,
 	  V4L2_PIX_FMT_SRGGB10, 10, 2, },
-	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
-	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR8_1X8,
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, MEDIA_BUS_FMT_SBGGR10_1X10,
+	  MEDIA_BUS_FMT_SBGGR12_1X12, MEDIA_BUS_FMT_SBGGR8_1X8,
 	  V4L2_PIX_FMT_SBGGR12, 12, 2, },
-	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
-	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG8_1X8,
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, MEDIA_BUS_FMT_SGBRG10_1X10,
+	  MEDIA_BUS_FMT_SGBRG12_1X12, MEDIA_BUS_FMT_SGBRG8_1X8,
 	  V4L2_PIX_FMT_SGBRG12, 12, 2, },
-	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
-	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG8_1X8,
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, MEDIA_BUS_FMT_SGRBG10_1X10,
+	  MEDIA_BUS_FMT_SGRBG12_1X12, MEDIA_BUS_FMT_SGRBG8_1X8,
 	  V4L2_PIX_FMT_SGRBG12, 12, 2, },
-	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
-	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, MEDIA_BUS_FMT_SRGGB10_1X10,
+	  MEDIA_BUS_FMT_SRGGB12_1X12, MEDIA_BUS_FMT_SRGGB8_1X8,
 	  V4L2_PIX_FMT_SRGGB12, 12, 2, },
-	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
-	  V4L2_MBUS_FMT_UYVY8_1X16, 0,
+	{ MEDIA_BUS_FMT_UYVY8_1X16, MEDIA_BUS_FMT_UYVY8_1X16,
+	  MEDIA_BUS_FMT_UYVY8_1X16, 0,
 	  V4L2_PIX_FMT_UYVY, 16, 2, },
-	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
-	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
+	{ MEDIA_BUS_FMT_YUYV8_1X16, MEDIA_BUS_FMT_YUYV8_1X16,
+	  MEDIA_BUS_FMT_YUYV8_1X16, 0,
 	  V4L2_PIX_FMT_YUYV, 16, 2, },
-	{ V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
-	  V4L2_MBUS_FMT_UYVY8_2X8, 0,
+	{ MEDIA_BUS_FMT_UYVY8_2X8, MEDIA_BUS_FMT_UYVY8_2X8,
+	  MEDIA_BUS_FMT_UYVY8_2X8, 0,
 	  V4L2_PIX_FMT_UYVY, 8, 2, },
-	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_YUYV8_2X8,
-	  V4L2_MBUS_FMT_YUYV8_2X8, 0,
+	{ MEDIA_BUS_FMT_YUYV8_2X8, MEDIA_BUS_FMT_YUYV8_2X8,
+	  MEDIA_BUS_FMT_YUYV8_2X8, 0,
 	  V4L2_PIX_FMT_YUYV, 8, 2, },
 	/* Empty entry to catch the unsupported pixel code (0) used by the CCDC
 	 * module and avoid NULL pointer dereferences.
@@ -114,8 +114,7 @@ static struct isp_format_info formats[] = {
 	{ 0, }
 };
 
-const struct isp_format_info *
-omap3isp_video_format_info(enum v4l2_mbus_pixelcode code)
+const struct isp_format_info *omap3isp_video_format_info(u32 code)
 {
 	unsigned int i;
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 0b7efed..4071dd7 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -44,10 +44,10 @@ struct v4l2_pix_format;
  * @bpp: Bytes per pixel (when stored in memory)
  */
 struct isp_format_info {
-	enum v4l2_mbus_pixelcode code;
-	enum v4l2_mbus_pixelcode truncated;
-	enum v4l2_mbus_pixelcode uncompressed;
-	enum v4l2_mbus_pixelcode flavor;
+	u32 code;
+	u32 truncated;
+	u32 uncompressed;
+	u32 flavor;
 	u32 pixelformat;
 	unsigned int width;
 	unsigned int bpp;
@@ -206,6 +206,6 @@ void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
 
 const struct isp_format_info *
-omap3isp_video_format_info(enum v4l2_mbus_pixelcode code);
+omap3isp_video_format_info(u32 code);
 
 #endif /* OMAP3_ISP_VIDEO_H */
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 4f81b4c..aa40c82 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1218,11 +1218,11 @@ void s3c_camif_unregister_video_node(struct camif_dev *camif, int idx)
 }
 
 /* Media bus pixel formats supported at the camif input */
-static const enum v4l2_mbus_pixelcode camif_mbus_formats[] = {
-	V4L2_MBUS_FMT_YUYV8_2X8,
-	V4L2_MBUS_FMT_YVYU8_2X8,
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_VYUY8_2X8,
+static const u32 camif_mbus_formats[] = {
+	MEDIA_BUS_FMT_YUYV8_2X8,
+	MEDIA_BUS_FMT_YVYU8_2X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_VYUY8_2X8,
 };
 
 /*
diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
index 6e0c998..812fb3a 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -96,10 +96,10 @@ void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
 }
 
 static const u32 src_pixfmt_map[8][2] = {
-	{ V4L2_MBUS_FMT_YUYV8_2X8, CISRCFMT_ORDER422_YCBYCR },
-	{ V4L2_MBUS_FMT_YVYU8_2X8, CISRCFMT_ORDER422_YCRYCB },
-	{ V4L2_MBUS_FMT_UYVY8_2X8, CISRCFMT_ORDER422_CBYCRY },
-	{ V4L2_MBUS_FMT_VYUY8_2X8, CISRCFMT_ORDER422_CRYCBY },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, CISRCFMT_ORDER422_YCBYCR },
+	{ MEDIA_BUS_FMT_YVYU8_2X8, CISRCFMT_ORDER422_YCRYCB },
+	{ MEDIA_BUS_FMT_UYVY8_2X8, CISRCFMT_ORDER422_CBYCRY },
+	{ MEDIA_BUS_FMT_VYUY8_2X8, CISRCFMT_ORDER422_CRYCBY },
 };
 
 /* Set camera input pixel format and resolution */
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 37c8bd6..1d1ef211 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -660,7 +660,7 @@ static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
 	memset(fmt, 0, sizeof(*fmt));
 	fmt->width = t->hact.end - t->hact.beg;
 	fmt->height = t->vact[0].end - t->vact[0].beg;
-	fmt->code = V4L2_MBUS_FMT_FIXED; /* means RGB888 */
+	fmt->code = MEDIA_BUS_FMT_FIXED; /* means RGB888 */
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 	if (t->interlaced) {
 		fmt->field = V4L2_FIELD_INTERLACED;
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 72cf892..46f4d56 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -170,7 +170,7 @@ static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
 	/* all modes are 720 pixels wide */
 	fmt->width = 720;
 	fmt->height = sdev->fmt->height;
-	fmt->code = V4L2_MBUS_FMT_FIXED;
+	fmt->code = MEDIA_BUS_FMT_FIXED;
 	fmt->field = V4L2_FIELD_INTERLACED;
 	fmt->colorspace = V4L2_COLORSPACE_JPEG;
 	return 0;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index e5f1d4c..0476696 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -680,7 +680,7 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	struct sh_vou_geometry geo;
 	struct v4l2_mbus_framefmt mbfmt = {
 		/* Revisit: is this the correct code? */
-		.code = V4L2_MBUS_FMT_YUYV8_2X8,
+		.code = MEDIA_BUS_FMT_YUYV8_2X8,
 		.field = V4L2_FIELD_INTERLACED,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
@@ -733,7 +733,7 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	/* Sanity checks */
 	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
 	    (unsigned)mbfmt.height > img_height_max ||
-	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8)
+	    mbfmt.code != MEDIA_BUS_FMT_YUYV8_2X8)
 		return -EIO;
 
 	if (mbfmt.width != geo.output.width ||
@@ -943,7 +943,7 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	struct sh_vou_geometry geo;
 	struct v4l2_mbus_framefmt mbfmt = {
 		/* Revisit: is this the correct code? */
-		.code = V4L2_MBUS_FMT_YUYV8_2X8,
+		.code = MEDIA_BUS_FMT_YUYV8_2X8,
 		.field = V4L2_FIELD_INTERLACED,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
@@ -994,7 +994,7 @@ static int sh_vou_s_crop(struct file *file, void *fh, const struct v4l2_crop *a)
 	/* Sanity checks */
 	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
 	    (unsigned)mbfmt.height > img_height_max ||
-	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8)
+	    mbfmt.code != MEDIA_BUS_FMT_YUYV8_2X8)
 		return -EIO;
 
 	geo.output.width = mbfmt.width;
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index c5291b0..ee5650f 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -105,25 +105,25 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
 }
 
 static int configure_geometry(struct atmel_isi *isi, u32 width,
-			u32 height, enum v4l2_mbus_pixelcode code)
+			u32 height, u32 code)
 {
 	u32 cfg2, cr;
 
 	switch (code) {
 	/* YUV, including grey */
-	case V4L2_MBUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
 		cr = ISI_CFG2_GRAYSCALE;
 		break;
-	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_MODE_3;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_MODE_2;
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_MODE_1;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_DEFAULT;
 		break;
 	/* RGB, TODO */
@@ -645,7 +645,7 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int formats = 0, ret;
 	/* sensor format */
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	/* soc camera host format */
 	const struct soc_mbus_pixelfmt *fmt;
 
@@ -670,10 +670,10 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	}
 
 	switch (code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
-	case V4L2_MBUS_FMT_VYUY8_2X8:
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &isi_camera_formats[0];
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 2347612a..ce72bd2 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -211,7 +211,7 @@ struct emma_prp_resize {
 
 /* prp configuration for a client-host fmt pair */
 struct mx2_fmt_cfg {
-	enum v4l2_mbus_pixelcode	in_fmt;
+	u32	in_fmt;
 	u32				out_fmt;
 	struct mx2_prp_cfg		cfg;
 };
@@ -309,7 +309,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 		}
 	},
 	{
-		.in_fmt		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.in_fmt		= MEDIA_BUS_FMT_UYVY8_2X8,
 		.out_fmt	= V4L2_PIX_FMT_YUYV,
 		.cfg		= {
 			.channel	= 1,
@@ -323,7 +323,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 		}
 	},
 	{
-		.in_fmt		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.in_fmt		= MEDIA_BUS_FMT_YUYV8_2X8,
 		.out_fmt	= V4L2_PIX_FMT_YUYV,
 		.cfg		= {
 			.channel	= 1,
@@ -337,7 +337,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 		}
 	},
 	{
-		.in_fmt		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.in_fmt		= MEDIA_BUS_FMT_YUYV8_2X8,
 		.out_fmt	= V4L2_PIX_FMT_YUV420,
 		.cfg		= {
 			.channel	= 2,
@@ -351,7 +351,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 		}
 	},
 	{
-		.in_fmt		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.in_fmt		= MEDIA_BUS_FMT_UYVY8_2X8,
 		.out_fmt	= V4L2_PIX_FMT_YUV420,
 		.cfg		= {
 			.channel	= 2,
@@ -366,9 +366,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 	},
 };
 
-static struct mx2_fmt_cfg *mx27_emma_prp_get_format(
-					enum v4l2_mbus_pixelcode in_fmt,
-					u32 out_fmt)
+static struct mx2_fmt_cfg *mx27_emma_prp_get_format(u32 in_fmt, u32 out_fmt)
 {
 	int i;
 
@@ -945,7 +943,7 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	const struct soc_mbus_pixelfmt *fmt;
 	struct device *dev = icd->parent;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	int ret, formats = 0;
 
 	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
@@ -959,8 +957,8 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 		return 0;
 	}
 
-	if (code == V4L2_MBUS_FMT_YUYV8_2X8 ||
-	    code == V4L2_MBUS_FMT_UYVY8_2X8) {
+	if (code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+	    code == MEDIA_BUS_FMT_UYVY8_2X8) {
 		formats++;
 		if (xlate) {
 			/*
@@ -968,7 +966,7 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 			 * soc_mediabus.c
 			 */
 			xlate->host_fmt =
-				soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_YUYV8_1_5X8);
+				soc_mbus_get_fmtdesc(MEDIA_BUS_FMT_YUYV8_1_5X8);
 			xlate->code	= code;
 			dev_dbg(dev, "Providing host format %s for sensor code %d\n",
 			       xlate->host_fmt->name, code);
@@ -976,11 +974,11 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 		}
 	}
 
-	if (code == V4L2_MBUS_FMT_UYVY8_2X8) {
+	if (code == MEDIA_BUS_FMT_UYVY8_2X8) {
 		formats++;
 		if (xlate) {
 			xlate->host_fmt =
-				soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_YUYV8_2X8);
+				soc_mbus_get_fmtdesc(MEDIA_BUS_FMT_YUYV8_2X8);
 			xlate->code	= code;
 			dev_dbg(dev, "Providing host format %s for sensor code %d\n",
 				xlate->host_fmt->name, code);
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 7696a87..8e52ccc 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -656,7 +656,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	int formats = 0, ret;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	const struct soc_mbus_pixelfmt *fmt;
 
 	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
@@ -677,7 +677,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 		return 0;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &mx3_camera_formats[0];
@@ -687,7 +687,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 				mx3_camera_formats[0].name, code);
 		}
 		break;
-	case V4L2_MBUS_FMT_Y10_1X10:
+	case MEDIA_BUS_FMT_Y10_1X10:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &mx3_camera_formats[1];
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 74ce8b6..e6b9328 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -140,7 +140,7 @@
 /* buffer for one video frame */
 struct omap1_cam_buf {
 	struct videobuf_buffer		vb;
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	int				inwork;
 	struct scatterlist		*sgbuf;
 	int				sgcount;
@@ -980,7 +980,7 @@ static void omap1_cam_clock_stop(struct soc_camera_host *ici)
 /* Duplicate standard formats based on host capability of byte swapping */
 static const struct soc_mbus_lookup omap1_cam_formats[] = {
 {
-	.code = V4L2_MBUS_FMT_UYVY8_2X8,
+	.code = MEDIA_BUS_FMT_UYVY8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YUYV,
 		.name			= "YUYV",
@@ -990,7 +990,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_VYUY8_2X8,
+	.code = MEDIA_BUS_FMT_VYUY8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YVYU,
 		.name			= "YVYU",
@@ -1000,7 +1000,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YUYV8_2X8,
+	.code = MEDIA_BUS_FMT_YUYV8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_UYVY,
 		.name			= "UYVY",
@@ -1010,7 +1010,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YVYU8_2X8,
+	.code = MEDIA_BUS_FMT_YVYU8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_VYUY,
 		.name			= "VYUY",
@@ -1020,7 +1020,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+	.code = MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555,
 		.name			= "RGB555",
@@ -1030,7 +1030,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+	.code = MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555X,
 		.name			= "RGB555X",
@@ -1040,7 +1040,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
+	.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565,
 		.name			= "RGB565",
@@ -1050,7 +1050,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB565_2X8_LE,
+	.code = MEDIA_BUS_FMT_RGB565_2X8_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565X,
 		.name			= "RGB565X",
@@ -1068,7 +1068,7 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->parent;
 	int formats = 0, ret;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	const struct soc_mbus_pixelfmt *fmt;
 
 	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
@@ -1088,14 +1088,14 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 		return 0;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_YVYU8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
-	case V4L2_MBUS_FMT_VYUY8_2X8:
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= soc_mbus_find_fmtdesc(code,
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 66178fc..951226a 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -187,7 +187,7 @@ struct pxa_cam_dma {
 struct pxa_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct videobuf_buffer		vb;
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	/* our descriptor lists for Y, U and V channels */
 	struct pxa_cam_dma		dmas[3];
 	int				inwork;
@@ -1253,7 +1253,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	struct device *dev = icd->parent;
 	int formats = 0, ret;
 	struct pxa_cam *cam;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	const struct soc_mbus_pixelfmt *fmt;
 
 	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
@@ -1283,7 +1283,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	}
 
 	switch (code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &pxa_camera_formats[0];
@@ -1292,11 +1292,11 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 			dev_dbg(dev, "Providing format %s using code %d\n",
 				pxa_camera_formats[0].name, code);
 		}
-	case V4L2_MBUS_FMT_VYUY8_2X8:
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_YVYU8_2X8:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
 		if (xlate)
 			dev_dbg(dev, "Providing format %s packed\n",
 				fmt->name);
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 20defcb..8d8438b 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -272,16 +272,16 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 
 	/* input interface */
 	switch (icd->current_fmt->code) {
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
 		vnmc |= priv->pdata_flags & RCAR_VIN_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		break;
-	case V4L2_MBUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_YUYV10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
 		vnmc |= priv->pdata_flags & RCAR_VIN_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
@@ -921,7 +921,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	int ret, k, n;
 	int formats = 0;
 	struct rcar_vin_cam *cam;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	const struct soc_mbus_pixelfmt *fmt;
 
 	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
@@ -1010,9 +1010,9 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 		cam->extra_fmt = NULL;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_YUYV8_1X16:
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV10_2X10:
 		if (cam->extra_fmt)
 			break;
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 20ad4a5..5f58ed9 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -149,7 +149,7 @@ struct sh_mobile_ceu_cam {
 	/* Camera cropping rectangle */
 	struct v4l2_rect rect;
 	const struct soc_mbus_pixelfmt *extra_fmt;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 };
 
 static struct sh_mobile_ceu_buffer *to_ceu_vb(struct vb2_buffer *vb)
@@ -861,16 +861,16 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd)
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
 		switch (cam->code) {
-		case V4L2_MBUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
 			value = 0x00000000; /* Cb0, Y0, Cr0, Y1 */
 			break;
-		case V4L2_MBUS_FMT_VYUY8_2X8:
+		case MEDIA_BUS_FMT_VYUY8_2X8:
 			value = 0x00000100; /* Cr0, Y0, Cb0, Y1 */
 			break;
-		case V4L2_MBUS_FMT_YUYV8_2X8:
+		case MEDIA_BUS_FMT_YUYV8_2X8:
 			value = 0x00000200; /* Y0, Cb0, Y1, Cr0 */
 			break;
-		case V4L2_MBUS_FMT_YVYU8_2X8:
+		case MEDIA_BUS_FMT_YVYU8_2X8:
 			value = 0x00000300; /* Y0, Cr0, Y1, Cb0 */
 			break;
 		default:
@@ -1048,7 +1048,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 	int ret, k, n;
 	int formats = 0;
 	struct sh_mobile_ceu_cam *cam;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	const struct soc_mbus_pixelfmt *fmt;
 
 	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
@@ -1141,10 +1141,10 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		cam->extra_fmt = NULL;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
-	case V4L2_MBUS_FMT_VYUY8_2X8:
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
 		if (cam->extra_fmt)
 			break;
 
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 05dd21a..c738e27 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -59,28 +59,28 @@ static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
 	switch (pdata->type) {
 	case SH_CSI2C:
 		switch (mf->code) {
-		case V4L2_MBUS_FMT_UYVY8_2X8:		/* YUV422 */
-		case V4L2_MBUS_FMT_YUYV8_1_5X8:		/* YUV420 */
-		case V4L2_MBUS_FMT_Y8_1X8:		/* RAW8 */
-		case V4L2_MBUS_FMT_SBGGR8_1X8:
-		case V4L2_MBUS_FMT_SGRBG8_1X8:
+		case MEDIA_BUS_FMT_UYVY8_2X8:		/* YUV422 */
+		case MEDIA_BUS_FMT_YUYV8_1_5X8:		/* YUV420 */
+		case MEDIA_BUS_FMT_Y8_1X8:		/* RAW8 */
+		case MEDIA_BUS_FMT_SBGGR8_1X8:
+		case MEDIA_BUS_FMT_SGRBG8_1X8:
 			break;
 		default:
 			/* All MIPI CSI-2 devices must support one of primary formats */
-			mf->code = V4L2_MBUS_FMT_YUYV8_2X8;
+			mf->code = MEDIA_BUS_FMT_YUYV8_2X8;
 		}
 		break;
 	case SH_CSI2I:
 		switch (mf->code) {
-		case V4L2_MBUS_FMT_Y8_1X8:		/* RAW8 */
-		case V4L2_MBUS_FMT_SBGGR8_1X8:
-		case V4L2_MBUS_FMT_SGRBG8_1X8:
-		case V4L2_MBUS_FMT_SBGGR10_1X10:	/* RAW10 */
-		case V4L2_MBUS_FMT_SBGGR12_1X12:	/* RAW12 */
+		case MEDIA_BUS_FMT_Y8_1X8:		/* RAW8 */
+		case MEDIA_BUS_FMT_SBGGR8_1X8:
+		case MEDIA_BUS_FMT_SGRBG8_1X8:
+		case MEDIA_BUS_FMT_SBGGR10_1X10:	/* RAW10 */
+		case MEDIA_BUS_FMT_SBGGR12_1X12:	/* RAW12 */
 			break;
 		default:
 			/* All MIPI CSI-2 devices must support one of primary formats */
-			mf->code = V4L2_MBUS_FMT_SBGGR8_1X8;
+			mf->code = MEDIA_BUS_FMT_SBGGR8_1X8;
 		}
 		break;
 	}
@@ -104,21 +104,21 @@ static int sh_csi2_s_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		tmp |= 0x1e;	/* YUV422 8 bit */
 		break;
-	case V4L2_MBUS_FMT_YUYV8_1_5X8:
+	case MEDIA_BUS_FMT_YUYV8_1_5X8:
 		tmp |= 0x18;	/* YUV420 8 bit */
 		break;
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
 		tmp |= 0x21;	/* RGB555 */
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		tmp |= 0x22;	/* RGB565 */
 		break;
-	case V4L2_MBUS_FMT_Y8_1X8:
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
-	case V4L2_MBUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
 		tmp |= 0x2a;	/* RAW8 */
 		break;
 	default:
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 8e61b97..f4be2a1 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -460,7 +460,7 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	unsigned int i, fmts = 0, raw_fmts = 0;
 	int ret;
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 
 	while (!v4l2_subdev_call(sd, video, enum_mbus_fmt, raw_fmts, &code))
 		raw_fmts++;
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index ceaddfb..f2ce1ab 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -62,7 +62,7 @@ static struct v4l2_subdev_core_ops platform_subdev_core_ops = {
 };
 
 static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-					enum v4l2_mbus_pixelcode *code)
+					u32 *code)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index dc02dec..1dbcd42 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -17,7 +17,7 @@
 
 static const struct soc_mbus_lookup mbus_fmt[] = {
 {
-	.code = V4L2_MBUS_FMT_YUYV8_2X8,
+	.code = MEDIA_BUS_FMT_YUYV8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YUYV,
 		.name			= "YUYV",
@@ -27,7 +27,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YVYU8_2X8,
+	.code = MEDIA_BUS_FMT_YVYU8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YVYU,
 		.name			= "YVYU",
@@ -37,7 +37,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_UYVY8_2X8,
+	.code = MEDIA_BUS_FMT_UYVY8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_UYVY,
 		.name			= "UYVY",
@@ -47,7 +47,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_VYUY8_2X8,
+	.code = MEDIA_BUS_FMT_VYUY8_2X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_VYUY,
 		.name			= "VYUY",
@@ -57,7 +57,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+	.code = MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555,
 		.name			= "RGB555",
@@ -67,7 +67,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+	.code = MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555X,
 		.name			= "RGB555X",
@@ -77,7 +77,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB565_2X8_LE,
+	.code = MEDIA_BUS_FMT_RGB565_2X8_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565,
 		.name			= "RGB565",
@@ -87,7 +87,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
+	.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565X,
 		.name			= "RGB565X",
@@ -97,7 +97,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB666_1X18,
+	.code = MEDIA_BUS_FMT_RGB666_1X18,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB32,
 		.name			= "RGB666/32bpp",
@@ -106,7 +106,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB888_1X24,
+	.code = MEDIA_BUS_FMT_RGB888_1X24,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB32,
 		.name			= "RGB888/32bpp",
@@ -115,7 +115,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB888_2X12_BE,
+	.code = MEDIA_BUS_FMT_RGB888_2X12_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB32,
 		.name			= "RGB888/32bpp",
@@ -124,7 +124,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_BE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB888_2X12_LE,
+	.code = MEDIA_BUS_FMT_RGB888_2X12_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB32,
 		.name			= "RGB888/32bpp",
@@ -133,7 +133,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR8_1X8,
+	.code = MEDIA_BUS_FMT_SBGGR8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR8,
 		.name			= "Bayer 8 BGGR",
@@ -143,7 +143,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_1X10,
+	.code = MEDIA_BUS_FMT_SBGGR10_1X10,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
@@ -153,7 +153,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_Y8_1X8,
+	.code = MEDIA_BUS_FMT_Y8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_GREY,
 		.name			= "Grey",
@@ -163,7 +163,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_Y10_1X10,
+	.code = MEDIA_BUS_FMT_Y10_1X10,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_Y10,
 		.name			= "Grey 10bit",
@@ -173,7 +173,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
+	.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
@@ -183,7 +183,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
+	.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
@@ -193,7 +193,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
+	.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
@@ -203,7 +203,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
+	.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR10,
 		.name			= "Bayer 10 BGGR",
@@ -213,7 +213,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_JPEG_1X8,
+	.code = MEDIA_BUS_FMT_JPEG_1X8,
 	.fmt = {
 		.fourcc                 = V4L2_PIX_FMT_JPEG,
 		.name                   = "JPEG",
@@ -223,7 +223,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE,
+	.code = MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB444,
 		.name			= "RGB444",
@@ -233,7 +233,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YUYV8_1_5X8,
+	.code = MEDIA_BUS_FMT_YUYV8_1_5X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YUV420,
 		.name			= "YUYV 4:2:0",
@@ -243,7 +243,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YVYU8_1_5X8,
+	.code = MEDIA_BUS_FMT_YVYU8_1_5X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YVU420,
 		.name			= "YVYU 4:2:0",
@@ -253,7 +253,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_UYVY8_1X16,
+	.code = MEDIA_BUS_FMT_UYVY8_1X16,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_UYVY,
 		.name			= "UYVY 16bit",
@@ -263,7 +263,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_VYUY8_1X16,
+	.code = MEDIA_BUS_FMT_VYUY8_1X16,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_VYUY,
 		.name			= "VYUY 16bit",
@@ -273,7 +273,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YUYV8_1X16,
+	.code = MEDIA_BUS_FMT_YUYV8_1X16,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YUYV,
 		.name			= "YUYV 16bit",
@@ -283,7 +283,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_YVYU8_1X16,
+	.code = MEDIA_BUS_FMT_YVYU8_1X16,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YVYU,
 		.name			= "YVYU 16bit",
@@ -293,7 +293,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SGRBG8_1X8,
+	.code = MEDIA_BUS_FMT_SGRBG8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGRBG8,
 		.name			= "Bayer 8 GRBG",
@@ -303,7 +303,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	.code = MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGRBG10DPCM8,
 		.name			= "Bayer 10 BGGR DPCM 8",
@@ -313,7 +313,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SGBRG10_1X10,
+	.code = MEDIA_BUS_FMT_SGBRG10_1X10,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGBRG10,
 		.name			= "Bayer 10 GBRG",
@@ -323,7 +323,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+	.code = MEDIA_BUS_FMT_SGRBG10_1X10,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGRBG10,
 		.name			= "Bayer 10 GRBG",
@@ -333,7 +333,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SRGGB10_1X10,
+	.code = MEDIA_BUS_FMT_SRGGB10_1X10,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SRGGB10,
 		.name			= "Bayer 10 RGGB",
@@ -343,7 +343,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SBGGR12_1X12,
+	.code = MEDIA_BUS_FMT_SBGGR12_1X12,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SBGGR12,
 		.name			= "Bayer 12 BGGR",
@@ -353,7 +353,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SGBRG12_1X12,
+	.code = MEDIA_BUS_FMT_SGBRG12_1X12,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGBRG12,
 		.name			= "Bayer 12 GBRG",
@@ -363,7 +363,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SGRBG12_1X12,
+	.code = MEDIA_BUS_FMT_SGRBG12_1X12,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SGRBG12,
 		.name			= "Bayer 12 GRBG",
@@ -373,7 +373,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
-	.code = V4L2_MBUS_FMT_SRGGB12_1X12,
+	.code = MEDIA_BUS_FMT_SRGGB12_1X12,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_SRGGB12,
 		.name			= "Bayer 12 RGGB",
@@ -458,7 +458,7 @@ s32 soc_mbus_image_size(const struct soc_mbus_pixelfmt *mf,
 EXPORT_SYMBOL(soc_mbus_image_size);
 
 const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
-	enum v4l2_mbus_pixelcode code,
+	u32 code,
 	const struct soc_mbus_lookup *lookup,
 	int n)
 {
@@ -473,7 +473,7 @@ const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
 EXPORT_SYMBOL(soc_mbus_find_fmtdesc);
 
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
-	enum v4l2_mbus_pixelcode code)
+	u32 code)
 {
 	return soc_mbus_find_fmtdesc(code, mbus_fmt, ARRAY_SIZE(mbus_fmt));
 }
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index ae6870c..2616483 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -101,7 +101,7 @@ struct via_camera {
 	 */
 	struct v4l2_pix_format sensor_format;
 	struct v4l2_pix_format user_format;
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 };
 
 /*
@@ -143,12 +143,12 @@ static struct via_format {
 	__u8 *desc;
 	__u32 pixelformat;
 	int bpp;   /* Bytes per pixel */
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 } via_formats[] = {
 	{
 		.desc		= "YUYV 4:2:2",
 		.pixelformat	= V4L2_PIX_FMT_YUYV,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.bpp		= 2,
 	},
 	/* RGB444 and Bayer should be doable, but have never been
@@ -849,7 +849,7 @@ static const struct v4l2_pix_format viacam_def_pix_format = {
 	.sizeimage	= VGA_WIDTH * VGA_HEIGHT * 2,
 };
 
-static const enum v4l2_mbus_pixelcode via_def_mbus_code = V4L2_MBUS_FMT_YUYV8_2X8;
+static const u32 via_def_mbus_code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 static int viacam_enum_fmt_vid_cap(struct file *filp, void *priv,
 		struct v4l2_fmtdesc *fmt)
diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index a0c1984..b21f381 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -187,8 +187,8 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
-		V4L2_MBUS_FMT_ARGB8888_1X32,
-		V4L2_MBUS_FMT_AYUV8_1X32,
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 	struct v4l2_mbus_framefmt *format;
 
@@ -215,8 +215,8 @@ static int bru_enum_frame_size(struct v4l2_subdev *subdev,
 	if (fse->index)
 		return -EINVAL;
 
-	if (fse->code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
-	    fse->code != V4L2_MBUS_FMT_AYUV8_1X32)
+	if (fse->code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fse->code != MEDIA_BUS_FMT_AYUV8_1X32)
 		return -EINVAL;
 
 	fse->min_width = BRU_MIN_SIZE;
@@ -261,9 +261,9 @@ static void bru_try_format(struct vsp1_bru *bru, struct v4l2_subdev_fh *fh,
 	switch (pad) {
 	case BRU_PAD_SINK(0):
 		/* Default to YUV if the requested format is not supported. */
-		if (fmt->code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
-		    fmt->code != V4L2_MBUS_FMT_AYUV8_1X32)
-			fmt->code = V4L2_MBUS_FMT_AYUV8_1X32;
+		if (fmt->code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+		    fmt->code != MEDIA_BUS_FMT_AYUV8_1X32)
+			fmt->code = MEDIA_BUS_FMT_AYUV8_1X32;
 		break;
 
 	default:
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index db2950a..80bedc5 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -70,9 +70,9 @@ static int hsit_enum_mbus_code(struct v4l2_subdev *subdev,
 
 	if ((code->pad == HSIT_PAD_SINK && !hsit->inverse) |
 	    (code->pad == HSIT_PAD_SOURCE && hsit->inverse))
-		code->code = V4L2_MBUS_FMT_ARGB8888_1X32;
+		code->code = MEDIA_BUS_FMT_ARGB8888_1X32;
 	else
-		code->code = V4L2_MBUS_FMT_AHSV8888_1X32;
+		code->code = MEDIA_BUS_FMT_AHSV8888_1X32;
 
 	return 0;
 }
@@ -136,8 +136,8 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 		return 0;
 	}
 
-	format->code = hsit->inverse ? V4L2_MBUS_FMT_AHSV8888_1X32
-		     : V4L2_MBUS_FMT_ARGB8888_1X32;
+	format->code = hsit->inverse ? MEDIA_BUS_FMT_AHSV8888_1X32
+		     : MEDIA_BUS_FMT_ARGB8888_1X32;
 	format->width = clamp_t(unsigned int, fmt->format.width,
 				HSIT_MIN_SIZE, HSIT_MAX_SIZE);
 	format->height = clamp_t(unsigned int, fmt->format.height,
@@ -151,8 +151,8 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 	format = vsp1_entity_get_pad_format(&hsit->entity, fh, HSIT_PAD_SOURCE,
 					    fmt->which);
 	*format = fmt->format;
-	format->code = hsit->inverse ? V4L2_MBUS_FMT_ARGB8888_1X32
-		     : V4L2_MBUS_FMT_AHSV8888_1X32;
+	format->code = hsit->inverse ? MEDIA_BUS_FMT_ARGB8888_1X32
+		     : MEDIA_BUS_FMT_AHSV8888_1X32;
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index d4fb23e..17a6ca7 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -78,8 +78,8 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
-		V4L2_MBUS_FMT_ARGB8888_1X32,
-		V4L2_MBUS_FMT_AYUV8_1X32,
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 
 	if (code->pad == LIF_PAD_SINK) {
@@ -147,9 +147,9 @@ static int lif_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	struct v4l2_mbus_framefmt *format;
 
 	/* Default to YUV if the requested format is not supported. */
-	if (fmt->format.code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
-	    fmt->format.code != V4L2_MBUS_FMT_AYUV8_1X32)
-		fmt->format.code = V4L2_MBUS_FMT_AYUV8_1X32;
+	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
+		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
 	format = vsp1_entity_get_pad_format(&lif->entity, fh, fmt->pad,
 					    fmt->which);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index fea36eb..6f185c3 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -86,9 +86,9 @@ static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
-		V4L2_MBUS_FMT_ARGB8888_1X32,
-		V4L2_MBUS_FMT_AHSV8888_1X32,
-		V4L2_MBUS_FMT_AYUV8_1X32,
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AHSV8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 	struct v4l2_mbus_framefmt *format;
 
@@ -158,10 +158,10 @@ static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	struct v4l2_mbus_framefmt *format;
 
 	/* Default to YUV if the requested format is not supported. */
-	if (fmt->format.code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
-	    fmt->format.code != V4L2_MBUS_FMT_AHSV8888_1X32 &&
-	    fmt->format.code != V4L2_MBUS_FMT_AYUV8_1X32)
-		fmt->format.code = V4L2_MBUS_FMT_AYUV8_1X32;
+	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
+		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
 	format = vsp1_entity_get_pad_format(&lut->entity, fh, fmt->pad,
 					    fmt->which);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index ec3dab6..1f1ba26 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -29,8 +29,8 @@ int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
-		V4L2_MBUS_FMT_ARGB8888_1X32,
-		V4L2_MBUS_FMT_AYUV8_1X32,
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 
 	if (code->index >= ARRAY_SIZE(codes))
@@ -103,9 +103,9 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	struct v4l2_rect *crop;
 
 	/* Default to YUV if the requested format is not supported. */
-	if (fmt->format.code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
-	    fmt->format.code != V4L2_MBUS_FMT_AYUV8_1X32)
-		fmt->format.code = V4L2_MBUS_FMT_AYUV8_1X32;
+	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
+		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
 	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, fmt->pad,
 					    fmt->which);
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index b7d3c8b..1129494 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -139,7 +139,7 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 	input = &sru->entity.formats[SRU_PAD_SINK];
 	output = &sru->entity.formats[SRU_PAD_SOURCE];
 
-	if (input->code == V4L2_MBUS_FMT_ARGB8888_1X32)
+	if (input->code == MEDIA_BUS_FMT_ARGB8888_1X32)
 		ctrl0 = VI6_SRU_CTRL0_PARAM2 | VI6_SRU_CTRL0_PARAM3
 		      | VI6_SRU_CTRL0_PARAM4;
 	else
@@ -170,8 +170,8 @@ static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
-		V4L2_MBUS_FMT_ARGB8888_1X32,
-		V4L2_MBUS_FMT_AYUV8_1X32,
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 	struct v4l2_mbus_framefmt *format;
 
@@ -248,9 +248,9 @@ static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_fh *fh,
 	switch (pad) {
 	case SRU_PAD_SINK:
 		/* Default to YUV if the requested format is not supported. */
-		if (fmt->code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
-		    fmt->code != V4L2_MBUS_FMT_AYUV8_1X32)
-			fmt->code = V4L2_MBUS_FMT_AYUV8_1X32;
+		if (fmt->code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+		    fmt->code != MEDIA_BUS_FMT_AYUV8_1X32)
+			fmt->code = MEDIA_BUS_FMT_AYUV8_1X32;
 
 		fmt->width = clamp(fmt->width, SRU_MIN_SIZE, SRU_MAX_SIZE);
 		fmt->height = clamp(fmt->height, SRU_MIN_SIZE, SRU_MAX_SIZE);
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index de92ef4..a4afec1 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -173,8 +173,8 @@ static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
-		V4L2_MBUS_FMT_ARGB8888_1X32,
-		V4L2_MBUS_FMT_AYUV8_1X32,
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 
 	if (code->pad == UDS_PAD_SINK) {
@@ -246,9 +246,9 @@ static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_fh *fh,
 	switch (pad) {
 	case UDS_PAD_SINK:
 		/* Default to YUV if the requested format is not supported. */
-		if (fmt->code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
-		    fmt->code != V4L2_MBUS_FMT_AYUV8_1X32)
-			fmt->code = V4L2_MBUS_FMT_AYUV8_1X32;
+		if (fmt->code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+		    fmt->code != MEDIA_BUS_FMT_AYUV8_1X32)
+			fmt->code = MEDIA_BUS_FMT_AYUV8_1X32;
 
 		fmt->width = clamp(fmt->width, UDS_MIN_SIZE, UDS_MAX_SIZE);
 		fmt->height = clamp(fmt->height, UDS_MIN_SIZE, UDS_MAX_SIZE);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 915a20e..d91f19a 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -48,85 +48,85 @@
  */
 
 static const struct vsp1_format_info vsp1_video_formats[] = {
-	{ V4L2_PIX_FMT_RGB332, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_RGB332, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_RGB_332, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 8, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_ARGB444, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_ARGB444, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
 	  1, { 16, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XRGB444, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XRGB444, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_XRGB_4444, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
 	  1, { 16, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_ARGB555, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_ARGB555, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
 	  1, { 16, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XRGB555, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XRGB555, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_XRGB_1555, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
 	  1, { 16, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_RGB565, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_RGB565, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_RGB_565, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS,
 	  1, { 16, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_BGR24, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_BGR24, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_BGR_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 24, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_RGB24, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_RGB24, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_RGB_888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 24, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_ABGR32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_ABGR32, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
 	  1, { 32, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XBGR32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XBGR32, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS,
 	  1, { 32, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_ARGB32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_ARGB32, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 32, 0, 0 }, false, false, 1, 1, true },
-	{ V4L2_PIX_FMT_XRGB32, V4L2_MBUS_FMT_ARGB8888_1X32,
+	{ V4L2_PIX_FMT_XRGB32, MEDIA_BUS_FMT_ARGB8888_1X32,
 	  VI6_FMT_ARGB_8888, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 32, 0, 0 }, false, false, 1, 1, false },
-	{ V4L2_PIX_FMT_UYVY, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_UYVY, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 16, 0, 0 }, false, false, 2, 1, false },
-	{ V4L2_PIX_FMT_VYUY, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_VYUY, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 16, 0, 0 }, false, true, 2, 1, false },
-	{ V4L2_PIX_FMT_YUYV, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 16, 0, 0 }, true, false, 2, 1, false },
-	{ V4L2_PIX_FMT_YVYU, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_YVYU, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_YUYV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  1, { 16, 0, 0 }, true, true, 2, 1, false },
-	{ V4L2_PIX_FMT_NV12M, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_NV12M, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  2, { 8, 16, 0 }, false, false, 2, 2, false },
-	{ V4L2_PIX_FMT_NV21M, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_NV21M, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  2, { 8, 16, 0 }, false, true, 2, 2, false },
-	{ V4L2_PIX_FMT_NV16M, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_NV16M, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  2, { 8, 16, 0 }, false, false, 2, 1, false },
-	{ V4L2_PIX_FMT_NV61M, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_NV61M, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_UV_422, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  2, { 8, 16, 0 }, false, true, 2, 1, false },
-	{ V4L2_PIX_FMT_YUV420M, V4L2_MBUS_FMT_AYUV8_1X32,
+	{ V4L2_PIX_FMT_YUV420M, MEDIA_BUS_FMT_AYUV8_1X32,
 	  VI6_FMT_Y_U_V_420, VI6_RPF_DSWAP_P_LLS | VI6_RPF_DSWAP_P_LWS |
 	  VI6_RPF_DSWAP_P_WDS | VI6_RPF_DSWAP_P_BTS,
 	  3, { 8, 8, 8 }, false, false, 2, 2, false },
diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
index 57585c70..4376bee 100644
--- a/include/media/davinci/vpbe.h
+++ b/include/media/davinci/vpbe.h
@@ -63,7 +63,7 @@ struct vpbe_output {
 	 * output basis. If per mode is needed, we may have to move this to
 	 * mode_info structure
 	 */
-	enum v4l2_mbus_pixelcode if_params;
+	u32 if_params;
 };
 
 /* encoder configuration info */
diff --git a/include/media/davinci/vpbe_venc.h b/include/media/davinci/vpbe_venc.h
index 476fafc..3dbd200 100644
--- a/include/media/davinci/vpbe_venc.h
+++ b/include/media/davinci/vpbe_venc.h
@@ -30,11 +30,10 @@
 #define VENC_SECOND_FIELD	BIT(2)
 
 struct venc_platform_data {
-	int (*setup_pinmux)(enum v4l2_mbus_pixelcode if_type,
-			    int field);
+	int (*setup_pinmux)(u32 if_type, int field);
 	int (*setup_clock)(enum vpbe_enc_timings_type type,
 			   unsigned int pixclock);
-	int (*setup_if_config)(enum v4l2_mbus_pixelcode pixcode);
+	int (*setup_if_config)(u32 pixcode);
 	/* Number of LCD outputs supported */
 	int num_lcd_outputs;
 	struct vpbe_if_params *lcd_if_params;
diff --git a/include/media/exynos-fimc.h b/include/media/exynos-fimc.h
index aa44660..69bcd2a 100644
--- a/include/media/exynos-fimc.h
+++ b/include/media/exynos-fimc.h
@@ -101,7 +101,7 @@ struct fimc_source_info {
  * @flags: flags indicating which operation mode format applies to
  */
 struct fimc_fmt {
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 	char	*name;
 	u32	fourcc;
 	u32	color;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 865246b..2f6261f 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -296,7 +296,7 @@ const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
  * format setup.
  */
 struct soc_camera_format_xlate {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	const struct soc_mbus_pixelfmt *host_fmt;
 };
 
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index d33f6d0..2ff7737 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -91,16 +91,16 @@ struct soc_mbus_pixelfmt {
  * @fmt:	pixel format description
  */
 struct soc_mbus_lookup {
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	struct soc_mbus_pixelfmt	fmt;
 };
 
 const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
-	enum v4l2_mbus_pixelcode code,
+	u32 code,
 	const struct soc_mbus_lookup *lookup,
 	int n);
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
-	enum v4l2_mbus_pixelcode code);
+	u32 code);
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf);
 s32 soc_mbus_image_size(const struct soc_mbus_pixelfmt *mf,
 			u32 bytes_per_line, u32 height);
-- 
1.9.1
