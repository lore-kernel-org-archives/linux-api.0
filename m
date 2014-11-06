From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 05/10] [media] pci: Make use of media_bus_format enum
Date: Thu,  6 Nov 2014 10:57:03 +0100
Message-ID: <1415267829-4177-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415267829-4177-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guennadi Liakhovetski <g.liakhovetski-Mmb7MZpHnFY@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Replace all references to the old definition in pci drivers.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/media/pci/cx18/cx18-av-core.c       | 2 +-
 drivers/media/pci/cx18/cx18-controls.c      | 2 +-
 drivers/media/pci/cx18/cx18-ioctl.c         | 2 +-
 drivers/media/pci/cx23885/cx23885-video.c   | 2 +-
 drivers/media/pci/ivtv/ivtv-controls.c      | 2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c         | 2 +-
 drivers/media/pci/saa7134/saa7134-empress.c | 4 ++--
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index 2d3afe0..4c6ce21 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -952,7 +952,7 @@ static int cx18_av_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 	int HSC, VSC, Vsrc, Hsrc, filter, Vlines;
 	int is_50Hz = !(state->std & V4L2_STD_525_60);
 
-	if (fmt->code != V4L2_MBUS_FMT_FIXED)
+	if (fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 
 	fmt->field = V4L2_FIELD_INTERLACED;
diff --git a/drivers/media/pci/cx18/cx18-controls.c b/drivers/media/pci/cx18/cx18-controls.c
index 282a3d2..4aeb7c6 100644
--- a/drivers/media/pci/cx18/cx18-controls.c
+++ b/drivers/media/pci/cx18/cx18-controls.c
@@ -98,7 +98,7 @@ static int cx18_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 	/* fix videodecoder resolution */
 	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
 	fmt.height = cxhdl->height;
-	fmt.code = V4L2_MBUS_FMT_FIXED;
+	fmt.code = MEDIA_BUS_FMT_FIXED;
 	v4l2_subdev_call(cx->sd_av, video, s_mbus_fmt, &fmt);
 	return 0;
 }
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 6f2b590..71963db 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -294,7 +294,7 @@ static int cx18_s_fmt_vid_cap(struct file *file, void *fh,
 
 	mbus_fmt.width = cx->cxhdl.width = w;
 	mbus_fmt.height = cx->cxhdl.height = h;
-	mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
+	mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
 	v4l2_subdev_call(cx->sd_av, video, s_mbus_fmt, &mbus_fmt);
 	return cx18_g_fmt_vid_cap(file, fh, fmt);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 682a4f9..091f5db 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -608,7 +608,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->field	= f->fmt.pix.field;
 	dprintk(2, "%s() width=%d height=%d field=%d\n", __func__,
 		dev->width, dev->height, dev->field);
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
 	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 	/* s_mbus_fmt overwrites f->fmt.pix.field, restore it */
diff --git a/drivers/media/pci/ivtv/ivtv-controls.c b/drivers/media/pci/ivtv/ivtv-controls.c
index 2b0ab26..ccf548c 100644
--- a/drivers/media/pci/ivtv/ivtv-controls.c
+++ b/drivers/media/pci/ivtv/ivtv-controls.c
@@ -69,7 +69,7 @@ static int ivtv_s_video_encoding(struct cx2341x_handler *cxhdl, u32 val)
 	/* fix videodecoder resolution */
 	fmt.width = cxhdl->width / (is_mpeg1 ? 2 : 1);
 	fmt.height = cxhdl->height;
-	fmt.code = V4L2_MBUS_FMT_FIXED;
+	fmt.code = MEDIA_BUS_FMT_FIXED;
 	v4l2_subdev_call(itv->sd_video, video, s_mbus_fmt, &fmt);
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 3e0cb77..4d8ee18 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -595,7 +595,7 @@ static int ivtv_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 		fmt->fmt.pix.width /= 2;
 	mbus_fmt.width = fmt->fmt.pix.width;
 	mbus_fmt.height = h;
-	mbus_fmt.code = V4L2_MBUS_FMT_FIXED;
+	mbus_fmt.code = MEDIA_BUS_FMT_FIXED;
 	v4l2_subdev_call(itv->sd_video, video, s_mbus_fmt, &mbus_fmt);
 	return ivtv_g_fmt_vid_cap(file, fh, fmt);
 }
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index e4ea85f..8b3bb78 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -140,7 +140,7 @@ static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_mbus_framefmt mbus_fmt;
 
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
 	saa_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 
@@ -157,7 +157,7 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_mbus_framefmt mbus_fmt;
 
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, MEDIA_BUS_FMT_FIXED);
 	saa_call_all(dev, video, try_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 
-- 
1.9.1
