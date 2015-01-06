From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCHv3 09/20] tuner-core: properly initialize media controller subdev
Date: Tue,  6 Jan 2015 19:08:40 -0200
Message-ID: <58826b3a683cac474935783286d7a4d0a5ef4e3a.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hans.verkuil@cisco.com>, Prabhakar Lad <prabhakar.csengg@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Properly initialize tuner core subdev at the media controller.

That requires a new subtype at the media controller API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 559f8372e2eb..9a83b27a7e8f 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -134,6 +134,9 @@ struct tuner {
 	unsigned int        type; /* chip type id */
 	void                *config;
 	const char          *name;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad	pad;
+#endif
 };
 
 /*
@@ -434,6 +437,8 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		t->name = analog_ops->info.name;
 	}
 
+	t->sd.entity.name = t->name;
+
 	tuner_dbg("type set to %s\n", t->name);
 
 	t->mode_mask = new_mode_mask;
@@ -592,6 +597,9 @@ static int tuner_probe(struct i2c_client *client,
 	struct tuner *t;
 	struct tuner *radio;
 	struct tuner *tv;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int ret;
+#endif
 
 	t = kzalloc(sizeof(struct tuner), GFP_KERNEL);
 	if (NULL == t)
@@ -684,6 +692,18 @@ static int tuner_probe(struct i2c_client *client,
 
 	/* Should be just before return */
 register_client:
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	t->pad.flags = MEDIA_PAD_FL_SOURCE;
+	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
+	t->sd.entity.name = t->name;
+
+	ret = media_entity_init(&t->sd.entity, 1, &t->pad, 0);
+	if (ret < 0) {
+		tuner_err("failed to initialize media entity!\n");
+		kfree(t);
+		return -ENODEV;
+	}
+#endif
 	/* Sets a default mode */
 	if (t->mode_mask & T_ANALOG_TV)
 		t->mode = V4L2_TUNER_ANALOG_TV;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 707db275f92b..5ffde035789b 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -66,6 +66,8 @@ struct media_device_info {
 /* A converter of analogue video to its digital representation. */
 #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
 
+#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV + 5)
+
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
 
 struct media_entity_desc {
-- 
2.1.0
