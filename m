From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v2 04/22] media: Media Controller enable/disable source handler API
Date: Wed,  3 Feb 2016 21:03:36 -0700
Message-ID: <ea4c54aba28ea5ec8e31fbea6f09ca527bb7984f.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com, j.anaszewski@samsung.com, geliangtang
List-Id: linux-api@vger.kernel.org

Add new fields to struct media_device to add enable_source, and
disable_source handlers, and source_priv to stash driver private
data that is used to run these handlers. The enable_source handler
finds source entity for the passed in entity and checks if it is
available. When link is found, it activates it. Disable source
handler deactivates the link.

Bridge driver is expected to implement and set these handlers.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/media/media-device.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index bad8242a..9415f1b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -333,6 +333,25 @@ struct media_device {
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
 
+	/* Handlers to find source entity for the sink entity and
+	 * check if it is available, and activate the link using
+	 * media_entity_setup_link() interface and start pipeline
+	 * from the source to the entity.
+	 * Bridge driver is expected to implement and set the
+	 * handler when media_device is registered or when
+	 * bridge driver finds the media_device during probe.
+	 * Bridge driver sets source_priv with information
+	 * necessary to run enable/disable source handlers.
+	 *
+	 * Use-case: find tuner entity connected to the decoder
+	 * entity and check if it is available, and activate the
+	 * using media_entity_setup_link() if it is available.
+	*/
+	void *source_priv;
+	int (*enable_source)(struct media_entity *entity,
+			     struct media_pipeline *pipe);
+	void (*disable_source)(struct media_entity *entity);
+
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
 };
-- 
2.5.0
