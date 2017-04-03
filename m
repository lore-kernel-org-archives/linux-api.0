From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 8/8] nowait aio: btrfs
Date: Mon,  3 Apr 2017 13:53:07 -0500
Message-ID: <20170403185307.6243-9-rgoldwyn@suse.de>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403185307.6243-1-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

Return EAGAIN if any of the following checks fail
 + i_rwsem is not lockable
 + NODATACOW or PREALLOC is not set
 + Cannot nocow at the desired location
 + Writing beyond end of file which is not allocated
---
 fs/btrfs/file.c  | 25 ++++++++++++++++++++-----
 fs/btrfs/inode.c |  3 +++
 fs/btrfs/super.c |  2 +-
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 520cb72..a870e5d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1823,12 +1823,29 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	ssize_t num_written = 0;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 	ssize_t err;
-	loff_t pos;
-	size_t count;
+	loff_t pos = iocb->ki_pos;
+	size_t count = iov_iter_count(from);
 	loff_t oldsize;
 	int clean_page = 0;
 
-	inode_lock(inode);
+	if ((iocb->ki_flags & IOCB_NOWAIT) &&
+			(iocb->ki_flags & IOCB_DIRECT)) {
+		/* Don't sleep on inode rwsem */
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+		/*
+		 * We will allocate space in case nodatacow is not set,
+		 * so bail
+		 */
+		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+					      BTRFS_INODE_PREALLOC)) ||
+		    check_can_nocow(BTRFS_I(inode), pos, &count) <= 0) {
+			inode_unlock(inode);
+			return -EAGAIN;
+		}
+	} else
+		inode_lock(inode);
+
 	err = generic_write_checks(iocb, from);
 	if (err <= 0) {
 		inode_unlock(inode);
@@ -1862,8 +1879,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	 */
 	update_time_for_write(inode);
 
-	pos = iocb->ki_pos;
-	count = iov_iter_count(from);
 	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
 	if (start_pos > oldsize) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a18510b..d91b21a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8627,6 +8627,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			dio_data.overwrite = 1;
 			inode_unlock(inode);
 			relock = true;
+		} else if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
 		}
 		ret = btrfs_delalloc_reserve_space(inode, offset, count);
 		if (ret)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index da687dc..5e60659 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2175,7 +2175,7 @@ static struct file_system_type btrfs_fs_type = {
 	.name		= "btrfs",
 	.mount		= btrfs_mount,
 	.kill_sb	= btrfs_kill_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
+	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA | FS_NOWAIT,
 };
 MODULE_ALIAS_FS("btrfs");
 
-- 
2.10.2
