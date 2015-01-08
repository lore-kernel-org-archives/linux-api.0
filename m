From: Fam Zheng <famz@redhat.com>
Subject: [RESEND PATCH 2/3] epoll: Add implementation for epoll_pwait1
Date: Thu,  8 Jan 2015 17:16:02 +0800
Message-ID: <1420708563-21743-3-git-send-email-famz@redhat.com>
References: <1420708563-21743-1-git-send-email-famz@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1420708563-21743-1-git-send-email-famz@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Miklos Szeredi <mszeredi@suse.cz>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Fam Zheng <famz@redhat.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fabian Frederick <fabf@skynet.be>, Josh
List-Id: linux-api@vger.kernel.org

Unlike ppoll(2), which accepts a timespec argument "timeout_ts" to
specify the timeout, epoll_wait(2) and epoll_pwait(2) expect a
microsecond timeout in int type.

This is an obstacle for applications in switching from ppoll to epoll,
if they want nanosecond resolution in their event loops.

Therefore, adding this variation of epoll wait interface, giving user an
option with *both* advantages, is a reasonable move: there could be
constantly scalable performance polling many fds, while having a
nanosecond timeout precision (assuming it has properly set up timer
slack with prctl(2)).

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 fs/eventpoll.c           | 24 ++++++++++++++++++++++++
 include/linux/syscalls.h |  4 ++++
 kernel/sys_ni.c          |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 117ba72..ee69fd4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2066,6 +2066,30 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 			      sigmask ? &ksigmask : NULL, sigsetsize);
 }
 
+SYSCALL_DEFINE6(epoll_pwait1, int, epfd, struct epoll_event __user *, events,
+		int, maxevents,
+		struct timespec __user *, timeout,
+		const sigset_t __user *, sigmask,
+		size_t, sigsetsize)
+{
+	struct timespec ts;
+	sigset_t ksigmask;
+
+	if (timeout && copy_from_user(&ts, timeout, sizeof(ts)))
+		return -EFAULT;
+
+	if (sigmask) {
+		if (sigsetsize != sizeof(sigset_t))
+			return -EINVAL;
+		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
+			return -EFAULT;
+	}
+	return epoll_pwait_do(epfd, events, maxevents,
+			      timeout ? &ts : NULL,
+			      sigmask ? &ksigmask : NULL,
+			      sigsetsize);
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		       struct epoll_event __user *, events,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 85893d7..3e0ed0b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -630,6 +630,10 @@ asmlinkage long sys_epoll_pwait(int epfd, struct epoll_event __user *events,
 				int maxevents, int timeout,
 				const sigset_t __user *sigmask,
 				size_t sigsetsize);
+asmlinkage long sys_epoll_pwait1(int epfd, struct epoll_event __user *events,
+				 int maxevents, struct timespec __user *ts,
+				 const sigset_t __user *sigmask,
+				 size_t sigsetsize);
 asmlinkage long sys_gethostname(char __user *name, int len);
 asmlinkage long sys_sethostname(char __user *name, int len);
 asmlinkage long sys_setdomainname(char __user *name, int len);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5adcb0a..1044158 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -229,3 +229,6 @@ cond_syscall(sys_bpf);
 
 /* execveat */
 cond_syscall(sys_execveat);
+
+/* epoll_pwait1 */
+cond_syscall(sys_epoll_pwait1);
-- 
1.9.3

