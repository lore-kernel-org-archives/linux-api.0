From: <adam.manzanares@wdc.com>
Subject: [RFC PATCH] fs: block dev aio request priority support
Date: Mon, 22 May 2017 10:19:33 -0700
Message-ID: <1495473573-3343-1-git-send-email-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: bcrl@kvack.org, viro@zeniv.linux.org.uk, jlayton@poochiereds.net, bfields@fieldses.org
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

Map the aio_reqprio to the bio priority field at
the point the bio is created from the aio iocb.

The aio_reqprio field of iocb is used as a kernel IO class and priority
iff the IOCB_FLAG_IOPRIO flag is set on the iocb.

Late last year device IO priority support was introduced to reduce application
tail latency when iopriority information was set on the process [1]. This 
patch mapped iopriority information to block io requests. This information 
could be leveraged by device drivers to build device specific prioritized 
commands.

The iopriority is set on the iocontext which is a structure associated with 
a process. There exists a system call to set this iopriority information on 
a process, but I believe it would be useful to also have a mechanism to set 
priority on a per io command basis. 

The aio iocb has a field for the request priority which is currently not used 
within the kernel. This patch leverages this field to pass a per command 
iopriority value to devices. This work leverages the work in the previously 
referenced patch [1]. When the bio is generated from the iocb we copy the 
iocb iopriority information into the bio, which is eventually turned into a 
request which also gets a copy of the iopriority information. 

To demonstrate how to use this feature I modified fio to use the new aio 
feature. The modification to fio can be found at [2] and the new options 
are cmndprioclass and cmndprio.

[1] https://lkml.org/lkml/2016/12/6/495
[2] https://github.com/nmtadam/fio/tree/cmnd-prio.v2

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 fs/aio.c                     | 9 +++++++++
 fs/block_dev.c               | 1 +
 include/linux/fs.h           | 1 +
 include/uapi/linux/aio_abi.h | 6 ++++++
 4 files changed, 17 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index f52d925..a75a279 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1568,6 +1568,15 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->common.ki_pos = iocb->aio_offset;
 	req->common.ki_complete = aio_complete;
 	req->common.ki_flags = iocb_flags(req->common.ki_filp);
+	if (iocb->aio_flags & IOCB_FLAG_IOPRIO)
+		/*
+		 * If the IOCB_FLAG_IOPRIO flag of aio_flags is set,
+		 * then the aio_reqprio is interpreted as a I/O
+		 * scheduling class and priority. This is then set
+		 * on the bio that is created from this request, which
+		 * enables the priority to be passed to device drivers.
+		 */
+		req->common.ki_ioprio = iocb->aio_reqprio;
 
 	if (iocb->aio_flags & IOCB_FLAG_RESFD) {
 		/*
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2eca00e..20d18db 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -360,6 +360,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		bio->bi_iter.bi_sector = pos >> 9;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
+		bio->bi_ioprio = iocb->ki_ioprio;
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 866c955..83135f0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -276,6 +276,7 @@ struct kiocb {
 	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
 	void			*private;
 	int			ki_flags;
+	u16			ki_ioprio; /* See linux/ioprio.h */
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index bb2554f..415980d 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -54,6 +54,12 @@ enum {
  */
 #define IOCB_FLAG_RESFD		(1 << 0)
 
+/*
+ * IOCB_FLAG_IOPRIO - Set if the "aio_reqprio" member of the "struct iocb"
+ *                    is interpreted as an I/O scheduling class and priority
+ */
+#define IOCB_FLAG_IOPRIO	(1 << 1)
+
 /* read() from /dev/aio returns these structures. */
 struct io_event {
 	__u64		data;		/* the data field from the iocb */
-- 
2.7.4

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
