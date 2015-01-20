From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC 5/6] epoll: Add implementation for epoll_mod_wait
Date: Tue, 20 Jan 2015 17:57:57 +0800
Message-ID: <1421747878-30744-6-git-send-email-famz@redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421747878-30744-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

This syscall is a sequence of

1) a number of epoll_ctl calls
2) a epoll_pwait, with timeout enhancement.

The epoll_ctl operations are embeded so that application doesn't have to use
separate syscalls to insert/delete/update the fds before poll. It is more
efficient if the set of fds varies from one poll to another, which is the
common pattern for certain applications. For example, depending on the input
buffer status, a data reading program may decide to temporarily not polling an
fd.

Because the enablement of batching in this interface, even that regular
epoll_ctl call sequence, which manipulates several fds, can be optimized to one
single epoll_ctl_wait (while specifying spec=NULL to skip the poll part).

The only complexity is returning the result of each operation.  For each
epoll_mod_cmd in cmds, the field "error" is an output field that will be stored
the return code *iff* the command is executed (0 for success and -errno of the
equivalent epoll_ctl call), and will be left unchanged if the command is not
executed because some earlier error, for example due to failure of
copy_from_user to copy the array.

Applications can utilize this fact to do error handling: they could initialize
all the epoll_mod_wait.error to a positive value, which is by definition not a
possible output value from epoll_mod_wait. Then when the syscall returned, they
know whether or not the command is executed by comparing each error with the
init value, if they're different, they have the result of the command.
More roughly, they can put any non-zero and not distinguish "not run" from
failure.

Also, timeout parameter is enhanced: timespec is used, compared to the old ms
scalar. This provides higher precision. The parameter field in struct
epoll_wait_spec, "clockid", also makes it possible for users to use a different
clock than the default when it makes more sense.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 fs/eventpoll.c           | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |  5 ++++
 2 files changed, 65 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e7a116d..2cc22c9 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2067,6 +2067,66 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 			      sigmask ? &ksigmask : NULL);
 }
 
+SYSCALL_DEFINE5(epoll_mod_wait, int, epfd, int, flags,
+		int, ncmds, struct epoll_mod_cmd __user *, cmds,
+		struct epoll_wait_spec __user *, spec)
+{
+	struct epoll_mod_cmd *kcmds = NULL;
+	int i, ret = 0;
+	int cmd_size = sizeof(struct epoll_mod_cmd) * ncmds;
+
+	if (flags)
+		return -EINVAL;
+	if (ncmds) {
+		if (!cmds)
+			return -EINVAL;
+		kcmds = kmalloc(cmd_size, GFP_KERNEL);
+		if (!kcmds)
+			return -ENOMEM;
+		if (copy_from_user(kcmds, cmds, cmd_size)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+	for (i = 0; i < ncmds; i++) {
+		struct epoll_event ev = (struct epoll_event) {
+			.events = kcmds[i].events,
+			.data = kcmds[i].data,
+		};
+		if (kcmds[i].flags) {
+			kcmds[i].error = ret = -EINVAL;
+			goto out;
+		}
+		kcmds[i].error = ret = ep_ctl_do(epfd, kcmds[i].op, kcmds[i].fd, ev);
+		if (ret)
+			goto out;
+	}
+	if (spec) {
+		sigset_t ksigmask;
+		struct epoll_wait_spec kspec;
+		ktime_t timeout;
+
+		if(copy_from_user(&kspec, spec, sizeof(struct epoll_wait_spec)))
+			return -EFAULT;
+		if (kspec.sigmask) {
+			if (kspec.sigsetsize != sizeof(sigset_t))
+				return -EINVAL;
+			if (copy_from_user(&ksigmask, kspec.sigmask, sizeof(ksigmask)))
+				return -EFAULT;
+		}
+		timeout = timespec_to_ktime(kspec.timeout);
+		ret = epoll_pwait_do(epfd, kspec.events, kspec.maxevents,
+				     kspec.clockid, timeout,
+				     kspec.sigmask ? &ksigmask : NULL);
+	}
+
+out:
+	if (ncmds && copy_to_user(cmds, kcmds, cmd_size))
+		return -EFAULT;
+	kfree(kcmds);
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		       struct epoll_event __user *, events,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 85893d7..7156c80 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -12,6 +12,8 @@
 #define _LINUX_SYSCALLS_H
 
 struct epoll_event;
+struct epoll_mod_cmd;
+struct epoll_wait_spec;
 struct iattr;
 struct inode;
 struct iocb;
@@ -630,6 +632,9 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
 				int maxevents, int timeout,
 				const sigset_t __user *sigmask,
 				size_t sigsetsize);
+asmlinkage long sys_epoll_mod_wait(int epfd, int flags,
+				   int ncmds, struct epoll_mod_cmd __user * cmds,
+				   struct epoll_wait_spec __user * spec);
 asmlinkage long sys_gethostname(char __user *name, int len);
 asmlinkage long sys_sethostname(char __user *name, int len);
 asmlinkage long sys_setdomainname(char __user *name, int len);
-- 
1.9.3
