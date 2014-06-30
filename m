From: David Drysdale <drysdale@google.com>
Subject: [PATCH 07/11] capsicum: convert callers to use sockfd_lookupr() etc
Date: Mon, 30 Jun 2014 11:28:07 +0100
Message-ID: <1404124096-21445-8-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Convert places that use sockfd_lookup() functions to use the
equivalent sockfd_lookupr() variant instead.

Annotate each such call with an indication of what operations will
be performed on the retrieved socket, to allow future policing
of rights associated with file descriptors.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 drivers/block/nbd.c                |   3 +-
 drivers/scsi/iscsi_tcp.c           |   2 +-
 drivers/staging/usbip/stub_dev.c   |   2 +-
 drivers/staging/usbip/vhci_sysfs.c |   2 +-
 drivers/vhost/net.c                |   2 +-
 fs/ncpfs/inode.c                   |   5 +-
 net/bluetooth/bnep/sock.c          |   2 +-
 net/bluetooth/cmtp/sock.c          |   2 +-
 net/bluetooth/hidp/sock.c          |   4 +-
 net/compat.c                       |   4 +-
 net/l2tp/l2tp_core.c               |  11 ++--
 net/l2tp/l2tp_core.h               |   2 +
 net/sched/sch_atm.c                |   2 +-
 net/socket.c                       | 115 +++++++++++++++++++++++--------------
 net/sunrpc/svcsock.c               |   4 +-
 15 files changed, 98 insertions(+), 64 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index d6f55e3052fb..8439bbd1ad17 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -646,7 +646,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		int err;
 		if (nbd->sock)
 			return -EBUSY;
-		sock = sockfd_lookup(arg, &err);
+		sock = sockfd_lookupr(arg, &err,
+				      CAP_READ, CAP_WRITE, CAP_SHUTDOWN);
 		if (sock) {
 			nbd->sock = sock;
 			if (max_part > 0)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 11854845393b..9354b333887c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -652,7 +652,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	int err;
 
 	/* lookup for existing socket */
-	sock = sockfd_lookup((int)transport_eph, &err);
+	sock = sockfd_lookupr((int)transport_eph, &err, CAP_SOCK_SERVER);
 	if (!sock) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "sockfd_lookup failed %d\n", err);
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index de692d7011a5..3ac80c595343 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -108,7 +108,7 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 			goto err;
 		}
 
-		socket = sockfd_lookup(sockfd, &err);
+		socket = sockfd_lookupr(sockfd, &err, CAP_LIST_END);
 		if (!socket)
 			goto err;
 
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index 211f43f67ea2..efe9d7625433 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -195,7 +195,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	/* Extract socket from fd. */
-	socket = sockfd_lookup(sockfd, &err);
+	socket = sockfd_lookupr(sockfd, &err, CAP_LIST_END);
 	if (!socket)
 		return -EINVAL;
 
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6fed594f12d3..f4db0caf817d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -838,7 +838,7 @@ static struct socket *get_raw_socket(int fd)
 		char  buf[MAX_ADDR_LEN];
 	} uaddr;
 	int uaddr_len = sizeof uaddr, r;
-	struct socket *sock = sockfd_lookup(fd, &r);
+	struct socket *sock = sockfd_lookupr(fd, &r, CAP_READ, CAP_WRITE);
 
 	if (!sock)
 		return ERR_PTR(-ENOTSOCK);
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index e31e589369a4..580024e60d20 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -539,7 +539,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	if (!uid_valid(data.mounted_uid) || !uid_valid(data.uid) ||
 	    !gid_valid(data.gid))
 		goto out;
-	sock = sockfd_lookup(data.ncp_fd, &error);
+	sock = sockfd_lookupr(data.ncp_fd, &error, CAP_WRITE, CAP_FSTAT);
 	if (!sock)
 		goto out;
 
@@ -567,7 +567,8 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	server->ncp_sock = sock;
 	
 	if (data.info_fd != -1) {
-		struct socket *info_sock = sockfd_lookup(data.info_fd, &error);
+		struct socket *info_sock = sockfd_lookupr(data.info_fd, &error,
+							  CAP_WRITE, CAP_FSTAT);
 		if (!info_sock)
 			goto out_bdi;
 		server->info_sock = info_sock;
diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index 5f051290daba..1a69b6b05d2e 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -69,7 +69,7 @@ static int bnep_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long
 		if (copy_from_user(&ca, argp, sizeof(ca)))
 			return -EFAULT;
 
-		nsock = sockfd_lookup(ca.sock, &err);
+		nsock = sockfd_lookupr(ca.sock, &err, CAP_READ, CAP_WRITE);
 		if (!nsock)
 			return err;
 
diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index d82787d417bd..4033b771e6ca 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -83,7 +83,7 @@ static int cmtp_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long
 		if (copy_from_user(&ca, argp, sizeof(ca)))
 			return -EFAULT;
 
-		nsock = sockfd_lookup(ca.sock, &err);
+		nsock = sockfd_lookupr(ca.sock, &err, CAP_READ, CAP_WRITE);
 		if (!nsock)
 			return err;
 
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index cb3fdde1968a..85afd39595f3 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -67,11 +67,11 @@ static int hidp_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long
 		if (copy_from_user(&ca, argp, sizeof(ca)))
 			return -EFAULT;
 
-		csock = sockfd_lookup(ca.ctrl_sock, &err);
+		csock = sockfd_lookupr(ca.ctrl_sock, &err, CAP_READ, CAP_WRITE);
 		if (!csock)
 			return err;
 
-		isock = sockfd_lookup(ca.intr_sock, &err);
+		isock = sockfd_lookupr(ca.intr_sock, &err, CAP_READ, CAP_WRITE);
 		if (!isock) {
 			sockfd_put(csock);
 			return err;
diff --git a/net/compat.c b/net/compat.c
index 9a76eaf63184..06655190173e 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -388,7 +388,7 @@ COMPAT_SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 		       char __user *, optval, unsigned int, optlen)
 {
 	int err;
-	struct socket *sock = sockfd_lookup(fd, &err);
+	struct socket *sock = sockfd_lookupr(fd, &err, CAP_SETSOCKOPT);
 
 	if (sock) {
 		err = security_socket_setsockopt(sock, level, optname);
@@ -508,7 +508,7 @@ COMPAT_SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
 		       char __user *, optval, int __user *, optlen)
 {
 	int err;
-	struct socket *sock = sockfd_lookup(fd, &err);
+	struct socket *sock = sockfd_lookupr(fd, &err, CAP_GETSOCKOPT);
 
 	if (sock) {
 		err = security_socket_getsockopt(sock, level, optname);
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a4e37d7158dc..64e6df42cfda 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -175,7 +175,8 @@ l2tp_session_id_hash_2(struct l2tp_net *pn, u32 session_id)
  * owned by userspace.  A struct sock returned from this function must be
  * released using l2tp_tunnel_sock_put once you're done with it.
  */
-static struct sock *l2tp_tunnel_sock_lookup(struct l2tp_tunnel *tunnel)
+static struct sock *l2tp_tunnel_sock_lookup(struct l2tp_tunnel *tunnel,
+					    struct capsicum_rights *rights)
 {
 	int err = 0;
 	struct socket *sock = NULL;
@@ -189,7 +190,7 @@ static struct sock *l2tp_tunnel_sock_lookup(struct l2tp_tunnel *tunnel)
 		 * of closing it.  Look the socket up using the fd to ensure
 		 * consistency.
 		 */
-		sock = sockfd_lookup(tunnel->fd, &err);
+		sock = sockfd_lookup_rights(tunnel->fd, &err, rights);
 		if (sock)
 			sk = sock->sk;
 	} else {
@@ -1411,9 +1412,11 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 	struct l2tp_tunnel *tunnel = NULL;
 	struct socket *sock = NULL;
 	struct sock *sk = NULL;
+	struct capsicum_rights rights;
 
 	tunnel = container_of(work, struct l2tp_tunnel, del_work);
-	sk = l2tp_tunnel_sock_lookup(tunnel);
+	sk = l2tp_tunnel_sock_lookup(tunnel,
+				     cap_rights_init(&rights, CAP_SHUTDOWN));
 	if (!sk)
 		return;
 
@@ -1614,7 +1617,7 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 		if (err < 0)
 			goto err;
 	} else {
-		sock = sockfd_lookup(fd, &err);
+		sock = sockfd_lookupr(fd, &err, CAP_READ, CAP_WRITE);
 		if (!sock) {
 			pr_err("tunl %u: sockfd_lookup(fd=%d) returned %d\n",
 			       tunnel_id, fd, err);
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 3f93ccd6ba97..fd1e282d4e8a 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -11,6 +11,8 @@
 #ifndef _L2TP_CORE_H_
 #define _L2TP_CORE_H_
 
+#include <linux/capsicum.h>
+
 /* Just some random numbers */
 #define L2TP_TUNNEL_MAGIC	0x42114DDA
 #define L2TP_SESSION_MAGIC	0x0C04EB7D
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 8449b337f9e3..8131efa6d164 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -238,7 +238,7 @@ static int atm_tc_change(struct Qdisc *sch, u32 classid, u32 parent,
 	}
 	pr_debug("atm_tc_change: type %d, payload %d, hdr_len %d\n",
 		 opt->nla_type, nla_len(opt), hdr_len);
-	sock = sockfd_lookup(fd, &error);
+	sock = sockfd_lookupr(fd, &error, CAP_GETSOCKNAME);
 	if (!sock)
 		return error;	/* f_count++ */
 	pr_debug("atm_tc_change: f_count %ld\n", file_count(sock->file));
diff --git a/net/socket.c b/net/socket.c
index f254e9bf9c4d..dbc00f0b992a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -419,23 +419,6 @@ struct socket *sock_from_file(struct file *file, int *err)
 }
 EXPORT_SYMBOL(sock_from_file);
 
-static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
-{
-	struct fd f = fdget(fd);
-	struct socket *sock;
-
-	*err = -EBADF;
-	if (f.file) {
-		sock = sock_from_file(f.file, err);
-		if (likely(sock)) {
-			*fput_needed = f.flags;
-			return sock;
-		}
-		fdput(f);
-	}
-	return NULL;
-}
-
 #ifdef CONFIG_SECURITY_CAPSICUM
 struct socket *sockfd_lookup_rights(int fd, int *err,
 				    struct capsicum_rights *rights)
@@ -506,6 +489,23 @@ struct socket *_sockfd_lookupr_light(int fd, int *err, int *fput_needed, ...)
 
 #else
 
+static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
+{
+	struct fd f = fdget(fd);
+	struct socket *sock;
+
+	*err = -EBADF;
+	if (f.file) {
+		sock = sock_from_file(f.file, err);
+		if (likely(sock)) {
+			*fput_needed = f.flags;
+			return sock;
+		}
+		fdput(f);
+	}
+	return NULL;
+}
+
 static inline struct socket *
 sockfd_lookup_light_rights(int fd, int *err, int *fput_needed,
 			   const struct capsicum_rights **actual_rights,
@@ -1608,7 +1608,7 @@ SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
 	struct sockaddr_storage address;
 	int err, fput_needed;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_BIND);
 	if (sock) {
 		err = move_addr_to_kernel(umyaddr, addrlen, &address);
 		if (err >= 0) {
@@ -1637,7 +1637,7 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
 	int err, fput_needed;
 	int somaxconn;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_LISTEN);
 	if (sock) {
 		somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
 		if ((unsigned int)backlog > somaxconn)
@@ -1671,6 +1671,8 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 	struct file *newfile;
 	int err, len, newfd, fput_needed;
 	struct sockaddr_storage address;
+	struct capsicum_rights rights;
+	const struct capsicum_rights *listen_rights = NULL;
 
 	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
@@ -1678,7 +1680,9 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup_light_rights(fd, &err, &fput_needed,
+					  &listen_rights,
+					  cap_rights_init(&rights, CAP_ACCEPT));
 	if (!sock)
 		goto out;
 
@@ -1770,7 +1774,7 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
 	struct sockaddr_storage address;
 	int err, fput_needed;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_CONNECT);
 	if (!sock)
 		goto out;
 	err = move_addr_to_kernel(uservaddr, addrlen, &address);
@@ -1802,7 +1806,7 @@ SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockaddr,
 	struct sockaddr_storage address;
 	int len, err, fput_needed;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_GETSOCKNAME);
 	if (!sock)
 		goto out;
 
@@ -1833,7 +1837,7 @@ SYSCALL_DEFINE3(getpeername, int, fd, struct sockaddr __user *, usockaddr,
 	struct sockaddr_storage address;
 	int len, err, fput_needed;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_GETPEERNAME);
 	if (sock != NULL) {
 		err = security_socket_getpeername(sock);
 		if (err) {
@@ -1871,7 +1875,8 @@ SYSCALL_DEFINE6(sendto, int, fd, void __user *, buff, size_t, len,
 
 	if (len > INT_MAX)
 		len = INT_MAX;
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed,
+				    CAP_WRITE, addr ? CAP_CONNECT : 0ULL);
 	if (!sock)
 		goto out;
 
@@ -1930,7 +1935,7 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
 
 	if (size > INT_MAX)
 		size = INT_MAX;
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_READ);
 	if (!sock)
 		goto out;
 
@@ -1984,7 +1989,7 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 	if (optlen < 0)
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_SETSOCKOPT);
 	if (sock != NULL) {
 		err = security_socket_setsockopt(sock, level, optname);
 		if (err)
@@ -2015,7 +2020,10 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
 	int err, fput_needed;
 	struct socket *sock;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_GETSOCKOPT,
+				(level == SOL_SCTP &&
+				 optname == SCTP_SOCKOPT_PEELOFF)
+				? CAP_PEELOFF : 0ULL);
 	if (sock != NULL) {
 		err = security_socket_getsockopt(sock, level, optname);
 		if (err)
@@ -2044,7 +2052,7 @@ SYSCALL_DEFINE2(shutdown, int, fd, int, how)
 	int err, fput_needed;
 	struct socket *sock;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_SHUTDOWN);
 	if (sock != NULL) {
 		err = security_socket_shutdown(sock, how);
 		if (!err)
@@ -2080,10 +2088,12 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	return 0;
 }
 
-static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
+static int ___sys_sendmsg(struct socket *sock_noaddr, struct socket *sock_addr,
+			 struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags,
 			 struct used_address *used_address)
 {
+	struct socket *sock;
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
 	struct sockaddr_storage address;
@@ -2103,6 +2113,9 @@ static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 		if (err)
 			return err;
 	}
+	sock = (msg_sys->msg_name ? sock_addr : sock_noaddr);
+	if (!sock)
+		return -EBADF;
 
 	if (msg_sys->msg_iovlen > UIO_FASTIOV) {
 		err = -EMSGSIZE;
@@ -2202,15 +2215,22 @@ long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags)
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock;
-
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
+	struct socket *sock_addr;
+	struct socket *sock_noaddr;
+
+	sock_addr = sockfd_lookupr_light(fd, &err, &fput_needed,
+					 CAP_WRITE, CAP_CONNECT);
+	sock_noaddr = sock_addr;
+	if (!sock_noaddr)
+		sock_noaddr = sockfd_lookupr_light(fd, &err, &fput_needed,
+						   CAP_WRITE);
+	if (!sock_noaddr)
 		goto out;
 
-	err = ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
+	err = ___sys_sendmsg(sock_noaddr, sock_addr, msg, &msg_sys, flags,
+			     NULL);
 
-	fput_light(sock->file, fput_needed);
+	fput_light(sock_noaddr->file, fput_needed);
 out:
 	return err;
 }
@@ -2230,7 +2250,8 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		   unsigned int flags)
 {
 	int fput_needed, err, datagrams;
-	struct socket *sock;
+	struct socket *sock_addr;
+	struct socket *sock_noaddr;
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
 	struct msghdr msg_sys;
@@ -2241,8 +2262,13 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	datagrams = 0;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
+	sock_addr = sockfd_lookupr_light(fd, &err, &fput_needed,
+					 CAP_WRITE, CAP_CONNECT);
+	sock_noaddr = sock_addr;
+	if (!sock_noaddr)
+		sock_noaddr = sockfd_lookupr_light(fd, &err, &fput_needed,
+						   CAP_WRITE);
+	if (!sock_noaddr)
 		return err;
 
 	used_address.name_len = UINT_MAX;
@@ -2252,14 +2278,15 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	while (datagrams < vlen) {
 		if (MSG_CMSG_COMPAT & flags) {
-			err = ___sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
-					     &msg_sys, flags, &used_address);
+			err = ___sys_sendmsg(sock_noaddr, sock_addr,
+					(struct msghdr __user *)compat_entry,
+					&msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
-			err = ___sys_sendmsg(sock,
+			err = ___sys_sendmsg(sock_noaddr, sock_addr,
 					     (struct msghdr __user *)entry,
 					     &msg_sys, flags, &used_address);
 			if (err < 0)
@@ -2273,7 +2300,7 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		++datagrams;
 	}
 
-	fput_light(sock->file, fput_needed);
+	fput_light(sock_noaddr->file, fput_needed);
 
 	/* We only return an error if no datagrams were able to be sent */
 	if (datagrams != 0)
@@ -2392,7 +2419,7 @@ long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags)
 	struct msghdr msg_sys;
 	struct socket *sock;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_READ);
 	if (!sock)
 		goto out;
 
@@ -2432,7 +2459,7 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	datagrams = 0;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookupr_light(fd, &err, &fput_needed, CAP_READ);
 	if (!sock)
 		return err;
 
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 43bcb4699d69..9568b63b8aef 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1400,7 +1400,7 @@ static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
 bool svc_alien_sock(struct net *net, int fd)
 {
 	int err;
-	struct socket *sock = sockfd_lookup(fd, &err);
+	struct socket *sock = sockfd_lookupr(fd, &err, CAP_LIST_END);
 	bool ret = false;
 
 	if (!sock)
@@ -1428,7 +1428,7 @@ int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
 		const size_t len)
 {
 	int err = 0;
-	struct socket *so = sockfd_lookup(fd, &err);
+	struct socket *so = sockfd_lookupr(fd, &err, CAP_LISTEN);
 	struct svc_sock *svsk = NULL;
 	struct sockaddr_storage addr;
 	struct sockaddr *sin = (struct sockaddr *)&addr;
-- 
2.0.0.526.g5318336

