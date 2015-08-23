From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v7 34/44] [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
Date: Sun, 23 Aug 2015 17:17:51 -0300
Message-ID: <f7240933f9d81317ee70210fdeb1a6b13024e1eb.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1440359643.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1440359643.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1440359643.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Instead of abusing MEDIA_ENT_T_V4L2_SUBDEV, initialize
new subdev entities as MEDIA_ENT_T_UNKNOWN.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 60da43772de9..07600daf5490 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -584,7 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->host_priv = NULL;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	sd->entity.name = sd->name;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_UNKNOWN;
 #endif
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 7306aeaff807..e9e7ad268a7e 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -42,6 +42,14 @@ struct media_device_info {
 
 #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
 
+/* Used values for media_entity_desc::type */
+
+/*
+ * Initial value when an entity is created
+ * Drivers should change it to something useful
+ */
+#define MEDIA_ENT_T_UNKNOWN	0x00000000
+
 /*
  * Base numbers for entity types
  *
@@ -52,7 +60,7 @@ struct media_device_info {
  * However, It is kept this way just to avoid binary breakages with the
  * namespace provided on legacy versions of this header.
  */
-#define MEDIA_ENT_T_DVB_BASE		0x00000000
+#define MEDIA_ENT_T_DVB_BASE		0x00000001
 #define MEDIA_ENT_T_V4L2_BASE		0x00010000
 #define MEDIA_ENT_T_V4L2_SUBDEV_BASE	0x00020000
 
-- 
2.4.3
