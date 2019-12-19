From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH 1/2] uapi: split openat2(2) definitions from fcntl.h
Date: Thu, 19 Dec 2019 21:55:29 +1100
Message-ID: <20191219105533.12508-2-cyphar@cyphar.com>
References: <20191219105533.12508-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191219105533.12508-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Florian Weimer <fweimer@redhat.com>, David Laight <david.laight@aculab.com>, Christian Brauner <christian.brauner@ubuntu.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Florian mentioned that glibc doesn't use fcntl.h because it has some
issues with namespace cleanliness, and that we should have a separate
header for openat2(2) if possible.

Suggested-by: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 MAINTAINERS                  |  1 +
 include/uapi/linux/fcntl.h   | 37 +-------------------------------
 include/uapi/linux/openat2.h | 41 ++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 36 deletions(-)
 create mode 100644 include/uapi/linux/openat2.h

diff --git a/MAINTAINERS b/MAINTAINERS
index bd5847e802de..737ada377ac3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6397,6 +6397,7 @@ F:	fs/*
 F:	include/linux/fs.h
 F:	include/linux/fs_types.h
 F:	include/uapi/linux/fs.h
+F:	include/uapi/linux/openat2.h
 
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 M:	Riku Voipio <riku.voipio@iki.fi>
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index d886bdb585e4..ca88b7bce553 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -3,6 +3,7 @@
 #define _UAPI_LINUX_FCNTL_H
 
 #include <asm/fcntl.h>
+#include <linux/openat2.h>
 
 #define F_SETLEASE	(F_LINUX_SPECIFIC_BASE + 0)
 #define F_GETLEASE	(F_LINUX_SPECIFIC_BASE + 1)
@@ -100,40 +101,4 @@
 
 #define AT_RECURSIVE		0x8000	/* Apply to the entire subtree */
 
-/*
- * Arguments for how openat2(2) should open the target path. If @resolve is
- * zero, then openat2(2) operates very similarly to openat(2).
- *
- * However, unlike openat(2), unknown bits in @flags result in -EINVAL rather
- * than being silently ignored. @mode must be zero unless one of {O_CREAT,
- * O_TMPFILE} are set.
- *
- * @flags: O_* flags.
- * @mode: O_CREAT/O_TMPFILE file mode.
- * @resolve: RESOLVE_* flags.
- */
-struct open_how {
-	__aligned_u64 flags;
-	__u16 mode;
-	__u16 __padding[3]; /* must be zeroed */
-	__aligned_u64 resolve;
-};
-
-#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
-#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
-
-/* how->resolve flags for openat2(2). */
-#define RESOLVE_NO_XDEV		0x01 /* Block mount-point crossings
-					(includes bind-mounts). */
-#define RESOLVE_NO_MAGICLINKS	0x02 /* Block traversal through procfs-style
-					"magic-links". */
-#define RESOLVE_NO_SYMLINKS	0x04 /* Block traversal through all symlinks
-					(implies OEXT_NO_MAGICLINKS) */
-#define RESOLVE_BENEATH		0x08 /* Block "lexical" trickery like
-					"..", symlinks, and absolute
-					paths which escape the dirfd. */
-#define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
-					be scoped inside the dirfd
-					(similar to chroot(2)). */
-
 #endif /* _UAPI_LINUX_FCNTL_H */
diff --git a/include/uapi/linux/openat2.h b/include/uapi/linux/openat2.h
new file mode 100644
index 000000000000..19ef775e8e5e
--- /dev/null
+++ b/include/uapi/linux/openat2.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_OPENAT2_H
+#define _UAPI_LINUX_OPENAT2_H
+
+/*
+ * Arguments for how openat2(2) should open the target path. If @resolve is
+ * zero, then openat2(2) operates very similarly to openat(2).
+ *
+ * However, unlike openat(2), unknown bits in @flags result in -EINVAL rather
+ * than being silently ignored. @mode must be zero unless one of {O_CREAT,
+ * O_TMPFILE} are set.
+ *
+ * @flags: O_* flags.
+ * @mode: O_CREAT/O_TMPFILE file mode.
+ * @resolve: RESOLVE_* flags.
+ */
+struct open_how {
+	__aligned_u64 flags;
+	__u16 mode;
+	__u16 __padding[3]; /* must be zeroed */
+	__aligned_u64 resolve;
+};
+
+#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
+#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
+
+/* how->resolve flags for openat2(2). */
+#define RESOLVE_NO_XDEV		0x01 /* Block mount-point crossings
+					(includes bind-mounts). */
+#define RESOLVE_NO_MAGICLINKS	0x02 /* Block traversal through procfs-style
+					"magic-links". */
+#define RESOLVE_NO_SYMLINKS	0x04 /* Block traversal through all symlinks
+					(implies OEXT_NO_MAGICLINKS) */
+#define RESOLVE_BENEATH		0x08 /* Block "lexical" trickery like
+					"..", symlinks, and absolute
+					paths which escape the dirfd. */
+#define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
+					be scoped inside the dirfd
+					(similar to chroot(2)). */
+
+#endif /* _UAPI_LINUX_OPENAT2_H */
-- 
2.24.0
