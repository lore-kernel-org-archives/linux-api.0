From: adam.manzanares@wdc.com
Subject: [PATCH v4 3/3] fs: Add aio iopriority support for block_dev
Date: Thu, 17 May 2018 13:38:03 -0700
Message-ID: <20180517203803.2664-4-adam.manzanares@wdc.com>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180517203803.2664-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org
Cc: mingo@kernel.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

This is the per-I/O equivalent of the ioprio_set system call.

When IOCB_FLAG_IOPRIO is set on the iocb aio_flags field, then we set the
newly added kiocb ki_ioprio field to the value in the iocb aio_reqprio field.

When a bio is created for an aio request by the block dev we set the priority
value of the bio to the user supplied value.

This patch depends on block: add ioprio_check_cap function

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 fs/aio.c                     | 16 ++++++++++++++++
 fs/block_dev.c               |  2 ++
 include/linux/fs.h           |  2 ++
 include/uapi/linux/aio_abi.h |  1 +
 4 files changed, 21 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index f3eae5d5771b..ff3107aa82d5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1451,6 +1451,22 @@ static int aio_prep_rw(struct kiocb *req, struct iocb *iocb)
 	if (iocb->aio_flags & IOCB_FLAG_RESFD)
 		req->ki_flags |= IOCB_EVENTFD;
 	req->ki_hint = file_write_hint(req->ki_filp);
+	if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
+		/*
+		 * If the IOCB_FLAG_IOPRIO flag of aio_flags is set, then
+		 * aio_reqprio is interpreted as an I/O scheduling
+		 * class and priority.
+		 */
+		ret = ioprio_check_cap(iocb->aio_reqprio);
+		if (ret) {
+			pr_debug("aio ioprio check cap error\n");
+			return -EINVAL;
+		}
+
+		req->ki_ioprio = iocb->aio_reqprio;
+		req->ki_flags |= IOCB_IOPRIO;
+	}
+
 	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
 	if (unlikely(ret))
 		fput(req->ki_filp);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7ec920e27065..970bef79caa6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -355,6 +355,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		bio->bi_write_hint = iocb->ki_hint;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
+		if (iocb->ki_flags & IOCB_IOPRIO)
+			bio->bi_ioprio = iocb->ki_ioprio;
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7a90ce387e00..3415e83f6350 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -294,6 +294,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_IOPRIO		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -302,6 +303,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_hint;
+	u16			ki_ioprio; /* See linux/ioprio.h */
 } __randomize_layout;
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index 2c0a3415beee..d4e768d55d14 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -55,6 +55,7 @@ enum {
  *                   is valid.
  */
 #define IOCB_FLAG_RESFD		(1 << 0)
+#define IOCB_FLAG_IOPRIO	(1 << 1)
 
 /* read() from /dev/aio returns these structures. */
 struct io_event {
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
