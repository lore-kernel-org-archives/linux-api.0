From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 1/6 v1 resend] fs: use << for MS_* flags
Date: Fri, 25 May 2018 14:48:20 +0200
Message-ID: <20180525124825.23875-2-christian@brauner.io>
References: <20180525124825.23875-1-christian@brauner.io>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180525124825.23875-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org, ebiederm@xmission.com, seth.forshee@canonical.com, viro@zeniv.linux.org.uk, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

The definitions for MS_* flags are currently a mixture between hex values
and bit-shifts. All higher values are already initialized with bit-shifts
for MS_* constants starting with (1<<16).
This patch switches the definitions for MS_* constants over to uniformly
use bit-shifts.
Note that the BIT() macro cannot be used as it is not exported to uapi
files as was pointed out by gregkh.

Signed-off-by: Christian Brauner <christian@brauner.io>
---
v0->v1:
* non-functional changes: extend commit message
---
 include/uapi/linux/fs.h | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index d2a8313fabd7..9662790a657c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -105,22 +105,23 @@ struct inodes_stat_t {
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
  */
-#define MS_RDONLY	 1	/* Mount read-only */
-#define MS_NOSUID	 2	/* Ignore suid and sgid bits */
-#define MS_NODEV	 4	/* Disallow access to device special files */
-#define MS_NOEXEC	 8	/* Disallow program execution */
-#define MS_SYNCHRONOUS	16	/* Writes are synced at once */
-#define MS_REMOUNT	32	/* Alter flags of a mounted FS */
-#define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
-#define MS_DIRSYNC	128	/* Directory modifications are synchronous */
-#define MS_NOATIME	1024	/* Do not update access times. */
-#define MS_NODIRATIME	2048	/* Do not update directory access times */
-#define MS_BIND		4096
-#define MS_MOVE		8192
-#define MS_REC		16384
-#define MS_VERBOSE	32768	/* War is peace. Verbosity is silence.
-				   MS_VERBOSE is deprecated. */
-#define MS_SILENT	32768
+#define MS_RDONLY	(1<<0)	/* Mount read-only */
+#define MS_NOSUID	(1<<1)	/* Ignore suid and sgid bits */
+#define MS_NODEV	(1<<2)	/* Disallow access to device special files */
+#define MS_NOEXEC	(1<<3)	/* Disallow program execution */
+#define MS_SYNCHRONOUS	(1<<4)	/* Writes are synced at once */
+#define MS_REMOUNT	(1<<5)	/* Alter flags of a mounted FS */
+#define MS_MANDLOCK	(1<<6)	/* Allow mandatory locks on an FS */
+#define MS_DIRSYNC	(1<<7)	/* Directory modifications are synchronous */
+#define MS_NOATIME	(1<<10)	/* Do not update access times. */
+#define MS_NODIRATIME	(1<<11)	/* Do not update directory access times */
+#define MS_BIND		(1<<12)
+#define MS_MOVE		(1<<13)
+#define MS_REC		(1<<14)
+#define MS_VERBOSE	(1<<15)	/* War is peace. Verbosity is silence.
+				 * MS_VERBOSE is deprecated.
+				 */
+#define MS_SILENT	(1<<15)
 #define MS_POSIXACL	(1<<16)	/* VFS does not apply the umask */
 #define MS_UNBINDABLE	(1<<17)	/* change to unbindable */
 #define MS_PRIVATE	(1<<18)	/* change to private */
-- 
2.17.0
