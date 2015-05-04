From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 3/4] media/vivid: Add support for Y16_BE format
Date: Mon,  4 May 2015 10:07:31 +0200
Message-ID: <1430726852-11715-4-git-send-email-ricardo.ribalda@gmail.com>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
List-Id: linux-api@vger.kernel.org

Support for V4L2_PIX_FMT_Y16_BE, a 16 bit big endian greyscale format.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 9 ++++++++-
 drivers/media/platform/vivid/vivid-vid-common.c | 8 ++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 9e50303a19c5..2e5129a6bc2f 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -221,6 +221,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ABGR32:
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
+	case V4L2_PIX_FMT_Y16_BE:
 		tpg->is_yuv = false;
 		break;
 	case V4L2_PIX_FMT_YUV444:
@@ -315,6 +316,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_YUV565:
 	case V4L2_PIX_FMT_Y16:
+	case V4L2_PIX_FMT_Y16_BE:
 		tpg->twopixelsize[0] = 2 * 2;
 		break;
 	case V4L2_PIX_FMT_RGB24:
@@ -715,7 +717,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		b <<= 4;
 	}
 	if (tpg->qual == TPG_QUAL_GRAY || tpg->fourcc == V4L2_PIX_FMT_GREY ||
-	    tpg->fourcc == V4L2_PIX_FMT_Y16) {
+	    tpg->fourcc == V4L2_PIX_FMT_Y16 ||
+	    tpg->fourcc == V4L2_PIX_FMT_Y16_BE) {
 		/* Rec. 709 Luma function */
 		/* (0.2126, 0.7152, 0.0722) * (255 * 256) */
 		r = g = b = (13879 * r + 46688 * g + 4713 * b) >> 16;
@@ -902,6 +905,10 @@ static void gen_twopix(struct tpg_data *tpg,
 		buf[0][offset] = 0;
 		buf[0][offset+1] = r_y;
 		break;
+	case V4L2_PIX_FMT_Y16_BE:
+		buf[0][offset] = r_y;
+		buf[0][offset+1] = 0;
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV420M:
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 96ccd3c38dd2..45f10a7f9b46 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -197,6 +197,14 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.fourcc   = V4L2_PIX_FMT_Y16_BE,
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.is_yuv   = true,
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
 		.fourcc   = V4L2_PIX_FMT_RGB332, /* rrrgggbb */
 		.vdownsampling = { 1 },
 		.bit_depth = { 8 },
-- 
2.1.4
