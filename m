From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 8/9] epoll: Add compat version implementation of epoll_pwait1
Date: Tue, 10 Mar 2015 09:49:14 +0800
Message-ID: <1425952155-27603-9-git-send-email-famz@redhat.com>
References: <1425952155-27603-1-git-send-email-famz@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425952155-27603-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/eventpoll.c         | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/compat.h |  6 ++++++
 2 files changed, 56 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 06a59fc..b837ea4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2178,6 +2178,56 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	return epoll_pwait_do(epfd, events, maxevents, CLOCK_MONOTONIC, kt,
 			      sigmask ? &ksigmask : NULL);
 }
+
+struct compat_epoll_wait_params {
+	int size;
+	int clockid;
+	compat_uptr_t timeout;
+	compat_uptr_t sigmask;
+	compat_size_t sigsetsize;
+} EPOLL_PACKED;
+
+COMPAT_SYSCALL_DEFINE5(epoll_pwait1, int, epfd, int, flags,
+		       struct epoll_event __user *, events,
+		       int, maxevents,
+		       struct compat_epoll_wait_params __user *, params)
+{
+	struct compat_epoll_wait_params p;
+
+	ktime_t kt = { 0 };
+	sigset_t sigmask;
+	compat_sigset_t compat_sigmask;
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
+		if (copy_from_user(&compat_sigmask, compat_ptr(p.sigmask),
+				   sizeof(sigmask)))
+			return -EFAULT;
+		if (p.sigsetsize != sizeof(p.sigmask))
+			return -EINVAL;
+		sigset_from_compat(&sigmask, &compat_sigmask);
+	}
+	if (p.timeout) {
+		if (compat_get_timespec(&timeout, compat_ptr(p.timeout)))
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
 #endif
 
 static int __init eventpoll_init(void)
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ab25814..649c5b2 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -452,6 +452,12 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 			const compat_sigset_t __user *sigmask,
 			compat_size_t sigsetsize);
 
+struct compat_epoll_wait_params;
+asmlinkage long compat_sys_epoll_pwait1(int epfd, int flags,
+			struct epoll_event __user *events,
+			int maxevents,
+			struct compat_epoll_wait_params __user *params);
+
 asmlinkage long compat_sys_utime(const char __user *filename,
 				 struct compat_utimbuf __user *t);
 asmlinkage long compat_sys_utimensat(unsigned int dfd,
-- 
1.9.3
