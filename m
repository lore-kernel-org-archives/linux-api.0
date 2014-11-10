From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 05/10] [media] pci: Make use of MEDIA_BUS_FMT definitions
Date: Mon, 10 Nov 2014 18:21:49 +0100
Message-ID: <1415640114-14930-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1415640114-14930-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415640114-14930-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Replace all references to the old definitions in pci drivers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
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
