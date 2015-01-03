From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 2/7] dvb core: add support for media controller at dvbdev
Date: Sat,  3 Jan 2015 00:04:35 -0200
Message-ID: <da68b7d34c320f2092209e7ef03b28deab555746.1420250453.git.mchehab@osg.samsung.com>
References: <cover.1420250453.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1420250453.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1420250453.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1420250453.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Provide a way to register media controller device nodes
at the DVB core.

Please notice that the dvbdev callers also require changes
for the devices to be registered via the media controller.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 983db75de350..464a457e7527 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -180,6 +180,59 @@ skip:
 	return -ENFILE;
 }
 
+static void dvb_register_media_device(struct dvb_device *dvbdev,
+				      int type, int minor)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int ret;
+
+	if (!dvbdev->mdev)
+		return;
+
+	dvbdev->entity = kzalloc(sizeof(*dvbdev->entity), GFP_KERNEL);
+	if (!dvbdev->entity)
+		return;
+
+	dvbdev->entity->type = MEDIA_ENT_T_DEVNODE_DVB;
+	dvbdev->entity->info.dvb.major = DVB_MAJOR;
+	dvbdev->entity->info.dvb.minor = minor;
+	dvbdev->entity->name = dvbdev->name;
+	switch(type) {
+	case DVB_DEVICE_FRONTEND:
+		dvbdev->entity->flags = MEDIA_ENT_T_DVB_FE;
+		break;
+	case DVB_DEVICE_DEMUX:
+		dvbdev->entity->flags = MEDIA_ENT_T_DVB_DEMUX;
+		break;
+	case DVB_DEVICE_DVR:
+		dvbdev->entity->flags = MEDIA_ENT_T_DVB_DVR;
+		break;
+	case DVB_DEVICE_CA:
+		dvbdev->entity->flags = MEDIA_ENT_T_DVB_CA;
+		break;
+	case DVB_DEVICE_NET:
+		dvbdev->entity->flags = MEDIA_ENT_T_DVB_NET;
+		break;
+	default:
+		kfree(dvbdev->entity);
+		dvbdev->entity = NULL;
+		return;
+	}
+
+	ret = media_device_register_entity(dvbdev->mdev, dvbdev->entity);
+	if (ret < 0) {
+		printk(KERN_ERR
+			"%s: media_device_register_entity failed for %s\n",
+			__func__, dvbdev->entity->name);
+		kfree(dvbdev->entity);
+		dvbdev->entity = NULL;
+		return;
+	}
+
+	printk(KERN_DEBUG "%s: media device '%s' registered.\n",
+		__func__, dvbdev->entity->name);
+#endif
+}
 
 int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			const struct dvb_device *template, void *priv, int type)
@@ -258,10 +311,11 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		return PTR_ERR(clsdev);
 	}
-
 	dprintk(KERN_DEBUG "DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, minor, minor);
 
+	dvb_register_media_device(dvbdev, type, minor);
+
 	return 0;
 }
 EXPORT_SYMBOL(dvb_register_device);
@@ -278,6 +332,13 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 
 	device_destroy(dvb_class, MKDEV(DVB_MAJOR, dvbdev->minor));
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (dvbdev->entity) {
+		media_device_unregister_entity(dvbdev->entity);
+		kfree(dvbdev->entity);
+	}
+#endif
+
 	list_del (&dvbdev->list_head);
 	kfree (dvbdev->fops);
 	kfree (dvbdev);
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index f96b28e7fc95..f58dfef46984 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -27,6 +27,7 @@
 #include <linux/poll.h>
 #include <linux/fs.h>
 #include <linux/list.h>
+#include <media/media-device.h>
 
 #define DVB_MAJOR 212
 
@@ -92,6 +93,15 @@ struct dvb_device {
 	/* don't really need those !? -- FIXME: use video_usercopy  */
 	int (*kernel_ioctl)(struct file *file, unsigned int cmd, void *arg);
 
+	/* Needed for media controller register/unregister */
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
+	const char *name;
+
+	/* Filled inside dvbdev.c */
+	struct media_entity *entity;
+#endif
+
 	void *priv;
 };
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 7902e800f019..cdb6946d315e 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -59,6 +59,12 @@ struct media_device_info {
 /* A converter of analogue video to its digital representation. */
 #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
 
+#define MEDIA_ENT_T_DVB_FE		(MEDIA_ENT_T_V4L2_SUBDEV + 5)
+#define MEDIA_ENT_T_DVB_DEMUX		(MEDIA_ENT_T_V4L2_SUBDEV + 6)
+#define MEDIA_ENT_T_DVB_DVR		(MEDIA_ENT_T_V4L2_SUBDEV + 7)
+#define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_V4L2_SUBDEV + 8)
+#define MEDIA_ENT_T_DVB_NET		(MEDIA_ENT_T_V4L2_SUBDEV + 9)
+
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
 
 struct media_entity_desc {
-- 
2.1.0
