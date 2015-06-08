From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 25/26] [media] dvb: dmx.h: don't use anonymous enums
Date: Mon,  8 Jun 2015 16:54:09 -0300
Message-ID: <457fb3301bb84d4c87d395e8d3783684e3acffc8.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

There are several anonymous enums here, used via a typedef.

Well, we don't like typedefs on Kernel, so let's de-anonimize
those enums. Then, latter, we may be able to get rid of the
typedefs, at least from Kernelspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index b4fb650d9d4f..ece3661a3cac 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -32,7 +32,7 @@
 
 #define DMX_FILTER_SIZE 16
 
-typedef enum
+typedef enum dmx_output
 {
 	DMX_OUT_DECODER, /* Streaming directly to decoder. */
 	DMX_OUT_TAP,     /* Output going to a memory buffer */
@@ -44,7 +44,7 @@ typedef enum
 } dmx_output_t;
 
 
-typedef enum
+typedef enum dmx_input
 {
 	DMX_IN_FRONTEND, /* Input from a front-end device.  */
 	DMX_IN_DVR       /* Input from the logical DVR device.  */
@@ -122,7 +122,7 @@ typedef struct dmx_caps {
 	int num_decoders;
 } dmx_caps_t;
 
-typedef enum {
+typedef enum dmx_source {
 	DMX_SOURCE_FRONT0 = 0,
 	DMX_SOURCE_FRONT1,
 	DMX_SOURCE_FRONT2,
-- 
2.4.2
