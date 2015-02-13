From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC v3 6/7] epoll: Add implementation for epoll_pwait1
Date: Fri, 13 Feb 2015 17:04:02 +0800
Message-ID: <1423818243-15410-7-git-send-email-famz@redhat.com>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423818243-15410-1-git-send-email-famz@redhat.com>
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
 fs/eventpoll.c                 | 27 +++++++++++++++++++++++++++
 include/linux/syscalls.h       |  5 +++++
 include/uapi/linux/eventpoll.h |  7 +++++++
 3 files changed, 39 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12e2e63..cc51e8c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2117,6 +2117,33 @@ out:
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
+
+	if (flags)
+		return -EINVAL;
+	if (!params)
+		return -EINVAL;
+	if (copy_from_user(&p, params, sizeof(p)))
+		return -EFAULT;
+	if (p.sigmask) {
+		if (copy_from_user(&sigmask, p.sigmask, sizeof(sigmask)))
+			return -EFAULT;
+		if (p.sigsetsize != sizeof(p.sigmask))
+			return -EINVAL;
+	}
+	kt = timespec_to_ktime(p.timeout);
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
index 4e18b17..d35c591 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -72,6 +72,13 @@ struct epoll_ctl_cmd {
 	int result;
 } EPOLL_PACKED;
 
+struct epoll_wait_params {
+	int clockid;
+	struct timespec timeout;
+	sigset_t *sigmask;
+	size_t sigsetsize;
+} EPOLL_PACKED;
+
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
-- 
1.9.3
