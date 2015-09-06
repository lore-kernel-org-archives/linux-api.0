From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v8 40/55] [media] media.h: don't use legacy entity macros at Kernel
Date: Sun,  6 Sep 2015 09:03:00 -0300
Message-ID: <3f2e554613f0b1286bd72dfd08f02ac6b874c95e.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <720b750e2738f8c70535b01c9c3a3dddf044db69.1440902901.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <720b750e2738f8c70535b01c9c3a3dddf044db69.1440902901.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Put the legacy MEDIA_ENT_* macros under a #ifndef __KERNEL__,
in order to be sure that none of those old symbols are used
inside the Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Acked-by: Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index f90147cb9b57..a1bd7afba110 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -105,6 +105,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 4)
 #define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 5)
 
+#ifndef __KERNEL__
 /* Legacy symbols used to avoid userspace compilation breakages */
 #define MEDIA_ENT_TYPE_SHIFT		16
 #define MEDIA_ENT_TYPE_MASK		0x00ff0000
@@ -118,6 +119,7 @@ struct media_device_info {
 #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
 #define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
 #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
+#endif
 
 /* Entity types */
 
-- 
2.4.3
