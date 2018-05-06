From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5/6 v1] statfs: add ST_SLAVE
Date: Mon,  7 May 2018 00:47:03 +0200
Message-ID: <20180506224704.14669-6-christian.brauner@ubuntu.com>
References: <20180506224704.14669-1-christian.brauner@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180506224704.14669-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Currently userspace can only determine whether a mountpoint is slave
by parsing /proc/<pid>/mountinfo. It would be convenient to simply retrieve
this property with a statvfs() call.
This let's userspace avoid costly parsing, supports cases where /proc is
not mounted, and supports usecases where file descriptors to mountpoints
are passed between processes that are inspected via fstatvfs().
This is especially helpful in all cases where userspace is not interested
in specific propagation properties our peer group layouts but rather just
wants to either turn on or turn off propagation for specific mountpoints.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
v0->v1:
* non-functional changes: extend commit message
---
 fs/statfs.c            | 10 +++++++++-
 include/linux/statfs.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index 2fc6f9c3793c..35ad0402c9a3 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -10,6 +10,7 @@
 #include <linux/uaccess.h>
 #include <linux/compat.h>
 #include "internal.h"
+#include "pnode.h"
 
 static int flags_by_mnt(int mnt_flags)
 {
@@ -50,8 +51,15 @@ static int flags_by_sb(int s_flags)
 
 static int calculate_f_flags(struct vfsmount *mnt)
 {
-	return ST_VALID | flags_by_mnt(mnt->mnt_flags) |
+	int flags = 0;
+
+	flags = ST_VALID | flags_by_mnt(mnt->mnt_flags) |
 		flags_by_sb(mnt->mnt_sb->s_flags);
+
+	if (IS_MNT_SLAVE(real_mount(mnt)))
+		flags |= ST_SLAVE;
+
+	return flags;
 }
 
 static int statfs_by_dentry(struct dentry *dentry, struct kstatfs *buf)
diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index 5416b2936dd9..048127effaad 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -41,6 +41,7 @@ struct kstatfs {
 #define ST_NODIRATIME	(1<<11) /* do not update directory access times */
 #define ST_RELATIME	(1<<12) /* update atime relative to mtime/ctime */
 #define ST_UNBINDABLE	(1<<17)	/* change to unbindable */
+#define ST_SLAVE	(1<<19)	/* change to slave */
 #define ST_SHARED	(1<<20)	/* change to shared */
 
 #endif
-- 
2.17.0
