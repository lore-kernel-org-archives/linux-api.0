From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] epoll: restrict EPOLLEXCLUSIVE to POLLIN and POLLOUT
Date: Thu,  4 Feb 2016 10:39:04 -0500
Message-ID: <1454600344-23655-1-git-send-email-jbaron@akamai.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

In the current implementation of the EPOLLEXCLUSIVE flag (added for 4.5-rc1),
if epoll waiters create different POLL* sets and register them as exclusive
against the same target fd, the current implementation will stop waking any
further waiters once it finds the first idle waiter. This means that waiters
could miss wakeups in certain cases.

For example, when we wake up a pipe for reading we do:
wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);
So if one epoll set or epfd is added to pipe p with POLLIN and a second set
epfd2 is added to pipe p with POLLRDNORM, only epfd may receive the wakeup
since the current implementation will stop after it finds any intersection
of events with a waiter that is blocked in epoll_wait().

We could potentially address this by requiring all epoll waiters that are
added to p be required to pass the same set of POLL* events. IE the first
EPOLL_CTL_ADD that passes EPOLLEXCLUSIVE establishes the set POLL* flags to
be used by any other epfds that are added as EPOLLEXCLUSIVE. However, I think
it might be somewhat confusing interface as we would have to reference count
the number of users for that set, and so userspace would have to keep track
of that count, or we would need a more involved interface. It also adds some
shared state that we'd have store somewhere. I don't think anybody will want
to bloat __wait_queue_head for this.

I think what we could do instead, is to simply restrict EPOLLEXCLUSIVE such
that it can only be specified with EPOLLIN and/or EPOLLOUT. So that way if
the wakeup includes 'POLLIN' and not 'POLLOUT', we can stop once we hit the
first idle waiter that specifies the EPOLLIN bit, since any remaining waiters
that only have 'POLLOUT' set wouldn't need to be woken. Likewise, we can do
the same thing if 'POLLOUT' is in the wakeup bit set and not 'POLLIN'. If both
'POLLOUT' and 'POLLIN' are set in the wake bit set (there is at least one
example of this I saw in fs/pipe.c), then we just wake the entire exclusive
list. Having both 'POLLOUT' and 'POLLIN' both set should not be on any
performance critical path, so I think that's ok (in fs/pipe.c its in
pipe_release()). We also continue to include EPOLLERR and EPOLLHUP by default
in any exclusive set. Thus, the user can specify EPOLLERR and/or EPOLLHUP but
is not required to do so.

Since epoll waiters may be interested in other events as well besides EPOLLIN,
EPOLLOUT, EPOLLERR and EPOLLHUP, these can still be added by doing a 'dup' call
on the target fd and adding that as one normally would with EPOLL_CTL_ADD. Since
I think that the POLLIN and POLLOUT events are what we are interest in balancing,
I think that the 'dup' thing could perhaps be added to only one of the waiter
threads. However, I think that EPOLLIN, EPOLLOUT, EPOLLERR and EPOLLHUP should
be sufficient for the majority of use-cases.

Since EPOLLEXCLUSIVE is intended to be used with a target fd shared among
multiple epfds, where between 1 and n of the epfds may receive an event, it
does not satisfy the semantics of EPOLLONESHOT where only 1 epfd would get an
event. Thus, it is not allowed to be specified in conjunction with
EPOLLEXCLUSIVE.

EPOLL_CTL_MOD is also not allowed if the fd was previously added as
EPOLLEXCLUSIVE. It seems with the limited number of flags to not be as
interesting, but this could be relaxed at some further point.

Signed-off-by: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
---
 fs/eventpoll.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ae1dbcf..cde6074 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -94,6 +94,11 @@
 /* Epoll private bits inside the event mask */
 #define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET | EPOLLEXCLUSIVE)
 
+#define EPOLLINOUT_BITS (POLLIN | POLLOUT)
+
+#define EPOLLEXCLUSIVE_OK_BITS (EPOLLINOUT_BITS | POLLERR | POLLHUP | \
+				EPOLLWAKEUP | EPOLLET | EPOLLEXCLUSIVE)
+
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4
 
@@ -1068,7 +1073,22 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * wait list.
 	 */
 	if (waitqueue_active(&ep->wq)) {
-		ewake = 1;
+		if ((epi->event.events & EPOLLEXCLUSIVE) &&
+					!((unsigned long)key & POLLFREE)) {
+			switch ((unsigned long)key & EPOLLINOUT_BITS) {
+			case POLLIN:
+				if (epi->event.events & POLLIN)
+					ewake = 1;
+				break;
+			case POLLOUT:
+				if (epi->event.events & POLLOUT)
+					ewake = 1;
+				break;
+			case 0:
+				ewake = 1;
+				break;
+			}
+		}
 		wake_up_locked(&ep->wq);
 	}
 	if (waitqueue_active(&ep->poll_wait))
@@ -1875,9 +1895,13 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
 	 * Also, we do not currently supported nested exclusive wakeups.
 	 */
-	if ((epds.events & EPOLLEXCLUSIVE) && (op == EPOLL_CTL_MOD ||
-		(op == EPOLL_CTL_ADD && is_file_epoll(tf.file))))
-		goto error_tgt_fput;
+	if (epds.events & EPOLLEXCLUSIVE) {
+		if (op == EPOLL_CTL_MOD)
+			goto error_tgt_fput;
+		if (op == EPOLL_CTL_ADD && (is_file_epoll(tf.file) ||
+				(epds.events & ~EPOLLEXCLUSIVE_OK_BITS)))
+			goto error_tgt_fput;
+	}
 
 	/*
 	 * At this point it is safe to assume that the "private_data" contains
@@ -1950,8 +1974,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		break;
 	case EPOLL_CTL_MOD:
 		if (epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_modify(ep, epi, &epds);
+			if (!(epi->event.events & EPOLLEXCLUSIVE)) {
+				epds.events |= POLLERR | POLLHUP;
+				error = ep_modify(ep, epi, &epds);
+			}
 		} else
 			error = -ENOENT;
 		break;
-- 
2.6.1
