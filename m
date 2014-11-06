From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT definitions inside the kernel
Date: Thu,  6 Nov 2014 10:57:08 +0100
Message-ID: <1415267829-4177-11-git-send-email-boris.brezillon@free-electrons.com>
References: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
users don't have access to these definitions.

We have to keep this definition for user-space users even though they're
encouraged to move to the new media_bus_format enum.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 include/uapi/linux/media-bus-format.h | 5 +++++
 include/uapi/linux/v4l2-mediabus.h    | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 251a902..d7f9ea2 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -31,9 +31,14 @@
  * new pixel codes.
  */
 
+#ifdef __KERNEL__
+#define MEDIA_BUS_FMT_ENTRY(name, val)	MEDIA_BUS_FMT_ ## name = val
+#else
+/* Keep V4L2_MBUS_FMT for backwards compatibility */
 #define MEDIA_BUS_FMT_ENTRY(name, val)	\
 	MEDIA_BUS_FMT_ ## name = val,	\
 	V4L2_MBUS_FMT_ ## name = val
+#endif
 
 enum media_bus_format {
 	MEDIA_BUS_FMT_ENTRY(FIXED, 0x0001),
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index d30526c..8759002 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -15,7 +15,9 @@
 #include <linux/videodev2.h>
 #include <linux/media-bus-format.h>
 
+#ifndef __KERNEL__
 #define v4l2_mbus_pixelcode media_bus_format
+#endif
 
 /**
  * struct v4l2_mbus_framefmt - frame format on the media bus
-- 
1.9.1

