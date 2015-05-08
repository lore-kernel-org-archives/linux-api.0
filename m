From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 03/18] media controller: use MEDIA_ENT_T_AV_DMA for A/V DMA engines
Date: Thu,  7 May 2015 22:12:25 -0300
Message-ID: <afb84e3d80fc4f6f2465a123012f161b8c29f1c4.1431046915.git.mchehab@osg.samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1431046915.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1431046915.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1431046915.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Hyun Kwon <hyun.kwon-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Michal Simek <michal.simek-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishnan Muthukrishnan <ramakrmu-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

At the Video4Linux API, the /dev/video?, /dev/vbi? and
/dev/radio? device nodes are used for the chipset that
provides the bridge between video/radio streams and the
USB, PCI or CPU buses.

Such bridge is also typically used to control the V4L2 device
as a hole.

For video streaming devices and SDR radio devices, they're
also associated with the DMA engines that transfer the
video stream (or SDR stream) to the CPU's memory.

It should be noticed, however, this is not true on non-SDR
radio devices, and may also not be true on embedded devices
that, due to DRM reasons, don't allow writing unencrypted
data on a memory that could be seen by the CPU.

So, we'll eventually need to add another entity for such
bridge chipsets that have a video/vbi/radio device node
associated, but don't have DMA engines on (some) devnodes.

As, currently, we don't have any such case, let's for now
just rename the device nodes that are associated with a
DMA engine as MEDIA_ENT_T_AV_DMA.

So,
	MEDIA_ENT_T_DEVNODE_V4L -> MEDIA_ENT_T_AV_DMA

PS.: This is not actually true for USB devices, as the
DMA engine is an internal component, as it is up to the
Kernel to strip the stream payload from the URB packages.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 5872f8bbf774..5b8147629159 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -183,7 +183,7 @@
 	    <entry>Unknown device node</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_V4L</constant></entry>
+	    <entry><constant>MEDIA_ENT_T_AV_DMA</constant></entry>
 	    <entry>V4L video, radio or vbi device node</entry>
 	  </row>
 	  <row>
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index efde88adf624..7fa0cc0f08f0 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -193,7 +193,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		struct xvip_dma *dma;
 
-		if (entity->type != MEDIA_ENT_T_DEVNODE_V4L)
+		if (entity->type != MEDIA_ENT_T_AV_DMA)
 			continue;
 
 		dma = to_xvip_dma(media_entity_to_video_device(entity));
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 71a1b93b0790..9ef920221b5a 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -912,7 +912,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	/* Part 5: Register the entity. */
 	if (vdev->v4l2_dev->mdev &&
 	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
-		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
+		vdev->entity.type = MEDIA_ENT_T_AV_DMA;
 		vdev->entity.name = vdev->name;
 		vdev->entity.info.dev.major = VIDEO_MAJOR;
 		vdev->entity.info.dev.minor = vdev->minor;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 63596063b213..9f8fc8330b3e 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -535,7 +535,7 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
 		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
 	}
 
-	WARN(pad->entity->type != MEDIA_ENT_T_DEVNODE_V4L,
+	WARN(pad->entity->type != MEDIA_ENT_T_AV_DMA,
 	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
 	     pad->entity->type, pad->entity->name);
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 775c11c6b173..a7aa2aac9c23 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -44,12 +44,12 @@ struct media_device_info {
 
 /* Used values for media_entity_desc::type */
 
-#define MEDIA_ENT_T_DEVNODE_V4L		(((1 << 16)) + 1)
-#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_DEVNODE_V4L + 3)
-#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_DEVNODE_V4L + 4)
-#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_DEVNODE_V4L + 5)
-#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_DEVNODE_V4L + 6)
-#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_DEVNODE_V4L + 7)
+#define MEDIA_ENT_T_AV_DMA		(((1 << 16)) + 1)
+#define MEDIA_ENT_T_DEVNODE_DVB_FE	(MEDIA_ENT_T_AV_DMA + 3)
+#define MEDIA_ENT_T_DEVNODE_DVB_DEMUX	(MEDIA_ENT_T_AV_DMA + 4)
+#define MEDIA_ENT_T_DEVNODE_DVB_DVR	(MEDIA_ENT_T_AV_DMA + 5)
+#define MEDIA_ENT_T_DEVNODE_DVB_CA	(MEDIA_ENT_T_AV_DMA + 6)
+#define MEDIA_ENT_T_DEVNODE_DVB_NET	(MEDIA_ENT_T_AV_DMA + 7)
 
 #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	((2 << 16) + 1)
 #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_SENSOR + 1)
-- 
2.1.0
