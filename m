From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/32] net/caif: convert to ->poll_mask
Date: Tue, 15 May 2018 21:48:24 +0200
Message-ID: <20180515194833.6906-24-hch@lst.de>
References: <20180515194833.6906-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180515194833.6906-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/caif/caif_socket.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index a6fb1b3bcad9..c7991867d622 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -934,15 +934,11 @@ static int caif_release(struct socket *sock)
 }
 
 /* Copied from af_unix.c:unix_poll(), added CAIF tx_flow handling */
-static __poll_t caif_poll(struct file *file,
-			      struct socket *sock, poll_table *wait)
+static __poll_t caif_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
-	__poll_t mask;
 	struct caifsock *cf_sk = container_of(sk, struct caifsock, sk);
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
+	__poll_t mask = 0;
 
 	/* exceptional events? */
 	if (sk->sk_err)
@@ -976,7 +972,7 @@ static const struct proto_ops caif_seqpacket_ops = {
 	.socketpair = sock_no_socketpair,
 	.accept = sock_no_accept,
 	.getname = sock_no_getname,
-	.poll = caif_poll,
+	.poll_mask = caif_poll_mask,
 	.ioctl = sock_no_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = sock_no_shutdown,
@@ -997,7 +993,7 @@ static const struct proto_ops caif_stream_ops = {
 	.socketpair = sock_no_socketpair,
 	.accept = sock_no_accept,
 	.getname = sock_no_getname,
-	.poll = caif_poll,
+	.poll_mask = caif_poll_mask,
 	.ioctl = sock_no_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = sock_no_shutdown,
-- 
2.17.0

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
