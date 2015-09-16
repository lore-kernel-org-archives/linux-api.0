From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v5 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Wed, 16 Sep 2015 19:09:11 +0300
Message-ID: <1442419751-4846-5-git-send-email-pantelis.antoniou@konsulko.com>
References: <1442419751-4846-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442419751-4846-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Documentation ABI entry for overlays sysfs entries.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 .../ABI/testing/sysfs-firmware-devicetree-overlays | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
new file mode 100644
index 0000000..2166051
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
@@ -0,0 +1,35 @@
+What:		/sys/firmware/devicetree/overlays/
+Date:		March 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		This directory contains the applied device tree overlays of
+		the running system, as directories of the overlay id.
+
+		enable: The master enable switch, by default is 1, and when
+		        set to 0 it cannot be re-enabled for security reasons.
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
+
+What:		/sys/firmware/devicetree/overlays/<id>
+Date:		March 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou@konsulko.com>
+Description:
+		Each directory represents an applied overlay, containing
+		the following attribute files.
+
+		targets: A file containing the list of targets of each overlay
+		         with each line containing a target.
+
+		can_remove: The attribute set to 1 means that the overlay can
+		            be removed, while 0 means that the overlay is being
+			    overlapped therefore removal is prohibited.
+
-- 
1.7.12
