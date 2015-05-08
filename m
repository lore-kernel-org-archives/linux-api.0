From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 16/18] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
Date: Thu,  7 May 2015 22:12:38 -0300
Message-ID: <8326e056cbbf1813e41f8321d5bfe695167e03b5.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1431046915.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1431046915.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1431046915.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Instead of abusing MEDIA_ENT_T_V4L2_SUBDEV, initialize
new subdev entities as MEDIA_ENT_T_UNKNOWN.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 66c6d9fd2033..0233d30b4922 100644
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
index 8d47b70b7ea8..663eb2c6019d 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -44,6 +44,12 @@ struct media_device_info {
 
 /* Used values for media_entity_desc::type */
 
+/*
+ * Initial value when an entity is created
+ * Drivers should change it to something useful
+ */
+#define MEDIA_ENT_T_UNKNOWN	0
+
 /* Audio/video streaming bridges */
 #define MEDIA_ENT_T_AV_DMA		(((1 << 16)) + 1)
 
-- 
2.1.0
