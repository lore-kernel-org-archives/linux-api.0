From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv3 01/20] media: add new types for DVB devnodes
Date: Tue,  6 Jan 2015 19:08:32 -0200
Message-ID: <7f1ea82b1055aa490726f3af2ad22bca25e49a28.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Most of the DVB subdevs have already their own devnode.

Add support for them at the media controller API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 7902e800f019..707db275f92b 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -50,7 +50,14 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE_V4L		(MEDIA_ENT_T_DEVNODE + 1)
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
-#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
+#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE + 4)
+#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE + 5)
+#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE + 6)
+#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE + 7)
+#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE + 8)
+
+/* Legacy symbol. Use it to avoid userspace compilation breakages */
+#define MEDIA_ENT_T_DEVNODE_DVB		MEDIA_ENT_T_DEVNODE_DVB_FE
 
 #define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENT_TYPE_SHIFT)
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
-- 
2.1.0
