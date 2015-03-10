From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v4 6/9] epoll: Add implementation for epoll_pwait1
Date: Tue, 10 Mar 2015 09:49:12 +0800
Message-ID: <1425952155-27603-7-git-send-email-famz@redhat.com>
References: <1425952155-27603-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425952155-27603-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

This is the new implementation for poll which has a flags parameter and
packs a number of parameters into a structure.

The main advantage of it over existing epoll_pwait is about timeout:
epoll_pwait expects a relative millisecond value, while epoll_pwait1
accepts 1) a timespec which is in nanosecond granularity; 2) a clockid
to allow using a clock other than CLOCK_MONOTONIC.

The 'flags' field in params is reserved for now and must be zero. The
next step would be allowing absolute timeout value.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 fs/eventpoll.c                 | 39 ++++++++++++++++++++++++++++++++++++++-
 include/linux/syscalls.h       |  5 +++++
 include/uapi/linux/eventpoll.h |  8 ++++++++
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 54dc63f..06a59fc 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2085,7 +2085,6 @@ SYSCALL_DEFINE4(epoll_ctl_batch, int, epfd, int, flags,
 	cmd_size = sizeof(struct epoll_ctl_cmd) * ncmds;
 	/* TODO: optimize for small arguments like select/poll with a stack
 	 * allocated buffer */
-
 	kcmds = kmalloc(cmd_size, GFP_KERNEL);
 	if (!kcmds)
 		return -ENOMEM;
@@ -2119,6 +2118,44 @@ out:
 	return ret;
 }
 
+SYSCALL_DEFINE5(epoll_pwait1, int, epfd, int, flags,
+		struct epoll_event __user *, events,
+		int, maxevents,
+		struct epoll_wait_params __user *, params)
+{
+	struct epoll_wait_params p;
+	ktime_t kt = { 0 };
+	sigset_t sigmask;
+	struct timespec timeout;
+
+	if (flags)
+		return -EINVAL;
+	if (!params)
+		return -EINVAL;
+	if (copy_from_user(&p, params, sizeof(p)))
+		return -EFAULT;
+	if (p.size != sizeof(p))
+		return -EINVAL;
+	if (p.sigmask) {
+		if (copy_from_user(&sigmask, p.sigmask, sizeof(sigmask)))
+			return -EFAULT;
+		if (p.sigsetsize != sizeof(p.sigmask))
+			return -EINVAL;
+	}
+	if (p.timeout) {
+		if (copy_from_user(&timeout, p.timeout, sizeof(timeout)))
+			return -EFAULT;
+		if (!timespec_valid(&timeout))
+			return -EINVAL;
+		kt = timespec_to_ktime(timeout);
+	} else {
+		kt = ns_to_ktime(-1);
+	}
+
+	return epoll_pwait_do(epfd, events, maxevents, p.clockid,
+			      kt, p.sigmask ? &sigmask : NULL);
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			struct epoll_event __user *, events,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7d784e3..a4823d9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -13,6 +13,7 @@
 
 struct epoll_event;
 struct epoll_ctl_cmd;
+struct epoll_wait_params;
 struct iattr;
 struct inode;
 struct iocb;
@@ -635,6 +636,10 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
 				int maxevents, int timeout,
 				const sigset_t __user *sigmask,
 				size_t sigsetsize);
+asmlinkage long sys_epoll_pwait1(int epfd, int flags,
+				 struct epoll_event __user *events,
+				 int maxevents,
+				 struct epoll_wait_params __user *params);
 asmlinkage long sys_epoll_ctl_batch(int epfd, int flags,
 				    int ncmds,
 				    struct epoll_ctl_cmd __user *cmds);
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 4e18b17..05ae035 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -72,6 +72,14 @@ struct epoll_ctl_cmd {
 	int result;
 } EPOLL_PACKED;
 
+struct epoll_wait_params {
+	int size;
+	int clockid;
+	struct timespec *timeout;
+	sigset_t *sigmask;
+	size_t sigsetsize;
+} EPOLL_PACKED;
+
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
-- 
1.9.3
