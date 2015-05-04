From: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] media/vivid: Code cleanout
Date: Mon,  4 May 2015 10:07:32 +0200
Message-ID: <1430726852-11715-5-git-send-email-ricardo.ribalda@gmail.com>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430726852-11715-1-git-send-email-ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ramakrishnan Muthukrishnan <ramakrmu-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Remove code duplication by merging two cases in a switch.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/media/platform/vivid/vivid-tpg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 2e5129a6bc2f..8cac0bdefd9a 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -294,6 +294,7 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	}
 
 	switch (fourcc) {
+	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_RGB332:
 		tpg->twopixelsize[0] = 2;
 		break;
@@ -333,9 +334,6 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_YUV32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
-	case V4L2_PIX_FMT_GREY:
-		tpg->twopixelsize[0] = 2;
-		break;
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV12M:
-- 
2.1.4
