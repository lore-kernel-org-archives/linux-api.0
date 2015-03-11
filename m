From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 17/21] Tools: hv: kvp: use misc char device to
 communicate with kernel
Date: Wed, 11 Mar 2015 14:29:30 +0100
Message-ID: <1426080574-9011-18-git-send-email-vkuznets@redhat.com>
References: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Radim Krcmar <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use /dev/vmbus/hv_kvp instead of netlink.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_kvp_daemon.c | 166 +++++++++--------------------------------------
 1 file changed, 31 insertions(+), 135 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 408bb07..0d9f48e 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -33,7 +33,6 @@
 #include <ctype.h>
 #include <errno.h>
 #include <arpa/inet.h>
-#include <linux/connector.h>
 #include <linux/hyperv.h>
 #include <linux/netlink.h>
 #include <ifaddrs.h>
@@ -79,7 +78,6 @@ enum {
 	DNS
 };
 
-static struct sockaddr_nl addr;
 static int in_hand_shake = 1;
 
 static char *os_name = "";
@@ -1387,34 +1385,6 @@ kvp_get_domain_name(char *buffer, int length)
 	freeaddrinfo(info);
 }
 
-static int
-netlink_send(int fd, struct cn_msg *msg)
-{
-	struct nlmsghdr nlh = { .nlmsg_type = NLMSG_DONE };
-	unsigned int size;
-	struct msghdr message;
-	struct iovec iov[2];
-
-	size = sizeof(struct cn_msg) + msg->len;
-
-	nlh.nlmsg_pid = getpid();
-	nlh.nlmsg_len = NLMSG_LENGTH(size);
-
-	iov[0].iov_base = &nlh;
-	iov[0].iov_len = sizeof(nlh);
-
-	iov[1].iov_base = msg;
-	iov[1].iov_len = size;
-
-	memset(&message, 0, sizeof(message));
-	message.msg_name = &addr;
-	message.msg_namelen = sizeof(addr);
-	message.msg_iov = iov;
-	message.msg_iovlen = 2;
-
-	return sendmsg(fd, &message, 0);
-}
-
 void print_usage(char *argv[])
 {
 	fprintf(stderr, "Usage: %s [options]\n"
@@ -1425,22 +1395,17 @@ void print_usage(char *argv[])
 
 int main(int argc, char *argv[])
 {
-	int fd, len, nl_group;
+	int kvp_fd, len;
 	int error;
-	struct cn_msg *message;
 	struct pollfd pfd;
-	struct nlmsghdr *incoming_msg;
-	struct cn_msg	*incoming_cn_msg;
-	struct hv_kvp_msg *hv_msg;
-	char	*p;
+	char    *p;
+	struct hv_kvp_msg hv_msg[1];
 	char	*key_value;
 	char	*key_name;
 	int	op;
 	int	pool;
 	char	*if_name;
 	struct hv_kvp_ipaddr_value *kvp_ip_val;
-	char *kvp_recv_buffer;
-	size_t kvp_recv_buffer_len;
 	int daemonize = 1, long_index = 0, opt;
 
 	static struct option long_options[] = {
@@ -1468,12 +1433,14 @@ int main(int argc, char *argv[])
 	openlog("KVP", 0, LOG_USER);
 	syslog(LOG_INFO, "KVP starting; pid is:%d", getpid());
 
-	kvp_recv_buffer_len = NLMSG_LENGTH(0) + sizeof(struct cn_msg) + sizeof(struct hv_kvp_msg);
-	kvp_recv_buffer = calloc(1, kvp_recv_buffer_len);
-	if (!kvp_recv_buffer) {
-		syslog(LOG_ERR, "Failed to allocate netlink buffer");
+	kvp_fd = open("/dev/vmbus/hv_kvp", O_RDWR);
+
+	if (kvp_fd < 0) {
+		syslog(LOG_ERR, "open /dev/vmbus/hv_kvp failed; error: %d %s",
+			errno, strerror(errno));
 		exit(EXIT_FAILURE);
 	}
+
 	/*
 	 * Retrieve OS release information.
 	 */
@@ -1489,100 +1456,44 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
-	if (fd < 0) {
-		syslog(LOG_ERR, "netlink socket creation failed; error: %d %s", errno,
-				strerror(errno));
-		exit(EXIT_FAILURE);
-	}
-	addr.nl_family = AF_NETLINK;
-	addr.nl_pad = 0;
-	addr.nl_pid = 0;
-	addr.nl_groups = 0;
-
-
-	error = bind(fd, (struct sockaddr *)&addr, sizeof(addr));
-	if (error < 0) {
-		syslog(LOG_ERR, "bind failed; error: %d %s", errno, strerror(errno));
-		close(fd);
-		exit(EXIT_FAILURE);
-	}
-	nl_group = CN_KVP_IDX;
-
-	if (setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &nl_group, sizeof(nl_group)) < 0) {
-		syslog(LOG_ERR, "setsockopt failed; error: %d %s", errno, strerror(errno));
-		close(fd);
-		exit(EXIT_FAILURE);
-	}
-
 	/*
 	 * Register ourselves with the kernel.
 	 */
-	message = (struct cn_msg *)kvp_recv_buffer;
-	message->id.idx = CN_KVP_IDX;
-	message->id.val = CN_KVP_VAL;
-
-	hv_msg = (struct hv_kvp_msg *)message->data;
 	hv_msg->kvp_hdr.operation = KVP_OP_REGISTER1;
-	message->ack = 0;
-	message->len = sizeof(struct hv_kvp_msg);
-
-	len = netlink_send(fd, message);
-	if (len < 0) {
-		syslog(LOG_ERR, "netlink_send failed; error: %d %s", errno, strerror(errno));
-		close(fd);
+	len = write(kvp_fd, hv_msg, sizeof(struct hv_kvp_msg));
+	if (len != sizeof(struct hv_kvp_msg)) {
+		syslog(LOG_ERR, "registration to kernel failed; error: %d %s",
+		       errno, strerror(errno));
+		close(kvp_fd);
 		exit(EXIT_FAILURE);
 	}
 
-	pfd.fd = fd;
+	pfd.fd = kvp_fd;
 
 	while (1) {
-		struct sockaddr *addr_p = (struct sockaddr *) &addr;
-		socklen_t addr_l = sizeof(addr);
 		pfd.events = POLLIN;
 		pfd.revents = 0;
 
 		if (poll(&pfd, 1, -1) < 0) {
 			syslog(LOG_ERR, "poll failed; error: %d %s", errno, strerror(errno));
 			if (errno == EINVAL) {
-				close(fd);
+				close(kvp_fd);
 				exit(EXIT_FAILURE);
 			}
 			else
 				continue;
 		}
 
-		len = recvfrom(fd, kvp_recv_buffer, kvp_recv_buffer_len, 0,
-				addr_p, &addr_l);
-
-		if (len < 0) {
-			int saved_errno = errno;
-			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
-					addr.nl_pid, errno, strerror(errno));
+		len = read(kvp_fd, hv_msg, sizeof(struct hv_kvp_msg));
 
-			if (saved_errno == ENOBUFS) {
-				syslog(LOG_ERR, "receive error: ignored");
-				continue;
-			}
+		if (len != sizeof(struct hv_kvp_msg)) {
+			syslog(LOG_ERR, "read failed; error:%d %s",
+			       errno, strerror(errno));
 
-			close(fd);
-			return -1;
+			close(kvp_fd);
+			return EXIT_FAILURE;
 		}
 
-		if (addr.nl_pid) {
-			syslog(LOG_WARNING, "Received packet from untrusted pid:%u",
-					addr.nl_pid);
-			continue;
-		}
-
-		incoming_msg = (struct nlmsghdr *)kvp_recv_buffer;
-
-		if (incoming_msg->nlmsg_type != NLMSG_DONE)
-			continue;
-
-		incoming_cn_msg = (struct cn_msg *)NLMSG_DATA(incoming_msg);
-		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
-
 		/*
 		 * We will use the KVP header information to pass back
 		 * the error from this daemon. So, first copy the state
@@ -1603,7 +1514,7 @@ int main(int argc, char *argv[])
 			if (lic_version) {
 				strcpy(lic_version, p);
 				syslog(LOG_INFO, "KVP LIC Version: %s",
-					lic_version);
+				       lic_version);
 			} else {
 				syslog(LOG_ERR, "malloc failed");
 			}
@@ -1702,7 +1613,6 @@ int main(int argc, char *argv[])
 			goto kvp_done;
 		}
 
-		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
 		key_name = (char *)hv_msg->body.kvp_enum_data.data.key;
 		key_value = (char *)hv_msg->body.kvp_enum_data.data.value;
 
@@ -1753,31 +1663,17 @@ int main(int argc, char *argv[])
 			hv_msg->error = HV_S_CONT;
 			break;
 		}
-		/*
-		 * Send the value back to the kernel. The response is
-		 * already in the receive buffer. Update the cn_msg header to
-		 * reflect the key value that has been added to the message
-		 */
-kvp_done:
-
-		incoming_cn_msg->id.idx = CN_KVP_IDX;
-		incoming_cn_msg->id.val = CN_KVP_VAL;
-		incoming_cn_msg->ack = 0;
-		incoming_cn_msg->len = sizeof(struct hv_kvp_msg);
-
-		len = netlink_send(fd, incoming_cn_msg);
-		if (len < 0) {
-			int saved_errno = errno;
-			syslog(LOG_ERR, "net_link send failed; error: %d %s", errno,
-					strerror(errno));
-
-			if (saved_errno == ENOMEM || saved_errno == ENOBUFS) {
-				syslog(LOG_ERR, "send error: ignored");
-				continue;
-			}
 
+		/* Send the value back to the kernel. */
+kvp_done:
+		len = write(kvp_fd, hv_msg, sizeof(struct hv_kvp_msg));
+		if (len != sizeof(struct hv_kvp_msg)) {
+			syslog(LOG_ERR, "write failed; error: %d %s", errno,
+			       strerror(errno));
 			exit(EXIT_FAILURE);
 		}
 	}
 
+	close(kvp_fd);
+	exit(0);
 }
-- 
1.9.3
