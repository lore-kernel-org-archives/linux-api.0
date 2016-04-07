From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/10] fs: add IOCB_SYNC and IOCB_DSYNC
Date: Thu,  7 Apr 2016 08:52:00 -0700
Message-ID: <1460044324-5298-7-git-send-email-hch@lst.de>
References: <1460044324-5298-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460044324-5298-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This will allow us to do per-I/O sync file writes, as required by a lot
of fileservers or storage targets.

XXX: Will need a few additional audits for O_DSYNC
---
 fs/block_dev.c     |  2 +-
 fs/btrfs/file.c    |  2 +-
 fs/cifs/file.c     |  2 +-
 fs/direct-io.c     |  2 +-
 fs/ext4/file.c     |  2 +-
 fs/f2fs/file.c     |  2 +-
 fs/gfs2/file.c     |  5 ++++-
 fs/nfs/direct.c    |  2 +-
 fs/ntfs/file.c     |  2 +-
 fs/udf/file.c      |  2 +-
 fs/xfs/xfs_file.c  |  2 +-
 include/linux/fs.h | 14 ++++++++++----
 mm/filemap.c       |  2 +-
 13 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9e1f3fe..d8dc351 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1662,7 +1662,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ret = __generic_file_write_iter(iocb, from);
 	if (ret > 0) {
 		ssize_t err;
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+		err = generic_write_sync(iocb, iocb->ki_pos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d28ec60..9d8e22c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1852,7 +1852,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	BTRFS_I(inode)->last_sub_trans = root->log_transid;
 	spin_unlock(&BTRFS_I(inode)->lock);
 	if (num_written > 0) {
-		err = generic_write_sync(file, pos, num_written);
+		err = generic_write_sync(iocb, pos, num_written);
 		if (err < 0)
 			num_written = err;
 	}
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cb070aa..b22b68c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2688,7 +2688,7 @@ out:
 	inode_unlock(inode);
 
 	if (rc > 0) {
-		ssize_t err = generic_write_sync(file, iocb->ki_pos - rc, rc);
+		ssize_t err = generic_write_sync(iocb, iocb->ki_pos - rc, rc);
 		if (err < 0)
 			rc = err;
 	}
diff --git a/fs/direct-io.c b/fs/direct-io.c
index c61314b..f7bcc01 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -268,7 +268,7 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
 		if (dio->rw & WRITE) {
 			int err;
 
-			err = generic_write_sync(dio->iocb->ki_filp, offset,
+			err = generic_write_sync(dio->iocb, offset,
 						 transferred);
 			if (err < 0 && ret > 0)
 				ret = err;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0caece3..5915928 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -172,7 +172,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret > 0) {
 		ssize_t err;
 
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+		err = generic_write_sync(iocb, iocb->ki_pos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 443e077..51ed838 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1885,7 +1885,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret > 0) {
 		ssize_t err;
 
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+		err = generic_write_sync(iocb, iocb->ki_pos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 208efc7..5a7d696 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -895,7 +895,10 @@ static long __gfs2_fallocate(struct file *file, int mode, loff_t offset, loff_t
 		mark_inode_dirty(inode);
 	}
 
-	return generic_write_sync(file, pos, count);
+	if ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host))
+		return vfs_fsync_range(file, pos, pos + count - 1,
+			       (file->f_flags & __O_SYNC) ? 0 : 1);
+	return 0;
 
 out_trans_fail:
 	gfs2_inplace_release(ip);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 346b5d8..be86de9 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -1054,7 +1054,7 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 			if (i_size_read(inode) < iocb->ki_pos)
 				i_size_write(inode, iocb->ki_pos);
 			spin_unlock(&inode->i_lock);
-			generic_write_sync(file, pos, result);
+			generic_write_sync(iocb, pos, result);
 		}
 	}
 	nfs_direct_req_release(dreq);
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 91117ad..10dc38c 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1953,7 +1953,7 @@ static ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	current->backing_dev_info = NULL;
 	inode_unlock(vi);
 	if (likely(written > 0)) {
-		err = generic_write_sync(file, iocb->ki_pos, written);
+		err = generic_write_sync(iocb, iocb->ki_pos, written);
 		if (err < 0)
 			written = 0;
 	}
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 7ab8d81..8e3d1ae 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -152,7 +152,7 @@ out:
 
 	if (retval > 0) {
 		mark_inode_dirty(inode);
-		err = generic_write_sync(file, iocb->ki_pos - retval, retval);
+		err = generic_write_sync(iocb, iocb->ki_pos - retval, retval);
 		if (err < 0)
 			retval = err;
 	}
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5de047a..b5d70e7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -908,7 +908,7 @@ xfs_file_write_iter(
 		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
 
 		/* Handle various SYNC-type writes */
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+		err = generic_write_sync(iocb, iocb->ki_pos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc29d12..1e61161 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -323,6 +323,8 @@ struct writeback_control;
 #define IOCB_APPEND		(1 << 1)
 #define IOCB_DIRECT		(1 << 2)
 #define IOCB_HIPRI		(1 << 3)
+#define IOCB_DSYNC		(1 << 4)
+#define IOCB_SYNC		(1 << 5)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -2475,12 +2477,12 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
 extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
 extern int vfs_fsync(struct file *file, int datasync);
-static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
+static inline int generic_write_sync(struct kiocb *iocb, loff_t pos, loff_t count)
 {
-	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
+	if (!(iocb->ki_flags & IOCB_DSYNC))
 		return 0;
-	return vfs_fsync_range(file, pos, pos + count - 1,
-			       (file->f_flags & __O_SYNC) ? 0 : 1);
+	return vfs_fsync_range(iocb->ki_filp, pos, pos + count - 1,
+			       (iocb->ki_flags & IOCB_SYNC) ? 0 : 1);
 }
 extern void emergency_sync(void);
 extern void emergency_remount(void);
@@ -2932,6 +2934,10 @@ static inline int iocb_flags(struct file *file)
 		res |= IOCB_APPEND;
 	if (io_is_direct(file))
 		res |= IOCB_DIRECT;
+	if ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host))
+		res |= IOCB_DSYNC;
+	if (file->f_flags & __O_SYNC)
+		res |= IOCB_SYNC;
 	return res;
 }
 
diff --git a/mm/filemap.c b/mm/filemap.c
index cb36db9..8345d6d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2794,7 +2794,7 @@ ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ret > 0) {
 		ssize_t err;
 
-		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+		err = generic_write_sync(iocb, iocb->ki_pos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
-- 
2.1.4
