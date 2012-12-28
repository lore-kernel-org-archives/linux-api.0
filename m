From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 2/3] signalfd: add ability to return siginfo in a raw format (v2)
Date: Fri, 28 Dec 2012 14:23:00 +0400
Message-ID: <1356690181-1796-3-git-send-email-avagin@openvz.org>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1356690181-1796-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

signalfd should be called with the flag SFD_RAW for that.

signalfd_siginfo is not full for siginfo with a negative si_code.
copy_siginfo_to_user() is copied a full siginfo to user-space, if
si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
expanded, because it has not compatible format with siginfo_t.

Another problem is that a constant __SI_* is removed from si_code.
It's not a problem for usual applications, because they expect
a defined type of siginfo (internal logic).
When we want to dump pending signals, we can't predict a type of
siginfo, so we should get it from kernel.

The main idea of the raw format is that it should be enough for
restoring exactly the same siginfo for the current process.

This functionality is required for checkpointing pending signals.

v2: fix a race condition during setting file flags
    copy_siginfo_to_user32() if is_compat_task

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/signalfd.c                 | 64 +++++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/signalfd.h |  1 +
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index b534869..4439a81 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -30,6 +30,7 @@
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
 #include <linux/proc_fs.h>
+#include <linux/compat.h>
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
@@ -74,6 +75,38 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
 }
 
 /*
+ * Copy a whole siginfo into users spaces.
+ * The main idea of this format is that it should be enough
+ * for restoring siginfo back into the kernel.
+ */
+static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
+					siginfo_t *kinfo)
+{
+	siginfo_t *uinfo = (siginfo_t *) siginfo;
+	int err;
+
+	BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
+
+	err = __clear_user(uinfo, sizeof(*uinfo));
+
+#ifdef CONFIG_COMPAT
+	if (unlikely(is_compat_task())) {
+		compat_siginfo_t *compat_uinfo = (compat_siginfo_t *) siginfo;
+
+		err |= copy_siginfo_to_user32(compat_uinfo, kinfo);
+		err |= put_user(kinfo->si_code, &compat_uinfo->si_code);
+
+		return err ? -EFAULT: sizeof(*compat_uinfo);
+	}
+#endif
+
+	err |= copy_siginfo_to_user(uinfo, kinfo);
+	err |= put_user(kinfo->si_code, &uinfo->si_code);
+
+	return err ? -EFAULT: sizeof(*uinfo);
+}
+
+/*
  * Copied from copy_siginfo_to_user() in kernel/signal.c
  */
 static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
@@ -205,6 +238,7 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	struct signalfd_ctx *ctx = file->private_data;
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
+	bool raw = file->f_flags & SFD_RAW;
 	ssize_t ret, total = 0;
 	siginfo_t info;
 
@@ -217,7 +251,12 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 		ret = signalfd_dequeue(ctx, &info, nonblock);
 		if (unlikely(ret <= 0))
 			break;
-		ret = signalfd_copyinfo(siginfo, &info);
+
+		if (raw)
+			ret = signalfd_copy_raw_info(siginfo, &info);
+		else
+			ret = signalfd_copyinfo(siginfo, &info);
+
 		if (ret < 0)
 			break;
 		siginfo++;
@@ -262,7 +301,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK))
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW))
 		return -EINVAL;
 
 	if (sizemask != sizeof(sigset_t) ||
@@ -272,20 +311,35 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	signotset(&sigmask);
 
 	if (ufd == -1) {
+		struct file *file;
 		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 		if (!ctx)
 			return -ENOMEM;
 
 		ctx->sigmask = sigmask;
 
+		ufd = get_unused_fd_flags(flags);
+		if (ufd < 0) {
+			kfree(ctx);
+			goto out;
+		}
+
 		/*
 		 * When we call this, the initialization must be complete, since
 		 * anon_inode_getfd() will install the fd.
 		 */
-		ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
+		file = anon_inode_getfile("[signalfd]", &signalfd_fops, ctx,
 				       O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
-		if (ufd < 0)
+		if (IS_ERR(file)) {
+			put_unused_fd(ufd);
+			ufd = PTR_ERR(file);
 			kfree(ctx);
+			goto out;
+		}
+
+		file->f_flags |= flags & SFD_RAW;
+
+		fd_install(ufd, file);
 	} else {
 		struct fd f = fdget(ufd);
 		if (!f.file)
@@ -302,7 +356,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		wake_up(&current->sighand->signalfd_wqh);
 		fdput(f);
 	}
-
+out:
 	return ufd;
 }
 
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index 492c6de..bc31849 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -15,6 +15,7 @@
 /* Flags for signalfd4.  */
 #define SFD_CLOEXEC O_CLOEXEC
 #define SFD_NONBLOCK O_NONBLOCK
+#define SFD_RAW O_DIRECT
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
-- 
1.7.11.7
