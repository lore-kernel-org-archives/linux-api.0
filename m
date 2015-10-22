From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 6/6] Documentation: ABI: overlays - per overlay docs
Date: Thu, 22 Oct 2015 22:50:27 +0300
Message-ID: <1445543427-26275-7-git-send-email-pantelis.antoniou@konsulko.com>
References: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445543427-26275-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Documentation for the per-overlay attributes.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
---
 .../ABI/testing/sysfs-firmware-devicetree-overlays | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
index e938f44..88d1549 100644
--- a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
+++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
@@ -22,3 +22,31 @@ Description:
 		to be a high-level one-way "off" switch for the interface so
 		that systems that have this interface can choose to turn it off
 		during initial boot, etc."
+
+What:		/sys/firmware/devicetree/overlays/<id>
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
+Description:
+		Each directory represents an applied overlay, containing
+		the following attribute files.
+
+What:		/sys/firmware/devicetree/overlays/<id>/can_remove
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
+Description:
+		The attribute set to 1 means that the overlay can be removed,
+		while 0 means that the overlay is being overlapped therefore
+		removal is prohibited.
+
+What:		/sys/firmware/devicetree/overlays/<id>/<fragment-name>/
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
+Description:
+		Each of these directories contain information about of the
+		particular overlay fragment.
+
+What:		/sys/firmware/devicetree/overlays/<id>/<fragment-name>/target
+Date:		October 2015
+Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
+Description:
+		The full-path of the target of the fragment
-- 
1.7.12

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
