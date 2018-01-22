From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/36] net/vmw_vsock: convert to ->poll_mask
Date: Mon, 22 Jan 2018 21:12:30 +0100
Message-ID: <20180122201243.31610-24-hch@lst.de>
References: <20180122201243.31610-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180122201243.31610-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/vmw_vsock/af_vsock.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index bbd97d3bd8fb..664c6346c0d6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -850,18 +850,11 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	return err;
 }
 
-static __poll_t vsock_poll(struct file *file, struct socket *sock,
-			       poll_table *wait)
+static __poll_t vsock_poll_mask(struct socket *sock, __poll_t events)
 {
-	struct sock *sk;
-	__poll_t mask;
-	struct vsock_sock *vsk;
-
-	sk = sock->sk;
-	vsk = vsock_sk(sk);
-
-	poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
+	struct sock *sk = sock->sk;
+	struct vsock_sock *vsk = vsock_sk(sk);
+	__poll_t mask = 0;
 
 	if (sk->sk_err)
 		/* Signify that there has been an error on this socket. */
@@ -1091,7 +1084,7 @@ static const struct proto_ops vsock_dgram_ops = {
 	.socketpair = sock_no_socketpair,
 	.accept = sock_no_accept,
 	.getname = vsock_getname,
-	.poll = vsock_poll,
+	.poll_mask = vsock_poll_mask,
 	.ioctl = sock_no_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = vsock_shutdown,
@@ -1849,7 +1842,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.socketpair = sock_no_socketpair,
 	.accept = vsock_accept,
 	.getname = vsock_getname,
-	.poll = vsock_poll,
+	.poll_mask = vsock_poll_mask,
 	.ioctl = sock_no_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
