From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 06/18] [media] media.h: create connector entities for hybrid TV devices
Date: Sun,  6 Sep 2015 14:30:49 -0300
Message-ID: <9af2bbe9e63004f843e8478bc3d31cd03ea75d64.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add entities to represent the connectors that exists inside a
hybrid TV device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b17f6763aff4..69433405aec2 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -61,6 +61,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DVB_BASE		0x00000000
 #define MEDIA_ENT_T_V4L2_BASE		0x00010000
 #define MEDIA_ENT_T_V4L2_SUBDEV_BASE	0x00020000
+#define MEDIA_ENT_T_CONNECTOR_BASE	0x00030000
 
 /*
  * V4L2 entities - Those are used for DMA (mmap/DMABUF) and
@@ -105,6 +106,13 @@ struct media_device_info {
 #define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 4)
 #define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 5)
 
+/* Connectors */
+#define MEDIA_ENT_T_CONN_RF		(MEDIA_ENT_T_CONNECTOR_BASE)
+#define MEDIA_ENT_T_CONN_SVIDEO		(MEDIA_ENT_T_CONNECTOR_BASE + 1)
+#define MEDIA_ENT_T_CONN_COMPOSITE	(MEDIA_ENT_T_CONNECTOR_BASE + 2)
+	/* For internal test signal generators and other debug connectors */
+#define MEDIA_ENT_T_CONN_TEST		(MEDIA_ENT_T_CONNECTOR_BASE + 3)
+
 #ifndef __KERNEL__
 /* Legacy symbols used to avoid userspace compilation breakages */
 #define MEDIA_ENT_TYPE_SHIFT		16
@@ -121,9 +129,9 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
 #endif
 
-/* Entity types */
-
+/* Entity flags */
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
+#define MEDIA_ENT_FL_CONNECTOR		(1 << 1)
 
 struct media_entity_desc {
 	__u32 id;
-- 
2.4.3
