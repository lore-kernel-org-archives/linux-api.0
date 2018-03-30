From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/32] net/nfc: convert to ->poll_mask
Date: Fri, 30 Mar 2018 17:08:01 +0200
Message-ID: <20180330150809.28094-25-hch@lst.de>
References: <20180330150809.28094-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180330150809.28094-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/nfc/llcp_sock.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 376040092142..b6010750e634 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -549,16 +549,13 @@ static inline __poll_t llcp_accept_poll(struct sock *parent)
 	return 0;
 }
 
-static __poll_t llcp_sock_poll(struct file *file, struct socket *sock,
-				   poll_table *wait)
+static __poll_t llcp_sock_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
 	__poll_t mask = 0;
 
 	pr_debug("%p\n", sk);
 
-	sock_poll_wait(file, sk_sleep(sk), wait);
-
 	if (sk->sk_state == LLCP_LISTEN)
 		return llcp_accept_poll(sk);
 
@@ -900,7 +897,7 @@ static const struct proto_ops llcp_sock_ops = {
 	.socketpair     = sock_no_socketpair,
 	.accept         = llcp_sock_accept,
 	.getname        = llcp_sock_getname,
-	.poll           = llcp_sock_poll,
+	.poll_mask      = llcp_sock_poll_mask,
 	.ioctl          = sock_no_ioctl,
 	.listen         = llcp_sock_listen,
 	.shutdown       = sock_no_shutdown,
@@ -920,7 +917,7 @@ static const struct proto_ops llcp_rawsock_ops = {
 	.socketpair     = sock_no_socketpair,
 	.accept         = sock_no_accept,
 	.getname        = llcp_sock_getname,
-	.poll           = llcp_sock_poll,
+	.poll_mask      = llcp_sock_poll_mask,
 	.ioctl          = sock_no_ioctl,
 	.listen         = sock_no_listen,
 	.shutdown       = sock_no_shutdown,
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
