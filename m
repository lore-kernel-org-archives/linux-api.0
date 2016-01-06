From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 29/31] media: track media device unregister in progress
Date: Wed,  6 Jan 2016 13:27:18 -0700
Message-ID: <151cfbe0e59b3d5396951bdcc29666614575f5bc.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add support to track media device unregister in progress
state to prevent more than one driver entering unregister.
This enables fixing the general protection faults while
snd-usb-audio was cleaning up media resources for pcm
streams and mixers. In this patch a new interface is added
to return the unregister in progress state. Subsequent
patches to snd-usb-audio and au0828-core use this interface
to avoid entering unregister and attempting to unregister
entities and remove devnodes while unregister is in progress.
Media device unregister removes entities and interface nodes.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c |  5 ++++-
 include/media/media-device.h | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 20c85a9..1bb9a5f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -749,10 +749,13 @@ void media_device_unregister(struct media_device *mdev)
 	spin_lock(&mdev->lock);
 
 	/* Check if mdev was ever registered at all */
-	if (!media_devnode_is_registered(&mdev->devnode)) {
+	/* check if unregister is in progress */
+	if (!media_devnode_is_registered(&mdev->devnode) ||
+	    mdev->unregister_in_progress) {
 		spin_unlock(&mdev->lock);
 		return;
 	}
+	mdev->unregister_in_progress = true;
 
 	/* Remove all entities from the media device */
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 04b6c2e..0807292 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -332,6 +332,10 @@ struct media_device {
 	spinlock_t lock;
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
+	/* Tracks unregister in progress state to prevent
+	 * more than one driver entering unregister
+	*/
+	bool unregister_in_progress;
 
 	/* Handlers to find source entity for the sink entity and
 	 * check if it is available, and activate the link using
@@ -365,6 +369,7 @@ struct media_device {
 /* media_devnode to media_device */
 #define to_media_device(node) container_of(node, struct media_device, devnode)
 
+
 /**
  * media_entity_enum_init - Initialise an entity enumeration
  *
@@ -553,6 +558,12 @@ struct media_device *media_device_get_devres(struct device *dev);
  * @dev: pointer to struct &device.
  */
 struct media_device *media_device_find_devres(struct device *dev);
+/* return unregister in progress state */
+static inline bool media_device_is_unregister_in_progress(
+					struct media_device *mdev)
+{
+	return mdev->unregister_in_progress;
+}
 
 /* Iterate over all entities. */
 #define media_device_for_each_entity(entity, mdev)			\
@@ -569,6 +580,7 @@ struct media_device *media_device_find_devres(struct device *dev);
 /* Iterate over all links. */
 #define media_device_for_each_link(link, mdev)			\
 	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
+
 #else
 static inline int media_device_register(struct media_device *mdev)
 {
@@ -604,5 +616,10 @@ static inline struct media_device *media_device_find_devres(struct device *dev)
 {
 	return NULL;
 }
+static inline bool media_device_is_unregister_in_progress(
+					struct media_device *mdev)
+{
+	return false;
+}
 #endif /* CONFIG_MEDIA_CONTROLLER */
 #endif
-- 
2.5.0
