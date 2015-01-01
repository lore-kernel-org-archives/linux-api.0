From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 4/5] dvb core: add media controller support for the demod
Date: Thu,  1 Jan 2015 13:51:25 -0200
Message-ID: <16368e1f9dfb1db65ec6f0d91a38d5233a12542c.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1420127255.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1420127255.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1420127255.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Shuah Khan <shuah.kh-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Akihiro Tsukada <tskd08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Olli Salonen <olli.salonen-X3B1VOXEql0@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Nibble Max <nibble.max-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Harper <james.harper-u7/cK5yN3tp/jDykUgYHh4dd74u8MsAO@public.gmane.org>, Matthias Schwarzott <zzam-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Now that we have an I2C function to attach DVB sub-devices, add
support for media controller on it.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 41aae1bf0103..65d002f19cc3 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -40,6 +40,8 @@
 
 #include <linux/dvb/frontend.h>
 
+#include <media/media-device.h>
+
 #include "dvbdev.h"
 
 /*
@@ -416,6 +418,11 @@ struct dvb_frontend {
 	struct dvb_frontend_ops ops;
 	struct dvb_adapter *dvb;
 	struct i2c_client *fe_cl;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
+	struct media_entity demod_entity;
+#endif
+
 	void *demodulator_priv;
 	void *tuner_priv;
 	void *frontend_priv;
diff --git a/drivers/media/dvb-core/dvb_i2c.c b/drivers/media/dvb-core/dvb_i2c.c
index 4ea4e5e59f14..df8b7718ca8a 100644
--- a/drivers/media/dvb-core/dvb_i2c.c
+++ b/drivers/media/dvb-core/dvb_i2c.c
@@ -39,11 +39,12 @@ dvb_i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info *info,
 
 struct dvb_frontend *
 dvb_i2c_attach_fe(struct i2c_adapter *adap, const struct i2c_board_info *info,
-		  const void *cfg, void **out)
+		  const void *cfg, void **out, struct media_device *mdev)
 {
 	struct i2c_client *cl;
 	struct i2c_board_info bi;
 	struct dvb_i2c_dev_config dcfg;
+	struct dvb_frontend *fe;
 
 	dcfg.priv_cfg = cfg;
 	dcfg.out = out;
@@ -53,7 +54,28 @@ dvb_i2c_attach_fe(struct i2c_adapter *adap, const struct i2c_board_info *info,
 	cl = dvb_i2c_new_device(adap, &bi, NULL);
 	if (!cl)
 		return NULL;
-	return i2c_get_clientdata(cl);
+	fe = i2c_get_clientdata(cl);
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	/* Register the media controller entity. */
+	if (mdev) {
+		int ret;
+
+		if (!fe->mdev)
+			fe->mdev = mdev;
+
+		fe->demod_entity.type = MEDIA_ENT_T_DEVNODE_DVB;
+		fe->demod_entity.name = info->type;
+		fe->demod_entity.info.dvb = fe->id;
+		fe->demod_entity.flags = MEDIA_ENT_T_DVB_DEMOD;
+		ret = media_device_register_entity(fe->mdev, &fe->demod_entity);
+		if (ret < 0)
+			printk(KERN_WARNING
+				"%s: media_device_register_entity failed\n",
+				__func__);
+	}
+#endif
+	return fe;
 }
 EXPORT_SYMBOL(dvb_i2c_attach_fe);
 
@@ -193,6 +215,10 @@ static int remove_fe(struct i2c_client *client,
 	if (param->priv_remove)
 		param->priv_remove(client);
 	fe = i2c_get_clientdata(client);
+
+	if (fe->mdev)
+		media_device_unregister_entity(&fe->demod_entity);
+
 	kfree(fe->demodulator_priv);
 	kfree(fe);
 	module_put(this_module);
diff --git a/drivers/media/dvb-core/dvb_i2c.h b/drivers/media/dvb-core/dvb_i2c.h
index 2bf409d4bcaf..c2efed9c997e 100644
--- a/drivers/media/dvb-core/dvb_i2c.h
+++ b/drivers/media/dvb-core/dvb_i2c.h
@@ -33,7 +33,8 @@
 
 struct dvb_frontend *dvb_i2c_attach_fe(struct i2c_adapter *adap,
 				       const struct i2c_board_info *info,
-				       const void *cfg, void **out);
+				       const void *cfg, void **out,
+				       struct media_device *mdev);
 
 struct i2c_client *dvb_i2c_attach_tuner(struct i2c_adapter *adap,
 					const struct i2c_board_info *info,
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index fc23b7ad194f..084526a29414 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1510,7 +1510,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_i2c_attach_fe(&i2c_bus->i2c_adap,
 						       &mb86a20s_board_info,
 						       &mygica_x8507_mb86a20s_config,
-						       NULL);
+						       NULL, NULL);
 		if (fe0->dvb.frontend == NULL)
 			break;
 
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index 74b5ce0de488..a47630be4583 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1814,7 +1814,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		fe0->dvb.frontend = dvb_i2c_attach_fe(&dev->i2c_adap,
 						       &mb86a20s_board_info,
 						       &kworld_mb86a20s_config,
-						       NULL);
+						       NULL, NULL);
 		if (fe0->dvb.frontend != NULL) {
 			dvb_attach(tda829x_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x4b,
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 27803a8cf5a4..e6b6da44b1e5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -822,7 +822,7 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->frontend = dvb_i2c_attach_fe(demod_i2c,
 						       &mb86a20s_board_info,
 						       &pv_mb86a20s_config,
-						       NULL);
+						       NULL, NULL);
 		if (dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
 				"Failed to attach mb86a20s demod\n");
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 6fa4eeed9f50..c9bbc251c7c7 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1330,7 +1330,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_i2c_attach_fe(&dev->i2c_adap[dev->def_i2c_bus],
 					       &mb86a20s_board_info,
 					       &c3tech_duo_mb86a20s_config,
-					       NULL);
+					       NULL, NULL);
 		if (dvb->fe[0] != NULL)
 			dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
 				   &dev->i2c_adap[dev->def_i2c_bus],
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index d847c760e8f0..c002aed74e6b 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -27,7 +27,7 @@
 #include <linux/types.h>
 #include <linux/version.h>
 
-#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
+#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 1)
 
 struct media_device_info {
 	char driver[16];
@@ -59,6 +59,8 @@ struct media_device_info {
 /* A converter of analogue video to its digital representation. */
 #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
 
+#define MEDIA_ENT_T_DVB_DEMOD		(MEDIA_ENT_T_V4L2_SUBDEV + 5)
+
 #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
 
 struct media_entity_desc {
-- 
2.1.0
