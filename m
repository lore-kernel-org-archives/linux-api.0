From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 14/15] [media] platform: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h
Date: Tue,  4 Nov 2014 10:55:09 +0100
Message-ID: <1415094910-15899-15-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

The v4l2-mediabus.h header is now deprecated and should be replaced with
v4l2-mbus.h.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/media/platform/omap3isp/ispcsi2.c  | 2 +-
 drivers/media/platform/omap3isp/ispvideo.h | 2 +-
 drivers/media/platform/vsp1/vsp1_video.c   | 2 +-
 include/media/soc_mediabus.h               | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 995a268..64acb66 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -15,7 +15,7 @@
  */
 #include <linux/delay.h>
 #include <media/v4l2-common.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/mm.h>
 
 #include "isp.h"
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 9de3de5..7738d27 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -16,7 +16,7 @@
 #ifndef OMAP3_ISP_VIDEO_H
 #define OMAP3_ISP_VIDEO_H
 
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <media/media-entity.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d91f19a..bb3af00 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -16,7 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 
 #include <media/media-entity.h>
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index 9d8e7a1..e357182 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -12,7 +12,7 @@
 #define SOC_MEDIABUS_H
 
 #include <linux/videodev2.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 
 /**
  * enum soc_mbus_packing - data packing types on the media-bus
-- 
1.9.1
