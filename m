From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 04/10] fs: Introduce RWF_NOWAIT and FMODE_AIO_NOWAIT
Date: Thu, 15 Jun 2017 10:59:56 -0500
Message-ID: <20170615160002.17233-5-rgoldwyn@suse.de>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170615160002.17233-1-rgoldwyn@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

RWF_NOWAIT informs kernel to bail out if an AIO request will block
for reasons such as file allocations, or a writeback triggered,
or would block while allocating requests while performing
direct I/O.

RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.

FMODE_AIO_NOWAIT is a flag which identifies the file opened is capable
of returning -EAGAIN if the AIO call will block. This must be set by
supporting filesystems in the ->open() call.

Filesystems xfs, btrfs and ext4 would be supported in the following patches.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/aio.c                |  6 ++++++
 include/linux/fs.h      | 11 ++++++++++-
 include/uapi/linux/fs.h |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 020fa0045e3c..34027b67e2f4 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1592,6 +1592,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		goto out_put_req;
 	}
 
+	if ((req->common.ki_flags & IOCB_NOWAIT) &&
+			!(req->common.ki_flags & IOCB_DIRECT)) {
+		ret = -EOPNOTSUPP;
+		goto out_put_req;
+	}
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc0ab585cd56..017aca01c35e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -142,6 +142,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
+/* File is capable of returning -EAGAIN if AIO will block */
+#define FMODE_AIO_NOWAIT	((__force fmode_t)0x8000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
@@ -268,6 +271,7 @@ struct writeback_control;
 #define IOCB_DSYNC		(1 << 4)
 #define IOCB_SYNC		(1 << 5)
 #define IOCB_WRITE		(1 << 6)
+#define IOCB_NOWAIT		(1 << 7)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -3060,9 +3064,14 @@ static inline int iocb_flags(struct file *file)
 
 static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
 {
-	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
+	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT)))
 		return -EOPNOTSUPP;
 
+	if (flags & RWF_NOWAIT) {
+		if (!(ki->ki_filp->f_mode & FMODE_AIO_NOWAIT))
+			return -EOPNOTSUPP;
+		ki->ki_flags |= IOCB_NOWAIT;
+	}
 	if (flags & RWF_HIPRI)
 		ki->ki_flags |= IOCB_HIPRI;
 	if (flags & RWF_DSYNC)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 24e61a54feaa..29969fb7f9a7 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -360,5 +360,6 @@ struct fscrypt_key {
 #define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
 #define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
 #define RWF_SYNC			0x00000004 /* per-IO O_SYNC */
+#define RWF_NOWAIT			0x00000008 /* per-IO, return -EAGAIN if operation would block */
 
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.12.0
