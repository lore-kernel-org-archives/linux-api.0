From: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: [Patch v3 1/3] firmware: dmi_scan: rename dmi_table to dmi_decode_table
Date: Tue, 21 Apr 2015 18:52:38 +0300
Message-ID: <1429631560-31359-2-git-send-email-ivan.khoronzhuk@globallogic.com>
References: <1429631560-31359-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429631560-31359-1-git-send-email-ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jdelvare-l3A5Bk7waGM@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The "dmi_table" function looks like data instance, but it does DMI
table decode. This patch renames it to "dmi_decode_table" name as
more appropriate. That allows us to use "dmi_table" name for correct
purposes.

Reviewed-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
---
 drivers/firmware/dmi_scan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 97b1616..a864a6b 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -80,9 +80,9 @@ static const char * __init dmi_string(const struct dmi_header *dm, u8 s)
  *	We have to be cautious here. We have seen BIOSes with DMI pointers
  *	pointing to completely the wrong place for example
  */
-static void dmi_table(u8 *buf,
-		      void (*decode)(const struct dmi_header *, void *),
-		      void *private_data)
+static void dmi_decode_table(u8 *buf,
+			     void (*decode)(const struct dmi_header *, void *),
+			     void *private_data)
 {
 	u8 *data = buf;
 	int i = 0;
@@ -130,7 +130,7 @@ static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
 	if (buf == NULL)
 		return -1;
 
-	dmi_table(buf, decode, NULL);
+	dmi_decode_table(buf, decode, NULL);
 
 	add_device_randomness(buf, dmi_len);
 
@@ -897,7 +897,7 @@ int dmi_walk(void (*decode)(const struct dmi_header *, void *),
 	if (buf == NULL)
 		return -1;
 
-	dmi_table(buf, decode, private_data);
+	dmi_decode_table(buf, decode, private_data);
 
 	dmi_unmap(buf);
 	return 0;
-- 
1.9.1
