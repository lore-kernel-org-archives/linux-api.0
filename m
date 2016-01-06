From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 16/31] media: au0828 video remove au0828_enable_analog_tuner()
Date: Wed,  6 Jan 2016 13:27:05 -0700
Message-ID: <b8df6a28c43cc6eab7488e4b1f7ba4bcbec17944.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

au0828_enable_analog_tuner() is no longer needed with
v4l2-core and au0828-video invoking enable_source and
disable_source handlers. In addition, it is unnecessary
to check for tuner availability in queue_setup() as
v4l2-core handles the tuner availability checks.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 61 ---------------------------------
 1 file changed, 61 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 3ea9d4f..32bcc56 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -638,64 +638,6 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 	return rc;
 }
 
-static int au0828_enable_analog_tuner(struct au0828_dev *dev)
-{
-#ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_device *mdev = dev->media_dev;
-	struct media_entity *source;
-	struct media_link *link, *found_link = NULL;
-	int ret, active_links = 0;
-
-	if (!mdev || !dev->decoder)
-		return 0;
-
-	/*
-	 * This will find the tuner that is connected into the decoder.
-	 * Technically, this is not 100% correct, as the device may be
-	 * using an analog input instead of the tuner. However, as we can't
-	 * do DVB streaming while the DMA engine is being used for V4L2,
-	 * this should be enough for the actual needs.
-	 */
-	list_for_each_entry(link, &dev->decoder->links, list) {
-		if (link->sink->entity == dev->decoder) {
-			found_link = link;
-			if (link->flags & MEDIA_LNK_FL_ENABLED)
-				active_links++;
-			break;
-		}
-	}
-
-	if (active_links == 1 || !found_link)
-		return 0;
-
-	source = found_link->source->entity;
-	list_for_each_entry(link, &source->links, list) {
-		struct media_entity *sink;
-		int flags = 0;
-
-		sink = link->sink->entity;
-
-		if (sink == dev->decoder)
-			flags = MEDIA_LNK_FL_ENABLED;
-
-		ret = media_entity_setup_link(link, flags);
-		if (ret) {
-			pr_err(
-				"Couldn't change link %s->%s to %s. Error %d\n",
-				source->name, sink->name,
-				flags ? "enabled" : "disabled",
-				ret);
-			return ret;
-		} else
-			au0828_isocdbg(
-				"link %s->%s was %s\n",
-				source->name, sink->name,
-				flags ? "ENABLED" : "disabled");
-	}
-#endif
-	return 0;
-}
-
 static int queue_setup(struct vb2_queue *vq, const void *parg,
 		       unsigned int *nbuffers, unsigned int *nplanes,
 		       unsigned int sizes[], void *alloc_ctxs[])
@@ -711,9 +653,6 @@ static int queue_setup(struct vb2_queue *vq, const void *parg,
 
 	*nplanes = 1;
 	sizes[0] = size;
-
-	au0828_enable_analog_tuner(dev);
-
 	return 0;
 }
 
-- 
2.5.0
