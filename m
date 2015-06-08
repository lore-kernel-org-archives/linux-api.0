From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 24/26] [media] dvb: frontend.h: add a note for the deprecated enums/structs
Date: Mon,  8 Jun 2015 16:54:08 -0300
Message-ID: <ee21941f1974eb73eda6b4d7b939148982a7ced3.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Let be clear, at the header, about what got deprecated.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index e764fd8b7e35..00a20cd21ee2 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -486,6 +486,12 @@ struct dtv_properties {
 
 #if defined(__DVB_CORE__) || !defined (__KERNEL__)
 
+/*
+ * DEPRECATED: The DVBv3 ioctls, structs and enums should not be used on
+ * newer programs, as it doesn't support the second generation of digital
+ * TV standards, nor supports newer delivery systems.
+ */
+
 enum fe_bandwidth {
 	BANDWIDTH_8_MHZ,
 	BANDWIDTH_7_MHZ,
-- 
2.4.2
