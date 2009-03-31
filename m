From: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Subject: [patch 081/183] eventfd: improve support for semaphore-like behavior
Date: Tue, 31 Mar 2009 15:24:18 -0700
Message-ID: <200903312224.n2VMOIRi022647@imap1.linux-foundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>

People started using eventfd in a semaphore-like way where before they
were using pipes.

That is, counter-based resource access.  Where a "wait()" returns
immediately by decrementing the counter by one, if counter is greater than
zero.  Otherwise will wait.  And where a "post(count)" will add count to
the counter releasing the appropriate amount of waiters.  If eventfd the
"post" (write) part is fine, while the "wait" (read) does not dequeue 1,
but the whole counter value.

The problem with eventfd is that a read() on the fd returns and wipes the
whole counter, making the use of it as semaphore a little bit more
cumbersome.  You can do a read() followed by a write() of COUNTER-1, but
IMO it's pretty easy and cheap to make this work w/out extra steps.  This
patch introduces a new eventfd flag that tells eventfd to only dequeue 1
from the counter, allowing simple read/write to make it behave like a
semaphore.  Simple test here:

http://www.xmailserver.org/eventfd-sem.c

To be back-compatible with earlier kernels, userspace applications should
probe for the availability of this feature via

#ifdef EFD_SEMAPHORE
	fd = eventfd2 (CNT, EFD_SEMAPHORE);
	if (fd == -1 && errno == EINVAL)
		<fallback>
#else
		<fallback>
#endif

Signed-off-by: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Tested-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 fs/eventfd.c            |   20 +++++++++++---------
 include/linux/eventfd.h |   12 +++++++++++-
 2 files changed, 22 insertions(+), 10 deletions(-)

diff -puN fs/eventfd.c~eventfd-improve-support-for-semaphore-like-behavior fs/eventfd.c
--- a/fs/eventfd.c~eventfd-improve-support-for-semaphore-like-behavior
+++ a/fs/eventfd.c
@@ -28,6 +28,7 @@ struct eventfd_ctx {
 	 * issue a wakeup.
 	 */
 	__u64 count;
+	unsigned int flags;
 };
 
 /*
@@ -87,22 +88,20 @@ static ssize_t eventfd_read(struct file 
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	ssize_t res;
-	__u64 ucnt;
+	__u64 ucnt = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (count < sizeof(ucnt))
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
-	ucnt = ctx->count;
-	if (ucnt > 0)
+	if (ctx->count > 0)
 		res = sizeof(ucnt);
 	else if (!(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (ctx->count > 0) {
-				ucnt = ctx->count;
 				res = sizeof(ucnt);
 				break;
 			}
@@ -117,8 +116,9 @@ static ssize_t eventfd_read(struct file 
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (res > 0) {
-		ctx->count = 0;
+	if (likely(res > 0)) {
+		ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
+		ctx->count -= ucnt;
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked(&ctx->wqh);
 	}
@@ -166,7 +166,7 @@ static ssize_t eventfd_write(struct file
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (res > 0) {
+	if (likely(res > 0)) {
 		ctx->count += ucnt;
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked(&ctx->wqh);
@@ -207,7 +207,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
+	if (flags & ~EFD_FLAGS_SET)
 		return -EINVAL;
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
@@ -216,13 +216,14 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
+	ctx->flags = flags;
 
 	/*
 	 * When we call this, the initialization must be complete, since
 	 * anon_inode_getfd() will install the fd.
 	 */
 	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx,
-			      flags & (O_CLOEXEC | O_NONBLOCK));
+			      flags & EFD_SHARED_FCNTL_FLAGS);
 	if (fd < 0)
 		kfree(ctx);
 	return fd;
@@ -232,3 +233,4 @@ SYSCALL_DEFINE1(eventfd, unsigned int, c
 {
 	return sys_eventfd2(count, 0);
 }
+
diff -puN include/linux/eventfd.h~eventfd-improve-support-for-semaphore-like-behavior include/linux/eventfd.h
--- a/include/linux/eventfd.h~eventfd-improve-support-for-semaphore-like-behavior
+++ a/include/linux/eventfd.h
@@ -13,10 +13,20 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
-/* Flags for eventfd2.  */
+/*
+ * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from eventfd, in order to leave a free define-space for
+ * shared O_* flags.
+ */
+#define EFD_SEMAPHORE (1 << 0)
 #define EFD_CLOEXEC O_CLOEXEC
 #define EFD_NONBLOCK O_NONBLOCK
 
+#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
+#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
+
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
 
_
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
