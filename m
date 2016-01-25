From: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 3/3] Documentation/ABI: Update sysfs-driver-toshiba_acpi file
Date: Mon, 25 Jan 2016 11:29:53 -0700
Message-ID: <1453746593-17546-1-git-send-email-coproscefalo@gmail.com>
Return-path: <platform-driver-x86-owner@vger.kernel.org>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch updates the documentation file adding the Cooling Method
entry.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 Documentation/ABI/testing/sysfs-driver-toshiba_acpi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-toshiba_acpi b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
index eed922e..f34221b 100644
--- a/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
+++ b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
@@ -179,3 +179,19 @@ Description:	This file controls the USB 3 functionality, valid values are:
 		Note that toggling this value requires a reboot for changes to
 		take effect.
 Users:		KToshiba
+
+What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/cooling_method
+Date:		2016
+KernelVersion:	4.6
+Contact:	Azael Avalos <coproscefalo@gmail.com>
+Description:	This file controls the Cooling Method feature.
+		Reading this file prints two values, the first is the actual cooling method
+		and the second is the maximum cooling method supported.
+		When the maximum cooling method is ONE, valid values are:
+			* 0 -> Maximum Performance
+			* 1 -> Battery Optimized
+		When the maximum cooling method is TWO, valid values are:
+			* 0 -> Maximum Performance
+			* 1 -> Performance
+			* 2 -> Battery Optimized
+Users:		KToshiba
-- 
2.7.0
