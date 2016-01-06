From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 20/31] media: au0828 change to register/unregister entity_notify hook
Date: Wed,  6 Jan 2016 13:27:09 -0700
Message-ID: <8ba7a2bcf7cde4d9361205c08ef5fca116b3973f.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

au0828 registers entity_notify hook to create media graph for
the device. This handler runs whenvere a new entity gets added
to the media device. It creates necessary links from video, vbi,
and ALSA entities to decoder and links tuner and decoder entities.
As this handler runs as entities get added, it has to maintain
state on the links it already created. New fields are added to
au0828_dev to keep this state information. entity_notify gets
unregistered before media_device unregister.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 104 +++++++++++++++++++++++----------
 drivers/media/usb/au0828/au0828.h      |   6 ++
 2 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 6ef177c..a381660 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -137,6 +137,8 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev &&
 		media_devnode_is_registered(&dev->media_dev->devnode)) {
+		media_device_unregister_entity_notify(dev->media_dev,
+						      &dev->entity_notify);
 		media_device_unregister(dev->media_dev);
 		media_device_cleanup(dev->media_dev);
 		dev->media_dev = NULL;
@@ -263,11 +265,16 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *entity;
 	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *audio_capture = NULL;
 	int i, ret;
 
 	if (!mdev)
 		return 0;
 
+	if (dev->tuner_linked && dev->vdev_linked && dev->vbi_linked &&
+	    dev->audio_capture_linked)
+		return 0;
+
 	media_device_for_each_entity(entity, mdev) {
 		switch (entity->function) {
 		case MEDIA_ENT_F_TUNER:
@@ -276,6 +283,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 		case MEDIA_ENT_F_ATV_DECODER:
 			decoder = entity;
 			break;
+		case MEDIA_ENT_F_AUDIO_CAPTURE:
+			audio_capture = entity;
+			break;
 		}
 	}
 
@@ -285,60 +295,77 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 	if (!decoder)
 		return -EINVAL;
 
-	if (tuner) {
+	if (tuner  && !dev->tuner_linked) {
+		dev->tuner = tuner;
 		ret = media_create_pad_link(tuner, TUNER_PAD_IF_OUTPUT,
 					    decoder, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
 			return ret;
+		dev->tuner_linked = 1;
 	}
-	if (dev->vdev.entity.graph_obj.mdev) {
+	if (dev->vdev.entity.graph_obj.mdev && !dev->vdev_linked) {
 		ret = media_create_pad_link(decoder, AU8522_PAD_VID_OUT,
 					    &dev->vdev.entity, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
 			return ret;
+		dev->vdev_linked = 1;
 	}
-	if (dev->vbi_dev.entity.graph_obj.mdev) {
+	if (dev->vbi_dev.entity.graph_obj.mdev && !dev->vbi_linked) {
 		ret = media_create_pad_link(decoder, AU8522_PAD_VBI_OUT,
 					    &dev->vbi_dev.entity, 0,
 					    MEDIA_LNK_FL_ENABLED);
 		if (ret)
 			return ret;
-	}
-
-	for (i = 0; i < AU0828_MAX_INPUT; i++) {
-		struct media_entity *ent = &dev->input_ent[i];
+		dev->vbi_linked = 1;
 
-		if (!ent->graph_obj.mdev)
-			continue;
+		/*
+		 * Input entities are registered before vbi entity,
+		 * create graph nodes for them after vbi is created
+		*/
+		for (i = 0; i < AU0828_MAX_INPUT; i++) {
+			struct media_entity *ent = &dev->input_ent[i];
 
-		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
-			break;
+			if (!ent->graph_obj.mdev)
+				continue;
 
-		switch (AUVI_INPUT(i).type) {
-		case AU0828_VMUX_CABLE:
-		case AU0828_VMUX_TELEVISION:
-		case AU0828_VMUX_DVB:
-			if (!tuner)
+			if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
 				break;
 
-			ret = media_create_pad_link(ent, 0, tuner,
-						    TUNER_PAD_RF_INPUT,
-						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
-				return ret;
-			break;
-		case AU0828_VMUX_COMPOSITE:
-		case AU0828_VMUX_SVIDEO:
-		default: /* AU0828_VMUX_DEBUG */
-			/* FIXME: fix the decoder PAD */
-			ret = media_create_pad_link(ent, 0, decoder, 0, 0);
-			if (ret)
-				return ret;
-			break;
+			switch (AUVI_INPUT(i).type) {
+			case AU0828_VMUX_CABLE:
+			case AU0828_VMUX_TELEVISION:
+			case AU0828_VMUX_DVB:
+				if (!tuner)
+					break;
+
+				ret = media_create_pad_link(ent, 0, tuner,
+							TUNER_PAD_RF_INPUT,
+							MEDIA_LNK_FL_ENABLED);
+				if (ret)
+					return ret;
+				break;
+			case AU0828_VMUX_COMPOSITE:
+			case AU0828_VMUX_SVIDEO:
+			default: /* AU0828_VMUX_DEBUG */
+				/* FIXME: fix the decoder PAD */
+				ret = media_create_pad_link(ent, 0, decoder,
+							    0, 0);
+				if (ret)
+					return ret;
+				break;
+			}
 		}
 	}
+	if (audio_capture && !dev->audio_capture_linked) {
+		ret = media_create_pad_link(decoder, AU8522_PAD_AUDIO_OUT,
+					    audio_capture, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+		dev->audio_capture_linked = 1;
+	}
 #endif
 	return 0;
 }
@@ -349,8 +376,10 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 #ifdef CONFIG_MEDIA_CONTROLLER
 	int ret;
 
-	if (dev->media_dev &&
-		!media_devnode_is_registered(&dev->media_dev->devnode)) {
+	if (!dev->media_dev)
+		return 0;
+
+	if (!media_devnode_is_registered(&dev->media_dev->devnode)) {
 
 		/* register media device */
 		ret = media_device_register(dev->media_dev);
@@ -360,6 +389,17 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 			return ret;
 		}
 	}
+	/* register entity_notify callback */
+	dev->entity_notify.notify_data = (void *) dev;
+	dev->entity_notify.notify = (void *) au0828_create_media_graph;
+	ret = media_device_register_entity_notify(dev->media_dev,
+						  &dev->entity_notify);
+	if (ret) {
+		dev_err(&udev->dev,
+			"Media Device register entity_notify Error: %d\n",
+			ret);
+		return ret;
+	}
 #endif
 	return 0;
 }
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 8276072..cfb6d58 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -283,6 +283,12 @@ struct au0828_dev {
 	struct media_entity *decoder;
 	struct media_entity input_ent[AU0828_MAX_INPUT];
 	struct media_pad input_pad[AU0828_MAX_INPUT];
+	struct media_entity_notify entity_notify;
+	struct media_entity *tuner;
+	bool tuner_linked;
+	bool vdev_linked;
+	bool vbi_linked;
+	bool audio_capture_linked;
 #endif
 };
 
-- 
2.5.0
