From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/32] net/tcp: convert to ->poll_mask
Date: Fri, 11 May 2018 13:07:45 +0200
Message-ID: <20180511110803.10910-15-hch@lst.de>
References: <20180511110803.10910-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180511110803.10910-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/tcp.h   |  4 ++--
 net/ipv4/af_inet.c  |  3 ++-
 net/ipv4/tcp.c      | 31 ++++++++++++++-----------------
 net/ipv6/af_inet6.c |  3 ++-
 4 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9c9b3768b350..d4d72ea9128d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -388,8 +388,8 @@ bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst);
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
index eaed0367e669..220b51347526 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -986,7 +986,8 @@ const struct proto_ops inet_stream_ops = {
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
index 9ce1c726185e..6ec0e7a13581 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -493,33 +493,30 @@ static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 		sk->sk_prot->stream_memory_read(sk) : false);
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
 
-	sock_poll_wait(file, sk_sleep(sk), wait);
-
 	state = inet_sk_state_load(sk);
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
 	 * EPOLLHUP is certainly not done right. But poll() doesn't
 	 * have a notion of HUP in just one direction, and for a
@@ -600,7 +597,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 
 	return mask;
 }
-EXPORT_SYMBOL(tcp_poll);
+EXPORT_SYMBOL(tcp_poll_mask);
 
 int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 8da0b513f188..a43d967eeca5 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -571,7 +571,8 @@ const struct proto_ops inet6_stream_ops = {
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
2.17.0
