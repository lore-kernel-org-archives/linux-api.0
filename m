From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 3/6] Documentation: ABI: overlays - global attributes
Date: Thu, 22 Oct 2015 22:50:24 +0300
Message-ID: <1445543427-26275-4-git-send-email-pantelis.antoniou@konsulko.com>
References: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445543427-26275-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Documentation ABI entry for overlays sysfs entries.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
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
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
+Description:
+		This directory contains the applied device tree overlays of
+		the running system, as directories of the overlay id.
+
+What:		/sys/firmware/devicetree/overlays/enable
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
