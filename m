From: adam.manzanares@wdc.com
Subject: [PATCH v2] fs: Add aio iopriority support for block_dev
Date: Thu,  3 May 2018 11:21:14 -0700
Message-ID: <20180503182114.2797-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

This is the per-I/O equivalent of the ioprio_set system call.

When IOCB_FLAG_IOPRIO is set on the iocb aio_flags field, then we set the
newly added kiocb ki_ioprio field to the value in the iocb aio_reqprio field.

When a bio is created for an aio request by the block dev we set the priority
value of the bio to the user supplied value.

See the following link for performance implications on a SATA HDD:
https://lkml.org/lkml/2016/12/6/495

Given that WRR support for NVME devices has patches floating around and it was
discussed at LSFMM, we may soon have a lower latency storage device that can 
make use of iopriorities. A per command iopriority interface seems timely 
given these developments. 

If we want to avoid bloating struct kiocb, I suggest we turn the private field 
into a union of the private and ki_ioprio field. It seems like the users of 
the private field all use it at a point where we can yank the priority from 
the kiocb before the private field is used. Comments and suggestions welcome.

v2: merge patches
    use IOCB_FLAG_IOPRIO
    validate intended use with IOCB_IOPRIO
    add linux-api and linux-block to cc

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 fs/aio.c                     | 10 ++++++++++
 fs/block_dev.c               |  2 ++
 include/linux/fs.h           |  2 ++
 include/uapi/linux/aio_abi.h |  1 +
 4 files changed, 15 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 88d7927ffbc6..f36636d8ff2c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1597,6 +1597,16 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		req->common.ki_flags |= IOCB_EVENTFD;
 	}
 
+	if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
+		/*
+		 * If the IOCB_FLAG_IOPRIO flag of aio_flags is set, then
+		 * aio_reqprio is interpreted as an I/O scheduling
+		 * class and priority.
+		 */
+		req->common.ki_ioprio = iocb->aio_reqprio;
+		req->common.ki_flags |= IOCB_IOPRIO;
+	}
+
 	ret = kiocb_set_rw_flags(&req->common, iocb->aio_rw_flags);
 	if (unlikely(ret)) {
 		pr_debug("EINVAL: aio_rw_flags\n");
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
index 760d8da1b6c7..ab63ce720305 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -292,6 +292,7 @@ enum rw_hint {
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_IOPRIO		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -300,6 +301,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	enum rw_hint		ki_hint;
+	u16			ki_ioprio; /* See linux/ioprio.h */
 } __randomize_layout;
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index a04adbc70ddf..d4593a6062ef 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -54,6 +54,7 @@ enum {
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
