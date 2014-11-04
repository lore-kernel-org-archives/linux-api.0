From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 05/15] [media] pci: Make use of media_bus_format enum
Date: Tue,  4 Nov 2014 10:55:00 +0100
Message-ID: <1415094910-15899-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Replace all references to the old definition in pci drivers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
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
