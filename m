From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] aio: implement IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC
Date: Wed, 21 Mar 2018 08:32:32 +0100
Message-ID: <20180321073232.13366-10-hch@lst.de>
References: <20180321073232.13366-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180321073232.13366-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Simple workqueue offload for now, but prepared for adding a real aio_fsync
method if the need arises.  Based on an earlier patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index da87cbf7c67a..79d3eb3d2dd9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -156,9 +156,16 @@ struct kioctx {
 	unsigned		id;
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
+		struct fsync_iocb	fsync;
 	};
 
 	struct kioctx		*ki_ctx;
@@ -1565,6 +1572,43 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
 	return ret;
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
+	INIT_WORK(&req->work, aio_fsync_work);
+	schedule_work(&req->work);
+	return -EIOCBQUEUED;
+out_fput:
+	if (unlikely(ret && ret != -EIOCBQUEUED))
+		fput(req->file);
+	return ret;
+}
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
@@ -1628,6 +1672,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	case IOCB_CMD_PWRITEV:
 		ret = aio_write(&req->rw, iocb, true, compat);
 		break;
+	case IOCB_CMD_FSYNC:
+		ret = aio_fsync(&req->fsync, iocb, false);
+		break;
+	case IOCB_CMD_FDSYNC:
+		ret = aio_fsync(&req->fsync, iocb, true);
+		break;
 	default:
 		pr_debug("invalid aio operation %d\n", iocb->aio_lio_opcode);
 		ret = -EINVAL;
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
