From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/10] filemap: remove the pos argument to generic_file_direct_write
Date: Tue, 29 Mar 2016 19:37:26 +0200
Message-ID: <1459273054-13478-3-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/btrfs/file.c    | 9 ++++-----
 fs/fuse/file.c     | 2 +-
 include/linux/fs.h | 2 +-
 mm/filemap.c       | 5 +++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15a09cb..424af7f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1703,18 +1703,17 @@ again:
 	return num_written ? num_written : ret;
 }
 
-static ssize_t __btrfs_direct_write(struct kiocb *iocb,
-				    struct iov_iter *from,
-				    loff_t pos)
+static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	loff_t pos = iocb->ki_pos;
 	ssize_t written;
 	ssize_t written_buffered;
 	loff_t endbyte;
 	int err;
 
-	written = generic_file_direct_write(iocb, from, pos);
+	written = generic_file_direct_write(iocb, from);
 
 	if (written < 0 || !iov_iter_count(from))
 		return written;
@@ -1832,7 +1831,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 		atomic_inc(&BTRFS_I(inode)->sync_writers);
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		num_written = __btrfs_direct_write(iocb, from, pos);
+		num_written = __btrfs_direct_write(iocb, from);
 	} else {
 		num_written = __btrfs_buffered_write(file, from, pos);
 		if (num_written > 0)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9dde38f..8e05139 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1186,7 +1186,7 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		loff_t pos = iocb->ki_pos;
-		written = generic_file_direct_write(iocb, from, pos);
+		written = generic_file_direct_write(iocb, from);
 		if (written < 0 || !iov_iter_count(from))
 			goto out;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 14a9719..0538bc4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2693,7 +2693,7 @@ extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *, loff_t);
+extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_perform_write(struct file *, struct iov_iter *, loff_t);
 
 ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos);
diff --git a/mm/filemap.c b/mm/filemap.c
index de05cf9..4cca8c6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2499,11 +2499,12 @@ int pagecache_write_end(struct file *file, struct address_space *mapping,
 EXPORT_SYMBOL(pagecache_write_end);
 
 ssize_t
-generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos)
+generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file	*file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode	*inode = mapping->host;
+	loff_t		pos = iocb->ki_pos;
 	ssize_t		written;
 	size_t		write_len;
 	pgoff_t		end;
@@ -2717,7 +2718,7 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		loff_t pos, endbyte;
 
-		written = generic_file_direct_write(iocb, from, iocb->ki_pos);
+		written = generic_file_direct_write(iocb, from);
 		/*
 		 * If the write stopped short of completing, fall back to
 		 * buffered writes.  Some filesystems do this for writes to
-- 
2.1.4
