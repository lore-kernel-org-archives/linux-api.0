From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 06/13] [media] media.h: add support for IF-PLL video/sound decoder
Date: Fri, 29 Jan 2016 10:10:56 -0200
Message-ID: <bc031d38ffa4a9505af2eaa8d7a91bf4e4721884.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454067262.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1454067262.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1454067262.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Very old hardware may have an analog stage tuner. Those hardware
consists of a PLL that converts a RF signal into IF signals.

Depending on the hardware, those video IF signal can be
decoded directly by the bridge chipset. Most Conexant
chips (bt8x8, cx2388x, etc) have internally the decoders
for that. Yet, even on such hardware, the tuner may have
internally its own TV multi-standard decoder like tda9887.

The same happens with the audio IF signal, where some bridges
are capable of receiving it, while others require an external
IF-PLL sound decoder, like msp3400.

Those external IF-PLL audio and video decoders have their own
I2C address, and use different drivers to handle them. So, they're
mapped as different subdevices on Linux.

Thankfully, all modern hardware comes with an IC chip that
has both the RF and the IF stages on it, being capable of
decoding audio and video IF signals internally.

Yet, as we need to support drivers that can work with either
analog or silicon tuners, we need to add two entity types
for those old hardware.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 Documentation/DocBook/media/v4l/media-types.xml | 29 ++++++++++++++++++++++++-
 include/uapi/linux/media.h                      | 17 +++++++++++++--
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 1af384250910..751c3d027103 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -84,7 +84,34 @@
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_F_TUNER</constant></entry>
-	    <entry>Digital TV, analog TV, radio and/or software radio tuner.</entry>
+	    <entry>Digital TV, analog TV, radio and/or software radio tuner,
+		   with consists on a PLL tuning stage that converts radio
+		   frequency (RF) signal into an Intermediate Frequency (IF).
+		   Modern tuners have internally IF-PLL decoders for audio
+		   and video, but older models have those stages implemented
+		   on separate entities.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IF_VID_DECODER</constant></entry>
+	    <entry>IF-PLL video decoder. It receives the IF from a PLL
+		   and decodes the analog TV video signal. This is commonly
+		   found on some very old analog tuners, like Philips MK3
+		   designs. They all contain a tda9887 (or some software
+		   compatible similar chip, like tda9885). Those devices
+		   use a different I2C address than the tuner PLL.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IF_AUD_DECODER</constant></entry>
+	    <entry>IF-PLL sound decoder. It receives the IF from a PLL
+		   and decodes the analog TV audio signal. This is commonly
+		   found on some very old analog hardware, like Micronas
+		   msp3400, Philips tda9840, tda985x, etc. Those devices
+		   use a different I2C address than the tuner PLL and
+		   should be controlled together with the IF-PLL video
+		   decoder.
+	    </entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 5dbb208e5451..c9eb42a6c021 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -89,6 +89,15 @@ struct media_device_info {
 #define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 33)
 
 /*
+ * Analog TV IF-PLL decoders
+ *
+ * It is a responsibility of the master/bridge drivers to create links
+ * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
+ */
+#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 41)
+#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 42)
+
+/*
  * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
  * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
  * with the legacy v1 API.The number range is out of range by purpose:
@@ -107,8 +116,12 @@ struct media_device_info {
 #define MEDIA_ENT_F_LENS		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
 #define MEDIA_ENT_F_ATV_DECODER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
 /*
- * It is a responsibility of the entity drivers to add connectors and links
- *	for the tuner entities.
+ * It is a responsibility of the master/bridge drivers to add connectors
+ * and links for MEDIA_ENT_F_TUNER. Please notice that some old tuners
+ * may require the usage of separate I2C chips to decode analog TV signals,
+ * when the master/bridge chipset doesn't have its own TV standard decoder.
+ * On such cases, the IF-PLL staging is mapped via one or two entities:
+ * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
  */
 #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
 
-- 
2.5.0
