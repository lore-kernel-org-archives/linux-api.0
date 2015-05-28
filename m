From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 24/35] DocBook: better document FE_SET_VOLTAGE ioctl
Date: Thu, 28 May 2015 18:49:27 -0300
Message-ID: <cc3ad7676eb5b91b53033d36911892d0d72abee8.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use the proper format for FE_SET_VOLTAGE documentation and fix
the documentation. The description for the enum is not 100%,
and it is missing the voltage off value.

Also, it is better to keep the enum description together with
the ioctl, as both are used together.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/fe-set-voltage.xml

diff --git a/Documentation/DocBook/media/dvb/fe-set-voltage.xml b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
new file mode 100644
index 000000000000..a1ee5f9c28e0
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
@@ -0,0 +1,94 @@
+<refentry id="FE_SET_VOLTAGE">
+  <refmeta>
+    <refentrytitle>ioctl FE_SET_VOLTAGE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_SET_VOLTAGE</refname>
+    <refpurpose>Allow setting the DC level sent to the antenna subsystem.</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&fe-sec-voltage; *<parameter>voltage</parameter></paramdef>
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
+	  <para>FE_SET_VOLTAGE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>pointer to &fe-sec-voltage;</parameter></term>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+<para>This ioctl allows to set the DC voltage level sent through the antenna
+    cable to 13V, 18V or off.</para>
+<para>Usually, a satellital antenna subsystems require that the digital TV
+    device to send a DC voltage to feed power to the LNBf. Depending on the
+    LNBf type, the polarization or the intermediate frequency (IF) of the LNBf
+    can controlled by the voltage level. Other devices (for example, the ones
+    that implement DISEqC and multipoint LNBf's don't need to control the
+    voltage level, provided that either 13V or 18V is sent to power up the
+    LNBf.</para>
+<para>NOTE: if more than one device is connected to the same antenna,
+    setting a voltage level may interfere on other devices, as they may lose
+    the capability of setting polarization or IF. So, on those
+    cases, setting the voltage to SEC_VOLTAGE_OFF while the device is not is
+    used is recommended.</para>
+
+&return-value-dvb;
+</refsect1>
+
+<section id="fe-sec-voltage-t">
+<title>enum fe_sec_voltage</title>
+
+<table pgwide="1" frame="none" id="fe-sec-voltage">
+    <title>enum fe_status</title>
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
+	    <entry align="char">SEC_VOLTAGE_13</entry>
+	    <entry align="char">Set DC voltage level to 13V</entry>
+	</row><row>
+	    <entry align="char">SEC_VOLTAGE_18</entry>
+	    <entry align="char">Set DC voltage level to 18V</entry>
+	</row><row>
+	    <entry align="char">SEC_VOLTAGE_OFF</entry>
+	    <entry align="char">Don't send any voltage to the antenna</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+
+</refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index bb2cd9ef3b03..584c759b6bbe 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -75,19 +75,6 @@ specification is available at
 </programlisting>
 </section>
 
-<section id="fe-sec-voltage-t">
-<title>diseqc slave reply</title>
-<para>The voltage is usually used with non-DiSEqC capable LNBs to switch the polarzation
-(horizontal/vertical). When using DiSEqC epuipment this voltage has to be switched
-consistently to the DiSEqC commands as described in the DiSEqC spec.</para>
-<programlisting>
-	typedef enum fe_sec_voltage {
-	SEC_VOLTAGE_13,
-	SEC_VOLTAGE_18
-	} fe_sec_voltage_t;
-</programlisting>
-</section>
-
 <section id="fe-sec-tone-mode-t">
 <title>SEC continuous tone</title>
 
@@ -641,54 +628,7 @@ typedef enum fe_hierarchy {
 &return-value-dvb;
 </section>
 
-<section id="FE_SET_VOLTAGE">
-<title>FE_SET_VOLTAGE</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This call is used to set the bus voltage. This call requires read/write
- permissions.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_SET_VOLTAGE">FE_SET_VOLTAGE</link>,
- fe_sec_voltage_t voltage);</para>
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
-<para>Equals <link linkend="FE_SET_VOLTAGE">FE_SET_VOLTAGE</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>fe_sec_voltage_t
- voltage</para>
-</entry><entry
- align="char">
-<para>The requested bus voltage.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
+&sub-fe-set-voltage;
 &sub-fe-enable-high-lnb-voltage;
 &sub-fe-set-frontend-tune-mode;
 
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 7aeeb5a69fdf..985b76896388 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -105,11 +105,13 @@ struct dvb_diseqc_slave_reply {
 };			/*  errorcode when no message was received  */
 
 
-typedef enum fe_sec_voltage {
+enum fe_sec_voltage {
 	SEC_VOLTAGE_13,
 	SEC_VOLTAGE_18,
 	SEC_VOLTAGE_OFF
-} fe_sec_voltage_t;
+};
+
+typedef enum fe_sec_voltage fe_sec_voltage_t;
 
 
 typedef enum fe_sec_tone_mode {
-- 
2.4.1
