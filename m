From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 15/26] [media] DocBook: better document the DVB-S2 rolloff factor
Date: Mon,  8 Jun 2015 16:53:59 -0300
Message-ID: <2f31b32afb96df41bcaaf81e33310fc5337feb92.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1433792665.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Instead of using a program listing, use a table and make clearer
what each define means.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index e1d1e2469029..c0aa1ad9eccf 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -468,14 +468,33 @@ get/set up to 64 properties. The actual meaning of each property is described on
 
 	<section id="fe-rolloff-t">
 		<title>fe_rolloff type</title>
-		<programlisting>
-typedef enum fe_rolloff {
-	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
-	ROLLOFF_20,
-	ROLLOFF_25,
-	ROLLOFF_AUTO,
-} fe_rolloff_t;
-		</programlisting>
+<table pgwide="1" frame="none" id="fe-rolloff">
+    <title>enum fe_rolloff</title>
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
+	    <entry align="char" id="ROLLOFF-35"><constant>ROLLOFF_35</constant></entry>
+	    <entry align="char">Roloff factor: &alpha;=35%</entry>
+	</row><row>
+	    <entry align="char" id="ROLLOFF-20"><constant>ROLLOFF_20</constant></entry>
+	    <entry align="char">Roloff factor: &alpha;=20%</entry>
+	</row><row>
+	    <entry align="char" id="ROLLOFF-25"><constant>ROLLOFF_25</constant></entry>
+	    <entry align="char">Roloff factor: &alpha;=25%</entry>
+	</row><row>
+	    <entry align="char" id="ROLLOFF-AUTO"><constant>ROLLOFF_AUTO</constant></entry>
+	    <entry align="char">Auto-detect the roloff factor.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 		</section>
 	</section>
 	<section id="DTV-DISEQC-SLAVE-REPLY">
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index bb222eb04627..cdd9e2fc030d 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -407,12 +407,14 @@ enum fe_pilot {
 
 typedef enum fe_pilot fe_pilot_t;
 
-typedef enum fe_rolloff {
+enum fe_rolloff {
 	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
 	ROLLOFF_20,
 	ROLLOFF_25,
 	ROLLOFF_AUTO,
-} fe_rolloff_t;
+};
+
+typedef enum fe_rolloff fe_rolloff_t;
 
 typedef enum fe_delivery_system {
 	SYS_UNDEFINED,
-- 
2.4.2
