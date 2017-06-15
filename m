From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 09/10] xfs: nowait aio support
Date: Thu, 15 Jun 2017 11:00:01 -0500
Message-ID: <20170615160002.17233-10-rgoldwyn@suse.de>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170615160002.17233-1-rgoldwyn@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

If IOCB_NOWAIT is set, bail if the i_rwsem is not lockable
immediately.

IF IOMAP_NOWAIT is set, return EAGAIN in xfs_file_iomap_begin
if it needs allocation either due to file extension, writing to a hole,
or COW or waiting for other DIOs to finish.

Return -EAGAIN if we don't have extent list in memory.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c  | 20 +++++++++++++++-----
 fs/xfs/xfs_iomap.c | 22 ++++++++++++++++++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5fb5a0958a14..e159eb381d9f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -541,8 +541,11 @@ xfs_file_dio_aio_write(
 		iolock = XFS_IOLOCK_SHARED;
 	}
 
-	xfs_ilock(ip, iolock);
-
+	if (!xfs_ilock_nowait(ip, iolock)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		xfs_ilock(ip, iolock);
+	}
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
@@ -553,9 +556,15 @@ xfs_file_dio_aio_write(
 	 * otherwise demote the lock if we had to take the exclusive lock
 	 * for other reasons in xfs_file_aio_write_checks.
 	 */
-	if (unaligned_io)
-		inode_dio_wait(inode);
-	else if (iolock == XFS_IOLOCK_EXCL) {
+	if (unaligned_io) {
+		/* If we are going to wait for other DIO to finish, bail */
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (atomic_read(&inode->i_dio_count))
+				return -EAGAIN;
+		} else {
+			inode_dio_wait(inode);
+		}
+	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
 		iolock = XFS_IOLOCK_SHARED;
 	}
@@ -892,6 +901,7 @@ xfs_file_open(
 		return -EFBIG;
 	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
 		return -EIO;
+	file->f_mode |= FMODE_AIO_NOWAIT;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 94e5bdf7304c..05dc87e8c1f5 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -995,6 +995,11 @@ xfs_file_iomap_begin(
 		lockmode = xfs_ilock_data_map_shared(ip);
 	}
 
+	if ((flags & IOMAP_NOWAIT) && !(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+		error = -EAGAIN;
+		goto out_unlock;
+	}
+
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 	if ((xfs_fsize_t)offset + length > mp->m_super->s_maxbytes)
 		length = mp->m_super->s_maxbytes - offset;
@@ -1016,6 +1021,15 @@ xfs_file_iomap_begin(
 
 	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
 		if (flags & IOMAP_DIRECT) {
+			/*
+			 * A reflinked inode will result in CoW alloc.
+			 * FIXME: It could still overwrite on unshared extents
+			 * and not need allocation.
+			 */
+			if (flags & IOMAP_NOWAIT) {
+				error = -EAGAIN;
+				goto out_unlock;
+			}
 			/* may drop and re-acquire the ilock */
 			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
 					&lockmode);
@@ -1033,6 +1047,14 @@ xfs_file_iomap_begin(
 
 	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
 		/*
+		 * If nowait is set bail since we are going to make
+		 * allocations.
+		 */
+		if (flags & IOMAP_NOWAIT) {
+			error = -EAGAIN;
+			goto out_unlock;
+		}
+		/*
 		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
 		 * pages to keep the chunks of work done where somewhat symmetric
 		 * with the work writeback does. This is a completely arbitrary
-- 
2.12.0
