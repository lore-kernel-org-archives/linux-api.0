From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4/4] [media] use https://linuxtv.org for LinuxTV URLs
Date: Fri,  4 Dec 2015 10:46:23 -0200
Message-ID: <991ce92f8de24cde063d531246602b6e14d3fef2.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
In-Reply-To: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Hans Verkuil <hans.verkuil@cisco.com>, Masanari Iida <standby24x7@gmail.com>, Antti Palosaari <crope@iki.fi>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@oracle.com>, Vaishali Thakkar <vthakkar1994@gmail.com>, Olli Salonen <olli.salonen@iki.fi>, Nibble Max <nibble.max@gmail.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

While https was always supported on linuxtv.org, only in
Dec 3 2015 the website is using valid certificates.

As we're planning to drop pure http support on some
future, change all references at the media subsystem
to point to the https URL instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml    |  2 +-
 Documentation/DocBook/media/dvb/examples.xml       |  2 +-
 Documentation/DocBook/media/dvb/intro.xml          |  2 +-
 Documentation/DocBook/media/v4l/capture.c.xml      |  2 +-
 Documentation/DocBook/media/v4l/compat.xml         |  2 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |  2 +-
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |  2 +-
 Documentation/DocBook/media/v4l/vidioc-enumstd.xml |  2 +-
 Documentation/DocBook/media_api.tmpl               |  6 +++---
 Documentation/dvb/README.dvb-usb                   |  4 ++--
 Documentation/dvb/faq.txt                          |  2 +-
 Documentation/dvb/get_dvb_firmware                 | 22 +++++++++++-----------
 Documentation/dvb/readme.txt                       | 10 +++++-----
 Documentation/video4linux/API.html                 |  2 +-
 Documentation/video4linux/fimc.txt                 |  6 +++---
 drivers/media/Kconfig                              |  4 ++--
 drivers/media/dvb-frontends/bsbe1-d01a.h           |  2 +-
 drivers/media/dvb-frontends/bsbe1.h                |  2 +-
 drivers/media/dvb-frontends/bsru6.h                |  2 +-
 drivers/media/dvb-frontends/isl6405.c              |  2 +-
 drivers/media/dvb-frontends/isl6405.h              |  2 +-
 drivers/media/dvb-frontends/isl6421.c              |  2 +-
 drivers/media/dvb-frontends/isl6421.h              |  2 +-
 drivers/media/dvb-frontends/lnbp21.c               |  2 +-
 drivers/media/dvb-frontends/lnbp21.h               |  2 +-
 drivers/media/dvb-frontends/lnbp22.c               |  2 +-
 drivers/media/dvb-frontends/lnbp22.h               |  2 +-
 drivers/media/dvb-frontends/tdhd1.h                |  2 +-
 drivers/media/pci/ttpci/av7110.c                   |  6 +++---
 drivers/media/pci/ttpci/av7110_av.c                |  2 +-
 drivers/media/pci/ttpci/av7110_ca.c                |  2 +-
 drivers/media/pci/ttpci/av7110_hw.c                |  2 +-
 drivers/media/pci/ttpci/av7110_v4l.c               |  2 +-
 drivers/media/pci/ttpci/budget-av.c                |  2 +-
 drivers/media/pci/ttpci/budget-ci.c                |  2 +-
 drivers/media/pci/ttpci/budget-core.c              |  2 +-
 drivers/media/pci/ttpci/budget-patch.c             |  2 +-
 drivers/media/pci/ttpci/budget.c                   |  2 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |  2 +-
 drivers/media/usb/dvb-usb/Kconfig                  |  2 +-
 include/linux/videodev2.h                          |  2 +-
 include/uapi/linux/videodev2.h                     |  2 +-
 42 files changed, 64 insertions(+), 64 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 08227d4e9150..e579ae5088ae 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -76,7 +76,7 @@ int main(void)
 
 <para>NOTE: While it is possible to directly call the Kernel code like the
     above example, it is strongly recommended to use
-    <ulink url="http://linuxtv.org/docs/libdvbv5/index.html">libdvbv5</ulink>,
+    <ulink url="https://linuxtv.org/docs/libdvbv5/index.html">libdvbv5</ulink>,
     as it provides abstraction to work with the supported digital TV standards
     and provides methods for usual operations like program scanning and to
     read/write channel descriptor files.</para>
diff --git a/Documentation/DocBook/media/dvb/examples.xml b/Documentation/DocBook/media/dvb/examples.xml
index c9f68c7183cc..837fb3b64b72 100644
--- a/Documentation/DocBook/media/dvb/examples.xml
+++ b/Documentation/DocBook/media/dvb/examples.xml
@@ -3,7 +3,7 @@
 </para>
 <para>NOTE: This section is out of date, and the code below won't even
     compile. Please refer to the
-    <ulink url="http://linuxtv.org/docs/libdvbv5/index.html">libdvbv5</ulink>
+    <ulink url="https://linuxtv.org/docs/libdvbv5/index.html">libdvbv5</ulink>
     for updated/recommended examples.
 </para>
 
diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 51db15648099..b5b701f5d8c2 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -32,7 +32,7 @@ and filtering several section and PES data streams at the same time.
 new standard Linux DVB API. As a commitment to the development of
 terminals based on open standards, Nokia and Convergence made it
 available to all Linux developers and published it on
-<ulink url="http://www.linuxtv.org/" /> in September 2000.
+<ulink url="https://linuxtv.org" /> in September 2000.
 Convergence is the maintainer of the Linux DVB API. Together with the
 LinuxTV community (i.e. you, the reader of this document), the Linux DVB
 API will be constantly reviewed and improved. With the Linux driver for
diff --git a/Documentation/DocBook/media/v4l/capture.c.xml b/Documentation/DocBook/media/v4l/capture.c.xml
index 1c5c49a2de59..22126a991b34 100644
--- a/Documentation/DocBook/media/v4l/capture.c.xml
+++ b/Documentation/DocBook/media/v4l/capture.c.xml
@@ -5,7 +5,7 @@
  *  This program can be used and distributed without restrictions.
  *
  *      This program is provided with the V4L2 API
- * see http://linuxtv.org/docs.php for more information
+ * see https://linuxtv.org/docs.php for more information
  */
 
 #include &lt;stdio.h&gt;
diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 5701a08ed792..5399e8904715 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2666,7 +2666,7 @@ is useful to display images captured with V4L2 devices.</para>
         <para>V4L2 does not support digital terrestrial, cable or
 satellite broadcast. A separate project aiming at digital receivers
 exists. You can find its homepage at <ulink
-url="http://linuxtv.org">http://linuxtv.org</ulink>. The Linux DVB API
+url="https://linuxtv.org">https://linuxtv.org</ulink>. The Linux DVB API
 has no connection to the V4L2 API except that drivers for hybrid
 hardware may support both.</para>
       </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
index 4c4603c135fe..f14a3bb1afaa 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml
@@ -99,7 +99,7 @@ if the driver supports writing registers to the device.</para>
     <para>We recommended the <application>v4l2-dbg</application>
 utility over calling this ioctl directly. It is available from the
 LinuxTV v4l-dvb repository; see <ulink
-url="http://linuxtv.org/repo/">http://linuxtv.org/repo/</ulink> for
+url="https://linuxtv.org/repo/">https://linuxtv.org/repo/</ulink> for
 access instructions.</para>
 
     <!-- Note for convenience vidioc-dbg-g-register.sgml
diff --git a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
index 3d038e75d12b..5877f68a5820 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml
@@ -117,7 +117,7 @@ However when a driver supports these ioctls it must also support
     <para>We recommended the <application>v4l2-dbg</application>
 utility over calling these ioctls directly. It is available from the
 LinuxTV v4l-dvb repository; see <ulink
-url="http://linuxtv.org/repo/">http://linuxtv.org/repo/</ulink> for
+url="https://linuxtv.org/repo/">https://linuxtv.org/repo/</ulink> for
 access instructions.</para>
 
     <!-- Note for convenience vidioc-dbg-g-chip-info.sgml
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumstd.xml b/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
index 8065099401d1..f18454e91752 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumstd.xml
@@ -198,7 +198,7 @@ video4linux-list@redhat.com on 17 Oct 2002
 <constant>V4L2_STD_ATSC_16_VSB</constant> are U.S. terrestrial digital
 TV standards. Presently the V4L2 API does not support digital TV. See
 also the Linux DVB API at <ulink
-url="http://linuxtv.org">http://linuxtv.org</ulink>.</para>
+url="https://linuxtv.org">https://linuxtv.org</ulink>.</para>
 <para><programlisting>
 #define V4L2_STD_PAL_BG         (V4L2_STD_PAL_B         |\
 				 V4L2_STD_PAL_B1        |\
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 92037033f5eb..7b77e0f7b87d 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -19,10 +19,10 @@
 <!ENTITY cs-def                 "<colspec colname='c1' colwidth='3*' /><colspec colname='c2' colwidth='1*' /><colspec colname='c3' colwidth='4*' /><spanspec spanname='hspan' namest='c1' nameend='c3' />">
 
 <!-- Video for Linux mailing list address. -->
-<!ENTITY v4l-ml                 "<ulink url='http://www.linuxtv.org/lists.php'>http://www.linuxtv.org/lists.php</ulink>">
+<!ENTITY v4l-ml                 "<ulink url='https://linuxtv.org/lists.php'>https://linuxtv.org/lists.php</ulink>">
 
 <!-- LinuxTV v4l-dvb repository. -->
-<!ENTITY v4l-dvb		"<ulink url='http://linuxtv.org/repo/'>http://linuxtv.org/repo/</ulink>">
+<!ENTITY v4l-dvb		"<ulink url='https://linuxtv.org/repo/'>https://linuxtv.org/repo/</ulink>">
 <!ENTITY dash-ent-8             "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 <!ENTITY dash-ent-10            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
 <!ENTITY dash-ent-12            "<entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry><entry>-</entry>">
@@ -91,7 +91,7 @@
 	      components, like mixers, PCM capture, PCM playback, etc, which
 	      are controlled via ALSA API.</para>
 	<para>For additional information and for the latest development code,
-		see: <ulink url="http://linuxtv.org">http://linuxtv.org</ulink>.</para>
+		see: <ulink url="https://linuxtv.org">https://linuxtv.org</ulink>.</para>
 	<para>For discussing improvements, reporting troubles, sending new drivers, etc, please mail to: <ulink url="http://vger.kernel.org/vger-lists.html#linux-media">Linux Media Mailing List (LMML).</ulink>.</para>
 </preface>
 
diff --git a/Documentation/dvb/README.dvb-usb b/Documentation/dvb/README.dvb-usb
index 8eb92264ee04..669dc6ce4330 100644
--- a/Documentation/dvb/README.dvb-usb
+++ b/Documentation/dvb/README.dvb-usb
@@ -45,7 +45,7 @@ Supported devices
 See the LinuxTV DVB Wiki at www.linuxtv.org for a complete list of
 cards/drivers/firmwares:
 
-http://www.linuxtv.org/wiki/index.php/DVB_USB
+https://linuxtv.org/wiki/index.php/DVB_USB
 
 0. History & News:
   2005-06-30 - added support for WideView WT-220U (Thanks to Steve Chang)
@@ -121,7 +121,7 @@ working.
 Have a look at the Wikipage for the DVB-USB-drivers to find out, which firmware
 you need for your device:
 
-http://www.linuxtv.org/wiki/index.php/DVB_USB
+https://linuxtv.org/wiki/index.php/DVB_USB
 
 1.2. Compiling
 
diff --git a/Documentation/dvb/faq.txt b/Documentation/dvb/faq.txt
index 97b1373f2428..a0be92012877 100644
--- a/Documentation/dvb/faq.txt
+++ b/Documentation/dvb/faq.txt
@@ -76,7 +76,7 @@ Some very frequently asked questions about linuxtv-dvb
 		the TuxBox CVS many interesting DVB applications and the dBox2
 		DVB source
 
-	http://www.linuxtv.org/downloads/	
+	https://linuxtv.org/downloads
 		DVB Swiss Army Knife library and utilities
 
 	http://www.nenie.org/misc/mpsys/
diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 91b43d2738c7..1a0a04125f71 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -152,7 +152,7 @@ sub tda10046lifeview {
 
 sub av7110 {
     my $sourcefile = "dvb-ttpci-01.fw-261d";
-    my $url = "http://www.linuxtv.org/downloads/firmware/$sourcefile";
+    my $url = "https://linuxtv.org/downloads/firmware/$sourcefile";
     my $hash = "603431b6259715a8e88f376a53b64e2f";
     my $outfile = "dvb-ttpci-01.fw";
 
@@ -303,7 +303,7 @@ sub vp7049 {
 }
 
 sub dibusb {
-	my $url = "http://www.linuxtv.org/downloads/firmware/dvb-usb-dibusb-5.0.0.11.fw";
+	my $url = "https://linuxtv.org/downloads/firmware/dvb-usb-dibusb-5.0.0.11.fw";
 	my $outfile = "dvb-dibusb-5.0.0.11.fw";
 	my $hash = "fa490295a527360ca16dcdf3224ca243";
 
@@ -351,7 +351,7 @@ sub nxt2004 {
 
 sub or51211 {
     my $fwfile = "dvb-fe-or51211.fw";
-    my $url = "http://linuxtv.org/downloads/firmware/$fwfile";
+    my $url = "https://linuxtv.org/downloads/firmware/$fwfile";
     my $hash = "d830949c771a289505bf9eafc225d491";
 
     checkstandard();
@@ -364,7 +364,7 @@ sub or51211 {
 
 sub cx231xx {
     my $fwfile = "v4l-cx231xx-avcore-01.fw";
-    my $url = "http://linuxtv.org/downloads/firmware/$fwfile";
+    my $url = "https://linuxtv.org/downloads/firmware/$fwfile";
     my $hash = "7d3bb956dc9df0eafded2b56ba57cc42";
 
     checkstandard();
@@ -376,7 +376,7 @@ sub cx231xx {
 }
 
 sub cx18 {
-    my $url = "http://linuxtv.org/downloads/firmware/";
+    my $url = "https://linuxtv.org/downloads/firmware/";
 
     my %files = (
 	'v4l-cx23418-apu.fw' => '588f081b562f5c653a3db1ad8f65939a',
@@ -450,7 +450,7 @@ sub mpc718 {
 }
 
 sub cx23885 {
-    my $url = "http://linuxtv.org/downloads/firmware/";
+    my $url = "https://linuxtv.org/downloads/firmware/";
 
     my %files = (
 	'v4l-cx23885-avcore-01.fw' => 'a9f8f5d901a7fb42f552e1ee6384f3bb',
@@ -472,7 +472,7 @@ sub cx23885 {
 }
 
 sub pvrusb2 {
-    my $url = "http://linuxtv.org/downloads/firmware/";
+    my $url = "https://linuxtv.org/downloads/firmware/";
 
     my %files = (
 	'v4l-cx25840.fw'           => 'dadb79e9904fc8af96e8111d9cb59320',
@@ -494,7 +494,7 @@ sub pvrusb2 {
 
 sub or51132_qam {
     my $fwfile = "dvb-fe-or51132-qam.fw";
-    my $url = "http://linuxtv.org/downloads/firmware/$fwfile";
+    my $url = "https://linuxtv.org/downloads/firmware/$fwfile";
     my $hash = "7702e8938612de46ccadfe9b413cb3b5";
 
     checkstandard();
@@ -507,7 +507,7 @@ sub or51132_qam {
 
 sub or51132_vsb {
     my $fwfile = "dvb-fe-or51132-vsb.fw";
-    my $url = "http://linuxtv.org/downloads/firmware/$fwfile";
+    my $url = "https://linuxtv.org/downloads/firmware/$fwfile";
     my $hash = "c16208e02f36fc439a557ad4c613364a";
 
     checkstandard();
@@ -519,7 +519,7 @@ sub or51132_vsb {
 }
 
 sub bluebird {
-	my $url = "http://www.linuxtv.org/download/dvb/firmware/dvb-usb-bluebird-01.fw";
+	my $url = "https://linuxtv.org/download/dvb/firmware/dvb-usb-bluebird-01.fw";
 	my $outfile = "dvb-usb-bluebird-01.fw";
 	my $hash = "658397cb9eba9101af9031302671f49d";
 
@@ -677,7 +677,7 @@ sub drxk_hauppauge_hvr930c {
 }
 
 sub drxk_terratec_h5 {
-    my $url = "http://www.linuxtv.org/downloads/firmware/";
+    my $url = "https://linuxtv.org/downloads/firmware/";
     my $hash = "19000dada8e2741162ccc50cc91fa7f1";
     my $fwfile = "dvb-usb-terratec-h5-drxk.fw";
 
diff --git a/Documentation/dvb/readme.txt b/Documentation/dvb/readme.txt
index 0b0380c91990..89965041a266 100644
--- a/Documentation/dvb/readme.txt
+++ b/Documentation/dvb/readme.txt
@@ -2,12 +2,12 @@ Linux Digital Video Broadcast (DVB) subsystem
 =============================================
 
 The main development site and CVS repository for these
-drivers is http://linuxtv.org/.
+drivers is https://linuxtv.org.
 
 The developer mailing list linux-dvb is also hosted there,
-see http://linuxtv.org/lists.php. Please check
-the archive http://linuxtv.org/pipermail/linux-dvb/
-and the Wiki http://linuxtv.org/wiki/
+see https://linuxtv.org/lists.php. Please check
+the archive https://linuxtv.org/pipermail/linux-dvb/
+and the Wiki https://linuxtv.org/wiki/
 before asking newbie questions on the list.
 
 API documentation, utilities and test/example programs
@@ -16,7 +16,7 @@ are available as part of the old driver package for Linux 2.4
 We plan to split this into separate packages, but it's not
 been done yet.
 
-http://linuxtv.org/downloads/
+https://linuxtv.org/downloads/
 
 What's inside this directory:
 
diff --git a/Documentation/video4linux/API.html b/Documentation/video4linux/API.html
index 256f8efa992c..eaf948cf1ae7 100644
--- a/Documentation/video4linux/API.html
+++ b/Documentation/video4linux/API.html
@@ -9,7 +9,7 @@
   <table border="0">
    <tr>
     <td>
-     <a href="http://linuxtv.org/downloads/legacy/video4linux/API/V4L1_API.html">V4L original API</a>
+     <a href="https://linuxtv.org/downloads/legacy/video4linux/API/V4L1_API.html">V4L original API</a>
     </td>
     <td>
      Obsoleted by V4L2 API
diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
index e0c6b8bc4743..4fab231be52e 100644
--- a/Documentation/video4linux/fimc.txt
+++ b/Documentation/video4linux/fimc.txt
@@ -58,7 +58,7 @@ Not currently supported:
 4.1. Media device interface
 
 The driver supports Media Controller API as defined at
-http://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
+https://linuxtv.org/downloads/v4l-dvb-apis/media_common.html
 The media device driver name is "SAMSUNG S5P FIMC".
 
 The purpose of this interface is to allow changing assignment of FIMC instances
@@ -83,11 +83,11 @@ undefined behaviour.
 4.3. Capture video node
 
 The driver supports V4L2 Video Capture Interface as defined at:
-http://linuxtv.org/downloads/v4l-dvb-apis/devices.html
+https://linuxtv.org/downloads/v4l-dvb-apis/devices.html
 
 At the capture and mem-to-mem video nodes only the multi-planar API is
 supported. For more details see:
-http://linuxtv.org/downloads/v4l-dvb-apis/planar-apis.html
+https://linuxtv.org/downloads/v4l-dvb-apis/planar-apis.html
 
 4.4. Camera capture subdevs
 
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3ef3d6c6bbf8..9264ea73b3be 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -9,7 +9,7 @@ menuconfig MEDIA_SUPPORT
 	  If you want to use Webcams, Video grabber devices and/or TV devices
 	  enable this option and other options below.
 	  Additional info and docs are available on the web at
-	  <http://linuxtv.org>
+	  <https://linuxtv.org>
 
 if MEDIA_SUPPORT
 
@@ -51,7 +51,7 @@ config MEDIA_RADIO_SUPPORT
 	  Enable AM/FM radio support.
 
 	  Additional info and docs are available on the web at
-	  <http://linuxtv.org>
+	  <https://linuxtv.org>
 
 	  Say Y when you have a board with radio support.
 
diff --git a/drivers/media/dvb-frontends/bsbe1-d01a.h b/drivers/media/dvb-frontends/bsbe1-d01a.h
index 7ed3c424178c..baaf89e768cf 100644
--- a/drivers/media/dvb-frontends/bsbe1-d01a.h
+++ b/drivers/media/dvb-frontends/bsbe1-d01a.h
@@ -21,7 +21,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 
 #ifndef BSBE1_D01A_H
diff --git a/drivers/media/dvb-frontends/bsbe1.h b/drivers/media/dvb-frontends/bsbe1.h
index 53e4d0dbb745..4ad766154741 100644
--- a/drivers/media/dvb-frontends/bsbe1.h
+++ b/drivers/media/dvb-frontends/bsbe1.h
@@ -19,7 +19,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 
 #ifndef BSBE1_H
diff --git a/drivers/media/dvb-frontends/bsru6.h b/drivers/media/dvb-frontends/bsru6.h
index c2a578e1314d..275c1782597d 100644
--- a/drivers/media/dvb-frontends/bsru6.h
+++ b/drivers/media/dvb-frontends/bsru6.h
@@ -19,7 +19,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 
 #ifndef BSRU6_H
diff --git a/drivers/media/dvb-frontends/isl6405.c b/drivers/media/dvb-frontends/isl6405.c
index b46450a10b80..6913cd687b4d 100644
--- a/drivers/media/dvb-frontends/isl6405.c
+++ b/drivers/media/dvb-frontends/isl6405.c
@@ -22,7 +22,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/drivers/media/dvb-frontends/isl6405.h b/drivers/media/dvb-frontends/isl6405.h
index 3c148b830bd1..4a23d3bdf3e6 100644
--- a/drivers/media/dvb-frontends/isl6405.h
+++ b/drivers/media/dvb-frontends/isl6405.h
@@ -22,7 +22,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 
 #ifndef _ISL6405_H
diff --git a/drivers/media/dvb-frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
index 3a4d4606a426..0b6d3837d5de 100644
--- a/drivers/media/dvb-frontends/isl6421.c
+++ b/drivers/media/dvb-frontends/isl6421.c
@@ -22,7 +22,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/drivers/media/dvb-frontends/isl6421.h b/drivers/media/dvb-frontends/isl6421.h
index 3273597833fd..00f9874ca5a2 100644
--- a/drivers/media/dvb-frontends/isl6421.h
+++ b/drivers/media/dvb-frontends/isl6421.h
@@ -22,7 +22,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 
 #ifndef _ISL6421_H
diff --git a/drivers/media/dvb-frontends/lnbp21.c b/drivers/media/dvb-frontends/lnbp21.c
index 4aca0fb9a8a7..6261460d93a7 100644
--- a/drivers/media/dvb-frontends/lnbp21.c
+++ b/drivers/media/dvb-frontends/lnbp21.c
@@ -22,7 +22,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/drivers/media/dvb-frontends/lnbp21.h b/drivers/media/dvb-frontends/lnbp21.h
index a9b530de62a6..cd9101f6e579 100644
--- a/drivers/media/dvb-frontends/lnbp21.h
+++ b/drivers/media/dvb-frontends/lnbp21.h
@@ -21,7 +21,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 
 #ifndef _LNBP21_H
diff --git a/drivers/media/dvb-frontends/lnbp22.c b/drivers/media/dvb-frontends/lnbp22.c
index d7ca0fdd0084..5c5fd04fd4a7 100644
--- a/drivers/media/dvb-frontends/lnbp22.c
+++ b/drivers/media/dvb-frontends/lnbp22.c
@@ -22,7 +22,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/drivers/media/dvb-frontends/lnbp22.h b/drivers/media/dvb-frontends/lnbp22.h
index 628148385182..5d01d92814c2 100644
--- a/drivers/media/dvb-frontends/lnbp22.h
+++ b/drivers/media/dvb-frontends/lnbp22.h
@@ -22,7 +22,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org
+ * the project's page is at https://linuxtv.org
  */
 
 #ifndef _LNBP22_H
diff --git a/drivers/media/dvb-frontends/tdhd1.h b/drivers/media/dvb-frontends/tdhd1.h
index 17750985db0c..2b9e8732c802 100644
--- a/drivers/media/dvb-frontends/tdhd1.h
+++ b/drivers/media/dvb-frontends/tdhd1.h
@@ -20,7 +20,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * The project's page is at http://www.linuxtv.org
+ * The project's page is at https://linuxtv.org
  */
 
 #ifndef TDHD1_H
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index f89364951ebd..5e18b6796ed9 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -26,7 +26,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 
@@ -1537,7 +1537,7 @@ static int get_firmware(struct av7110* av7110)
 			printk(KERN_ERR "dvb-ttpci: usually this should be in "
 			       "/usr/lib/hotplug/firmware or /lib/firmware\n");
 			printk(KERN_ERR "dvb-ttpci: and can be downloaded from"
-			       " http://www.linuxtv.org/download/dvb/firmware/\n");
+			       " https://linuxtv.org/download/dvb/firmware/\n");
 		} else
 			printk(KERN_ERR "dvb-ttpci: cannot request firmware"
 			       " (error %i)\n", ret);
@@ -2314,7 +2314,7 @@ static int frontend_init(struct av7110 *av7110)
 /* Budgetpatch note:
  * Original hardware design by Roberto Deza:
  * There is a DVB_Wiki at
- * http://www.linuxtv.org/
+ * https://linuxtv.org
  *
  * New software triggering design by Emard that works on
  * original Roberto Deza's hardware:
diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index 1cf906047353..6fc748e22017 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -25,7 +25,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 #include <linux/types.h>
diff --git a/drivers/media/pci/ttpci/av7110_ca.c b/drivers/media/pci/ttpci/av7110_ca.c
index a6079b90252a..bc4c65ffd4b9 100644
--- a/drivers/media/pci/ttpci/av7110_ca.c
+++ b/drivers/media/pci/ttpci/av7110_ca.c
@@ -25,7 +25,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/ttpci/av7110_hw.c b/drivers/media/pci/ttpci/av7110_hw.c
index 300bd3c94738..0583d56ef5ef 100644
--- a/drivers/media/pci/ttpci/av7110_hw.c
+++ b/drivers/media/pci/ttpci/av7110_hw.c
@@ -22,7 +22,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
- * the project's page is at http://www.linuxtv.org/
+ * the project's page is at https://linuxtv.org
  */
 
 /* for debugging ARM communication: */
diff --git a/drivers/media/pci/ttpci/av7110_v4l.c b/drivers/media/pci/ttpci/av7110_v4l.c
index 6c4076acb131..479aff02db81 100644
--- a/drivers/media/pci/ttpci/av7110_v4l.c
+++ b/drivers/media/pci/ttpci/av7110_v4l.c
@@ -22,7 +22,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index f1f7360c01ba..6f0d0161970e 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -30,7 +30,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 1feeeff3681b..7b27af4d9658 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -26,7 +26,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/
+ * the project's page is at https://linuxtv.org
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/pci/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
index e9674b40007c..6d42dcfd4825 100644
--- a/drivers/media/pci/ttpci/budget-core.c
+++ b/drivers/media/pci/ttpci/budget-core.c
@@ -31,7 +31,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 
diff --git a/drivers/media/pci/ttpci/budget-patch.c b/drivers/media/pci/ttpci/budget-patch.c
index b5b65962ce8f..591dbdfa2a13 100644
--- a/drivers/media/pci/ttpci/budget-patch.c
+++ b/drivers/media/pci/ttpci/budget-patch.c
@@ -27,7 +27,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 #include "av7110.h"
diff --git a/drivers/media/pci/ttpci/budget.c b/drivers/media/pci/ttpci/budget.c
index 99972beca262..de54310a2660 100644
--- a/drivers/media/pci/ttpci/budget.c
+++ b/drivers/media/pci/ttpci/budget.c
@@ -31,7 +31,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at https://linuxtv.org
  */
 
 #include "budget.h"
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 9facc92c8dea..3dc8ef004f8b 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -9,7 +9,7 @@ config DVB_USB_V2
 	  <file:Documentation/dvb/README.dvb-usb>.
 
 	  For a complete list of supported USB devices see the LinuxTV DVB Wiki:
-	  <http://www.linuxtv.org/wiki/index.php/DVB_USB>
+	  <https://linuxtv.org/wiki/index.php/DVB_USB>
 
 	  Say Y if you own a USB DVB device.
 
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 128eee61570d..f03b0b70c901 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -9,7 +9,7 @@ config DVB_USB
 	  <file:Documentation/dvb/README.dvb-usb>.
 
 	  For a complete list of supported USB devices see the LinuxTV DVB Wiki:
-	  <http://www.linuxtv.org/wiki/index.php/DVB_USB>
+	  <https://linuxtv.org/wiki/index.php/DVB_USB>
 
 	  Say Y if you own a USB DVB device.
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 73ea2fb04731..16c0ed6c50a7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -46,7 +46,7 @@
  * All kernel-specific stuff were moved to media/v4l2-dev.h, so
  * no #if __KERNEL tests are allowed here
  *
- *	See http://linuxtv.org for more info
+ *	See https://linuxtv.org for more info
  *
  *	Author: Bill Dirks <bill@thedirks.org>
  *		Justin Schoeman
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 0014529606e2..65f4449dd56e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -46,7 +46,7 @@
  * All kernel-specific stuff were moved to media/v4l2-dev.h, so
  * no #if __KERNEL tests are allowed here
  *
- *	See http://linuxtv.org for more info
+ *	See https://linuxtv.org for more info
  *
  *	Author: Bill Dirks <bill@thedirks.org>
  *		Justin Schoeman
-- 
2.5.0


