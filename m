From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 1/3] media: Fix ALSA and DVB representation at media controller API
Date: Mon, 26 Jan 2015 10:47:10 -0200
Message-ID: <cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1422273497.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1422273497.git.mchehab@osg.samsung.com>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hans.verkuil@cisco.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>, Ricardo Ribalda <ricardo.ribalda@gmail.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The previous provision for DVB media controller support were to
define an ID (likely meaning the adapter number) for the DVB
devnodes.

This is just plain wrong. Just like V4L, DVB devices (and ALSA,
or whatever) are identified via a (major, minor) tuple.

This is enough to uniquely identify a devnode, no matter what
API it implements.

So, before we go too far, let's mark the old v4l, dvb and alsa
"devnode" info as deprecated, and just call it as "dev".

As we don't want to break compilation on already existing apps,
let's just keep the old definitions as-is, adding a note that
those are deprecated at media-entity.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 86bb93fd7db8..d89d5cb465d9 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -943,8 +943,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
 		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
 		vdev->entity.name = vdev->name;
-		vdev->entity.info.v4l.major = VIDEO_MAJOR;
-		vdev->entity.info.v4l.minor = vdev->minor;
+		vdev->entity.info.dev.major = VIDEO_MAJOR;
+		vdev->entity.info.dev.minor = vdev->minor;
 		ret = media_device_register_entity(vdev->v4l2_dev->mdev,
 			&vdev->entity);
 		if (ret < 0)
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 015f92aab44a..204cc67c84e8 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -248,8 +248,8 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 			goto clean_up;
 		}
 #if defined(CONFIG_MEDIA_CONTROLLER)
-		sd->entity.info.v4l.major = VIDEO_MAJOR;
-		sd->entity.info.v4l.minor = vdev->minor;
+		sd->entity.info.dev.major = VIDEO_MAJOR;
+		sd->entity.info.dev.minor = vdev->minor;
 #endif
 		sd->devnode = vdev;
 	}
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index e00459185d20..d6d74bcfe183 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -87,17 +87,7 @@ struct media_entity {
 		struct {
 			u32 major;
 			u32 minor;
-		} v4l;
-		struct {
-			u32 major;
-			u32 minor;
-		} fb;
-		struct {
-			u32 card;
-			u32 device;
-			u32 subdevice;
-		} alsa;
-		int dvb;
+		} dev;
 
 		/* Sub-device specifications */
 		/* Nothing needed yet */
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index d847c760e8f0..418f4fec391a 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -78,6 +78,20 @@ struct media_entity_desc {
 		struct {
 			__u32 major;
 			__u32 minor;
+		} dev;
+
+#if 1
+		/*
+		 * DEPRECATED: previous node specifications. Kept just to
+		 * avoid breaking compilation, but media_entity_desc.dev
+		 * should be used instead. In particular, alsa and dvb
+		 * fields below are wrong: for all devnodes, there should
+		 * be just major/minor inside the struct, as this is enough
+		 * to represent any devnode, no matter what type.
+		 */
+		struct {
+			__u32 major;
+			__u32 minor;
 		} v4l;
 		struct {
 			__u32 major;
@@ -89,6 +103,7 @@ struct media_entity_desc {
 			__u32 subdevice;
 		} alsa;
 		int dvb;
+#endif
 
 		/* Sub-device specifications */
 		/* Nothing needed yet */
-- 
2.1.0
