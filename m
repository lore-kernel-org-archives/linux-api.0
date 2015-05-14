From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/23] userfaultfd: allocate the userfaultfd_ctx cacheline aligned
Date: Thu, 14 May 2015 19:31:13 +0200
Message-ID: <1431624680-20153-17-git-send-email-aarcange@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431624680-20153-1-git-send-email-aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Use proper slab to guarantee alignment.

Signed-off-by: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/userfaultfd.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 3d26f41..5542fe7 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -27,20 +27,26 @@
 #include <linux/ioctl.h>
 #include <linux/security.h>
 
+static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
+
 enum userfaultfd_state {
 	UFFD_STATE_WAIT_API,
 	UFFD_STATE_RUNNING,
 };
 
+/*
+ * Start with fault_pending_wqh and fault_wqh so they're more likely
+ * to be in the same cacheline.
+ */
 struct userfaultfd_ctx {
-	/* pseudo fd refcounting */
-	atomic_t refcount;
 	/* waitqueue head for the pending (i.e. not read) userfaults */
 	wait_queue_head_t fault_pending_wqh;
 	/* waitqueue head for the userfaults */
 	wait_queue_head_t fault_wqh;
 	/* waitqueue head for the pseudo fd to wakeup poll/read */
 	wait_queue_head_t fd_wqh;
+	/* pseudo fd refcounting */
+	atomic_t refcount;
 	/* userfaultfd syscall flags */
 	unsigned int flags;
 	/* state machine */
@@ -117,7 +123,7 @@ static void userfaultfd_ctx_put(struct userfaultfd_ctx *ctx)
 		VM_BUG_ON(spin_is_locked(&ctx->fd_wqh.lock));
 		VM_BUG_ON(waitqueue_active(&ctx->fd_wqh));
 		mmput(ctx->mm);
-		kfree(ctx);
+		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
 	}
 }
 
@@ -987,6 +993,15 @@ static const struct file_operations userfaultfd_fops = {
 	.llseek		= noop_llseek,
 };
 
+static void init_once_userfaultfd_ctx(void *mem)
+{
+	struct userfaultfd_ctx *ctx = (struct userfaultfd_ctx *) mem;
+
+	init_waitqueue_head(&ctx->fault_pending_wqh);
+	init_waitqueue_head(&ctx->fault_wqh);
+	init_waitqueue_head(&ctx->fd_wqh);
+}
+
 /**
  * userfaultfd_file_create - Creates an userfaultfd file pointer.
  * @flags: Flags for the userfaultfd file.
@@ -1017,14 +1032,11 @@ static struct file *userfaultfd_file_create(int flags)
 		goto out;
 
 	file = ERR_PTR(-ENOMEM);
-	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = kmem_cache_alloc(userfaultfd_ctx_cachep, GFP_KERNEL);
 	if (!ctx)
 		goto out;
 
 	atomic_set(&ctx->refcount, 1);
-	init_waitqueue_head(&ctx->fault_pending_wqh);
-	init_waitqueue_head(&ctx->fault_wqh);
-	init_waitqueue_head(&ctx->fd_wqh);
 	ctx->flags = flags;
 	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
@@ -1035,7 +1047,7 @@ static struct file *userfaultfd_file_create(int flags)
 	file = anon_inode_getfile("[userfaultfd]", &userfaultfd_fops, ctx,
 				  O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (IS_ERR(file))
-		kfree(ctx);
+		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
 out:
 	return file;
 }
@@ -1064,3 +1076,14 @@ err_put_unused_fd:
 
 	return error;
 }
+
+static int __init userfaultfd_init(void)
+{
+	userfaultfd_ctx_cachep = kmem_cache_create("userfaultfd_ctx_cache",
+						sizeof(struct userfaultfd_ctx),
+						0,
+						SLAB_HWCACHE_ALIGN|SLAB_PANIC,
+						init_once_userfaultfd_ctx);
+	return 0;
+}
+__initcall(userfaultfd_init);
