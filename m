From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] aio: remove the extra get_file/fput pair in io_submit_one
Date: Wed,  2 May 2018 23:14:45 +0200
Message-ID: <20180502211448.18276-5-hch@lst.de>
References: <20180502211448.18276-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502211448.18276-1-hch@lst.de>
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
 fs/aio.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 18507743757a..e5866e2fc331 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1515,16 +1515,19 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
 		return ret;
 	ret = rw_verify_area(WRITE, file, &req->ki_pos, iov_iter_count(&iter));
 	if (!ret) {
-		req->ki_flags |= IOCB_WRITE;
-		file_start_write(file);
-		ret = aio_ret(req, call_write_iter(file, req, &iter));
 		/*
-		 * We release freeze protection in aio_complete().  Fool lockdep
-		 * by telling it the lock got released so that it doesn't
-		 * complain about held lock when we return to userspace.
+		 * Open-code file_start_write here to grab freeze protection,
+		 * which will be released by another thread in aio_complete().
+		 * Fool lockdep by telling it the lock got released so that it
+		 * doesn't complain about the held lock when we return to
+		 * userspace.
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
@@ -1599,7 +1602,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_user_iocb = user_iocb;
 	req->ki_user_data = iocb->aio_data;
 
-	get_file(file);
 	switch (iocb->aio_lio_opcode) {
 	case IOCB_CMD_PREAD:
 		ret = aio_read(&req->common, iocb, false, compat);
@@ -1618,8 +1620,13 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		ret = -EINVAL;
 		break;
 	}
-	fput(file);
 
+	/*
+	 * If ret is -EIOCBQUEUED, ownership of the file reference acquired
+	 * above passed to the file system, which at this point might have
+	 * dropped the reference, so we must be careful to not reference it
+	 * once we have called into the file system.
+	 */
 	if (ret && ret != -EIOCBQUEUED)
 		goto out_put_req;
 	return 0;
-- 
2.17.0
