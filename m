From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/32] net: convert datagram_poll users tp ->poll_mask
Date: Fri, 11 May 2018 13:07:47 +0200
Message-ID: <20180511110803.10910-17-hch@lst.de>
References: <20180511110803.10910-1-hch@lst.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180511110803.10910-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/mISDN/socket.c  |  2 +-
 drivers/net/ppp/pppoe.c      |  2 +-
 drivers/staging/ipx/af_ipx.c |  2 +-
 include/linux/skbuff.h       |  3 +--
 include/net/udp.h            |  2 +-
 net/appletalk/ddp.c          |  2 +-
 net/ax25/af_ax25.c           |  2 +-
 net/bluetooth/hci_sock.c     |  2 +-
 net/can/bcm.c                |  2 +-
 net/can/raw.c                |  2 +-
 net/core/datagram.c          | 13 ++++---------
 net/decnet/af_decnet.c       |  6 +++---
 net/ieee802154/socket.c      |  4 ++--
 net/ipv4/af_inet.c           |  6 +++---
 net/ipv4/udp.c               | 10 +++++-----
 net/ipv6/af_inet6.c          |  2 +-
 net/ipv6/raw.c               |  4 ++--
 net/kcm/kcmsock.c            | 10 +++++-----
 net/key/af_key.c             |  2 +-
 net/l2tp/l2tp_ip.c           |  2 +-
 net/l2tp/l2tp_ip6.c          |  2 +-
 net/l2tp/l2tp_ppp.c          |  2 +-
 net/llc/af_llc.c             |  2 +-
 net/netlink/af_netlink.c     |  2 +-
 net/netrom/af_netrom.c       |  2 +-
 net/nfc/rawsock.c            |  4 ++--
 net/packet/af_packet.c       |  9 ++++-----
 net/phonet/socket.c          |  2 +-
 net/qrtr/qrtr.c              |  2 +-
 net/rose/af_rose.c           |  2 +-
 net/x25/af_x25.c             |  2 +-
 31 files changed, 52 insertions(+), 59 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 18c0a1281914..98f90aadd141 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -588,7 +588,7 @@ static const struct proto_ops data_sock_ops = {
 	.getname	= data_sock_getname,
 	.sendmsg	= mISDN_sock_sendmsg,
 	.recvmsg	= mISDN_sock_recvmsg,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= data_sock_setsockopt,
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 7df07337d69c..40d0c80fa6ef 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1122,7 +1122,7 @@ static const struct proto_ops pppoe_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= pppoe_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
diff --git a/drivers/staging/ipx/af_ipx.c b/drivers/staging/ipx/af_ipx.c
index 5703dd176787..208b5c161631 100644
--- a/drivers/staging/ipx/af_ipx.c
+++ b/drivers/staging/ipx/af_ipx.c
@@ -1965,7 +1965,7 @@ static const struct proto_ops ipx_dgram_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= ipx_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.ioctl		= ipx_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ipx_compat_ioctl,
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9065477ed255..89198379b39d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3250,8 +3250,7 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned flags,
 				    int *peeked, int *off, int *err);
 struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned flags, int noblock,
 				  int *err);
-__poll_t datagram_poll(struct file *file, struct socket *sock,
-			   struct poll_table_struct *wait);
+__poll_t datagram_poll_mask(struct socket *sock, __poll_t events);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
 			   struct iov_iter *to, int size);
 static inline int skb_copy_datagram_msg(const struct sk_buff *from, int offset,
diff --git a/include/net/udp.h b/include/net/udp.h
index 0676b272f6ac..61389a29334b 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -276,7 +276,7 @@ int udp_init_sock(struct sock *sk);
 int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 int __udp_disconnect(struct sock *sk, int flags);
 int udp_disconnect(struct sock *sk, int flags);
-__poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait);
+__poll_t udp_poll_mask(struct socket *sock, __poll_t events);
 struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 				       netdev_features_t features,
 				       bool is_ipv6);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 9b6bc5abe946..55fdba05d7d9 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1869,7 +1869,7 @@ static const struct proto_ops atalk_dgram_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= atalk_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.ioctl		= atalk_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= atalk_compat_ioctl,
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2b41366fcad2..b7cd97325c66 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1954,7 +1954,7 @@ static const struct proto_ops ax25_proto_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= ax25_accept,
 	.getname	= ax25_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.ioctl		= ax25_ioctl,
 	.listen		= ax25_listen,
 	.shutdown	= ax25_shutdown,
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 1506e1632394..d6c099861538 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1975,7 +1975,7 @@ static const struct proto_ops hci_sock_ops = {
 	.sendmsg	= hci_sock_sendmsg,
 	.recvmsg	= hci_sock_recvmsg,
 	.ioctl		= hci_sock_ioctl,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= hci_sock_setsockopt,
diff --git a/net/can/bcm.c b/net/can/bcm.c
index ac5e5e34fee3..30c51e0ce294 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1669,7 +1669,7 @@ static const struct proto_ops bcm_ops = {
 	.socketpair    = sock_no_socketpair,
 	.accept        = sock_no_accept,
 	.getname       = sock_no_getname,
-	.poll          = datagram_poll,
+	.poll_mask     = datagram_poll_mask,
 	.ioctl         = can_ioctl,	/* use can_ioctl() from af_can.c */
 	.listen        = sock_no_listen,
 	.shutdown      = sock_no_shutdown,
diff --git a/net/can/raw.c b/net/can/raw.c
index 1051eee82581..fd7e2f49ea6a 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -843,7 +843,7 @@ static const struct proto_ops raw_ops = {
 	.socketpair    = sock_no_socketpair,
 	.accept        = sock_no_accept,
 	.getname       = raw_getname,
-	.poll          = datagram_poll,
+	.poll_mask     = datagram_poll_mask,
 	.ioctl         = can_ioctl,	/* use can_ioctl() from af_can.c */
 	.listen        = sock_no_listen,
 	.shutdown      = sock_no_shutdown,
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 9938952c5c78..f19bf3dc2bd6 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -819,9 +819,8 @@ EXPORT_SYMBOL(skb_copy_and_csum_datagram_msg);
 
 /**
  * 	datagram_poll - generic datagram poll
- *	@file: file struct
  *	@sock: socket
- *	@wait: poll table
+ *	@events to wait for
  *
  *	Datagram poll: Again totally generic. This also handles
  *	sequenced packet sockets providing the socket receive queue
@@ -831,14 +830,10 @@ EXPORT_SYMBOL(skb_copy_and_csum_datagram_msg);
  *	and you use a different write policy from sock_writeable()
  *	then please supply your own write_space callback.
  */
-__poll_t datagram_poll(struct file *file, struct socket *sock,
-			   poll_table *wait)
+__poll_t datagram_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
-	__poll_t mask;
-
-	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
+	__poll_t mask = 0;
 
 	/* exceptional events? */
 	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
@@ -871,4 +866,4 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 
 	return mask;
 }
-EXPORT_SYMBOL(datagram_poll);
+EXPORT_SYMBOL(datagram_poll_mask);
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 32751602767f..2af6470d73ce 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1207,11 +1207,11 @@ static int dn_getname(struct socket *sock, struct sockaddr *uaddr,int peer)
 }
 
 
-static __poll_t dn_poll(struct file *file, struct socket *sock, poll_table  *wait)
+static __poll_t dn_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
 	struct dn_scp *scp = DN_SK(sk);
-	__poll_t mask = datagram_poll(file, sock, wait);
+	__poll_t mask = datagram_poll_mask(sock, events);
 
 	if (!skb_queue_empty(&scp->other_receive_queue))
 		mask |= EPOLLRDBAND;
@@ -2344,7 +2344,7 @@ static const struct proto_ops dn_proto_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	dn_accept,
 	.getname =	dn_getname,
-	.poll =		dn_poll,
+	.poll_mask =	dn_poll_mask,
 	.ioctl =	dn_ioctl,
 	.listen =	dn_listen,
 	.shutdown =	dn_shutdown,
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a60658c85a9a..a0768d2759b8 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -423,7 +423,7 @@ static const struct proto_ops ieee802154_raw_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = sock_no_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = ieee802154_sock_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = sock_no_shutdown,
@@ -969,7 +969,7 @@ static const struct proto_ops ieee802154_dgram_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = sock_no_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = ieee802154_sock_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = sock_no_shutdown,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 220b51347526..030a0fcffdbf 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1019,7 +1019,7 @@ const struct proto_ops inet_dgram_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = inet_getname,
-	.poll		   = udp_poll,
+	.poll_mask	   = udp_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
@@ -1040,7 +1040,7 @@ EXPORT_SYMBOL(inet_dgram_ops);
 
 /*
  * For SOCK_RAW sockets; should be the same as inet_dgram_ops but without
- * udp_poll
+ * udp_poll_mask
  */
 static const struct proto_ops inet_sockraw_ops = {
 	.family		   = PF_INET,
@@ -1051,7 +1051,7 @@ static const struct proto_ops inet_sockraw_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = inet_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 24b5c59b1c53..34a2cd7290dc 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2498,7 +2498,7 @@ int compat_udp_getsockopt(struct sock *sk, int level, int optname,
  * 	udp_poll - wait for a UDP event.
  *	@file - file struct
  *	@sock - socket
- *	@wait - poll table
+ *	@events - events to wait for
  *
  *	This is same as datagram poll, except for the special case of
  *	blocking sockets. If application is using a blocking fd
@@ -2507,23 +2507,23 @@ int compat_udp_getsockopt(struct sock *sk, int level, int optname,
  *	but then block when reading it. Add special case code
  *	to work around these arguably broken applications.
  */
-__poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
+__poll_t udp_poll_mask(struct socket *sock, __poll_t events)
 {
-	__poll_t mask = datagram_poll(file, sock, wait);
+	__poll_t mask = datagram_poll_mask(sock, events);
 	struct sock *sk = sock->sk;
 
 	if (!skb_queue_empty(&udp_sk(sk)->reader_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Check for false positives due to checksum errors */
-	if ((mask & EPOLLRDNORM) && !(file->f_flags & O_NONBLOCK) &&
+	if ((mask & EPOLLRDNORM) && !(sock->file->f_flags & O_NONBLOCK) &&
 	    !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
 		mask &= ~(EPOLLIN | EPOLLRDNORM);
 
 	return mask;
 
 }
-EXPORT_SYMBOL(udp_poll);
+EXPORT_SYMBOL(udp_poll_mask);
 
 int udp_abort(struct sock *sk, int err)
 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index a43d967eeca5..a64c4f070aae 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -602,7 +602,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.socketpair	   = sock_no_socketpair,	/* a do nothing	*/
 	.accept		   = sock_no_accept,		/* a do nothing	*/
 	.getname	   = inet6_getname,
-	.poll		   = udp_poll,			/* ok		*/
+	.poll_mask	   = udp_poll_mask,		/* ok		*/
 	.ioctl		   = inet6_ioctl,		/* must change  */
 	.listen		   = sock_no_listen,		/* ok		*/
 	.shutdown	   = inet_shutdown,		/* ok		*/
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 5eb9b08947ed..4a73ea1ddd51 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -1345,7 +1345,7 @@ void raw6_proc_exit(void)
 }
 #endif	/* CONFIG_PROC_FS */
 
-/* Same as inet6_dgram_ops, sans udp_poll.  */
+/* Same as inet6_dgram_ops, sans udp_poll_mask.  */
 const struct proto_ops inet6_sockraw_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
@@ -1355,7 +1355,7 @@ const struct proto_ops inet6_sockraw_ops = {
 	.socketpair	   = sock_no_socketpair,	/* a do nothing	*/
 	.accept		   = sock_no_accept,		/* a do nothing	*/
 	.getname	   = inet6_getname,
-	.poll		   = datagram_poll,		/* ok		*/
+	.poll_mask	   = datagram_poll_mask,	/* ok		*/
 	.ioctl		   = inet6_ioctl,		/* must change  */
 	.listen		   = sock_no_listen,		/* ok		*/
 	.shutdown	   = inet_shutdown,		/* ok		*/
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index dc76bc346829..d67734c99027 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1336,9 +1336,9 @@ static void init_kcm_sock(struct kcm_sock *kcm, struct kcm_mux *mux)
 	struct list_head *head;
 	int index = 0;
 
-	/* For SOCK_SEQPACKET sock type, datagram_poll checks the sk_state, so
-	 * we set sk_state, otherwise epoll_wait always returns right away with
-	 * EPOLLHUP
+	/* For SOCK_SEQPACKET sock type, datagram_poll_mask checks the sk_state,
+	 * so  we set sk_state, otherwise epoll_wait always returns right away
+	 * with EPOLLHUP
 	 */
 	kcm->sk.sk_state = TCP_ESTABLISHED;
 
@@ -1903,7 +1903,7 @@ static const struct proto_ops kcm_dgram_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	sock_no_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	kcm_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
@@ -1924,7 +1924,7 @@ static const struct proto_ops kcm_seqpacket_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	sock_no_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	kcm_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7e2e7188e7f4..7654607e728b 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3726,7 +3726,7 @@ static const struct proto_ops pfkey_ops = {
 
 	/* Now the operations that really occur. */
 	.release	=	pfkey_release,
-	.poll		=	datagram_poll,
+	.poll_mask	=	datagram_poll_mask,
 	.sendmsg	=	pfkey_sendmsg,
 	.recvmsg	=	pfkey_recvmsg,
 };
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index a9c05b2bc1b0..181073bf6925 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -613,7 +613,7 @@ static const struct proto_ops l2tp_ip_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = l2tp_ip_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 957369192ca1..336e4c00abbc 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -754,7 +754,7 @@ static const struct proto_ops l2tp_ip6_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = l2tp_ip6_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = inet6_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 1fd9e145076a..ef1f46aa6414 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1806,7 +1806,7 @@ static const struct proto_ops pppol2tp_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= pppol2tp_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= pppol2tp_setsockopt,
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index cb80ebb38311..c75ec214415d 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1189,7 +1189,7 @@ static const struct proto_ops llc_ui_ops = {
 	.socketpair  = sock_no_socketpair,
 	.accept      = llc_ui_accept,
 	.getname     = llc_ui_getname,
-	.poll	     = datagram_poll,
+	.poll_mask   = datagram_poll_mask,
 	.ioctl       = llc_ui_ioctl,
 	.listen      = llc_ui_listen,
 	.shutdown    = llc_ui_shutdown,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 55342c4d5cec..22b30278903b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2673,7 +2673,7 @@ static const struct proto_ops netlink_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	netlink_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	netlink_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 4221d98a314b..96b45549f4ac 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1367,7 +1367,7 @@ static const struct proto_ops nr_proto_ops = {
 	.socketpair	=	sock_no_socketpair,
 	.accept		=	nr_accept,
 	.getname	=	nr_getname,
-	.poll		=	datagram_poll,
+	.poll_mask	=	datagram_poll_mask,
 	.ioctl		=	nr_ioctl,
 	.listen		=	nr_listen,
 	.shutdown	=	sock_no_shutdown,
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index e2188deb08dc..60c322531c49 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -284,7 +284,7 @@ static const struct proto_ops rawsock_ops = {
 	.socketpair     = sock_no_socketpair,
 	.accept         = sock_no_accept,
 	.getname        = sock_no_getname,
-	.poll           = datagram_poll,
+	.poll_mask      = datagram_poll_mask,
 	.ioctl          = sock_no_ioctl,
 	.listen         = sock_no_listen,
 	.shutdown       = sock_no_shutdown,
@@ -304,7 +304,7 @@ static const struct proto_ops rawsock_raw_ops = {
 	.socketpair     = sock_no_socketpair,
 	.accept         = sock_no_accept,
 	.getname        = sock_no_getname,
-	.poll           = datagram_poll,
+	.poll_mask      = datagram_poll_mask,
 	.ioctl          = sock_no_ioctl,
 	.listen         = sock_no_listen,
 	.shutdown       = sock_no_shutdown,
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 01f3515cada0..f1d6a351a111 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4108,12 +4108,11 @@ static int packet_ioctl(struct socket *sock, unsigned int cmd,
 	return 0;
 }
 
-static __poll_t packet_poll(struct file *file, struct socket *sock,
-				poll_table *wait)
+static __poll_t packet_poll_mask(struct socket *sock, __poll_t events)
 {
 	struct sock *sk = sock->sk;
 	struct packet_sock *po = pkt_sk(sk);
-	__poll_t mask = datagram_poll(file, sock, wait);
+	__poll_t mask = datagram_poll_mask(sock, events);
 
 	spin_lock_bh(&sk->sk_receive_queue.lock);
 	if (po->rx_ring.pg_vec) {
@@ -4455,7 +4454,7 @@ static const struct proto_ops packet_ops_spkt = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	packet_getname_spkt,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	packet_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
@@ -4476,7 +4475,7 @@ static const struct proto_ops packet_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	packet_getname,
-	.poll =		packet_poll,
+	.poll_mask =	packet_poll_mask,
 	.ioctl =	packet_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index f9b40e6a18a5..9ecf02def928 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -448,7 +448,7 @@ const struct proto_ops phonet_dgram_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= pn_socket_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.ioctl		= pn_socket_ioctl,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 2aa07b547b16..1b5025ea5b04 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1023,7 +1023,7 @@ static const struct proto_ops qrtr_proto_ops = {
 	.recvmsg	= qrtr_recvmsg,
 	.getname	= qrtr_getname,
 	.ioctl		= qrtr_ioctl,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
 	.getsockopt	= sock_no_getsockopt,
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 9ff5e0a76593..ecd8bc5f5f7e 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1482,7 +1482,7 @@ static const struct proto_ops rose_proto_ops = {
 	.socketpair	=	sock_no_socketpair,
 	.accept		=	rose_accept,
 	.getname	=	rose_getname,
-	.poll		=	datagram_poll,
+	.poll_mask	=	datagram_poll_mask,
 	.ioctl		=	rose_ioctl,
 	.listen		=	rose_listen,
 	.shutdown	=	sock_no_shutdown,
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index d49aa79b7997..f93365ae0fdd 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1750,7 +1750,7 @@ static const struct proto_ops x25_proto_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	x25_accept,
 	.getname =	x25_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	x25_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_x25_ioctl,
-- 
2.17.0
