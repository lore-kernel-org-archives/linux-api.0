From: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 3/3] Documentation/ABI: Update sysfs-driver-toshiba_acpi entry
Date: Fri, 27 Mar 2015 15:10:29 -0600
Message-ID: <1427490629-6415-1-git-send-email-coproscefalo@gmail.com>
Return-path: <platform-driver-x86-owner@vger.kernel.org>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch updates the sysfs-driver-toshiba_acpi entry, adding the
missing entries for USB Sleep functions.

And also, while at the neighborhood, fix some typos and add a note
that some features require a reboot.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 .../ABI/testing/sysfs-driver-toshiba_acpi          | 93 +++++++++++++++++++---
 1 file changed, 80 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-toshiba_acpi b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
index ca9c71a..eed922e 100644
--- a/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
+++ b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
@@ -8,9 +8,11 @@ Description:	This file controls the keyboard backlight operation mode, valid
 			* 0x2  -> AUTO (also called TIMER)
 			* 0x8  -> ON
 			* 0x10 -> OFF
-		Note that the kernel 3.16 onwards this file accepts all listed
+		Note that from kernel 3.16 onwards this file accepts all listed
 		parameters, kernel 3.15 only accepts the first two (FN-Z and
 		AUTO).
+		Also note that toggling this value on type 1 devices, requires
+		a reboot for changes to take effect.
 Users:		KToshiba
 
 What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/kbd_backlight_timeout
@@ -67,15 +69,72 @@ Description:	This file shows the current keyboard backlight type,
 			* 2 -> Type 2, supporting modes TIMER, ON and OFF
 Users:		KToshiba
 
+What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/usb_sleep_charge
+Date:		January 23, 2015
+KernelVersion:	4.0
+Contact:	Azael Avalos <coproscefalo@gmail.com>
+Description:	This file controls the USB Sleep & Charge charging mode, which
+		can be:
+			* 0 -> Disabled		(0x00)
+			* 1 -> Alternate	(0x09)
+			* 2 -> Auto		(0x21)
+			* 3 -> Typical		(0x11)
+		Note that from kernel 4.1 onwards this file accepts all listed
+		values, kernel 4.0 only supports the first three.
+		Note that this feature only works when connected to power, if
+		you want to use it under battery, see the entry named
+		"sleep_functions_on_battery"
+Users:		KToshiba
+
+What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/sleep_functions_on_battery
+Date:		January 23, 2015
+KernelVersion:	4.0
+Contact:	Azael Avalos <coproscefalo@gmail.com>
+Description:	This file controls the USB Sleep Functions under battery, and
+		set the level at which point they will be disabled, accepted
+		values can be:
+			* 0	-> Disabled
+			* 1-100	-> Battery level to disable sleep functions
+		Currently it prints two values, the first one indicates if the
+		feature is enabled or disabled, while the second one shows the
+		current battery level set.
+		Note that when the value is set to disabled, the sleep function
+		will only work when connected to power.
+Users:		KToshiba
+
+What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/usb_rapid_charge
+Date:		January 23, 2015
+KernelVersion:	4.0
+Contact:	Azael Avalos <coproscefalo@gmail.com>
+Description:	This file controls the USB Rapid Charge state, which can be:
+			* 0 -> Disabled
+			* 1 -> Enabled
+		Note that toggling this value requires a reboot for changes to
+		take effect.
+Users:		KToshiba
+
+What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/usb_sleep_music
+Date:		January 23, 2015
+KernelVersion:	4.0
+Contact:	Azael Avalos <coproscefalo@gmail.com>
+Description:	This file controls the Sleep & Music state, which values can be:
+			* 0 -> Disabled
+			* 1 -> Enabled
+		Note that this feature only works when connected to power, if
+		you want to use it under battery, see the entry named
+		"sleep_functions_on_battery"
+Users:		KToshiba
+
 What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/version
-Date:		February, 2015
-KernelVersion:	3.20
+Date:		February 12, 2015
+KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file shows the current version of the driver
+Users:		KToshiba
 
 What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/fan
-Date:		February, 2015
-KernelVersion:	3.20
+Date:		February 12, 2015
+KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the state of the internal fan, valid
 		values are:
@@ -83,8 +142,8 @@ Description:	This file controls the state of the internal fan, valid
 			* 1 -> ON
 
 What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/kbd_function_keys
-Date:		February, 2015
-KernelVersion:	3.20
+Date:		February 12, 2015
+KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the Special Functions (hotkeys) operation
 		mode, valid values are:
@@ -94,21 +153,29 @@ Description:	This file controls the Special Functions (hotkeys) operation
 		and the hotkeys are accessed via FN-F{1-12}.
 		In the "Special Functions" mode, the F{1-12} keys trigger the
 		hotkey and the F{1-12} keys are accessed via FN-F{1-12}.
+		Note that toggling this value requires a reboot for changes to
+		take effect.
+Users:		KToshiba
 
 What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/panel_power_on
-Date:		February, 2015
-KernelVersion:	3.20
+Date:		February 12, 2015
+KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls whether the laptop should turn ON whenever
 		the LID is opened, valid values are:
 			* 0 -> Disabled
 			* 1 -> Enabled
+		Note that toggling this value requires a reboot for changes to
+		take effect.
+Users:		KToshiba
 
 What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/usb_three
-Date:		February, 2015
-KernelVersion:	3.20
+Date:		February 12, 2015
+KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
-Description:	This file controls whether the USB 3 functionality, valid
-		values are:
+Description:	This file controls the USB 3 functionality, valid values are:
 			* 0 -> Disabled (Acts as a regular USB 2)
 			* 1 -> Enabled (Full USB 3 functionality)
+		Note that toggling this value requires a reboot for changes to
+		take effect.
+Users:		KToshiba
-- 
2.2.2
