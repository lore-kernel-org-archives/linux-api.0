From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/32] net/sctp: convert to ->poll_mask
Date: Fri, 11 May 2018 13:07:52 +0200
Message-ID: <20180511110803.10910-22-hch@lst.de>
References: <20180511110803.10910-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180511110803.10910-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/sctp/sctp.h | 3 +--
 net/sctp/ipv6.c         | 2 +-
 net/sctp/protocol.c     | 2 +-
 net/sctp/socket.c       | 4 +---
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 28b996d63490..206100cc665b 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -107,8 +107,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 int sctp_inet_listen(struct socket *sock, int backlog);
 void sctp_write_space(struct sock *sk);
 void sctp_data_ready(struct sock *sk);
-__poll_t sctp_poll(struct file *file, struct socket *sock,
-		poll_table *wait);
+__poll_t sctp_poll_mask(struct socket *sock, __poll_t events);
 void sctp_sock_rfree(struct sk_buff *skb);
 void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 		    struct sctp_association *asoc);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 2e3f7b75a8ec..d52eaf1881af 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -1007,7 +1007,7 @@ static const struct proto_ops inet6_seqpacket_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = sctp_getname,
-	.poll		   = sctp_poll,
+	.poll_mask	   = sctp_poll_mask,
 	.ioctl		   = inet6_ioctl,
 	.listen		   = sctp_inet_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index d685f8456762..a1d2ea3ff4c9 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1016,7 +1016,7 @@ static const struct proto_ops inet_seqpacket_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = inet_accept,
 	.getname	   = inet_getname,	/* Semantics are different.  */
-	.poll		   = sctp_poll,
+	.poll_mask	   = sctp_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = sctp_inet_listen,
 	.shutdown	   = inet_shutdown,	/* Looks harmless.  */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 80835ac26d2c..f6bb1b89525c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7701,14 +7701,12 @@ int sctp_inet_listen(struct socket *sock, int backlog)
  * here, again, by modeling the current TCP/UDP code.  We don't have
  * a good way to test with it yet.
  */
-__poll_t sctp_poll(struct file *file, struct socket *sock, poll_table *wait)
+__poll_t sctp_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
 	struct sctp_sock *sp = sctp_sk(sk);
 	__poll_t mask;
 
-	poll_wait(file, sk_sleep(sk), wait);
-
 	sock_rps_record_flow(sk);
 
 	/* A TCP-style listening socket becomes readable when the accept queue
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
