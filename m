From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 16/26] [media] DocBook: properly document the delivery systems
Date: Mon,  8 Jun 2015 16:54:00 -0300
Message-ID: <1696d2ff68a7401f0ad4b613a43740edb863e033.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Hans Verkuil <hans.verkuil@cisco.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use a table for the delivery systems. The table is organized
by the type (cable, satellite, terrestrial) and shows what
standards are not fully implemented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index c0aa1ad9eccf..08227d4e9150 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -515,31 +515,82 @@ get/set up to 64 properties. The actual meaning of each property is described on
 		<section id="fe-delivery-system-t">
 		<title>fe_delivery_system type</title>
 		<para>Possible values: </para>
-<programlisting>
 
-typedef enum fe_delivery_system {
-	SYS_UNDEFINED,
-	SYS_DVBC_ANNEX_A,
-	SYS_DVBC_ANNEX_B,
-	SYS_DVBT,
-	SYS_DSS,
-	SYS_DVBS,
-	SYS_DVBS2,
-	SYS_DVBH,
-	SYS_ISDBT,
-	SYS_ISDBS,
-	SYS_ISDBC,
-	SYS_ATSC,
-	SYS_ATSCMH,
-	SYS_DTMB,
-	SYS_CMMB,
-	SYS_DAB,
-	SYS_DVBT2,
-	SYS_TURBO,
-	SYS_DVBC_ANNEX_C,
-} fe_delivery_system_t;
-</programlisting>
-		</section>
+<table pgwide="1" frame="none" id="fe-delivery-system">
+    <title>enum fe_delivery_system</title>
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
+		<entry id="SYS-UNDEFINED"><constant>SYS_UNDEFINED</constant></entry>
+		<entry>Undefined standard. Generally, indicates an error</entry>
+	</row><row>
+		<entry id="SYS-DVBC-ANNEX-A"><constant>SYS_DVBC_ANNEX_A</constant></entry>
+		<entry>Cable TV: DVB-C following ITU-T J.83 Annex A spec</entry>
+	</row><row>
+		<entry id="SYS-DVBC-ANNEX-B"><constant>SYS_DVBC_ANNEX_B</constant></entry>
+		<entry>Cable TV: DVB-C following ITU-T J.83 Annex B spec (ClearQAM)</entry>
+	</row><row>
+		<entry id="SYS-DVBC-ANNEX-C"><constant>SYS_DVBC_ANNEX_C</constant></entry>
+		<entry>Cable TV: DVB-C following ITU-T J.83 Annex C spec</entry>
+	</row><row>
+		<entry id="SYS-ISDBC"><constant>SYS_ISDBC</constant></entry>
+		<entry>Cable TV: ISDB-C (no drivers yet)</entry>
+	</row><row>
+		<entry id="SYS-DVBT"><constant>SYS_DVBT</constant></entry>
+		<entry>Terrestral TV: DVB-T</entry>
+	</row><row>
+		<entry id="SYS-DVBT2"><constant>SYS_DVBT2</constant></entry>
+		<entry>Terrestral TV: DVB-T2</entry>
+	</row><row>
+		<entry id="SYS-ISDBT"><constant>SYS_ISDBT</constant></entry>
+		<entry>Terrestral TV: ISDB-T</entry>
+	</row><row>
+		<entry id="SYS-ATSC"><constant>SYS_ATSC</constant></entry>
+		<entry>Terrestral TV: ATSC</entry>
+	</row><row>
+		<entry id="SYS-ATSCMH"><constant>SYS_ATSCMH</constant></entry>
+		<entry>Terrestral TV (mobile): ATSC-M/H</entry>
+	</row><row>
+		<entry id="SYS-DTMB"><constant>SYS_DTMB</constant></entry>
+		<entry>Terrestrial TV: DTMB</entry>
+	</row><row>
+		<entry id="SYS-DVBS"><constant>SYS_DVBS</constant></entry>
+		<entry>Satellite TV: DVB-S</entry>
+	</row><row>
+		<entry id="SYS-DVBS2"><constant>SYS_DVBS2</constant></entry>
+		<entry>Satellite TV: DVB-S2</entry>
+	</row><row>
+		<entry id="SYS-TURBO"><constant>SYS_TURBO</constant></entry>
+		<entry>Satellite TV: DVB-S Turbo</entry>
+	</row><row>
+		<entry id="SYS-ISDBS"><constant>SYS_ISDBS</constant></entry>
+		<entry>Satellite TV: ISDB-S</entry>
+	</row><row>
+		<entry id="SYS-DAB"><constant>SYS_DAB</constant></entry>
+		<entry>Digital audio: DAB (not fully supported)</entry>
+	</row><row>
+		<entry id="SYS-DSS"><constant>SYS_DSS</constant></entry>
+		<entry>Satellite TV:"DSS (not fully supported)</entry>
+	</row><row>
+		<entry id="SYS-CMMB"><constant>SYS_CMMB</constant></entry>
+		<entry>Terrestral TV (mobile):CMMB (not fully supported)</entry>
+	</row><row>
+		<entry id="SYS-DVBH"><constant>SYS_DVBH</constant></entry>
+		<entry>Terrestral TV (mobile): DVB-H (standard deprecated)</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+
+
+</section>
 	</section>
 	<section id="DTV-ISDBT-PARTIAL-RECEPTION">
 		<title><constant>DTV_ISDBT_PARTIAL_RECEPTION</constant></title>
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index cdd9e2fc030d..66499f238204 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -416,7 +416,7 @@ enum fe_rolloff {
 
 typedef enum fe_rolloff fe_rolloff_t;
 
-typedef enum fe_delivery_system {
+enum fe_delivery_system {
 	SYS_UNDEFINED,
 	SYS_DVBC_ANNEX_A,
 	SYS_DVBC_ANNEX_B,
@@ -436,7 +436,9 @@ typedef enum fe_delivery_system {
 	SYS_DVBT2,
 	SYS_TURBO,
 	SYS_DVBC_ANNEX_C,
-} fe_delivery_system_t;
+};
+
+typedef enum fe_delivery_system fe_delivery_system_t;
 
 /* backward compatibility */
 #define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
-- 
2.4.2

