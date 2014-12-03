From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH] Documentation: Add entry for dell-laptop sysfs interface
Date: Wed,  3 Dec 2014 18:41:33 +0100
Message-ID: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dvhart@infradead.org, mjg59@srcf.ucam.org
Cc: linux-api@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com, Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com, pali.rohar@gmail.com, Gabriele Mazzotta <gabriele.mzt@gmail.com>
List-Id: linux-api@vger.kernel.org

Add the documentation for the new sysfs interface of dell-laptop
that allows to configure the keyboard illumination on Dell systems.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 .../ABI/testing/sysfs-platform-dell-laptop         | 60 ++++++++++++++=
++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-dell-lapto=
p

diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Doc=
umentation/ABI/testing/sysfs-platform-dell-laptop
new file mode 100644
index 0000000..7969443
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
@@ -0,0 +1,60 @@
+What:		/sys/class/leds/dell::kbd_backlight/als_setting
+Date:		December 2014
+KernelVersion:	3.19
+Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
+		Pali Roh=C3=A1r <pali.rohar@gmail.com>
+Description:
+		This file allows to control the automatic keyboard
+		illumination mode on some systems that have an ambient
+		light sensor. Write 1 to this file to enable the auto
+		mode, 0 to disable it.
+
+What:		/sys/class/leds/dell::kbd_backlight/start_triggers
+Date:		December 2014
+KernelVersion:	3.19
+Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
+		Pali Roh=C3=A1r <pali.rohar@gmail.com>
+Description:
+		This file allows to control the input triggers that
+		turn on the keyboard backlight illumination that is
+		disabled because of inactivity.
+		Read the file to see the triggers available. The ones
+		enabled are preceded by '+', those disabled by '-'.
+
+		To enable a trigger, write its name preceded by '+' to
+		this file. To disable a trigger, write its name preceded
+		by '-' instead.
+
+		For example, to enable the keyboard as trigger run:
+		    echo +keyboard > /sys/class/leds/dell::kbd_backlight/start_trigg=
ers
+		To disable it:
+		    echo -keyboard > /sys/class/leds/dell::kbd_backlight/start_trigg=
ers
+
+		Note that not all the available triggers can be configured.
+
+What:		/sys/class/leds/dell::kbd_backlight/stop_timeout
+Date:		December 2014
+KernelVersion:	3.19
+Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
+		Pali Roh=C3=A1r <pali.rohar@gmail.com>
+Description:
+		This file allows to specify the interval after which the
+		keyboard illumination is disabled because of inactivity.
+		The timeouts are expressed in seconds, minutes, hours and
+		days, for which the symbols are 's', 'm', 'h' and 'd'
+		respectively.
+
+		To configure the timeout, write to this file a value along
+		with any the above units. If no unit is specified, the value
+		is assumed to be expressed in seconds.
+
+		For example, to set the timeout to 10 minutes run:
+		    echo 10m > /sys/class/leds/dell::kbd_backlight/stop_timeout
+
+		Note that when this file is read, the returned value might be
+		expressed in a different unit than the one used when the timeout
+		was set.
+
+		Also note that only some timeouts are supported and that
+		some systems might fall back to a specific timeout in case
+		an invalid timeout is written to this file.
--=20
2.1.3
