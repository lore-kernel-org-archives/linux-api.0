From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 03/10] xfs: eliminate the pos variable in xfs_file_dio_aio_write
Date: Tue, 29 Mar 2016 19:37:27 +0200
Message-ID: <1459273054-13478-4-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/xfs_file.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ac0fd32..4f214a7 100644
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
-					      pos >> PAGE_CACHE_SHIFT,
+					      iocb->ki_pos >> PAGE_CACHE_SHIFT,
 					      end >> PAGE_CACHE_SHIFT);
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
