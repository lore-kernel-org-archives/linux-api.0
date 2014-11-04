From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 15/15] staging: media: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h
Date: Tue,  4 Nov 2014 10:55:10 +0100
Message-ID: <1415094910-15899-16-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guennadi Liakhovetski <g.liakhovetski-Mmb7MZpHnFY@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The v4l2-mediabus.h header is now deprecated and should be replaced with
v4l2-mbus.h.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/staging/media/omap4iss/iss_csi2.c  | 2 +-
 drivers/staging/media/omap4iss/iss_video.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index b72e530..f47e4e5 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -13,7 +13,7 @@
 
 #include <linux/delay.h>
 #include <media/v4l2-common.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/mm.h>
 
 #include "iss.h"
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index cc8146b..a028b51 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -14,7 +14,7 @@
 #ifndef OMAP4_ISS_VIDEO_H
 #define OMAP4_ISS_VIDEO_H
 
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
-- 
1.9.1
