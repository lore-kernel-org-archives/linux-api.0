From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 3/3] signalfd: add ability to read siginfo-s without dequeuing signals (v4)
Date: Mon, 14 Jan 2013 20:53:55 +0400
Message-ID: <1358182435-19245-4-git-send-email-avagin@openvz.org>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358182435-19245-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

pread(fd, buf, size, pos) with non-zero pos returns siginfo-s
without dequeuing signals.

A sequence number and a queue are encoded in pos.

pos = seq + SFD_*_OFFSET

seq is a sequence number of a signal in a queue.

SFD_PER_THREAD_QUEUE_OFFSET - read signals from a per-thread queue.
SFD_SHARED_QUEUE_OFFSET - read signals from a shared (process wide) queue.

This functionality is required for checkpointing pending signals.

v2: llseek() can't be used here, because peek_offset/f_pos/whatever
has to be shared with all processes which have this file opened.

Suppose that the task forks after sys_signalfd(). Now if parent or child
do llseek this affects them both. This is insane because signalfd is
"strange" to say at least, fork/dup/etc inherits signalfd_ctx but not
the" source" of the data. // Oleg Nesterov

v3,v4: minor cleanups

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
 fs/signalfd.c                 | 45 ++++++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/signalfd.h |  5 +++++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 4439a81..1eb9b87 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -51,6 +51,44 @@ struct signalfd_ctx {
 	sigset_t sigmask;
 };
 
+static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
+				siginfo_t *info, loff_t *ppos)
+{
+	struct sigpending *pending;
+	struct sigqueue *q;
+	loff_t seq;
+	int ret = 0;
+
+	if (*ppos >= SFD_SHARED_QUEUE_OFFSET) {
+		pending = &current->signal->shared_pending;
+		seq = *ppos - SFD_SHARED_QUEUE_OFFSET;
+	} else if (*ppos >= SFD_PER_THREAD_QUEUE_OFFSET) {
+		pending = &current->pending;
+		seq = *ppos - SFD_PER_THREAD_QUEUE_OFFSET;
+	} else
+		return -EINVAL;
+
+	spin_lock_irq(&current->sighand->siglock);
+
+	list_for_each_entry(q, &pending->list, list) {
+		if (sigismember(&ctx->sigmask, q->info.si_signo))
+			continue;
+
+		if (seq-- == 0) {
+			copy_siginfo(info, &q->info);
+			ret = info->si_signo;
+			break;
+		}
+	}
+
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (ret)
+		(*ppos)++;
+
+	return ret;
+}
+
 static int signalfd_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
@@ -248,7 +286,11 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
+		if (*ppos == 0)
+			ret = signalfd_dequeue(ctx, &info, nonblock);
+		else
+			ret = signalfd_peek(ctx, &info, ppos);
+
 		if (unlikely(ret <= 0))
 			break;
 
@@ -338,6 +380,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		}
 
 		file->f_flags |= flags & SFD_RAW;
+		file->f_mode |= FMODE_PREAD;
 
 		fd_install(ufd, file);
 	} else {
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index bc31849..0953785 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -17,6 +17,11 @@
 #define SFD_NONBLOCK O_NONBLOCK
 #define SFD_RAW O_DIRECT
 
+/* Read signals from a shared (process wide) queue */
+#define SFD_SHARED_QUEUE_OFFSET (1LL << 62)
+/* Read signals from a per-thread queue */
+#define SFD_PER_THREAD_QUEUE_OFFSET 1
+
 struct signalfd_siginfo {
 	__u32 ssi_signo;
 	__s32 ssi_errno;
-- 
1.7.11.7
