From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 1/3] i2c: document the existing i2c sysfs ABI
Date: Tue, 14 Oct 2014 17:48:12 +0300
Message-ID: <1413298094-9276-2-git-send-email-octavian.purdila@intel.com>
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413298094-9276-1-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org
Cc: linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org, johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds Documentation/ABI/testing/sysfs-bus-i2c which
documents the existing i2c sysfs ABI.

Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-bus-i2c | 45 +++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c

diff --git a/Documentation/ABI/testing/sysfs-bus-i2c b/Documentation/ABI/testing/sysfs-bus-i2c
new file mode 100644
index 0000000..8075585
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-i2c
@@ -0,0 +1,45 @@
+What:		/sys/bus/i2c/devices/i2c-X
+KernelVersion:	since at least 2.6.12
+Contact:	linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		This entry represents a registered i2c bus. X is the
+		bus number and its format is "%d".
+
+What:		/sys/bus/i2c/devices/i2c-X/Y
+What:		/sys/bus/i2c/devices/Y
+KernelVersion:	since at least 2.6.12
+Contact:	linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		An i2c device attached to bus X. Format of Y is
+		"%d-%04x" where the first number is the bus number (X)
+		and the second number is the device i2c address.
+
+What:		/sys/bus/i2c/devices/i2c-X/new_device
+KernelVersion:	2.6.31
+Contact:	linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		Write only entry that allows instantiating a
+		new i2c device on bus X. This is to be used when
+		enumeration mechanism such as ACPI or DT are not
+		present or not used for this device.
+		Format: "%s %hi\n" where the first argument is the
+		device name (no spaces allowed) and the second is the
+		i2c address of the device.
+
+What:		/sys/bus/i2c/devices/i2c-X/delete_device
+KernelVersion:	2.6.31
+Contact:	linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		Write only entry that allows the removal of an i2c
+		device from bus X.
+		Format: "%s %hi\n" where the first argument is the
+		device name (no spaces allowed) and the second is the
+		i2c address of the device.
+
+What:		/sys/bus/i2c/devices/i2c-X/i2c-Y
+What:		/sys/bus/i2c/devices/i2c-Y
+KernelVersion:	3.13
+Contact:	linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		An i2c device attached to bus X that is enumerated via
+		ACPI. Y is the ACPI device name and its format is "%s".
-- 
1.9.1
