From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] aio: remove the extra get_file/fput pair in io_submit_one
Date: Sun, 15 Apr 2018 17:01:05 +0200
Message-ID: <20180415150108.1341-5-hch@lst.de>
References: <20180415150108.1341-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180415150108.1341-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

If we release the lockdep write protection token before calling into
->write_iter and thus never access the file pointer after an -EIOCBQUEUED
return from ->write_iter or ->read_iter we don't need this extra
reference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 18507743757a..d7be32cdd1db 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1515,16 +1515,17 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
 		return ret;
 	ret = rw_verify_area(WRITE, file, &req->ki_pos, iov_iter_count(&iter));
 	if (!ret) {
-		req->ki_flags |= IOCB_WRITE;
-		file_start_write(file);
-		ret = aio_ret(req, call_write_iter(file, req, &iter));
 		/*
 		 * We release freeze protection in aio_complete().  Fool lockdep
 		 * by telling it the lock got released so that it doesn't
 		 * complain about held lock when we return to userspace.
 		 */
-		if (S_ISREG(file_inode(file)->i_mode))
+		if (S_ISREG(file_inode(file)->i_mode)) {
+			__sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, true);
 			__sb_writers_release(file_inode(file)->i_sb, SB_FREEZE_WRITE);
+		}
+		req->ki_flags |= IOCB_WRITE;
+		ret = aio_ret(req, call_write_iter(file, req, &iter));
 	}
 	kfree(iovec);
 	return ret;
@@ -1599,7 +1600,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_user_iocb = user_iocb;
 	req->ki_user_data = iocb->aio_data;
 
-	get_file(file);
 	switch (iocb->aio_lio_opcode) {
 	case IOCB_CMD_PREAD:
 		ret = aio_read(&req->common, iocb, false, compat);
@@ -1618,7 +1618,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		ret = -EINVAL;
 		break;
 	}
-	fput(file);
 
 	if (ret && ret != -EIOCBQUEUED)
 		goto out_put_req;
-- 
2.17.0
