From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 08/15] staging: media: Make use of media_bus_format enum
Date: Tue,  4 Nov 2014 10:55:03 +0100
Message-ID: <1415094910-15899-9-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Reference new definitions in all media drivers residing in staging.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  18 ++--
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |  26 +++---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 100 ++++++++++-----------
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  90 +++++++++----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  96 ++++++++++----------
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  18 ++--
 drivers/staging/media/omap4iss/iss_csi2.c          |  62 ++++++-------
 drivers/staging/media/omap4iss/iss_ipipe.c         |  16 ++--
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  28 +++---
 drivers/staging/media/omap4iss/iss_resizer.c       |  26 +++---
 drivers/staging/media/omap4iss/iss_video.c         |  78 ++++++++--------
 drivers/staging/media/omap4iss/iss_video.h         |  10 +--
 12 files changed, 284 insertions(+), 284 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index bdc7f00..704fa20 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -37,15 +37,15 @@
 
 /* ipipe input format's */
 static const unsigned int ipipe_input_fmts[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_SGRBG12_1X12,
-	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
-	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
 };
 
 /* ipipe output format's */
 static const unsigned int ipipe_output_fmts[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
 };
 
 static int ipipe_validate_lutdpc_params(struct vpfe_ipipe_lutdpc *lutdpc)
@@ -1457,7 +1457,7 @@ ipipe_try_format(struct vpfe_ipipe_device *ipipe,
 
 		/* If not found, use SBGGR10 as default */
 		if (i >= ARRAY_SIZE(ipipe_input_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG12_1X12;
+			fmt->code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	} else if (pad == IPIPE_PAD_SOURCE) {
 		for (i = 0; i < ARRAY_SIZE(ipipe_output_fmts); i++)
 			if (fmt->code == ipipe_output_fmts[i])
@@ -1465,7 +1465,7 @@ ipipe_try_format(struct vpfe_ipipe_device *ipipe,
 
 		/* If not found, use UYVY as default */
 		if (i >= ARRAY_SIZE(ipipe_output_fmts))
-			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	}
 
 	fmt->width = clamp_t(u32, fmt->width, MIN_OUT_HEIGHT, max_out_width);
@@ -1642,7 +1642,7 @@ ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPE_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
 	ipipe_set_format(sd, fh, &format);
@@ -1650,7 +1650,7 @@ ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPE_PAD_SOURCE;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+	format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
 	ipipe_set_format(sd, fh, &format);
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index b2daf5e..4a0895b2 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -196,12 +196,12 @@ ipipe_setup_resizer(void *__iomem rsz_base, struct resizer_params *params)
 		rsz_set_rsz_regs(rsz_base, RSZ_B, params);
 }
 
-static u32 ipipe_get_color_pat(enum v4l2_mbus_pixelcode pix)
+static u32 ipipe_get_color_pat(enum media_bus_format pix)
 {
 	switch (pix) {
-	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
 		return ipipe_sgrbg_pattern;
 
 	default:
@@ -211,23 +211,23 @@ static u32 ipipe_get_color_pat(enum v4l2_mbus_pixelcode pix)
 
 static int ipipe_get_data_path(struct vpfe_ipipe_device *ipipe)
 {
-	enum v4l2_mbus_pixelcode temp_pix_fmt;
+	enum media_bus_format temp_pix_fmt;
 
 	switch (ipipe->formats[IPIPE_PAD_SINK].code) {
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
-		temp_pix_fmt = V4L2_MBUS_FMT_SGRBG12_1X12;
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
+		temp_pix_fmt = MEDIA_BUS_FMT_SGRBG12_1X12;
 		break;
 
 	default:
-		temp_pix_fmt = V4L2_MBUS_FMT_UYVY8_2X8;
+		temp_pix_fmt = MEDIA_BUS_FMT_UYVY8_2X8;
 	}
 
-	if (temp_pix_fmt == V4L2_MBUS_FMT_SGRBG12_1X12) {
+	if (temp_pix_fmt == MEDIA_BUS_FMT_SGRBG12_1X12) {
 		if (ipipe->formats[IPIPE_PAD_SOURCE].code ==
-			V4L2_MBUS_FMT_SGRBG12_1X12)
+			MEDIA_BUS_FMT_SGRBG12_1X12)
 			return IPIPE_RAW2RAW;
 		return IPIPE_RAW2YUV;
 	}
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 6d4893b..3818e94 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -23,42 +23,42 @@
 #include "vpfe_mc_capture.h"
 
 static const unsigned int ipipeif_input_fmts[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_SGRBG12_1X12,
-	V4L2_MBUS_FMT_Y8_1X8,
-	V4L2_MBUS_FMT_UV8_1X8,
-	V4L2_MBUS_FMT_YDYUYDYV8_1X16,
-	V4L2_MBUS_FMT_SBGGR8_1X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_Y8_1X8,
+	MEDIA_BUS_FMT_UV8_1X8,
+	MEDIA_BUS_FMT_YDYUYDYV8_1X16,
+	MEDIA_BUS_FMT_SBGGR8_1X8,
 };
 
 static const unsigned int ipipeif_output_fmts[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_SGRBG12_1X12,
-	V4L2_MBUS_FMT_Y8_1X8,
-	V4L2_MBUS_FMT_UV8_1X8,
-	V4L2_MBUS_FMT_YDYUYDYV8_1X16,
-	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
-	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_Y8_1X8,
+	MEDIA_BUS_FMT_UV8_1X8,
+	MEDIA_BUS_FMT_YDYUYDYV8_1X16,
+	MEDIA_BUS_FMT_SBGGR8_1X8,
+	MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
 };
 
 static int
-ipipeif_get_pack_mode(enum v4l2_mbus_pixelcode in_pix_fmt)
+ipipeif_get_pack_mode(enum media_bus_format in_pix_fmt)
 {
 	switch (in_pix_fmt) {
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
-	case V4L2_MBUS_FMT_Y8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_UV8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_UV8_1X8:
 		return IPIPEIF_5_1_PACK_8_BIT;
 
-	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8:
 		return IPIPEIF_5_1_PACK_8_BIT_A_LAW;
 
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
 		return IPIPEIF_5_1_PACK_16_BIT;
 
-	case V4L2_MBUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
 		return IPIPEIF_5_1_PACK_12_BIT;
 
 	default:
@@ -107,8 +107,8 @@ ipipeif_get_cfg_src1(struct vpfe_ipipeif_device *ipipeif)
 
 	informat = &ipipeif->formats[IPIPEIF_PAD_SINK];
 	if (ipipeif->input == IPIPEIF_INPUT_MEMORY &&
-	   (informat->code == V4L2_MBUS_FMT_Y8_1X8 ||
-	    informat->code == V4L2_MBUS_FMT_UV8_1X8))
+	   (informat->code == MEDIA_BUS_FMT_Y8_1X8 ||
+	    informat->code == MEDIA_BUS_FMT_UV8_1X8))
 		return IPIPEIF_CCDC;
 
 	return IPIPEIF_SRC1_PARALLEL_PORT;
@@ -122,11 +122,11 @@ ipipeif_get_data_shift(struct vpfe_ipipeif_device *ipipeif)
 	informat = &ipipeif->formats[IPIPEIF_PAD_SINK];
 
 	switch (informat->code) {
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
 		return IPIPEIF_5_1_BITS11_0;
 
-	case V4L2_MBUS_FMT_Y8_1X8:
-	case V4L2_MBUS_FMT_UV8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_UV8_1X8:
 		return IPIPEIF_5_1_BITS11_0;
 
 	default:
@@ -143,7 +143,7 @@ ipipeif_get_source(struct vpfe_ipipeif_device *ipipeif)
 	if (ipipeif->input == IPIPEIF_INPUT_ISIF)
 		return IPIPEIF_CCDC;
 
-	if (informat->code == V4L2_MBUS_FMT_UYVY8_2X8)
+	if (informat->code == MEDIA_BUS_FMT_UYVY8_2X8)
 		return IPIPEIF_SDRAM_YUV;
 
 	return IPIPEIF_SDRAM_RAW;
@@ -190,7 +190,7 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 	struct v4l2_mbus_framefmt *informat, *outformat;
 	struct ipipeif_params params = ipipeif->config;
 	enum ipipeif_input_source ipipeif_source;
-	enum v4l2_mbus_pixelcode isif_port_if;
+	enum media_bus_format isif_port_if;
 	void *ipipeif_base_addr;
 	unsigned int val;
 	int data_shift;
@@ -268,16 +268,16 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 	ipipeif_write(val, ipipeif_base_addr, IPIPEIF_INIRSZ);
 	isif_port_if = informat->code;
 
-	if (isif_port_if == V4L2_MBUS_FMT_Y8_1X8)
-		isif_port_if = V4L2_MBUS_FMT_YUYV8_1X16;
-	else if (isif_port_if == V4L2_MBUS_FMT_UV8_1X8)
-		isif_port_if = V4L2_MBUS_FMT_SGRBG12_1X12;
+	if (isif_port_if == MEDIA_BUS_FMT_Y8_1X8)
+		isif_port_if = MEDIA_BUS_FMT_YUYV8_1X16;
+	else if (isif_port_if == MEDIA_BUS_FMT_UV8_1X8)
+		isif_port_if = MEDIA_BUS_FMT_SGRBG12_1X12;
 
 	/* Enable DPCM decompression */
 	switch (ipipeif_source) {
 	case IPIPEIF_SDRAM_RAW:
 		val = 0;
-		if (outformat->code == V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8) {
+		if (outformat->code == MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8) {
 			val = 1;
 			val |= (IPIPEIF_DPCM_8BIT_10BIT & 1) <<
 				IPIPEIF_DPCM_BITS_SHIFT;
@@ -296,9 +296,9 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 		/* configure CFG2 */
 		val = ipipeif_read(ipipeif_base_addr, IPIPEIF_CFG2);
 		switch (isif_port_if) {
-		case V4L2_MBUS_FMT_YUYV8_1X16:
-		case V4L2_MBUS_FMT_UYVY8_2X8:
-		case V4L2_MBUS_FMT_Y8_1X8:
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_Y8_1X8:
 			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
 			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
 			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
@@ -344,16 +344,16 @@ static int ipipeif_hw_setup(struct v4l2_subdev *sd)
 		val |= VPFE_PINPOL_POSITIVE << IPIPEIF_CFG2_VDPOL_SHIFT;
 
 		switch (isif_port_if) {
-		case V4L2_MBUS_FMT_YUYV8_1X16:
-		case V4L2_MBUS_FMT_YUYV10_1X20:
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_YUYV10_1X20:
 			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
 			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
 			break;
 
-		case V4L2_MBUS_FMT_YUYV8_2X8:
-		case V4L2_MBUS_FMT_UYVY8_2X8:
-		case V4L2_MBUS_FMT_Y8_1X8:
-		case V4L2_MBUS_FMT_YUYV10_2X10:
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+		case MEDIA_BUS_FMT_UYVY8_2X8:
+		case MEDIA_BUS_FMT_Y8_1X8:
+		case MEDIA_BUS_FMT_YUYV10_2X10:
 			SETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
 			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
 			val |= IPIPEIF_CBCR_Y << IPIPEIF_CFG2_YUV8P_SHIFT;
@@ -625,7 +625,7 @@ ipipeif_try_format(struct vpfe_ipipeif_device *ipipeif,
 
 		/* If not found, use SBGGR10 as default */
 		if (i >= ARRAY_SIZE(ipipeif_input_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG12_1X12;
+			fmt->code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	} else if (pad == IPIPEIF_PAD_SOURCE) {
 		for (i = 0; i < ARRAY_SIZE(ipipeif_output_fmts); i++)
 			if (fmt->code == ipipeif_output_fmts[i])
@@ -633,7 +633,7 @@ ipipeif_try_format(struct vpfe_ipipeif_device *ipipeif,
 
 		/* If not found, use UYVY as default */
 		if (i >= ARRAY_SIZE(ipipeif_output_fmts))
-			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	}
 
 	fmt->width = clamp_t(u32, fmt->width, MIN_OUT_HEIGHT, max_out_width);
@@ -770,7 +770,7 @@ ipipeif_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPEIF_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
 	ipipeif_set_format(sd, fh, &format);
@@ -778,7 +778,7 @@ ipipeif_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPEIF_PAD_SOURCE;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+	format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
 	ipipeif_set_format(sd, fh, &format);
@@ -805,9 +805,9 @@ ipipeif_video_in_queue(struct vpfe_device *vpfe_dev, unsigned long addr)
 		return -EINVAL;
 
 	switch (ipipeif->formats[IPIPEIF_PAD_SINK].code) {
-	case V4L2_MBUS_FMT_Y8_1X8:
-	case V4L2_MBUS_FMT_UV8_1X8:
-	case V4L2_MBUS_FMT_YDYUYDYV8_1X16:
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_UV8_1X8:
+	case MEDIA_BUS_FMT_YDYUYDYV8_1X16:
 		adofs = ipipeif->formats[IPIPEIF_PAD_SINK].width;
 		break;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 0d535b0..fa26f63 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -27,13 +27,13 @@
 #define MAX_HEIGHT	4096
 
 static const unsigned int isif_fmts[] = {
-	V4L2_MBUS_FMT_YUYV8_2X8,
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_YUYV8_1X16,
-	V4L2_MBUS_FMT_YUYV10_1X20,
-	V4L2_MBUS_FMT_SGRBG12_1X12,
-	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8,
-	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_YUYV8_2X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_YUYV8_1X16,
+	MEDIA_BUS_FMT_YUYV10_1X20,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8,
+	MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
 };
 
 #define ISIF_COLPTN_R_Ye	0x0
@@ -154,7 +154,7 @@ enum v4l2_field vpfe_isif_get_fid(struct vpfe_device *vpfe_dev)
 static int
 isif_set_pixel_format(struct vpfe_isif_device *isif, unsigned int pixfmt)
 {
-	if (isif->formats[ISIF_PAD_SINK].code == V4L2_MBUS_FMT_SGRBG12_1X12) {
+	if (isif->formats[ISIF_PAD_SINK].code == MEDIA_BUS_FMT_SGRBG12_1X12) {
 		if (pixfmt == V4L2_PIX_FMT_SBGGR16)
 			isif->isif_cfg.data_pack = ISIF_PACK_16BIT;
 		else if ((pixfmt == V4L2_PIX_FMT_SGRBG10DPCM8) ||
@@ -184,7 +184,7 @@ static int
 isif_set_frame_format(struct vpfe_isif_device *isif,
 		      enum isif_frmfmt frm_fmt)
 {
-	if (isif->formats[ISIF_PAD_SINK].code == V4L2_MBUS_FMT_SGRBG12_1X12)
+	if (isif->formats[ISIF_PAD_SINK].code == MEDIA_BUS_FMT_SGRBG12_1X12)
 		isif->isif_cfg.bayer.frm_fmt = frm_fmt;
 	else
 		isif->isif_cfg.ycbcr.frm_fmt = frm_fmt;
@@ -196,7 +196,7 @@ static int isif_set_image_window(struct vpfe_isif_device *isif)
 {
 	struct v4l2_rect *win = &isif->crop;
 
-	if (isif->formats[ISIF_PAD_SINK].code == V4L2_MBUS_FMT_SGRBG12_1X12) {
+	if (isif->formats[ISIF_PAD_SINK].code == MEDIA_BUS_FMT_SGRBG12_1X12) {
 		isif->isif_cfg.bayer.win.top = win->top;
 		isif->isif_cfg.bayer.win.left = win->left;
 		isif->isif_cfg.bayer.win.width = win->width;
@@ -214,7 +214,7 @@ static int isif_set_image_window(struct vpfe_isif_device *isif)
 static int
 isif_set_buftype(struct vpfe_isif_device *isif, enum isif_buftype buf_type)
 {
-	if (isif->formats[ISIF_PAD_SINK].code == V4L2_MBUS_FMT_SGRBG12_1X12)
+	if (isif->formats[ISIF_PAD_SINK].code == MEDIA_BUS_FMT_SGRBG12_1X12)
 		isif->isif_cfg.bayer.buf_type = buf_type;
 	else
 		isif->isif_cfg.ycbcr.buf_type = buf_type;
@@ -296,7 +296,7 @@ isif_try_format(struct vpfe_isif_device *isif, struct v4l2_subdev_fh *fh,
 
 	/* If not found, use YUYV8_2x8 as default */
 	if (i >= ARRAY_SIZE(isif_fmts))
-		fmt->format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+		fmt->format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	/* Clamp the size. */
 	fmt->format.width = clamp_t(u32, width, 32, MAX_WIDTH);
@@ -429,7 +429,7 @@ static int isif_get_params(struct v4l2_subdev *sd, void *params)
 	struct vpfe_isif_device *isif = v4l2_get_subdevdata(sd);
 
 	/* only raw module parameters can be set through the IOCTL */
-	if (isif->formats[ISIF_PAD_SINK].code != V4L2_MBUS_FMT_SGRBG12_1X12)
+	if (isif->formats[ISIF_PAD_SINK].code != MEDIA_BUS_FMT_SGRBG12_1X12)
 		return -EINVAL;
 	memcpy(params, &isif->isif_cfg.bayer.config_params,
 			sizeof(isif->isif_cfg.bayer.config_params));
@@ -604,7 +604,7 @@ static int isif_set_params(struct v4l2_subdev *sd, void *params)
 	int ret = -EINVAL;
 
 	/* only raw module parameters can be set through the IOCTL */
-	if (isif->formats[ISIF_PAD_SINK].code != V4L2_MBUS_FMT_SGRBG12_1X12)
+	if (isif->formats[ISIF_PAD_SINK].code != MEDIA_BUS_FMT_SGRBG12_1X12)
 		return ret;
 
 	memcpy(&isif_raw_params, params, sizeof(isif_raw_params));
@@ -1041,19 +1041,19 @@ isif_config_culling(struct vpfe_isif_device *isif, struct vpfe_isif_cul *cul)
 static int isif_get_pix_fmt(u32 mbus_code)
 {
 	switch (mbus_code) {
-	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
 		return ISIF_PIXFMT_RAW;
 
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
-	case V4L2_MBUS_FMT_YUYV10_2X10:
-	case V4L2_MBUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_Y8_1X8:
 		return ISIF_PIXFMT_YCBCR_8BIT;
 
-	case V4L2_MBUS_FMT_YUYV8_1X16:
-	case V4L2_MBUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
 		return ISIF_PIXFMT_YCBCR_16BIT;
 
 	default:
@@ -1121,11 +1121,11 @@ static int isif_config_raw(struct v4l2_subdev *sd, int mode)
 	      ISIF_FRM_FMT_MASK) << ISIF_FRM_FMT_SHIFT) | ((pix_fmt &
 	      ISIF_INPUT_MASK) << ISIF_INPUT_SHIFT);
 
-	/* currently only V4L2_MBUS_FMT_SGRBG12_1X12 is
+	/* currently only MEDIA_BUS_FMT_SGRBG12_1X12 is
 	 * supported. shift appropriately depending on
 	 * different MBUS fmt's added
 	 */
-	if (format->code == V4L2_MBUS_FMT_SGRBG12_1X12)
+	if (format->code == MEDIA_BUS_FMT_SGRBG12_1X12)
 		val |= ((VPFE_ISIF_NO_SHIFT &
 			ISIF_DATASFT_MASK) << ISIF_DATASFT_SHIFT);
 
@@ -1154,7 +1154,7 @@ static int isif_config_raw(struct v4l2_subdev *sd, int mode)
 	/* Configure Gain & Offset */
 	isif_config_gain_offset(isif);
 	/* Configure Color pattern */
-	if (format->code == V4L2_MBUS_FMT_SGRBG12_1X12)
+	if (format->code == MEDIA_BUS_FMT_SGRBG12_1X12)
 		val = isif_sgrbg_pattern;
 	else
 		/* default set to rggb */
@@ -1254,8 +1254,8 @@ static int isif_config_ycbcr(struct v4l2_subdev *sd, int mode)
 		  (((params->vd_pol & ISIF_VD_POL_MASK) << ISIF_VD_POL_SHIFT));
 	/* pack the data to 8-bit CCDCCFG */
 	switch (format->code) {
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		if (pix_fmt != ISIF_PIXFMT_YCBCR_8BIT) {
 			pr_debug("Invalid pix_fmt(input mode)\n");
 			return -EINVAL;
@@ -1266,7 +1266,7 @@ static int isif_config_ycbcr(struct v4l2_subdev *sd, int mode)
 		ccdcfg = ccdcfg | ISIF_PACK_8BIT | ISIF_YCINSWP_YCBCR;
 		break;
 
-	case V4L2_MBUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_YUYV10_2X10:
 		if (pix_fmt != ISIF_PIXFMT_YCBCR_8BIT) {
 			pr_debug("Invalid pix_fmt(input mode)\n");
 			return -EINVAL;
@@ -1278,7 +1278,7 @@ static int isif_config_ycbcr(struct v4l2_subdev *sd, int mode)
 			ISIF_BW656_ENABLE;
 		break;
 
-	case V4L2_MBUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
 		if (pix_fmt != ISIF_PIXFMT_YCBCR_16BIT) {
 			pr_debug("Invalid pix_fmt(input mode)\n");
 			return -EINVAL;
@@ -1286,7 +1286,7 @@ static int isif_config_ycbcr(struct v4l2_subdev *sd, int mode)
 		isif_write(isif->isif_cfg.base_addr, 3, REC656IF);
 		break;
 
-	case V4L2_MBUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
 		ccdcfg |= ISIF_PACK_8BIT;
 		ccdcfg |= ISIF_YCINSWP_YCBCR;
 		if (pix_fmt != ISIF_PIXFMT_YCBCR_8BIT) {
@@ -1295,7 +1295,7 @@ static int isif_config_ycbcr(struct v4l2_subdev *sd, int mode)
 		}
 		break;
 
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		if (pix_fmt != ISIF_PIXFMT_YCBCR_16BIT) {
 			pr_debug("Invalid pix_fmt(input mode)\n");
 			return -EINVAL;
@@ -1313,8 +1313,8 @@ static int isif_config_ycbcr(struct v4l2_subdev *sd, int mode)
 		ISIF_PIX_ORDER_SHIFT;
 	isif_write(isif->isif_cfg.base_addr, ccdcfg, CCDCFG);
 	/* configure video window */
-	if (format->code == V4L2_MBUS_FMT_YUYV10_1X20 ||
-			format->code == V4L2_MBUS_FMT_YUYV8_1X16)
+	if (format->code == MEDIA_BUS_FMT_YUYV10_1X20 ||
+			format->code == MEDIA_BUS_FMT_YUYV8_1X16)
 		isif_setwin(isif, &params->win, params->frm_fmt, 1, mode);
 	else
 		isif_setwin(isif, &params->win, params->frm_fmt, 2, mode);
@@ -1345,17 +1345,17 @@ static int isif_configure(struct v4l2_subdev *sd, int mode)
 	format = &isif->formats[ISIF_PAD_SINK];
 
 	switch (format->code) {
-	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
 		return isif_config_raw(sd, mode);
 
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
-	case V4L2_MBUS_FMT_YUYV10_2X10:
-	case V4L2_MBUS_FMT_Y8_1X8:
-	case V4L2_MBUS_FMT_YUYV8_1X16:
-	case V4L2_MBUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
 		return isif_config_ycbcr(sd, mode);
 
 	default:
@@ -1630,7 +1630,7 @@ isif_init_formats(struct v4l2_subdev *sd,
 	memset(&format, 0, sizeof(format));
 	format.pad = ISIF_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = MAX_WIDTH;
 	format.format.height = MAX_HEIGHT;
 	isif_set_format(sd, fh, &format);
@@ -1638,7 +1638,7 @@ isif_init_formats(struct v4l2_subdev *sd,
 	memset(&format, 0, sizeof(format));
 	format.pad = ISIF_PAD_SOURCE;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = MAX_WIDTH;
 	format.format.height = MAX_HEIGHT;
 	isif_set_format(sd, fh, &format);
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 8828d6c..522f5c9 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -35,18 +35,18 @@
 #define MIN_OUT_HEIGHT		2
 
 static const unsigned int resizer_input_formats[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_Y8_1X8,
-	V4L2_MBUS_FMT_UV8_1X8,
-	V4L2_MBUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_Y8_1X8,
+	MEDIA_BUS_FMT_UV8_1X8,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
 };
 
 static const unsigned int resizer_output_formats[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_Y8_1X8,
-	V4L2_MBUS_FMT_UV8_1X8,
-	V4L2_MBUS_FMT_YDYUYDYV8_1X16,
-	V4L2_MBUS_FMT_SGRBG12_1X12,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_Y8_1X8,
+	MEDIA_BUS_FMT_UV8_1X8,
+	MEDIA_BUS_FMT_YDYUYDYV8_1X16,
+	MEDIA_BUS_FMT_SGRBG12_1X12,
 };
 
 /* resizer_calculate_line_length() - This function calculates the line length of
@@ -54,17 +54,17 @@ static const unsigned int resizer_output_formats[] = {
  *				     output.
  */
 static void
-resizer_calculate_line_length(enum v4l2_mbus_pixelcode pix, int width,
+resizer_calculate_line_length(enum media_bus_format pix, int width,
 		      int height, int *line_len, int *line_len_c)
 {
 	*line_len = 0;
 	*line_len_c = 0;
 
-	if (pix == V4L2_MBUS_FMT_UYVY8_2X8 ||
-	    pix == V4L2_MBUS_FMT_SGRBG12_1X12) {
+	if (pix == MEDIA_BUS_FMT_UYVY8_2X8 ||
+	    pix == MEDIA_BUS_FMT_SGRBG12_1X12) {
 		*line_len = width << 1;
-	} else if (pix == V4L2_MBUS_FMT_Y8_1X8 ||
-		   pix == V4L2_MBUS_FMT_UV8_1X8) {
+	} else if (pix == MEDIA_BUS_FMT_Y8_1X8 ||
+		   pix == MEDIA_BUS_FMT_UV8_1X8) {
 		*line_len = width;
 		*line_len_c = width;
 	} else {
@@ -85,11 +85,11 @@ resizer_validate_output_image_format(struct device *dev,
 				     struct v4l2_mbus_framefmt *format,
 				     int *in_line_len, int *in_line_len_c)
 {
-	if (format->code != V4L2_MBUS_FMT_UYVY8_2X8 &&
-	    format->code != V4L2_MBUS_FMT_Y8_1X8 &&
-	    format->code != V4L2_MBUS_FMT_UV8_1X8 &&
-	    format->code != V4L2_MBUS_FMT_YDYUYDYV8_1X16 &&
-	    format->code != V4L2_MBUS_FMT_SGRBG12_1X12) {
+	if (format->code != MEDIA_BUS_FMT_UYVY8_2X8 &&
+	    format->code != MEDIA_BUS_FMT_Y8_1X8 &&
+	    format->code != MEDIA_BUS_FMT_UV8_1X8 &&
+	    format->code != MEDIA_BUS_FMT_YDYUYDYV8_1X16 &&
+	    format->code != MEDIA_BUS_FMT_SGRBG12_1X12) {
 		dev_err(dev, "Invalid Mbus format, %d\n", format->code);
 		return -EINVAL;
 	}
@@ -281,7 +281,7 @@ resizer_calculate_sdram_offsets(struct vpfe_resizer_device *resizer, int index)
 	param->ext_mem_param[index].c_offset = 0;
 	param->ext_mem_param[index].flip_ofst_y = 0;
 	param->ext_mem_param[index].flip_ofst_c = 0;
-	if (outformat->code == V4L2_MBUS_FMT_YDYUYDYV8_1X16) {
+	if (outformat->code == MEDIA_BUS_FMT_YDYUYDYV8_1X16) {
 		/* YUV 420 */
 		yuv_420 = 1;
 		bytesperpixel = 1;
@@ -322,7 +322,7 @@ static int resizer_configure_output_win(struct vpfe_resizer_device *resizer)
 	outformat = &resizer->resizer_a.formats[RESIZER_PAD_SOURCE];
 
 	output_specs.vst_y = param->user_config.vst;
-	if (outformat->code == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+	if (outformat->code == MEDIA_BUS_FMT_YDYUYDYV8_1X16)
 		output_specs.vst_c = param->user_config.vst;
 
 	configure_resizer_out_params(resizer, RSZ_A, &output_specs, 0, 0);
@@ -336,7 +336,7 @@ static int resizer_configure_output_win(struct vpfe_resizer_device *resizer)
 	if (param->rsz_en[RSZ_B])
 		resizer_calculate_resize_ratios(resizer, RSZ_B);
 
-	if (outformat->code == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+	if (outformat->code == MEDIA_BUS_FMT_YDYUYDYV8_1X16)
 		resizer_enable_422_420_conversion(param, RSZ_A, ENABLE);
 	else
 		resizer_enable_422_420_conversion(param, RSZ_A, DISABLE);
@@ -447,26 +447,26 @@ resizer_configure_common_in_params(struct vpfe_resizer_device *resizer)
 		param->rsz_common.source = IPIPE_DATA;
 
 	switch (informat->code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		param->rsz_common.src_img_fmt = RSZ_IMG_422;
 		param->rsz_common.raw_flip = 0;
 		break;
 
-	case V4L2_MBUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
 		param->rsz_common.src_img_fmt = RSZ_IMG_420;
 		/* Select y */
 		param->rsz_common.y_c = 0;
 		param->rsz_common.raw_flip = 0;
 		break;
 
-	case V4L2_MBUS_FMT_UV8_1X8:
+	case MEDIA_BUS_FMT_UV8_1X8:
 		param->rsz_common.src_img_fmt = RSZ_IMG_420;
 		/* Select y */
 		param->rsz_common.y_c = 1;
 		param->rsz_common.raw_flip = 0;
 		break;
 
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
 		param->rsz_common.raw_flip = 1;
 		break;
 
@@ -519,7 +519,7 @@ resizer_configure_in_continious_mode(struct vpfe_resizer_device *resizer)
 		param->ext_mem_param[RSZ_B].rsz_sdr_oft_c = line_len_c;
 		configure_resizer_out_params(resizer, RSZ_B,
 						&cont_config->output2, 0, 1);
-		if (outformat2->code == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+		if (outformat2->code == MEDIA_BUS_FMT_YDYUYDYV8_1X16)
 			resizer_enable_422_420_conversion(param,
 							  RSZ_B, ENABLE);
 		else
@@ -540,15 +540,15 @@ resizer_configure_in_continious_mode(struct vpfe_resizer_device *resizer)
 
 static inline int
 resizer_validate_input_image_format(struct device *dev,
-				    enum v4l2_mbus_pixelcode pix,
+				    enum media_bus_format pix,
 				    int width, int height, int *line_len)
 {
 	int val;
 
-	if (pix != V4L2_MBUS_FMT_UYVY8_2X8 &&
-	    pix != V4L2_MBUS_FMT_Y8_1X8 &&
-	    pix != V4L2_MBUS_FMT_UV8_1X8 &&
-	    pix != V4L2_MBUS_FMT_SGRBG12_1X12) {
+	if (pix != MEDIA_BUS_FMT_UYVY8_2X8 &&
+	    pix != MEDIA_BUS_FMT_Y8_1X8 &&
+	    pix != MEDIA_BUS_FMT_UV8_1X8 &&
+	    pix != MEDIA_BUS_FMT_SGRBG12_1X12) {
 		dev_err(dev,
 		"resizer validate output: pix format not supported, %d\n", pix);
 		return -EINVAL;
@@ -560,7 +560,7 @@ resizer_validate_input_image_format(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (pix == V4L2_MBUS_FMT_UV8_1X8)
+	if (pix == MEDIA_BUS_FMT_UV8_1X8)
 		resizer_calculate_line_length(pix, width,
 					      height, &val, line_len);
 	else
@@ -709,12 +709,12 @@ resizer_configure_in_single_shot_mode(struct vpfe_resizer_device *resizer)
 		configure_resizer_out_params(resizer, RSZ_A,
 					&param->user_config.output1, 0, 1);
 
-		if (outformat1->code == V4L2_MBUS_FMT_SGRBG12_1X12)
+		if (outformat1->code == MEDIA_BUS_FMT_SGRBG12_1X12)
 			param->rsz_common.raw_flip = 1;
 		else
 			param->rsz_common.raw_flip = 0;
 
-		if (outformat1->code == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+		if (outformat1->code == MEDIA_BUS_FMT_YDYUYDYV8_1X16)
 			resizer_enable_422_420_conversion(param,
 							  RSZ_A, ENABLE);
 		else
@@ -732,7 +732,7 @@ resizer_configure_in_single_shot_mode(struct vpfe_resizer_device *resizer)
 		param->ext_mem_param[RSZ_B].rsz_sdr_oft_c = line_len_c;
 		configure_resizer_out_params(resizer, RSZ_B,
 					&param->user_config.output2, 0, 1);
-		if (outformat2->code == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+		if (outformat2->code == MEDIA_BUS_FMT_YDYUYDYV8_1X16)
 			resizer_enable_422_420_conversion(param,
 							  RSZ_B, ENABLE);
 		else
@@ -745,7 +745,7 @@ resizer_configure_in_single_shot_mode(struct vpfe_resizer_device *resizer)
 		resizer_calculate_resize_ratios(resizer, RSZ_A);
 		resizer_calculate_sdram_offsets(resizer, RSZ_A);
 		/* Overriding resize ratio calculation */
-		if (informat->code == V4L2_MBUS_FMT_UV8_1X8) {
+		if (informat->code == MEDIA_BUS_FMT_UV8_1X8) {
 			param->rsz_rsc_param[RSZ_A].v_dif =
 				(((informat->height + 1) * 2) * 256) /
 				(param->rsz_rsc_param[RSZ_A].o_vsz + 1);
@@ -756,7 +756,7 @@ resizer_configure_in_single_shot_mode(struct vpfe_resizer_device *resizer)
 		resizer_calculate_resize_ratios(resizer, RSZ_B);
 		resizer_calculate_sdram_offsets(resizer, RSZ_B);
 		/* Overriding resize ratio calculation */
-		if (informat->code == V4L2_MBUS_FMT_UV8_1X8) {
+		if (informat->code == MEDIA_BUS_FMT_UV8_1X8) {
 			param->rsz_rsc_param[RSZ_B].v_dif =
 				(((informat->height + 1) * 2) * 256) /
 				(param->rsz_rsc_param[RSZ_B].o_vsz + 1);
@@ -1340,7 +1340,7 @@ resizer_try_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		}
 		/* If not found, use UYVY as default */
 		if (i >= ARRAY_SIZE(resizer_input_formats))
-			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 		fmt->width = clamp_t(u32, fmt->width, MIN_IN_WIDTH,
 					MAX_IN_WIDTH);
@@ -1357,7 +1357,7 @@ resizer_try_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		}
 		/* If not found, use UYVY as default */
 		if (i >= ARRAY_SIZE(resizer_output_formats))
-			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 		fmt->width = clamp_t(u32, fmt->width, MIN_OUT_WIDTH,
 					max_out_width);
@@ -1375,7 +1375,7 @@ resizer_try_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		}
 		/* If not found, use UYVY as default */
 		if (i >= ARRAY_SIZE(resizer_output_formats))
-			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 		fmt->width = clamp_t(u32, fmt->width, MIN_OUT_WIDTH,
 					max_out_width);
@@ -1548,7 +1548,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_CROP_PAD_SINK;
 		format.which = which;
-		format.format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_HEIGHT;
 		resizer_set_format(sd, fh, &format);
@@ -1556,7 +1556,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_CROP_PAD_SOURCE;
 		format.which = which;
-		format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_WIDTH;
 		resizer_set_format(sd, fh, &format);
@@ -1564,7 +1564,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_CROP_PAD_SOURCE2;
 		format.which = which;
-		format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_WIDTH;
 		resizer_set_format(sd, fh, &format);
@@ -1572,7 +1572,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SINK;
 		format.which = which;
-		format.format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_HEIGHT;
 		resizer_set_format(sd, fh, &format);
@@ -1580,7 +1580,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SOURCE;
 		format.which = which;
-		format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 		format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
 		resizer_set_format(sd, fh, &format);
@@ -1588,7 +1588,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SINK;
 		format.which = which;
-		format.format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_HEIGHT;
 		resizer_set_format(sd, fh, &format);
@@ -1596,7 +1596,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SOURCE;
 		format.which = which;
-		format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = IPIPE_MAX_OUTPUT_WIDTH_B;
 		format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_B;
 		resizer_set_format(sd, fh, &format);
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index a862b28..bf45d2c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -99,47 +99,47 @@ void mbus_to_pix(const struct v4l2_mbus_framefmt *mbus,
 			   struct v4l2_pix_format *pix)
 {
 	switch (mbus->code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		pix->pixelformat = V4L2_PIX_FMT_UYVY;
 		pix->bytesperline = pix->width * 2;
 		break;
 
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		pix->pixelformat = V4L2_PIX_FMT_YUYV;
 		pix->bytesperline = pix->width * 2;
 		break;
 
-	case V4L2_MBUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
 		pix->pixelformat = V4L2_PIX_FMT_UYVY;
 		pix->bytesperline = pix->width * 2;
 		break;
 
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
 		pix->pixelformat = V4L2_PIX_FMT_SBGGR16;
 		pix->bytesperline = pix->width * 2;
 		break;
 
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
 		pix->pixelformat = V4L2_PIX_FMT_SGRBG10DPCM8;
 		pix->bytesperline = pix->width;
 		break;
 
-	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8:
 		pix->pixelformat = V4L2_PIX_FMT_SGRBG10ALAW8;
 		pix->bytesperline = pix->width;
 		break;
 
-	case V4L2_MBUS_FMT_YDYUYDYV8_1X16:
+	case MEDIA_BUS_FMT_YDYUYDYV8_1X16:
 		pix->pixelformat = V4L2_PIX_FMT_NV12;
 		pix->bytesperline = pix->width;
 		break;
 
-	case V4L2_MBUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
 		pix->pixelformat = V4L2_PIX_FMT_GREY;
 		pix->bytesperline = pix->width;
 		break;
 
-	case V4L2_MBUS_FMT_UV8_1X8:
+	case MEDIA_BUS_FMT_UV8_1X8:
 		pix->pixelformat = V4L2_PIX_FMT_UV8;
 		pix->bytesperline = pix->width;
 		break;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 92c2d5b..b72e530 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -93,20 +93,20 @@ static void csi2_recv_config(struct iss_csi2_device *csi2,
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
-	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_SGBRG8_1X8,
-	V4L2_MBUS_FMT_SGRBG8_1X8,
-	V4L2_MBUS_FMT_SRGGB8_1X8,
-	V4L2_MBUS_FMT_UYVY8_1X16,
-	V4L2_MBUS_FMT_YUYV8_1X16,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SBGGR10_1X10,
+	MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SGBRG10_1X10,
+	MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8,
+	MEDIA_BUS_FMT_SBGGR8_1X8,
+	MEDIA_BUS_FMT_SGBRG8_1X8,
+	MEDIA_BUS_FMT_SGRBG8_1X8,
+	MEDIA_BUS_FMT_SRGGB8_1X8,
+	MEDIA_BUS_FMT_UYVY8_1X16,
+	MEDIA_BUS_FMT_YUYV8_1X16,
 };
 
 /* To set the format on the CSI2 requires a mapping function that takes
@@ -201,26 +201,26 @@ static u16 csi2_ctx_map_format(struct iss_csi2_device *csi2)
 	int fmtidx, destidx;
 
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
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
-	case V4L2_MBUS_FMT_SGBRG8_1X8:
-	case V4L2_MBUS_FMT_SGRBG8_1X8:
-	case V4L2_MBUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
 		fmtidx = 2;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_1X16:
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		fmtidx = 3;
 		break;
 	default:
@@ -817,7 +817,7 @@ csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
-	enum v4l2_mbus_pixelcode pixelcode;
+	enum media_bus_format pixelcode;
 	struct v4l2_mbus_framefmt *format;
 	const struct iss_format_info *info;
 	unsigned int i;
@@ -832,7 +832,7 @@ csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(csi2_input_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
 		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
 		fmt->height = clamp_t(u32, fmt->height, 1, 8191);
@@ -1020,7 +1020,7 @@ static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = CSI2_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	csi2_set_format(sd, fh, &format);
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index 5404200..a1a46ef 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -28,10 +28,10 @@ __ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
 		  unsigned int pad, enum v4l2_subdev_format_whence which);
 
 static const unsigned int ipipe_fmts[] = {
-	V4L2_MBUS_FMT_SGRBG10_1X10,
-	V4L2_MBUS_FMT_SRGGB10_1X10,
-	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_SGBRG10_1X10,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SBGGR10_1X10,
+	MEDIA_BUS_FMT_SGBRG10_1X10,
 };
 
 /*
@@ -211,7 +211,7 @@ ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(ipipe_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
 		/* Clamp the input size. */
 		fmt->width = clamp_t(u32, width, 1, 8192);
@@ -223,7 +223,7 @@ ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
 		format = __ipipe_get_format(ipipe, fh, IPIPE_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
 
-		fmt->code = V4L2_MBUS_FMT_UYVY8_1X16;
+		fmt->code = MEDIA_BUS_FMT_UYVY8_1X16;
 		fmt->width = clamp_t(u32, width, 32, fmt->width);
 		fmt->height = clamp_t(u32, height, 32, fmt->height);
 		fmt->colorspace = V4L2_COLORSPACE_JPEG;
@@ -257,7 +257,7 @@ static int ipipe_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index != 0)
 			return -EINVAL;
 
-		code->code = V4L2_MBUS_FMT_UYVY8_1X16;
+		code->code = MEDIA_BUS_FMT_UYVY8_1X16;
 		break;
 
 	default:
@@ -385,7 +385,7 @@ static int ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPE_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	ipipe_set_format(sd, fh, &format);
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 75f6a15..32a7483 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -24,12 +24,12 @@
 #include "iss_ipipeif.h"
 
 static const unsigned int ipipeif_fmts[] = {
-	V4L2_MBUS_FMT_SGRBG10_1X10,
-	V4L2_MBUS_FMT_SRGGB10_1X10,
-	V4L2_MBUS_FMT_SBGGR10_1X10,
-	V4L2_MBUS_FMT_SGBRG10_1X10,
-	V4L2_MBUS_FMT_UYVY8_1X16,
-	V4L2_MBUS_FMT_YUYV8_1X16,
+	MEDIA_BUS_FMT_SGRBG10_1X10,
+	MEDIA_BUS_FMT_SRGGB10_1X10,
+	MEDIA_BUS_FMT_SBGGR10_1X10,
+	MEDIA_BUS_FMT_SGBRG10_1X10,
+	MEDIA_BUS_FMT_UYVY8_1X16,
+	MEDIA_BUS_FMT_YUYV8_1X16,
 };
 
 /*
@@ -140,8 +140,8 @@ static void ipipeif_configure(struct iss_ipipeif_device *ipipeif)
 
 	/* Select ISIF/IPIPEIF input format */
 	switch (format->code) {
-	case V4L2_MBUS_FMT_UYVY8_1X16:
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		iss_reg_update(iss, OMAP4_ISS_MEM_ISP_ISIF, ISIF_MODESET,
 			       ISIF_MODESET_CCDMD | ISIF_MODESET_INPMOD_MASK |
 			       ISIF_MODESET_CCDW_MASK,
@@ -151,25 +151,25 @@ static void ipipeif_configure(struct iss_ipipeif_device *ipipeif)
 			       IPIPEIF_CFG2_YUV8, IPIPEIF_CFG2_YUV16);
 
 		break;
-	case V4L2_MBUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
 		isif_ccolp = ISIF_CCOLP_CP0_F0_GR |
 			ISIF_CCOLP_CP1_F0_R |
 			ISIF_CCOLP_CP2_F0_B |
 			ISIF_CCOLP_CP3_F0_GB;
 		goto cont_raw;
-	case V4L2_MBUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
 		isif_ccolp = ISIF_CCOLP_CP0_F0_R |
 			ISIF_CCOLP_CP1_F0_GR |
 			ISIF_CCOLP_CP2_F0_GB |
 			ISIF_CCOLP_CP3_F0_B;
 		goto cont_raw;
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
 		isif_ccolp = ISIF_CCOLP_CP0_F0_B |
 			ISIF_CCOLP_CP1_F0_GB |
 			ISIF_CCOLP_CP2_F0_GR |
 			ISIF_CCOLP_CP3_F0_R;
 		goto cont_raw;
-	case V4L2_MBUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
 		isif_ccolp = ISIF_CCOLP_CP0_F0_GB |
 			ISIF_CCOLP_CP1_F0_B |
 			ISIF_CCOLP_CP2_F0_R |
@@ -415,7 +415,7 @@ ipipeif_try_format(struct iss_ipipeif_device *ipipeif,
 
 		/* If not found, use SGRBG10 as default */
 		if (i >= ARRAY_SIZE(ipipeif_fmts))
-			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+			fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
 		/* Clamp the input size. */
 		fmt->width = clamp_t(u32, width, 1, 8192);
@@ -625,7 +625,7 @@ static int ipipeif_init_formats(struct v4l2_subdev *sd,
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPEIF_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	ipipeif_set_format(sd, fh, &format);
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index a21e356..54be1270 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -24,8 +24,8 @@
 #include "iss_resizer.h"
 
 static const unsigned int resizer_fmts[] = {
-	V4L2_MBUS_FMT_UYVY8_1X16,
-	V4L2_MBUS_FMT_YUYV8_1X16,
+	MEDIA_BUS_FMT_UYVY8_1X16,
+	MEDIA_BUS_FMT_YUYV8_1X16,
 };
 
 /*
@@ -156,8 +156,8 @@ static void resizer_set_outaddr(struct iss_resizer_device *resizer, u32 addr)
 		      addr & 0xffff);
 
 	/* Program UV buffer address... Hardcoded to be contiguous! */
-	if ((informat->code == V4L2_MBUS_FMT_UYVY8_1X16) &&
-	    (outformat->code == V4L2_MBUS_FMT_YUYV8_1_5X8)) {
+	if ((informat->code == MEDIA_BUS_FMT_UYVY8_1X16) &&
+	    (outformat->code == MEDIA_BUS_FMT_YUYV8_1_5X8)) {
 		u32 c_addr = addr + (resizer->video_out.bpl_value *
 				     (outformat->height - 1));
 
@@ -242,8 +242,8 @@ static void resizer_configure(struct iss_resizer_device *resizer)
 		      resizer->video_out.bpl_value);
 
 	/* UYVY -> NV12 conversion */
-	if ((informat->code == V4L2_MBUS_FMT_UYVY8_1X16) &&
-	    (outformat->code == V4L2_MBUS_FMT_YUYV8_1_5X8)) {
+	if ((informat->code == MEDIA_BUS_FMT_UYVY8_1X16) &&
+	    (outformat->code == MEDIA_BUS_FMT_YUYV8_1_5X8)) {
 		iss_reg_write(iss, OMAP4_ISS_MEM_ISP_RESIZER, RZA_420,
 			      RSZ_420_CEN | RSZ_420_YEN);
 
@@ -457,7 +457,7 @@ resizer_try_format(struct iss_resizer_device *resizer,
 		   struct v4l2_mbus_framefmt *fmt,
 		   enum v4l2_subdev_format_whence which)
 {
-	enum v4l2_mbus_pixelcode pixelcode;
+	enum media_bus_format pixelcode;
 	struct v4l2_mbus_framefmt *format;
 	unsigned int width = fmt->width;
 	unsigned int height = fmt->height;
@@ -472,7 +472,7 @@ resizer_try_format(struct iss_resizer_device *resizer,
 
 		/* If not found, use UYVY as default */
 		if (i >= ARRAY_SIZE(resizer_fmts))
-			fmt->code = V4L2_MBUS_FMT_UYVY8_1X16;
+			fmt->code = MEDIA_BUS_FMT_UYVY8_1X16;
 
 		/* Clamp the input size. */
 		fmt->width = clamp_t(u32, width, 1, 8192);
@@ -485,8 +485,8 @@ resizer_try_format(struct iss_resizer_device *resizer,
 					      which);
 		memcpy(fmt, format, sizeof(*fmt));
 
-		if ((pixelcode == V4L2_MBUS_FMT_YUYV8_1_5X8) &&
-		    (fmt->code == V4L2_MBUS_FMT_UYVY8_1X16))
+		if ((pixelcode == MEDIA_BUS_FMT_YUYV8_1_5X8) &&
+		    (fmt->code == MEDIA_BUS_FMT_UYVY8_1X16))
 			fmt->code = pixelcode;
 
 		/* The data formatter truncates the number of horizontal output
@@ -537,9 +537,9 @@ static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
 		}
 
 		switch (format->code) {
-		case V4L2_MBUS_FMT_UYVY8_1X16:
+		case MEDIA_BUS_FMT_UYVY8_1X16:
 			if (code->index == 1)
-				code->code = V4L2_MBUS_FMT_YUYV8_1_5X8;
+				code->code = MEDIA_BUS_FMT_YUYV8_1_5X8;
 			else
 				return -EINVAL;
 			break;
@@ -680,7 +680,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 	memset(&format, 0, sizeof(format));
 	format.pad = RESIZER_PAD_SINK;
 	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
-	format.format.code = V4L2_MBUS_FMT_UYVY8_1X16;
+	format.format.code = MEDIA_BUS_FMT_UYVY8_1X16;
 	format.format.width = 4096;
 	format.format.height = 4096;
 	resizer_set_format(sd, fh, &format);
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 5d62503..01a8b61 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -34,67 +34,67 @@ MODULE_PARM_DESC(debug, "activates debug info");
  */
 
 static struct iss_format_info formats[] = {
-	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
-	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
+	{ MEDIA_BUS_FMT_Y8_1X8, MEDIA_BUS_FMT_Y8_1X8,
+	  MEDIA_BUS_FMT_Y8_1X8, MEDIA_BUS_FMT_Y8_1X8,
 	  V4L2_PIX_FMT_GREY, 8, "Greyscale 8 bpp", },
-	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
-	  V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y8_1X8,
+	{ MEDIA_BUS_FMT_Y10_1X10, MEDIA_BUS_FMT_Y10_1X10,
+	  MEDIA_BUS_FMT_Y10_1X10, MEDIA_BUS_FMT_Y8_1X8,
 	  V4L2_PIX_FMT_Y10, 10, "Greyscale 10 bpp", },
-	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
-	  V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y8_1X8,
+	{ MEDIA_BUS_FMT_Y12_1X12, MEDIA_BUS_FMT_Y10_1X10,
+	  MEDIA_BUS_FMT_Y12_1X12, MEDIA_BUS_FMT_Y8_1X8,
 	  V4L2_PIX_FMT_Y12, 12, "Greyscale 12 bpp", },
-	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
-	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SBGGR8_1X8,
+	  MEDIA_BUS_FMT_SBGGR8_1X8, MEDIA_BUS_FMT_SBGGR8_1X8,
 	  V4L2_PIX_FMT_SBGGR8, 8, "BGGR Bayer 8 bpp", },
-	{ V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
-	  V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_MBUS_FMT_SGBRG8_1X8,
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
+	  MEDIA_BUS_FMT_SGBRG8_1X8, MEDIA_BUS_FMT_SGBRG8_1X8,
 	  V4L2_PIX_FMT_SGBRG8, 8, "GBRG Bayer 8 bpp", },
-	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
-	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SGRBG8_1X8,
+	  MEDIA_BUS_FMT_SGRBG8_1X8, MEDIA_BUS_FMT_SGRBG8_1X8,
 	  V4L2_PIX_FMT_SGRBG8, 8, "GRBG Bayer 8 bpp", },
-	{ V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
-	  V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_MBUS_FMT_SRGGB8_1X8,
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
+	  MEDIA_BUS_FMT_SRGGB8_1X8, MEDIA_BUS_FMT_SRGGB8_1X8,
 	  V4L2_PIX_FMT_SRGGB8, 8, "RGGB Bayer 8 bpp", },
-	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
-	  V4L2_MBUS_FMT_SGRBG10_1X10, 0,
+	{ MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8,
+	  MEDIA_BUS_FMT_SGRBG10_1X10, 0,
 	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, "GRBG Bayer 10 bpp DPCM8",  },
-	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
-	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10,
+	  MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SBGGR8_1X8,
 	  V4L2_PIX_FMT_SBGGR10, 10, "BGGR Bayer 10 bpp", },
-	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
-	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG8_1X8,
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10,
+	  MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SGBRG8_1X8,
 	  V4L2_PIX_FMT_SGBRG10, 10, "GBRG Bayer 10 bpp", },
-	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
-	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG8_1X8,
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10,
+	  MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SGRBG8_1X8,
 	  V4L2_PIX_FMT_SGRBG10, 10, "GRBG Bayer 10 bpp", },
-	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
-	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB8_1X8,
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10,
+	  MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SRGGB8_1X8,
 	  V4L2_PIX_FMT_SRGGB10, 10, "RGGB Bayer 10 bpp", },
-	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
-	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR8_1X8,
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, MEDIA_BUS_FMT_SBGGR10_1X10,
+	  MEDIA_BUS_FMT_SBGGR12_1X12, MEDIA_BUS_FMT_SBGGR8_1X8,
 	  V4L2_PIX_FMT_SBGGR12, 12, "BGGR Bayer 12 bpp", },
-	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
-	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG8_1X8,
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, MEDIA_BUS_FMT_SGBRG10_1X10,
+	  MEDIA_BUS_FMT_SGBRG12_1X12, MEDIA_BUS_FMT_SGBRG8_1X8,
 	  V4L2_PIX_FMT_SGBRG12, 12, "GBRG Bayer 12 bpp", },
-	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
-	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG8_1X8,
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, MEDIA_BUS_FMT_SGRBG10_1X10,
+	  MEDIA_BUS_FMT_SGRBG12_1X12, MEDIA_BUS_FMT_SGRBG8_1X8,
 	  V4L2_PIX_FMT_SGRBG12, 12, "GRBG Bayer 12 bpp", },
-	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
-	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, MEDIA_BUS_FMT_SRGGB10_1X10,
+	  MEDIA_BUS_FMT_SRGGB12_1X12, MEDIA_BUS_FMT_SRGGB8_1X8,
 	  V4L2_PIX_FMT_SRGGB12, 12, "RGGB Bayer 12 bpp", },
-	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
-	  V4L2_MBUS_FMT_UYVY8_1X16, 0,
+	{ MEDIA_BUS_FMT_UYVY8_1X16, MEDIA_BUS_FMT_UYVY8_1X16,
+	  MEDIA_BUS_FMT_UYVY8_1X16, 0,
 	  V4L2_PIX_FMT_UYVY, 16, "YUV 4:2:2 (UYVY)", },
-	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
-	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
+	{ MEDIA_BUS_FMT_YUYV8_1X16, MEDIA_BUS_FMT_YUYV8_1X16,
+	  MEDIA_BUS_FMT_YUYV8_1X16, 0,
 	  V4L2_PIX_FMT_YUYV, 16, "YUV 4:2:2 (YUYV)", },
-	{ V4L2_MBUS_FMT_YUYV8_1_5X8, V4L2_MBUS_FMT_YUYV8_1_5X8,
-	  V4L2_MBUS_FMT_YUYV8_1_5X8, 0,
+	{ MEDIA_BUS_FMT_YUYV8_1_5X8, MEDIA_BUS_FMT_YUYV8_1_5X8,
+	  MEDIA_BUS_FMT_YUYV8_1_5X8, 0,
 	  V4L2_PIX_FMT_NV12, 8, "YUV 4:2:0 (NV12)", },
 };
 
 const struct iss_format_info *
-omap4iss_video_format_info(enum v4l2_mbus_pixelcode code)
+omap4iss_video_format_info(enum media_bus_format code)
 {
 	unsigned int i;
 
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 9dccdb1..cc8146b 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -43,10 +43,10 @@ struct v4l2_pix_format;
  * @description: Human-readable format description
  */
 struct iss_format_info {
-	enum v4l2_mbus_pixelcode code;
-	enum v4l2_mbus_pixelcode truncated;
-	enum v4l2_mbus_pixelcode uncompressed;
-	enum v4l2_mbus_pixelcode flavor;
+	enum media_bus_format code;
+	enum media_bus_format truncated;
+	enum media_bus_format uncompressed;
+	enum media_bus_format flavor;
 	u32 pixelformat;
 	unsigned int bpp;
 	const char *description;
@@ -199,6 +199,6 @@ void omap4iss_video_cancel_stream(struct iss_video *video);
 struct media_pad *omap4iss_video_remote_pad(struct iss_video *video);
 
 const struct iss_format_info *
-omap4iss_video_format_info(enum v4l2_mbus_pixelcode code);
+omap4iss_video_format_info(enum media_bus_format code);
 
 #endif /* OMAP4_ISS_VIDEO_H */
-- 
1.9.1
