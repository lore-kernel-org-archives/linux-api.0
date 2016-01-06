From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 03/31] media: Media Controller register/unregister entity_notify API
Date: Wed,  6 Jan 2016 13:26:52 -0700
Message-ID: <01a8373c514c6728094056532e82f13192dcbb3f.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

Add new interfaces to register and unregister entity_notify
hook to media device to allow drivers to take appropriate
actions when as new entities get added to the shared media
device.When a new entity is registered, all registered
entity_notify hooks are invoked to allow drivers or modules
that registered hook to take appropriate action. For example,
ALSA driver registers an entity_notify hook to parse the list
of registered entities to determine if decoder has been linked
to ALSA entity. au0828 bridge driver registers an entity_notify
hook to create media graph for the device.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 61 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/media-device.h | 25 ++++++++++++++++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index b786b10..20c85a9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -536,6 +536,7 @@ static void media_device_release(struct media_devnode *mdev)
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
+	struct media_entity_notify *notify, *next;
 	unsigned int i;
 	int ret;
 
@@ -575,6 +576,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
 			       &entity->pads[i].graph_obj);
 
+	/* invoke entity_notify callbacks */
+	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
+		(notify)->notify(entity, notify->notify_data);
+	}
+
 	spin_unlock(&mdev->lock);
 
 	return 0;
@@ -608,6 +614,8 @@ static void __media_device_unregister_entity(struct media_entity *entity)
 	/* Remove the entity */
 	media_gobj_destroy(&entity->graph_obj);
 
+	/* invoke entity_notify callbacks to handle entity removal?? */
+
 	entity->graph_obj.mdev = NULL;
 }
 
@@ -633,6 +641,7 @@ int __must_check media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->interfaces);
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
+	INIT_LIST_HEAD(&mdev->entity_notify);
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
@@ -680,11 +689,59 @@ int __must_check __media_device_register(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
+/**
+ * media_device_register_entity_notify - Register a media entity notify
+ * callback with a media device. When a new entity is registered, all
+ * the registered media_entity_notify callbacks are invoked.
+ * @mdev:      The media device
+ * @nptr:      The media_entity_notify
+ */
+int __must_check media_device_register_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	spin_lock(&mdev->lock);
+	list_add_tail(&nptr->list, &mdev->entity_notify);
+	spin_unlock(&mdev->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
+
+/**
+ * __media_device_unregister_entity_notify - Unregister a media entity notify
+ * callback with a media device. When a new entity is registered, all
+ * the registered media_entity_notify callbacks are invoked.
+ * @mdev:      The media device
+ * @nptr:      The media_entity_notify
+ * Non-locking version. Should be called with mdev->lock held.
+ */
+static void __media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	list_del(&nptr->list);
+}
+
+/**
+ * media_device_unregister_entity_notify - Unregister a media entity notify
+ * callback with a media device. When a new entity is registered, all
+ * the registered media_entity_notify callbacks are invoked.
+ * @mdev:      The media device
+ * @nptr:      The media_entity_notify
+ */
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	spin_lock(&mdev->lock);
+	__media_device_unregister_entity_notify(mdev, nptr);
+	spin_unlock(&mdev->lock);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
+
 void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *next;
 	struct media_interface *intf, *tmp_intf;
+	struct media_entity_notify *notify, *nextp;
 
 	if (mdev == NULL)
 		return;
@@ -701,6 +758,10 @@ void media_device_unregister(struct media_device *mdev)
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		__media_device_unregister_entity(entity);
 
+	/* Remove all entity_notify callbacks from the media device */
+	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
+		__media_device_unregister_entity_notify(mdev, notify);
+
 	/* Remove all interfaces from the media device */
 	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
 				 graph_obj.list) {
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 122963a..6520d1c 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -264,6 +264,12 @@
 struct ida;
 struct device;
 
+struct media_entity_notify {
+	struct list_head list;
+	void *notify_data;
+	void (*notify)(struct media_entity *entity, void *notify_data);
+};
+
 /**
  * struct media_device - Media device
  * @dev:	Parent device
@@ -319,6 +325,9 @@ struct media_device {
 	struct list_head pads;
 	struct list_head links;
 
+	/* notify callback list invoked when a new entity is registered */
+	struct list_head entity_notify;
+
 	/* Protects the graph objects creation/removal */
 	spinlock_t lock;
 	/* Serializes graph operations. */
@@ -497,6 +506,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
  */
 void media_device_unregister_entity(struct media_entity *entity);
 
+int __must_check media_device_register_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr);
+
 /**
  * media_device_get_devres() -	get media device as device resource
  *				creates if one doesn't exist
@@ -552,6 +566,17 @@ static inline int media_device_register_entity(struct media_device *mdev,
 static inline void media_device_unregister_entity(struct media_entity *entity)
 {
 }
+static inline int media_device_register_entity_notify(
+					struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	return 0;
+}
+static inline void media_device_unregister_entity_notify(
+					struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+}
 static inline struct media_device *media_device_get_devres(struct device *dev)
 {
 	return NULL;
-- 
2.5.0
