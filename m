From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 13/26] [media] DocBook: document DVB-S2 pilot in a table
Date: Mon,  8 Jun 2015 16:53:57 -0300
Message-ID: <812131f645515b00d9f154f55cf7ee28f2f4cb94.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Putting it into a table allows to comment each possible
values, with makes more clear what field means.

Also, it allows to do cross-references with the frontend.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 8d57f0c9b6aa..e31d9457671f 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -417,13 +417,30 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	<para>Sets DVB-S2 pilot</para>
 	<section id="fe-pilot-t">
 		<title>fe_pilot type</title>
-		<programlisting>
-typedef enum fe_pilot {
-	PILOT_ON,
-	PILOT_OFF,
-	PILOT_AUTO,
-} fe_pilot_t;
-		</programlisting>
+<table pgwide="1" frame="none" id="fe-pilot">
+    <title>enum fe_pilot</title>
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
+	    <entry align="char" id="PILOT-ON"><constant>PILOT_ON</constant></entry>
+	    <entry align="char">Pilot tones enabled</entry>
+	</row><row>
+	    <entry align="char" id="PILOT-OFF"><constant>PILOT_OFF</constant></entry>
+	    <entry align="char">Pilot tones disabled</entry>
+	</row><row>
+	    <entry align="char" id="PILOT-AUTO"><constant>PILOT_AUTO</constant></entry>
+	    <entry align="char">Autodetect pilot tones</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 		</section>
 	</section>
 	<section id="DTV-ROLLOFF">
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 3a7ff9002654..bb222eb04627 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -399,11 +399,13 @@ struct dvb_frontend_event {
 
 #define DTV_MAX_COMMAND		DTV_STAT_TOTAL_BLOCK_COUNT
 
-typedef enum fe_pilot {
+enum fe_pilot {
 	PILOT_ON,
 	PILOT_OFF,
 	PILOT_AUTO,
-} fe_pilot_t;
+};
+
+typedef enum fe_pilot fe_pilot_t;
 
 typedef enum fe_rolloff {
 	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
-- 
2.4.2
