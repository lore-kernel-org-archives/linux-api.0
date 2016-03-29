From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/10] filemap: remove pos variables in generic_file_read_iter
Date: Tue, 29 Mar 2016 19:37:25 +0200
Message-ID: <1459273054-13478-2-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Just use ki_pos directly to make everyones life easier.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 mm/filemap.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a8c69c8..de05cf9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1838,8 +1838,6 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	ssize_t retval = 0;
-	loff_t *ppos = &iocb->ki_pos;
-	loff_t pos = *ppos;
 	size_t count = iov_iter_count(iter);
 
 	if (!count)
@@ -1851,15 +1849,16 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		loff_t size;
 
 		size = i_size_read(inode);
-		retval = filemap_write_and_wait_range(mapping, pos,
-					pos + count - 1);
+		retval = filemap_write_and_wait_range(mapping, iocb->ki_pos,
+					iocb->ki_pos + count - 1);
 		if (!retval) {
 			struct iov_iter data = *iter;
-			retval = mapping->a_ops->direct_IO(iocb, &data, pos);
+			retval = mapping->a_ops->direct_IO(iocb, &data,
+					iocb->ki_pos);
 		}
 
 		if (retval > 0) {
-			*ppos = pos + retval;
+			iocb->ki_pos += retval;
 			iov_iter_advance(iter, retval);
 		}
 
@@ -1872,14 +1871,14 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		 * the rest of the read.  Buffered reads will not work for
 		 * DAX files, so don't bother trying.
 		 */
-		if (retval < 0 || !iov_iter_count(iter) || *ppos >= size ||
+		if (retval < 0 || !iov_iter_count(iter) || iocb->ki_pos >= size ||
 		    IS_DAX(inode)) {
 			file_accessed(file);
 			goto out;
 		}
 	}
 
-	retval = do_generic_file_read(file, ppos, iter, retval);
+	retval = do_generic_file_read(file, &iocb->ki_pos, iter, retval);
 out:
 	return retval;
 }
-- 
2.1.4
