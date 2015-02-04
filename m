From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC v2 2/7] epoll: Specify clockid explicitly
Date: Wed,  4 Feb 2015 18:36:48 +0800
Message-ID: <1423046213-7043-3-git-send-email-famz@redhat.com>
References: <1423046213-7043-1-git-send-email-famz@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423046213-7043-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Later we will add clockid in the interface, so let's start using explicit
clockid internally. Now we specify CLOCK_MONOTONIC, which is the same as before.

Signed-off-by: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/eventpoll.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4cf359d..01f469a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1570,7 +1570,7 @@ static int ep_send_events(struct eventpoll *ep,
  *          error code, in case of error.
  */
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
-		   int maxevents, const ktime_t timeout)
+		   int maxevents, int clockid, const ktime_t timeout)
 {
 	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
@@ -1624,7 +1624,8 @@ fetch_events:
 			}
 
 			spin_unlock_irqrestore(&ep->lock, flags);
-			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+			if (!schedule_hrtimeout_range_clock(to, slack,
+						HRTIMER_MODE_ABS, clockid))
 				timed_out = 1;
 
 			spin_lock_irqsave(&ep->lock, flags);
@@ -1945,7 +1946,8 @@ error_return:
 }
 
 static inline int epoll_wait_do(int epfd, struct epoll_event __user *events,
-				int maxevents, const ktime_t timeout)
+				int maxevents, int clockid,
+				const ktime_t timeout)
 {
 	int error;
 	struct fd f;
@@ -1979,7 +1981,7 @@ static inline int epoll_wait_do(int epfd, struct epoll_event __user *events,
 	ep = f.file->private_data;
 
 	/* Time to fish for events ... */
-	error = ep_poll(ep, events, maxevents, timeout);
+	error = ep_poll(ep, events, maxevents, clockid, timeout);
 
 error_fput:
 	fdput(f);
@@ -1994,12 +1996,13 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 		int, maxevents, int, timeout)
 {
 	ktime_t kt = ms_to_ktime(timeout);
-	return epoll_wait_do(epfd, events, maxevents, kt);
+	return epoll_wait_do(epfd, events, maxevents, CLOCK_MONOTONIC, kt);
 }
 
 static inline int epoll_pwait_do(int epfd, struct epoll_event __user *events,
-				 int maxevents, ktime_t timeout,
-				 sigset_t *sigmask, size_t sigsetsize)
+				 int maxevents,
+				 int clockid, ktime_t timeout,
+				 sigset_t *sigmask)
 {
 	int error;
 	sigset_t sigsaved;
@@ -2013,7 +2016,7 @@ static inline int epoll_pwait_do(int epfd, struct epoll_event __user *events,
 		set_current_blocked(sigmask);
 	}
 
-	error = epoll_wait_do(epfd, events, maxevents, timeout);
+	error = epoll_wait_do(epfd, events, maxevents, clockid, timeout);
 
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
@@ -2050,8 +2053,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
 	}
-	return epoll_pwait_do(epfd, events, maxevents, kt,
-			      sigmask ? &ksigmask : NULL, sigsetsize);
+	return epoll_pwait_do(epfd, events, maxevents, CLOCK_MONOTONIC, kt,
+			      sigmask ? &ksigmask : NULL);
 }
 
 #ifdef CONFIG_COMPAT
@@ -2073,8 +2076,8 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		sigset_from_compat(&ksigmask, &csigmask);
 	}
 
-	return epoll_pwait_do(epfd, events, maxevents, kt,
-			      sigmask ? &ksigmask : NULL, sigsetsize);
+	return epoll_pwait_do(epfd, events, maxevents, CLOCK_MONOTONIC, kt,
+			      sigmask ? &ksigmask : NULL);
 }
 #endif
 
-- 
1.9.3
