From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC v3 4/7] epoll: Add implementation for epoll_ctl_batch
Date: Fri, 13 Feb 2015 17:04:00 +0800
Message-ID: <1423818243-15410-5-git-send-email-famz@redhat.com>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423818243-15410-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

This new syscall is a batched version of epoll_ctl. It will execute each
command as specified in cmds in given order, and stop at first failure
or upon completion of all commands.

Signed-off-by: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/eventpoll.c                 | 48 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h       |  4 ++++
 include/uapi/linux/eventpoll.h | 11 ++++++++++
 3 files changed, 63 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 6a2b0a4..12e2e63 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2069,6 +2069,54 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
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
+			kcmds[i].result = -EINVAL;
+			goto copy;
+		}
+		kcmds[i].result = ep_ctl_do(epfd, kcmds[i].op,
+					    kcmds[i].fd, ev);
+		if (kcmds[i].result)
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
index 76d1e38..7d784e3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -12,6 +12,7 @@
 #define _LINUX_SYSCALLS_H
 
 struct epoll_event;
+struct epoll_ctl_cmd;
 struct iattr;
 struct inode;
 struct iocb;
@@ -634,6 +635,9 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
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
index bc81fb2..4e18b17 100644
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
+	int result;
+} EPOLL_PACKED;
+
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
-- 
1.9.3
