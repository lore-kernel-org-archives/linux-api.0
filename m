From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 1/3] uffd: Tossing bits around
Date: Wed, 18 Mar 2015 22:34:50 +0300
Message-ID: <5509D35A.1080206@parallels.com>
References: <5509D342.7000403@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5509D342.7000403-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Reformat the existing code a bit to make it easier for
further patching.

Signed-off-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 fs/userfaultfd.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index b4c7f25..6c9a2d6 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -61,6 +61,23 @@ struct userfaultfd_wake_range {
 	unsigned long len;
 };
 
+static const struct file_operations userfaultfd_fops;
+
+static struct userfaultfd_ctx *userfaultfd_ctx_alloc(void)
+{
+	struct userfaultfd_ctx *ctx;
+
+	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	if (ctx) {
+		atomic_set(&ctx->refcount, 1);
+		init_waitqueue_head(&ctx->fault_wqh);
+		init_waitqueue_head(&ctx->fd_wqh);
+		ctx->released = false;
+	}
+
+	return ctx;
+}
+
 static int userfaultfd_wake_function(wait_queue_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
@@ -307,15 +324,15 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static inline unsigned int find_userfault(struct userfaultfd_ctx *ctx,
+static inline unsigned int do_find_userfault(wait_queue_head_t *wqh,
 					  struct userfaultfd_wait_queue **uwq)
 {
 	wait_queue_t *wq;
 	struct userfaultfd_wait_queue *_uwq;
 	unsigned int ret = 0;
 
-	spin_lock(&ctx->fault_wqh.lock);
-	list_for_each_entry(wq, &ctx->fault_wqh.task_list, task_list) {
+	spin_lock(&wqh->lock);
+	list_for_each_entry(wq, &wqh->task_list, task_list) {
 		_uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
 		if (_uwq->pending) {
 			ret = POLLIN;
@@ -324,11 +341,17 @@ static inline unsigned int find_userfault(struct userfaultfd_ctx *ctx,
 			break;
 		}
 	}
-	spin_unlock(&ctx->fault_wqh.lock);
+	spin_unlock(&wqh->lock);
 
 	return ret;
 }
 
+static inline unsigned int find_userfault(struct userfaultfd_ctx *ctx,
+		struct userfaultfd_wait_queue **uwq)
+{
+	return do_find_userfault(&ctx->fault_wqh, uwq);
+}
+
 static unsigned int userfaultfd_poll(struct file *file, poll_table *wait)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
@@ -1080,16 +1103,12 @@ static struct file *userfaultfd_file_create(int flags)
 		goto out;
 
 	file = ERR_PTR(-ENOMEM);
-	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = userfaultfd_ctx_alloc();
 	if (!ctx)
 		goto out;
 
-	atomic_set(&ctx->refcount, 1);
-	init_waitqueue_head(&ctx->fault_wqh);
-	init_waitqueue_head(&ctx->fd_wqh);
 	ctx->flags = flags;
 	ctx->state = UFFD_STATE_WAIT_API;
-	ctx->released = false;
 	ctx->mm = current->mm;
 	/* prevent the mm struct to be freed */
 	atomic_inc(&ctx->mm->mm_count);
-- 
1.8.4.2
