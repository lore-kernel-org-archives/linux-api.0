From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 07/10] sysctl: use generic UUID library
Date: Tue,  5 Apr 2016 16:56:16 +0300
Message-ID: <1459864579-55988-8-git-send-email-andriy.shevchenko@linux.intel.com>
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
 kernel/sysctl_binary.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 055ad65..ce94c45 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/netdevice.h>
 #include <linux/kernel.h>
+#include <linux/uuid.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
 
@@ -1117,9 +1118,8 @@ static ssize_t bin_uuid(struct file *file,
 
 	/* Only supports reads */
 	if (oldval && oldlen) {
-		char buf[40], *str = buf;
-		unsigned char uuid[16];
-		int i;
+		char buf[UUID_STRING_LEN + 1];
+		uuid_be uuid;
 
 		result = kernel_read(file, 0, buf, sizeof(buf) - 1);
 		if (result < 0)
@@ -1128,21 +1128,13 @@ static ssize_t bin_uuid(struct file *file,
 		buf[result] = '\0';
 
 		/* Convert the uuid to from a string to binary */
-		for (i = 0; i < 16; i++) {
-			if (!isxdigit(str[0]) || !isxdigit(str[1]))
-				return -EIO;
-
-			uuid[i] = (hex_to_bin(str[0]) << 4) |
-					hex_to_bin(str[1]);
-			str += 2;
-			if (*str == '-')
-				str++;
-		}
+		if (uuid_be_to_bin(buf, &uuid))
+			return -EIO;
 
 		if (oldlen > 16)
 			oldlen = 16;
 
-		if (copy_to_user(oldval, uuid, oldlen))
+		if (copy_to_user(oldval, &uuid, oldlen))
 			return -EFAULT;
 
 		copied = oldlen;
-- 
2.8.0.rc3
