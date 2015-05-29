From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 8/8] DocBook: improve documentation for hierarchy
Date: Thu, 28 May 2015 22:28:57 -0300
Message-ID: <bd97fcf94495df76ee2fc9ac8749ff962e18fa0a.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1432862317.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1432862317.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1432862317.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Format it as a table and links it with the legacy API xml.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 5f30a28a15b0..ae9bc1e089cc 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -951,15 +951,43 @@ typedef enum atscmh_sccc_code_mode {
 	<section id="DTV-HIERARCHY">
 	<title><constant>DTV_HIERARCHY</constant></title>
 	<para>Frontend hierarchy</para>
-	<programlisting>
-typedef enum fe_hierarchy {
-	 HIERARCHY_NONE,
-	 HIERARCHY_1,
-	 HIERARCHY_2,
-	 HIERARCHY_4,
-	 HIERARCHY_AUTO
- } fe_hierarchy_t;
-	</programlisting>
+
+
+<section id="fe-hierarchy-t">
+<title>Frontend hierarchy</title>
+
+<table pgwide="1" frame="none" id="fe-hierarchy">
+    <title>enum fe_hierarchy</title>
+    <tgroup cols="2">
+	&cs-def;
+	<thead>
+	<row>
+	    <entry>ID</entry>
+	    <entry>Description</entry>
+	</row>
+	</thead>
+	<tbody valign="top">
+	<row>
+	     <entry>HIERARCHY_NONE</entry>
+	    <entry>No hierarchy</entry>
+	</row><row>
+	     <entry>HIERARCHY_AUTO</entry>
+	    <entry>Autodetect hierarchy (if supported)</entry>
+	</row><row>
+	     <entry>HIERARCHY_1</entry>
+	    <entry>Hierarchy 1</entry>
+	</row><row>
+	     <entry>HIERARCHY_2</entry>
+	    <entry>Hierarchy 2</entry>
+	</row><row>
+	     <entry>HIERARCHY_4</entry>
+	    <entry>Hierarchy 4</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+
 	</section>
 	<section id="DTV-STREAM-ID">
 	<title><constant>DTV_STREAM_ID</constant></title>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index a005c4b472f5..d81b3ff33295 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -56,24 +56,6 @@ specification is available at
 
 &sub-dvbproperty;
 
-<section>
-<title>More OFDM parameters</title>
-
-<section id="fe-hierarchy-t">
-<title>frontend hierarchy</title>
-<programlisting>
-typedef enum fe_hierarchy {
-	 HIERARCHY_NONE,
-	 HIERARCHY_1,
-	 HIERARCHY_2,
-	 HIERARCHY_4,
-	 HIERARCHY_AUTO
- } fe_hierarchy_t;
-</programlisting>
-</section>
-
-</section>
-
 <section id="frontend_fcalls">
 <title>Frontend Function Calls</title>
 
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index d20f1fd75fa9..cb2e18381305 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -183,7 +183,7 @@ struct dvb_vsb_parameters {
 	 &fe-modulation-t;     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
 	 &fe-transmit-mode-t;  transmission_mode;
 	 &fe-guard-interval-t; guard_interval;
-	 fe_hierarchy_t      hierarchy_information;
+	 &fe-hierarchy-t;      hierarchy_information;
  };
 </programlisting>
 </section>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 1d2b7c6dee04..3a7ff9002654 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -244,13 +244,15 @@ enum fe_guard_interval {
 
 typedef enum fe_guard_interval fe_guard_interval_t;
 
-typedef enum fe_hierarchy {
+enum fe_hierarchy {
 	HIERARCHY_NONE,
 	HIERARCHY_1,
 	HIERARCHY_2,
 	HIERARCHY_4,
 	HIERARCHY_AUTO
-} fe_hierarchy_t;
+};
+
+typedef enum fe_hierarchy fe_hierarchy_t;
 
 enum fe_interleaving {
 	INTERLEAVING_NONE,
-- 
2.4.1
