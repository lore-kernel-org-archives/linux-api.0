From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 30/31] sound/usb: Check media device unregister progress state
Date: Wed,  6 Jan 2016 13:27:19 -0700
Message-ID: <6787aacbea3c94ba42772928acaf590223e2445b.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Change to release media resources for pcm streams
and mixer before snd_card_disconnect() is done from
usb_audio_disconnect(). The stream and mixer resource
release interfaces access managed media resources
(device resources) created on the usb device parent.
These interfaces should be called before the last
put_device() which releases all the device resources.
In addition, changed the stream and mixer resource
release interfaces to check if media device unregister
is in progress and avoid calling Media Controller API
to unregister entities and remove devnodes. Media device
unregister takes care of all of this. This fixes the
the general protection faults while snd-usb-audio was
cleaning up media resources for pcm streams and mixers.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/card.c   |  8 ++++++--
 sound/usb/media.c  | 41 +++++++++++++++++++++++++++++++----------
 sound/usb/media.h  |  4 ++--
 sound/usb/stream.c |  1 -
 4 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index e965982..8959ccb 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -608,6 +608,12 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		 */
 		wait_event(chip->shutdown_wait,
 			   !atomic_read(&chip->usage_count));
+
+		/* release media pcm stream resources */
+		media_stream_delete(chip);
+		/* delete mixer media resources */
+		media_mixer_delete(chip);
+
 		snd_card_disconnect(card);
 		/* release the pcm resources */
 		list_for_each_entry(as, &chip->pcm_list, list) {
@@ -621,8 +627,6 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		list_for_each(p, &chip->midi_list) {
 			snd_usbmidi_disconnect(p);
 		}
-		/* delete mixer media resources */
-		media_mixer_delete(chip);
 		/* release mixer resources */
 		list_for_each_entry(mixer, &chip->mixer_list, list) {
 			snd_usb_mixer_disconnect(mixer);
diff --git a/sound/usb/media.c b/sound/usb/media.c
index 4f99086..9d29e1d 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -98,8 +98,11 @@ void media_device_delete(struct usb_interface *iface)
 	struct usb_device *usbdev = interface_to_usbdev(iface);
 
 	mdev = media_device_find_devres(&usbdev->dev);
-	if (mdev && media_devnode_is_registered(&mdev->devnode))
-		media_device_unregister(mdev);
+	if (mdev) {
+		if (media_devnode_is_registered(&mdev->devnode) &&
+		    !media_device_is_unregister_in_progress(mdev))
+			media_device_unregister(mdev);
+	}
 }
 
 static int media_enable_source(struct media_ctl *mctl)
@@ -177,7 +180,7 @@ int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 	return 0;
 }
 
-void media_stream_delete(struct snd_usb_substream *subs)
+static void __media_stream_delete(struct snd_usb_substream *subs)
 {
 	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
 
@@ -185,7 +188,7 @@ void media_stream_delete(struct snd_usb_substream *subs)
 		struct media_device *mdev;
 
 		mdev = media_device_find_devres(&subs->dev->dev);
-		if (mdev) {
+		if (mdev && !media_device_is_unregister_in_progress(mdev)) {
 			media_devnode_remove(mctl->intf_devnode);
 			media_device_unregister_entity(&mctl->media_entity);
 			media_entity_cleanup(&mctl->media_entity);
@@ -195,6 +198,21 @@ void media_stream_delete(struct snd_usb_substream *subs)
 	}
 }
 
+void media_stream_delete(struct snd_usb_audio *chip)
+{
+	struct snd_usb_stream *as;
+
+	list_for_each_entry(as, &chip->pcm_list, list) {
+		struct snd_usb_substream *subs;
+		int idx;
+
+		for (idx = 0; idx < 2; idx++) {
+			subs = &as->substream[idx];
+			__media_stream_delete(subs);
+		}
+	}
+}
+
 int media_start_pipeline(struct snd_usb_substream *subs)
 {
 	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
@@ -283,22 +301,25 @@ void media_mixer_delete(struct snd_usb_audio *chip)
 	struct media_device *mdev;
 
 	mdev = media_device_find_devres(&chip->dev->dev);
-	if (!mdev)
-		return;
 
+	if (chip->ctl_intf_media_devnode) {
+		if (mdev && !media_device_is_unregister_in_progress(mdev))
+			media_devnode_remove(chip->ctl_intf_media_devnode);
+		chip->ctl_intf_media_devnode = NULL;
+	}
 	list_for_each_entry(mixer, &chip->mixer_list, list) {
 		struct media_mixer_ctl *mctl;
 
 		mctl = (struct media_mixer_ctl *) mixer->media_mixer_ctl;
 		if (!mixer->media_mixer_ctl)
 			continue;
-
-		media_device_unregister_entity(&mctl->media_entity);
-		media_entity_cleanup(&mctl->media_entity);
+		if (mdev && !media_device_is_unregister_in_progress(mdev)) {
+			media_device_unregister_entity(&mctl->media_entity);
+			media_entity_cleanup(&mctl->media_entity);
+		}
 		kfree(mctl);
 		mixer->media_mixer_ctl = NULL;
 	}
-	media_devnode_remove(chip->ctl_intf_media_devnode);
 }
 
 #endif
diff --git a/sound/usb/media.h b/sound/usb/media.h
index 00884b5..bd1b1ec 100644
--- a/sound/usb/media.h
+++ b/sound/usb/media.h
@@ -52,7 +52,7 @@ int media_device_create(struct snd_usb_audio *chip,
 void media_device_delete(struct usb_interface *iface);
 int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 			int stream);
-void media_stream_delete(struct snd_usb_substream *subs);
+void media_stream_delete(struct snd_usb_audio *chip);
 int media_start_pipeline(struct snd_usb_substream *subs);
 void media_stop_pipeline(struct snd_usb_substream *subs);
 int media_mixer_init(struct snd_usb_audio *chip);
@@ -65,7 +65,7 @@ static inline void media_device_delete(struct usb_interface *iface) { }
 static inline int media_stream_init(struct snd_usb_substream *subs,
 					struct snd_pcm *pcm, int stream)
 						{ return 0; }
-static inline void media_stream_delete(struct snd_usb_substream *subs) { }
+static inline void media_stream_delete(struct snd_usb_audio *chip) { }
 static inline int media_start_pipeline(struct snd_usb_substream *subs)
 					{ return 0; }
 static inline void media_stop_pipeline(struct snd_usb_substream *subs) { }
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 789e515..f96f539 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -53,7 +53,6 @@ static void free_substream(struct snd_usb_substream *subs)
 		kfree(fp);
 	}
 	kfree(subs->rate_list.list);
-	media_stream_delete(subs);
 }
 
 
-- 
2.5.0
