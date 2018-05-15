From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/32] aio: simplify KIOCB_KEY handling
Date: Tue, 15 May 2018 21:48:07 +0200
Message-ID: <20180515194833.6906-7-hch@lst.de>
References: <20180515194833.6906-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180515194833.6906-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

No need to pass the key field to lookup_iocb to compare it with KIOCB_KEY,
as we can do that right after retrieving it from userspace.  Also move the
KIOCB_KEY definition to aio.c as it is an internal value not used by any
other place in the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c            | 14 +++++++-------
 include/linux/aio.h |  2 --
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index f3eae5d5771b..2e0bc04f7920 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -46,6 +46,8 @@
 
 #include "internal.h"
 
+#define KIOCB_KEY		0
+
 #define AIO_RING_MAGIC			0xa10a10a1
 #define AIO_RING_COMPAT_FEATURES	1
 #define AIO_RING_INCOMPAT_FEATURES	0
@@ -1812,15 +1814,12 @@ COMPAT_SYSCALL_DEFINE3(io_submit, compat_aio_context_t, ctx_id,
  *	Finds a given iocb for cancellation.
  */
 static struct aio_kiocb *
-lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb, u32 key)
+lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb)
 {
 	struct aio_kiocb *kiocb;
 
 	assert_spin_locked(&ctx->ctx_lock);
 
-	if (key != KIOCB_KEY)
-		return NULL;
-
 	/* TODO: use a hash or array, this sucks. */
 	list_for_each_entry(kiocb, &ctx->active_reqs, ki_list) {
 		if (kiocb->ki_user_iocb == iocb)
@@ -1847,9 +1846,10 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 	u32 key;
 	int ret;
 
-	ret = get_user(key, &iocb->aio_key);
-	if (unlikely(ret))
+	if (unlikely(get_user(key, &iocb->aio_key)))
 		return -EFAULT;
+	if (unlikely(key != KIOCB_KEY))
+		return -EINVAL;
 
 	ctx = lookup_ioctx(ctx_id);
 	if (unlikely(!ctx))
@@ -1857,7 +1857,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 
 	spin_lock_irq(&ctx->ctx_lock);
 
-	kiocb = lookup_kiocb(ctx, iocb, key);
+	kiocb = lookup_kiocb(ctx, iocb);
 	if (kiocb)
 		ret = kiocb_cancel(kiocb);
 	else
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 9d8aabecfe2d..b83e68dd006f 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -8,8 +8,6 @@ struct kioctx;
 struct kiocb;
 struct mm_struct;
 
-#define KIOCB_KEY		0
-
 typedef int (kiocb_cancel_fn)(struct kiocb *);
 
 /* prototypes */
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
