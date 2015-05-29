From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4/8] DocBook: improve documentation for OFDM transmission mode
Date: Thu, 28 May 2015 22:28:53 -0300
Message-ID: <abb97d457a590324e19ebb727b46761c287dae14.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Format it as a table and add more details, in special, for
the DTMB modes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 41085537acfc..06a12f1c57c5 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -827,22 +827,61 @@ typedef enum fe_guard_interval {
 	<section id="DTV-TRANSMISSION-MODE">
 		<title><constant>DTV_TRANSMISSION_MODE</constant></title>
 
-		<para>Specifies the number of carriers used by the standard</para>
+		<para>Specifies the number of carriers used by the standard.
+		    This is used only on OFTM-based standards, e. g.
+		    DVB-T/T2, ISDB-T, DTMB</para>
+
+<section id="fe-transmit-mode-t">
+<title>enum fe_transmit_mode: Number of carriers per channel</title>
+
+<table pgwide="1" frame="none" id="fe-transmit-mode">
+    <title>enum fe_transmit_mode</title>
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
+	    <entry>TRANSMISSION_MODE_AUTO</entry>
+	    <entry>Autodetect transmission mode. The hardware will try to find
+		the correct FFT-size (if capable) to fill in the missing
+		parameters.</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_1K</entry>
+	    <entry>Transmission mode 1K</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_2K</entry>
+	    <entry>Transmission mode 2K</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_8K</entry>
+	    <entry>Transmission mode 8K</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_4K</entry>
+	    <entry>Transmission mode 4K</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_16K</entry>
+	    <entry>Transmission mode 16K</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_32K</entry>
+	    <entry>Transmission mode 32K</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_C1</entry>
+	    <entry>Single Carrier (C=1) transmission mode (DTMB)</entry>
+	</row><row>
+	    <entry>TRANSMISSION_MODE_C3780</entry>
+	    <entry>Multi Carrier (C=3780) transmission mode (DTMB)</entry>
+	</row><row>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+
 
-		<para>Possible values are:</para>
-<programlisting>
-typedef enum fe_transmit_mode {
-	TRANSMISSION_MODE_2K,
-	TRANSMISSION_MODE_8K,
-	TRANSMISSION_MODE_AUTO,
-	TRANSMISSION_MODE_4K,
-	TRANSMISSION_MODE_1K,
-	TRANSMISSION_MODE_16K,
-	TRANSMISSION_MODE_32K,
-	TRANSMISSION_MODE_C1,
-	TRANSMISSION_MODE_C3780,
-} fe_transmit_mode_t;
-</programlisting>
 		<para>Notes:</para>
 		<para>1) ISDB-T supports three carrier/symbol-size: 8K, 4K, 2K. It is called
 			'mode' in the standard: Mode 1 is 2K, mode 2 is 4K, mode 3 is 8K</para>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 77dd88ceeedd..3b6a169ac8f3 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -87,21 +87,6 @@ detection.
 <section>
 <title>More OFDM parameters</title>
 
-<section id="fe-transmit-mode-t">
-<title>Number of carriers per channel</title>
-<programlisting>
-typedef enum fe_transmit_mode {
-	TRANSMISSION_MODE_2K,
-	TRANSMISSION_MODE_8K,
-	TRANSMISSION_MODE_AUTO,
-	TRANSMISSION_MODE_4K,
-	TRANSMISSION_MODE_1K,
-	TRANSMISSION_MODE_16K,
-	TRANSMISSION_MODE_32K,
- } fe_transmit_mode_t;
-</programlisting>
-</section>
-
 <section id="fe-bandwidth-t">
 <title>frontend bandwidth</title>
 <programlisting>
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index fe1117e91f51..fa0c6649abfd 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -139,7 +139,7 @@ struct dvb_vsb_parameters {
 	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
 	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
 	 &fe-modulation-t;     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
-	 fe_transmit_mode_t  transmission_mode;
+	 &fe-transmit-mode-t;  transmission_mode;
 	 fe_guard_interval_t guard_interval;
 	 fe_hierarchy_t      hierarchy_information;
  };
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 223905563676..c42e6d849f52 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -198,7 +198,7 @@ enum fe_modulation {
 
 typedef enum fe_modulation fe_modulation_t;
 
-typedef enum fe_transmit_mode {
+enum fe_transmit_mode {
 	TRANSMISSION_MODE_2K,
 	TRANSMISSION_MODE_8K,
 	TRANSMISSION_MODE_AUTO,
@@ -208,7 +208,9 @@ typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_32K,
 	TRANSMISSION_MODE_C1,
 	TRANSMISSION_MODE_C3780,
-} fe_transmit_mode_t;
+};
+
+typedef enum fe_transmit_mode fe_transmit_mode_t;
 
 #if defined(__DVB_CORE__) || !defined (__KERNEL__)
 typedef enum fe_bandwidth {
-- 
2.4.1

