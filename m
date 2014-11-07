From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 04/10] [media] i2c: Make use of media_bus_format enum
Date: Fri,  7 Nov 2014 15:07:43 +0100
Message-ID: <1415369269-5064-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definitions to include/uapi/linux/media-bus-format.h and
prefixed values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Replace all references to the old definitions in i2c drivers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/media/i2c/adv7170.c               | 16 +++----
 drivers/media/i2c/adv7175.c               | 16 +++----
 drivers/media/i2c/adv7180.c               |  6 +--
 drivers/media/i2c/adv7183.c               |  6 +--
 drivers/media/i2c/adv7604.c               | 72 +++++++++++++++----------------
 drivers/media/i2c/adv7842.c               |  6 +--
 drivers/media/i2c/ak881x.c                |  8 ++--
 drivers/media/i2c/cx25840/cx25840-core.c  |  2 +-
 drivers/media/i2c/m5mols/m5mols_core.c    |  6 +--
 drivers/media/i2c/ml86v7667.c             |  6 +--
 drivers/media/i2c/mt9m032.c               |  6 +--
 drivers/media/i2c/mt9p031.c               |  8 ++--
 drivers/media/i2c/mt9t001.c               |  8 ++--
 drivers/media/i2c/mt9v011.c               |  6 +--
 drivers/media/i2c/mt9v032.c               | 12 +++---
 drivers/media/i2c/noon010pc30.c           | 12 +++---
 drivers/media/i2c/ov7670.c                | 16 +++----
 drivers/media/i2c/ov9650.c                | 10 ++---
 drivers/media/i2c/s5c73m3/s5c73m3.h       |  6 +--
 drivers/media/i2c/s5k4ecgx.c              |  4 +-
 drivers/media/i2c/s5k5baf.c               | 14 +++---
 drivers/media/i2c/s5k6a3.c                |  2 +-
 drivers/media/i2c/s5k6aa.c                |  8 ++--
 drivers/media/i2c/saa6752hs.c             |  6 +--
 drivers/media/i2c/saa7115.c               |  2 +-
 drivers/media/i2c/saa717x.c               |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c    | 32 +++++++-------
 drivers/media/i2c/soc_camera/imx074.c     |  8 ++--
 drivers/media/i2c/soc_camera/mt9m001.c    | 14 +++---
 drivers/media/i2c/soc_camera/mt9m111.c    | 70 +++++++++++++++---------------
 drivers/media/i2c/soc_camera/mt9t031.c    | 10 ++---
 drivers/media/i2c/soc_camera/mt9t112.c    | 22 +++++-----
 drivers/media/i2c/soc_camera/mt9v022.c    | 26 +++++------
 drivers/media/i2c/soc_camera/ov2640.c     | 54 +++++++++++------------
 drivers/media/i2c/soc_camera/ov5642.c     |  8 ++--
 drivers/media/i2c/soc_camera/ov6650.c     | 58 ++++++++++++-------------
 drivers/media/i2c/soc_camera/ov772x.c     | 20 ++++-----
 drivers/media/i2c/soc_camera/ov9640.c     | 40 ++++++++---------
 drivers/media/i2c/soc_camera/ov9740.c     | 12 +++---
 drivers/media/i2c/soc_camera/rj54n1cb0c.c | 54 +++++++++++------------
 drivers/media/i2c/soc_camera/tw9910.c     | 10 ++---
 drivers/media/i2c/sr030pc30.c             | 14 +++---
 drivers/media/i2c/tvp514x.c               | 12 +++---
 drivers/media/i2c/tvp5150.c               |  6 +--
 drivers/media/i2c/tvp7002.c               | 10 ++---
 drivers/media/i2c/vs6624.c                | 18 ++++----
 46 files changed, 382 insertions(+), 382 deletions(-)

diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index 04bb297..40a1a95 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -63,9 +63,9 @@ static inline struct adv7170 *to_adv7170(struct v4l2_subdev *sd)
 
 static char *inputs[] = { "pass_through", "play_back" };
 
-static enum v4l2_mbus_pixelcode adv7170_codes[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_UYVY8_1X16,
+static u32 adv7170_codes[] = {
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_UYVY8_1X16,
 };
 
 /* ----------------------------------------------------------------------- */
@@ -263,7 +263,7 @@ static int adv7170_s_routing(struct v4l2_subdev *sd,
 }
 
 static int adv7170_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-				enum v4l2_mbus_pixelcode *code)
+				u32 *code)
 {
 	if (index >= ARRAY_SIZE(adv7170_codes))
 		return -EINVAL;
@@ -278,9 +278,9 @@ static int adv7170_g_fmt(struct v4l2_subdev *sd,
 	u8 val = adv7170_read(sd, 0x7);
 
 	if ((val & 0x40) == (1 << 6))
-		mf->code = V4L2_MBUS_FMT_UYVY8_1X16;
+		mf->code = MEDIA_BUS_FMT_UYVY8_1X16;
 	else
-		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 	mf->colorspace  = V4L2_COLORSPACE_SMPTE170M;
 	mf->width       = 0;
@@ -297,11 +297,11 @@ static int adv7170_s_fmt(struct v4l2_subdev *sd,
 	int ret;
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		val &= ~0x40;
 		break;
 
-	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 		val |= 0x40;
 		break;
 
diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index b88f3b3..d220af5 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -60,9 +60,9 @@ static inline struct adv7175 *to_adv7175(struct v4l2_subdev *sd)
 
 static char *inputs[] = { "pass_through", "play_back", "color_bar" };
 
-static enum v4l2_mbus_pixelcode adv7175_codes[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_UYVY8_1X16,
+static u32 adv7175_codes[] = {
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_UYVY8_1X16,
 };
 
 /* ----------------------------------------------------------------------- */
@@ -301,7 +301,7 @@ static int adv7175_s_routing(struct v4l2_subdev *sd,
 }
 
 static int adv7175_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-				enum v4l2_mbus_pixelcode *code)
+				u32 *code)
 {
 	if (index >= ARRAY_SIZE(adv7175_codes))
 		return -EINVAL;
@@ -316,9 +316,9 @@ static int adv7175_g_fmt(struct v4l2_subdev *sd,
 	u8 val = adv7175_read(sd, 0x7);
 
 	if ((val & 0x40) == (1 << 6))
-		mf->code = V4L2_MBUS_FMT_UYVY8_1X16;
+		mf->code = MEDIA_BUS_FMT_UYVY8_1X16;
 	else
-		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
 
 	mf->colorspace  = V4L2_COLORSPACE_SMPTE170M;
 	mf->width       = 0;
@@ -335,11 +335,11 @@ static int adv7175_s_fmt(struct v4l2_subdev *sd,
 	int ret;
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		val &= ~0x40;
 		break;
 
-	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 		val |= 0x40;
 		break;
 
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 821178d..bffe6eb 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -422,12 +422,12 @@ static void adv7180_exit_controls(struct adv7180_state *state)
 }
 
 static int adv7180_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				 enum v4l2_mbus_pixelcode *code)
+				 u32 *code)
 {
 	if (index > 0)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+	*code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	return 0;
 }
@@ -437,7 +437,7 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
 {
 	struct adv7180_state *state = to_state(sd);
 
-	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	fmt->field = V4L2_FIELD_INTERLACED;
 	fmt->width = 720;
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index df461b0..28940cc 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -421,12 +421,12 @@ static int adv7183_g_input_status(struct v4l2_subdev *sd, u32 *status)
 }
 
 static int adv7183_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-				enum v4l2_mbus_pixelcode *code)
+				u32 *code)
 {
 	if (index > 0)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_UYVY8_2X8;
+	*code = MEDIA_BUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
@@ -435,7 +435,7 @@ static int adv7183_try_mbus_fmt(struct v4l2_subdev *sd,
 {
 	struct adv7183 *decoder = to_adv7183(sd);
 
-	fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	if (decoder->std & V4L2_STD_525_60) {
 		fmt->field = V4L2_FIELD_SEQ_TB;
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 47795ff..6cccaca 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -88,7 +88,7 @@ struct adv7604_reg_seq {
 };
 
 struct adv7604_format_info {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	u8 op_ch_sel;
 	bool rgb_out;
 	bool swap_cb_cr;
@@ -749,77 +749,77 @@ static void adv7604_write_reg_seq(struct v4l2_subdev *sd,
  */
 
 static const struct adv7604_format_info adv7604_formats[] = {
-	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
+	{ MEDIA_BUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
 	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YUYV10_2X10, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV10_2X10, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ V4L2_MBUS_FMT_YVYU10_2X10, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU10_2X10, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
+	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
+	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_UYVY10_1X20, ADV7604_OP_CH_SEL_RBG, false, false,
+	{ MEDIA_BUS_FMT_UYVY10_1X20, ADV7604_OP_CH_SEL_RBG, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ V4L2_MBUS_FMT_VYUY10_1X20, ADV7604_OP_CH_SEL_RBG, false, true,
+	{ MEDIA_BUS_FMT_VYUY10_1X20, ADV7604_OP_CH_SEL_RBG, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ V4L2_MBUS_FMT_YUYV10_1X20, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV10_1X20, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ V4L2_MBUS_FMT_YVYU10_1X20, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU10_1X20, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_10BIT },
-	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
+	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
+	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
 };
 
 static const struct adv7604_format_info adv7611_formats[] = {
-	{ V4L2_MBUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
+	{ MEDIA_BUS_FMT_RGB888_1X24, ADV7604_OP_CH_SEL_RGB, true, false,
 	  ADV7604_OP_MODE_SEL_SDR_444 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV8_2X8, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU8_2X8, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV12_2X12, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU12_2X12, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422 | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
+	{ MEDIA_BUS_FMT_UYVY8_1X16, ADV7604_OP_CH_SEL_RBG, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
+	{ MEDIA_BUS_FMT_VYUY8_1X16, ADV7604_OP_CH_SEL_RBG, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV8_1X16, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU8_1X16, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_8BIT },
-	{ V4L2_MBUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
+	{ MEDIA_BUS_FMT_UYVY12_1X24, ADV7604_OP_CH_SEL_RBG, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
+	{ MEDIA_BUS_FMT_VYUY12_1X24, ADV7604_OP_CH_SEL_RBG, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
+	{ MEDIA_BUS_FMT_YUYV12_1X24, ADV7604_OP_CH_SEL_RGB, false, false,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
-	{ V4L2_MBUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
+	{ MEDIA_BUS_FMT_YVYU12_1X24, ADV7604_OP_CH_SEL_RGB, false, true,
 	  ADV7604_OP_MODE_SEL_SDR_422_2X | ADV7604_OP_FORMAT_SEL_12BIT },
 };
 
 static const struct adv7604_format_info *
-adv7604_format_info(struct adv7604_state *state, enum v4l2_mbus_pixelcode code)
+adv7604_format_info(struct adv7604_state *state, u32 code)
 {
 	unsigned int i;
 
@@ -1917,7 +1917,7 @@ static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	info = adv7604_format_info(state, format->format.code);
 	if (info == NULL)
-		info = adv7604_format_info(state, V4L2_MBUS_FMT_YUYV8_2X8);
+		info = adv7604_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
 
 	adv7604_fill_format(state, &format->format);
 	format->format.code = info->code;
@@ -2807,7 +2807,7 @@ static int adv7604_probe(struct i2c_client *client,
 	}
 
 	state->timings = cea640x480;
-	state->format = adv7604_format_info(state, V4L2_MBUS_FMT_YUYV8_2X8);
+	state->format = adv7604_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7604_ops);
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 48b628b..d237250 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1877,12 +1877,12 @@ static int adv7842_s_routing(struct v4l2_subdev *sd,
 }
 
 static int adv7842_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				 enum v4l2_mbus_pixelcode *code)
+				 u32 *code)
 {
 	if (index)
 		return -EINVAL;
 	/* Good enough for now */
-	*code = V4L2_MBUS_FMT_FIXED;
+	*code = MEDIA_BUS_FMT_FIXED;
 	return 0;
 }
 
@@ -1893,7 +1893,7 @@ static int adv7842_g_mbus_fmt(struct v4l2_subdev *sd,
 
 	fmt->width = state->timings.bt.width;
 	fmt->height = state->timings.bt.height;
-	fmt->code = V4L2_MBUS_FMT_FIXED;
+	fmt->code = MEDIA_BUS_FMT_FIXED;
 	fmt->field = V4L2_FIELD_NONE;
 
 	if (state->mode == ADV7842_MODE_SDP) {
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index c14e667..69aeaf3 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -102,7 +102,7 @@ static int ak881x_try_g_mbus_fmt(struct v4l2_subdev *sd,
 	v4l_bound_align_image(&mf->width, 0, 720, 2,
 			      &mf->height, 0, ak881x->lines, 1, 0);
 	mf->field	= V4L2_FIELD_INTERLACED;
-	mf->code	= V4L2_MBUS_FMT_YUYV8_2X8;
+	mf->code	= MEDIA_BUS_FMT_YUYV8_2X8;
 	mf->colorspace	= V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
@@ -112,19 +112,19 @@ static int ak881x_s_mbus_fmt(struct v4l2_subdev *sd,
 			     struct v4l2_mbus_framefmt *mf)
 {
 	if (mf->field != V4L2_FIELD_INTERLACED ||
-	    mf->code != V4L2_MBUS_FMT_YUYV8_2X8)
+	    mf->code != MEDIA_BUS_FMT_YUYV8_2X8)
 		return -EINVAL;
 
 	return ak881x_try_g_mbus_fmt(sd, mf);
 }
 
 static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				enum v4l2_mbus_pixelcode *code)
+				u32 *code)
 {
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+	*code = MEDIA_BUS_FMT_YUYV8_2X8;
 	return 0;
 }
 
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index e453a3f..f29a165 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1373,7 +1373,7 @@ static int cx25840_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 	int HSC, VSC, Vsrc, Hsrc, filter, Vlines;
 	int is_50Hz = !(state->std & V4L2_STD_525_60);
 
-	if (fmt->code != V4L2_MBUS_FMT_FIXED)
+	if (fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 
 	fmt->field = V4L2_FIELD_INTERLACED;
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 8d870b7..2820f7c 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -57,14 +57,14 @@ static struct v4l2_mbus_framefmt m5mols_default_ffmt[M5MOLS_RESTYPE_MAX] = {
 	[M5MOLS_RESTYPE_MONITOR] = {
 		.width		= 1920,
 		.height		= 1080,
-		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.code		= MEDIA_BUS_FMT_VYUY8_2X8,
 		.field		= V4L2_FIELD_NONE,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 	},
 	[M5MOLS_RESTYPE_CAPTURE] = {
 		.width		= 1920,
 		.height		= 1080,
-		.code		= V4L2_MBUS_FMT_JPEG_1X8,
+		.code		= MEDIA_BUS_FMT_JPEG_1X8,
 		.field		= V4L2_FIELD_NONE,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 	},
@@ -479,7 +479,7 @@ static int m5mols_get_version(struct v4l2_subdev *sd)
  * __find_restype - Lookup M-5MOLS resolution type according to pixel code
  * @code: pixel code
  */
-static enum m5mols_restype __find_restype(enum v4l2_mbus_pixelcode code)
+static enum m5mols_restype __find_restype(u32 code)
 {
 	enum m5mols_restype type = M5MOLS_RESTYPE_MONITOR;
 
diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index 2cace73..d730786 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -192,12 +192,12 @@ static int ml86v7667_g_input_status(struct v4l2_subdev *sd, u32 *status)
 }
 
 static int ml86v7667_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
-				   enum v4l2_mbus_pixelcode *code)
+				   u32 *code)
 {
 	if (index > 0)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+	*code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	return 0;
 }
@@ -207,7 +207,7 @@ static int ml86v7667_mbus_fmt(struct v4l2_subdev *sd,
 {
 	struct ml86v7667_priv *priv = to_ml86v7667(sd);
 
-	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	/* The top field is always transferred first by the chip */
 	fmt->field = V4L2_FIELD_INTERLACED_TB;
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 85ec3ba..45b3fca 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -323,7 +323,7 @@ static int mt9m032_enum_mbus_code(struct v4l2_subdev *subdev,
 	if (code->index != 0)
 		return -EINVAL;
 
-	code->code = V4L2_MBUS_FMT_Y8_1X8;
+	code->code = MEDIA_BUS_FMT_Y8_1X8;
 	return 0;
 }
 
@@ -331,7 +331,7 @@ static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
 				   struct v4l2_subdev_fh *fh,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->index != 0 || fse->code != V4L2_MBUS_FMT_Y8_1X8)
+	if (fse->index != 0 || fse->code != MEDIA_BUS_FMT_Y8_1X8)
 		return -EINVAL;
 
 	fse->min_width = MT9M032_COLUMN_SIZE_DEF;
@@ -759,7 +759,7 @@ static int mt9m032_probe(struct i2c_client *client,
 
 	sensor->format.width = sensor->crop.width;
 	sensor->format.height = sensor->crop.height;
-	sensor->format.code = V4L2_MBUS_FMT_Y8_1X8;
+	sensor->format.code = MEDIA_BUS_FMT_Y8_1X8;
 	sensor->format.field = V4L2_FIELD_NONE;
 	sensor->format.colorspace = V4L2_COLORSPACE_SRGB;
 
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e18797f..edb76bd 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -950,9 +950,9 @@ static int mt9p031_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	format = v4l2_subdev_get_try_format(fh, 0);
 
 	if (mt9p031->model == MT9P031_MODEL_MONOCHROME)
-		format->code = V4L2_MBUS_FMT_Y12_1X12;
+		format->code = MEDIA_BUS_FMT_Y12_1X12;
 	else
-		format->code = V4L2_MBUS_FMT_SGRBG12_1X12;
+		format->code = MEDIA_BUS_FMT_SGRBG12_1X12;
 
 	format->width = MT9P031_WINDOW_WIDTH_DEF;
 	format->height = MT9P031_WINDOW_HEIGHT_DEF;
@@ -1120,9 +1120,9 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->crop.top = MT9P031_ROW_START_DEF;
 
 	if (mt9p031->model == MT9P031_MODEL_MONOCHROME)
-		mt9p031->format.code = V4L2_MBUS_FMT_Y12_1X12;
+		mt9p031->format.code = MEDIA_BUS_FMT_Y12_1X12;
 	else
-		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+		mt9p031->format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 
 	mt9p031->format.width = MT9P031_WINDOW_WIDTH_DEF;
 	mt9p031->format.height = MT9P031_WINDOW_HEIGHT_DEF;
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 422e068..d9e9889 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -333,7 +333,7 @@ static int mt9t001_enum_mbus_code(struct v4l2_subdev *subdev,
 	if (code->index > 0)
 		return -EINVAL;
 
-	code->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	return 0;
 }
 
@@ -341,7 +341,7 @@ static int mt9t001_enum_frame_size(struct v4l2_subdev *subdev,
 				   struct v4l2_subdev_fh *fh,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->index >= 8 || fse->code != V4L2_MBUS_FMT_SGRBG10_1X10)
+	if (fse->index >= 8 || fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
 		return -EINVAL;
 
 	fse->min_width = (MT9T001_WINDOW_WIDTH_DEF + 1) / fse->index;
@@ -792,7 +792,7 @@ static int mt9t001_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	crop->height = MT9T001_WINDOW_HEIGHT_DEF + 1;
 
 	format = v4l2_subdev_get_try_format(fh, 0);
-	format->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format->width = MT9T001_WINDOW_WIDTH_DEF + 1;
 	format->height = MT9T001_WINDOW_HEIGHT_DEF + 1;
 	format->field = V4L2_FIELD_NONE;
@@ -917,7 +917,7 @@ static int mt9t001_probe(struct i2c_client *client,
 	mt9t001->crop.width = MT9T001_WINDOW_WIDTH_DEF + 1;
 	mt9t001->crop.height = MT9T001_WINDOW_HEIGHT_DEF + 1;
 
-	mt9t001->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	mt9t001->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	mt9t001->format.width = MT9T001_WINDOW_WIDTH_DEF + 1;
 	mt9t001->format.height = MT9T001_WINDOW_HEIGHT_DEF + 1;
 	mt9t001->format.field = V4L2_FIELD_NONE;
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 47e4753..a10f7f8 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -325,18 +325,18 @@ static int mt9v011_reset(struct v4l2_subdev *sd, u32 val)
 }
 
 static int mt9v011_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					enum v4l2_mbus_pixelcode *code)
+					u32 *code)
 {
 	if (index > 0)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_SGRBG8_1X8;
+	*code = MEDIA_BUS_FMT_SGRBG8_1X8;
 	return 0;
 }
 
 static int mt9v011_try_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
 {
-	if (fmt->code != V4L2_MBUS_FMT_SGRBG8_1X8)
+	if (fmt->code != MEDIA_BUS_FMT_SGRBG8_1X8)
 		return -EINVAL;
 
 	v4l_bound_align_image(&fmt->width, 48, 639, 1,
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index d044bce..93687c1 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -454,7 +454,7 @@ static int mt9v032_enum_mbus_code(struct v4l2_subdev *subdev,
 	if (code->index > 0)
 		return -EINVAL;
 
-	code->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	return 0;
 }
 
@@ -462,7 +462,7 @@ static int mt9v032_enum_frame_size(struct v4l2_subdev *subdev,
 				   struct v4l2_subdev_fh *fh,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
-	if (fse->index >= 3 || fse->code != V4L2_MBUS_FMT_SGRBG10_1X10)
+	if (fse->index >= 3 || fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
 		return -EINVAL;
 
 	fse->min_width = MT9V032_WINDOW_WIDTH_DEF / (1 << fse->index);
@@ -814,9 +814,9 @@ static int mt9v032_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	format = v4l2_subdev_get_try_format(fh, 0);
 
 	if (mt9v032->model->color)
-		format->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		format->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	else
-		format->code = V4L2_MBUS_FMT_Y10_1X10;
+		format->code = MEDIA_BUS_FMT_Y10_1X10;
 
 	format->width = MT9V032_WINDOW_WIDTH_DEF;
 	format->height = MT9V032_WINDOW_HEIGHT_DEF;
@@ -966,9 +966,9 @@ static int mt9v032_probe(struct i2c_client *client,
 	mt9v032->crop.height = MT9V032_WINDOW_HEIGHT_DEF;
 
 	if (mt9v032->model->color)
-		mt9v032->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		mt9v032->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	else
-		mt9v032->format.code = V4L2_MBUS_FMT_Y10_1X10;
+		mt9v032->format.code = MEDIA_BUS_FMT_Y10_1X10;
 
 	mt9v032->format.width = MT9V032_WINDOW_WIDTH_DEF;
 	mt9v032->format.height = MT9V032_WINDOW_HEIGHT_DEF;
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 7eae487..00c7b26 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -112,7 +112,7 @@ MODULE_PARM_DESC(debug, "Enable module debug trace. Set to 1 to enable.");
 #define REG_TERM		0xFFFF
 
 struct noon010_format {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	enum v4l2_colorspace colorspace;
 	u16 ispctl1_reg;
 };
@@ -175,23 +175,23 @@ static const struct noon010_frmsize noon010_sizes[] = {
 /* Supported pixel formats. */
 static const struct noon010_format noon010_formats[] = {
 	{
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x03,
 	}, {
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
+		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x02,
 	}, {
-		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.code		= MEDIA_BUS_FMT_VYUY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0,
 	}, {
-		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x01,
 	}, {
-		.code		= V4L2_MBUS_FMT_RGB565_2X8_BE,
+		.code		= MEDIA_BUS_FMT_RGB565_2X8_BE,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x40,
 	},
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index dd3db24..957927f 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -632,31 +632,31 @@ static int ov7670_detect(struct v4l2_subdev *sd)
  * The magic matrix numbers come from OmniVision.
  */
 static struct ov7670_format_struct {
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 	enum v4l2_colorspace colorspace;
 	struct regval_list *regs;
 	int cmatrix[CMATRIX_LEN];
 } ov7670_formats[] = {
 	{
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.regs 		= ov7670_fmt_yuv422,
 		.cmatrix	= { 128, -128, 0, -34, -94, 128 },
 	},
 	{
-		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
+		.mbus_code	= MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.regs		= ov7670_fmt_rgb444,
 		.cmatrix	= { 179, -179, 0, -61, -176, 228 },
 	},
 	{
-		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.mbus_code	= MEDIA_BUS_FMT_RGB565_2X8_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.regs		= ov7670_fmt_rgb565,
 		.cmatrix	= { 179, -179, 0, -61, -176, 228 },
 	},
 	{
-		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
+		.mbus_code	= MEDIA_BUS_FMT_SBGGR8_1X8,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.regs 		= ov7670_fmt_raw,
 		.cmatrix	= { 0, 0, 0, 0, 0, 0 },
@@ -772,7 +772,7 @@ static void ov7675_get_framerate(struct v4l2_subdev *sd,
 		pll_factor = PLL_FACTOR;
 
 	clkrc++;
-	if (info->fmt->mbus_code == V4L2_MBUS_FMT_SBGGR8_1X8)
+	if (info->fmt->mbus_code == MEDIA_BUS_FMT_SBGGR8_1X8)
 		clkrc = (clkrc >> 1);
 
 	tpf->numerator = 1;
@@ -810,7 +810,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
 	} else {
 		clkrc = (5 * pll_factor * info->clock_speed * tpf->numerator) /
 			(4 * tpf->denominator);
-		if (info->fmt->mbus_code == V4L2_MBUS_FMT_SBGGR8_1X8)
+		if (info->fmt->mbus_code == MEDIA_BUS_FMT_SBGGR8_1X8)
 			clkrc = (clkrc << 1);
 		clkrc--;
 	}
@@ -900,7 +900,7 @@ static int ov7670_set_hw(struct v4l2_subdev *sd, int hstart, int hstop,
 
 
 static int ov7670_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					enum v4l2_mbus_pixelcode *code)
+					u32 *code)
 {
 	if (index >= N_OV7670_FMTS)
 		return -EINVAL;
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 4da90c6..2246bd5 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -384,17 +384,17 @@ static const struct ov965x_framesize ov965x_framesizes[] = {
 };
 
 struct ov965x_pixfmt {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	u32 colorspace;
 	/* REG_TSLB value, only bits [3:2] may be set. */
 	u8 tslb_reg;
 };
 
 static const struct ov965x_pixfmt ov965x_formats[] = {
-	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG, 0x00},
-	{ V4L2_MBUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG, 0x04},
-	{ V4L2_MBUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG, 0x0c},
-	{ V4L2_MBUS_FMT_VYUY8_2X8, V4L2_COLORSPACE_JPEG, 0x08},
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG, 0x00},
+	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG, 0x04},
+	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG, 0x0c},
+	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_COLORSPACE_JPEG, 0x08},
 };
 
 /*
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3.h b/drivers/media/i2c/s5c73m3/s5c73m3.h
index 9656b67..13aed59 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3.h
+++ b/drivers/media/i2c/s5c73m3/s5c73m3.h
@@ -27,8 +27,8 @@
 
 #define DRIVER_NAME			"S5C73M3"
 
-#define S5C73M3_ISP_FMT			V4L2_MBUS_FMT_VYUY8_2X8
-#define S5C73M3_JPEG_FMT		V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8
+#define S5C73M3_ISP_FMT			MEDIA_BUS_FMT_VYUY8_2X8
+#define S5C73M3_JPEG_FMT		MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8
 
 /* Subdevs pad index definitions */
 enum s5c73m3_pads {
@@ -402,7 +402,7 @@ struct s5c73m3 {
 
 	const struct s5c73m3_frame_size *sensor_pix_size[2];
 	const struct s5c73m3_frame_size *oif_pix_size[2];
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 
 	const struct s5c73m3_interval *fiv;
 
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 1fcc76f..d1c50c9 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -151,7 +151,7 @@ static const struct s5k4ecgx_frmsize s5k4ecgx_prev_sizes[] = {
 #define S5K4ECGX_NUM_PREV ARRAY_SIZE(s5k4ecgx_prev_sizes)
 
 struct s5k4ecgx_pixfmt {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	u32 colorspace;
 	/* REG_TC_PCFG_Format register value */
 	u16 reg_p_format;
@@ -159,7 +159,7 @@ struct s5k4ecgx_pixfmt {
 
 /* By default value, output from sensor will be YUV422 0-255 */
 static const struct s5k4ecgx_pixfmt s5k4ecgx_formats[] = {
-	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG, 5 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG, 5 },
 };
 
 static const char * const s5k4ecgx_supply_names[] = {
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 0e461a6..60a74d8 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -248,7 +248,7 @@ enum s5k5baf_gpio_id {
 #define NUM_ISP_PADS 2
 
 struct s5k5baf_pixfmt {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	u32 colorspace;
 	/* REG_P_FMT(x) register value */
 	u16 reg_p_fmt;
@@ -331,10 +331,10 @@ struct s5k5baf {
 };
 
 static const struct s5k5baf_pixfmt s5k5baf_formats[] = {
-	{ V4L2_MBUS_FMT_VYUY8_2X8,	V4L2_COLORSPACE_JPEG,	5 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8,	V4L2_COLORSPACE_JPEG,	5 },
 	/* range 16-240 */
-	{ V4L2_MBUS_FMT_VYUY8_2X8,	V4L2_COLORSPACE_REC709,	6 },
-	{ V4L2_MBUS_FMT_RGB565_2X8_BE,	V4L2_COLORSPACE_JPEG,	0 },
+	{ MEDIA_BUS_FMT_VYUY8_2X8,	V4L2_COLORSPACE_REC709,	6 },
+	{ MEDIA_BUS_FMT_RGB565_2X8_BE,	V4L2_COLORSPACE_JPEG,	0 },
 };
 
 static struct v4l2_rect s5k5baf_cis_rect = {
@@ -1206,7 +1206,7 @@ static int s5k5baf_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->pad == PAD_CIS) {
 		if (code->index > 0)
 			return -EINVAL;
-		code->code = V4L2_MBUS_FMT_FIXED;
+		code->code = MEDIA_BUS_FMT_FIXED;
 		return 0;
 	}
 
@@ -1227,7 +1227,7 @@ static int s5k5baf_enum_frame_size(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	if (fse->pad == PAD_CIS) {
-		fse->code = V4L2_MBUS_FMT_FIXED;
+		fse->code = MEDIA_BUS_FMT_FIXED;
 		fse->min_width = S5K5BAF_CIS_WIDTH;
 		fse->max_width = S5K5BAF_CIS_WIDTH;
 		fse->min_height = S5K5BAF_CIS_HEIGHT;
@@ -1252,7 +1252,7 @@ static void s5k5baf_try_cis_format(struct v4l2_mbus_framefmt *mf)
 {
 	mf->width = S5K5BAF_CIS_WIDTH;
 	mf->height = S5K5BAF_CIS_HEIGHT;
-	mf->code = V4L2_MBUS_FMT_FIXED;
+	mf->code = MEDIA_BUS_FMT_FIXED;
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 	mf->field = V4L2_FIELD_NONE;
 }
diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index c11a408..91b841a 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -80,7 +80,7 @@ static inline struct s5k6a3 *sd_to_s5k6a3(struct v4l2_subdev *sd)
 
 static const struct v4l2_mbus_framefmt s5k6a3_formats[] = {
 	{
-		.code = V4L2_MBUS_FMT_SGRBG10_1X10,
+		.code = MEDIA_BUS_FMT_SGRBG10_1X10,
 		.colorspace = V4L2_COLORSPACE_SRGB,
 		.field = V4L2_FIELD_NONE,
 	}
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 629a5cd..2851581 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -191,7 +191,7 @@ struct s5k6aa_regval {
 };
 
 struct s5k6aa_pixfmt {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	u32 colorspace;
 	/* REG_P_FMT(x) register value */
 	u16 reg_p_fmt;
@@ -285,10 +285,10 @@ static struct s5k6aa_regval s5k6aa_analog_config[] = {
 
 /* TODO: Add RGB888 and Bayer format */
 static const struct s5k6aa_pixfmt s5k6aa_formats[] = {
-	{ V4L2_MBUS_FMT_YUYV8_2X8,	V4L2_COLORSPACE_JPEG,	5 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8,	V4L2_COLORSPACE_JPEG,	5 },
 	/* range 16-240 */
-	{ V4L2_MBUS_FMT_YUYV8_2X8,	V4L2_COLORSPACE_REC709,	6 },
-	{ V4L2_MBUS_FMT_RGB565_2X8_BE,	V4L2_COLORSPACE_JPEG,	0 },
+	{ MEDIA_BUS_FMT_YUYV8_2X8,	V4L2_COLORSPACE_REC709,	6 },
+	{ MEDIA_BUS_FMT_RGB565_2X8_BE,	V4L2_COLORSPACE_JPEG,	0 },
 };
 
 static const struct s5k6aa_interval s5k6aa_intervals[] = {
diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
index 4024ea6..f14c0e6 100644
--- a/drivers/media/i2c/saa6752hs.c
+++ b/drivers/media/i2c/saa6752hs.c
@@ -562,7 +562,7 @@ static int saa6752hs_g_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefm
 		h->video_format = SAA6752HS_VF_D1;
 	f->width = v4l2_format_table[h->video_format].fmt.pix.width;
 	f->height = v4l2_format_table[h->video_format].fmt.pix.height;
-	f->code = V4L2_MBUS_FMT_FIXED;
+	f->code = MEDIA_BUS_FMT_FIXED;
 	f->field = V4L2_FIELD_INTERLACED;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	return 0;
@@ -572,7 +572,7 @@ static int saa6752hs_try_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_frame
 {
 	int dist_352, dist_480, dist_720;
 
-	f->code = V4L2_MBUS_FMT_FIXED;
+	f->code = MEDIA_BUS_FMT_FIXED;
 
 	dist_352 = abs(f->width - 352);
 	dist_480 = abs(f->width - 480);
@@ -599,7 +599,7 @@ static int saa6752hs_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefm
 {
 	struct saa6752hs_state *h = to_state(sd);
 
-	if (f->code != V4L2_MBUS_FMT_FIXED)
+	if (f->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 
 	/*
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 35a4464..7147c8b 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1172,7 +1172,7 @@ static int saa711x_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_f
 
 static int saa711x_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
 {
-	if (fmt->code != V4L2_MBUS_FMT_FIXED)
+	if (fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 	fmt->field = V4L2_FIELD_INTERLACED;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 6922a9f..0d0f9a9 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -998,7 +998,7 @@ static int saa717x_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 
 	v4l2_dbg(1, debug, sd, "decoder set size\n");
 
-	if (fmt->code != V4L2_MBUS_FMT_FIXED)
+	if (fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 
 	/* FIXME need better bounds checking here */
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 932ed9b..82d2e0a 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -333,22 +333,22 @@ static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
  *    orders must be defined.
  */
 static const struct smiapp_csi_data_format smiapp_csi_data_formats[] = {
-	{ V4L2_MBUS_FMT_SGRBG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GRBG, },
-	{ V4L2_MBUS_FMT_SRGGB12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_RGGB, },
-	{ V4L2_MBUS_FMT_SBGGR12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_BGGR, },
-	{ V4L2_MBUS_FMT_SGBRG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GBRG, },
-	{ V4L2_MBUS_FMT_SGRBG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GRBG, },
-	{ V4L2_MBUS_FMT_SRGGB10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_RGGB, },
-	{ V4L2_MBUS_FMT_SBGGR10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_BGGR, },
-	{ V4L2_MBUS_FMT_SGBRG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GBRG, },
-	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GRBG, },
-	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_RGGB, },
-	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_BGGR, },
-	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GBRG, },
-	{ V4L2_MBUS_FMT_SGRBG8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_GRBG, },
-	{ V4L2_MBUS_FMT_SRGGB8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_RGGB, },
-	{ V4L2_MBUS_FMT_SBGGR8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_BGGR, },
-	{ V4L2_MBUS_FMT_SGBRG8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ MEDIA_BUS_FMT_SGRBG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ MEDIA_BUS_FMT_SRGGB12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ MEDIA_BUS_FMT_SBGGR12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ MEDIA_BUS_FMT_SGBRG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ MEDIA_BUS_FMT_SGRBG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ MEDIA_BUS_FMT_SRGGB10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ MEDIA_BUS_FMT_SBGGR10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ MEDIA_BUS_FMT_SGBRG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ MEDIA_BUS_FMT_SGRBG8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ MEDIA_BUS_FMT_SRGGB8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ MEDIA_BUS_FMT_SBGGR8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ MEDIA_BUS_FMT_SGBRG8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_GBRG, },
 };
 
 const char *pixel_order_str[] = { "GRBG", "RGGB", "BGGR", "GBRG" };
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index 5b91593..ec89cfa 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -71,7 +71,7 @@
 
 /* IMX074 has only one fixed colorspace per pixelcode */
 struct imx074_datafmt {
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	enum v4l2_colorspace		colorspace;
 };
 
@@ -82,7 +82,7 @@ struct imx074 {
 };
 
 static const struct imx074_datafmt imx074_colour_fmts[] = {
-	{V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
 };
 
 static struct imx074 *to_imx074(const struct i2c_client *client)
@@ -91,7 +91,7 @@ static struct imx074 *to_imx074(const struct i2c_client *client)
 }
 
 /* Find a data format by a pixel code in an array */
-static const struct imx074_datafmt *imx074_find_datafmt(enum v4l2_mbus_pixelcode code)
+static const struct imx074_datafmt *imx074_find_datafmt(u32 code)
 {
 	int i;
 
@@ -236,7 +236,7 @@ static int imx074_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 }
 
 static int imx074_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if ((unsigned int)index >= ARRAY_SIZE(imx074_colour_fmts))
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index dbd8c14..2e9a535 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -53,13 +53,13 @@
 
 /* MT9M001 has only one fixed colorspace per pixelcode */
 struct mt9m001_datafmt {
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	enum v4l2_colorspace		colorspace;
 };
 
 /* Find a data format by a pixel code in an array */
 static const struct mt9m001_datafmt *mt9m001_find_datafmt(
-	enum v4l2_mbus_pixelcode code, const struct mt9m001_datafmt *fmt,
+	u32 code, const struct mt9m001_datafmt *fmt,
 	int n)
 {
 	int i;
@@ -75,14 +75,14 @@ static const struct mt9m001_datafmt mt9m001_colour_fmts[] = {
 	 * Order important: first natively supported,
 	 * second supported with a GPIO extender
 	 */
-	{V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
 };
 
 static const struct mt9m001_datafmt mt9m001_monochrome_fmts[] = {
 	/* Order important - see above */
-	{V4L2_MBUS_FMT_Y10_1X10, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_Y10_1X10, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
 };
 
 struct mt9m001 {
@@ -563,7 +563,7 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 };
 
 static int mt9m001_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    enum v4l2_mbus_pixelcode *code)
+			    u32 *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index b51e856..5992ea9 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -182,23 +182,23 @@ static struct mt9m111_context context_b = {
 
 /* MT9M111 has only one fixed colorspace per pixelcode */
 struct mt9m111_datafmt {
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	enum v4l2_colorspace		colorspace;
 };
 
 static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
-	{V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_VYUY8_2X8, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_BGR565_2X8_LE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_BGR565_2X8_BE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_VYUY8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_BGR565_2X8_LE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_BGR565_2X8_BE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
 };
 
 struct mt9m111 {
@@ -218,7 +218,7 @@ struct mt9m111 {
 
 /* Find a data format by a pixel code */
 static const struct mt9m111_datafmt *mt9m111_find_datafmt(struct mt9m111 *mt9m111,
-						enum v4l2_mbus_pixelcode code)
+						u32 code)
 {
 	int i;
 	for (i = 0; i < ARRAY_SIZE(mt9m111_colour_fmts); i++)
@@ -331,7 +331,7 @@ static int mt9m111_setup_rect_ctx(struct mt9m111 *mt9m111,
 }
 
 static int mt9m111_setup_geometry(struct mt9m111 *mt9m111, struct v4l2_rect *rect,
-			int width, int height, enum v4l2_mbus_pixelcode code)
+			int width, int height, u32 code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
@@ -345,7 +345,7 @@ static int mt9m111_setup_geometry(struct mt9m111 *mt9m111, struct v4l2_rect *rec
 	if (!ret)
 		ret = reg_write(WINDOW_HEIGHT, rect->height);
 
-	if (code != V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
+	if (code != MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* IFP in use, down-scaling possible */
 		if (!ret)
 			ret = mt9m111_setup_rect_ctx(mt9m111, &context_b,
@@ -393,8 +393,8 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
+	if (mt9m111->fmt->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
+	    mt9m111->fmt->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* Bayer format - even size lengths */
 		rect.width	= ALIGN(rect.width, 2);
 		rect.height	= ALIGN(rect.height, 2);
@@ -462,7 +462,7 @@ static int mt9m111_g_fmt(struct v4l2_subdev *sd,
 }
 
 static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
-			      enum v4l2_mbus_pixelcode code)
+			      u32 code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	u16 data_outfmt2, mask_outfmt2 = MT9M111_OUTFMT_PROCESSED_BAYER |
@@ -474,46 +474,46 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 	int ret;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
 		data_outfmt2 = MT9M111_OUTFMT_PROCESSED_BAYER |
 			MT9M111_OUTFMT_RGB;
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE:
 		data_outfmt2 = MT9M111_OUTFMT_BYPASS_IFP | MT9M111_OUTFMT_RGB;
 		break;
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
 		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB555 |
 			MT9M111_OUTFMT_SWAP_YCbCr_C_Y_RGB_EVEN;
 		break;
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
 		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB555;
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565 |
 			MT9M111_OUTFMT_SWAP_YCbCr_C_Y_RGB_EVEN;
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565;
 		break;
-	case V4L2_MBUS_FMT_BGR565_2X8_BE:
+	case MEDIA_BUS_FMT_BGR565_2X8_BE:
 		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565 |
 			MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr_RGB_R_B;
 		break;
-	case V4L2_MBUS_FMT_BGR565_2X8_LE:
+	case MEDIA_BUS_FMT_BGR565_2X8_LE:
 		data_outfmt2 = MT9M111_OUTFMT_RGB | MT9M111_OUTFMT_RGB565 |
 			MT9M111_OUTFMT_SWAP_YCbCr_C_Y_RGB_EVEN |
 			MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr_RGB_R_B;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		data_outfmt2 = 0;
 		break;
-	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
 		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr_RGB_R_B;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_C_Y_RGB_EVEN;
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
 		data_outfmt2 = MT9M111_OUTFMT_SWAP_YCbCr_C_Y_RGB_EVEN |
 			MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr_RGB_R_B;
 		break;
@@ -542,8 +542,8 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 
 	fmt = mt9m111_find_datafmt(mt9m111, mf->code);
 
-	bayer = fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-		fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE;
+	bayer = fmt->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
+		fmt->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE;
 
 	/*
 	 * With Bayer format enforce even side lengths, but let the user play
@@ -554,7 +554,7 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
 		rect->height = ALIGN(rect->height, 2);
 	}
 
-	if (fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
+	if (fmt->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE) {
 		/* IFP bypass mode, no scaling */
 		mf->width = rect->width;
 		mf->height = rect->height;
@@ -840,7 +840,7 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 };
 
 static int mt9m111_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    enum v4l2_mbus_pixelcode *code)
+			    u32 *code)
 {
 	if (index >= ARRAY_SIZE(mt9m111_colour_fmts))
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index f8358c4..35d9c8d 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -345,7 +345,7 @@ static int mt9t031_g_fmt(struct v4l2_subdev *sd,
 
 	mf->width	= mt9t031->rect.width / mt9t031->xskip;
 	mf->height	= mt9t031->rect.height / mt9t031->yskip;
-	mf->code	= V4L2_MBUS_FMT_SBGGR10_1X10;
+	mf->code	= MEDIA_BUS_FMT_SBGGR10_1X10;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
 
@@ -367,7 +367,7 @@ static int mt9t031_s_fmt(struct v4l2_subdev *sd,
 	xskip = mt9t031_skip(&rect.width, mf->width, MT9T031_MAX_WIDTH);
 	yskip = mt9t031_skip(&rect.height, mf->height, MT9T031_MAX_HEIGHT);
 
-	mf->code	= V4L2_MBUS_FMT_SBGGR10_1X10;
+	mf->code	= MEDIA_BUS_FMT_SBGGR10_1X10;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 
 	/* mt9t031_set_params() doesn't change width and height */
@@ -385,7 +385,7 @@ static int mt9t031_try_fmt(struct v4l2_subdev *sd,
 		&mf->width, MT9T031_MIN_WIDTH, MT9T031_MAX_WIDTH, 1,
 		&mf->height, MT9T031_MIN_HEIGHT, MT9T031_MAX_HEIGHT, 1, 0);
 
-	mf->code	= V4L2_MBUS_FMT_SBGGR10_1X10;
+	mf->code	= MEDIA_BUS_FMT_SBGGR10_1X10;
 	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 
 	return 0;
@@ -673,12 +673,12 @@ static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
 };
 
 static int mt9t031_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    enum v4l2_mbus_pixelcode *code)
+			    u32 *code)
 {
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_SBGGR10_1X10;
+	*code = MEDIA_BUS_FMT_SBGGR10_1X10;
 	return 0;
 }
 
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 996d7b4..64f0836 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -77,7 +77,7 @@
 			struct
 ************************************************************************/
 struct mt9t112_format {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	enum v4l2_colorspace colorspace;
 	u16 fmt;
 	u16 order;
@@ -103,32 +103,32 @@ struct mt9t112_priv {
 
 static const struct mt9t112_format mt9t112_cfmts[] = {
 	{
-		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 0,
 	}, {
-		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.code		= MEDIA_BUS_FMT_VYUY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 1,
 	}, {
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 2,
 	}, {
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
+		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 3,
 	}, {
-		.code		= V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+		.code		= MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.fmt		= 8,
 		.order		= 2,
 	}, {
-		.code		= V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.code		= MEDIA_BUS_FMT_RGB565_2X8_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.fmt		= 4,
 		.order		= 2,
@@ -840,7 +840,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 
 static int mt9t112_set_params(struct mt9t112_priv *priv,
 			      const struct v4l2_rect *rect,
-			      enum v4l2_mbus_pixelcode code)
+			      u32 code)
 {
 	int i;
 
@@ -953,7 +953,7 @@ static int mt9t112_try_fmt(struct v4l2_subdev *sd,
 			break;
 
 	if (i == priv->num_formats) {
-		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	} else {
 		mf->colorspace	= mt9t112_cfmts[i].colorspace;
@@ -967,7 +967,7 @@ static int mt9t112_try_fmt(struct v4l2_subdev *sd,
 }
 
 static int mt9t112_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
@@ -1101,7 +1101,7 @@ static int mt9t112_probe(struct i2c_client *client,
 
 	/* Cannot fail: using the default supported pixel code */
 	if (!ret)
-		mt9t112_set_params(priv, &rect, V4L2_MBUS_FMT_UYVY8_2X8);
+		mt9t112_set_params(priv, &rect, MEDIA_BUS_FMT_UYVY8_2X8);
 	else
 		v4l2_clk_put(priv->clk);
 
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 99022c8..a246d4d 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -85,13 +85,13 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 
 /* MT9V022 has only one fixed colorspace per pixelcode */
 struct mt9v022_datafmt {
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	enum v4l2_colorspace		colorspace;
 };
 
 /* Find a data format by a pixel code in an array */
 static const struct mt9v022_datafmt *mt9v022_find_datafmt(
-	enum v4l2_mbus_pixelcode code, const struct mt9v022_datafmt *fmt,
+	u32 code, const struct mt9v022_datafmt *fmt,
 	int n)
 {
 	int i;
@@ -107,14 +107,14 @@ static const struct mt9v022_datafmt mt9v022_colour_fmts[] = {
 	 * Order important: first natively supported,
 	 * second supported with a GPIO extender
 	 */
-	{V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
 };
 
 static const struct mt9v022_datafmt mt9v022_monochrome_fmts[] = {
 	/* Order important - see above */
-	{V4L2_MBUS_FMT_Y10_1X10, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_Y10_1X10, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
 };
 
 /* only registers with different addresses on different mt9v02x sensors */
@@ -410,13 +410,13 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
 	 * .try_mbus_fmt(), datawidth is from our supported format list
 	 */
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_Y8_1X8:
-	case V4L2_MBUS_FMT_Y10_1X10:
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_Y10_1X10:
 		if (mt9v022->model != MT9V022IX7ATM)
 			return -EINVAL;
 		break;
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
 		if (mt9v022->model != MT9V022IX7ATC)
 			return -EINVAL;
 		break;
@@ -443,8 +443,8 @@ static int mt9v022_try_fmt(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	const struct mt9v022_datafmt *fmt;
-	int align = mf->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
-		mf->code == V4L2_MBUS_FMT_SBGGR10_1X10;
+	int align = mf->code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
+		mf->code == MEDIA_BUS_FMT_SBGGR10_1X10;
 
 	v4l_bound_align_image(&mf->width, MT9V022_MIN_WIDTH,
 		MT9V022_MAX_WIDTH, align,
@@ -759,7 +759,7 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
 };
 
 static int mt9v022_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			    enum v4l2_mbus_pixelcode *code)
+			    u32 *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 6c6b1c3..6f2dd90 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -302,7 +302,7 @@ struct ov2640_win_size {
 struct ov2640_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
-	enum v4l2_mbus_pixelcode	cfmt_code;
+	u32	cfmt_code;
 	struct v4l2_clk			*clk;
 	const struct ov2640_win_size	*win;
 };
@@ -623,11 +623,11 @@ static const struct regval_list ov2640_rgb565_le_regs[] = {
 	ENDMARKER,
 };
 
-static enum v4l2_mbus_pixelcode ov2640_codes[] = {
-	V4L2_MBUS_FMT_YUYV8_2X8,
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_RGB565_2X8_BE,
-	V4L2_MBUS_FMT_RGB565_2X8_LE,
+static u32 ov2640_codes[] = {
+	MEDIA_BUS_FMT_YUYV8_2X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_RGB565_2X8_BE,
+	MEDIA_BUS_FMT_RGB565_2X8_LE,
 };
 
 /*
@@ -785,7 +785,7 @@ static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
 }
 
 static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
-			     enum v4l2_mbus_pixelcode code)
+			     u32 code)
 {
 	struct ov2640_priv       *priv = to_ov2640(client);
 	const struct regval_list *selected_cfmt_regs;
@@ -797,20 +797,20 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
 	/* select format */
 	priv->cfmt_code = 0;
 	switch (code) {
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		dev_dbg(&client->dev, "%s: Selected cfmt RGB565 BE", __func__);
 		selected_cfmt_regs = ov2640_rgb565_be_regs;
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		dev_dbg(&client->dev, "%s: Selected cfmt RGB565 LE", __func__);
 		selected_cfmt_regs = ov2640_rgb565_le_regs;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		dev_dbg(&client->dev, "%s: Selected cfmt YUYV (YUV422)", __func__);
 		selected_cfmt_regs = ov2640_yuyv_regs;
 		break;
 	default:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		dev_dbg(&client->dev, "%s: Selected cfmt UYVY", __func__);
 		selected_cfmt_regs = ov2640_uyvy_regs;
 	}
@@ -869,7 +869,7 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
 	if (!priv->win) {
 		u32 width = W_SVGA, height = H_SVGA;
 		priv->win = ov2640_select_win(&width, &height);
-		priv->cfmt_code = V4L2_MBUS_FMT_UYVY8_2X8;
+		priv->cfmt_code = MEDIA_BUS_FMT_UYVY8_2X8;
 	}
 
 	mf->width	= priv->win->width;
@@ -877,13 +877,13 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
 	mf->code	= priv->cfmt_code;
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
 	mf->field	= V4L2_FIELD_NONE;
@@ -899,14 +899,14 @@ static int ov2640_s_fmt(struct v4l2_subdev *sd,
 
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
-		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
 
@@ -926,14 +926,14 @@ static int ov2640_try_fmt(struct v4l2_subdev *sd,
 	mf->field	= V4L2_FIELD_NONE;
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
-		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
 
@@ -941,7 +941,7 @@ static int ov2640_try_fmt(struct v4l2_subdev *sd,
 }
 
 static int ov2640_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index >= ARRAY_SIZE(ov2640_codes))
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index d2daa6a..93ae031 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -602,7 +602,7 @@ static struct regval_list ov5642_default_regs_finalise[] = {
 };
 
 struct ov5642_datafmt {
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	enum v4l2_colorspace		colorspace;
 };
 
@@ -618,7 +618,7 @@ struct ov5642 {
 };
 
 static const struct ov5642_datafmt ov5642_colour_fmts[] = {
-	{V4L2_MBUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG},
 };
 
 static struct ov5642 *to_ov5642(const struct i2c_client *client)
@@ -628,7 +628,7 @@ static struct ov5642 *to_ov5642(const struct i2c_client *client)
 
 /* Find a data format by a pixel code in an array */
 static const struct ov5642_datafmt
-			*ov5642_find_datafmt(enum v4l2_mbus_pixelcode code)
+			*ov5642_find_datafmt(u32 code)
 {
 	int i;
 
@@ -840,7 +840,7 @@ static int ov5642_g_fmt(struct v4l2_subdev *sd,
 }
 
 static int ov5642_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index >= ARRAY_SIZE(ov5642_colour_fmts))
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index ab01598..f4eef2f 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -202,18 +202,18 @@ struct ov6650 {
 	unsigned long		pclk_limit;	/* from host */
 	unsigned long		pclk_max;	/* from resolution and format */
 	struct v4l2_fract	tpf;		/* as requested with s_parm */
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	enum v4l2_colorspace	colorspace;
 };
 
 
-static enum v4l2_mbus_pixelcode ov6650_codes[] = {
-	V4L2_MBUS_FMT_YUYV8_2X8,
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_YVYU8_2X8,
-	V4L2_MBUS_FMT_VYUY8_2X8,
-	V4L2_MBUS_FMT_SBGGR8_1X8,
-	V4L2_MBUS_FMT_Y8_1X8,
+static u32 ov6650_codes[] = {
+	MEDIA_BUS_FMT_YUYV8_2X8,
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_YVYU8_2X8,
+	MEDIA_BUS_FMT_VYUY8_2X8,
+	MEDIA_BUS_FMT_SBGGR8_1X8,
+	MEDIA_BUS_FMT_Y8_1X8,
 };
 
 /* read a register */
@@ -555,29 +555,29 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 			.height	= mf->height << half_scale,
 		},
 	};
-	enum v4l2_mbus_pixelcode code = mf->code;
+	u32 code = mf->code;
 	unsigned long mclk, pclk;
 	u8 coma_set = 0, coma_mask = 0, coml_set, coml_mask, clkrc;
 	int ret;
 
 	/* select color matrix configuration for given color encoding */
 	switch (code) {
-	case V4L2_MBUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_Y8_1X8:
 		dev_dbg(&client->dev, "pixel format GREY8_1X8\n");
 		coma_mask |= COMA_RGB | COMA_WORD_SWAP | COMA_BYTE_SWAP;
 		coma_set |= COMA_BW;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		dev_dbg(&client->dev, "pixel format YUYV8_2X8_LE\n");
 		coma_mask |= COMA_RGB | COMA_BW | COMA_BYTE_SWAP;
 		coma_set |= COMA_WORD_SWAP;
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
 		dev_dbg(&client->dev, "pixel format YVYU8_2X8_LE (untested)\n");
 		coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP |
 				COMA_BYTE_SWAP;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		dev_dbg(&client->dev, "pixel format YUYV8_2X8_BE\n");
 		if (half_scale) {
 			coma_mask |= COMA_RGB | COMA_BW | COMA_WORD_SWAP;
@@ -587,7 +587,7 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 			coma_set |= COMA_BYTE_SWAP | COMA_WORD_SWAP;
 		}
 		break;
-	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
 		dev_dbg(&client->dev, "pixel format YVYU8_2X8_BE (untested)\n");
 		if (half_scale) {
 			coma_mask |= COMA_RGB | COMA_BW;
@@ -597,7 +597,7 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 			coma_set |= COMA_BYTE_SWAP;
 		}
 		break;
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
 		dev_dbg(&client->dev, "pixel format SBGGR8_1X8 (untested)\n");
 		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
 		coma_set |= COMA_RAW_RGB | COMA_RGB;
@@ -608,8 +608,8 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	}
 	priv->code = code;
 
-	if (code == V4L2_MBUS_FMT_Y8_1X8 ||
-			code == V4L2_MBUS_FMT_SBGGR8_1X8) {
+	if (code == MEDIA_BUS_FMT_Y8_1X8 ||
+			code == MEDIA_BUS_FMT_SBGGR8_1X8) {
 		coml_mask = COML_ONE_CHANNEL;
 		coml_set = 0;
 		priv->pclk_max = 4000000;
@@ -619,7 +619,7 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		priv->pclk_max = 8000000;
 	}
 
-	if (code == V4L2_MBUS_FMT_SBGGR8_1X8)
+	if (code == MEDIA_BUS_FMT_SBGGR8_1X8)
 		priv->colorspace = V4L2_COLORSPACE_SRGB;
 	else if (code != 0)
 		priv->colorspace = V4L2_COLORSPACE_JPEG;
@@ -697,18 +697,18 @@ static int ov6650_try_fmt(struct v4l2_subdev *sd,
 	mf->field = V4L2_FIELD_NONE;
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_Y10_1X10:
-		mf->code = V4L2_MBUS_FMT_Y8_1X8;
-	case V4L2_MBUS_FMT_Y8_1X8:
-	case V4L2_MBUS_FMT_YVYU8_2X8:
-	case V4L2_MBUS_FMT_YUYV8_2X8:
-	case V4L2_MBUS_FMT_VYUY8_2X8:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_Y10_1X10:
+		mf->code = MEDIA_BUS_FMT_Y8_1X8;
+	case MEDIA_BUS_FMT_Y8_1X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_VYUY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 		break;
 	default:
-		mf->code = V4L2_MBUS_FMT_SBGGR8_1X8;
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
+		mf->code = MEDIA_BUS_FMT_SBGGR8_1X8;
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	}
@@ -717,7 +717,7 @@ static int ov6650_try_fmt(struct v4l2_subdev *sd,
 }
 
 static int ov6650_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index >= ARRAY_SIZE(ov6650_codes))
 		return -EINVAL;
@@ -1013,7 +1013,7 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->rect.width  = W_CIF;
 	priv->rect.height = H_CIF;
 	priv->half_scale  = false;
-	priv->code	  = V4L2_MBUS_FMT_YUYV8_2X8;
+	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	priv->clk = v4l2_clk_get(&client->dev, "mclk");
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 970a04e..8daac88 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -376,7 +376,7 @@
  */
 
 struct ov772x_color_format {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	enum v4l2_colorspace colorspace;
 	u8 dsp3;
 	u8 dsp4;
@@ -408,7 +408,7 @@ struct ov772x_priv {
  */
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
@@ -416,7 +416,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.com7		= OFMT_YUV,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
+		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= UV_ON,
 		.dsp4		= DSP_OFMT_YUV,
@@ -424,7 +424,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.com7		= OFMT_YUV,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
@@ -432,7 +432,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.com7		= OFMT_YUV,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+		.code		= MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
@@ -440,7 +440,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.com7		= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+		.code		= MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
@@ -448,7 +448,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.com7		= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.code		= MEDIA_BUS_FMT_RGB565_2X8_LE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
@@ -456,7 +456,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		.com7		= FMT_RGB565 | OFMT_RGB,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_RGB565_2X8_BE,
+		.code		= MEDIA_BUS_FMT_RGB565_2X8_BE,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_YUV,
@@ -468,7 +468,7 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 		 * regardless of the COM7 value. We can thus only support 10-bit
 		 * Bayer until someone figures it out.
 		 */
-		.code		= V4L2_MBUS_FMT_SBGGR10_1X10,
+		.code		= MEDIA_BUS_FMT_SBGGR10_1X10,
 		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.dsp3		= 0x0,
 		.dsp4		= DSP_OFMT_RAW10,
@@ -990,7 +990,7 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 };
 
 static int ov772x_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index >= ARRAY_SIZE(ov772x_cfmts))
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index bc74224..aa93d2e 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -159,10 +159,10 @@ static const struct ov9640_reg ov9640_regs_rgb[] = {
 	{ OV9640_MTXS,	0x65 },
 };
 
-static enum v4l2_mbus_pixelcode ov9640_codes[] = {
-	V4L2_MBUS_FMT_UYVY8_2X8,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
-	V4L2_MBUS_FMT_RGB565_2X8_LE,
+static u32 ov9640_codes[] = {
+	MEDIA_BUS_FMT_UYVY8_2X8,
+	MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE,
+	MEDIA_BUS_FMT_RGB565_2X8_LE,
 };
 
 /* read a register */
@@ -351,22 +351,22 @@ static void ov9640_res_roundup(u32 *width, u32 *height)
 }
 
 /* Prepare necessary register changes depending on color encoding */
-static void ov9640_alter_regs(enum v4l2_mbus_pixelcode code,
+static void ov9640_alter_regs(u32 code,
 			      struct ov9640_reg_alt *alt)
 {
 	switch (code) {
 	default:
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		alt->com12	= OV9640_COM12_YUV_AVG;
 		alt->com13	= OV9640_COM13_Y_DELAY_EN |
 					OV9640_COM13_YUV_DLY(0x01);
 		break;
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
 		alt->com7	= OV9640_COM7_RGB;
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_555;
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		alt->com7	= OV9640_COM7_RGB;
 		alt->com13	= OV9640_COM13_RGB_AVG;
 		alt->com15	= OV9640_COM15_RGB_565;
@@ -376,7 +376,7 @@ static void ov9640_alter_regs(enum v4l2_mbus_pixelcode code,
 
 /* Setup registers according to resolution and color encoding */
 static int ov9640_write_regs(struct i2c_client *client, u32 width,
-		enum v4l2_mbus_pixelcode code, struct ov9640_reg_alt *alts)
+		u32 code, struct ov9640_reg_alt *alts)
 {
 	const struct ov9640_reg	*ov9640_regs, *matrix_regs;
 	int			ov9640_regs_len, matrix_regs_len;
@@ -419,7 +419,7 @@ static int ov9640_write_regs(struct i2c_client *client, u32 width,
 	}
 
 	/* select color matrix configuration for given color encoding */
-	if (code == V4L2_MBUS_FMT_UYVY8_2X8) {
+	if (code == MEDIA_BUS_FMT_UYVY8_2X8) {
 		matrix_regs	= ov9640_regs_yuv;
 		matrix_regs_len	= ARRAY_SIZE(ov9640_regs_yuv);
 	} else {
@@ -487,7 +487,7 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov9640_reg_alt alts = {0};
 	enum v4l2_colorspace cspace;
-	enum v4l2_mbus_pixelcode code = mf->code;
+	u32 code = mf->code;
 	int ret;
 
 	ov9640_res_roundup(&mf->width, &mf->height);
@@ -500,13 +500,13 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd,
 		return ret;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		cspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
-		code = V4L2_MBUS_FMT_UYVY8_2X8;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+		code = MEDIA_BUS_FMT_UYVY8_2X8;
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		cspace = V4L2_COLORSPACE_JPEG;
 	}
 
@@ -527,13 +527,13 @@ static int ov9640_try_fmt(struct v4l2_subdev *sd,
 	mf->field = V4L2_FIELD_NONE;
 
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
-		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
 
@@ -541,7 +541,7 @@ static int ov9640_try_fmt(struct v4l2_subdev *sd,
 }
 
 static int ov9640_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index >= ARRAY_SIZE(ov9640_codes))
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index ee9eb63..841dc55 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -392,8 +392,8 @@ static const struct ov9740_reg ov9740_defaults[] = {
 	{ OV9740_ISP_CTRL19,		0x02 },
 };
 
-static enum v4l2_mbus_pixelcode ov9740_codes[] = {
-	V4L2_MBUS_FMT_YUYV8_2X8,
+static u32 ov9740_codes[] = {
+	MEDIA_BUS_FMT_YUYV8_2X8,
 };
 
 /* read a register */
@@ -674,13 +674,13 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov9740_priv *priv = to_ov9740(sd);
 	enum v4l2_colorspace cspace;
-	enum v4l2_mbus_pixelcode code = mf->code;
+	u32 code = mf->code;
 	int ret;
 
 	ov9740_res_roundup(&mf->width, &mf->height);
 
 	switch (code) {
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		cspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
@@ -710,14 +710,14 @@ static int ov9740_try_fmt(struct v4l2_subdev *sd,
 	ov9740_res_roundup(&mf->width, &mf->height);
 
 	mf->field = V4L2_FIELD_NONE;
-	mf->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	mf->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
 	return 0;
 }
 
 static int ov9740_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index >= ARRAY_SIZE(ov9740_codes))
 		return -EINVAL;
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index 7e6d978..1752428 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -111,13 +111,13 @@
 
 /* RJ54N1CB0C has only one fixed colorspace per pixelcode */
 struct rj54n1_datafmt {
-	enum v4l2_mbus_pixelcode	code;
+	u32	code;
 	enum v4l2_colorspace		colorspace;
 };
 
 /* Find a data format by a pixel code in an array */
 static const struct rj54n1_datafmt *rj54n1_find_datafmt(
-	enum v4l2_mbus_pixelcode code, const struct rj54n1_datafmt *fmt,
+	u32 code, const struct rj54n1_datafmt *fmt,
 	int n)
 {
 	int i;
@@ -129,15 +129,15 @@ static const struct rj54n1_datafmt *rj54n1_find_datafmt(
 }
 
 static const struct rj54n1_datafmt rj54n1_colour_fmts[] = {
-	{V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE, V4L2_COLORSPACE_SRGB},
-	{V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_COLORSPACE_SRGB},
 };
 
 struct rj54n1_clock_div {
@@ -486,7 +486,7 @@ static int reg_write_multiple(struct i2c_client *client,
 }
 
 static int rj54n1_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index >= ARRAY_SIZE(rj54n1_colour_fmts))
 		return -EINVAL;
@@ -965,11 +965,11 @@ static int rj54n1_try_fmt(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	const struct rj54n1_datafmt *fmt;
-	int align = mf->code == V4L2_MBUS_FMT_SBGGR10_1X10 ||
-		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE ||
-		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE ||
-		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE ||
-		mf->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE;
+	int align = mf->code == MEDIA_BUS_FMT_SBGGR10_1X10 ||
+		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE ||
+		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE ||
+		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE ||
+		mf->code == MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE;
 
 	dev_dbg(&client->dev, "%s: code = %d, width = %u, height = %u\n",
 		__func__, mf->code, mf->width, mf->height);
@@ -1025,55 +1025,55 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 
 	/* RA_SEL_UL is only relevant for raw modes, ignored otherwise. */
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case MEDIA_BUS_FMT_YVYU8_2X8:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0x11);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0x11);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		if (!ret)
 			ret = reg_write(client, RJ54N1_RA_SEL_UL, 0);
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		if (!ret)
 			ret = reg_write(client, RJ54N1_RA_SEL_UL, 8);
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
 		if (!ret)
 			ret = reg_write(client, RJ54N1_RA_SEL_UL, 0);
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 4);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
 		if (!ret)
 			ret = reg_write(client, RJ54N1_RA_SEL_UL, 8);
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 5);
 		break;
 	default:
@@ -1083,7 +1083,7 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 	/* Special case: a raw mode with 10 bits of data per clock tick */
 	if (!ret)
 		ret = reg_set(client, RJ54N1_OCLK_SEL_EN,
-			      (mf->code == V4L2_MBUS_FMT_SBGGR10_1X10) << 1, 2);
+			      (mf->code == MEDIA_BUS_FMT_SBGGR10_1X10) << 1, 2);
 
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 416402e..9b85321 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -705,7 +705,7 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd,
 
 	mf->width	= priv->scale->width;
 	mf->height	= priv->scale->height;
-	mf->code	= V4L2_MBUS_FMT_UYVY8_2X8;
+	mf->code	= MEDIA_BUS_FMT_UYVY8_2X8;
 	mf->colorspace	= V4L2_COLORSPACE_JPEG;
 	mf->field	= V4L2_FIELD_INTERLACED_BT;
 
@@ -724,7 +724,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 	/*
 	 * check color format
 	 */
-	if (mf->code != V4L2_MBUS_FMT_UYVY8_2X8)
+	if (mf->code != MEDIA_BUS_FMT_UYVY8_2X8)
 		return -EINVAL;
 
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
@@ -751,7 +751,7 @@ static int tw9910_try_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 
-	mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
 	/*
@@ -822,12 +822,12 @@ static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 };
 
 static int tw9910_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			   enum v4l2_mbus_pixelcode *code)
+			   u32 *code)
 {
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_UYVY8_2X8;
+	*code = MEDIA_BUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 118f8ee..10c735c 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -165,7 +165,7 @@ struct sr030pc30_info {
 };
 
 struct sr030pc30_format {
-	enum v4l2_mbus_pixelcode code;
+	u32 code;
 	enum v4l2_colorspace colorspace;
 	u16 ispctl1_reg;
 };
@@ -201,23 +201,23 @@ static const struct sr030pc30_frmsize sr030pc30_sizes[] = {
 /* supported pixel formats */
 static const struct sr030pc30_format sr030pc30_formats[] = {
 	{
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x03,
 	}, {
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
+		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x02,
 	}, {
-		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.code		= MEDIA_BUS_FMT_VYUY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0,
 	}, {
-		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x01,
 	}, {
-		.code		= V4L2_MBUS_FMT_RGB565_2X8_BE,
+		.code		= MEDIA_BUS_FMT_RGB565_2X8_BE,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.ispctl1_reg	= 0x40,
 	},
@@ -472,7 +472,7 @@ static int sr030pc30_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 static int sr030pc30_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
-			      enum v4l2_mbus_pixelcode *code)
+			      u32 *code)
 {
 	if (!code || index >= ARRAY_SIZE(sr030pc30_formats))
 		return -EINVAL;
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index b9dabc9..2042042 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -756,12 +756,12 @@ static int tvp514x_s_ctrl(struct v4l2_ctrl *ctrl)
  */
 static int
 tvp514x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					enum v4l2_mbus_pixelcode *code)
+					u32 *code)
 {
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV10_2X10;
+	*code = MEDIA_BUS_FMT_YUYV10_2X10;
 	return 0;
 }
 
@@ -784,7 +784,7 @@ tvp514x_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
 	/* Calculate height and width based on current standard */
 	current_std = decoder->current_std;
 
-	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	f->code = MEDIA_BUS_FMT_YUYV8_2X8;
 	f->width = decoder->std_list[current_std].width;
 	f->height = decoder->std_list[current_std].height;
 	f->field = V4L2_FIELD_INTERLACED;
@@ -942,7 +942,7 @@ static int tvp514x_enum_mbus_code(struct v4l2_subdev *sd,
 	if (index != 0)
 		return -EINVAL;
 
-	code->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	return 0;
 }
@@ -967,7 +967,7 @@ static int tvp514x_get_pad_format(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	format->format.code = V4L2_MBUS_FMT_YUYV8_2X8;
+	format->format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 	format->format.width = tvp514x_std_list[decoder->current_std].width;
 	format->format.height = tvp514x_std_list[decoder->current_std].height;
 	format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
@@ -991,7 +991,7 @@ static int tvp514x_set_pad_format(struct v4l2_subdev *sd,
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
 	if (fmt->format.field != V4L2_FIELD_INTERLACED ||
-	    fmt->format.code != V4L2_MBUS_FMT_YUYV8_2X8 ||
+	    fmt->format.code != MEDIA_BUS_FMT_YUYV8_2X8 ||
 	    fmt->format.colorspace != V4L2_COLORSPACE_SMPTE170M ||
 	    fmt->format.width != tvp514x_std_list[decoder->current_std].width ||
 	    fmt->format.height != tvp514x_std_list[decoder->current_std].height)
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 193e7d6..68cdab9 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -818,12 +818,12 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 }
 
 static int tvp5150_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-						enum v4l2_mbus_pixelcode *code)
+						u32 *code)
 {
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_UYVY8_2X8;
+	*code = MEDIA_BUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
@@ -840,7 +840,7 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	f->width = decoder->rect.width;
 	f->height = decoder->rect.height;
 
-	f->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	f->field = V4L2_FIELD_SEQ_TB;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 51bac76..fe4870e 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -626,7 +626,7 @@ static int tvp7002_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f
 
 	f->width = bt->width;
 	f->height = bt->height;
-	f->code = V4L2_MBUS_FMT_YUYV10_1X20;
+	f->code = MEDIA_BUS_FMT_YUYV10_1X20;
 	f->field = device->current_timings->scanmode;
 	f->colorspace = device->current_timings->color_space;
 
@@ -756,12 +756,12 @@ static int tvp7002_s_register(struct v4l2_subdev *sd,
  */
 
 static int tvp7002_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-					enum v4l2_mbus_pixelcode *code)
+					u32 *code)
 {
 	/* Check requested format index is within range */
 	if (index)
 		return -EINVAL;
-	*code = V4L2_MBUS_FMT_YUYV10_1X20;
+	*code = MEDIA_BUS_FMT_YUYV10_1X20;
 	return 0;
 }
 
@@ -859,7 +859,7 @@ tvp7002_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (code->index != 0)
 		return -EINVAL;
 
-	code->code = V4L2_MBUS_FMT_YUYV10_1X20;
+	code->code = MEDIA_BUS_FMT_YUYV10_1X20;
 
 	return 0;
 }
@@ -878,7 +878,7 @@ tvp7002_get_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 {
 	struct tvp7002 *tvp7002 = to_tvp7002(sd);
 
-	fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
+	fmt->format.code = MEDIA_BUS_FMT_YUYV10_1X20;
 	fmt->format.width = tvp7002->current_timings->timings.bt.width;
 	fmt->format.height = tvp7002->current_timings->timings.bt.height;
 	fmt->format.field = tvp7002->current_timings->scanmode;
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 373f2df..00e7f04 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -45,19 +45,19 @@ struct vs6624 {
 };
 
 static const struct vs6624_format {
-	enum v4l2_mbus_pixelcode mbus_code;
+	u32 mbus_code;
 	enum v4l2_colorspace colorspace;
 } vs6624_formats[] = {
 	{
-		.mbus_code      = V4L2_MBUS_FMT_UYVY8_2X8,
+		.mbus_code      = MEDIA_BUS_FMT_UYVY8_2X8,
 		.colorspace     = V4L2_COLORSPACE_JPEG,
 	},
 	{
-		.mbus_code      = V4L2_MBUS_FMT_YUYV8_2X8,
+		.mbus_code      = MEDIA_BUS_FMT_YUYV8_2X8,
 		.colorspace     = V4L2_COLORSPACE_JPEG,
 	},
 	{
-		.mbus_code      = V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.mbus_code      = MEDIA_BUS_FMT_RGB565_2X8_LE,
 		.colorspace     = V4L2_COLORSPACE_SRGB,
 	},
 };
@@ -65,7 +65,7 @@ static const struct vs6624_format {
 static struct v4l2_mbus_framefmt vs6624_default_fmt = {
 	.width = VGA_WIDTH,
 	.height = VGA_HEIGHT,
-	.code = V4L2_MBUS_FMT_UYVY8_2X8,
+	.code = MEDIA_BUS_FMT_UYVY8_2X8,
 	.field = V4L2_FIELD_NONE,
 	.colorspace = V4L2_COLORSPACE_JPEG,
 };
@@ -558,7 +558,7 @@ static int vs6624_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 static int vs6624_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
-				enum v4l2_mbus_pixelcode *code)
+				u32 *code)
 {
 	if (index >= ARRAY_SIZE(vs6624_formats))
 		return -EINVAL;
@@ -605,15 +605,15 @@ static int vs6624_s_mbus_fmt(struct v4l2_subdev *sd,
 
 	/* set image format */
 	switch (fmt->code) {
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		vs6624_write(sd, VS6624_IMG_FMT0, 0x0);
 		vs6624_write(sd, VS6624_YUV_SETUP, 0x1);
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		vs6624_write(sd, VS6624_IMG_FMT0, 0x0);
 		vs6624_write(sd, VS6624_YUV_SETUP, 0x3);
 		break;
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		vs6624_write(sd, VS6624_IMG_FMT0, 0x4);
 		vs6624_write(sd, VS6624_RGB_SETUP, 0x0);
 		break;
-- 
1.9.1
