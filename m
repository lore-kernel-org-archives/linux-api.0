From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 38/55] [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
Date: Sun,  6 Sep 2015 09:02:58 -0300
Message-ID: <84879cc0deb14467e5436af5287148ace5b15cce.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <662a3bb2bfb02f820f4dafa0033af2cf16d273c5.1440902901.git.mchehab@osg.samsung.com>
References: <662a3bb2bfb02f820f4dafa0033af2cf16d273c5.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>, Markus Elfring <elfring@users.sourceforge.net>, Lars-Peter Clausen <lars@metafoo.de>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Instead of abusing MEDIA_ENT_T_V4L2_SUBDEV, initialize
new subdev entities as MEDIA_ENT_T_UNKNOWN.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 659507bce63f..134fe7510195 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -435,6 +435,12 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 {
 	int i;
 
+	if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN ||
+	    entity->type == MEDIA_ENT_T_UNKNOWN)
+		dev_warn(mdev->dev,
+			 "Entity type for entity %s was not initialized!\n",
+			 entity->name);
+
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->graph_obj.mdev != NULL);
 	entity->graph_obj.mdev = mdev;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 60da43772de9..b3bcc8253182 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -584,7 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->host_priv = NULL;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	sd->entity.name = sd->name;
-	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN;
 #endif
 }
 EXPORT_SYMBOL(v4l2_subdev_init);
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index f8725b881a1d..3d6210095336 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -42,6 +42,14 @@ struct media_device_info {
 
 #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
 
+/* Used values for media_entity_desc::type */
+
+/*
+ * Initial value to be used when a new entity is created
+ * Drivers should change it to something useful
+ */
+#define MEDIA_ENT_T_UNKNOWN	0x00000000
+
 /*
  * Base numbers for entity types
  *
@@ -75,6 +83,15 @@ struct media_device_info {
 #define MEDIA_ENT_T_V4L2_SWRADIO	(MEDIA_ENT_T_V4L2_BASE + 6)
 
 /* V4L2 Sub-device entities */
+
+	/*
+	 * Subdevs are initialized with MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN,
+	 * in order to preserve backward compatibility.
+	 * Drivers should change to the proper subdev type before
+	 * registering the entity.
+	 */
+#define MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_T_V4L2_SUBDEV_BASE
+
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 1)
 #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 2)
 #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 3)
-- 
2.4.3
