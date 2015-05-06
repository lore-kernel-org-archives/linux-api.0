From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed,  6 May 2015 15:00:12 -0700
Message-ID: <1430949612-21356-1-git-send-email-zab@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add the O_NOMTIME flag which prevents mtime from being updated which can
greatly reduce the IO overhead of writes to allocated and initialized
regions of files.

ceph servers can have loads where they perform O_DIRECT overwrites of
allocated file data and then sync to make sure that the O_DIRECT writes
are flushed from write caches.  If the writes dirty the inode with mtime
updates then the syncs also write out the metadata needed to track the
inodes which can add significant iop and latency overhead.

The ceph servers don't use mtime at all.  They're using the local file
system as a backing store and any backups would be driven by their upper
level ceph metadata.  For ceph, slow IO from mtime updates in the file
system is as daft as if we had block devices slowing down IO for
per-block write timestamps that file systems never use.

In simple tests a O_DIRECT|O_NOMTIME overwriting write followed by a
sync went from 2 serial write round trips to 1 in XFS and from 4 serial
IO round trips to 1 in ext4.

file_update_time() checks for O_NOMTIME and aborts the update if it's
set, just like the current check for the in-kernel inode flag
S_NOCMTIME.  I didn't update any other mtime update sites. They could be
added as we decide that it's appropriate to do so.

I opted not to name the flag O_NOCMTIME because I didn't want the name
to imply that ctime updates would be prevented for other inode changes
like updating i_size in truncate.  Not updating ctime is a side-effect
of removing mtime updates when it's the only thing changing in the
inode.

The criteria for using O_NOMTIME is the same as for using O_NOATIME:
owning the file or having the CAP_FOWNER capability.  If we're not
comfortable allowing owners to prevent mtime/ctime updates then we
should add a tunable to allow O_NOMTIME.  Maybe a mount option?

Signed-off-by: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/fcntl.c                       | 12 +++++++-----
 fs/inode.c                       |  2 +-
 fs/namei.c                       |  4 ++--
 include/linux/fs.h               |  7 +------
 include/uapi/asm-generic/fcntl.h |  4 ++++
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ee85cd4..9e48092 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -27,7 +27,8 @@
 #include <asm/siginfo.h>
 #include <asm/uaccess.h>
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME | \
+		    O_NOMTIME)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -41,8 +42,9 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	if (((arg ^ filp->f_flags) & O_APPEND) && IS_APPEND(inode))
 		return -EPERM;
 
-	/* O_NOATIME can only be set by the owner or superuser */
-	if ((arg & O_NOATIME) && !(filp->f_flags & O_NOATIME))
+	/* O_NOATIME and O_NOMTIME can only be set by the owner or superuser */
+	if (((arg & O_NOATIME) && !(filp->f_flags & O_NOATIME)) ||
+	    ((arg & O_NOMTIME) && !(filp->f_flags & O_NOMTIME)))
 		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 
@@ -740,7 +742,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
@@ -748,7 +750,7 @@ static int __init fcntl_init(void)
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
 		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
-		__FMODE_NONOTIFY
+		__FMODE_NONOTIFY| O_NOMTIME
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/fs/inode.c b/fs/inode.c
index ea37cd1..8976edc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1721,7 +1721,7 @@ int file_update_time(struct file *file)
 	int ret;
 
 	/* First try to exhaust all avenues to not sync */
-	if (IS_NOCMTIME(inode))
+	if (IS_NOCMTIME(inode) || (file->f_flags & O_NOMTIME))
 		return 0;
 
 	now = current_fs_time(inode->i_sb);
diff --git a/fs/namei.c b/fs/namei.c
index 4a8d998b..1a3ccb3 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2609,8 +2609,8 @@ static int may_open(struct path *path, int acc_mode, int flag)
 			return -EPERM;
 	}
 
-	/* O_NOATIME can only be set by the owner or superuser */
-	if (flag & O_NOATIME && !inode_owner_or_capable(inode))
+	/* O_NOATIME and O_NOMTIME can only be set by the owner or superuser */
+	if (flag & (O_NOATIME|O_NOMTIME) && !inode_owner_or_capable(inode))
 		return -EPERM;
 
 	return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 35ec87e..34602f5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -110,12 +110,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* 64bit hashes as llseek() offset (for directories) */
 #define FMODE_64BITHASH         ((__force fmode_t)0x400)
 
-/*
- * Don't update ctime and mtime.
- *
- * Currently a special hack for the XFS open_by_handle ioctl, but we'll
- * hopefully graduate it to a proper O_CMTIME flag supported by open(2) soon.
- */
+/* Don't update ctime and mtime. */
 #define FMODE_NOCMTIME		((__force fmode_t)0x800)
 
 /* Expect random access pattern */
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index e063eff..8e484ae 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -88,6 +88,10 @@
 #define __O_TMPFILE	020000000
 #endif
 
+#ifndef O_NOMTIME
+#define O_NOMTIME	040000000
+#endif
+
 /* a horrid kludge trying to make sure that this will fail on old kernels */
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
-- 
2.1.0
