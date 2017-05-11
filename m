From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 03/10] fs: Use RWF_* flags for AIO operations
Date: Thu, 11 May 2017 14:17:03 -0500
Message-ID: <20170511191710.31959-4-rgoldwyn@suse.de>
References: <20170511191710.31959-1-rgoldwyn@suse.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170511191710.31959-1-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>

aio_rw_flags is introduced in struct iocb (using aio_reserved1) which will
carry the RWF_* flags. We cannot use aio_flags because they are not
checked for validity which may break existing applications.

Note, the only place RWF_HIPRI comes in effect is dio_await_one().
All the rest of the locations, aio code return -EIOCBQUEUED before the
checks for RWF_HIPRI.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/aio.c                     | 8 +++++++-
 include/uapi/linux/aio_abi.h | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index f52d925ee259..020fa0045e3c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1541,7 +1541,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	ssize_t ret;
 
 	/* enforce forwards compatibility on users */
-	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
+	if (unlikely(iocb->aio_reserved2)) {
 		pr_debug("EINVAL: reserve field set\n");
 		return -EINVAL;
 	}
@@ -1586,6 +1586,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		req->common.ki_flags |= IOCB_EVENTFD;
 	}
 
+	ret = kiocb_set_rw_flags(&req->common, iocb->aio_rw_flags);
+	if (unlikely(ret)) {
+		pr_debug("EINVAL: aio_rw_flags\n");
+		goto out_put_req;
+	}
+
 	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		pr_debug("EFAULT: aio_key\n");
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index bb2554f7fbd1..a2d4a8ac94ca 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -79,7 +79,7 @@ struct io_event {
 struct iocb {
 	/* these are internal to the kernel/libc. */
 	__u64	aio_data;	/* data to be returned in event's data */
-	__u32	PADDED(aio_key, aio_reserved1);
+	__u32	PADDED(aio_key, aio_rw_flags);
 				/* the kernel sets aio_key to the req # */
 
 	/* common fields */
-- 
2.12.0
