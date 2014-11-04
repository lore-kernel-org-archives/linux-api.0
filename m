From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 07/15] [media] usb: Make use of media_bus_format enum
Date: Tue,  4 Nov 2014 10:55:02 +0100
Message-ID: <1415094910-15899-8-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Reference new definitions in all usb drivers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c | 4 ++--
 drivers/media/usb/em28xx/em28xx-camera.c  | 2 +-
 drivers/media/usb/go7007/go7007-v4l2.c    | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c   | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 459bb0e..95653ba 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1878,7 +1878,7 @@ static int cx231xx_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 	/* fix videodecoder resolution */
 	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
 	fmt.height = cxhdl->height;
-	fmt.code = V4L2_MBUS_FMT_FIXED;
+	fmt.code = MEDIA_BUS_FMT_FIXED;
 	v4l2_subdev_call(dev->sd_cx25840, video, s_mbus_fmt, &fmt);
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 3b3ada6..989d527 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -967,7 +967,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->height = f->fmt.pix.height;
 	dev->format = fmt;
 
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
 	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 
@@ -1012,7 +1012,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	   resolution (since a standard change effects things like the number
 	   of lines in VACT, etc) */
 	memset(&mbus_fmt, 0, sizeof(mbus_fmt));
-	mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
+	mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
 	mbus_fmt.width = dev->width;
 	mbus_fmt.height = dev->height;
 	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 6d2ea9a..38cf6c8 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -430,7 +430,7 @@ int em28xx_init_camera(struct em28xx *dev)
 			break;
 		}
 
-		fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
+		fmt.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		fmt.width = 640;
 		fmt.height = 480;
 		v4l2_subdev_call(subdev, video, s_mbus_fmt, &fmt);
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index ec799b4..d6bf982 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -252,7 +252,7 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	if (go->board_info->sensor_flags & GO7007_SENSOR_SCALING) {
 		struct v4l2_mbus_framefmt mbus_fmt;
 
-		mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
+		mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
 		mbus_fmt.width = fmt ? fmt->fmt.pix.width : width;
 		mbus_fmt.height = height;
 		go->encoder_h_halve = 0;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 9623b62..2fd9b5e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2966,7 +2966,7 @@ static void pvr2_subdev_update(struct pvr2_hdw *hdw)
 		memset(&fmt, 0, sizeof(fmt));
 		fmt.width = hdw->res_hor_val;
 		fmt.height = hdw->res_ver_val;
-		fmt.code = V4L2_MBUS_FMT_FIXED;
+		fmt.code = MEDIA_BUS_FMT_FIXED;
 		pvr2_trace(PVR2_TRACE_CHIPS, "subdev v4l2 set_size(%dx%d)",
 			   fmt.width, fmt.height);
 		v4l2_device_call_all(&hdw->v4l2_dev, 0, video, s_mbus_fmt, &fmt);
-- 
1.9.1
