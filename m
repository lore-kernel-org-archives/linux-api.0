From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 17/18] media controller: get rid of entity subtype on Kernel
Date: Thu,  7 May 2015 22:12:39 -0300
Message-ID: <e2fff968b52f1b94e42023fbd7bf70ad0f1b7cc9.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Don't use anymore the type/subtype entity data/macros
inside the Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index f15b48145711..bb98506532ff 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -103,16 +103,6 @@ struct media_entity {
 	} info;
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
 static inline bool is_media_entity_av_dma(struct media_entity *entity)
 {
 	if (!entity)
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 663eb2c6019d..307cc4d72af0 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -71,7 +71,9 @@ struct media_device_info {
 /* Radio, Analog TV and/or Digital TV tuners */
 #define MEDIA_ENT_T_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
 
-#if 1
+#define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENT_TYPE_SHIFT)
+
+#ifndef __KERNEL__
 /*
  * Legacy symbols.
  * Kept just to avoid userspace compilation breakages.
@@ -82,7 +84,6 @@ struct media_device_info {
 #define MEDIA_ENT_TYPE_MASK		0x00ff0000
 #define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
 
-#define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENT_TYPE_SHIFT)
 #define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENT_TYPE_SHIFT)
 
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
-- 
2.1.0
