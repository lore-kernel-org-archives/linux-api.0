From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 6/8] DocBook: improve documentation for FEC fields
Date: Thu, 28 May 2015 22:28:55 -0300
Message-ID: <68173ff8e9279a842f8ec2e52db7743bf77719fc.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432862317.git.mchehab@osg.samsung.com>
References: <cover.1432862317.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Format it as a table and add more details. Also, remove the
duplicated occurrences.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 06a12f1c57c5..b96a91a1494d 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -290,25 +290,70 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	<title><constant>DTV_INNER_FEC</constant></title>
 	<para>Used cable/satellite transmissions. The acceptable values are:
 	</para>
-	<programlisting>
-typedef enum fe_code_rate {
-	FEC_NONE = 0,
-	FEC_1_2,
-	FEC_2_3,
-	FEC_3_4,
-	FEC_4_5,
-	FEC_5_6,
-	FEC_6_7,
-	FEC_7_8,
-	FEC_8_9,
-	FEC_AUTO,
-	FEC_3_5,
-	FEC_9_10,
-	FEC_2_5,
-} fe_code_rate_t;
-	</programlisting>
-	<para>which correspond to error correction rates of 1/2, 2/3, etc.,
-	no error correction or auto detection.</para>
+<section id="fe-code-rate-t">
+<title>enum fe_code_rate: type of the Forward Error Correction.</title>
+
+<table pgwide="1" frame="none" id="fe-code-rate">
+    <title>enum fe_code_rate</title>
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
+	    <entry>FEC_NONE</entry>
+	    <entry>No Forward Error Correction Code</entry>
+	</row><row>
+	    <entry>FEC_AUTO</entry>
+	    <entry>Autodetect Error Correction Code</entry>
+	</row><row>
+	    <entry>FEC_1_2</entry>
+	    <entry>Forward Error Correction Code 1/2</entry>
+	</row><row>
+	    <entry>FEC_2_3</entry>
+	    <entry>Forward Error Correction Code 2/3</entry>
+	</row><row>
+	    <entry>FEC_3_4</entry>
+	    <entry>Forward Error Correction Code 3/4</entry>
+	</row><row>
+	    <entry>FEC_4_5</entry>
+	    <entry>Forward Error Correction Code 4/5</entry>
+	</row><row>
+	    <entry>FEC_5_6</entry>
+	    <entry>Forward Error Correction Code 5/6</entry>
+	</row><row>
+	    <entry>FEC_6_7</entry>
+	    <entry>Forward Error Correction Code 6/7</entry>
+	</row><row>
+	    <entry>FEC_7_8</entry>
+	    <entry>Forward Error Correction Code 7/8</entry>
+	</row><row>
+	    <entry>FEC_8_9</entry>
+	    <entry>Forward Error Correction Code 8/9</entry>
+	</row><row>
+	    <entry>FEC_9_10</entry>
+	    <entry>Forward Error Correction Code 9/10</entry>
+	</row><row>
+	    <entry>FEC_2_5</entry>
+	    <entry>Forward Error Correction Code 2/5</entry>
+	</row><row>
+	    <entry>FEC_3_5</entry>
+	    <entry>Forward Error Correction Code 3/5</entry>
+	</row><row>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
 	</section>
 	<section id="DTV-VOLTAGE">
 	<title><constant>DTV_VOLTAGE</constant></title>
@@ -757,46 +802,18 @@ typedef enum atscmh_sccc_code_mode {
 	</section>
 	<section id="DTV-CODE-RATE-HP">
 	<title><constant>DTV_CODE_RATE_HP</constant></title>
-	<para>Used on terrestrial transmissions. The acceptable values are:
+	<para>Used on terrestrial transmissions.  The acceptable values are
+	    the ones described at &fe-transmit-mode-t;.
 	</para>
-	<programlisting>
-typedef enum fe_code_rate {
-	FEC_NONE = 0,
-	FEC_1_2,
-	FEC_2_3,
-	FEC_3_4,
-	FEC_4_5,
-	FEC_5_6,
-	FEC_6_7,
-	FEC_7_8,
-	FEC_8_9,
-	FEC_AUTO,
-	FEC_3_5,
-	FEC_9_10,
-} fe_code_rate_t;
-	</programlisting>
 	</section>
 	<section id="DTV-CODE-RATE-LP">
 	<title><constant>DTV_CODE_RATE_LP</constant></title>
-	<para>Used on terrestrial transmissions. The acceptable values are:
+	<para>Used on terrestrial transmissions. The acceptable values are
+	    the ones described at &fe-transmit-mode-t;.
 	</para>
-	<programlisting>
-typedef enum fe_code_rate {
-	FEC_NONE = 0,
-	FEC_1_2,
-	FEC_2_3,
-	FEC_3_4,
-	FEC_4_5,
-	FEC_5_6,
-	FEC_6_7,
-	FEC_7_8,
-	FEC_8_9,
-	FEC_AUTO,
-	FEC_3_5,
-	FEC_9_10,
-} fe_code_rate_t;
-	</programlisting>
+
 	</section>
+
 	<section id="DTV-GUARD-INTERVAL">
 		<title><constant>DTV_GUARD_INTERVAL</constant></title>
 
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 93d22486f20c..563800eb1216 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -56,34 +56,6 @@ specification is available at
 
 &sub-dvbproperty;
 
-<section id="fe-code-rate-t">
-<title>frontend code rate</title>
-<para>The possible values for the <constant>fec_inner</constant> field used on
-<link linkend="dvb-qpsk-parameters"><constant>struct dvb_qpsk_parameters</constant></link> and
-<link linkend="dvb-qam-parameters"><constant>struct dvb_qam_parameters</constant></link> are:
-</para>
-<programlisting>
-typedef enum fe_code_rate {
-	FEC_NONE = 0,
-	FEC_1_2,
-	FEC_2_3,
-	FEC_3_4,
-	FEC_4_5,
-	FEC_5_6,
-	FEC_6_7,
-	FEC_7_8,
-	FEC_8_9,
-	FEC_AUTO,
-	FEC_3_5,
-	FEC_9_10,
-} fe_code_rate_t;
-</programlisting>
-<para>which correspond to error correction rates of 1/2, 2/3, etc., no error correction or auto
-detection.
-</para>
-</section>
-
-
 <section>
 <title>More OFDM parameters</title>
 
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index ed393f22f7a7..c1dfbd8096bd 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -145,7 +145,7 @@ OFDM frontends the <constant>frequency</constant> specifies the absolute frequen
 <programlisting>
  struct dvb_qpsk_parameters {
 	 uint32_t        symbol_rate;  /&#x22C6; symbol rate in Symbols per second &#x22C6;/
-	 fe_code_rate_t  fec_inner;    /&#x22C6; forward error correction (see above) &#x22C6;/
+	 &fe-code-rate-t;  fec_inner;    /&#x22C6; forward error correction (see above) &#x22C6;/
  };
 </programlisting>
 </section>
@@ -156,7 +156,7 @@ OFDM frontends the <constant>frequency</constant> specifies the absolute frequen
 <programlisting>
  struct dvb_qam_parameters {
 	 uint32_t         symbol_rate; /&#x22C6; symbol rate in Symbols per second &#x22C6;/
-	 fe_code_rate_t   fec_inner;   /&#x22C6; forward error correction (see above) &#x22C6;/
+	 &fe-code-rate-t;   fec_inner;   /&#x22C6; forward error correction (see above) &#x22C6;/
 	 &fe-modulation-t;  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
  };
 </programlisting>
@@ -178,8 +178,8 @@ struct dvb_vsb_parameters {
 <programlisting>
  struct dvb_ofdm_parameters {
 	 &fe-bandwidth-t;      bandwidth;
-	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
-	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
+	 &fe-code-rate-t;      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
+	 &fe-code-rate-t;      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
 	 &fe-modulation-t;     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
 	 &fe-transmit-mode-t;  transmission_mode;
 	 fe_guard_interval_t guard_interval;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 43e6faf91849..49f6e980125b 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -162,7 +162,7 @@ enum fe_spectral_inversion {
 
 typedef enum fe_spectral_inversion fe_spectral_inversion_t;
 
-typedef enum fe_code_rate {
+enum fe_code_rate {
 	FEC_NONE = 0,
 	FEC_1_2,
 	FEC_2_3,
@@ -176,7 +176,9 @@ typedef enum fe_code_rate {
 	FEC_3_5,
 	FEC_9_10,
 	FEC_2_5,
-} fe_code_rate_t;
+};
+
+typedef enum fe_code_rate fe_code_rate_t;
 
 
 enum fe_modulation {
-- 
2.4.1
