From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 20/22] media: au0828 add enable, disable source handlers
Date: Wed,  3 Feb 2016 21:03:52 -0700
Message-ID: <1ebb3d41fa42581f8741e493f3109357ad1a0b3c.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Add enable_source and disable_source handlers.
The enable source handler is called from
v4l2-core, dvb-core, and ALSA drivers to check
if the shared media source is free. The disable
source handler is called to release the shared
media source.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 149 +++++++++++++++++++++++++++++++++
 drivers/media/usb/au0828/au0828.h      |   3 +
 2 files changed, 152 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 4c90f28..fd2265c 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -282,6 +282,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		return -EINVAL;
 
 	if (tuner) {
+		dev->tuner = tuner;
 		/* create tuner to decoder link in deactivated state */
 		ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
 					    decoder, 0, 0);
@@ -373,6 +374,150 @@ void au0828_media_graph_notify(struct media_entity *new, void *notify_data)
 #endif
 }
 
+static int au0828_enable_source(struct media_entity *entity,
+				struct media_pipeline *pipe)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity  *source;
+	struct media_entity *sink;
+	struct media_link *link, *found_link = NULL;
+	int ret = 0;
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return -ENODEV;
+
+	/* for Audio and Video entities, source is the decoder */
+	mutex_lock(&mdev->graph_mutex);
+
+	dev = mdev->source_priv;
+	if (!dev->tuner || !dev->decoder) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	/*
+	 * For Audio and V4L2 entity, find the link to which decoder
+	 * is the sink. Look for an active link between decoder and
+	 * tuner, if one exists, nothing to do. If not, look for any
+	 * active links between tuner and any other entity. If one
+	 * exists, tuner is busy. If tuner is free, setup link and
+	 * start pipeline from source (tuner).
+	 * For DVB FE entity, the source for the link is the tuner.
+	 * Check if tuner is available and setup link and start
+	 * pipeline.
+	*/
+	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
+		sink = dev->decoder;
+	else
+		sink = entity;
+
+	/* Is an active link between sink and tuner */
+	if (dev->active_link) {
+		if (dev->active_link->sink->entity == sink &&
+		    dev->active_link->source->entity == dev->tuner) {
+			ret = 0;
+			goto end;
+		} else {
+			ret = -EBUSY;
+			goto end;
+		}
+	}
+
+	list_for_each_entry(link, &sink->links, list) {
+		/* Check sink, and source */
+		if (link->sink->entity == sink &&
+		    link->source->entity == dev->tuner) {
+			found_link = link;
+			break;
+		}
+	}
+
+	if (!found_link) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	/* activate link between source and sink and start pipeline */
+	source = found_link->source->entity;
+	ret = __media_entity_setup_link(found_link, MEDIA_LNK_FL_ENABLED);
+	if (ret) {
+		pr_err(
+			"Activate tuner link %s->%s. Error %d\n",
+			source->name, sink->name, ret);
+		goto end;
+	}
+
+	ret = __media_entity_pipeline_start(entity, pipe);
+	if (ret) {
+		pr_err("Start Pipeline: %s->%s Error %d\n",
+			source->name, entity->name, ret);
+		ret = __media_entity_setup_link(found_link, 0);
+		pr_err("Deactive link Error %d\n", ret);
+		goto end;
+	}
+	/*
+	 * save active link and active link owner to avoid audio
+	 * deactivating video owned link from disable_source and
+	 * vice versa
+	*/
+	dev->active_link = found_link;
+	dev->active_link_owner = entity;
+end:
+	mutex_unlock(&mdev->graph_mutex);
+	pr_debug("au0828_enable_source() end %s %d %d\n",
+		entity->name, entity->function, ret);
+	return ret;
+#endif
+	return 0;
+}
+
+static void au0828_disable_source(struct media_entity *entity)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_entity *sink;
+	int ret = 0;
+	struct media_device *mdev = entity->graph_obj.mdev;
+	struct au0828_dev *dev;
+
+	if (!mdev)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+	dev = mdev->source_priv;
+	if (!dev->tuner || !dev->decoder || !dev->active_link) {
+		ret = -ENODEV;
+		goto end;
+	}
+
+	if (entity->function != MEDIA_ENT_F_DTV_DEMOD)
+		sink = dev->decoder;
+	else
+		sink = entity;
+
+	/* link is active - stop pipeline from source (tuner) */
+	if (dev->active_link && dev->active_link->sink->entity == sink &&
+	    dev->active_link->source->entity == dev->tuner) {
+		/*
+		 * prevent video from deactivating link when audio
+		 * has active pipeline
+		*/
+		if (dev->active_link_owner != entity)
+			goto end;
+		__media_entity_pipeline_stop(entity);
+		ret = __media_entity_setup_link(dev->active_link, 0);
+		if (ret)
+			pr_err("Deactive link Error %d\n", ret);
+		dev->active_link = NULL;
+		dev->active_link_owner = NULL;
+	}
+
+end:
+	mutex_unlock(&mdev->graph_mutex);
+#endif
+}
+
 static int au0828_media_device_register(struct au0828_dev *dev,
 					struct usb_device *udev)
 {
@@ -403,6 +548,10 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 			ret);
 		return ret;
 	}
+	/* set enable_source */
+	dev->media_dev->source_priv = (void *) dev;
+	dev->media_dev->enable_source = au0828_enable_source;
+	dev->media_dev->disable_source = au0828_disable_source;
 #endif
 	return 0;
 }
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 54379ec..a7c88a1 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -284,6 +284,9 @@ struct au0828_dev {
 	struct media_entity input_ent[AU0828_MAX_INPUT];
 	struct media_pad input_pad[AU0828_MAX_INPUT];
 	struct media_entity_notify entity_notify;
+	struct media_entity *tuner;
+	struct media_link *active_link;
+	struct media_entity *active_link_owner;
 #endif
 };
 
-- 
2.5.0
