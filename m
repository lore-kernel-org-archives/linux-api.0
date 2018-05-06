From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 6/6 v1] statfs: add ST_PRIVATE
Date: Mon,  7 May 2018 00:47:04 +0200
Message-ID: <20180506224704.14669-7-christian.brauner@ubuntu.com>
References: <20180506224704.14669-1-christian.brauner@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180506224704.14669-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Currently userspace can only determine whether a mountpoint is private
by parsing /proc/<pid>/mountinfo. It would be convenient to simply retrieve
this property with a statvfs() call.
This let's userspace avoid costly parsing, supports cases where /proc is
not mounted, and supports usecases where file descriptors to mountpoints
are passed between processes that are inspected via fstatvfs().
A mountpoint is considered ST_PRIVATE iff and it is neither ST_SLAVE nor
ST_SHARED.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
v0->v1:
* non-functional changes: extend commit message
---
 fs/statfs.c            | 2 ++
 include/linux/statfs.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/statfs.c b/fs/statfs.c
index 35ad0402c9a3..899e899ee84c 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -58,6 +58,8 @@ static int calculate_f_flags(struct vfsmount *mnt)
 
 	if (IS_MNT_SLAVE(real_mount(mnt)))
 		flags |= ST_SLAVE;
+	else if (!(flags & ST_SHARED))
+		flags |= ST_PRIVATE;
 
 	return flags;
 }
diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index 048127effaad..663fa5498a7d 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -41,6 +41,7 @@ struct kstatfs {
 #define ST_NODIRATIME	(1<<11) /* do not update directory access times */
 #define ST_RELATIME	(1<<12) /* update atime relative to mtime/ctime */
 #define ST_UNBINDABLE	(1<<17)	/* change to unbindable */
+#define ST_PRIVATE	(1<<18)	/* change to private */
 #define ST_SLAVE	(1<<19)	/* change to slave */
 #define ST_SHARED	(1<<20)	/* change to shared */
 
-- 
2.17.0
