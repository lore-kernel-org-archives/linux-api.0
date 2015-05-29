From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 7/8] DocBook: improve documentation for guard interval
Date: Thu, 28 May 2015 22:28:56 -0300
Message-ID: <46da1278eaccfe26cf61017d50dc2f231a8622ee.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Format it as a table and add more details, in special for
DTMB guard intervals.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index b96a91a1494d..5f30a28a15b0 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -818,21 +818,59 @@ typedef enum atscmh_sccc_code_mode {
 		<title><constant>DTV_GUARD_INTERVAL</constant></title>
 
 		<para>Possible values are:</para>
-<programlisting>
-typedef enum fe_guard_interval {
-	GUARD_INTERVAL_1_32,
-	GUARD_INTERVAL_1_16,
-	GUARD_INTERVAL_1_8,
-	GUARD_INTERVAL_1_4,
-	GUARD_INTERVAL_AUTO,
-	GUARD_INTERVAL_1_128,
-	GUARD_INTERVAL_19_128,
-	GUARD_INTERVAL_19_256,
-	GUARD_INTERVAL_PN420,
-	GUARD_INTERVAL_PN595,
-	GUARD_INTERVAL_PN945,
-} fe_guard_interval_t;
-</programlisting>
+
+<section id="fe-guard-interval-t">
+<title>Modulation guard interval</title>
+
+<table pgwide="1" frame="none" id="fe-guard-interval">
+    <title>enum fe_guard_interval</title>
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
+	    <entry>GUARD_INTERVAL_AUTO</entry>
+	    <entry>Autodetect the guard interval</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_1_128</entry>
+	    <entry>Guard interval 1/128</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_1_32</entry>
+	    <entry>Guard interval 1/32</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_1_16</entry>
+	    <entry>Guard interval 1/16</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_1_8</entry>
+	    <entry>Guard interval 1/8</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_1_4</entry>
+	    <entry>Guard interval 1/4</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_19_128</entry>
+	    <entry>Guard interval 19/128</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_19_256</entry>
+	    <entry>Guard interval 19/256</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_PN420</entry>
+	    <entry>PN length 420 (1/4)</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_PN595</entry>
+	    <entry>PN length 595 (1/6)</entry>
+	</row><row>
+	    <entry>GUARD_INTERVAL_PN945</entry>
+	    <entry>PN length 945 (1/9)</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
 
 		<para>Notes:</para>
 		<para>1) If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 563800eb1216..a005c4b472f5 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -59,22 +59,6 @@ specification is available at
 <section>
 <title>More OFDM parameters</title>
 
-<section id="fe-guard-interval-t">
-<title>frontend guard inverval</title>
-<programlisting>
-typedef enum fe_guard_interval {
-	GUARD_INTERVAL_1_32,
-	GUARD_INTERVAL_1_16,
-	GUARD_INTERVAL_1_8,
-	GUARD_INTERVAL_1_4,
-	GUARD_INTERVAL_AUTO,
-	GUARD_INTERVAL_1_128,
-	GUARD_INTERVAL_19_128,
-	GUARD_INTERVAL_19_256,
-} fe_guard_interval_t;
-</programlisting>
-</section>
-
 <section id="fe-hierarchy-t">
 <title>frontend hierarchy</title>
 <programlisting>
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index c1dfbd8096bd..d20f1fd75fa9 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -182,7 +182,7 @@ struct dvb_vsb_parameters {
 	 &fe-code-rate-t;      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
 	 &fe-modulation-t;     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
 	 &fe-transmit-mode-t;  transmission_mode;
-	 fe_guard_interval_t guard_interval;
+	 &fe-guard-interval-t; guard_interval;
 	 fe_hierarchy_t      hierarchy_information;
  };
 </programlisting>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 49f6e980125b..1d2b7c6dee04 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -228,7 +228,7 @@ enum fe_bandwidth {
 typedef enum fe_bandwidth fe_bandwidth_t;
 #endif
 
-typedef enum fe_guard_interval {
+enum fe_guard_interval {
 	GUARD_INTERVAL_1_32,
 	GUARD_INTERVAL_1_16,
 	GUARD_INTERVAL_1_8,
@@ -240,8 +240,9 @@ typedef enum fe_guard_interval {
 	GUARD_INTERVAL_PN420,
 	GUARD_INTERVAL_PN595,
 	GUARD_INTERVAL_PN945,
-} fe_guard_interval_t;
+};
 
+typedef enum fe_guard_interval fe_guard_interval_t;
 
 typedef enum fe_hierarchy {
 	HIERARCHY_NONE,
-- 
2.4.1

