From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: [PATCH v3] falloc: expose ioctl numbers into uapi
Date: Tue,  6 Oct 2015 18:21:15 +0200
Message-ID: <1444148477-28441-1-git-send-email-gabriel@lse.epita.fr>
References: <1444141657-14898-4-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444141657-14898-4-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
---

It seems that I am a bit off today, here is hopefully the last version

v2: missed <linux/types.h>
v3: missed <linux/ioctl.h>

 include/linux/falloc.h      | 18 ------------------
 include/uapi/linux/falloc.h | 21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 9961110..eb651e9 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -3,24 +3,6 @@
 
 #include <uapi/linux/falloc.h>
 
-
-/*
- * Space reservation ioctls and argument structure
- * are designed to be compatible with the legacy XFS ioctls.
- */
-struct space_resv {
-	__s16		l_type;
-	__s16		l_whence;
-	__s64		l_start;
-	__s64		l_len;		/* len == 0 means until end of file */
-	__s32		l_sysid;
-	__u32		l_pid;
-	__s32		l_pad[4];	/* reserved area */
-};
-
-#define FS_IOC_RESVSP		_IOW('X', 40, struct space_resv)
-#define FS_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
-
 #define	FALLOC_FL_SUPPORTED_MASK	(FALLOC_FL_KEEP_SIZE |		\
 					 FALLOC_FL_PUNCH_HOLE |		\
 					 FALLOC_FL_COLLAPSE_RANGE |	\
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 3e445a7..0ae27fe 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -1,6 +1,9 @@
 #ifndef _UAPI_FALLOC_H_
 #define _UAPI_FALLOC_H_
 
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
 #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
@@ -58,4 +61,22 @@
  */
 #define FALLOC_FL_INSERT_RANGE		0x20
 
+
+/*
+ * Space reservation ioctls and argument structure
+ * are designed to be compatible with the legacy XFS ioctls.
+ */
+struct space_resv {
+	__s16		l_type;
+	__s16		l_whence;
+	__s64		l_start;
+	__s64		l_len;		/* len == 0 means until end of file */
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserved area */
+};
+
+#define FS_IOC_RESVSP		_IOW('X', 40, struct space_resv)
+#define FS_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
+
 #endif /* _UAPI_FALLOC_H_ */
-- 
2.6.0
