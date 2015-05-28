From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 25/35] DocBook: better document FE_SET_TONE ioctl
Date: Thu, 28 May 2015 18:49:28 -0300
Message-ID: <7ec16730d944eb47423b67dea14ac2032c406ad7.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use the proper format for FE_SET_TONE documentation and
improve the documentation.

Keep the enum fe_sec_tone_mode description together with
the ioctl, as both are used together.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-set-tone.xml

diff --git a/Documentation/DocBook/media/dvb/fe-set-tone.xml b/Documentation/DocBook/media/dvb/fe-set-tone.xml
new file mode 100644
index 000000000000..b4b1f5303170
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-set-tone.xml
@@ -0,0 +1,88 @@
+<refentry id="FE_SET_TONE">
+  <refmeta>
+    <refentrytitle>ioctl FE_SET_TONE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_SET_TONE</refname>
+    <refpurpose>Sets/resets the generation of the continuous 22kHz tone.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&fe-sec-tone-mode; *<parameter>tone</parameter></paramdef>
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
+	  <para>FE_SET_TONE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>pointer to &fe-sec-tone-mode;</parameter></term>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+<para>This ioctl is used to set the generation of the continuous 22kHz tone.
+    This call requires read/write permissions.</para>
+<para>Usually, satellital antenna subsystems require that the digital TV
+    device to send a 22kHz tone in order to select between high/low band on
+    some dual-band LNBf. It is also used to send signals to DiSEqC equipment,
+    but this is done using the DiSEqC ioctls.</para>
+<para>NOTE: if more than one device is connected to the same antenna,
+    setting a tone may interfere on other devices, as they may lose
+    the capability of selecting the band. So, it is recommended that
+    applications would change to SEC_TONE_OFF when the device is not used.</para>
+
+&return-value-dvb;
+</refsect1>
+
+<section id="fe-sec-tone-mode-t">
+<title>enum fe_sec_voltage</title>
+
+<table pgwide="1" frame="none" id="fe-sec-tone-mode">
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
+	    <entry align="char">SEC_TONE_ON</entry>
+	    <entry align="char">Sends a 22kHz tone burst to the antenna</entry>
+	</row><row>
+	    <entry align="char">SEC_TONE_OFF</entry>
+	    <entry align="char">Don't send a 22kHz tone to the antenna
+		(except if the FE_DISEQC_* ioctls are called)</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 584c759b6bbe..f05da4abb3fe 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -75,21 +75,6 @@ specification is available at
 </programlisting>
 </section>
 
-<section id="fe-sec-tone-mode-t">
-<title>SEC continuous tone</title>
-
-<para>The continuous 22KHz tone is usually used with non-DiSEqC capable LNBs to switch the
-high/low band of a dual-band LNB. When using DiSEqC epuipment this voltage has to
-be switched consistently to the DiSEqC commands as described in the DiSEqC
-spec.</para>
-<programlisting>
-	typedef enum fe_sec_tone_mode {
-	SEC_TONE_ON,
-	SEC_TONE_OFF
-	} fe_sec_tone_mode_t;
-</programlisting>
-</section>
-
 <section id="fe-sec-mini-cmd-t">
 <title>SEC tone burst</title>
 
@@ -582,52 +567,8 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 </section>
 
-<section id="FE_SET_TONE">
-<title>FE_SET_TONE</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This call is used to set the generation of the continuous 22kHz tone. This call
- requires read/write permissions.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_SET_TONE">FE_SET_TONE</link>,
- fe_sec_tone_mode_t tone);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
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
-<para>Equals <link linkend="FE_SET_TONE">FE_SET_TONE</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>fe_sec_tone_mode_t
- tone</para>
-</entry><entry
- align="char">
-<para>The requested tone generation mode (on/off).</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-&return-value-dvb;
-</section>
 
+&sub-fe-set-tone;
 &sub-fe-set-voltage;
 &sub-fe-enable-high-lnb-voltage;
 &sub-fe-set-frontend-tune-mode;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 985b76896388..009ff0534806 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -114,10 +114,12 @@ enum fe_sec_voltage {
 typedef enum fe_sec_voltage fe_sec_voltage_t;
 
 
-typedef enum fe_sec_tone_mode {
+enum fe_sec_tone_mode {
 	SEC_TONE_ON,
 	SEC_TONE_OFF
-} fe_sec_tone_mode_t;
+}
+
+typedef enum fe_sec_tone_mode fe_sec_tone_mode_t;
 
 
 typedef enum fe_sec_mini_cmd {
-- 
2.4.1

