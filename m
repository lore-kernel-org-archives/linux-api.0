From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 19/22] media: au0828-core register entity_notify hook
Date: Wed,  3 Feb 2016 21:03:51 -0700
Message-ID: <90c306d638c26bc5abb35d39d33772270d3abb1b.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Register entity_notify async hook to create links
between existing bridge driver entities and a newly
added non-bridge driver entities. For example, this
handler creates link between V4L decoder entity and
ALSA mixer entity.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 43 ++++++++++++++++++++++++++++++++--
 drivers/media/usb/au0828/au0828.h      |  1 +
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 92d22ed..4c90f28 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -347,14 +347,42 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
 	return 0;
 }
 
+void au0828_media_graph_notify(struct media_entity *new, void *notify_data)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct au0828_dev *dev = (struct au0828_dev *) notify_data;
+	int ret;
+
+	if (!dev->decoder)
+		return;
+
+	switch (new->function) {
+	case MEDIA_ENT_F_AUDIO_MIXER:
+		ret = media_create_pad_link(dev->decoder,
+					    AU8522_PAD_AUDIO_OUT,
+					    new, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			dev_err(&dev->usbdev->dev,
+				"Mixer Pad Link Create Error: %d\n",
+				ret);
+		break;
+	default:
+		break;
+	}
+#endif
+}
+
 static int au0828_media_device_register(struct au0828_dev *dev,
 					struct usb_device *udev)
 {
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
@@ -364,6 +392,17 @@ static int au0828_media_device_register(struct au0828_dev *dev,
 			return ret;
 		}
 	}
+	/* register entity_notify callback */
+	dev->entity_notify.notify_data = (void *) dev;
+	dev->entity_notify.notify = (void *) au0828_media_graph_notify;
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
index 8276072..54379ec 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -283,6 +283,7 @@ struct au0828_dev {
 	struct media_entity *decoder;
 	struct media_entity input_ent[AU0828_MAX_INPUT];
 	struct media_pad input_pad[AU0828_MAX_INPUT];
+	struct media_entity_notify entity_notify;
 #endif
 };
 
-- 
2.5.0
