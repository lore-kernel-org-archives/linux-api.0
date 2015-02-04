From: Fam Zheng <famz@redhat.com>
Subject: [PATCH RFC v2 6/7] epoll: Add implementation for epoll_pwait1
Date: Wed,  4 Feb 2015 18:36:52 +0800
Message-ID: <1423046213-7043-7-git-send-email-famz@redhat.com>
References: <1423046213-7043-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423046213-7043-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

This is the new implementation for poll which uses timespec as timeout,
and has a flags parameter.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 fs/eventpoll.c           | 34 ++++++++++++++++++++++++++++++++++
 include/linux/syscalls.h |  5 +++++
 2 files changed, 39 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4eb40e0..59b2db9 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2115,6 +2115,40 @@ out:
 	return ret;
 }
 
+SYSCALL_DEFINE6(epoll_pwait1, int, epfd, int, flags,
+		struct epoll_event __user *, events,
+		int, maxevents, struct timespec __user *, timeout,
+		void __user *, sig)
+{
+	size_t sigsetsize = 0;
+	sigset_t ksigmask;
+	sigset_t __user *sigmask = NULL;
+	struct timespec kts;
+	ktime_t kt = { 0 };
+
+	if (flags)
+		return -EINVAL;
+	if (sig) {
+		if (!access_ok(VERIFY_READ, sig, sizeof(void *)+sizeof(size_t))
+		    || __get_user(sigmask, (sigset_t __user * __user *)sig)
+		    || __get_user(sigsetsize,
+				  (size_t __user *)(sig+sizeof(void *))))
+			return -EFAULT;
+		if (sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
+			return -EFAULT;
+	}
+	if (timeout) {
+		if (copy_from_user(&kts, timeout, sizeof(kts)))
+			return -EFAULT;
+		kt = timespec_to_ktime(kts);
+	}
+
+	return epoll_pwait_do(epfd, events, maxevents, CLOCK_MONOTONIC,
+			      kt, &ksigmask);
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		       struct epoll_event __user *, events,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 117822c..0c3ecdb 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -631,6 +631,11 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
 				int maxevents, int timeout,
 				const sigset_t __user *sigmask,
 				size_t sigsetsize);
+asmlinkage long sys_epoll_pwait1(int epfd, int flags,
+				 struct epoll_event __user *events,
+				 int maxevents,
+				 struct timespec __user *timeout,
+				 void __user *sig);
 asmlinkage long sys_epoll_ctl_batch(int epfd, int flags,
 				    int ncmds,
 				    struct epoll_ctl_cmd __user *cmds);
-- 
1.9.3
