From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aio: resurrect IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC support
Date: Wed, 17 Jan 2018 20:47:47 +0100
Message-ID: <20180117194747.1631-2-hch@lst.de>
References: <20180117194747.1631-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180117194747.1631-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

These and the ->aio_fsync method had been merged together with the
initial aio support, but no ->aio_fsync method had ever been implemented
in mainline, so it got removed a while ago.

This patch wires up the iocb commands to a simple workqueue based offload
that already shows great performance.  In the future an aio_fsync method
could be added if we grow more elaborate implementations, but for now
an 6 to 8 fold improvement in the fsync rate in fs_mark should be good
enough to go with this simple version.

Note that this does not wire up the offset and length fields and thus
does not provide a ranged fsync.  The reasons for that are that in
all current file system ranges only matter for writing back page cache,
which doesn't mix with AIO anyway (as AIO only does direct I/O), and
also because these fields would bloat the aio_kiocb over the size of
the normal read/write and poll iocbs, which is worth it given the
condition above.  But the offset and length fields are checked for
being zero, so such a support could be added later if needed.

Based on an earlier patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 0cddd24e7316..e1df7e8408ea 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -164,10 +164,17 @@ struct poll_iocb {
 	struct wait_queue_entry	wait;
 };
 
+struct fsync_iocb {
+	struct work_struct	work;
+	struct file		*file;
+	bool			datasync;
+};
+
 struct aio_kiocb {
 	union {
 		struct kiocb		rw;
 		struct poll_iocb	poll;
+		struct fsync_iocb	fsync;
 	};
 
 	struct kioctx		*ki_ctx;
@@ -1660,6 +1667,61 @@ static ssize_t aio_poll(struct aio_kiocb *aiocb, struct iocb *iocb)
 	return -EIOCBQUEUED;
 }
 
+static void aio_fsync_work(struct work_struct *work)
+{
+	struct fsync_iocb *req = container_of(work, struct fsync_iocb, work);
+	int ret;
+
+	ret = vfs_fsync(req->file, req->datasync);
+	fput(req->file);
+	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
+}
+
+static int generic_aio_fsync(struct fsync_iocb *req)
+{
+	struct super_block *sb = file_inode(req->file)->i_sb;
+
+	if (unlikely(!sb->s_dio_done_wq)) {
+		int ret = sb_init_dio_done_wq(sb);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Use the direct I/O completion workqueue, as that is used to queue
+	 * fsyncs for O_(D)SYNC writes already.
+	 */
+	INIT_WORK(&req->work, aio_fsync_work);
+	queue_work(sb->s_dio_done_wq, &req->work);
+	return -EIOCBQUEUED;
+}
+
+static int aio_fsync(struct fsync_iocb *req, struct iocb *iocb, bool datasync)
+{
+	int ret;
+
+	if (iocb->aio_buf)
+		return -EINVAL;
+	if (iocb->aio_offset || iocb->aio_nbytes || iocb->aio_rw_flags)
+		return -EINVAL;
+
+	req->file = fget(iocb->aio_fildes);
+	if (unlikely(!req->file))
+		return -EBADF;
+
+	ret = -EINVAL;
+	if (!req->file->f_op->fsync)
+		goto out_fput;
+
+	req->datasync = datasync;
+
+	ret = generic_aio_fsync(req);
+out_fput:
+	if (unlikely(ret && ret != -EIOCBQUEUED))
+		fput(req->file);
+	return ret;
+}
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
@@ -1723,6 +1785,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	case IOCB_CMD_PWRITEV:
 		ret = aio_write(&req->rw, iocb, true, compat);
 		break;
+	case IOCB_CMD_FSYNC:
+		ret = aio_fsync(&req->fsync, iocb, false);
+		break;
+	case IOCB_CMD_FDSYNC:
+		ret = aio_fsync(&req->fsync, iocb, true);
+		break;
 	case IOCB_CMD_POLL:
 		ret = aio_poll(req, iocb);
 		break;
-- 
2.14.2
