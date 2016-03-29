From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] direct-io: eliminate the offset argument to ->direct_IO
Date: Tue, 29 Mar 2016 19:37:28 +0200
Message-ID: <1459273054-13478-5-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Including blkdev_direct_IO and dax_do_io.  It has to be ki_pos to actually
work, so eliminate the superflous argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/Locking          |  2 +-
 Documentation/filesystems/vfs.txt          |  2 +-
 drivers/staging/lustre/lustre/llite/rw26.c |  4 ++--
 fs/9p/vfs_addr.c                           |  3 ++-
 fs/affs/file.c                             |  5 +++--
 fs/block_dev.c                             |  6 +++---
 fs/btrfs/inode.c                           |  6 +++---
 fs/ceph/addr.c                             |  3 +--
 fs/cifs/file.c                             |  2 +-
 fs/dax.c                                   |  4 ++--
 fs/direct-io.c                             |  7 ++++---
 fs/exofs/inode.c                           |  3 +--
 fs/ext2/inode.c                            |  8 ++++----
 fs/ext4/ext4.h                             |  3 +--
 fs/ext4/indirect.c                         | 12 ++++++------
 fs/ext4/inode.c                            | 18 +++++++++---------
 fs/f2fs/data.c                             |  6 +++---
 fs/fat/inode.c                             |  6 +++---
 fs/fuse/file.c                             |  3 ++-
 fs/gfs2/aops.c                             |  6 +++---
 fs/hfs/inode.c                             |  7 +++----
 fs/hfsplus/inode.c                         |  7 +++----
 fs/jfs/inode.c                             |  7 +++----
 fs/nfs/direct.c                            | 17 +++++++----------
 fs/nfs/file.c                              |  2 +-
 fs/nilfs2/inode.c                          |  4 ++--
 fs/ocfs2/aops.c                            |  9 ++++-----
 fs/reiserfs/inode.c                        |  7 +++----
 fs/udf/file.c                              |  3 +--
 fs/udf/inode.c                             |  7 +++----
 fs/xfs/xfs_aops.c                          |  7 +++----
 fs/xfs/xfs_file.c                          |  2 +-
 include/linux/dax.h                        |  2 +-
 include/linux/fs.h                         |  9 ++++-----
 include/linux/nfs_fs.h                     |  5 ++---
 mm/filemap.c                               |  5 ++---
 mm/page_io.c                               |  2 +-
 37 files changed, 99 insertions(+), 112 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 619af9b..75eea7c 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -194,7 +194,7 @@ prototypes:
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	int (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
+	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
 	int (*launder_page)(struct page *);
 	int (*is_partially_uptodate)(struct page *, unsigned long, unsigned long);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index b02a7d5..6c28a5e 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -591,7 +591,7 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
+	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
 	int (*launder_page) (struct page *);
diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 7a5db67..12b59b9 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -358,14 +358,14 @@ static ssize_t ll_direct_IO_26_seg(const struct lu_env *env, struct cl_io *io,
  */
 #define MAX_DIO_SIZE ((KMALLOC_MAX_SIZE / sizeof(struct brw_page) *	  \
 		       PAGE_CACHE_SIZE) & ~(DT_MAX_BRW_SIZE - 1))
-static ssize_t ll_direct_IO_26(struct kiocb *iocb, struct iov_iter *iter,
-			       loff_t file_offset)
+static ssize_t ll_direct_IO_26(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct lu_env *env;
 	struct cl_io *io;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct ccc_object *obj = cl_inode2ccc(inode);
+	loff_t file_offset = iocb->ki_pos;
 	ssize_t count = iov_iter_count(iter);
 	ssize_t tot_bytes = 0, result = 0;
 	struct ll_inode_info *lli = ll_i2info(inode);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index e9e0437..f6c8a24 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -245,9 +245,10 @@ static int v9fs_launder_page(struct page *page)
  *
  */
 static ssize_t
-v9fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
+v9fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
+	loff_t pos = iocb->ki_pos;
 	ssize_t n;
 	int err = 0;
 	if (iov_iter_rw(iter) == WRITE) {
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 22fc7c8..2e3258d 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -389,12 +389,13 @@ static void affs_write_failed(struct address_space *mapping, loff_t to)
 }
 
 static ssize_t
-affs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
+affs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
+	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
 	if (iov_iter_rw(iter) == WRITE) {
@@ -404,7 +405,7 @@ affs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 			return 0;
 	}
 
-	ret = blockdev_direct_IO(iocb, inode, iter, offset, affs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, affs_get_block);
 	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		affs_write_failed(mapping, offset + count);
 	return ret;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3172c4e..2a2402d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -162,15 +162,15 @@ static struct inode *bdev_file_inode(struct file *file)
 }
 
 static ssize_t
-blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
+blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = bdev_file_inode(file);
 
 	if (IS_DAX(inode))
-		return dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
+		return dax_do_io(iocb, inode, iter, blkdev_get_block,
 				NULL, DIO_SKIP_DIO_COUNT);
-	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
+	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter,
 				    blkdev_get_block, NULL, NULL,
 				    DIO_SKIP_DIO_COUNT);
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 41a5688..526d248 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8541,13 +8541,13 @@ out:
 	return retval;
 }
 
-static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			       loff_t offset)
+static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_dio_data dio_data = { 0 };
+	loff_t offset = iocb->ki_pos;
 	size_t count = 0;
 	int flags = 0;
 	bool wakeup = true;
@@ -8607,7 +8607,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 	ret = __blockdev_direct_IO(iocb, inode,
 				   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-				   iter, offset, btrfs_get_blocks_direct, NULL,
+				   iter, btrfs_get_blocks_direct, NULL,
 				   btrfs_submit_direct, flags);
 	if (iov_iter_rw(iter) == WRITE) {
 		current->journal_info = NULL;
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index fc5cae2..dac4296 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1292,8 +1292,7 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
  * intercept O_DIRECT reads and writes early, this function should
  * never get called.
  */
-static ssize_t ceph_direct_io(struct kiocb *iocb, struct iov_iter *iter,
-			      loff_t pos)
+static ssize_t ceph_direct_io(struct kiocb *iocb, struct iov_iter *iter)
 {
 	WARN_ON(1);
 	return -EINVAL;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ff882ae..27c0762 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3854,7 +3854,7 @@ void cifs_oplock_break(struct work_struct *work)
  * Direct IO is not yet supported in the cached mode. 
  */
 static ssize_t
-cifs_direct_io(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
+cifs_direct_io(struct kiocb *iocb, struct iov_iter *iter)
 {
         /*
          * FIXME
diff --git a/fs/dax.c b/fs/dax.c
index 90322eb..daa0465 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -244,7 +244,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
  * @iocb: The control block for this I/O
  * @inode: The file which the I/O is directed at
  * @iter: The addresses to do I/O from or to
- * @pos: The file offset where the I/O starts
  * @get_block: The filesystem method used to translate file offsets to blocks
  * @end_io: A filesystem callback for I/O completion
  * @flags: See below
@@ -257,11 +256,12 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
  * is in progress.
  */
 ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
-		  struct iov_iter *iter, loff_t pos, get_block_t get_block,
+		  struct iov_iter *iter, get_block_t get_block,
 		  dio_iodone_t end_io, int flags)
 {
 	struct buffer_head bh;
 	ssize_t retval = -EINVAL;
+	loff_t pos = iocb->ki_pos;
 	loff_t end = pos + iov_iter_count(iter);
 
 	memset(&bh, 0, sizeof(bh));
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 476f1ec..8122ff9 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1113,7 +1113,7 @@ static inline int drop_refcount(struct dio *dio)
 static inline ssize_t
 do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 		      struct block_device *bdev, struct iov_iter *iter,
-		      loff_t offset, get_block_t get_block, dio_iodone_t end_io,
+		      get_block_t get_block, dio_iodone_t end_io,
 		      dio_submit_t submit_io, int flags)
 {
 	unsigned i_blkbits = ACCESS_ONCE(inode->i_blkbits);
@@ -1121,6 +1121,7 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	unsigned blocksize_mask = (1 << blkbits) - 1;
 	ssize_t retval = -EINVAL;
 	size_t count = iov_iter_count(iter);
+	loff_t offset = iocb->ki_pos;
 	loff_t end = offset + count;
 	struct dio *dio;
 	struct dio_submit sdio = { 0, };
@@ -1328,7 +1329,7 @@ out:
 
 ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 			     struct block_device *bdev, struct iov_iter *iter,
-			     loff_t offset, get_block_t get_block,
+			     get_block_t get_block,
 			     dio_iodone_t end_io, dio_submit_t submit_io,
 			     int flags)
 {
@@ -1344,7 +1345,7 @@ ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
-	return do_blockdev_direct_IO(iocb, inode, bdev, iter, offset, get_block,
+	return do_blockdev_direct_IO(iocb, inode, bdev, iter, get_block,
 				     end_io, submit_io, flags);
 }
 
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 9eaf595..5d63fb8 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -960,8 +960,7 @@ static void exofs_invalidatepage(struct page *page, unsigned int offset,
 
 
  /* TODO: Should be easy enough to do proprly */
-static ssize_t exofs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			       loff_t offset)
+static ssize_t exofs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	return 0;
 }
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6bd58e6..b675610 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -854,20 +854,20 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t
-ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
+ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
+	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
 	if (IS_DAX(inode))
-		ret = dax_do_io(iocb, inode, iter, offset, ext2_get_block, NULL,
+		ret = dax_do_io(iocb, inode, iter, ext2_get_block, NULL,
 				DIO_LOCKING);
 	else
-		ret = blockdev_direct_IO(iocb, inode, iter, offset,
-					 ext2_get_block);
+		ret = blockdev_direct_IO(iocb, inode, iter, ext2_get_block);
 	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		ext2_write_failed(mapping, offset + count);
 	return ret;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c047435..d9e5f4e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2556,8 +2556,7 @@ extern int ext4_get_next_extent(struct inode *inode, ext4_lblk_t lblk,
 /* indirect.c */
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				struct ext4_map_blocks *map, int flags);
-extern ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-				  loff_t offset);
+extern ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter);
 extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
 extern void ext4_ind_truncate(handle_t *, struct inode *inode);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 3027fa6..627b7e8 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -659,12 +659,12 @@ out:
  * crashes then stale disk data _may_ be exposed inside the file. But current
  * VFS code falls back into buffered path in that case so we are safe.
  */
-ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			   loff_t offset)
+ssize_t ext4_ind_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
+	loff_t offset = iocb->ki_pos;
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
@@ -707,21 +707,21 @@ retry:
 			goto locked;
 		}
 		if (IS_DAX(inode))
-			ret = dax_do_io(iocb, inode, iter, offset,
+			ret = dax_do_io(iocb, inode, iter,
 					ext4_dio_get_block, NULL, 0);
 		else
 			ret = __blockdev_direct_IO(iocb, inode,
 						   inode->i_sb->s_bdev, iter,
-						   offset, ext4_dio_get_block,
+						   ext4_dio_get_block,
 						   NULL, NULL, 0);
 		inode_dio_end(inode);
 	} else {
 locked:
 		if (IS_DAX(inode))
-			ret = dax_do_io(iocb, inode, iter, offset,
+			ret = dax_do_io(iocb, inode, iter,
 					ext4_dio_get_block, NULL, DIO_LOCKING);
 		else
-			ret = blockdev_direct_IO(iocb, inode, iter, offset,
+			ret = blockdev_direct_IO(iocb, inode, iter,
 						 ext4_dio_get_block);
 
 		if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dab84a2..df01b84 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3336,12 +3336,12 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
  * if the machine crashes during the write.
  *
  */
-static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-				  loff_t offset)
+static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
+	loff_t offset = iocb->ki_pos;
 	size_t count = iov_iter_count(iter);
 	int overwrite = 0;
 	get_block_t *get_block_func = NULL;
@@ -3350,7 +3350,7 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 	/* Use the old path for reads and writes beyond i_size. */
 	if (iov_iter_rw(iter) != WRITE || final_size > inode->i_size)
-		return ext4_ind_direct_IO(iocb, iter, offset);
+		return ext4_ind_direct_IO(iocb, iter);
 
 	BUG_ON(iocb->private == NULL);
 
@@ -3402,11 +3402,11 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
 #endif
 	if (IS_DAX(inode))
-		ret = dax_do_io(iocb, inode, iter, offset, get_block_func,
+		ret = dax_do_io(iocb, inode, iter, get_block_func,
 				ext4_end_io_dio, dio_flags);
 	else
 		ret = __blockdev_direct_IO(iocb, inode,
-					   inode->i_sb->s_bdev, iter, offset,
+					   inode->i_sb->s_bdev, iter,
 					   get_block_func,
 					   ext4_end_io_dio, NULL, dio_flags);
 
@@ -3433,12 +3433,12 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	return ret;
 }
 
-static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			      loff_t offset)
+static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	size_t count = iov_iter_count(iter);
+	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
@@ -3458,9 +3458,9 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 	trace_ext4_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		ret = ext4_ext_direct_IO(iocb, iter, offset);
+		ret = ext4_ext_direct_IO(iocb, iter);
 	else
-		ret = ext4_ind_direct_IO(iocb, iter, offset);
+		ret = ext4_ind_direct_IO(iocb, iter);
 	trace_ext4_direct_IO_exit(inode, offset, count, iov_iter_rw(iter), ret);
 	return ret;
 }
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index e5c762b..3bcfe2d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1655,12 +1655,12 @@ static int check_direct_IO(struct inode *inode, struct iov_iter *iter,
 	return 0;
 }
 
-static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			      loff_t offset)
+static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
+	loff_t offset = iocb->ki_pos;
 	int err;
 
 	err = check_direct_IO(inode, iter, offset);
@@ -1672,7 +1672,7 @@ static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 
 	trace_f2fs_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
 
-	err = blockdev_direct_IO(iocb, inode, iter, offset, get_data_block_dio);
+	err = blockdev_direct_IO(iocb, inode, iter, get_data_block_dio);
 	if (err < 0 && iov_iter_rw(iter) == WRITE)
 		f2fs_write_failed(mapping, offset + count);
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 2262810..3bcf579 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -244,13 +244,13 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 	return err;
 }
 
-static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			     loff_t offset)
+static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
+	loff_t offset = iocb->ki_pos;
 	ssize_t ret;
 
 	if (iov_iter_rw(iter) == WRITE) {
@@ -272,7 +272,7 @@ static ssize_t fat_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	ret = blockdev_direct_IO(iocb, inode, iter, offset, fat_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, fat_get_block);
 	if (ret < 0 && iov_iter_rw(iter) == WRITE)
 		fat_write_failed(mapping, offset + count);
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 8e05139..a8d884a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2837,7 +2837,7 @@ static inline loff_t fuse_round_up(loff_t off)
 }
 
 static ssize_t
-fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
+fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	ssize_t ret = 0;
@@ -2848,6 +2848,7 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 	struct inode *inode;
 	loff_t i_size;
 	size_t count = iov_iter_count(iter);
+	loff_t offset = iocb->ki_pos;
 	struct fuse_io_priv *io;
 	bool is_sync = is_sync_kiocb(iocb);
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index aa016e4..1e5881c 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1042,13 +1042,13 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, loff_t offset)
 
 
 
-static ssize_t gfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			      loff_t offset)
+static ssize_t gfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct address_space *mapping = inode->i_mapping;
 	struct gfs2_inode *ip = GFS2_I(inode);
+	loff_t offset = iocb->ki_pos;
 	struct gfs2_holder gh;
 	int rv;
 
@@ -1099,7 +1099,7 @@ static ssize_t gfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	}
 
 	rv = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
-				  offset, gfs2_get_block_direct, NULL, NULL, 0);
+				  gfs2_get_block_direct, NULL, NULL, 0);
 out:
 	gfs2_glock_dq(&gh);
 	gfs2_holder_uninit(&gh);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 6686bf3..4810a97 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -124,8 +124,7 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
-static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			     loff_t offset)
+static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -133,7 +132,7 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, offset, hfs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -141,7 +140,7 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	 */
 	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + count;
+		loff_t end = iocb->ki_pos + count;
 
 		if (end > isize)
 			hfs_write_failed(mapping, end);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 1a6394c..a84d191 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -122,8 +122,7 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 	return res ? try_to_free_buffers(page) : 0;
 }
 
-static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-				 loff_t offset)
+static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -131,7 +130,7 @@ static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, offset, hfsplus_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, hfsplus_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -139,7 +138,7 @@ static ssize_t hfsplus_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	 */
 	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + count;
+		loff_t end = iocb->ki_pos + count;
 
 		if (end > isize)
 			hfsplus_write_failed(mapping, end);
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 9d9bae6..f6a2a78 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -332,8 +332,7 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, jfs_get_block);
 }
 
-static ssize_t jfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			     loff_t offset)
+static ssize_t jfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -341,7 +340,7 @@ static ssize_t jfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, offset, jfs_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, jfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -349,7 +348,7 @@ static ssize_t jfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	 */
 	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + count;
+		loff_t end = iocb->ki_pos + count;
 
 		if (end > isize)
 			jfs_write_failed(mapping, end);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 7a0cfd3..17eff9c 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -250,7 +250,7 @@ static int nfs_direct_cmp_commit_data_verf(struct nfs_direct_req *dreq,
  * shunt off direct read and write requests before the VFS gets them,
  * so this method is only ever called for swap.
  */
-ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
+ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 
@@ -261,7 +261,7 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
 
 	if (iov_iter_rw(iter) == READ)
-		return nfs_file_direct_read(iocb, iter, pos);
+		return nfs_file_direct_read(iocb, iter);
 	return nfs_file_direct_write(iocb, iter);
 }
 
@@ -545,7 +545,6 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_read - file direct read operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers into which to read data
- * @pos: byte offset in file where reading starts
  *
  * We use this function for direct reads instead of calling
  * generic_file_aio_read() in order to avoid gfar's check to see if
@@ -561,8 +560,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * client must read the updated atime from the server back into its
  * cache.
  */
-ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
-				loff_t pos)
+ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -574,7 +572,7 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
 	nfs_add_stats(mapping->host, NFSIOS_DIRECTREADBYTES, count);
 
 	dfprintk(FILE, "NFS: direct read(%pD2, %zd@%Ld)\n",
-		file, count, (long long) pos);
+		file, count, (long long) iocb->ki_pos);
 
 	result = 0;
 	if (!count)
@@ -594,7 +592,7 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
 
 	dreq->inode = inode;
 	dreq->bytes_left = count;
-	dreq->io_start = pos;
+	dreq->io_start = iocb->ki_pos;
 	dreq->ctx = get_nfs_open_context(nfs_file_open_context(iocb->ki_filp));
 	l_ctx = nfs_get_lock_context(dreq->ctx);
 	if (IS_ERR(l_ctx)) {
@@ -606,14 +604,14 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
 		dreq->iocb = iocb;
 
 	NFS_I(inode)->read_io += count;
-	result = nfs_direct_read_schedule_iovec(dreq, iter, pos);
+	result = nfs_direct_read_schedule_iovec(dreq, iter, iocb->ki_pos);
 
 	inode_unlock(inode);
 
 	if (!result) {
 		result = nfs_direct_wait(dreq);
 		if (result > 0)
-			iocb->ki_pos = pos + result;
+			iocb->ki_pos += result;
 	}
 
 	nfs_direct_req_release(dreq);
@@ -969,7 +967,6 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_write - file direct write operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers from which to write data
- * @pos: byte offset in file where writing starts
  *
  * We use this function for direct writes instead of calling
  * generic_file_aio_write() in order to avoid taking the inode
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 89bf093..431a95a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -164,7 +164,7 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t result;
 
 	if (iocb->ki_flags & IOCB_DIRECT)
-		return nfs_file_direct_read(iocb, to, iocb->ki_pos);
+		return nfs_file_direct_read(iocb, to);
 
 	dprintk("NFS: read(%pD2, %zu@%lu)\n",
 		iocb->ki_filp,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 21a1e2e..39aeba8 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -305,7 +305,7 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t
-nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
+nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 
@@ -313,7 +313,7 @@ nilfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	return blockdev_direct_IO(iocb, inode, iter, offset, nilfs_get_block);
+	return blockdev_direct_IO(iocb, inode, iter, nilfs_get_block);
 }
 
 const struct address_space_operations nilfs_aops = {
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1581240..a3022da 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2423,13 +2423,11 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 	return 0;
 }
 
-static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			       loff_t offset)
+static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file)->i_mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	loff_t end = offset + iter->count;
 	get_block_t *get_block;
 
 	/*
@@ -2440,7 +2438,8 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		return 0;
 
 	/* Fallback to buffered I/O if we do not support append dio. */
-	if (end > i_size_read(inode) && !ocfs2_supports_append_dio(osb))
+	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
+	    !ocfs2_supports_append_dio(osb))
 		return 0;
 
 	if (iov_iter_rw(iter) == READ)
@@ -2449,7 +2448,7 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		get_block = ocfs2_dio_get_block;
 
 	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-				    iter, offset, get_block,
+				    iter, get_block,
 				    ocfs2_dio_end_io, NULL, 0);
 }
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ae9e5b3..b4bb9e5 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3279,15 +3279,14 @@ static int reiserfs_releasepage(struct page *page, gfp_t unused_gfp_flags)
  * We thank Mingming Cao for helping us understand in great detail what
  * to do in this section of the code.
  */
-static ssize_t reiserfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-				  loff_t offset)
+static ssize_t reiserfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, offset,
+	ret = blockdev_direct_IO(iocb, inode, iter,
 				 reiserfs_get_blocks_direct_io);
 
 	/*
@@ -3296,7 +3295,7 @@ static ssize_t reiserfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	 */
 	if (unlikely(iov_iter_rw(iter) == WRITE && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + count;
+		loff_t end = iocb->ki_pos + count;
 
 		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
 			truncate_setsize(inode, isize);
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 1af9896..d13b536 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -99,8 +99,7 @@ static int udf_adinicb_write_begin(struct file *file,
 	return 0;
 }
 
-static ssize_t udf_adinicb_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-				     loff_t offset)
+static ssize_t udf_adinicb_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	/* Fallback to buffered I/O. */
 	return 0;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 166d3ed..890f748 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -214,8 +214,7 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
-static ssize_t udf_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
-			     loff_t offset)
+static ssize_t udf_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -223,9 +222,9 @@ static ssize_t udf_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(iocb, inode, iter, offset, udf_get_block);
+	ret = blockdev_direct_IO(iocb, inode, iter, udf_get_block);
 	if (unlikely(ret < 0 && iov_iter_rw(iter) == WRITE))
-		udf_write_failed(mapping, offset + count);
+		udf_write_failed(mapping, iocb->ki_pos + count);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d445a64..60e4924 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1406,8 +1406,7 @@ xfs_end_io_direct_write(
 STATIC ssize_t
 xfs_vm_direct_IO(
 	struct kiocb		*iocb,
-	struct iov_iter		*iter,
-	loff_t			offset)
+	struct iov_iter		*iter)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	dio_iodone_t		*endio = NULL;
@@ -1420,12 +1419,12 @@ xfs_vm_direct_IO(
 	}
 
 	if (IS_DAX(inode)) {
-		return dax_do_io(iocb, inode, iter, offset,
+		return dax_do_io(iocb, inode, iter,
 				 xfs_get_blocks_direct, endio, 0);
 	}
 
 	bdev = xfs_find_bdev_for_inode(inode);
-	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
+	return  __blockdev_direct_IO(iocb, inode, bdev, iter,
 			xfs_get_blocks_direct, endio, NULL, flags);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4f214a7..06792c9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -794,7 +794,7 @@ xfs_file_dio_aio_write(
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
 
 	data = *from;
-	ret = mapping->a_ops->direct_IO(iocb, &data, iocb->ki_pos);
+	ret = mapping->a_ops->direct_IO(iocb, &data);
 
 	/* see generic_file_direct_write() for why this is necessary */
 	if (mapping->nrpages) {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 636dd59..982a6c4 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -5,7 +5,7 @@
 #include <linux/mm.h>
 #include <asm/pgtable.h>
 
-ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
+ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *,
 		  get_block_t, dio_iodone_t, int flags);
 int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0538bc4..8656f5c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -394,7 +394,7 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, gfp_t);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter, loff_t offset);
+	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 	/*
 	 * migrate the contents of a page to the specified target. If
 	 * migrate_mode is MIGRATE_ASYNC, it must not block.
@@ -2756,18 +2756,17 @@ void dio_end_io(struct bio *bio, int error);
 
 ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 			     struct block_device *bdev, struct iov_iter *iter,
-			     loff_t offset, get_block_t get_block,
+			     get_block_t get_block,
 			     dio_iodone_t end_io, dio_submit_t submit_io,
 			     int flags);
 
 static inline ssize_t blockdev_direct_IO(struct kiocb *iocb,
 					 struct inode *inode,
-					 struct iov_iter *iter, loff_t offset,
+					 struct iov_iter *iter,
 					 get_block_t get_block)
 {
 	return __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
-				    offset, get_block, NULL, NULL,
-				    DIO_LOCKING | DIO_SKIP_HOLES);
+			get_block, NULL, NULL, DIO_LOCKING | DIO_SKIP_HOLES);
 }
 #endif
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 67300f8..cede8f6 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -445,10 +445,9 @@ static inline struct rpc_cred *nfs_file_cred(struct file *file)
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(struct kiocb *, struct iov_iter *, loff_t);
+extern ssize_t nfs_direct_IO(struct kiocb *, struct iov_iter *);
 extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
-			struct iov_iter *iter,
-			loff_t pos);
+			struct iov_iter *iter);
 extern ssize_t nfs_file_direct_write(struct kiocb *iocb,
 			struct iov_iter *iter);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 4cca8c6..4e007c0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1853,8 +1853,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 					iocb->ki_pos + count - 1);
 		if (!retval) {
 			struct iov_iter data = *iter;
-			retval = mapping->a_ops->direct_IO(iocb, &data,
-					iocb->ki_pos);
+			retval = mapping->a_ops->direct_IO(iocb, &data);
 		}
 
 		if (retval > 0) {
@@ -2538,7 +2537,7 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	data = *from;
-	written = mapping->a_ops->direct_IO(iocb, &data, pos);
+	written = mapping->a_ops->direct_IO(iocb, &data);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
diff --git a/mm/page_io.c b/mm/page_io.c
index 18aac78..673d880 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -279,7 +279,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 
 		set_page_writeback(page);
 		unlock_page(page);
-		ret = mapping->a_ops->direct_IO(&kiocb, &from, kiocb.ki_pos);
+		ret = mapping->a_ops->direct_IO(&kiocb, &from);
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
-- 
2.1.4

