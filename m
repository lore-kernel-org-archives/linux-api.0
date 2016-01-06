From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 08/31] media: v4l-core add v4l_enable/disable_media_tuner() helper functions
Date: Wed,  6 Jan 2016 13:26:57 -0700
Message-ID: <e642fee6e443170b33a8c69fbc21b409f7be5583.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add a new interfaces to be used by v4l-core to invoke enable
source and disable_source handlers in the media_device. The
enable_source helper function invokes the enable_source handler
to find tuner entity connected to the decoder and check is it
is available or busy. If tuner is available, link is activated
and pipeline is started. The disable_source helper function
invokes the disable_source handler to deactivate and stop the
pipeline.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 27 +++++++++++++++++++++++++++
 include/media/v4l2-dev.h           |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d8e5994..f06da6e 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -233,6 +233,33 @@ struct video_device *video_devdata(struct file *file)
 }
 EXPORT_SYMBOL(video_devdata);
 
+int v4l_enable_media_tuner(struct video_device *vdev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = vdev->entity.graph_obj.mdev;
+	int ret;
+
+	if (!mdev || !mdev->enable_source)
+		return 0;
+	ret = mdev->enable_source(&vdev->entity, &vdev->pipe);
+	if (ret)
+		return -EBUSY;
+	return 0;
+#endif /* CONFIG_MEDIA_CONTROLLER */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l_enable_media_tuner);
+
+void v4l_disable_media_tuner(struct video_device *vdev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = vdev->entity.graph_obj.mdev;
+
+	if (mdev && mdev->disable_source)
+		mdev->disable_source(&vdev->entity);
+#endif /* CONFIG_MEDIA_CONTROLLER */
+}
+EXPORT_SYMBOL_GPL(v4l_disable_media_tuner);
 
 /* Priority handling */
 
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index eeabf20..68999a3 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -87,6 +87,7 @@ struct video_device
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_entity entity;
 	struct media_intf_devnode *intf_devnode;
+	struct media_pipeline pipe;
 #endif
 	/* device ops */
 	const struct v4l2_file_operations *fops;
@@ -176,6 +177,9 @@ void video_unregister_device(struct video_device *vdev);
    latter can also be used for video_device->release(). */
 struct video_device * __must_check video_device_alloc(void);
 
+int v4l_enable_media_tuner(struct video_device *vdev);
+void v4l_disable_media_tuner(struct video_device *vdev);
+
 /* this release function frees the vdev pointer */
 void video_device_release(struct video_device *vdev);
 
-- 
2.5.0
