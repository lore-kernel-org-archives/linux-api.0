From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 3/3] signalfd: add ability to read siginfo-s without dequeuing signals (v2)
Date: Tue, 29 Jan 2013 23:03:01 +0400
Message-ID: <1359486181-29088-1-git-send-email-avagin@openvz.org>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1358849741-9611-4-git-send-email-avagin@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

If signalfd is created with the flag SFD_PEEK, it reads siginfo-s
without dequeuing signals.

For reading not first siginfo pread(fd, buf, size, pos) can be used,
where ppos / sizeof(signalfd_siginfo) is a sequence number of a signal
in a queue.

This functionality is required for checkpointing pending signals.

v2: * signals can be dumped only from one queue.
    * treat pos as offset in bytes, not in elements, so pos should be
      aligned to the size of signalfd_siginfo.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/signalfd.c                 | 61 ++++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/signalfd.h |  2 ++
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 8019ec9..0da6a30 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -51,6 +51,47 @@ struct signalfd_ctx {
 	sigset_t sigmask;
 };
 
+static int peek_signal(struct sigpending *pending, sigset_t *mask,
+				siginfo_t *info, loff_t *pseq)
+{
+	struct sigqueue *q;
+	int ret = 0;
+
+	spin_lock_irq(&current->sighand->siglock);
+
+	list_for_each_entry(q, &pending->list, list) {
+		if (sigismember(mask, q->info.si_signo))
+			continue;
+
+		if ((*pseq)-- == 0) {
+			copy_siginfo(info, &q->info);
+			ret = info->si_signo;
+			break;
+		}
+	}
+
+	spin_unlock_irq(&current->sighand->siglock);
+
+	return ret;
+}
+
+static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
+				siginfo_t *info, loff_t *ppos, int queue_mask)
+{
+	loff_t seq = *ppos / sizeof(struct signalfd_siginfo);
+	int signr = 0;
+
+	if (queue_mask & SIGQUEUE_PRIVATE)
+		signr = peek_signal(&current->pending,
+					&ctx->sigmask, info, &seq);
+	else if (queue_mask & SIGQUEUE_SHARED)
+		signr = peek_signal(&current->signal->shared_pending,
+					 &ctx->sigmask, info, &seq);
+	(*ppos) += sizeof(struct signalfd_siginfo);
+
+	return signr;
+}
+
 static int signalfd_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
@@ -257,9 +298,15 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	if (!count)
 		return -EINVAL;
 
+	if (*ppos % sizeof(struct signalfd_siginfo))
+		return -EINVAL;
+
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock, qmask);
+		if (file->f_flags & SFD_PEEK)
+			ret = signalfd_peek(ctx, &info, ppos, qmask);
+		else
+			ret = signalfd_dequeue(ctx, &info, nonblock, qmask);
 
 		if (unlikely(ret <= 0))
 			break;
@@ -315,7 +362,12 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW | SFD_QUEUES))
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK |
+			SFD_RAW | SFD_PEEK | SFD_QUEUES))
+		return -EINVAL;
+
+	/* SFD_PEEK can be used for one queue only */
+	if ((flags & SFD_PEEK) && ((flags & SFD_QUEUES) == SFD_QUEUES))
 		return -EINVAL;
 
 	if (sizemask != sizeof(sigset_t) ||
@@ -352,7 +404,10 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		}
 
 		file->f_flags |= (flags & SFD_QUEUES) ? : SFD_QUEUES;
-		file->f_flags |= flags & SFD_RAW;
+		file->f_flags |= flags & (SFD_RAW | SFD_PEEK);
+
+		if (file->f_flags & SFD_PEEK)
+			file->f_mode |= FMODE_PREAD;
 
 		fd_install(ufd, file);
 	} else {
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index 481b658..24c5d2d 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -20,6 +20,8 @@
 #define SFD_SHARED_QUEUE O_DIRECTORY
 /* Read signals from a per-thread queue */
 #define SFD_PER_THREAD_QUEUE O_EXCL
+/* Read signals without removing them from a queue */
+#define SFD_PEEK O_APPEND
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
-- 
1.7.11.7

