From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 10/22] media: Change v4l-core to check if source is free
Date: Wed,  3 Feb 2016 21:03:42 -0700
Message-ID: <a2cb324f737fad4d594b9aa18cf5448ac9352217.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Change s_input, s_fmt, s_tuner, s_frequency, querystd,
s_hw_freq_seek, and vb2_core_streamon interfaces that
alter the tuner configuration to check if it is free,
by calling v4l_enable_media_source(). If source isn't
free, return -EBUSY. v4l_disable_media_source() is
called from v4l2_fh_exit() to release tuner (source).
vb2_core_streamon() uses v4l_vb2q_enable_media_source().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-fh.c        |  2 ++
 drivers/media/v4l2-core/v4l2-ioctl.c     | 30 ++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-core.c |  4 ++++
 3 files changed, 36 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index c97067a..c183f09 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -29,6 +29,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
 
 void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
 {
@@ -92,6 +93,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
+	v4l_disable_media_source(fh->vdev);
 	v4l2_event_unsubscribe_all(fh);
 	fh->vdev = NULL;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 8a018c6..ceaa44a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf2-v4l2.h>
+#include <media/v4l2-mc.h>
 
 #include <trace/events/v4l2.h>
 
@@ -1041,6 +1042,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
+	int ret;
+
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
 	return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
 }
 
@@ -1448,6 +1455,9 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
 
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
 	v4l_sanitize_format(p);
 
 	switch (p->type) {
@@ -1637,7 +1647,11 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_tuner *p = arg;
+	int ret;
 
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
 	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	return ops->vidioc_s_tuner(file, fh, p);
@@ -1691,7 +1705,11 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
 	if (vfd->vfl_type == VFL_TYPE_SDR) {
 		if (p->type != V4L2_TUNER_SDR && p->type != V4L2_TUNER_RF)
 			return -EINVAL;
@@ -1746,7 +1764,11 @@ static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id id = *(v4l2_std_id *)arg, norm;
+	int ret;
 
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
 	norm = id & vfd->tvnorms;
 	if (vfd->tvnorms && !norm)	/* Check if std is supported */
 		return -EINVAL;
@@ -1760,7 +1782,11 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id *p = arg;
+	int ret;
 
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
 	/*
 	 * If no signal is detected, then the driver should return
 	 * V4L2_STD_UNKNOWN. Otherwise it should return tvnorms with
@@ -1779,7 +1805,11 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_hw_freq_seek *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
+	ret = v4l_enable_media_source(vfd);
+	if (ret)
+		return ret;
 	/* s_hw_freq_seek is not supported for SDR for now */
 	if (vfd->vfl_type == VFL_TYPE_SDR)
 		return -EINVAL;
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ec5b78e..d381478 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -25,6 +25,7 @@
 #include <linux/kthread.h>
 
 #include <media/videobuf2-core.h>
+#include <media/v4l2-mc.h>
 
 #include <trace/events/vb2.h>
 
@@ -1873,6 +1874,9 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 	 * are available.
 	 */
 	if (q->queued_count >= q->min_buffers_needed) {
+		ret = v4l_vb2q_enable_media_source(q);
+		if (ret)
+			return ret;
 		ret = vb2_start_streaming(q);
 		if (ret) {
 			__vb2_queue_cancel(q);
-- 
2.5.0
