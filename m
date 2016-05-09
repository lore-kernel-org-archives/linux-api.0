From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v8 3/6] Documentation: ABI: overlays - global attributes
Date: Mon,  9 May 2016 16:10:00 +0300
Message-ID: <1462799403-10083-4-git-send-email-pantelis.antoniou@konsulko.com>
References: <1462799403-10083-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462799403-10083-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Documentation ABI entry for overlays sysfs entries.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../ABI/testing/sysfs-firmware-devicetree-overlays | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
new file mode 100644
index 0000000..e938f44
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
@@ -0,0 +1,24 @@
+What:		/sys/firmware/devicetree/overlays/
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		This directory contains the applied device tree overlays of
+		the running system, as directories of the overlay id.
+
+What:		/sys/firmware/devicetree/overlays/enable
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		The master enable switch, by default is 1, and when
+		set to 0 it cannot be re-enabled for security reasons.
+
+		The discussion about this switch takes place in:
+		http://comments.gmane.org/gmane.linux.drivers.devicetree/101871
+
+		Kees Cook:
+		"Coming from the perspective of drawing a bright line between
+		kernel and the root user (which tends to start with disabling
+		kernel module loading), I would say that there at least needs
+		to be a high-level one-way "off" switch for the interface so
+		that systems that have this interface can choose to turn it off
+		during initial boot, etc."
-- 
1.7.12
