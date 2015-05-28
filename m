From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 26/35] DocBook: better document FE_DISEQC_SEND_BURST ioctl
Date: Thu, 28 May 2015 18:49:29 -0300
Message-ID: <d68e777ec46bb9f68bb620d5f2eb2cb4b99c19c3.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1432844837.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
In-Reply-To: <cover.1432844837.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
References: <cover.1432844837.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Use the proper format for FE_DISEQC_SEND_BURST documentation
and  improve the documentation.

Keep the enum fe_sec_mini_cmd description together with
the ioctl, as both are used together.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml

diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
new file mode 100644
index 000000000000..d1a798048641
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
@@ -0,0 +1,86 @@
+<refentry id="FE_DISEQC_SEND_BURST">
+  <refmeta>
+    <refentrytitle>ioctl FE_DISEQC_SEND_BURST</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_DISEQC_SEND_BURST</refname>
+    <refpurpose>Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite selection.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&fe-sec-mini-cmd; *<parameter>tone</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+        <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fe_fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_DISEQC_SEND_BURST</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>pointer to &fe-sec-mini-cmd;</parameter></term>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+<para>This ioctl is used to set the generation of a 22kHz tone burst for mini
+    DiSEqC satellite
+    selection for 2x1 switches.
+    This call requires read/write permissions.</para>
+<para>It provides support for what's specified at
+    <ulink url="http://www.eutelsat.com/files/contributed/satellites/pdf/Diseqc/associated%20docs/simple_tone_burst_detec.pdf">Digital Satellite Equipment Control
+	(DiSEqC) - Simple "ToneBurst" Detection Circuit specification.</ulink>
+    </para>
+&return-value-dvb;
+</refsect1>
+
+<section id="fe-sec-mini-cmd-t">
+<title>enum fe_sec_mini_cmd</title>
+
+<table pgwide="1" frame="none" id="fe-sec-mini-cmd">
+    <title>enum fe_sec_tone_mode</title>
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
+	    <entry align="char">SEC_MINI_A</entry>
+	    <entry align="char">Sends a mini-DiSEqC 22kHz '0' Tone Burst to
+		select satellite-A</entry>
+	</row><row>
+	    <entry align="char">SEC_MINI_B</entry>
+	    <entry align="char">Sends a mini-DiSEqC 22kHz '1' Data Burst to
+		select satellite-B</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index f05da4abb3fe..17050152a48a 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -75,23 +75,6 @@ specification is available at
 </programlisting>
 </section>
 
-<section id="fe-sec-mini-cmd-t">
-<title>SEC tone burst</title>
-
-<para>The 22KHz tone burst is usually used with non-DiSEqC capable switches to select
-between two connected LNBs/satellites. When using DiSEqC epuipment this voltage has to
-be switched consistently to the DiSEqC commands as described in the DiSEqC
-spec.</para>
-<programlisting>
-	typedef enum fe_sec_mini_cmd {
-	SEC_MINI_A,
-	SEC_MINI_B
-	} fe_sec_mini_cmd_t;
-</programlisting>
-
-<para></para>
-</section>
-
 <section id="fe-spectral-inversion-t">
 <title>frontend spectral inversion</title>
 <para>The Inversion field can take one of these values:
@@ -519,55 +502,7 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 </section>
 
-<section id="FE_DISEQC_SEND_BURST">
-<title>FE_DISEQC_SEND_BURST</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call is used to send a 22KHz tone burst.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request =
- <link linkend="FE_DISEQC_SEND_BURST">FE_DISEQC_SEND_BURST</link>, fe_sec_mini_cmd_t burst);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_DISEQC_SEND_BURST">FE_DISEQC_SEND_BURST</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>fe_sec_mini_cmd_t
- burst</para>
-</entry><entry
- align="char">
-<para>burst A or B.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
-
+&sub-fe-diseqc-send-burst;
 &sub-fe-set-tone;
 &sub-fe-set-voltage;
 &sub-fe-enable-high-lnb-voltage;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 009ff0534806..8bc672d57829 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -122,10 +122,12 @@ enum fe_sec_tone_mode {
 typedef enum fe_sec_tone_mode fe_sec_tone_mode_t;
 
 
-typedef enum fe_sec_mini_cmd {
+enum fe_sec_mini_cmd {
 	SEC_MINI_A,
 	SEC_MINI_B
-} fe_sec_mini_cmd_t;
+};
+
+typedef enum fe_sec_mini_cmd fe_sec_mini_cmd_t;
 
 
 /**
-- 
2.4.1
