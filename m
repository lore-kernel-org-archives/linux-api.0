From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] signalfd: add ability to choose a private or shared queue
Date: Tue, 22 Jan 2013 14:15:40 +0400
Message-ID: <1358849741-9611-3-git-send-email-avagin@openvz.org>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358849741-9611-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch is added two flags SFD_SHARED_QUEUE and SFD_PER_THREAD_QUEUE
SFD_SHARED_QUEUE - read signals from a shared (process wide) queue
SFD_PER_THREAD_QUEUE - read signals from a per-thread queue

Without these flags or with both flags signals are read from both queues.

This functionality is required for dumping pending signals.

Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/signalfd.c                 | 30 ++++++++++++++++++++++--------
 include/uapi/linux/signalfd.h |  4 ++++
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index c723b5d..8019ec9 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -61,13 +61,17 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
 {
 	struct signalfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
+	unsigned int flags = file->f_flags;
 
 	poll_wait(file, &current->sighand->signalfd_wqh, wait);
 
 	spin_lock_irq(&current->sighand->siglock);
-	if (next_signal(&current->pending, &ctx->sigmask) ||
-	    next_signal(&current->signal->shared_pending,
-			&ctx->sigmask))
+	if ((flags & SFD_PER_THREAD_QUEUE) &&
+	     next_signal(&current->pending, &ctx->sigmask))
+		events |= POLLIN;
+
+	if ((flags & SFD_SHARED_QUEUE) &&
+	     next_signal(&current->signal->shared_pending, &ctx->sigmask))
 		events |= POLLIN;
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -189,13 +193,13 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 }
 
 static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
-				int nonblock)
+				int nonblock, int qmask)
 {
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
 
 	spin_lock_irq(&current->sighand->siglock);
-	ret = dequeue_signal(current, &ctx->sigmask, info);
+	ret = do_dequeue_signal(current, &ctx->sigmask, info, qmask);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -209,7 +213,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(current, &ctx->sigmask, info);
+		ret = do_dequeue_signal(current, &ctx->sigmask, info, qmask);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
@@ -240,16 +244,23 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
 	bool raw = file->f_flags & SFD_RAW;
+	int qmask = 0;
 	ssize_t ret, total = 0;
 	siginfo_t info;
 
+	if (file->f_flags & SFD_PER_THREAD_QUEUE)
+		qmask |= SIGQUEUE_PRIVATE;
+	if (file->f_flags & SFD_SHARED_QUEUE)
+		qmask |= SIGQUEUE_SHARED;
+
 	count /= sizeof(struct signalfd_siginfo);
 	if (!count)
 		return -EINVAL;
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
+		ret = signalfd_dequeue(ctx, &info, nonblock, qmask);
+
 		if (unlikely(ret <= 0))
 			break;
 
@@ -292,6 +303,8 @@ static const struct file_operations signalfd_fops = {
 	.llseek		= noop_llseek,
 };
 
+#define SFD_QUEUES (SFD_SHARED_QUEUE | SFD_PER_THREAD_QUEUE)
+
 SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		size_t, sizemask, int, flags)
 {
@@ -302,7 +315,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW))
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW | SFD_QUEUES))
 		return -EINVAL;
 
 	if (sizemask != sizeof(sigset_t) ||
@@ -338,6 +351,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 			goto out;
 		}
 
+		file->f_flags |= (flags & SFD_QUEUES) ? : SFD_QUEUES;
 		file->f_flags |= flags & SFD_RAW;
 
 		fd_install(ufd, file);
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index bc31849..481b658 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -16,6 +16,10 @@
 #define SFD_CLOEXEC O_CLOEXEC
 #define SFD_NONBLOCK O_NONBLOCK
 #define SFD_RAW O_DIRECT
+/* Read signals from a shared (process wide) queue */
+#define SFD_SHARED_QUEUE O_DIRECTORY
+/* Read signals from a per-thread queue */
+#define SFD_PER_THREAD_QUEUE O_EXCL
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
-- 
1.7.11.7
