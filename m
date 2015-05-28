From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 34/35] DocBook: Better document enum fe_modulation
Date: Thu, 28 May 2015 18:49:37 -0300
Message-ID: <057967adc76bbca08c671869313c0fda5f92ad9b.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Instead of using programlisting, use a table, as this provides
a better view of the structure.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 0fa4ccfd406d..d9861b54f8c8 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -137,25 +137,78 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	</section>
 	<section id="DTV-MODULATION">
 	<title><constant>DTV_MODULATION</constant></title>
-<para>Specifies the frontend modulation type for cable and satellite types. The modulation can be one of the types bellow:</para>
-<programlisting>
- typedef enum fe_modulation {
-	QPSK,
-	QAM_16,
-	QAM_32,
-	QAM_64,
-	QAM_128,
-	QAM_256,
-	QAM_AUTO,
-	VSB_8,
-	VSB_16,
-	PSK_8,
-	APSK_16,
-	APSK_32,
-	DQPSK,
-	QAM_4_NR,
- } fe_modulation_t;
-</programlisting>
+<para>Specifies the frontend modulation type for delivery systems that supports
+    more than one modulation type. The modulation can be one of the types
+    defined by &fe-modulation;.</para>
+
+
+<section id="fe-modulation-t">
+<title>Modulation property</title>
+
+<para>Most of the digital TV standards currently offers more than one possible
+    modulation (sometimes called as "constellation" on some standards). This
+    enum contains the values used by the Kernel. Please notice that not all
+    modulations are supported by a given standard.</para>
+
+<table pgwide="1" frame="none" id="fe-modulation">
+    <title>enum fe_modulation</title>
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
+	    <entry>QPSK</entry>
+	    <entry>QPSK modulation</entry>
+	</row><row>
+	    <entry>QAM_16</entry>
+	    <entry>16-QAM modulation</entry>
+	</row><row>
+	    <entry>QAM_32</entry>
+	    <entry>32-QAM modulation</entry>
+	</row><row>
+	    <entry>QAM_64</entry>
+	    <entry>64-QAM modulation</entry>
+	</row><row>
+	    <entry>QAM_128</entry>
+	    <entry>128-QAM modulation</entry>
+	</row><row>
+	    <entry>QAM_256</entry>
+	    <entry>256-QAM modulation</entry>
+	</row><row>
+	    <entry>QAM_AUTO</entry>
+	    <entry>Autodetect QAM modulation</entry>
+	</row><row>
+	    <entry>VSB_8</entry>
+	    <entry>8-VSB modulation</entry>
+	</row><row>
+	    <entry>VSB_16</entry>
+	    <entry>16-VSB modulation</entry>
+	</row><row>
+	    <entry>PSK_8</entry>
+	    <entry>8-PSK modulation</entry>
+	</row><row>
+	    <entry>APSK_16</entry>
+	    <entry>16-APSK modulation</entry>
+	</row><row>
+	    <entry>APSK_32</entry>
+	    <entry>32-APSK modulation</entry>
+	</row><row>
+	    <entry>DQPSK</entry>
+	    <entry>DQPSK modulation</entry>
+	</row><row>
+	    <entry>QAM_4_NR</entry>
+	    <entry>4-QAM-NR modulation</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+
 	</section>
 	<section id="DTV-BANDWIDTH-HZ">
 		<title><constant>DTV_BANDWIDTH_HZ</constant></title>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 16a4648043d6..07c1284e88c8 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -100,32 +100,6 @@ detection.
 </para>
 </section>
 
-<section id="fe-modulation-t">
-<title>frontend modulation type for QAM, OFDM and VSB</title>
-<para>For cable and terrestrial frontends, e. g. for
-<link linkend="dvb-qam-parameters"><constant>struct dvb_qpsk_parameters</constant></link>,
-<link linkend="dvb-ofdm-parameters"><constant>struct dvb_qam_parameters</constant></link> and
-<link linkend="dvb-vsb-parameters"><constant>struct dvb_qam_parameters</constant></link>,
-it needs to specify the quadrature modulation mode which can be one of the following:
-</para>
-<programlisting>
- typedef enum fe_modulation {
-	QPSK,
-	QAM_16,
-	QAM_32,
-	QAM_64,
-	QAM_128,
-	QAM_256,
-	QAM_AUTO,
-	VSB_8,
-	VSB_16,
-	PSK_8,
-	APSK_16,
-	APSK_32,
-	DQPSK,
- } fe_modulation_t;
-</programlisting>
-</section>
 
 <section>
 <title>More OFDM parameters</title>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 8bc672d57829..b2a27a15371c 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -178,7 +178,7 @@ typedef enum fe_code_rate {
 } fe_code_rate_t;
 
 
-typedef enum fe_modulation {
+enum fe_modulation {
 	QPSK,
 	QAM_16,
 	QAM_32,
@@ -193,7 +193,9 @@ typedef enum fe_modulation {
 	APSK_32,
 	DQPSK,
 	QAM_4_NR,
-} fe_modulation_t;
+};
+
+typedef enum fe_modulation fe_modulation_t;
 
 typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_2K,
-- 
2.4.1

