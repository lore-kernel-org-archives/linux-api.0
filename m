From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v3 3/3] epoll: Add EPOLL_ROTATE mode
Date: Tue, 24 Feb 2015 21:25:48 +0000 (GMT)
Message-ID: <0dfea5cf8fb9a10e5cb973ae0f58589033db79eb.1424805740.git.jbaron@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1424805740.git.jbaron@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Epoll file descriptors that are added to a shared wakeup source are always
added in a non-exclusive manner. That means that when we have multiple epoll
fds attached to a shared wakeup source they are all woken up. This can
lead to excessive cpu usage and uneven load distribution.

This patch introduces a new 'EPOLL_ROTATE' flag that can be passed as
an argument to epoll_create1(). The 'EPOLL_ROTATE' flag creates a 'special'
epfd that, such that it will round robin its wakeups among any epfds attached
to it. This special epfd can then be attached to at most 1 wakeup sources.

For example:

1. ep1 = epoll_create1(EPOLL_ROTATE);
2. epoll_ctl(ep1, EPOLL_CTL_ADD, fd_source, NULL);
3. epoll_ctl(ep2, EPOLL_CTL_ADD, ep1, event);
   epoll_ctl(ep3, EPOLL_CTL_ADD, ep1, event);
   epoll_ctl(ep4, EPOLL_CTL_ADD, ep1, event);
     .
     .
     .

The usage of the indirect 'special' epfd is designed such that we don't have to
attach the epfds in step #3, directly to the wakeup source. This address two
issues. First, it ensures that competing process do not miss wakeups when they
are attached directly to the wakeup source. Because of the round robin nature
of the wakeups, we want to ensure that competing threads can't starve out or
insert themselves into our wakeup queue. Since, this 'special' fd is local to
our process we can control its exposure. And second, we didn't want the
implementation to affect the core kernel wake up paths, even when unused. By
creating a separate 'special' epfd we have isolated the wakeup paths.

An implementation note is that in the epoll wakeup routine,
'ep_poll_callback()', if EPOLLROUNDROBIN is set, we return 1, for a successful
wakeup, only when there are current waiters. The idea is to use this additional
heuristic in order minimize wakeup latencies.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c                 | 41 +++++++++++++++++++++++++++++++++++------
 include/uapi/linux/eventpoll.h |  4 ++++
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index da84712..a8b06a1 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -219,6 +219,9 @@ struct eventpoll {
 	/* used to optimize loop detection check */
 	int visited;
 	struct list_head visited_list_link;
+
+	/* wakeup policy type */
+	int wakeup_policy;
 };
 
 /* Wait structure used by the poll hooks */
@@ -1009,6 +1012,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	unsigned long flags;
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
+	int ewake = 0;
 
 	if ((unsigned long)key & POLLFREE) {
 		ep_pwq_from_wait(wait)->whead = NULL;
@@ -1073,8 +1077,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 	 * wait list.
 	 */
-	if (waitqueue_active(&ep->wq))
+	if (waitqueue_active(&ep->wq)) {
 		wake_up_locked(&ep->wq);
+		ewake = 1;
+	}
 	if (waitqueue_active(&ep->poll_wait))
 		pwake++;
 
@@ -1082,9 +1088,15 @@ out_unlock:
 	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
-
+	if (pwake) {
+		if (ep->wakeup_policy == EPOLL_ROTATE)
+			__wake_up_rotate(&ep->poll_wait, TASK_NORMAL, 1, 0,
+					 (void *)POLLIN);
+		else
+			ep_poll_safewake(&ep->poll_wait);
+	}
+	if (epi->event.events & EPOLLROTATE)
+		return ewake;
 	return 1;
 }
 
@@ -1097,12 +1109,19 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 {
 	struct epitem *epi = ep_item_from_epqueue(pt);
 	struct eppoll_entry *pwq;
+	struct eventpoll *ep;
 
 	if (epi->nwait >= 0 && (pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL))) {
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		if (is_file_epoll(epi->ffd.file))
+			ep = epi->ffd.file->private_data;
+		if (ep && (ep->wakeup_policy == EPOLL_ROTATE)) {
+			__add_wait_queue_exclusive(whead, &pwq->wait);
+			epi->event.events |= EPOLLROTATE;
+		} else
+			add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
@@ -1777,7 +1796,7 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
 
-	if (flags & ~EPOLL_CLOEXEC)
+	if (flags & ~(EPOLL_CLOEXEC | EPOLL_ROTATE))
 		return -EINVAL;
 	/*
 	 * Create the internal data structure ("struct eventpoll").
@@ -1802,6 +1821,8 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	}
 	ep->file = file;
 	fd_install(fd, file);
+	if (flags & EPOLL_ROTATE)
+		ep->wakeup_policy = EPOLL_ROTATE;
 	return fd;
 
 out_free_fd:
@@ -1874,6 +1895,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 */
 	ep = f.file->private_data;
 
+	if ((ep->wakeup_policy == EPOLL_ROTATE) && is_file_epoll(tf.file))
+		goto error_tgt_fput;
+
 	/*
 	 * When we insert an epoll file descriptor, inside another epoll file
 	 * descriptor, there is the change of creating closed loops, which are
@@ -1911,6 +1935,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 				mutex_lock_nested(&tep->mtx, 1);
 			}
 		}
+		error = -EINVAL;
+		if ((ep->wakeup_policy == EPOLL_ROTATE) &&
+					(!RB_EMPTY_ROOT(&ep->rbr)))
+			goto error_unlock;
 	}
 
 	/*
@@ -1945,6 +1973,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 			error = -ENOENT;
 		break;
 	}
+error_unlock:
 	if (tep != NULL)
 		mutex_unlock(&tep->mtx);
 	mutex_unlock(&ep->mtx);
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2..b0a3b41 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -20,12 +20,16 @@
 
 /* Flags for epoll_create1.  */
 #define EPOLL_CLOEXEC O_CLOEXEC
+#define EPOLL_ROTATE 0x1
 
 /* Valid opcodes to issue to sys_epoll_ctl() */
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
 
+/* Marks struct epitem that are attached to wakeup policy type EPOLL_ROTATE */
+#define EPOLLROTATE (1 << 28)
+
 /*
  * Request the handling of system wakeup events so as to prevent system suspends
  * from happening while those events are being processed.
-- 
1.8.2.rc2
