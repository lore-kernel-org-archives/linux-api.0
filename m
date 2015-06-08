From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 17/26] [media] DocBook: add xrefs for enum fe_type
Date: Mon,  8 Jun 2015 16:54:01 -0300
Message-ID: <02391cd7fc77d9a8b77cd8ca67684b73ccaffcc5.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The only enum that was missing xrefs at frontend.h is fe_type.
Add xrefs for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index 8523caf91a2c..8fadf3a4ba44 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -20,22 +20,22 @@
   </thead>
   <tbody valign="top">
   <row>
-     <entry id="FE_QPSK"><constant>FE_QPSK</constant></entry>
+     <entry id="FE-QPSK"><constant>FE_QPSK</constant></entry>
      <entry>For DVB-S standard</entry>
      <entry><constant>SYS_DVBS</constant></entry>
   </row>
   <row>
-     <entry id="FE_QAM"><constant>FE_QAM</constant></entry>
+     <entry id="FE-QAM"><constant>FE_QAM</constant></entry>
      <entry>For DVB-C annex A standard</entry>
      <entry><constant>SYS_DVBC_ANNEX_A</constant></entry>
   </row>
   <row>
-     <entry id="FE_OFDM"><constant>FE_OFDM</constant></entry>
+     <entry id="FE-OFDM"><constant>FE_OFDM</constant></entry>
      <entry>For DVB-T standard</entry>
      <entry><constant>SYS_DVBT</constant></entry>
   </row>
   <row>
-     <entry id="FE_ATSC"><constant>FE_ATSC</constant></entry>
+     <entry id="FE-ATSC"><constant>FE_ATSC</constant></entry>
      <entry>For ATSC standard (terrestrial) or for DVB-C Annex B (cable) used in US.</entry>
      <entry><constant>SYS_ATSC</constant> (terrestrial) or <constant>SYS_DVBC_ANNEX_B</constant> (cable)</entry>
   </row>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 66499f238204..a36d802fae0c 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -28,12 +28,14 @@
 
 #include <linux/types.h>
 
-typedef enum fe_type {
+enum fe_type {
 	FE_QPSK,
 	FE_QAM,
 	FE_OFDM,
 	FE_ATSC
-} fe_type_t;
+};
+
+typedef enum fe_type fe_type_t;
 
 
 enum fe_caps {
-- 
2.4.2
