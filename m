From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] aio: implement IOCB_CMD_FSYNC and IOCB_CMD_FDSYNC
Date: Wed,  2 May 2018 23:14:47 +0200
Message-ID: <20180502211448.18276-7-hch@lst.de>
References: <20180502211448.18276-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502211448.18276-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Simple workqueue offload for now, but prepared for adding a real aio_fsync
method if the need arises.  Based on an earlier patch from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/aio.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index d07c27b3fe88..61d2e6942951 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -156,6 +156,12 @@ struct kioctx {
 	unsigned		id;
 };
 
+struct fsync_iocb {
+	struct work_struct	work;
+	struct file		*file;
+	bool			datasync;
+};
+
 /*
  * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
  * cancelled or completed (this makes a certain amount of sense because
@@ -172,6 +178,7 @@ struct kioctx {
 struct aio_kiocb {
 	union {
 		struct kiocb		rw;
+		struct fsync_iocb	fsync;
 	};
 
 	struct kioctx		*ki_ctx;
@@ -1573,6 +1580,36 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
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
+	if (unlikely(iocb->aio_buf || iocb->aio_offset || iocb->aio_nbytes ||
+			iocb->aio_rw_flags))
+		return -EINVAL;
+
+	req->file = fget(iocb->aio_fildes);
+	if (unlikely(!req->file))
+		return -EBADF;
+	if (unlikely(!req->file->f_op->fsync)) {
+		fput(req->file);
+		return -EINVAL;
+	}
+
+	req->datasync = datasync;
+	INIT_WORK(&req->work, aio_fsync_work);
+	schedule_work(&req->work);
+	return -EIOCBQUEUED;
+}
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
@@ -1636,6 +1673,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
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
2.17.0
