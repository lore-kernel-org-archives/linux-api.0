From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 10/10] btrfs: nowait aio support
Date: Thu, 15 Jun 2017 11:00:02 -0500
Message-ID: <20170615160002.17233-11-rgoldwyn@suse.de>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170615160002.17233-1-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Return EAGAIN if any of the following checks fail
 + i_rwsem is not lockable
 + NODATACOW or PREALLOC is not set
 + Cannot nocow at the desired location
 + Writing beyond end of file which is not allocated

Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c  | 33 +++++++++++++++++++++++++++------
 fs/btrfs/inode.c |  3 +++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index da1096eb1a40..59e2dccdf75b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1875,12 +1875,29 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
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
@@ -1914,8 +1931,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	 */
 	update_time_for_write(inode);
 
-	pos = iocb->ki_pos;
-	count = iov_iter_count(from);
 	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
 	if (start_pos > oldsize) {
@@ -3071,13 +3086,19 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 	return offset;
 }
 
+static int btrfs_file_open(struct inode *inode, struct file *filp)
+{
+	filp->f_mode |= FMODE_AIO_NOWAIT;
+	return generic_file_open(inode, filp);
+}
+
 const struct file_operations btrfs_file_operations = {
 	.llseek		= btrfs_file_llseek,
 	.read_iter      = generic_file_read_iter,
 	.splice_read	= generic_file_splice_read,
 	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
-	.open		= generic_file_open,
+	.open		= btrfs_file_open,
 	.release	= btrfs_release_file,
 	.fsync		= btrfs_sync_file,
 	.fallocate	= btrfs_fallocate,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ef3c98c527c1..861979802aa3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8755,6 +8755,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			dio_data.overwrite = 1;
 			inode_unlock(inode);
 			relock = true;
+		} else if (iocb->ki_flags & IOCB_NOWAIT) {
+			ret = -EAGAIN;
+			goto out;
 		}
 		ret = btrfs_delalloc_reserve_space(inode, offset, count);
 		if (ret)
-- 
2.12.0
