From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 2/6 v1] statfs: use << to align with fs header
Date: Mon,  7 May 2018 00:47:00 +0200
Message-ID: <20180506224704.14669-3-christian.brauner@ubuntu.com>
References: <20180506224704.14669-1-christian.brauner@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180506224704.14669-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

After switching to using bit-shifts to define MS_* flags switch over ST_*
flags too. ST_* and MS_* flags generally have the exact same value.
Initializing them identically let's userspace easily detect when flags
indicate the same property but use a different value in doing so.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
v0->v1:
* non-functional changes: extend commit message
---
 include/linux/statfs.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index 3142e98546ac..b336c04e793c 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -27,18 +27,18 @@ struct kstatfs {
  * ABI.  The exception is ST_VALID which has the same value as MS_REMOUNT
  * which doesn't make any sense for statfs.
  */
-#define ST_RDONLY	0x0001	/* mount read-only */
-#define ST_NOSUID	0x0002	/* ignore suid and sgid bits */
-#define ST_NODEV	0x0004	/* disallow access to device special files */
-#define ST_NOEXEC	0x0008	/* disallow program execution */
-#define ST_SYNCHRONOUS	0x0010	/* writes are synced at once */
-#define ST_VALID	0x0020	/* f_flags support is implemented */
-#define ST_MANDLOCK	0x0040	/* allow mandatory locks on an FS */
-/* 0x0080 used for ST_WRITE in glibc */
-/* 0x0100 used for ST_APPEND in glibc */
-/* 0x0200 used for ST_IMMUTABLE in glibc */
-#define ST_NOATIME	0x0400	/* do not update access times */
-#define ST_NODIRATIME	0x0800	/* do not update directory access times */
-#define ST_RELATIME	0x1000	/* update atime relative to mtime/ctime */
+#define ST_RDONLY	(1<<0) /* mount read-only */
+#define ST_NOSUID	(1<<1) /* ignore suid and sgid bits */
+#define ST_NODEV	(1<<2) /* disallow access to device special files */
+#define ST_NOEXEC	(1<<3) /* disallow program execution */
+#define ST_SYNCHRONOUS	(1<<4) /* writes are synced at once */
+#define ST_VALID	(1<<5) /* f_flags support is implemented */
+#define ST_MANDLOCK	(1<<6) /* allow mandatory locks on an FS */
+/* (1<<7) used for ST_WRITE in glibc */
+/* (1<<8) used for ST_APPEND in glibc */
+/* (1<<9) used for ST_IMMUTABLE in glibc */
+#define ST_NOATIME	(1<<10) /* do not update access times */
+#define ST_NODIRATIME	(1<<11) /* do not update directory access times */
+#define ST_RELATIME	(1<<12) /* update atime relative to mtime/ctime */
 
 #endif
-- 
2.17.0
