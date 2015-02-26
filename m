From: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] Documentation/ABI: Add file describing the sysfs entries for toshiba_haps
Date: Thu, 26 Feb 2015 10:59:33 -0700
Message-ID: <1424973573-3136-1-git-send-email-coproscefalo@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds a new file describing the sysfs entries for the
toshiba_haps driver.

Signed-off-by: Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-driver-toshiba_haps | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-toshiba_haps

diff --git a/Documentation/ABI/testing/sysfs-driver-toshiba_haps b/Documentation/ABI/testing/sysfs-driver-toshiba_haps
new file mode 100644
index 0000000..a662370
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-toshiba_haps
@@ -0,0 +1,20 @@
+What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS620A:00/protection_level
+Date:		August 16, 2014
+KernelVersion:	3.17
+Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+Description:	This file controls the built-in accelerometer protection level,
+		valid values are:
+			* 0 -> Disabled
+			* 1 -> Low
+			* 2 -> Medium
+			* 3 -> High
+		The default potection value is set to 2 (Medium).
+Users:		KToshiba
+
+What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS620A:00/reset_protection
+Date:		August 16, 2014
+KernelVersion:	3.17
+Contact:	Azael Avalos <coproscefalo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+Description:	This file turns off the built-in accelerometer for a few
+		seconds and then restore normal operation. Accepting 1 as the
+		only parameter.
-- 
2.2.2
