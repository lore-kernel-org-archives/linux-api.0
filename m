From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 30/31] sound/usb: Check media device unregister progress state
Date: Thu, 14 Jan 2016 12:52:30 -0700
Message-ID: <75db5354c03727a38fc83849cab4af095a3cf4e6.1452800274.git.shuahkh@osg.samsung.com>
References: <fd72f02797d595fc1c53b16fccec4d204430995e.1452800273.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fd72f02797d595fc1c53b16fccec4d204430995e.1452800273.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1452800265.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1452800265.git.shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs-mcfjX3dozePR7s880joybQ@public.gmane.org, johan-v8HUHnYb0Yo@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.orga
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

Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
Changes since v1:
- Rebased after patch 26 v2 work.
- No changes to patch.

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
index da58378..93c2bdd 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -77,8 +77,11 @@ void media_device_delete(struct usb_interface *iface)
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
@@ -156,7 +159,7 @@ int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 	return 0;
 }
 
-void media_stream_delete(struct snd_usb_substream *subs)
+static void __media_stream_delete(struct snd_usb_substream *subs)
 {
 	struct media_ctl *mctl = (struct media_ctl *) subs->media_ctl;
 
@@ -164,7 +167,7 @@ void media_stream_delete(struct snd_usb_substream *subs)
 		struct media_device *mdev;
 
 		mdev = media_device_find_devres(&subs->dev->dev);
-		if (mdev) {
+		if (mdev && !media_device_is_unregister_in_progress(mdev)) {
 			media_devnode_remove(mctl->intf_devnode);
 			media_device_unregister_entity(&mctl->media_entity);
 			media_entity_cleanup(&mctl->media_entity);
@@ -174,6 +177,21 @@ void media_stream_delete(struct snd_usb_substream *subs)
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
@@ -262,20 +280,23 @@ void media_mixer_delete(struct snd_usb_audio *chip)
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
diff --git a/sound/usb/media.h b/sound/usb/media.h
index 9477ffa..09854da 100644
--- a/sound/usb/media.h
+++ b/sound/usb/media.h
@@ -54,7 +54,7 @@ int media_device_create(struct snd_usb_audio *chip,
 void media_device_delete(struct usb_interface *iface);
 int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
 			int stream);
-void media_stream_delete(struct snd_usb_substream *subs);
+void media_stream_delete(struct snd_usb_audio *chip);
 int media_start_pipeline(struct snd_usb_substream *subs);
 void media_stop_pipeline(struct snd_usb_substream *subs);
 int media_mixer_init(struct snd_usb_audio *chip);
@@ -67,7 +67,7 @@ static inline void media_device_delete(struct usb_interface *iface) { }
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
