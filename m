From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] fs: add a VALID_OPEN_FLAGS
Date: Thu, 30 Mar 2017 18:33:26 +0200
Message-ID: <20170330163327.23920-2-hch@lst.de>
References: <20170330163327.23920-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170330163327.23920-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

Add a central define for all valid open flags, and use it in the uniqueness
check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fcntl.c            | 14 ++++----------
 include/linux/fcntl.h |  6 ++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index be8fbe289087..de1b16bb6a29 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -742,16 +742,10 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
-		O_RDONLY	| O_WRONLY	| O_RDWR	|
-		O_CREAT		| O_EXCL	| O_NOCTTY	|
-		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
-		__O_SYNC	| O_DSYNC	| FASYNC	|
-		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
-		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
-		__FMODE_NONOTIFY
-		));
+	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
+		HWEIGHT32(
+			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
+			__FMODE_EXEC | __FMODE_NONOTIFY));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
 		sizeof(struct fasync_struct), 0, SLAB_PANIC, NULL);
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 76ce329e656d..1b48d9c9a561 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -3,6 +3,12 @@
 
 #include <uapi/linux/fcntl.h>
 
+/* list of all valid flags for the open/openat flags argument: */
+#define VALID_OPEN_FLAGS \
+	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
+	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
+	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
+	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
 
 #ifndef force_o_largefile
 #define force_o_largefile() (BITS_PER_LONG != 32)
-- 
2.11.0
