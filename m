From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] epoll: add EPOLLEXCLUSIVE flag
Date: Mon,  7 Dec 2015 22:23:47 -0500
Message-ID: <e26b962fcb6f87a81b38d5dc812cf33fd7549c8a.1449523436.git.jbaron@akamai.com>
References: <cover.1449523436.git.jbaron@akamai.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1449523436.git.jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1449523436.git.jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
References: <cover.1449523436.git.jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Currently, epoll file descriptors or epfds (the fd returned from
epoll_create[1]()) that are added to a shared wakeup source are always
added in a non-exclusive manner. This means that when we have multiple
epfds attached to a shared fd source they are all woken up. This creates
thundering herd type behavior.

Introduce a new 'EPOLLEXCLUSIVE' flag that can be passed as part of the
'event' argument during an epoll_ctl() EPOLL_CTL_ADD operation. This new
flag allows for exclusive wakeups when there are multiple epfds attached to
a shared fd event source.

The implementation walks the list of exclusive waiters, and queues an
event to each epfd, until it finds the first waiter that has threads
blocked on it via epoll_wait(). The idea is to search for threads which are
idle and ready to process the wakeup events. Thus, we queue an event to at
least 1 epfd, but may still potentially queue an event to all epfds that
are attached to the shared fd source.

Performance testing was done by Madars Vitolins using a modified version of
Enduro/X. The use of the 'EPOLLEXCLUSIVE' flag reduce the length of this
particular workload from 860s down to 24s.

Tested-by: Madars Vitolins <m@silodev.com>
Signed-off-by: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
---
 fs/eventpoll.c                 | 24 +++++++++++++++++++++---
 include/uapi/linux/eventpoll.h |  3 +++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1e009ca..ae1dbcf 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -92,7 +92,7 @@
  */
 
 /* Epoll private bits inside the event mask */
-#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET)
+#define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET | EPOLLEXCLUSIVE)
 
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
@@ -1002,6 +1002,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	unsigned long flags;
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
+	int ewake = 0;
 
 	if ((unsigned long)key & POLLFREE) {
 		ep_pwq_from_wait(wait)->whead = NULL;
@@ -1066,8 +1067,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
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
 
@@ -1078,6 +1081,9 @@ out_unlock:
 	if (pwake)
 		ep_poll_safewake(&ep->poll_wait);
 
+	if (epi->event.events & EPOLLEXCLUSIVE)
+		return ewake;
+
 	return 1;
 }
 
@@ -1095,7 +1101,10 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		if (epi->event.events & EPOLLEXCLUSIVE)
+			add_wait_queue_exclusive(whead, &pwq->wait);
+		else
+			add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
@@ -1862,6 +1871,15 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		goto error_tgt_fput;
 
 	/*
+	 * epoll adds to the wakeup queue at EPOLL_CTL_ADD time only,
+	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
+	 * Also, we do not currently supported nested exclusive wakeups.
+	 */
+	if ((epds.events & EPOLLEXCLUSIVE) && (op == EPOLL_CTL_MOD ||
+		(op == EPOLL_CTL_ADD && is_file_epoll(tf.file))))
+		goto error_tgt_fput;
+
+	/*
 	 * At this point it is safe to assume that the "private_data" contains
 	 * our own data structure.
 	 */
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2..1c31549 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -26,6 +26,9 @@
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/* Set exclusive wakeup mode for the target file descriptor */
+#define EPOLLEXCLUSIVE (1 << 28)
+
 /*
  * Request the handling of system wakeup events so as to prevent system suspends
  * from happening while those events are being processed.
-- 
2.6.1
