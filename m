From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT definitions inside the kernel
Date: Sat,  8 Nov 2014 16:47:12 +0100
Message-ID: <1415461632-31236-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415369269-5064-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guennadi Liakhovetski <g.liakhovetski-Mmb7MZpHnFY@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
users don't have access to these definitions.

We have to keep this definition for user-space users even though they're
encouraged to move to the new media_bus_format enum.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Acked-by: Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/uapi/linux/v4l2-mediabus.h | 45 ++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index d712df8..5c9410d 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -15,6 +15,33 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
+/**
+ * struct v4l2_mbus_framefmt - frame format on the media bus
+ * @width:	frame width
+ * @height:	frame height
+ * @code:	data format code (from enum v4l2_mbus_pixelcode)
+ * @field:	used interlacing type (from enum v4l2_field)
+ * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
+ */
+struct v4l2_mbus_framefmt {
+	__u32			width;
+	__u32			height;
+	__u32			code;
+	__u32			field;
+	__u32			colorspace;
+	__u32			reserved[7];
+};
+
+#ifndef __KERNEL__
+/*
+ * enum v4l2_mbus_pixelcode and its definitions are now deprecated, and
+ * MEDIA_BUS_FMT_ definitions (defined in media-bus-format.h) should be
+ * used instead.
+ *
+ * New defines should only be added to media-bus-format.h. The
+ * v4l2_mbus_pixelcode enum is frozen.
+ */
+
 #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
 	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
 
@@ -102,22 +129,6 @@ enum v4l2_mbus_pixelcode {
 
 	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
 };
-
-/**
- * struct v4l2_mbus_framefmt - frame format on the media bus
- * @width:	frame width
- * @height:	frame height
- * @code:	data format code (from enum v4l2_mbus_pixelcode)
- * @field:	used interlacing type (from enum v4l2_field)
- * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
- */
-struct v4l2_mbus_framefmt {
-	__u32			width;
-	__u32			height;
-	__u32			code;
-	__u32			field;
-	__u32			colorspace;
-	__u32			reserved[7];
-};
+#endif /* __KERNEL__ */
 
 #endif
-- 
1.9.1
