From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Tue, 17 Feb 2015 19:33:42 +0000 (GMT)
Message-ID: <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com>
References: <cover.1424200151.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1424200151.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Epoll file descriptors that are added to a shared wakeup source are always
added in a non-exclusive manner. That means that when we have multiple epoll
fds attached to a shared wakeup source they are all woken up. This can
lead to excessive cpu usage and uneven load distribution.

This patch introduces two new 'events' flags that are intended to be used
with EPOLL_CTL_ADD operations. EPOLLEXCLUSIVE, adds the epoll fd to the event
source in an exclusive manner such that the minimum number of threads are
woken. EPOLLROUNDROBIN, which depends on EPOLLEXCLUSIVE also being set, can
also be added to the 'events' flag, such that we round robin through the set
of waiting threads.

An implementation note is that in the epoll wakeup routine,
'ep_poll_callback()', if EPOLLROUNDROBIN is set, we return 1, for a successful
wakeup, only when there are current waiters. The idea is to use this additional
heuristic in order minimize wakeup latencies.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c                 | 25 ++++++++++++++++++++-----
 include/uapi/linux/eventpoll.h |  6 ++++++
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d77f944..382c832 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -92,7 +92,8 @@
  */
 
 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET | \
+			 EPOLLEXCLUSIVE | EPOLLROUNDROBIN)
 
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -1002,6 +1003,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	unsigned long flags;
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
+	int ewake = 0;
 
 	if ((unsigned long)key & POLLFREE) {
 		ep_pwq_from_wait(wait)->whead = NULL;
@@ -1066,8 +1068,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 	 * wait list.
 	 */
-	if (waitqueue_active(&ep->wq))
+	if (waitqueue_active(&ep->wq)) {
+		ewake = 1;
 		wake_up_locked(&ep->wq);
+	}
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
@@ -1078,6 +1082,8 @@ out_unlock:
 	if (pwake)
 		ep_poll_safewake(&ep->poll_wait);
 
+	if (epi->event.events & EPOLLROUNDROBIN)
+		return ewake;
 	return 1;
 }
 
@@ -1095,7 +1101,12 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		if (epi->event.events & EPOLLROUNDROBIN)
+			add_wait_queue_rr(whead, &pwq->wait);
+		else if (epi->event.events & EPOLLEXCLUSIVE)
+			add_wait_queue_exclusive(whead, &pwq->wait);
+		else
+			add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
@@ -1820,8 +1831,7 @@ SYSCALL_DEFINE1(epoll_create, int, size)
 SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		struct epoll_event __user *, event)
 {
-	int error;
-	int full_check = 0;
+	int error, full_check = 0, wait_flags = 0;
 	struct fd f, tf;
 	struct eventpoll *ep;
 	struct epitem *epi;
@@ -1861,6 +1871,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	if (f.file == tf.file || !is_file_epoll(f.file))
 		goto error_tgt_fput;
 
+	wait_flags = epds.events & (EPOLLEXCLUSIVE | EPOLLROUNDROBIN);
+	if (wait_flags && ((op == EPOLL_CTL_MOD) || ((op == EPOLL_CTL_ADD) &&
+	    ((wait_flags == EPOLLROUNDROBIN) || (is_file_epoll(tf.file))))))
+		goto error_tgt_fput;
+
 	/*
 	 * At this point it is safe to assume that the "private_data" contains
 	 * our own data structure.
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2..10260a1 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -26,6 +26,12 @@
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/* Balance wakeups for a shared event source */
+#define EPOLLROUNDROBIN (1 << 27)
+
+/* Add exclusively */
+#define EPOLLEXCLUSIVE (1 << 28)
+
 /*
  * Request the handling of system wakeup events so as to prevent system suspends
  * from happening while those events are being processed.
-- 
1.8.2.rc2
