From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v3 27/31] sound/usb: Create media mixer function and control interface entities
Date: Mon, 18 Jan 2016 16:29:34 -0700
Message-ID: <c61358f0f1c4890fb7f62a6ef7c29b534bebadd4.1453158167.git.shuahkh@osg.samsung.com>
References: <cover.1453158165.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1453158165.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add support for creating MEDIA_ENT_F_AUDIO_MIXER entity for
each mixer and a MEDIA_INTF_T_ALSA_CONTROL control interface
entity that links to mixer entities. MEDIA_INTF_T_ALSA_CONTROL
entity corresponds to the control device for the card.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
Changes since v2:
- Rebase patch after patch 26 v3 work.
- Remove unnecessary casts.
Changes since v1:
- Rebase after patch 26 v2 work.
- Fixed warnings in stub defines when
  CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER
  is disabled

 sound/usb/card.c     |  5 +++
 sound/usb/media.c    | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/media.h    | 21 ++++++++++++
 sound/usb/mixer.h    |  1 +
 sound/usb/usbaudio.h |  1 +
 5 files changed, 119 insertions(+)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 1a63851..e965982 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -562,6 +562,9 @@ static int usb_audio_probe(struct usb_interface *intf,
 	if (err < 0)
 		goto __error;
 
+	/* Create media entities for mixer and control dev */
+	media_mixer_init(chip);
+
 	usb_chip[chip->index] = chip;
 	chip->num_interfaces++;
 	usb_set_intfdata(intf, chip);
@@ -618,6 +621,8 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		list_for_each(p, &chip->midi_list) {
 			snd_usbmidi_disconnect(p);
 		}
+		/* delete mixer media resources */
+		media_mixer_delete(chip);
 		/* release mixer resources */
 		list_for_each_entry(mixer, &chip->mixer_list, list) {
 			snd_usb_mixer_disconnect(mixer);
diff --git a/sound/usb/media.c b/sound/usb/media.c
index c575b33..e4fc3e9 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -23,9 +23,11 @@
 #include <linux/usb.h>
 
 #include <sound/pcm.h>
+#include <sound/core.h>
 
 #include "usbaudio.h"
 #include "card.h"
+#include "mixer.h"
 #include "media.h"
 
 int media_device_create(struct snd_usb_audio *chip,
@@ -188,3 +190,92 @@ void media_stop_pipeline(struct snd_usb_substream *subs)
 	if (mctl)
 		media_disable_source(mctl);
 }
+
+int media_mixer_init(struct snd_usb_audio *chip)
+{
+	struct device *ctl_dev = &chip->card->ctl_dev;
+	struct media_intf_devnode *ctl_intf;
+	struct usb_mixer_interface *mixer;
+	struct media_device *mdev;
+	struct media_mixer_ctl *mctl;
+	u32 intf_type = MEDIA_INTF_T_ALSA_CONTROL;
+	int ret;
+
+	mdev = media_device_find_devres(&chip->dev->dev);
+	if (!mdev)
+		return -ENODEV;
+
+	ctl_intf = chip->ctl_intf_media_devnode;
+	if (!ctl_intf) {
+		ctl_intf = (void *) media_devnode_create(mdev,
+							 intf_type, 0,
+							 MAJOR(ctl_dev->devt),
+							 MINOR(ctl_dev->devt));
+		if (!ctl_intf)
+			return -ENOMEM;
+		chip->ctl_intf_media_devnode = ctl_intf;
+	}
+
+	list_for_each_entry(mixer, &chip->mixer_list, list) {
+
+		if (mixer->media_mixer_ctl)
+			continue;
+
+		/* allocate media_mixer_ctl */
+		mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
+		if (!mctl)
+			return -ENOMEM;
+
+		mctl->media_dev = mdev;
+		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_MIXER;
+		mctl->media_entity.name = chip->card->mixername;
+		mctl->media_pad[0].flags = MEDIA_PAD_FL_SINK;
+		mctl->media_pad[1].flags = MEDIA_PAD_FL_SOURCE;
+		mctl->media_pad[2].flags = MEDIA_PAD_FL_SOURCE;
+		media_entity_pads_init(&mctl->media_entity, MEDIA_MIXER_PAD_MAX,
+				  mctl->media_pad);
+		ret =  media_device_register_entity(mctl->media_dev,
+						    &mctl->media_entity);
+		if (ret) {
+			kfree(mctl);
+			return ret;
+		}
+
+		mctl->intf_link = media_create_intf_link(&mctl->media_entity,
+							 &ctl_intf->intf,
+							 MEDIA_LNK_FL_ENABLED);
+		if (!mctl->intf_link) {
+			media_device_unregister_entity(&mctl->media_entity);
+			media_entity_cleanup(&mctl->media_entity);
+			kfree(mctl);
+			return -ENOMEM;
+		}
+		mctl->intf_devnode = ctl_intf;
+		mixer->media_mixer_ctl = mctl;
+	}
+	return 0;
+}
+
+void media_mixer_delete(struct snd_usb_audio *chip)
+{
+	struct usb_mixer_interface *mixer;
+	struct media_device *mdev;
+
+	mdev = media_device_find_devres(&chip->dev->dev);
+	if (!mdev)
+		return;
+
+	list_for_each_entry(mixer, &chip->mixer_list, list) {
+		struct media_mixer_ctl *mctl;
+
+		mctl = mixer->media_mixer_ctl;
+		if (!mixer->media_mixer_ctl)
+			continue;
+
+		media_device_unregister_entity(&mctl->media_entity);
+		media_entity_cleanup(&mctl->media_entity);
+		kfree(mctl);
+		mixer->media_mixer_ctl = NULL;
+	}
+	media_devnode_remove(chip->ctl_intf_media_devnode);
+}
diff --git a/sound/usb/media.h b/sound/usb/media.h
index 698c2a4..d6a8dca 100644
--- a/sound/usb/media.h
+++ b/sound/usb/media.h
@@ -21,6 +21,7 @@
 
 #include <media/media-device.h>
 #include <media/media-entity.h>
+#include <sound/asound.h>
 
 struct media_ctl {
 	struct media_device *media_dev;
@@ -31,6 +32,22 @@ struct media_ctl {
 	struct media_pipeline media_pipe;
 };
 
+/*
+ * One source pad each for SNDRV_PCM_STREAM_CAPTURE and
+ * SNDRV_PCM_STREAM_PLAYBACK. One for sink pad to link
+ * to AUDIO Source
+*/
+#define MEDIA_MIXER_PAD_MAX    (SNDRV_PCM_STREAM_LAST + 2)
+
+struct media_mixer_ctl {
+	struct media_device *media_dev;
+	struct media_entity media_entity;
+	struct media_intf_devnode *intf_devnode;
+	struct media_link *intf_link;
+	struct media_pad media_pad[MEDIA_MIXER_PAD_MAX];
+	struct media_pipeline media_pipe;
+};
+
 int media_device_create(struct snd_usb_audio *chip,
 			struct usb_interface *iface);
 void media_device_delete(struct usb_interface *iface);
@@ -39,6 +56,8 @@ int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 void media_stream_delete(struct snd_usb_substream *subs);
 int media_start_pipeline(struct snd_usb_substream *subs);
 void media_stop_pipeline(struct snd_usb_substream *subs);
+int media_mixer_init(struct snd_usb_audio *chip);
+void media_mixer_delete(struct snd_usb_audio *chip);
 #else
 static inline int media_device_create(struct snd_usb_audio *chip,
 				      struct usb_interface *iface)
@@ -51,5 +70,7 @@ static inline void media_stream_delete(struct snd_usb_substream *subs) { }
 static inline int media_start_pipeline(struct snd_usb_substream *subs)
 					{ return 0; }
 static inline void media_stop_pipeline(struct snd_usb_substream *subs) { }
+static inline int media_mixer_init(struct snd_usb_audio *chip) { return 0; }
+static inline void media_mixer_delete(struct snd_usb_audio *chip) { }
 #endif
 #endif /* __MEDIA_H */
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 3417ef3..787b352 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -22,6 +22,7 @@ struct usb_mixer_interface {
 	struct urb *rc_urb;
 	struct usb_ctrlrequest *rc_setup_packet;
 	u8 rc_buffer[6];
+	void *media_mixer_ctl;
 };
 
 #define MAX_CHANNELS	16	/* max logical channels */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index e3fac29..490b16a 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -60,6 +60,7 @@ struct snd_usb_audio {
 	bool autoclock;			/* from the 'autoclock' module param */
 
 	struct usb_host_interface *ctrl_intf;	/* the audio control interface */
+	void *ctl_intf_media_devnode;
 };
 
 #define usb_audio_err(chip, fmt, args...) \
-- 
2.5.0
