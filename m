From: Gabriele Mazzotta <gabriele.mzt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Documentation: dell-laptop: correct als_setting description
Date: Fri,  2 Jan 2015 12:06:50 +0100
Message-ID: <1420196810-8855-1-git-send-email-gabriele.mzt@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, A.Sloman-dxBOTFGcEFw2EctHIo1CcQ@public.gmane.org, Gabriele Mazzotta <gabriele.mzt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It was incorrectly stated that als_setting is to enable and disable
the ambient light sensor on supported system rather than setting a
threshold value. Correct the description and add a note to make more
clear what could be the effect of changing als_setting.

Reported-by: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Gabriele Mazzotta <gabriele.mzt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-platform-dell-laptop | 17 ++++++++++++=
+----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Doc=
umentation/ABI/testing/sysfs-platform-dell-laptop
index 7969443..a40c217 100644
--- a/Documentation/ABI/testing/sysfs-platform-dell-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
@@ -4,10 +4,12 @@ KernelVersion:	3.19
 Contact:	Gabriele Mazzotta <gabriele.mzt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 		Pali Roh=C3=A1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 Description:
-		This file allows to control the automatic keyboard
-		illumination mode on some systems that have an ambient
-		light sensor. Write 1 to this file to enable the auto
-		mode, 0 to disable it.
+		This file allows to set at which value reported by the
+		ambient light sensor the keyboard backlight has to be
+		turned on or off.
+
+		Note that the 'als' trigger must be supported and enabled
+		for this setting to have any effect.
=20
 What:		/sys/class/leds/dell::kbd_backlight/start_triggers
 Date:		December 2014
@@ -32,6 +34,13 @@ Description:
=20
 		Note that not all the available triggers can be configured.
=20
+		Note also that enabling the 'als' trigger could simply
+		alter the behavior of the other triggers and not allow
+		the ambient light sensor control the keyboard illumination
+		independently. It could prevent other triggers from turning
+		the keyboard backlight on or force them to turn it off
+		depending on the current ambient light and als_setting.
+
 What:		/sys/class/leds/dell::kbd_backlight/stop_timeout
 Date:		December 2014
 KernelVersion:	3.19
--=20
2.1.4
