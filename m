From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v4 2/9] epoll: Specify clockid explicitly
Date: Tue, 10 Mar 2015 09:49:08 +0800
Message-ID: <1425952155-27603-3-git-send-email-famz@redhat.com>
References: <1425952155-27603-1-git-send-email-famz@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1425952155-27603-1-git-send-email-famz@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, David Herrmann <dh.herrmann@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Miklos Szeredi <mszeredi@suse.cz>, David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>, "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Theodore Ts'o <tytso@mit.edu>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Rashika Kheria <rashika.kheria@gmail.com>, Hugh Dickins <hughd@google.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fam Zheng <famz@redhat.com>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

Later we will add clockid in the interface, so let's start using explicit
clockid internally. Now we specify CLOCK_MONOTONIC, which is the same as before.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 fs/eventpoll.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7dfabeb..957d1d0 100644
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
@@ -1578,6 +1578,8 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 	wait_queue_t wait;
 	ktime_t expires, *to = NULL;
 
+	if (clockid != CLOCK_MONOTONIC && clockid != CLOCK_REALTIME)
+		return -EINVAL;
 	if (!ktime_to_ns(timeout)) {
 		/*
 		 * Avoid the unnecessary trip to the wait queue loop, if the
@@ -1624,7 +1626,8 @@ fetch_events:
 			}
 
 			spin_unlock_irqrestore(&ep->lock, flags);
-			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
+			if (!schedule_hrtimeout_range_clock(to, slack,
+						HRTIMER_MODE_ABS, clockid))
 				timed_out = 1;
 
 			spin_lock_irqsave(&ep->lock, flags);
@@ -1945,7 +1948,8 @@ error_return:
 }
 
 static inline int epoll_wait_do(int epfd, struct epoll_event __user *events,
-				int maxevents, const ktime_t timeout)
+				int maxevents, int clockid,
+				const ktime_t timeout)
 {
 	int error;
 	struct fd f;
@@ -1979,7 +1983,7 @@ static inline int epoll_wait_do(int epfd, struct epoll_event __user *events,
 	ep = f.file->private_data;
 
 	/* Time to fish for events ... */
-	error = ep_poll(ep, events, maxevents, timeout);
+	error = ep_poll(ep, events, maxevents, clockid, timeout);
 
 error_fput:
 	fdput(f);
@@ -1994,12 +1998,13 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
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
@@ -2013,7 +2018,7 @@ static inline int epoll_pwait_do(int epfd, struct epoll_event __user *events,
 		set_current_blocked(sigmask);
 	}
 
-	error = epoll_wait_do(epfd, events, maxevents, timeout);
+	error = epoll_wait_do(epfd, events, maxevents, clockid, timeout);
 
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
@@ -2050,8 +2055,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
 	}
-	return epoll_pwait_do(epfd, events, maxevents, kt,
-			      sigmask ? &ksigmask : NULL, sigsetsize);
+	return epoll_pwait_do(epfd, events, maxevents, CLOCK_MONOTONIC, kt,
+			      sigmask ? &ksigmask : NULL);
 }
 
 #ifdef CONFIG_COMPAT
@@ -2073,8 +2078,8 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
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

