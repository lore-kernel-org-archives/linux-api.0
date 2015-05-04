From: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] media/vivid: Add support for Y16 format
Date: Mon,  4 May 2015 10:07:29 +0200
Message-ID: <1430726852-11715-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430726852-11715-1-git-send-email-ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ramakrishnan Muthukrishnan <ramakrmu-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Support for V4L2_PIX_FMT_Y16, a 16 bit greyscale format.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/media/platform/vivid/vivid-tpg.c        | 9 ++++++++-
 drivers/media/platform/vivid/vivid-vid-common.c | 8 ++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 4df755aa7e48..9e50303a19c5 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -220,6 +220,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
 	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y16:
 		tpg->is_yuv = false;
 		break;
 	case V4L2_PIX_FMT_YUV444:
@@ -313,6 +314,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_YUV444:
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_YUV565:
+	case V4L2_PIX_FMT_Y16:
 		tpg->twopixelsize[0] = 2 * 2;
 		break;
 	case V4L2_PIX_FMT_RGB24:
@@ -712,7 +714,8 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		g <<= 4;
 		b <<= 4;
 	}
-	if (tpg->qual == TPG_QUAL_GRAY || tpg->fourcc == V4L2_PIX_FMT_GREY) {
+	if (tpg->qual == TPG_QUAL_GRAY || tpg->fourcc == V4L2_PIX_FMT_GREY ||
+	    tpg->fourcc == V4L2_PIX_FMT_Y16) {
 		/* Rec. 709 Luma function */
 		/* (0.2126, 0.7152, 0.0722) * (255 * 256) */
 		r = g = b = (13879 * r + 46688 * g + 4713 * b) >> 16;
@@ -895,6 +898,10 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_GREY:
 		buf[0][offset] = r_y;
 		break;
+	case V4L2_PIX_FMT_Y16:
+		buf[0][offset] = 0;
+		buf[0][offset+1] = r_y;
+		break;
 	case V4L2_PIX_FMT_YUV422P:
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YUV420M:
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 6ba874420485..96ccd3c38dd2 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -189,6 +189,14 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 	},
 	{
+		.fourcc   = V4L2_PIX_FMT_Y16,
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
