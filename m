From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC v2 4/7] epoll: Add implementation for epoll_ctl_batch
Date: Wed,  4 Feb 2015 18:36:50 +0800
Message-ID: <1423046213-7043-5-git-send-email-famz@redhat.com>
References: <1423046213-7043-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423046213-7043-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

This new syscall is a batched version of epoll_ctl. It will execute each
command as specified in cmds in given order, and stop at first failure
or upon completion of all commands.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 fs/eventpoll.c                 | 48 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h       |  4 ++++
 include/uapi/linux/eventpoll.h | 11 ++++++++++
 3 files changed, 63 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a1c313c..4eb40e0 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2067,6 +2067,54 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 			      sigmask ? &ksigmask : NULL);
 }
 
+SYSCALL_DEFINE4(epoll_ctl_batch, int, epfd, int, flags,
+		int, ncmds, struct epoll_ctl_cmd __user *, cmds)
+{
+	struct epoll_ctl_cmd *kcmds = NULL;
+	int i, r, ret = 0;
+	int cmd_size;
+
+	if (flags)
+		return -EINVAL;
+	if (ncmds <= 0 || !cmds)
+		return -EINVAL;
+	cmd_size = sizeof(struct epoll_ctl_cmd) * ncmds;
+	kcmds = kmalloc(cmd_size, GFP_KERNEL);
+	if (!kcmds)
+		return -ENOMEM;
+	if (copy_from_user(kcmds, cmds, cmd_size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	for (i = 0; i < ncmds; i++) {
+		struct epoll_event ev = (struct epoll_event) {
+			.events = kcmds[i].events,
+			.data = kcmds[i].data,
+		};
+		if (kcmds[i].flags) {
+			kcmds[i].error_hint = -EINVAL;
+			goto copy;
+		}
+		kcmds[i].error_hint = ep_ctl_do(epfd, kcmds[i].op,
+						kcmds[i].fd, ev);
+		if (kcmds[i].error_hint)
+			goto copy;
+		ret++;
+	}
+copy:
+	r = copy_to_user(cmds, kcmds,
+			 sizeof(struct epoll_ctl_cmd) * ncmds);
+	/* Failing to copy the command results back will leave
+	 * userspace no way to know the actual error code, but we still
+	 * report the number of succeeded commands with ret, so it's
+	 * not a big problem. Ignore it for now.
+	 */
+	(void) r;
+out:
+	kfree(kcmds);
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		       struct epoll_event __user *, events,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 85893d7..117822c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -12,6 +12,7 @@
 #define _LINUX_SYSCALLS_H
 
 struct epoll_event;
+struct epoll_ctl_cmd;
 struct iattr;
 struct inode;
 struct iocb;
@@ -630,6 +631,9 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
 				int maxevents, int timeout,
 				const sigset_t __user *sigmask,
 				size_t sigsetsize);
+asmlinkage long sys_epoll_ctl_batch(int epfd, int flags,
+				    int ncmds,
+				    struct epoll_ctl_cmd __user *cmds);
 asmlinkage long sys_gethostname(char __user *name, int len);
 asmlinkage long sys_sethostname(char __user *name, int len);
 asmlinkage long sys_setdomainname(char __user *name, int len);
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2..bbdce3d 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -18,6 +18,8 @@
 #include <linux/fcntl.h>
 #include <linux/types.h>
 
+#include <linux/signal.h>
+
 /* Flags for epoll_create1.  */
 #define EPOLL_CLOEXEC O_CLOEXEC
 
@@ -61,6 +63,15 @@ struct epoll_event {
 	__u64 data;
 } EPOLL_PACKED;
 
+struct epoll_ctl_cmd {
+	int flags;
+	int op;
+	int fd;
+	__u32 events;
+	__u64 data;
+	int error_hint;
+} EPOLL_PACKED;
+
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
-- 
1.9.3
