From: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
Subject: [Patch v2 1/3] firmware: dmi_scan: rename dmi_table to dmi_decode_table
Date: Mon, 20 Apr 2015 13:19:45 +0300
Message-ID: <1429525187-3376-2-git-send-email-ivan.khoronzhuk@globallogic.com>
References: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, matt.fleming@intel.com, jdelvare@suse.de, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com
Cc: dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org, Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
List-Id: linux-api@vger.kernel.org

The "dmi_table" function looks like data instance, but it does DMI
table decode. This patch renames it to "dmi_decode_table" name as
more appropriate. That allows us to use "dmi_table" name for correct
purposes.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
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
