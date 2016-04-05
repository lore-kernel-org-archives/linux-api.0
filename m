From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 03/10] lib/uuid: move generate_random_uuid() to uuid.c
Date: Tue,  5 Apr 2016 16:56:12 +0300
Message-ID: <1459864579-55988-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459864579-55988-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, Theodore Ts'o <tytso@mit.edu>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Let's gather the UUID related functions under one hood.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/char/random.c  | 21 +--------------------
 fs/btrfs/volumes.c     |  2 +-
 fs/ext4/ioctl.c        |  2 +-
 fs/f2fs/file.c         |  2 +-
 fs/reiserfs/objectid.c |  2 +-
 fs/ubifs/sb.c          |  2 +-
 include/linux/random.h |  1 -
 include/linux/uuid.h   |  2 ++
 lib/uuid.c             | 20 ++++++++++++++++++++
 9 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b583e53..0158d3b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -260,6 +260,7 @@
 #include <linux/irq.h>
 #include <linux/syscalls.h>
 #include <linux/completion.h>
+#include <linux/uuid.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -1621,26 +1622,6 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	return urandom_read(NULL, buf, count, NULL);
 }
 
-/***************************************************************
- * Random UUID interface
- *
- * Used here for a Boot ID, but can be useful for other kernel
- * drivers.
- ***************************************************************/
-
-/*
- * Generate random UUID
- */
-void generate_random_uuid(unsigned char uuid_out[16])
-{
-	get_random_bytes(uuid_out, 16);
-	/* Set UUID version to 4 --- truly random generation */
-	uuid_out[6] = (uuid_out[6] & 0x0F) | 0x40;
-	/* Set the UUID variant to DCE */
-	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
-}
-EXPORT_SYMBOL(generate_random_uuid);
-
 /********************************************************************
  *
  * Sysctl interface
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a85ce77..7d1b91d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -20,13 +20,13 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
-#include <linux/random.h>
 #include <linux/iocontext.h>
 #include <linux/capability.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/semaphore.h>
+#include <linux/uuid.h>
 #include <asm/div64.h>
 #include "ctree.h"
 #include "extent_map.h"
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index eae5917..7497f50 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -13,8 +13,8 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/file.h>
-#include <linux/random.h>
 #include <linux/quotaops.h>
+#include <linux/uuid.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 443e077..28bcde8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -20,7 +20,7 @@
 #include <linux/uaccess.h>
 #include <linux/mount.h>
 #include <linux/pagevec.h>
-#include <linux/random.h>
+#include <linux/uuid.h>
 
 #include "f2fs.h"
 #include "node.h"
diff --git a/fs/reiserfs/objectid.c b/fs/reiserfs/objectid.c
index 99a5d5d..415d66c 100644
--- a/fs/reiserfs/objectid.c
+++ b/fs/reiserfs/objectid.c
@@ -3,8 +3,8 @@
  */
 
 #include <linux/string.h>
-#include <linux/random.h>
 #include <linux/time.h>
+#include <linux/uuid.h>
 #include "reiserfs.h"
 
 /* find where objectid map starts */
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index f4fbc7b..3cbb904 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -28,8 +28,8 @@
 
 #include "ubifs.h"
 #include <linux/slab.h>
-#include <linux/random.h>
 #include <linux/math64.h>
+#include <linux/uuid.h>
 
 /*
  * Default journal size in logical eraseblocks as a percent of total
diff --git a/include/linux/random.h b/include/linux/random.h
index 9c29122..e47e533 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -26,7 +26,6 @@ extern void get_random_bytes(void *buf, int nbytes);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern void get_random_bytes_arch(void *buf, int nbytes);
-void generate_random_uuid(unsigned char uuid_out[16]);
 extern int random_int_secret_init(void);
 
 #ifndef MODULE
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 6df2509..91c2b6d 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -33,6 +33,8 @@ static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
 	return memcmp(&u1, &u2, sizeof(uuid_be));
 }
 
+void generate_random_uuid(unsigned char uuid[16]);
+
 extern void uuid_le_gen(uuid_le *u);
 extern void uuid_be_gen(uuid_be *u);
 
diff --git a/lib/uuid.c b/lib/uuid.c
index 398821e..6c81c0b 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -23,6 +23,26 @@
 #include <linux/uuid.h>
 #include <linux/random.h>
 
+/***************************************************************
+ * Random UUID interface
+ *
+ * Used here for a Boot ID, but can be useful for other kernel
+ * drivers.
+ ***************************************************************/
+
+/*
+ * Generate random UUID
+ */
+void generate_random_uuid(unsigned char uuid[16])
+{
+	get_random_bytes(uuid, 16);
+	/* Set UUID version to 4 --- truly random generation */
+	uuid[6] = (uuid[6] & 0x0F) | 0x40;
+	/* Set the UUID variant to DCE */
+	uuid[8] = (uuid[8] & 0x3F) | 0x80;
+}
+EXPORT_SYMBOL(generate_random_uuid);
+
 static void __uuid_gen_common(__u8 b[16])
 {
 	prandom_bytes(b, 16);
-- 
2.8.0.rc3
