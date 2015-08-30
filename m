From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v8 39/55] [media] media controller: get rid of entity subtype on Kernel
Date: Sun, 30 Aug 2015 00:06:50 -0300
Message-ID: <8154aa42b993840dfde2d794e7e9e1f0c57c1e82.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Don't use anymore the type/subtype entity data/macros
inside the Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index b0cfbc0dffc7..756e1960fd7f 100644
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
index 44b84aae8b02..cd486fc25f1e 100644
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
-- 
2.4.3
