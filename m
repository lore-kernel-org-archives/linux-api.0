From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/32] net: convert datagram_poll users tp ->poll_mask
Date: Fri, 30 Mar 2018 17:07:53 +0200
Message-ID: <20180330150809.28094-17-hch@lst.de>
References: <20180330150809.28094-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180330150809.28094-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/mISDN/socket.c        |  2 +-
 drivers/net/ppp/pppoe.c            |  2 +-
 drivers/staging/ipx/af_ipx.c       |  2 +-
 drivers/staging/irda/net/af_irda.c |  6 +++---
 include/linux/skbuff.h             |  3 +--
 include/net/udp.h                  |  2 +-
 net/appletalk/ddp.c                |  2 +-
 net/ax25/af_ax25.c                 |  2 +-
 net/bluetooth/hci_sock.c           |  2 +-
 net/can/bcm.c                      |  2 +-
 net/can/raw.c                      |  2 +-
 net/core/datagram.c                | 13 ++++---------
 net/decnet/af_decnet.c             |  6 +++---
 net/ieee802154/socket.c            |  4 ++--
 net/ipv4/af_inet.c                 |  6 +++---
 net/ipv4/udp.c                     | 10 +++++-----
 net/ipv6/af_inet6.c                |  2 +-
 net/ipv6/raw.c                     |  4 ++--
 net/kcm/kcmsock.c                  |  4 ++--
 net/key/af_key.c                   |  2 +-
 net/l2tp/l2tp_ip.c                 |  2 +-
 net/l2tp/l2tp_ip6.c                |  2 +-
 net/l2tp/l2tp_ppp.c                |  2 +-
 net/llc/af_llc.c                   |  2 +-
 net/netlink/af_netlink.c           |  2 +-
 net/netrom/af_netrom.c             |  2 +-
 net/nfc/rawsock.c                  |  4 ++--
 net/packet/af_packet.c             |  9 ++++-----
 net/phonet/socket.c                |  2 +-
 net/qrtr/qrtr.c                    |  2 +-
 net/rose/af_rose.c                 |  2 +-
 net/x25/af_x25.c                   |  2 +-
 32 files changed, 52 insertions(+), 59 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index c84270e16bdd..61d6e4c9e7d1 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -589,7 +589,7 @@ static const struct proto_ops data_sock_ops = {
 	.getname	= data_sock_getname,
 	.sendmsg	= mISDN_sock_sendmsg,
 	.recvmsg	= mISDN_sock_recvmsg,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= data_sock_setsockopt,
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 5aa59f41bf8c..8c311e626884 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1120,7 +1120,7 @@ static const struct proto_ops pppoe_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= pppoe_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
diff --git a/drivers/staging/ipx/af_ipx.c b/drivers/staging/ipx/af_ipx.c
index d21a9d128d3e..3373f7f67d35 100644
--- a/drivers/staging/ipx/af_ipx.c
+++ b/drivers/staging/ipx/af_ipx.c
@@ -1967,7 +1967,7 @@ static const struct proto_ops ipx_dgram_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= ipx_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.ioctl		= ipx_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ipx_compat_ioctl,
diff --git a/drivers/staging/irda/net/af_irda.c b/drivers/staging/irda/net/af_irda.c
index 2f1e9ab3d6d0..77659b1c40ba 100644
--- a/drivers/staging/irda/net/af_irda.c
+++ b/drivers/staging/irda/net/af_irda.c
@@ -2600,7 +2600,7 @@ static const struct proto_ops irda_seqpacket_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	irda_accept,
 	.getname =	irda_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	irda_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	irda_compat_ioctl,
@@ -2624,7 +2624,7 @@ static const struct proto_ops irda_dgram_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	irda_accept,
 	.getname =	irda_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	irda_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	irda_compat_ioctl,
@@ -2649,7 +2649,7 @@ static const struct proto_ops irda_ultra_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	irda_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	irda_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	irda_compat_ioctl,
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ddf77cf4ff2d..1ac027bd33ec 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3246,8 +3246,7 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned flags,
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
index 850a8e581cce..03e8907ae57c 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -275,7 +275,7 @@ int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 int udp_init_sock(struct sock *sk);
 int __udp_disconnect(struct sock *sk, int flags);
 int udp_disconnect(struct sock *sk, int flags);
-__poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait);
+__poll_t udp_poll_mask(struct socket *sock, __poll_t events);
 struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 				       netdev_features_t features,
 				       bool is_ipv6);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 03a9fc0771c0..3ea5631fee29 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1870,7 +1870,7 @@ static const struct proto_ops atalk_dgram_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= atalk_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.ioctl		= atalk_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= atalk_compat_ioctl,
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 47fdd399626b..3282dbe7d9eb 100644
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
index 923e9a271872..46a547e4a0c8 100644
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
index f2ecc43376a1..d65678554979 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -845,7 +845,7 @@ static const struct proto_ops raw_ops = {
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
index 791aff68af88..7793b3829906 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1209,11 +1209,11 @@ static int dn_getname(struct socket *sock, struct sockaddr *uaddr,int *uaddr_len
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
@@ -2346,7 +2346,7 @@ static const struct proto_ops dn_proto_ops = {
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
index ec32cc263b18..4a2bfae06b28 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -985,7 +985,7 @@ const struct proto_ops inet_dgram_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = inet_getname,
-	.poll		   = udp_poll,
+	.poll_mask	   = udp_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
@@ -1006,7 +1006,7 @@ EXPORT_SYMBOL(inet_dgram_ops);
 
 /*
  * For SOCK_RAW sockets; should be the same as inet_dgram_ops but without
- * udp_poll
+ * udp_poll_mask
  */
 static const struct proto_ops inet_sockraw_ops = {
 	.family		   = PF_INET,
@@ -1017,7 +1017,7 @@ static const struct proto_ops inet_sockraw_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = inet_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index e5ef7c38c934..56427047f7e1 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2491,7 +2491,7 @@ int compat_udp_getsockopt(struct sock *sk, int level, int optname,
  * 	udp_poll - wait for a UDP event.
  *	@file - file struct
  *	@sock - socket
- *	@wait - poll table
+ *	@events - events to wait for
  *
  *	This is same as datagram poll, except for the special case of
  *	blocking sockets. If application is using a blocking fd
@@ -2500,23 +2500,23 @@ int compat_udp_getsockopt(struct sock *sk, int level, int optname,
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
index c470549d6ef9..82c192b92358 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -578,7 +578,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.socketpair	   = sock_no_socketpair,	/* a do nothing	*/
 	.accept		   = sock_no_accept,		/* a do nothing	*/
 	.getname	   = inet6_getname,
-	.poll		   = udp_poll,			/* ok		*/
+	.poll_mask	   = udp_poll_mask,		/* ok		*/
 	.ioctl		   = inet6_ioctl,		/* must change  */
 	.listen		   = sock_no_listen,		/* ok		*/
 	.shutdown	   = inet_shutdown,		/* ok		*/
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 4c25339b1984..fdd9916f1475 100644
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
index f297d53a11aa..305c8c38c5d9 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1889,7 +1889,7 @@ static const struct proto_ops kcm_dgram_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	sock_no_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	kcm_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
@@ -1910,7 +1910,7 @@ static const struct proto_ops kcm_seqpacket_ops = {
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
index 3428fba6f2b7..bf436a51511b 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -614,7 +614,7 @@ static const struct proto_ops l2tp_ip_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = l2tp_ip_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = inet_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 6f009eaa5fbe..fc8ae3842606 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -755,7 +755,7 @@ static const struct proto_ops l2tp_ip6_ops = {
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = sock_no_accept,
 	.getname	   = l2tp_ip6_getname,
-	.poll		   = datagram_poll,
+	.poll_mask	   = datagram_poll_mask,
 	.ioctl		   = inet6_ioctl,
 	.listen		   = sock_no_listen,
 	.shutdown	   = inet_shutdown,
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 3b02f24ea9ec..d4679ea432d8 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1778,7 +1778,7 @@ static const struct proto_ops pppol2tp_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= pppol2tp_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= pppol2tp_setsockopt,
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index c38d16f22d2a..67e5db6157ef 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1180,7 +1180,7 @@ static const struct proto_ops llc_ui_ops = {
 	.socketpair  = sock_no_socketpair,
 	.accept      = llc_ui_accept,
 	.getname     = llc_ui_getname,
-	.poll	     = datagram_poll,
+	.poll_mask   = datagram_poll_mask,
 	.ioctl       = llc_ui_ioctl,
 	.listen      = llc_ui_listen,
 	.shutdown    = llc_ui_shutdown,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 07e8478068f0..9e4ff69deddb 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2669,7 +2669,7 @@ static const struct proto_ops netlink_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	netlink_getname,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	netlink_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 9ba30c63be3d..22636fca311e 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1366,7 +1366,7 @@ static const struct proto_ops nr_proto_ops = {
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
index e0f3f4aeeb4f..f50ec1244281 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4074,12 +4074,11 @@ static int packet_ioctl(struct socket *sock, unsigned int cmd,
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
@@ -4424,7 +4423,7 @@ static const struct proto_ops packet_ops_spkt = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	packet_getname_spkt,
-	.poll =		datagram_poll,
+	.poll_mask =	datagram_poll_mask,
 	.ioctl =	packet_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
@@ -4445,7 +4444,7 @@ static const struct proto_ops packet_ops = {
 	.socketpair =	sock_no_socketpair,
 	.accept =	sock_no_accept,
 	.getname =	packet_getname,
-	.poll =		packet_poll,
+	.poll_mask =	packet_poll_mask,
 	.ioctl =	packet_ioctl,
 	.listen =	sock_no_listen,
 	.shutdown =	sock_no_shutdown,
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index fffcd69f63ff..28d981512f5f 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -449,7 +449,7 @@ const struct proto_ops phonet_dgram_ops = {
 	.socketpair	= sock_no_socketpair,
 	.accept		= sock_no_accept,
 	.getname	= pn_socket_getname,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.ioctl		= pn_socket_ioctl,
 	.listen		= sock_no_listen,
 	.shutdown	= sock_no_shutdown,
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 5fb3929e3d7d..7f273529a0b1 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1024,7 +1024,7 @@ static const struct proto_ops qrtr_proto_ops = {
 	.recvmsg	= qrtr_recvmsg,
 	.getname	= qrtr_getname,
 	.ioctl		= qrtr_ioctl,
-	.poll		= datagram_poll,
+	.poll_mask	= datagram_poll_mask,
 	.shutdown	= sock_no_shutdown,
 	.setsockopt	= sock_no_setsockopt,
 	.getsockopt	= sock_no_getsockopt,
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 083bd251406f..f80a5c0804f1 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1483,7 +1483,7 @@ static const struct proto_ops rose_proto_ops = {
 	.socketpair	=	sock_no_socketpair,
 	.accept		=	rose_accept,
 	.getname	=	rose_getname,
-	.poll		=	datagram_poll,
+	.poll_mask	=	datagram_poll_mask,
 	.ioctl		=	rose_ioctl,
 	.listen		=	rose_listen,
 	.shutdown	=	sock_no_shutdown,
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 562cc11131f6..b94b8f3339f3 100644
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
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
