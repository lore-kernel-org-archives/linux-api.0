From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/32] net/tcp: convert to ->poll_mask
Date: Wed, 10 Jan 2018 16:58:28 +0100
Message-ID: <20180110155853.32348-8-hch@lst.de>
References: <20180110155853.32348-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180110155853.32348-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/tcp.h   |  4 ++--
 net/ipv4/af_inet.c  |  3 ++-
 net/ipv4/tcp.c      | 33 ++++++++++++++-------------------
 net/ipv6/af_inet6.c |  3 ++-
 4 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 50b21a49d870..75b3ce444b1c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -387,8 +387,8 @@ bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst);
 void tcp_close(struct sock *sk, long timeout);
 void tcp_init_sock(struct sock *sk);
 void tcp_init_transfer(struct sock *sk, int bpf_op);
-__poll_t tcp_poll(struct file *file, struct socket *sock,
-		      struct poll_table_struct *wait);
+struct wait_queue_head *tcp_get_poll_head(struct socket *sock, __poll_t events);
+__poll_t tcp_poll_mask(struct socket *sock, __poll_t events);
 int tcp_getsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, int __user *optlen);
 int tcp_setsockopt(struct sock *sk, int level, int optname,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f00499a46927..2a362198a03e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -934,7 +934,8 @@ const struct proto_ops inet_stream_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = inet_getname,
-	.poll		   = tcp_poll,
+	.get_poll_head	   = tcp_get_poll_head,
+	.poll_mask	   = tcp_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = inet_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c4a7ee7f6721..4d88c765cfcc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -486,35 +486,30 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 	}
 }
 
+struct wait_queue_head *tcp_get_poll_head(struct socket *sock, __poll_t events)
+{
+	sock_poll_busy_loop(sock, events);
+	sock_rps_record_flow(sock->sk);
+	return sk_sleep(sock->sk);
+}
+EXPORT_SYMBOL(tcp_get_poll_head);
+
 /*
- *	Wait for a TCP event.
- *
- *	Note that we don't need to lock the socket, as the upper poll layers
- *	take care of normal races (between the test and the event) and we don't
- *	go look at any of the socket buffers directly.
+ * Socket is not locked. We are protected from async events by poll logic and
+ * correct handling of state changes made by other threads is impossible in
+ * any case.
  */
-__poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
+__poll_t tcp_poll_mask(struct socket *sock, __poll_t events)
 {
-	__poll_t mask;
 	struct sock *sk = sock->sk;
 	const struct tcp_sock *tp = tcp_sk(sk);
+	__poll_t mask = 0;
 	int state;
 
-	sock_rps_record_flow(sk);
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-
 	state = sk_state_load(sk);
 	if (state == TCP_LISTEN)
 		return inet_csk_listen_poll(sk);
 
-	/* Socket is not locked. We are protected from async events
-	 * by poll logic and correct handling of state changes
-	 * made by other threads is impossible in any case.
-	 */
-
-	mask = 0;
-
 	/*
 	 * POLLHUP is certainly not done right. But poll() doesn't
 	 * have a notion of HUP in just one direction, and for a
@@ -595,7 +590,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 
 	return mask;
 }
-EXPORT_SYMBOL(tcp_poll);
+EXPORT_SYMBOL(tcp_poll_mask);
 
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index c9441ca45399..cccbb6e6603a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -544,7 +544,8 @@ const struct proto_ops inet6_stream_ops = {
 	.socketpair	   = sock_no_socketpair,	/* a do nothing	*/
 	.accept		   = inet_accept,		/* ok		*/
 	.getname	   = inet6_getname,
-	.poll		   = tcp_poll,			/* ok		*/
+	.get_poll_head	   = tcp_get_poll_head,
+	.poll_mask	   = tcp_poll_mask,		/* ok		*/
 	.ioctl		   = inet6_ioctl,		/* must change  */
 	.listen		   = inet_listen,		/* ok		*/
 	.shutdown	   = inet_shutdown,		/* ok		*/
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
