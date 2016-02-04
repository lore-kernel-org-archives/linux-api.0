From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 21/22] sound/usb: Use Media Controller API to share media resources
Date: Wed,  3 Feb 2016 21:03:53 -0700
Message-ID: <d6f619a817d94d4485dba566a4ba5f89a3667808.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Change ALSA driver to use Media Controller API to
share media resources with DVB and V4L2 drivers
on a AU0828 media device. Media Controller specific
initialization is done after sound card is registered.
ALSA creates Media interface and entity function graph
nodes for Control, Mixer, PCM Playback, and PCM Capture
devices.

snd_usb_hw_params() will call Media Controller enable
source handler interface to request the media resource.
If resource request is granted, it will release it from
snd_usb_hw_free(). If resource is busy, -EBUSY is returned.

Media specific cleanup is done in usb_audio_disconnect().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/Kconfig        |   4 +
 sound/usb/Makefile       |   2 +
 sound/usb/card.c         |  14 +++
 sound/usb/card.h         |   1 +
 sound/usb/media.c        | 319 +++++++++++++++++++++++++++++++++++++++++++++++
 sound/usb/media.h        |  72 +++++++++++
 sound/usb/mixer.h        |   1 +
 sound/usb/pcm.c          |  28 ++++-
 sound/usb/quirks-table.h |   1 +
 sound/usb/stream.c       |   2 +
 sound/usb/usbaudio.h     |   3 +
 11 files changed, 442 insertions(+), 5 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index a452ad7..1a71d93 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -15,6 +15,7 @@ config SND_USB_AUDIO
 	select SND_RAWMIDI
 	select SND_PCM
 	select BITREVERSE
+	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER	if MEDIA_CONTROLLER
 	help
 	  Say Y here to include support for USB audio and USB MIDI
 	  devices.
@@ -22,6 +23,9 @@ config SND_USB_AUDIO
 	  To compile this driver as a module, choose M here: the module
 	  will be called snd-usb-audio.
 
+config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
+	bool
+
 config SND_USB_UA101
 	tristate "Edirol UA-101/UA-1000 driver"
 	select SND_PCM
diff --git a/sound/usb/Makefile b/sound/usb/Makefile
index 2d2d122..8dca3c4 100644
--- a/sound/usb/Makefile
+++ b/sound/usb/Makefile
@@ -15,6 +15,8 @@ snd-usb-audio-objs := 	card.o \
 			quirks.o \
 			stream.o
 
+snd-usb-audio-$(CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER) += media.o
+
 snd-usbmidi-lib-objs := midi.o
 
 # Toplevel Module Dependency
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 1f09d95..35fe256 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -66,6 +66,7 @@
 #include "format.h"
 #include "power.h"
 #include "stream.h"
+#include "media.h"
 
 MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
 MODULE_DESCRIPTION("USB Audio");
@@ -561,6 +562,11 @@ static int usb_audio_probe(struct usb_interface *intf,
 	if (err < 0)
 		goto __error;
 
+	if (quirk->media_device) {
+		/* don't want to fail when media_device_create() fails */
+		media_device_create(chip, intf);
+	}
+
 	usb_chip[chip->index] = chip;
 	chip->num_interfaces++;
 	usb_set_intfdata(intf, chip);
@@ -617,6 +623,14 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		list_for_each(p, &chip->midi_list) {
 			snd_usbmidi_disconnect(p);
 		}
+		/*
+		 * Nice to check quirk && quirk->media_device
+		 * need some special handlings. Doesn't look like
+		 * we have access to quirk here
+		 * Acceses mixer_list
+		*/
+		media_device_delete(chip);
+
 		/* release mixer resources */
 		list_for_each_entry(mixer, &chip->mixer_list, list) {
 			snd_usb_mixer_disconnect(mixer);
diff --git a/sound/usb/card.h b/sound/usb/card.h
index 71778ca..c15a03c 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -156,6 +156,7 @@ struct snd_usb_substream {
 	} dsd_dop;
 
 	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
+	void *media_ctl;
 };
 
 struct snd_usb_stream {
diff --git a/sound/usb/media.c b/sound/usb/media.c
new file mode 100644
index 0000000..8fef48e
--- /dev/null
+++ b/sound/usb/media.c
@@ -0,0 +1,319 @@
+/*
+ * media.c - Media Controller specific ALSA driver code
+ *
+ * Copyright (c) 2015 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+
+/*
+ * This file adds Media Controller support to ALSA driver
+ * to use the Media Controller API to share tuner with DVB
+ * and V4L2 drivers that control media device. Media device
+ * is created based on existing quirks framework. Using this
+ * approach, the media controller API usage can be added for
+ * a specific device.
+*/
+
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+
+#include <sound/pcm.h>
+#include <sound/core.h>
+
+#include "usbaudio.h"
+#include "card.h"
+#include "mixer.h"
+#include "media.h"
+
+static int media_enable_source(struct media_ctl *mctl)
+{
+	if (mctl && mctl->media_dev->enable_source)
+		return mctl->media_dev->enable_source(&mctl->media_entity,
+						      &mctl->media_pipe);
+	return 0;
+}
+
+static void media_disable_source(struct media_ctl *mctl)
+{
+	if (mctl && mctl->media_dev->disable_source)
+		mctl->media_dev->disable_source(&mctl->media_entity);
+}
+
+int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
+			int stream)
+{
+	struct media_device *mdev;
+	struct media_ctl *mctl;
+	struct device *pcm_dev = &pcm->streams[stream].dev;
+	u32 intf_type;
+	int ret = 0;
+	u16 mixer_pad;
+	struct media_entity *entity;
+
+	mdev = subs->stream->chip->media_dev;
+	if (!mdev)
+		return -ENODEV;
+
+	if (subs->media_ctl)
+		return 0;
+
+	/* allocate media_ctl */
+	mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
+	if (!mctl)
+		return -ENOMEM;
+
+	mctl->media_dev = mdev;
+	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
+		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_PLAYBACK;
+		mctl->media_pad.flags = MEDIA_PAD_FL_SOURCE;
+		mixer_pad = 1;
+	} else {
+		intf_type = MEDIA_INTF_T_ALSA_PCM_CAPTURE;
+		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_CAPTURE;
+		mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
+		mixer_pad = 2;
+	}
+	mctl->media_entity.name = pcm->name;
+	media_entity_pads_init(&mctl->media_entity, 1, &mctl->media_pad);
+	ret =  media_device_register_entity(mctl->media_dev,
+					    &mctl->media_entity);
+	if (ret)
+		goto err1;
+
+	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
+						  MAJOR(pcm_dev->devt),
+						  MINOR(pcm_dev->devt));
+	if (!mctl->intf_devnode) {
+		ret = -ENOMEM;
+		goto err2;
+	}
+	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
+						 &mctl->intf_devnode->intf,
+						 MEDIA_LNK_FL_ENABLED);
+	if (!mctl->intf_link) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	/* create link between mixer and audio */
+	media_device_for_each_entity(entity, mdev) {
+		switch (entity->function) {
+		case MEDIA_ENT_F_AUDIO_MIXER:
+			ret = media_create_pad_link(entity, mixer_pad,
+						    &mctl->media_entity, 0,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				goto err4;
+			break;
+		}
+	}
+
+	subs->media_ctl = mctl;
+	return 0;
+
+err4:
+	media_remove_intf_link(mctl->intf_link);
+err3:
+	media_devnode_remove(mctl->intf_devnode);
+err2:
+	media_device_unregister_entity(&mctl->media_entity);
+err1:
+	kfree(mctl);
+	return ret;
+}
+
+void media_stream_delete(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = subs->media_ctl;
+
+	if (mctl && mctl->media_dev) {
+		struct media_device *mdev;
+
+		mdev = subs->stream->chip->media_dev;
+		if (mdev && media_devnode_is_registered(&mdev->devnode)) {
+			media_devnode_remove(mctl->intf_devnode);
+			media_device_unregister_entity(&mctl->media_entity);
+			media_entity_cleanup(&mctl->media_entity);
+		}
+		kfree(mctl);
+		subs->media_ctl = NULL;
+	}
+}
+
+int media_start_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = subs->media_ctl;
+
+	if (mctl)
+		return media_enable_source(mctl);
+	return 0;
+}
+
+void media_stop_pipeline(struct snd_usb_substream *subs)
+{
+	struct media_ctl *mctl = subs->media_ctl;
+
+	if (mctl)
+		media_disable_source(mctl);
+}
+
+int media_mixer_init(struct snd_usb_audio *chip)
+{
+	struct device *ctl_dev = &chip->card->ctl_dev;
+	struct media_intf_devnode *ctl_intf;
+	struct usb_mixer_interface *mixer;
+	struct media_device *mdev = chip->media_dev;
+	struct media_mixer_ctl *mctl;
+	u32 intf_type = MEDIA_INTF_T_ALSA_CONTROL;
+	int ret;
+
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
+static void media_mixer_delete(struct snd_usb_audio *chip)
+{
+	struct usb_mixer_interface *mixer;
+	struct media_device *mdev = chip->media_dev;
+
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
+		if (media_devnode_is_registered(&mdev->devnode)) {
+			media_device_unregister_entity(&mctl->media_entity);
+			media_entity_cleanup(&mctl->media_entity);
+		}
+		kfree(mctl);
+		mixer->media_mixer_ctl = NULL;
+	}
+	if (media_devnode_is_registered(&mdev->devnode))
+		media_devnode_remove(chip->ctl_intf_media_devnode);
+	chip->ctl_intf_media_devnode = NULL;
+}
+
+int media_device_create(struct snd_usb_audio *chip,
+			struct usb_interface *iface)
+{
+	struct media_device *mdev;
+	struct usb_device *usbdev = interface_to_usbdev(iface);
+	int ret;
+
+	mdev = media_device_get_devres(&usbdev->dev);
+	if (!mdev)
+		return -ENOMEM;
+	if (!mdev->dev) {
+		/* register media device */
+		mdev->dev = &usbdev->dev;
+		if (usbdev->product)
+			strlcpy(mdev->model, usbdev->product,
+				sizeof(mdev->model));
+		if (usbdev->serial)
+			strlcpy(mdev->serial, usbdev->serial,
+				sizeof(mdev->serial));
+		strcpy(mdev->bus_info, usbdev->devpath);
+		mdev->hw_revision = le16_to_cpu(usbdev->descriptor.bcdDevice);
+		media_device_init(mdev);
+	}
+	if (!media_devnode_is_registered(&mdev->devnode)) {
+		ret = media_device_register(mdev);
+		if (ret) {
+			dev_err(&usbdev->dev,
+				"Couldn't register media device. Error: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	/* save media device - avoid lookups */
+	chip->media_dev = mdev;
+
+	/* Create media entities for mixer and control dev */
+	ret = media_mixer_init(chip);
+	if (ret) {
+		dev_err(&usbdev->dev,
+			"Couldn't create media mixer entities. Error: %d\n",
+			ret);
+
+		/* clear saved media_dev */
+		chip->media_dev = NULL;
+
+		return ret;
+	}
+	return 0;
+}
+
+void media_device_delete(struct snd_usb_audio *chip)
+{
+	struct media_device *mdev = chip->media_dev;
+
+	media_mixer_delete(chip);
+
+	if (mdev) {
+		if (media_devnode_is_registered(&mdev->devnode))
+			media_device_unregister(mdev);
+		chip->media_dev = NULL;
+	}
+}
diff --git a/sound/usb/media.h b/sound/usb/media.h
new file mode 100644
index 0000000..b5f451a
--- /dev/null
+++ b/sound/usb/media.h
@@ -0,0 +1,72 @@
+/*
+ * media.h - Media Controller specific ALSA driver code
+ *
+ * Copyright (c) 2015 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2015 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+
+/*
+ * This file adds Media Controller support to ALSA driver
+ * to use the Media Controller API to share tuner with DVB
+ * and V4L2 drivers that control media device. Media device
+ * is created based on existing quirks framework. Using this
+ * approach, the media controller API usage can be added for
+ * a specific device.
+*/
+#ifndef __MEDIA_H
+
+#ifdef CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER
+
+#include <media/media-device.h>
+#include <media/media-entity.h>
+#include <sound/asound.h>
+
+struct media_ctl {
+	struct media_device *media_dev;
+	struct media_entity media_entity;
+	struct media_intf_devnode *intf_devnode;
+	struct media_link *intf_link;
+	struct media_pad media_pad;
+	struct media_pipeline media_pipe;
+};
+
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
+int media_device_create(struct snd_usb_audio *chip,
+			struct usb_interface *iface);
+void media_device_delete(struct snd_usb_audio *chip);
+int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
+			int stream);
+void media_stream_delete(struct snd_usb_substream *subs);
+int media_start_pipeline(struct snd_usb_substream *subs);
+void media_stop_pipeline(struct snd_usb_substream *subs);
+#else
+static inline int media_device_create(struct snd_usb_audio *chip,
+				      struct usb_interface *iface)
+						{ return 0; }
+static inline void media_device_delete(struct snd_usb_audio *chip) { }
+static inline int media_stream_init(struct snd_usb_substream *subs,
+					struct snd_pcm *pcm, int stream)
+						{ return 0; }
+static inline void media_stream_delete(struct snd_usb_substream *subs) { }
+static inline int media_start_pipeline(struct snd_usb_substream *subs)
+					{ return 0; }
+static inline void media_stop_pipeline(struct snd_usb_substream *subs) { }
+#endif
+#endif /* __MEDIA_H */
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
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 9245f52..c3b8486 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -35,6 +35,7 @@
 #include "pcm.h"
 #include "clock.h"
 #include "power.h"
+#include "media.h"
 
 #define SUBSTREAM_FLAG_DATA_EP_STARTED	0
 #define SUBSTREAM_FLAG_SYNC_EP_STARTED	1
@@ -715,10 +716,14 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	struct audioformat *fmt;
 	int ret;
 
+	ret = media_start_pipeline(subs);
+	if (ret)
+		return ret;
+
 	ret = snd_pcm_lib_alloc_vmalloc_buffer(substream,
 					       params_buffer_bytes(hw_params));
 	if (ret < 0)
-		return ret;
+		goto err_ret;
 
 	subs->pcm_format = params_format(hw_params);
 	subs->period_bytes = params_period_bytes(hw_params);
@@ -732,22 +737,27 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		dev_dbg(&subs->dev->dev,
 			"cannot set format: format = %#x, rate = %d, channels = %d\n",
 			   subs->pcm_format, subs->cur_rate, subs->channels);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_ret;
 	}
 
 	ret = snd_usb_lock_shutdown(subs->stream->chip);
 	if (ret < 0)
-		return ret;
+		goto err_ret;
 	ret = set_format(subs, fmt);
 	snd_usb_unlock_shutdown(subs->stream->chip);
 	if (ret < 0)
-		return ret;
+		goto err_ret;
 
 	subs->interface = fmt->iface;
 	subs->altset_idx = fmt->altset_idx;
 	subs->need_setup_ep = true;
 
 	return 0;
+
+err_ret:
+	media_stop_pipeline(subs);
+	return ret;
 }
 
 /*
@@ -759,6 +769,7 @@ static int snd_usb_hw_free(struct snd_pcm_substream *substream)
 {
 	struct snd_usb_substream *subs = substream->runtime->private_data;
 
+	media_stop_pipeline(subs);
 	subs->cur_audiofmt = NULL;
 	subs->cur_rate = 0;
 	subs->period_bytes = 0;
@@ -1219,6 +1230,7 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_stream *as = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct snd_usb_substream *subs = &as->substream[direction];
+	int ret;
 
 	subs->interface = -1;
 	subs->altset_idx = 0;
@@ -1232,7 +1244,12 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
 	subs->dsd_dop.channel = 0;
 	subs->dsd_dop.marker = 1;
 
-	return setup_hw_info(runtime, subs);
+	ret = setup_hw_info(runtime, subs);
+	if (ret == 0)
+		ret = media_stream_init(subs, as->pcm, direction);
+	if (ret)
+		snd_usb_autosuspend(subs->stream->chip);
+	return ret;
 }
 
 static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
@@ -1241,6 +1258,7 @@ static int snd_usb_pcm_close(struct snd_pcm_substream *substream, int direction)
 	struct snd_usb_substream *subs = &as->substream[direction];
 
 	stop_endpoints(subs, true);
+	media_stop_pipeline(subs);
 
 	if (subs->interface >= 0 &&
 	    !snd_usb_lock_shutdown(subs->stream->chip)) {
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index c60a776..9d087b1 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2886,6 +2886,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.product_name = pname, \
 		.ifnum = QUIRK_ANY_INTERFACE, \
 		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
+		.media_device = 1, \
 	} \
 }
 
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index c4dc577..6c7f5c1 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -36,6 +36,7 @@
 #include "format.h"
 #include "clock.h"
 #include "stream.h"
+#include "media.h"
 
 /*
  * free a substream
@@ -52,6 +53,7 @@ static void free_substream(struct snd_usb_substream *subs)
 		kfree(fp);
 	}
 	kfree(subs->rate_list.list);
+	media_stream_delete(subs);
 }
 
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index b665d85..0c0a86c 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -60,6 +60,8 @@ struct snd_usb_audio {
 	bool autoclock;			/* from the 'autoclock' module param */
 
 	struct usb_host_interface *ctrl_intf;	/* the audio control interface */
+	void *media_dev;
+	void *ctl_intf_media_devnode;
 };
 
 #define usb_audio_err(chip, fmt, args...) \
@@ -110,6 +112,7 @@ struct snd_usb_audio_quirk {
 	const char *product_name;
 	int16_t ifnum;
 	uint16_t type;
+	bool media_device;
 	const void *data;
 };
 
-- 
2.5.0
