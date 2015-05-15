From: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Subject: [PATCH RFC v2 2/2] vfs: add O_NOCMTIME
Date: Fri, 15 May 2015 14:23:48 -0700
Message-ID: <1431725028-24071-3-git-send-email-zab@zabbo.net>
References: <1431725028-24071-1-git-send-email-zab@zabbo.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431725028-24071-1-git-send-email-zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add a O_NOCMTIME flag which prevents inode time updates on writes and
can greatly reduce the IO overhead of writes to allocated and
initialized regions of files.

ceph servers can have loads where they perform O_DIRECT overwrites of
allocated file data and then sync to make sure that the O_DIRECT writes
are flushed from write caches.  If the writes dirty the inode with mtime
updates then the syncs also write out the metadata needed to track the
inodes which can add significant iop and latency overhead.

The ceph servers don't use mtime at all.  They're using the local file
system as a backing store and any backups would be driven by their upper
level ceph metadata.

In simple tests a O_DIRECT|O_NOCMTIME overwriting write followed by a
sync went from 2 serial write round trips to 1 in XFS and from 4 serial
IO round trips to 1 in ext4.

file_update_time() is changed to call a file_is_nocmtime() helper which
tests the file flag in addition to testing the inode's S_NOCMTIME flag.
It doesn't check FMODE_NOCMTIME because that's only used by XFS to
trigger private flags which trigger private flags which do other things.

O_NOCMTIME can only be used if the mount has its MNT_NOCMTIME flag set.
This requires priviledged intervention to testify that mtime isn't
critical to, say, backup infrastructure or NFS server consistency
guarantees.

Signed-off-by: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
---
 fs/fcntl.c                       | 30 +++++++++++++++++++++++-------
 fs/inode.c                       |  2 +-
 fs/namei.c                       |  3 +--
 include/linux/fs.h               |  7 +++++++
 include/uapi/asm-generic/fcntl.h |  4 ++++
 5 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ee85cd4..eaa5d1d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -22,12 +22,30 @@
 #include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/shmem_fs.h>
+#include <linux/mount.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME | \
+		    O_NOCMTIME)
+
+/*
+ * O_NOATIME and O_NOCMTIME can only be set by the ownder or superuser.
+ * And O_NOCMTIME requires MNT_NOCMTIME.
+ */
+bool forbid_o_notime(struct inode *inode, struct vfsmount *mnt,
+		     unsigned long flags)
+{
+	if ((flags & (O_NOATIME|O_NOCMTIME)) && !inode_owner_or_capable(inode))
+		return true;
+
+	if ((flags & O_NOCMTIME) && !(mnt->mnt_flags & MNT_NOCMTIME))
+		return true;
+
+	return false;
+}
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -41,10 +59,8 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	if (((arg ^ filp->f_flags) & O_APPEND) && IS_APPEND(inode))
 		return -EPERM;
 
-	/* O_NOATIME can only be set by the owner or superuser */
-	if ((arg & O_NOATIME) && !(filp->f_flags & O_NOATIME))
-		if (!inode_owner_or_capable(inode))
-			return -EPERM;
+	if (forbid_o_notime(inode, filp->f_path.mnt, arg & ~filp->f_flags))
+		return -EPERM;
 
 	/* required for strict SunOS emulation */
 	if (O_NONBLOCK != O_NDELAY)
@@ -740,7 +756,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
@@ -748,7 +764,7 @@ static int __init fcntl_init(void)
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
 		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
-		__FMODE_NONOTIFY
+		__FMODE_NONOTIFY| O_NOCMTIME
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/fs/inode.c b/fs/inode.c
index ea37cd1..b643dd0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1721,7 +1721,7 @@ int file_update_time(struct file *file)
 	int ret;
 
 	/* First try to exhaust all avenues to not sync */
-	if (IS_NOCMTIME(inode))
+	if (file_is_nocmtime(file))
 		return 0;
 
 	now = current_fs_time(inode->i_sb);
diff --git a/fs/namei.c b/fs/namei.c
index fe30d3b..8ecebca 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2617,8 +2617,7 @@ static int may_open(struct path *path, int acc_mode, int flag)
 			return -EPERM;
 	}
 
-	/* O_NOATIME can only be set by the owner or superuser */
-	if (flag & O_NOATIME && !inode_owner_or_capable(inode))
+	if (forbid_o_notime(inode, path->mnt, flag))
 		return -EPERM;
 
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 35ec87e..dd92eeb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1471,6 +1471,8 @@ static inline void sb_start_intwrite(struct super_block *sb)
 
 
 extern bool inode_owner_or_capable(const struct inode *inode);
+extern bool forbid_o_notime(struct inode *inode, struct vfsmount *mnt,
+			    unsigned long flags);
 
 /*
  * VFS helper functions..
@@ -2950,6 +2952,11 @@ static inline bool is_root_inode(struct inode *inode)
 	return inode == inode->i_sb->s_root->d_inode;
 }
 
+static inline bool file_is_nocmtime(struct file *file)
+{
+	return IS_NOCMTIME(file_inode(file)) || (file->f_flags & O_NOCMTIME);
+}
+
 static inline bool dir_emit(struct dir_context *ctx,
 			    const char *name, int namelen,
 			    u64 ino, unsigned type)
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index e063eff..ed7b2e1 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -88,6 +88,10 @@
 #define __O_TMPFILE	020000000
 #endif
 
+#ifndef O_NOCMTIME
+#define O_NOCMTIME	040000000
+#endif
+
 /* a horrid kludge trying to make sure that this will fail on old kernels */
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
-- 
2.1.0
