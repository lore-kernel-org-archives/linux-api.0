From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v7 35/44] [media] media controller: get rid of entity subtype on Kernel
Date: Sun, 23 Aug 2015 17:17:52 -0300
Message-ID: <8958d8f7b45d41897646d63225dc53868a458eb9.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Don't use anymore the type/subtype entity data/macros
inside the Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 952867571429..796e4a490af8 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -185,16 +185,6 @@ struct media_intf_devnode {
 	u32				minor;
 };
 
-static inline u32 media_entity_type(struct media_entity *entity)
-{
-	return entity->type & MEDIA_ENT_TYPE_MASK;
-}
-
-static inline u32 media_entity_subtype(struct media_entity *entity)
-{
-	return entity->type & MEDIA_ENT_SUBTYPE_MASK;
-}
-
 static inline u32 media_entity_id(struct media_entity *entity)
 {
 	return entity->graph_obj.id;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index e9e7ad268a7e..ceea791dd6e9 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -42,10 +42,8 @@ struct media_device_info {
 
 #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
 
-/* Used values for media_entity_desc::type */
-
 /*
- * Initial value when an entity is created
+ * Initial value to be used when a new entity is created
  * Drivers should change it to something useful
  */
 #define MEDIA_ENT_T_UNKNOWN	0x00000000
@@ -96,6 +94,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 7)
 #define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 8)
 
+#ifndef __KERNEL__
 /* Legacy symbols used to avoid userspace compilation breakages */
 #define MEDIA_ENT_TYPE_SHIFT		16
 #define MEDIA_ENT_TYPE_MASK		0x00ff0000
@@ -109,6 +108,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
 #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
+#endif
 
 /* Entity types */
 
-- 
2.4.3
