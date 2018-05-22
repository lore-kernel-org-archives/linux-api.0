From: adam.manzanares@wdc.com
Subject: [PATCH v6 3/5] fs: Add aio iopriority support
Date: Tue, 22 May 2018 08:07:35 -0700
Message-ID: <20180522150737.9893-4-adam.manzanares@wdc.com>
References: <20180522150737.9893-1-adam.manzanares@wdc.com>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180522150737.9893-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org
Cc: tglx@linutronix.de, mingo@kernel.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, bigeasy@linutronix.de, jack@suse.cz, darrick.wong@oracle.com, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, hch@infradread.org, jmoyer@redhat.com, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

This is the per-I/O equivalent of the ioprio_set system call.

When IOCB_FLAG_IOPRIO is set on the iocb aio_flags field, then we set the
newly added kiocb ki_ioprio field to the value in the iocb aio_reqprio field.

This patch depends on block: add ioprio_check_cap function.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c         |  3 +++
 fs/aio.c                     | 16 ++++++++++++++++
 include/linux/fs.h           |  3 +++
 include/uapi/linux/aio_abi.h |  1 +
 4 files changed, 23 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5d4e31655d96..dd98dfd97f5e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -76,6 +76,8 @@
 #include <linux/miscdevice.h>
 #include <linux/falloc.h>
 #include <linux/uio.h>
+#include <linux/ioprio.h>
+
 #include "loop.h"
 
 #include <linux/uaccess.h>
@@ -559,6 +561,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_filp = file;
 	cmd->iocb.ki_complete = lo_rw_aio_complete;
 	cmd->iocb.ki_flags = IOCB_DIRECT;
+	cmd->iocb.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
 	if (cmd->css)
 		kthread_associate_blkcg(cmd->css);
 
diff --git a/fs/aio.c b/fs/aio.c
index 755d3f57bcc8..8225013f70f0 100644
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
+	} else
+		req->ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
+
 	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
 	if (unlikely(ret))
 		fput(req->ki_filp);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50de40dbbb85..73b749ed3ea1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -36,6 +36,7 @@
 #include <linux/delayed_call.h>
 #include <linux/uuid.h>
 #include <linux/errseq.h>
+#include <linux/ioprio.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -302,6 +303,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_hint;
+	u16			ki_ioprio; /* See linux/ioprio.h */
 } __randomize_layout;
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
@@ -1942,6 +1944,7 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 		.ki_filp = filp,
 		.ki_flags = iocb_flags(filp),
 		.ki_hint = ki_hint_validate(file_write_hint(filp)),
+		.ki_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0),
 	};
 }
 
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
