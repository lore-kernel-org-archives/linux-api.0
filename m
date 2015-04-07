From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v2 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Tue,  7 Apr 2015 22:23:52 +0300
Message-ID: <1428434632-13789-5-git-send-email-pantelis.antoniou@konsulko.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Documentation ABI entry for overlays sysfs entries.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 .../ABI/testing/sysfs-firmware-devicetree-overlays | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
new file mode 100644
index 0000000..6b81f1c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
@@ -0,0 +1,23 @@
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
-- 
1.7.12
