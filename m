From: Eric Wong <normalperson@yhbt.net>
Subject: [RFC/PATCH] epoll: replace EPOLL_CTL_DISABLE with EPOLL_CTL_POKE
Date: Fri, 2 Nov 2012 04:13:12 +0000
Message-ID: <20121102041312.GA15886@dcvr.yhbt.net>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-34263-glibc-alpha=m.gmane.org@sourceware.org>
Content-Disposition: inline
In-Reply-To: <1351210112-23238-1-git-send-email-palewis@adobe.com>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: "Paton J. Lewis" <palewis@adobe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Holland <pholland@adobe.com>, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk <mtk.manpages@gmail.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, paulmck@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

"Paton J. Lewis" <palewis@adobe.com> wrote:
> --- /dev/null
> +++ b/tools/testing/selftests/epoll/test_epoll.c

> +	/* Handle events until we encounter an error or this thread's 'stop'
> +	   condition is set: */
> +	while (1) {
> +		int result = epoll_wait(thread_data->epoll_set,
> +					&event_data,
> +					1,	/* Number of desired events */
> +					1000);  /* Timeout in ms */

<snip>

> +		/* We need the mutex here because checking for the stop
> +		   condition and re-enabling the epoll item need to be done
> +		   together as one atomic operation when EPOLL_CTL_DISABLE is
> +		   available: */
> +		item_data = (struct epoll_item_private *)event_data.data.ptr;
> +		pthread_mutex_lock(&item_data->mutex);

The per-item mutex bothers me.  Using EPOLLONESHOT normally frees me
from the need to worry about concurrent access to the item userspace.

Instead of having another thread call delete_item() on a successful
EPOLL_CTL_DISABLE, I'd normally use shutdown() (which causes
epoll_wait() to return the item and my normal error handling will kick
in once I try a read()/write()).

However, since shutdown() is limited to sockets and is irreversible,
I came up with EPOLL_CTL_POKE instead.  Comments greatly appreciated
(I'm not a regular kernel hacker, either)


>From 12a2d7c4584605dd763c7510140666d2a6b51d89 Mon Sep 17 00:00:00 2001
From: Eric Wong <normalperson@yhbt.net>
Date: Fri, 2 Nov 2012 03:47:08 +0000
Subject: [PATCH] epoll: replace EPOLL_CTL_DISABLE with EPOLL_CTL_POKE

EPOLL_CTL_POKE may be used to force an item into the epoll
ready list.  Instead of disabling an item asynchronously
via EPOLL_CTL_DISABLE, this forces the threads calling
epoll_wait() to handle the item in its normal loop.

EPOLL_CTL_POKE has the advantage of _not_ requiring per-item
locking when used in conjunction with EPOLLONESHOT.
Additionally, EPOLL_CTL_POKE does not require EPOLLONESHOT to
function (though it's usefulness in single-threaded or
oneshot-free scenarios is limited).

The modified epoll test demonstrates the lack of per-item
locking needed to accomplish safe deletion of items.

In a normal application, I use shutdown() for a similar effect
as calling EPOLL_CTL_POKE in a different thread.  However,
shutdown() has some limitations:
a) it only works on sockets
b) irreversibly affects the socket

Signed-off-by: Eric Wong <normalperson@yhbt.net>
---
 fs/eventpoll.c                             |   57 +++++++++++++++++++---------
 include/uapi/linux/eventpoll.h             |    2 +-
 tools/testing/selftests/epoll/test_epoll.c |   36 +++++++++++++-----
 3 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index da72250..1eea950 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -39,6 +39,9 @@
 #include <asm/mman.h>
 #include <linux/atomic.h>
 
+/* not currently exposed to user space, but maybe this should be */
+#define EPOLLPOKED	(EPOLLWAKEUP >> 1)
+
 /*
  * LOCKING:
  * There are three level of locking required by epoll :
@@ -677,30 +680,41 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 }
 
 /*
- * Disables a "struct epitem" in the eventpoll set. Returns -EBUSY if the item
- * had no event flags set, indicating that another thread may be currently
- * handling that item's events (in the case that EPOLLONESHOT was being
- * used). Otherwise a zero result indicates that the item has been disabled
- * from receiving events. A disabled item may be re-enabled via
- * EPOLL_CTL_MOD. Must be called with "mtx" held.
+ * Inserts "struct epitem" of the eventpoll set into the ready list
+ * if it is not already on the ready list.  Returns zero on success,
+ * returns -EBUSY if the item was already in the ready list.  This
+ * poke action is always a one-time event and behaves like an
+ * edge-triggered wakeup.
  */
-static int ep_disable(struct eventpoll *ep, struct epitem *epi)
+static int ep_poke(struct eventpoll *ep, struct epitem *epi)
 {
 	int result = 0;
 	unsigned long flags;
+	int pwake = 0;
 
 	spin_lock_irqsave(&ep->lock, flags);
-	if (epi->event.events & ~EP_PRIVATE_BITS) {
-		if (ep_is_linked(&epi->rdllink))
-			list_del_init(&epi->rdllink);
-		/* Ensure ep_poll_callback will not add epi back onto ready
-		   list: */
-		epi->event.events &= EP_PRIVATE_BITS;
-		}
-	else
+
+	if (ep_is_linked(&epi->rdllink)) {
 		result = -EBUSY;
+	} else {
+		epi->event.events |= EPOLLPOKED;
+
+		list_add_tail(&epi->rdllink, &ep->rdllist);
+		__pm_stay_awake(epi->ws);
+
+		/* Notify waiting tasks that events are available */
+		if (waitqueue_active(&ep->wq))
+			wake_up_locked(&ep->wq);
+		if (waitqueue_active(&ep->poll_wait))
+			pwake++;
+	}
+
 	spin_unlock_irqrestore(&ep->lock, flags);
 
+	/* We have to call this outside the lock */
+	if (pwake)
+		ep_poll_safewake(&ep->poll_wait);
+
 	return result;
 }
 
@@ -768,6 +782,8 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 
 	init_poll_funcptr(&pt, NULL);
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
+		if (epi->event.events & EPOLLPOKED)
+			return POLLIN | POLLRDNORM;
 		pt._key = epi->event.events;
 		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
 		    epi->event.events)
@@ -1398,7 +1414,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 		 * is holding "mtx", so no operations coming from userspace
 		 * can change the item.
 		 */
-		if (revents) {
+		if (revents || (epi->event.events & EPOLLPOKED)) {
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
 				list_add(&epi->rdllink, head);
@@ -1407,6 +1423,11 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 			}
 			eventcnt++;
 			uevent++;
+
+			/* each poke is a one-time event */
+			if (epi->event.events & EPOLLPOKED)
+				epi->event.events &= ~EPOLLPOKED;
+
 			if (epi->event.events & EPOLLONESHOT)
 				epi->event.events &= EP_PRIVATE_BITS;
 			else if (!(epi->event.events & EPOLLET)) {
@@ -1813,9 +1834,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		} else
 			error = -ENOENT;
 		break;
-	case EPOLL_CTL_DISABLE:
+	case EPOLL_CTL_POKE:
 		if (epi)
-			error = ep_disable(ep, epi);
+			error = ep_poke(ep, epi);
 		else
 			error = -ENOENT;
 		break;
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index 8c99ce7..46292bb 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -25,7 +25,7 @@
 #define EPOLL_CTL_ADD 1
 #define EPOLL_CTL_DEL 2
 #define EPOLL_CTL_MOD 3
-#define EPOLL_CTL_DISABLE 4
+#define EPOLL_CTL_POKE 4
 
 /*
  * Request the handling of system wakeup events so as to prevent system suspends
diff --git a/tools/testing/selftests/epoll/test_epoll.c b/tools/testing/selftests/epoll/test_epoll.c
index f752539..537b53e 100644
--- a/tools/testing/selftests/epoll/test_epoll.c
+++ b/tools/testing/selftests/epoll/test_epoll.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <assert.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <pthread.h>
@@ -99,11 +100,21 @@ void *read_thread_function(void *function_data)
 		   together as one atomic operation when EPOLL_CTL_DISABLE is
 		   available: */
 		item_data = (struct epoll_item_private *)event_data.data.ptr;
+#ifdef EPOLL_CTL_POKE
+		assert(event_data.events == 0 && "poke sets no events");
+#else
 		pthread_mutex_lock(&item_data->mutex);
+#endif
 
 		/* Remove the item from the epoll set if we want to stop
 		   handling that event: */
-		if (item_data->stop)
+		/*
+		 * XXX
+		 * Using __sync_add_and_fetch(&var, 0) should allow us
+		 * to safely read without holding a mutex.  Right?
+		 * There's no __sync_fetch() in gcc...
+		 */
+		if (__sync_add_and_fetch(&item_data->stop, 0))
 			delete_item(item_data->index);
 		else {
 			/* Clear the data that was written to the other end of
@@ -127,12 +138,16 @@ void *read_thread_function(void *function_data)
 				goto error_unlock;
 		}
 
+#ifndef EPOLL_CTL_POKE
 		pthread_mutex_unlock(&item_data->mutex);
+#endif
 	}
 
 error_unlock:
 	thread_data->status = item_data->status = errno;
+#ifndef EPOLL_CTL_POKE
 	pthread_mutex_unlock(&item_data->mutex);
+#endif
 	return 0;
 }
 
@@ -261,22 +276,23 @@ int main(int argc, char **argv)
 		goto error;
 
 	/* Cancel all event pollers: */
-#ifdef EPOLL_CTL_DISABLE
+#ifdef EPOLL_CTL_POKE
 	for (index = 0; index < n_epoll_items; ++index) {
-		pthread_mutex_lock(&epoll_items[index].mutex);
-		++epoll_items[index].stop;
+		__sync_add_and_fetch(&epoll_items[index].stop, 1);
 		if (epoll_ctl(epoll_set,
-			      EPOLL_CTL_DISABLE,
+			      EPOLL_CTL_POKE,
 			      epoll_items[index].fd,
-			      NULL) == 0)
-			delete_item(index);
-		else if (errno != EBUSY) {
-			pthread_mutex_unlock(&epoll_items[index].mutex);
+			      NULL) == 0) {
+			/*
+			 * We do NOT delete the item in this thread,
+			 * the thread calling epoll_wait will do that
+			 * for us.
+			 */
+		} else if (errno != EBUSY) {
 			goto error;
 		}
 		/* EBUSY means events were being handled; allow the other thread
 		   to delete the item. */
-		pthread_mutex_unlock(&epoll_items[index].mutex);
 	}
 #else
 	for (index = 0; index < n_epoll_items; ++index) {
-- 
Eric Wong
