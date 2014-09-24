From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH] [media] Fix smatch warning: unknown field name in initializer
Date: Wed, 24 Sep 2014 09:51:14 -0300
Message-ID: <a51536f693c64c92151b4a7f530e97fa9b0d867d.1411563071.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is detected with:
	gcc-4.8.3-7.fc20.x86_64

Smatch, up to this patch:
	commit de462ba2c79d9347368c887ed93113e7818a7b07
	Author: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
	Date:   Wed Sep 17 13:31:16 2014 +0300

drivers/media/v4l2-core/v4l2-dv-timings.c:34:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:35:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:36:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:37:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:38:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:39:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:40:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:41:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:42:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:43:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:44:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:45:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:46:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:47:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:48:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:49:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:50:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:51:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:52:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:53:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:54:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:55:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:56:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:57:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:58:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:59:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:60:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:61:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:62:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:63:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:64:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:65:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:66:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:67:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:68:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:69:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:70:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:71:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:72:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:73:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:74:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:75:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:76:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:77:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:78:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:79:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:80:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:81:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:82:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:83:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:84:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:85:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:86:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:87:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:88:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:89:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:90:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:91:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:92:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:93:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:94:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:95:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:96:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:97:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:98:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:99:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:100:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:101:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:102:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:103:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:104:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:105:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:106:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:107:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:108:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:109:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:110:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:111:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:112:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:113:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:114:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:115:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:116:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:117:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:118:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:119:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:120:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:121:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:122:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:123:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:124:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:125:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:126:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:127:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:128:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:129:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:130:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:131:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:132:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:133:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:134:9: error: unknown field name in initializer
drivers/media/v4l2-core/v4l2-dv-timings.c:135:9: error: too many errors
drivers/media/usb/hdpvr/hdpvr-video.c:42:9: error: unknown field name in initializer
drivers/media/usb/hdpvr/hdpvr-video.c:43:9: error: unknown field name in initializer
drivers/media/usb/hdpvr/hdpvr-video.c:44:9: error: unknown field name in initializer
drivers/media/usb/hdpvr/hdpvr-video.c:45:9: error: unknown field name in initializer
drivers/media/usb/hdpvr/hdpvr-video.c:46:9: error: unknown field name in initializer
drivers/media/usb/hdpvr/hdpvr-video.c:47:9: error: unknown field name in initializer
drivers/media/usb/hdpvr/hdpvr-video.c:48:9: error: unknown field name in initializer
drivers/media/usb/hdpvr/hdpvr-video.c:49:9: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:484:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:485:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:486:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:487:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:488:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:489:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:490:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:491:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:492:18: error: unknown field name in initializer
drivers/media/platform/s5p-tv/hdmi_drv.c:493:18: error: unknown field name in initializer

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index 6c8f159e416e..6a0764c89fcb 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -21,17 +21,8 @@
 #ifndef _V4L2_DV_TIMINGS_H
 #define _V4L2_DV_TIMINGS_H
 
-#if __GNUC__ < 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ < 6))
-/* Sadly gcc versions older than 4.6 have a bug in how they initialize
-   anonymous unions where they require additional curly brackets.
-   This violates the C1x standard. This workaround adds the curly brackets
-   if needed. */
 #define V4L2_INIT_BT_TIMINGS(_width, args...) \
 	{ .bt = { _width , ## args } }
-#else
-#define V4L2_INIT_BT_TIMINGS(_width, args...) \
-	.bt = { _width , ## args }
-#endif
 
 /* CEA-861-E timings (i.e. standard HDTV timings) */
 
-- 
1.9.3
