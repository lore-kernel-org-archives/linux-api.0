From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 1/2] media-device.h: Let clearer that entity function must be initialized
Date: Fri, 11 Dec 2015 17:33:17 -0200
Message-ID: <9f249ef05975239a207a626a611778e955fff1c7.1449862315.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Improve the documentation to let it clear that the entity function
must be initialized.

Suggested-by: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 include/media/media-device.h | 4 ++++
 include/uapi/linux/media.h   | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 7cfcc08a09ea..3448ad6320c4 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -423,6 +423,10 @@ void media_device_unregister(struct media_device *mdev);
  * %MEDIA_ENT_FL_DEFAULT indicates the default entity for a given type.
  * 	This can be used to report the default audio and video devices or the
  * 	default camera sensor.
+ *
+ * NOTE: Drivers should set the entity function before calling this function.
+ * Please notice that the values %MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN and
+ * %MEDIA_ENT_F_UNKNOWN should not be used by the drivers.
  */
 int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity);
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index ff6a8010c520..8d8e1a3e6e1a 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -92,7 +92,7 @@ struct media_device_info {
  *
  * Subdevs are initialized with MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN,
  * in order to preserve backward compatibility.
- * Drivers should change to the proper subdev type before
+ * Drivers must change to the proper subdev type before
  * registering the entity.
  */
 
-- 
2.5.0
