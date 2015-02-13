From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCHv4 04/25] [media] media: add new types for DVB devnodes
Date: Fri, 13 Feb 2015 20:57:47 -0200
Message-ID: <531e8c73d777d1a1d477597b722b78cd7c78bd99.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1423867976.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1423867976.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1423867976.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Most of the DVB subdevs have already their own devnode.

Add support for them at the media controller API.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 418f4fec391a..4c8f26243252 100644
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
