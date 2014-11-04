From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 11/15] [media] Deprecate v4l2_mbus_pixelcode
Date: Tue,  4 Nov 2014 10:55:06 +0100
Message-ID: <1415094910-15899-12-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

The v4l2_mbus_pixelcode enum (or its values) should be replaced by the
media_bus_format enum.
Keep this enum in v4l2-mediabus.h and create a new header containing
the v4l2_mbus_framefmt struct definition (which is not deprecated) so
that we can add a #warning statement in v4l2-mediabus.h and hopefully
encourage users to move to the new definitions.

Replace inclusion of v4l2-mediabus.h with v4l2-mbus.h in all common headers
and update the documentation Makefile to parse v4l2-mbus.h instead of
v4l2-mediabus.h.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 Documentation/DocBook/media/Makefile |  2 +-
 include/media/v4l2-mediabus.h        |  2 +-
 include/uapi/linux/Kbuild            |  1 +
 include/uapi/linux/v4l2-mbus.h       | 35 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h   | 26 ++++----------------------
 include/uapi/linux/v4l2-subdev.h     |  2 +-
 6 files changed, 43 insertions(+), 25 deletions(-)
 create mode 100644 include/uapi/linux/v4l2-mbus.h

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 181b7f4..30a22fa 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -99,7 +99,7 @@ STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if (/^struct\s+([^\s]+)\s+/)' $(srctree)/include/uapi/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-subdev.h) \
-	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-mediabus.h)
+	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/v4l2-mbus.h)
 
 ERRORS = \
 	E2BIG \
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 4915621..fc6bdd3 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -11,7 +11,7 @@
 #ifndef V4L2_MEDIABUS_H
 #define V4L2_MEDIABUS_H
 
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 
 /* Parallel flags */
 /*
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index b2c23f8..7b72720 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -408,6 +408,7 @@ header-y += uvcvideo.h
 header-y += v4l2-common.h
 header-y += v4l2-controls.h
 header-y += v4l2-dv-timings.h
+header-y += v4l2-mbus.h
 header-y += v4l2-mediabus.h
 header-y += v4l2-subdev.h
 header-y += veth.h
diff --git a/include/uapi/linux/v4l2-mbus.h b/include/uapi/linux/v4l2-mbus.h
new file mode 100644
index 0000000..2778c6e
--- /dev/null
+++ b/include/uapi/linux/v4l2-mbus.h
@@ -0,0 +1,35 @@
+/*
+ * Media Bus API header
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_V4L2_MBUS_H
+#define __LINUX_V4L2_MBUS_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/media-bus-format.h>
+
+/**
+ * struct v4l2_mbus_framefmt - frame format on the media bus
+ * @width:	frame width
+ * @height:	frame height
+ * @code:	data format code (from enum media_bus_format)
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
+#endif
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 5a3e797..a587eac 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -10,12 +10,12 @@
 
 #ifndef __LINUX_V4L2_MEDIABUS_H
 #define __LINUX_V4L2_MEDIABUS_H
+#ifndef __KERNEL__
 
-#include <linux/types.h>
-#include <linux/videodev2.h>
-#include <linux/media-bus-format.h>
+#warning "Use v4l2-mbus.h instead of v4l2-mediabus.h"
+
+#include <linux/v4l2-mbus.h>
 
-#ifndef __KERNEL__
 #define MEDIA_BUS_TO_V4L2_MBUS(x)	V4L2_MBUS_FMT_ ## x = MEDIA_BUS_FMT_ ## x
 
 enum v4l2_mbus_pixelcode {
@@ -104,22 +104,4 @@ enum v4l2_mbus_pixelcode {
 	MEDIA_BUS_TO_V4L2_MBUS(AHSV8888_1X32),
 };
 #endif /* __KERNEL__ */
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
-
 #endif
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index 7f44f04..1a46d3b 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -26,7 +26,7 @@
 #include <linux/ioctl.h>
 #include <linux/types.h>
 #include <linux/v4l2-common.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 
 /**
  * enum v4l2_subdev_format_whence - Media bus format type
-- 
1.9.1
