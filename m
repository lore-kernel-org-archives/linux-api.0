From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 29/36] net/phonet: convert to ->poll_mask
Date: Mon, 22 Jan 2018 21:12:36 +0100
Message-ID: <20180122201243.31610-30-hch@lst.de>
References: <20180122201243.31610-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180122201243.31610-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/phonet/socket.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 7563b0ac8386..c18c906c025f 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -341,15 +341,12 @@ static int pn_socket_getname(struct socket *sock, struct sockaddr *addr,
 	return 0;
 }
 
-static __poll_t pn_socket_poll(struct file *file, struct socket *sock,
-					poll_table *wait)
+static __poll_t pn_socket_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
 	struct pep_sock *pn = pep_sk(sk);
 	__poll_t mask = 0;
 
-	poll_wait(file, sk_sleep(sk), wait);
-
 	if (sk->sk_state == TCP_CLOSE)
 		return POLLERR;
 	if (!skb_queue_empty(&sk->sk_receive_queue))
@@ -474,7 +471,7 @@ const struct proto_ops phonet_stream_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= pn_socket_accept,
 	.getname	= pn_socket_getname,
-	.poll		= pn_socket_poll,
+	.poll_mask	= pn_socket_poll_mask,
 	.ioctl		= pn_socket_ioctl,
 	.listen		= pn_socket_listen,
 	.shutdown	= sock_no_shutdown,
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
