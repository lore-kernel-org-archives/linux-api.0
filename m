From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/36] net: remove sock_no_poll
Date: Mon, 22 Jan 2018 21:12:24 +0100
Message-ID: <20180122201243.31610-18-hch@lst.de>
References: <20180122201243.31610-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180122201243.31610-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Now that sock_poll handles a NULL ->poll or ->poll_mask there is no need
for a stub.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/af_alg.c             | 1 -
 crypto/algif_hash.c         | 2 --
 crypto/algif_rng.c          | 1 -
 drivers/isdn/mISDN/socket.c | 1 -
 drivers/net/ppp/pptp.c      | 1 -
 include/net/sock.h          | 2 --
 net/bluetooth/bnep/sock.c   | 1 -
 net/bluetooth/cmtp/sock.c   | 1 -
 net/bluetooth/hidp/sock.c   | 1 -
 net/core/sock.c             | 6 ------
 10 files changed, 17 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 05b084e216ac..592797ec8075 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -345,7 +345,6 @@ static const struct proto_ops alg_proto_ops = {
 	.sendpage	=	sock_no_sendpage,
 	.sendmsg	=	sock_no_sendmsg,
 	.recvmsg	=	sock_no_recvmsg,
-	.poll		=	sock_no_poll,
 
 	.bind		=	alg_bind,
 	.release	=	af_alg_release,
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 76d2e716c792..d5f323c1efc5 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -293,7 +293,6 @@ static struct proto_ops algif_hash_ops = {
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.setsockopt	=	sock_no_setsockopt,
-	.poll		=	sock_no_poll,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg,
@@ -401,7 +400,6 @@ static struct proto_ops algif_hash_ops_nokey = {
 	.mmap		=	sock_no_mmap,
 	.bind		=	sock_no_bind,
 	.setsockopt	=	sock_no_setsockopt,
-	.poll		=	sock_no_poll,
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg_nokey,
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 150c2b6480ed..22df3799a17b 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -106,7 +106,6 @@ static struct proto_ops algif_rng_ops = {
 	.bind		=	sock_no_bind,
 	.accept		=	sock_no_accept,
 	.setsockopt	=	sock_no_setsockopt,
-	.poll		=	sock_no_poll,
 	.sendmsg	=	sock_no_sendmsg,
 	.sendpage	=	sock_no_sendpage,
 
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index c5603d1a07d6..c84270e16bdd 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -746,7 +746,6 @@ static const struct proto_ops base_sock_ops = {
 	.getname	= sock_no_getname,
 	.sendmsg	= sock_no_sendmsg,
 	.recvmsg	= sock_no_recvmsg,
-	.poll		= sock_no_poll,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 6dde9a0cfe76..87f892f1d0fe 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -627,7 +627,6 @@ static const struct proto_ops pptp_ops = {
 	.socketpair = sock_no_socketpair,
 	.accept     = sock_no_accept,
 	.getname    = pptp_getname,
-	.poll       = sock_no_poll,
 	.listen     = sock_no_listen,
 	.shutdown   = sock_no_shutdown,
 	.setsockopt = sock_no_setsockopt,
diff --git a/include/net/sock.h b/include/net/sock.h
index f90685441143..1a5c31d1893a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1578,8 +1578,6 @@ int sock_no_connect(struct socket *, struct sockaddr *, int, int);
 int sock_no_socketpair(struct socket *, struct socket *);
 int sock_no_accept(struct socket *, struct socket *, int, bool);
 int sock_no_getname(struct socket *, struct sockaddr *, int *, int);
-__poll_t sock_no_poll(struct file *, struct socket *,
-			  struct poll_table_struct *);
 int sock_no_ioctl(struct socket *, unsigned int, unsigned long);
 int sock_no_listen(struct socket *, int);
 int sock_no_shutdown(struct socket *, int);
diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index b5116fa9835e..00deacdcb51c 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -175,7 +175,6 @@ static const struct proto_ops bnep_sock_ops = {
 	.getname	= sock_no_getname,
 	.sendmsg	= sock_no_sendmsg,
 	.recvmsg	= sock_no_recvmsg,
-	.poll		= sock_no_poll,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index ce86a7bae844..e08f28fadd65 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -178,7 +178,6 @@ static const struct proto_ops cmtp_sock_ops = {
 	.getname	= sock_no_getname,
 	.sendmsg	= sock_no_sendmsg,
 	.recvmsg	= sock_no_recvmsg,
-	.poll		= sock_no_poll,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 008ba439bd62..1eaac01f85de 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -208,7 +208,6 @@ static const struct proto_ops hidp_sock_ops = {
 	.getname	= sock_no_getname,
 	.sendmsg	= sock_no_sendmsg,
 	.recvmsg	= sock_no_recvmsg,
-	.poll		= sock_no_poll,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
diff --git a/net/core/sock.c b/net/core/sock.c
index 1211159718ad..1943a79befea 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2496,12 +2496,6 @@ int sock_no_getname(struct socket *sock, struct sockaddr *saddr,
 }
 EXPORT_SYMBOL(sock_no_getname);
 
-__poll_t sock_no_poll(struct file *file, struct socket *sock, poll_table *pt)
-{
-	return 0;
-}
-EXPORT_SYMBOL(sock_no_poll);
-
 int sock_no_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	return -EOPNOTSUPP;
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
