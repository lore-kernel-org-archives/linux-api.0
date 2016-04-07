From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10] xfs: eliminate the pos variable in xfs_file_dio_aio_write
Date: Thu,  7 Apr 2016 08:51:57 -0700
Message-ID: <1460044324-5298-4-git-send-email-hch@lst.de>
References: <1460044324-5298-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1460044324-5298-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 569938a..92f72fb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -718,18 +718,19 @@ xfs_file_dio_aio_write(
 	int			unaligned_io = 0;
 	int			iolock;
 	size_t			count = iov_iter_count(from);
-	loff_t			pos = iocb->ki_pos;
 	loff_t			end;
 	struct iov_iter		data;
 	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
 	/* DIO must be aligned to device logical sector size */
-	if (!IS_DAX(inode) && ((pos | count) & target->bt_logical_sectormask))
+	if (!IS_DAX(inode) &&
+	    ((iocb->ki_pos | count) & target->bt_logical_sectormask))
 		return -EINVAL;
 
 	/* "unaligned" here means not aligned to a filesystem block */
-	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
+	if ((iocb->ki_pos & mp->m_blockmask) ||
+	    ((iocb->ki_pos + count) & mp->m_blockmask))
 		unaligned_io = 1;
 
 	/*
@@ -760,8 +761,7 @@ xfs_file_dio_aio_write(
 	if (ret)
 		goto out;
 	count = iov_iter_count(from);
-	pos = iocb->ki_pos;
-	end = pos + count - 1;
+	end = iocb->ki_pos + count - 1;
 
 	/*
 	 * See xfs_file_read_iter() for why we do a full-file flush here.
@@ -794,19 +794,18 @@ xfs_file_dio_aio_write(
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
 
 	data = *from;
-	ret = mapping->a_ops->direct_IO(iocb, &data, pos);
+	ret = mapping->a_ops->direct_IO(iocb, &data, iocb->ki_pos);
 
 	/* see generic_file_direct_write() for why this is necessary */
 	if (mapping->nrpages) {
 		invalidate_inode_pages2_range(mapping,
-					      pos >> PAGE_SHIFT,
+					      iocb->ki_pos >> PAGE_SHIFT,
 					      end >> PAGE_SHIFT);
 	}
 
 	if (ret > 0) {
-		pos += ret;
+		iocb->ki_pos += ret;
 		iov_iter_advance(from, ret);
-		iocb->ki_pos = pos;
 	}
 out:
 	xfs_rw_iunlock(ip, iolock);
-- 
2.1.4

