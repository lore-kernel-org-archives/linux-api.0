From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 5/5] MAINTAINERS: Beaglebone capemanager maintainer
Date: Wed, 13 May 2015 10:59:45 +0300
Message-ID: <1431503985-31853-6-git-send-email-pantelis.antoniou@konsulko.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431503985-31853-1-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Robert Nelson <robertcnelson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Geert Uytterhoeven <geert+renesas-gXvu3+zWzMSzQB+pC5nmwQ@public.gmane.org>, =?UTF-8?q?Beno=C3=AEt=20Cousso?= <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add me as the capemanager maintainer.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c97e090..87611c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1964,6 +1964,14 @@ W:	http://bcache.evilpiepirate.org
 S:	Maintained:
 F:	drivers/md/bcache/
 
+BEAGLEBONE CAPEMANAGER
+M:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
+S:	Maintained
+F:	drivers/misc/beaglebone-capemgr.c
+F:	Documentation/misc-devices/bone_capemgr.txt
+F:	Documentation/devicetree/bindings/misc/bone_capemgr.txt
+F:	Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr
+
 BEFS FILE SYSTEM
 S:	Orphan
 F:	Documentation/filesystems/befs.txt
-- 
1.7.12
