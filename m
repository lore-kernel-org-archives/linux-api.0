From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 22/26] [media] frontend: Fix a typo at the comments
Date: Mon,  8 Jun 2015 16:54:06 -0300
Message-ID: <0a02f00e9330b9f14a46a7b87195f8c151ad2bcf.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The description of struct dtv_stats has a spmall typo:
	FE_SCALE_DECIBELS instead of FE_SCALE_DECIBEL

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 46c7fd1143a5..0380e62fc8b2 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -435,13 +435,13 @@ enum fecap_scale_params {
  *
  * In other words, for ISDB, those values should be filled like:
  *	u.st.stat.svalue[0] = global statistics;
- *	u.st.stat.scale[0] = FE_SCALE_DECIBELS;
+ *	u.st.stat.scale[0] = FE_SCALE_DECIBEL;
  *	u.st.stat.value[1] = layer A statistics;
  *	u.st.stat.scale[1] = FE_SCALE_NOT_AVAILABLE (if not available);
  *	u.st.stat.svalue[2] = layer B statistics;
- *	u.st.stat.scale[2] = FE_SCALE_DECIBELS;
+ *	u.st.stat.scale[2] = FE_SCALE_DECIBEL;
  *	u.st.stat.svalue[3] = layer C statistics;
- *	u.st.stat.scale[3] = FE_SCALE_DECIBELS;
+ *	u.st.stat.scale[3] = FE_SCALE_DECIBEL;
  *	u.st.len = 4;
  */
 struct dtv_stats {
-- 
2.4.2
