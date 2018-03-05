From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/36] net/dccp: convert to ->poll_mask
Date: Mon,  5 Mar 2018 13:27:28 -0800
Message-ID: <20180305212743.16664-22-hch@lst.de>
References: <20180305212743.16664-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180305212743.16664-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/dccp/dccp.h  |  3 +--
 net/dccp/ipv4.c  |  2 +-
 net/dccp/ipv6.c  |  2 +-
 net/dccp/proto.c | 13 ++-----------
 4 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index f91e3816806b..0ea2ee56ac1b 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -316,8 +316,7 @@ int dccp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 		 int flags, int *addr_len);
 void dccp_shutdown(struct sock *sk, int how);
 int inet_dccp_listen(struct socket *sock, int backlog);
-__poll_t dccp_poll(struct file *file, struct socket *sock,
-		       poll_table *wait);
+__poll_t dccp_poll_mask(struct socket *sock, __poll_t events);
 int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 void dccp_req_err(struct sock *sk, u64 seq);
 
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index e65fcb45c3f6..e8476f319efd 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -983,7 +983,7 @@ static const struct proto_ops inet_dccp_ops = {
 	.accept		   = inet_accept,
 	.getname	   = inet_getname,
 	/* FIXME: work on tcp_poll to rename it to inet_csk_poll */
-	.poll		   = dccp_poll,
+	.poll_mask	   = dccp_poll_mask,
 	.ioctl		   = inet_ioctl,
 	/* FIXME: work on inet_listen to rename it to sock_common_listen */
 	.listen		   = inet_dccp_listen,
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 5df7857fc0f3..f0aac8e4b888 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -1069,7 +1069,7 @@ static const struct proto_ops inet6_dccp_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = inet6_getname,
-	.poll		   = dccp_poll,
+	.poll_mask	   = dccp_poll_mask,
 	.ioctl		   = inet6_ioctl,
 	.listen		   = inet_dccp_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 15bdc002d90c..26816032a7c2 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -314,20 +314,11 @@ int dccp_disconnect(struct sock *sk, int flags)
 
 EXPORT_SYMBOL_GPL(dccp_disconnect);
 
-/*
- *	Wait for a DCCP event.
- *
- *	Note that we don't need to lock the socket, as the upper poll layers
- *	take care of normal races (between the test and the event) and we don't
- *	go look at any of the socket buffers directly.
- */
-__poll_t dccp_poll(struct file *file, struct socket *sock,
-		       poll_table *wait)
+__poll_t dccp_poll_mask(struct socket *sock, __poll_t events)
 {
 	__poll_t mask;
 	struct sock *sk = sock->sk;
 
-	sock_poll_wait(file, sk_sleep(sk), wait);
 	if (sk->sk_state == DCCP_LISTEN)
 		return inet_csk_listen_poll(sk);
 
@@ -369,7 +360,7 @@ __poll_t dccp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
-EXPORT_SYMBOL_GPL(dccp_poll);
+EXPORT_SYMBOL_GPL(dccp_poll_mask);
 
 int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 {
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
