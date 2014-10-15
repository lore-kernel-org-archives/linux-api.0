From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATH v3 1/4] i2c: document the existing i2c sysfs ABI
Date: Wed, 15 Oct 2014 23:03:28 +0300
Message-ID: <1413403411-8895-2-git-send-email-octavian.purdila@intel.com>
References: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413403411-8895-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: wsa@the-dreams.de
Cc: linux@roeck-us.net, johan@kernel.org, linux-i2c@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-api@vger.kernel.org

This patch adds Documentation/ABI/testing/sysfs-bus-i2c which
documents the existing i2c sysfs ABI.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
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
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		This entry represents a registered i2c bus. X is the
+		bus number and its format is "%d".
+
+What:		/sys/bus/i2c/devices/i2c-X/Y
+What:		/sys/bus/i2c/devices/Y
+KernelVersion:	since at least 2.6.12
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		An i2c device attached to bus X. Format of Y is
+		"%d-%04x" where the first number is the bus number (X)
+		and the second number is the device i2c address.
+
+What:		/sys/bus/i2c/devices/i2c-X/new_device
+KernelVersion:	2.6.31
+Contact:	linux-i2c@vger.kernel.org
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
+Contact:	linux-i2c@vger.kernel.org
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
+Contact:	linux-i2c@vger.kernel.org
+Description:
+		An i2c device attached to bus X that is enumerated via
+		ACPI. Y is the ACPI device name and its format is "%s".
-- 
1.9.1
