From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 04/31] media: Media Controller enable/disable source handler API
Date: Wed,  6 Jan 2016 13:26:53 -0700
Message-ID: <d8d65a0188b05f3e799400c745584a02bc9b7548.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add new fields to struct media_device to add enable_source, and
disable_source handlers, and source_priv to stash driver private
data that is need to run these handlers. The enable_source handler
finds source entity for the passed in entity and check if it is
available, and activate the link using __media_entity_setup_link()
interface. Bridge driver is expected to implement and set these
handlers and private data when media_device is registered or when
bridge driver finds the media_device during probe. This is to enable
the use-case to find tuner entity connected to the decoder entity and
check if it is available, and activate it and start pipeline between
the source and the entity. The disable_source handler deactivates the
link and stops the pipeline. This handler can be invoked from the
media core (v4l-core, dvb-core) as well as other drivers such as ALSA
that control the media device.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/media/media-device.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6520d1c..04b6c2e 100644
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
