From: <adam.manzanares@wdc.com>
Subject: [RFC PATCH v2] fs: block dev aio request priority support
Date: Tue, 23 May 2017 13:48:04 -0700
Message-ID: <1495572484-8780-1-git-send-email-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
Sender: owner-linux-aio@kvack.org
To: bcrl@kvack.org, viro@zeniv.linux.org.uk, jlayton@poochiereds.net, bfields@fieldses.org, rgoldwyn@suse.de
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-api@vger.kernel.org

From: Adam Manzanares <adam.manzanares@wdc.com>

Map the aio_reqprio to the bio priority field at the point the bio is
created from the aio iocb. The aio_reqprio field of iocb is used as a
kernel IO class and priority iff the RWF_IOPRI flag is set on the iocb.

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

This update is based on the work of Goldwyn [3].

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>

v2: - use aio_rw_flags to indicate aio_reqprio should be 
      interpreted as an ioprio value.
	- update reference [2]
	- add reference [3]

[1] https://lkml.org/lkml/2016/12/6/495
[2] https://github.com/nmtadam/fio/tree/cmnd-prio.v3
[3] https://patchwork.kernel.org/patch/9722789/

---
 fs/aio.c                | 8 ++++++++
 fs/block_dev.c          | 1 +
 include/linux/fs.h      | 7 ++++++-
 include/uapi/linux/fs.h | 4 ++--
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9616dc7..7043711 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1605,6 +1605,14 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		}
 	}
 
+	/* If the IOCB IOPRI is set then the aio_reqprio is interpreted
+	 * as a IO scheduling class and priority value. This is then
+	 * set on the bio that is created from this request, which
+	 * enables the priority to be passed to device drivers
+	 */
+	if (req->common.ki_flags & IOCB_IOPRI)
+		req->common.ki_ioprio = iocb->aio_reqprio;
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 519599d..d3cd6e4 100644
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
index 2a7d14a..ac4bc7f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -269,6 +269,7 @@ struct writeback_control;
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
 #define IOCB_NOWAIT		(1 << 7)
+#define IOCB_IOPRI		(1 << 8)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -276,6 +277,7 @@ struct kiocb {
 	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
 	void			*private;
 	int			ki_flags;
+	u16			ki_ioprio; /* See linux/ioprio.h */
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
@@ -3061,7 +3063,8 @@ static inline int iocb_flags(struct file *file)
 
 static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
 {
-	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT)))
+	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC |
+			       RWF_NOWAIT | RWF_IOPRI)))
 		return -EOPNOTSUPP;
 
 	if (flags & RWF_HIPRI)
@@ -3072,6 +3075,8 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
 		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
 	if (flags & RWF_NOWAIT)
 		ki->ki_flags |= IOCB_NOWAIT;
+	if (flags & RWF_IOPRI)
+		ki->ki_flags |= IOCB_IOPRI;
 	return 0;
 }
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 29969fb..ede8c9d 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -356,10 +356,10 @@ struct fscrypt_key {
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
-/* flags for preadv2/pwritev2: */
+/* flags for aio & preadv2/pwritev2: */
 #define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
 #define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
 #define RWF_SYNC			0x00000004 /* per-IO O_SYNC */
 #define RWF_NOWAIT			0x00000008 /* per-IO, return -EAGAIN if operation would block */
-
+#define RWF_IOPRI			0x00000010 /* per-IO, interpret aio iocb reqprio as ioprio */
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.7.4

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
