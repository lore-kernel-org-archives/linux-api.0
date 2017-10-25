From: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC PATCH 3/3] userfaultfd: non-cooperative: allow synchronous EVENT_REMOVE
Date: Wed, 25 Oct 2017 19:23:37 +0300
Message-ID: <1508948617-22505-4-git-send-email-rppt@linux.vnet.ibm.com>
References: <1508948617-22505-1-git-send-email-rppt@linux.vnet.ibm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508948617-22505-1-git-send-email-rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In non-cooperative case, multi-threaded userfaultfd monitor may encounter a
race between UFFDIO_COPY and the processing of UFFD_EVENT_REMOVE.
Unlike the page faults that suspend the faulting thread until the page
fault is resolved, other events resume exectution of the thread that caused
the event immediately after delivering the notification to the userfaultfd
monitor. The monitor may run UFFDIO_COPY in parallel with the event
processing and this may result in memory corruption.
With UFFD_EVENT_REMOVE_SYNC introduced by this patch, it would be possible
to block the non-cooperative thread until the userfaultfd monitor will
explicitly wake it.

Signed-off-by: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/userfaultfd.c                 | 32 +++++++++++++++++++++++++++++++-
 include/uapi/linux/userfaultfd.h | 11 +++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 67cec38473b8..06a6475c1bf5 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -658,6 +658,14 @@ static void userfaultfd_event_complete(struct userfaultfd_ctx *ctx,
 {
 	struct userfaultfd_wake_key key = { 0 };
 
+	/*
+	 * For synchronous events we don't wake up the thread that
+	 * caused the event. The userfault monitor has to explicitly
+	 * wake it with ioctl(UFFDIO_WAKE_SYNC_EVENT)
+	 */
+	if (ewq->msg.event & UFFD_EVENT_FLAG_SYNC)
+		return;
+
 	key.event = ewq->msg.event;
 	 __wake_up_locked_key(&ctx->event_wqh, TASK_NORMAL, &key);
 }
@@ -778,7 +786,8 @@ bool userfaultfd_remove(struct vm_area_struct *vma,
 	struct userfaultfd_wait_queue ewq;
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
-	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_REMOVE))
+	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_REMOVE ||
+		      ctx->features & UFFD_FEATURE_EVENT_REMOVE_SYNC))
 		return true;
 
 	userfaultfd_ctx_get(ctx);
@@ -787,6 +796,9 @@ bool userfaultfd_remove(struct vm_area_struct *vma,
 	msg_init(&ewq.msg);
 
 	ewq.msg.event = UFFD_EVENT_REMOVE;
+	if (ctx->features & UFFD_FEATURE_EVENT_REMOVE_SYNC)
+		ewq.msg.event |= UFFD_EVENT_FLAG_SYNC;
+
 	ewq.msg.arg.remove.start = start;
 	ewq.msg.arg.remove.end = end;
 
@@ -1670,6 +1682,21 @@ static int userfaultfd_wake(struct userfaultfd_ctx *ctx,
 	return ret;
 }
 
+static int userfaultfd_wake_sync_event(struct userfaultfd_ctx *ctx,
+				       unsigned long arg)
+{
+	struct userfaultfd_wake_key key = {
+		.event = arg,
+	};
+
+	spin_lock(&ctx->event_wqh.lock);
+	if (waitqueue_active(&ctx->event_wqh))
+		__wake_up_locked_key(&ctx->event_wqh, TASK_NORMAL, &key);
+	spin_unlock(&ctx->event_wqh.lock);
+
+	return 0;
+}
+
 static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
 			    unsigned long arg)
 {
@@ -1842,6 +1869,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_WAKE:
 		ret = userfaultfd_wake(ctx, arg);
 		break;
+	case UFFDIO_WAKE_SYNC_EVENT:
+		ret = userfaultfd_wake_sync_event(ctx, arg);
+		break;
 	case UFFDIO_COPY:
 		ret = userfaultfd_copy(ctx, arg);
 		break;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index d6d1f65cb3c3..32b96a048baf 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -21,6 +21,7 @@
 #define UFFD_API_FEATURES (UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
 			   UFFD_FEATURE_EVENT_REMOVE |	\
+			   UFFD_FEATURE_EVENT_REMOVE_SYNC |	\
 			   UFFD_FEATURE_EVENT_UNMAP |		\
 			   UFFD_FEATURE_MISSING_HUGETLBFS |	\
 			   UFFD_FEATURE_MISSING_SHMEM |		\
@@ -51,6 +52,7 @@
 #define _UFFDIO_WAKE			(0x02)
 #define _UFFDIO_COPY			(0x03)
 #define _UFFDIO_ZEROPAGE		(0x04)
+#define _UFFDIO_WAKE_SYNC_EVENT		(0x05)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -67,6 +69,7 @@
 				      struct uffdio_copy)
 #define UFFDIO_ZEROPAGE		_IOWR(UFFDIO, _UFFDIO_ZEROPAGE,	\
 				      struct uffdio_zeropage)
+#define UFFDIO_WAKE_SYNC_EVENT	_IOR(UFFDIO, _UFFDIO_WAKE_SYNC_EVENT, __u32)
 
 /* read() structure */
 struct uffd_msg {
@@ -118,6 +121,13 @@ struct uffd_msg {
 #define UFFD_EVENT_REMOVE	0x15
 #define UFFD_EVENT_UNMAP	0x16
 
+/*
+ * Events that are delivered synchronously. The causing thread is
+ * blocked until the event is handled by the userfault monitor
+ */
+#define UFFD_EVENT_FLAG_SYNC	0x80
+#define UFFD_EVENT_REMOVE_SYNC	(UFFD_EVENT_REMOVE | UFFD_EVENT_FLAG_SYNC)
+
 /* flags for UFFD_EVENT_PAGEFAULT */
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
 #define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
@@ -175,6 +185,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_EVENT_UNMAP		(1<<6)
 #define UFFD_FEATURE_SIGBUS			(1<<7)
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
+#define UFFD_FEATURE_EVENT_REMOVE_SYNC		(1<<9)
 	__u64 features;
 
 	__u64 ioctls;
-- 
2.7.4
