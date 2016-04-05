From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 10/10] genhd: move to use generic UUID library
Date: Tue,  5 Apr 2016 16:56:19 +0300
Message-ID: <1459864579-55988-11-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-api@vger.kernel.org

UUID library provides uuid_be type and uuid_be_to_bin() function. This
substitutes open coded variant by generic library calls.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/genhd.h | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5c70676..359a8e4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -14,6 +14,7 @@
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
+#include <linux/uuid.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -93,7 +94,7 @@ struct disk_stats {
  * Enough for the string representation of any kind of UUID plus NULL.
  * EFI UUID is 36 characters. MSDOS UUID is 11 characters.
  */
-#define PARTITION_META_INFO_UUIDLTH	37
+#define PARTITION_META_INFO_UUIDLTH	(UUID_STRING_LEN + 1)
 
 struct partition_meta_info {
 	char uuid[PARTITION_META_INFO_UUIDLTH];
@@ -228,27 +229,9 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 	return NULL;
 }
 
-static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
-{
-	int i;
-	for (i = 0; i < 16; ++i) {
-		*to++ = (hex_to_bin(*uuid_str) << 4) |
-			(hex_to_bin(*(uuid_str + 1)));
-		uuid_str += 2;
-		switch (i) {
-		case 3:
-		case 5:
-		case 7:
-		case 9:
-			uuid_str++;
-			continue;
-		}
-	}
-}
-
 static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
 {
-	part_pack_uuid(uuid_str, to);
+	uuid_be_to_bin(uuid_str, (uuid_be *)to);
 	return 0;
 }
 
-- 
2.8.0.rc3
