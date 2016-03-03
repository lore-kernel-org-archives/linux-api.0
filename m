From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] [media] media.h: postpone connectors entities
Date: Thu,  3 Mar 2016 14:54:30 -0300
Message-ID: <93125094c07d8c9ec25dff5869f191b33eb9dd6e.1457027668.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The representation of external connections got some heated
discussions recently. As we're too close to the merge window,
let's not set those entities into a stone.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/uapi/linux/media.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 13e19a18f97f..323f1af35062 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -82,10 +82,18 @@ struct media_device_info {
  * Connectors
  */
 /* It is a responsibility of the entity drivers to add connectors and links */
+#ifdef __KERNEL__
+	/*
+	 * For now, it should not be used in userspace, as some
+	 * definitions may change
+	 */
+
 #define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 0x30001)
 #define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 0x30002)
 #define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 0x30003)
 
+#endif
+
 /*
  * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
  * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
-- 
2.5.0
