From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 09/31] media: v4l2-core add v4l_vb2q_enable_media_tuner() helper
Date: Wed,  6 Jan 2016 13:26:58 -0700
Message-ID: <ac1ad6fc9832cb922ac02eba1f916a6fb4ef97a8.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add a new v4l_vb2q_enable_media_tuner() wrapper function
to be called from v4l2-core to enable the media tuner with
videobuf2 queue, when the calling frunction has the videobuf2
queue and doesn't have the struct video_device associated with
the queue handy as in the case of vb2_core_streamon(). This
function simply calls v4l_enable_media_tuner() passing in the
pointer to struct video_device.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 21 +++++++++++++++++++++
 include/media/v4l2-dev.h           |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index f06da6e..9ef675a 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -30,6 +30,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/videobuf2-core.h>
 
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
@@ -261,6 +262,26 @@ void v4l_disable_media_tuner(struct video_device *vdev)
 }
 EXPORT_SYMBOL_GPL(v4l_disable_media_tuner);
 
+/**
+ * v4l_vb2q_enable_media_tuner - Wrapper for v4l_enable_media_tuner()
+ * @q:         videobuf2 queue
+ *
+ * This function is intended to be called from v4l2-core
+ * to enable the media tuner with videobuf2 queue, when
+ * the calling frunction has the videobuf2 queue and doesn't
+ * have the struct video_device associated with the
+ * queue handy as in the case of vb2_core_streamon(). This
+ * function simply calls v4l_enable_media_tuner() passing
+ * in the pointer to struct video_device.
+ */
+int v4l_vb2q_enable_media_tuner(struct vb2_queue *q)
+{
+	struct v4l2_fh *fh = q->owner;
+
+	return v4l_enable_media_tuner(fh->vdev);
+}
+EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_tuner);
+
 /* Priority handling */
 
 static inline bool prio_is_valid(enum v4l2_priority prio)
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 68999a3..1948097 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -179,6 +179,7 @@ struct video_device * __must_check video_device_alloc(void);
 
 int v4l_enable_media_tuner(struct video_device *vdev);
 void v4l_disable_media_tuner(struct video_device *vdev);
+int v4l_vb2q_enable_media_tuner(struct vb2_queue *q);
 
 /* this release function frees the vdev pointer */
 void video_device_release(struct video_device *vdev);
-- 
2.5.0
