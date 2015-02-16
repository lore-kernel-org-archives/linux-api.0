From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 10/12] xfstests: fsstress: Add fallocate insert range operation
Date: Tue, 17 Feb 2015 00:47:57 +0900
Message-ID: <1424101680-3301-11-git-send-email-linkinjeon@gmail.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: david@fromorbit.com, tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, bfoster@redhat.com, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
List-Id: linux-api@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This commit adds insert operation support for fsstress, which is
meant to exercise fallocate FALLOC_FL_INSERT_RANGE support.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 ltp/fsstress.c |   19 ++++++++++++++++---
 src/global.h   |    4 ++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index b56fe5c..aa3e0c3 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -72,6 +72,7 @@ typedef enum {
 	OP_PUNCH,
 	OP_ZERO,
 	OP_COLLAPSE,
+	OP_INSERT,
 	OP_READ,
 	OP_READLINK,
 	OP_RENAME,
@@ -170,6 +171,7 @@ void	mknod_f(int, long);
 void	punch_f(int, long);
 void	zero_f(int, long);
 void	collapse_f(int, long);
+void	insert_f(int, long);
 void	read_f(int, long);
 void	readlink_f(int, long);
 void	rename_f(int, long);
@@ -209,6 +211,7 @@ opdesc_t	ops[] = {
 	{ OP_PUNCH, "punch", punch_f, 1, 1 },
 	{ OP_ZERO, "zero", zero_f, 1, 1 },
 	{ OP_COLLAPSE, "collapse", collapse_f, 1, 1 },
+	{ OP_INSERT, "insert", insert_f, 1, 1 },
 	{ OP_READ, "read", read_f, 1, 0 },
 	{ OP_READLINK, "readlink", readlink_f, 1, 0 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
@@ -2176,6 +2179,7 @@ struct print_flags falloc_flags [] = {
 	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
 	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
+	{ FALLOC_FL_INSERT_RANGE, "INSERT_RANGE"},
 	{ -1, NULL}
 };
 
@@ -2227,10 +2231,11 @@ do_fallocate(int opno, long r, int mode)
 	off %= maxfsize;
 	len = (off64_t)(random() % (1024 * 1024));
 	/*
-	 * Collapse range requires off and len to be block aligned, make it
-	 * more likely to be the case.
+	 * Collapse/insert range requires off and len to be block aligned,
+	 * make it more likely to be the case.
 	 */
-	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {
+	if ((mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)) &&
+		(opno % 2)) {
 		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 	}
@@ -2656,6 +2661,14 @@ collapse_f(int opno, long r)
 }
 
 void
+insert_f(int opno, long r)
+{
+#ifdef HAVE_LINUX_FALLOC_H
+	do_fallocate(opno, r, FALLOC_FL_INSERT_RANGE);
+#endif
+}
+
+void
 read_f(int opno, long r)
 {
 	char		*buf;
diff --git a/src/global.h b/src/global.h
index 8180f66..f63246b 100644
--- a/src/global.h
+++ b/src/global.h
@@ -172,6 +172,10 @@
 #define FALLOC_FL_ZERO_RANGE		0x10
 #endif
 
+#ifndef FALLOC_FL_INSERT_RANGE
+#define FALLOC_FL_INSERT_RANGE		0x20
+#endif
+
 #endif /* HAVE_LINUX_FALLOC_H */
 
 #endif /* GLOBAL_H */
-- 
1.7.9.5
