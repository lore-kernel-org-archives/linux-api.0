From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 8/8] efivars: use generic UUID library
Date: Mon,  4 Apr 2016 16:30:10 +0300
Message-ID: <1459776610-68469-9-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>, Matt Fleming <matt@codeblueprint.co.uk>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Instead of opencoding let's use generic UUID library functions here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/efivarfs/inode.c | 40 +++-------------------------------------
 1 file changed, 3 insertions(+), 37 deletions(-)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index e2ab6d0..7103453 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/uuid.h>
 
 #include "internal.h"
 
@@ -46,11 +47,7 @@ struct inode *efivarfs_get_inode(struct super_block *sb,
  */
 bool efivarfs_valid_name(const char *str, int len)
 {
-	static const char dashes[EFI_VARIABLE_GUID_LEN] = {
-		[8] = 1, [13] = 1, [18] = 1, [23] = 1
-	};
 	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
-	int i;
 
 	/*
 	 * We need a GUID, plus at least one letter for the variable name,
@@ -68,37 +65,7 @@ bool efivarfs_valid_name(const char *str, int len)
 	 *
 	 *	12345678-1234-1234-1234-123456789abc
 	 */
-	for (i = 0; i < EFI_VARIABLE_GUID_LEN; i++) {
-		if (dashes[i]) {
-			if (*s++ != '-')
-				return false;
-		} else {
-			if (!isxdigit(*s++))
-				return false;
-		}
-	}
-
-	return true;
-}
-
-static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
-{
-	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
-	guid->b[1] = hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
-	guid->b[2] = hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
-	guid->b[3] = hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
-	guid->b[4] = hex_to_bin(str[11]) << 4 | hex_to_bin(str[12]);
-	guid->b[5] = hex_to_bin(str[9]) << 4 | hex_to_bin(str[10]);
-	guid->b[6] = hex_to_bin(str[16]) << 4 | hex_to_bin(str[17]);
-	guid->b[7] = hex_to_bin(str[14]) << 4 | hex_to_bin(str[15]);
-	guid->b[8] = hex_to_bin(str[19]) << 4 | hex_to_bin(str[20]);
-	guid->b[9] = hex_to_bin(str[21]) << 4 | hex_to_bin(str[22]);
-	guid->b[10] = hex_to_bin(str[24]) << 4 | hex_to_bin(str[25]);
-	guid->b[11] = hex_to_bin(str[26]) << 4 | hex_to_bin(str[27]);
-	guid->b[12] = hex_to_bin(str[28]) << 4 | hex_to_bin(str[29]);
-	guid->b[13] = hex_to_bin(str[30]) << 4 | hex_to_bin(str[31]);
-	guid->b[14] = hex_to_bin(str[32]) << 4 | hex_to_bin(str[33]);
-	guid->b[15] = hex_to_bin(str[34]) << 4 | hex_to_bin(str[35]);
+	return uuid_is_valid(s) == 0;
 }
 
 static int efivarfs_create(struct inode *dir, struct dentry *dentry,
@@ -119,8 +86,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	/* length of the variable name itself: remove GUID and separator */
 	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
 
-	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
-			&var->var.VendorGuid);
+	uuid_le_to_bin(dentry->d_name.name + namelen + 1, &var->var.VendorGuid);
 
 	if (efivar_variable_is_removable(var->var.VendorGuid,
 					 dentry->d_name.name, namelen))
-- 
2.8.0.rc3
