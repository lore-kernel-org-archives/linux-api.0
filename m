From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/28] net/unix: convert to ->poll_mask
Date: Wed, 21 Mar 2018 08:40:15 +0100
Message-ID: <20180321074032.14211-12-hch@lst.de>
References: <20180321074032.14211-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180321074032.14211-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/unix/af_unix.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2d465bdeccbc..619c6921dd46 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -638,9 +638,8 @@ static int unix_stream_connect(struct socket *, struct sockaddr *,
 static int unix_socketpair(struct socket *, struct socket *);
 static int unix_accept(struct socket *, struct socket *, int, bool);
 static int unix_getname(struct socket *, struct sockaddr *, int *, int);
-static __poll_t unix_poll(struct file *, struct socket *, poll_table *);
-static __poll_t unix_dgram_poll(struct file *, struct socket *,
-				    poll_table *);
+static __poll_t unix_poll_mask(struct socket *, __poll_t);
+static __poll_t unix_dgram_poll_mask(struct socket *, __poll_t);
 static int unix_ioctl(struct socket *, unsigned int, unsigned long);
 static int unix_shutdown(struct socket *, int);
 static int unix_stream_sendmsg(struct socket *, struct msghdr *, size_t);
@@ -681,7 +680,7 @@ static const struct proto_ops unix_stream_ops = {
 	.socketpair =	unix_socketpair,
 	.accept =	unix_accept,
 	.getname =	unix_getname,
-	.poll =		unix_poll,
+	.poll_mask =	unix_poll_mask,
 	.ioctl =	unix_ioctl,
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
@@ -704,7 +703,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.socketpair =	unix_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	unix_getname,
-	.poll =		unix_dgram_poll,
+	.poll_mask =	unix_dgram_poll_mask,
 	.ioctl =	unix_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	unix_shutdown,
@@ -726,7 +725,7 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.socketpair =	unix_socketpair,
 	.accept =	unix_accept,
 	.getname =	unix_getname,
-	.poll =		unix_dgram_poll,
+	.poll_mask =	unix_dgram_poll_mask,
 	.ioctl =	unix_ioctl,
 	.listen =	unix_listen,
 	.shutdown =	unix_shutdown,
@@ -2640,13 +2639,10 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	return err;
 }
 
-static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wait)
+static __poll_t unix_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
-	__poll_t mask;
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
+	__poll_t mask = 0;
 
 	/* exceptional events? */
 	if (sk->sk_err)
@@ -2675,15 +2671,11 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 	return mask;
 }
 
-static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
-				    poll_table *wait)
+static __poll_t unix_dgram_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk, *other;
-	unsigned int writable;
-	__poll_t mask;
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
+	int writable;
+	__poll_t mask = 0;
 
 	/* exceptional events? */
 	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
@@ -2709,7 +2701,7 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	}
 
 	/* No write status requested, avoid expensive OUT tests. */
-	if (!(poll_requested_events(wait) & (EPOLLWRBAND|EPOLLWRNORM|EPOLLOUT)))
+	if (!(events & (EPOLLWRBAND|EPOLLWRNORM|EPOLLOUT)))
 		return mask;
 
 	writable = unix_writable(sk);
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
