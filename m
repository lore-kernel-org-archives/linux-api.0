From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC v3 1/7] epoll: Extract epoll_wait_do and epoll_pwait_do
Date: Fri, 13 Feb 2015 17:03:57 +0800
Message-ID: <1423818243-15410-2-git-send-email-famz@redhat.com>
References: <1423818243-15410-1-git-send-email-famz@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423818243-15410-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

In preparation of new epoll syscalls, this patch allows reusing the code from
epoll_pwait implementation. The new functions uses ktime_t for more accuracy.

Signed-off-by: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/eventpoll.c | 162 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 75 insertions(+), 87 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d77f944..4cf359d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1554,17 +1554,6 @@ static int ep_send_events(struct eventpoll *ep,
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, false);
 }
 
-static inline struct timespec ep_set_mstimeout(long ms)
-{
-	struct timespec now, ts = {
-		.tv_sec = ms / MSEC_PER_SEC,
-		.tv_nsec = NSEC_PER_MSEC * (ms % MSEC_PER_SEC),
-	};
-
-	ktime_get_ts(&now);
-	return timespec_add_safe(now, ts);
-}
-
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller supplied
  *           event buffer.
@@ -1573,17 +1562,15 @@ static inline struct timespec ep_set_mstimeout(long ms)
  * @events: Pointer to the userspace buffer where the ready events should be
  *          stored.
  * @maxevents: Size (in terms of number of events) of the caller event buffer.
- * @timeout: Maximum timeout for the ready events fetch operation, in
- *           milliseconds. If the @timeout is zero, the function will not block,
- *           while if the @timeout is less than zero, the function will block
- *           until at least one event has been retrieved (or an error
- *           occurred).
+ * @timeout: Maximum timeout for the ready events fetch operation.  If 0, the
+ *           function will not block. If negative, the function will block until
+ *           at least one event has been retrieved (or an error occurred).
  *
  * Returns: Returns the number of ready events which have been fetched, or an
  *          error code, in case of error.
  */
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
-		   int maxevents, long timeout)
+		   int maxevents, const ktime_t timeout)
 {
 	int res = 0, eavail, timed_out = 0;
 	unsigned long flags;
@@ -1591,13 +1578,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 	wait_queue_t wait;
 	ktime_t expires, *to = NULL;
 
-	if (timeout > 0) {
-		struct timespec end_time = ep_set_mstimeout(timeout);
-
-		slack = select_estimate_accuracy(&end_time);
-		to = &expires;
-		*to = timespec_to_ktime(end_time);
-	} else if (timeout == 0) {
+	if (!ktime_to_ns(timeout)) {
 		/*
 		 * Avoid the unnecessary trip to the wait queue loop, if the
 		 * caller specified a non blocking operation.
@@ -1605,6 +1586,15 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		timed_out = 1;
 		spin_lock_irqsave(&ep->lock, flags);
 		goto check_events;
+	} else if (ktime_to_ns(timeout) > 0) {
+		struct timespec now, end_time;
+
+		ktime_get_ts(&now);
+		end_time = timespec_add_safe(now, ktime_to_timespec(timeout));
+
+		slack = select_estimate_accuracy(&end_time);
+		to = &expires;
+		*to = timespec_to_ktime(end_time);
 	}
 
 fetch_events:
@@ -1954,12 +1944,8 @@ error_return:
 	return error;
 }
 
-/*
- * Implement the event wait interface for the eventpoll file. It is the kernel
- * part of the user space epoll_wait(2).
- */
-SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
-		int, maxevents, int, timeout)
+static inline int epoll_wait_do(int epfd, struct epoll_event __user *events,
+				int maxevents, const ktime_t timeout)
 {
 	int error;
 	struct fd f;
@@ -2002,91 +1988,93 @@ error_fput:
 
 /*
  * Implement the event wait interface for the eventpoll file. It is the kernel
+ * part of the user space epoll_wait(2).
+ */
+SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
+		int, maxevents, int, timeout)
+{
+	ktime_t kt = ms_to_ktime(timeout);
+	return epoll_wait_do(epfd, events, maxevents, kt);
+}
+
+static inline int epoll_pwait_do(int epfd, struct epoll_event __user *events,
+				 int maxevents, ktime_t timeout,
+				 sigset_t *sigmask, size_t sigsetsize)
+{
+	int error;
+	sigset_t sigsaved;
+
+	/*
+	 * If the caller wants a certain signal mask to be set during the wait,
+	 * we apply it here.
+	 */
+	if (sigmask) {
+		sigsaved = current->blocked;
+		set_current_blocked(sigmask);
+	}
+
+	error = epoll_wait_do(epfd, events, maxevents, timeout);
+
+	/*
+	 * If we changed the signal mask, we need to restore the original one.
+	 * In case we've got a signal while waiting, we do not restore the
+	 * signal mask yet, and we allow do_signal() to deliver the signal on
+	 * the way back to userspace, before the signal mask is restored.
+	 */
+	if (sigmask) {
+		if (error == -EINTR) {
+			memcpy(&current->saved_sigmask, &sigsaved,
+			       sizeof(sigsaved));
+			set_restore_sigmask();
+		} else
+			set_current_blocked(&sigsaved);
+	}
+
+	return error;
+}
+
+/*
+ * Implement the event wait interface for the eventpoll file. It is the kernel
  * part of the user space epoll_pwait(2).
  */
 SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	int error;
-	sigset_t ksigmask, sigsaved;
+	ktime_t kt = ms_to_ktime(timeout);
+	sigset_t ksigmask;
 
-	/*
-	 * If the caller wants a certain signal mask to be set during the wait,
-	 * we apply it here.
-	 */
 	if (sigmask) {
 		if (sigsetsize != sizeof(sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigsaved = current->blocked;
-		set_current_blocked(&ksigmask);
 	}
-
-	error = sys_epoll_wait(epfd, events, maxevents, timeout);
-
-	/*
-	 * If we changed the signal mask, we need to restore the original one.
-	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on
-	 * the way back to userspace, before the signal mask is restored.
-	 */
-	if (sigmask) {
-		if (error == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
-			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
-	}
-
-	return error;
+	return epoll_pwait_do(epfd, events, maxevents, kt,
+			      sigmask ? &ksigmask : NULL, sigsetsize);
 }
 
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
-			struct epoll_event __user *, events,
-			int, maxevents, int, timeout,
-			const compat_sigset_t __user *, sigmask,
-			compat_size_t, sigsetsize)
+		       struct epoll_event __user *, events,
+		       int, maxevents, int, timeout,
+		       const compat_sigset_t __user *, sigmask,
+		       compat_size_t, sigsetsize)
 {
-	long err;
 	compat_sigset_t csigmask;
-	sigset_t ksigmask, sigsaved;
+	sigset_t ksigmask;
+	ktime_t kt = ms_to_ktime(timeout);
 
-	/*
-	 * If the caller wants a certain signal mask to be set during the wait,
-	 * we apply it here.
-	 */
 	if (sigmask) {
 		if (sigsetsize != sizeof(compat_sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigsaved = current->blocked;
-		set_current_blocked(&ksigmask);
 	}
 
-	err = sys_epoll_wait(epfd, events, maxevents, timeout);
-
-	/*
-	 * If we changed the signal mask, we need to restore the original one.
-	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on
-	 * the way back to userspace, before the signal mask is restored.
-	 */
-	if (sigmask) {
-		if (err == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
-			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
-	}
-
-	return err;
+	return epoll_pwait_do(epfd, events, maxevents, kt,
+			      sigmask ? &ksigmask : NULL, sigsetsize);
 }
 #endif
 
-- 
1.9.3
