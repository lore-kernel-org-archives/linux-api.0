From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 26/26] [media] DocBook: Change format for enum dmx_output documentation
Date: Mon,  8 Jun 2015 16:54:10 -0300
Message-ID: <7452be004f4917c424de5fc55f8527551e1f504a.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use a table for the Demux output. No new information added
here. They were all merged inside the table.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index e7d44a0b00d6..23996f88cd58 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -88,12 +88,8 @@ ENUMS = \
 
 ENUM_DEFS = \
 	$(shell perl -e 'open IN,"cat @ARGV| cpp -fpreprocessed |"; while (<IN>) { if ($$enum) {print "$$1\n" if (/\s*([A-Z]\S+)\b/); } $$enum = 0 if ($$enum && /^\}/); $$enum = 1 if(/^\s*enum\s/); }; close IN;' \
-		$(srctree)/include/uapi/linux/dvb/audio.h \
-		$(srctree)/include/uapi/linux/dvb/ca.h \
 		$(srctree)/include/uapi/linux/dvb/dmx.h \
-		$(srctree)/include/uapi/linux/dvb/frontend.h \
-		$(srctree)/include/uapi/linux/dvb/net.h \
-		$(srctree)/include/uapi/linux/dvb/video.h)
+		$(srctree)/include/uapi/linux/dvb/frontend.h)
 
 STRUCTS = \
 	$(shell perl -ne 'print "$$1 " if /^struct\s+([^\s]+)\s+/' $(srctree)/include/uapi/linux/videodev2.h) \
@@ -251,9 +247,14 @@ $(MEDIA_OBJ_DIR)/dmx.h.xml: $(srctree)/include/uapi/linux/dvb/dmx.h $(MEDIA_OBJ_
 	@(					\
 	echo "<programlisting>") > $@
 	@(					\
+	for ident in $(ENUM_DEFS) ; do		\
+	  entity=`echo $$ident | tr _ -` ;	\
+	  r="$$r s/([^\w\-])$$ident([^\w\-])/\1\&$$entity\;\2/g;";\
+	done;					\
 	expand --tabs=8 < $< |			\
 	  sed $(ESCAPE) $(DVB_DOCUMENTED) |	\
-	  sed 's/i\.e\./&ie;/') >> $@
+	  sed 's/i\.e\./&ie;/' |		\
+	  perl -ne "$$r print $$_;") >> $@
 	@(					\
 	echo "</programlisting>") >> $@
 
diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index 11a831d58643..34f2fb1cd601 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -8,26 +8,43 @@ accessed by including <constant>linux/dvb/dmx.h</constant> in your application.
 <title>Demux Data Types</title>
 
 <section id="dmx-output-t">
-<title>dmx_output_t</title>
-<programlisting>
-typedef enum
-{
-	DMX_OUT_DECODER, /&#x22C6; Streaming directly to decoder. &#x22C6;/
-	DMX_OUT_TAP,     /&#x22C6; Output going to a memory buffer &#x22C6;/
-			 /&#x22C6; (to be retrieved via the read command).&#x22C6;/
-	DMX_OUT_TS_TAP,  /&#x22C6; Output multiplexed into a new TS  &#x22C6;/
-			 /&#x22C6; (to be retrieved by reading from the &#x22C6;/
-			 /&#x22C6; logical DVR device).                 &#x22C6;/
-	DMX_OUT_TSDEMUX_TAP /&#x22C6; Like TS_TAP but retrieved from the DMX device &#x22C6;/
-} dmx_output_t;
-</programlisting>
-<para><constant>DMX_OUT_TAP</constant> delivers the stream output to the demux device on which the ioctl is
-called.
-</para>
-<para><constant>DMX_OUT_TS_TAP</constant> routes output to the logical DVR device <constant>/dev/dvb/adapter?/dvr?</constant>,
-which delivers a TS multiplexed from all filters for which <constant>DMX_OUT_TS_TAP</constant> was
-specified.
-</para>
+<title>Output for the demux</title>
+
+<table pgwide="1" frame="none" id="dmx-output">
+    <title>enum dmx_output</title>
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
+		<entry align="char" id="DMX-OUT-DECODER">DMX_OUT_DECODER</entry>
+		<entry>Streaming directly to decoder.</entry>
+	</row><row>
+		<entry align="char" id="DMX-OUT-TAP">DMX_OUT_TAP</entry>
+		<entry>Output going to a memory buffer (to be retrieved via the
+		    read command). Delivers the stream output to the demux
+		    device on which the ioctl is called.</entry>
+	</row><row>
+		<entry align="char" id="DMX-OUT-TS-TAP">DMX_OUT_TS_TAP</entry>
+		<entry>Output multiplexed into a new TS (to be retrieved by
+		    reading from the logical DVR device). Routes output to the
+		    logical DVR device <constant>/dev/dvb/adapter?/dvr?</constant>,
+		    which delivers a TS multiplexed from all filters for which
+		    <constant>DMX_OUT_TS_TAP</constant> was specified.</entry>
+	</row><row>
+		<entry align="char" id="DMX-OUT-TSDEMUX-TAP">DMX_OUT_TSDEMUX_TAP</entry>
+		<entry>Like &DMX-OUT-TS-TAP; but retrieved from the DMX
+		    device.</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+
 </section>
 
 <section id="dmx-input-t">
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index ece3661a3cac..427e4899ed69 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -32,7 +32,7 @@
 
 #define DMX_FILTER_SIZE 16
 
-typedef enum dmx_output
+enum dmx_output
 {
 	DMX_OUT_DECODER, /* Streaming directly to decoder. */
 	DMX_OUT_TAP,     /* Output going to a memory buffer */
@@ -41,8 +41,9 @@ typedef enum dmx_output
 			 /* (to be retrieved by reading from the */
 			 /* logical DVR device).                 */
 	DMX_OUT_TSDEMUX_TAP /* Like TS_TAP but retrieved from the DMX device */
-} dmx_output_t;
+};
 
+typedef enum dmx_output dmx_output_t;
 
 typedef enum dmx_input
 {
@@ -139,7 +140,6 @@ struct dmx_stc {
 	__u64 stc;		/* output: stc in 'base'*90 kHz units */
 };
 
-
 #define DMX_START                _IO('o', 41)
 #define DMX_STOP                 _IO('o', 42)
 #define DMX_SET_FILTER           _IOW('o', 43, struct dmx_sct_filter_params)
-- 
2.4.2

