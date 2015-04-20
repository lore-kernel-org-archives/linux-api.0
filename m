From: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: [Patch v2 3/3] Documentation: ABI: sysfs-firmware-dmi: add -entries suffix to file name
Date: Mon, 20 Apr 2015 13:19:47 +0300
Message-ID: <1429525187-3376-4-git-send-email-ivan.khoronzhuk@globallogic.com>
References: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429525187-3376-1-git-send-email-ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jdelvare-l3A5Bk7waGM@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The dmi-sysfs module adds DMI table structures entries under
/sys/firmware/dmi/entries only, so rename documentation file to
sysfs-firmware-dmi-entries as more appropriate. Without renaming it's
confusing to differ this from sysfs-firmware-dmi-tables that adds raw
DMI table and actually adds "dmi" kobject.

Reviewed-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
---
 .../ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries}      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries} (99%)

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
similarity index 99%
rename from Documentation/ABI/testing/sysfs-firmware-dmi
rename to Documentation/ABI/testing/sysfs-firmware-dmi-entries
index c78f9ab..210ad44 100644
--- a/Documentation/ABI/testing/sysfs-firmware-dmi
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
@@ -1,4 +1,4 @@
-What:		/sys/firmware/dmi/
+What:		/sys/firmware/dmi/entries/
 Date:		February 2011
 Contact:	Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
 Description:
-- 
1.9.1
