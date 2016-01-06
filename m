From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 14/31] media: Change v4l-core to check for tuner availability
Date: Wed,  6 Jan 2016 13:27:03 -0700
Message-ID: <8e31384a21e670e6b75dfbc1556f1e597a2184d8.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Change s_input, s_fmt, s_tuner, s_frequency, querystd,
s_hw_freq_seek, and vb2_core_streamon interfaces that
alter the tuner configuration to check for tuner availability
by calling v4l_enable_media_tuner(). If tuner isn't free,
return -EBUSY. v4l_disable_media_tuner() is called from
v4l2_fh_exit() to release the tuner. vb2_core_streamon()
uses v4l_vb2q_enable_media_tuner().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-fh.c        |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c     | 29 +++++++++++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-core.c |  4 ++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index c97067a..538db62 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -92,6 +92,7 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
 {
 	if (fh->vdev == NULL)
 		return;
+	v4l_disable_media_tuner(fh->vdev);
 	v4l2_event_unsubscribe_all(fh);
 	fh->vdev = NULL;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 8a018c6..ed7f600 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1041,6 +1041,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
+	int ret;
+
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
 }
 
@@ -1448,6 +1454,9 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	v4l_sanitize_format(p);
 
 	switch (p->type) {
@@ -1637,7 +1646,11 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_tuner *p = arg;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	return ops->vidioc_s_tuner(file, fh, p);
@@ -1691,7 +1704,11 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	if (vfd->vfl_type == VFL_TYPE_SDR) {
 		if (p->type != V4L2_TUNER_SDR && p->type != V4L2_TUNER_RF)
 			return -EINVAL;
@@ -1746,7 +1763,11 @@ static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id id = *(v4l2_std_id *)arg, norm;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	norm = id & vfd->tvnorms;
 	if (vfd->tvnorms && !norm)	/* Check if std is supported */
 		return -EINVAL;
@@ -1760,7 +1781,11 @@ static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	v4l2_std_id *p = arg;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	/*
 	 * If no signal is detected, then the driver should return
 	 * V4L2_STD_UNKNOWN. Otherwise it should return tvnorms with
@@ -1779,7 +1804,11 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_hw_freq_seek *p = arg;
 	enum v4l2_tuner_type type;
+	int ret;
 
+	ret = v4l_enable_media_tuner(vfd);
+	if (ret)
+		return ret;
 	/* s_hw_freq_seek is not supported for SDR for now */
 	if (vfd->vfl_type == VFL_TYPE_SDR)
 		return -EINVAL;
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 33bdd81..c9bbb87 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -25,6 +25,7 @@
 #include <linux/kthread.h>
 
 #include <media/videobuf2-core.h>
+#include <media/v4l2-dev.h>
 
 #include <trace/events/vb2.h>
 
@@ -1742,6 +1743,9 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 	 * are available.
 	 */
 	if (q->queued_count >= q->min_buffers_needed) {
+		ret = v4l_vb2q_enable_media_tuner(q);
+		if (ret)
+			return ret;
 		ret = vb2_start_streaming(q);
 		if (ret) {
 			__vb2_queue_cancel(q);
-- 
2.5.0
