From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 08/18] media controller: add comments for the entity types
Date: Thu,  7 May 2015 22:12:30 -0300
Message-ID: <089802aaf4c9f80af162fe074b4d8a54d7f35a28.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Better document the linux/media.h UAPI header, by adding
comments to each entity subtype.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 6acc4be1378c..8d47b70b7ea8 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -44,19 +44,25 @@ struct media_device_info {
 
 /* Used values for media_entity_desc::type */
 
+/* Audio/video streaming bridges */
 #define MEDIA_ENT_T_AV_DMA		(((1 << 16)) + 1)
+
+/* Digital TV entities */
 #define MEDIA_ENT_T_DTV_DEMOD	(MEDIA_ENT_T_AV_DMA + 3)
 #define MEDIA_ENT_T_DTV_DEMUX	(MEDIA_ENT_T_AV_DMA + 4)
 #define MEDIA_ENT_T_DTV_DVR	(MEDIA_ENT_T_AV_DMA + 5)
 #define MEDIA_ENT_T_DTV_CA	(MEDIA_ENT_T_AV_DMA + 6)
 #define MEDIA_ENT_T_DTV_NET	(MEDIA_ENT_T_AV_DMA + 7)
 
+/* Camera entities */
 #define MEDIA_ENT_T_CAM_SENSOR	((2 << 16) + 1)
 #define MEDIA_ENT_T_CAM_FLASH	(MEDIA_ENT_T_CAM_SENSOR + 1)
 #define MEDIA_ENT_T_CAM_LENS	(MEDIA_ENT_T_CAM_SENSOR + 2)
 
+/* Analog TV entities */
 #define MEDIA_ENT_T_ATV_DECODER	(MEDIA_ENT_T_CAM_SENSOR + 3)
 
+/* Radio, Analog TV and/or Digital TV tuners */
 #define MEDIA_ENT_T_TUNER	(MEDIA_ENT_T_CAM_SENSOR + 4)
 
 #if 1
-- 
2.1.0
