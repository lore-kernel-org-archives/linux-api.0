From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv2 1/9] media: Fix DVB representation at media controller API
Date: Sat,  3 Jan 2015 12:49:03 -0200
Message-ID: <ea1dd8e443b34e2047468866ec423d4334f54eba.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The DVB devices are identified via a (major, minor) tuple,
and not by a random id. Fix it, before we start using it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index e00459185d20..de333cc8261b 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -97,7 +97,10 @@ struct media_entity {
 			u32 device;
 			u32 subdevice;
 		} alsa;
-		int dvb;
+		struct {
+			u32 major;
+			u32 minor;
+		} dvb;
 
 		/* Sub-device specifications */
 		/* Nothing needed yet */
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index d847c760e8f0..7902e800f019 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -27,7 +27,7 @@
 #include <linux/types.h>
 #include <linux/version.h>
 
-#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
+#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 1)
 
 struct media_device_info {
 	char driver[16];
@@ -88,7 +88,10 @@ struct media_entity_desc {
 			__u32 device;
 			__u32 subdevice;
 		} alsa;
-		int dvb;
+		struct {
+			__u32 major;
+			__u32 minor;
+		} dvb;
 
 		/* Sub-device specifications */
 		/* Nothing needed yet */
-- 
2.1.0
