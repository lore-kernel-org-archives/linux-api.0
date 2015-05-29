From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 5/8] DocBook: move fe_bandwidth to the frontend legacy section
Date: Thu, 28 May 2015 22:28:54 -0300
Message-ID: <7a3d45f9e8c246b00208487b0794223873b949d4.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

fe_bandwidth/fe_bandwidth_t is used only on DVBv3 API. So, move
it to the frontend legacy xml, and convert it into a table.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 3b6a169ac8f3..93d22486f20c 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -87,21 +87,6 @@ detection.
 <section>
 <title>More OFDM parameters</title>
 
-<section id="fe-bandwidth-t">
-<title>frontend bandwidth</title>
-<programlisting>
-typedef enum fe_bandwidth {
-	BANDWIDTH_8_MHZ,
-	BANDWIDTH_7_MHZ,
-	BANDWIDTH_6_MHZ,
-	BANDWIDTH_AUTO,
-	BANDWIDTH_5_MHZ,
-	BANDWIDTH_10_MHZ,
-	BANDWIDTH_1_712_MHZ,
-} fe_bandwidth_t;
-</programlisting>
-</section>
-
 <section id="fe-guard-interval-t">
 <title>frontend guard inverval</title>
 <programlisting>
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index fa0c6649abfd..ed393f22f7a7 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -60,6 +60,48 @@ supported via the new <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET
     using the &DTV-DELIVERY-SYSTEM; property.</para>
 </section>
 
+<section id="fe-bandwidth-t">
+<title>Frontend bandwidth</title>
+
+<table pgwide="1" frame="none" id="fe-bandwidth">
+    <title>enum fe_bandwidth</title>
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
+	    <entry>BANDWIDTH_AUTO</entry>
+	    <entry>Autodetect bandwidth (if supported)</entry>
+	</row><row>
+	    <entry>BANDWIDTH_1_712_MHZ</entry>
+	    <entry>1.712 MHz</entry>
+	</row><row>
+	    <entry>BANDWIDTH_5_MHZ</entry>
+	    <entry>5 MHz</entry>
+	</row><row>
+	    <entry>BANDWIDTH_6_MHZ</entry>
+	    <entry>6 MHz</entry>
+	</row><row>
+	    <entry>BANDWIDTH_7_MHZ</entry>
+	    <entry>7 MHz</entry>
+	</row><row>
+	    <entry>BANDWIDTH_8_MHZ</entry>
+	    <entry>8 MHz</entry>
+	</row><row>
+	    <entry>BANDWIDTH_10_MHZ</entry>
+	    <entry>10 MHz</entry>
+	</row><row>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+
+</section>
 
 <section id="dvb-frontend-parameters">
 <title>frontend parameters</title>
@@ -135,7 +177,7 @@ struct dvb_vsb_parameters {
 <para>DVB-T frontends are supported by the <constant>dvb_ofdm_parameters</constant> structure:</para>
 <programlisting>
  struct dvb_ofdm_parameters {
-	 fe_bandwidth_t      bandwidth;
+	 &fe-bandwidth-t;      bandwidth;
 	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
 	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
 	 &fe-modulation-t;     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c42e6d849f52..43e6faf91849 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -213,7 +213,7 @@ enum fe_transmit_mode {
 typedef enum fe_transmit_mode fe_transmit_mode_t;
 
 #if defined(__DVB_CORE__) || !defined (__KERNEL__)
-typedef enum fe_bandwidth {
+enum fe_bandwidth {
 	BANDWIDTH_8_MHZ,
 	BANDWIDTH_7_MHZ,
 	BANDWIDTH_6_MHZ,
@@ -221,7 +221,9 @@ typedef enum fe_bandwidth {
 	BANDWIDTH_5_MHZ,
 	BANDWIDTH_10_MHZ,
 	BANDWIDTH_1_712_MHZ,
-} fe_bandwidth_t;
+};
+
+typedef enum fe_bandwidth fe_bandwidth_t;
 #endif
 
 typedef enum fe_guard_interval {
-- 
2.4.1

