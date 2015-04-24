From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Fri, 24 Apr 2015 12:45:44 +0300
Message-ID: <1429868744-19863-5-git-send-email-pantelis.antoniou@konsulko.com>
References: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429868744-19863-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Documentation ABI entry for overlays sysfs entries.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
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
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
+Description:
+		This directory contains the applied device tree overlays of
+		the running system, as directories of the overlay id.
+
+		enable: The master enable switch, by default is 1, and when
+		        set to 0 it cannot be re-enabled for security reasons.
+
+What:		/sys/firmware/devicetree/overlays/<id>
+Date:		March 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
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
