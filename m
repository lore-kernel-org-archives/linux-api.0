From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 05/10] fs: return if direct write will trigger writeback
Date: Wed, 24 May 2017 11:41:45 -0500
Message-ID: <20170524164150.9492-6-rgoldwyn@suse.de>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170524164150.9492-1-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adam.manzanares-Sjgp3cTcYWE@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

Find out if the write will trigger a wait due to writeback. If yes,
return -EAGAIN.

Return -EINVAL for buffered AIO: there are multiple causes of
delay such as page locks, dirty throttling logic, page loading
from disk etc. which cannot be taken care of.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 mm/filemap.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 097213275461..bc146efa6815 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2675,6 +2675,9 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
 
 	pos = iocb->ki_pos;
 
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+		return -EINVAL;
+
 	if (limit != RLIM_INFINITY) {
 		if (iocb->ki_pos >= limit) {
 			send_sig(SIGXFSZ, current, 0);
@@ -2743,9 +2746,17 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	write_len = iov_iter_count(from);
 	end = (pos + write_len - 1) >> PAGE_SHIFT;
 
-	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
-	if (written)
-		goto out;
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* If there are pages to writeback, return */
+		if (filemap_range_has_page(inode->i_mapping, pos,
+					   pos + iov_iter_count(from)))
+			return -EAGAIN;
+	} else {
+		written = filemap_write_and_wait_range(mapping, pos,
+							pos + write_len - 1);
+		if (written)
+			goto out;
+	}
 
 	/*
 	 * After a write we want buffered reads to be sure to go to disk to get
-- 
2.12.0
