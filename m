From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 18/21] Tools: hv: vss: use misc char device to
 communicate with kernel
Date: Wed, 11 Mar 2015 14:29:31 +0100
Message-ID: <1426080574-9011-19-git-send-email-vkuznets@redhat.com>
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

Use /dev/vmbus/hv_vss instead of netlink.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_vss_daemon.c | 139 +++++++++--------------------------------------
 1 file changed, 25 insertions(+), 114 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 5e63f70..135425a 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -19,7 +19,6 @@
 
 
 #include <sys/types.h>
-#include <sys/socket.h>
 #include <sys/poll.h>
 #include <sys/ioctl.h>
 #include <fcntl.h>
@@ -30,21 +29,11 @@
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
-#include <arpa/inet.h>
 #include <linux/fs.h>
-#include <linux/connector.h>
 #include <linux/hyperv.h>
-#include <linux/netlink.h>
 #include <syslog.h>
 #include <getopt.h>
 
-static struct sockaddr_nl addr;
-
-#ifndef SOL_NETLINK
-#define SOL_NETLINK 270
-#endif
-
-
 /* Don't use syslog() in the function since that can cause write to disk */
 static int vss_do_freeze(char *dir, unsigned int cmd)
 {
@@ -137,33 +126,6 @@ out:
 	return error;
 }
 
-static int netlink_send(int fd, struct cn_msg *msg)
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
@@ -174,16 +136,11 @@ void print_usage(char *argv[])
 
 int main(int argc, char *argv[])
 {
-	int fd, len, nl_group;
+	int vss_fd, len;
 	int error;
-	struct cn_msg *message;
 	struct pollfd pfd;
-	struct nlmsghdr *incoming_msg;
-	struct cn_msg	*incoming_cn_msg;
 	int	op;
-	struct hv_vss_msg *vss_msg;
-	char *vss_recv_buffer;
-	size_t vss_recv_buffer_len;
+	struct hv_vss_msg vss_msg[1];
 	int daemonize = 1, long_index = 0, opt;
 
 	static struct option long_options[] = {
@@ -211,98 +168,50 @@ int main(int argc, char *argv[])
 	openlog("Hyper-V VSS", 0, LOG_USER);
 	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
 
-	vss_recv_buffer_len = NLMSG_LENGTH(0) + sizeof(struct cn_msg) + sizeof(struct hv_vss_msg);
-	vss_recv_buffer = calloc(1, vss_recv_buffer_len);
-	if (!vss_recv_buffer) {
-		syslog(LOG_ERR, "Failed to allocate netlink buffers");
-		exit(EXIT_FAILURE);
-	}
-
-	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
-	if (fd < 0) {
-		syslog(LOG_ERR, "netlink socket creation failed; error:%d %s",
-				errno, strerror(errno));
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
-		syslog(LOG_ERR, "bind failed; error:%d %s", errno, strerror(errno));
-		close(fd);
-		exit(EXIT_FAILURE);
-	}
-	nl_group = CN_VSS_IDX;
-	if (setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &nl_group, sizeof(nl_group)) < 0) {
-		syslog(LOG_ERR, "setsockopt failed; error:%d %s", errno, strerror(errno));
-		close(fd);
+	vss_fd = open("/dev/vmbus/hv_vss", O_RDWR);
+	if (vss_fd < 0) {
+		syslog(LOG_ERR, "open /dev/vmbus/hv_vss failed; error: %d %s",
+		       errno, strerror(errno));
 		exit(EXIT_FAILURE);
 	}
 	/*
 	 * Register ourselves with the kernel.
 	 */
-	message = (struct cn_msg *)vss_recv_buffer;
-	message->id.idx = CN_VSS_IDX;
-	message->id.val = CN_VSS_VAL;
-	message->ack = 0;
-	vss_msg = (struct hv_vss_msg *)message->data;
-	vss_msg->vss_hdr.operation = VSS_OP_REGISTER;
-
-	message->len = sizeof(struct hv_vss_msg);
+	vss_msg->vss_hdr.operation = VSS_OP_REGISTER1;
 
-	len = netlink_send(fd, message);
+	len = write(vss_fd, vss_msg, sizeof(struct hv_vss_msg));
 	if (len < 0) {
-		syslog(LOG_ERR, "netlink_send failed; error:%d %s", errno, strerror(errno));
-		close(fd);
+		syslog(LOG_ERR, "registration to kernel failed; error: %d %s",
+		       errno, strerror(errno));
+		close(vss_fd);
 		exit(EXIT_FAILURE);
 	}
 
-	pfd.fd = fd;
+	pfd.fd = vss_fd;
 
 	while (1) {
-		struct sockaddr *addr_p = (struct sockaddr *) &addr;
-		socklen_t addr_l = sizeof(addr);
 		pfd.events = POLLIN;
 		pfd.revents = 0;
 
 		if (poll(&pfd, 1, -1) < 0) {
 			syslog(LOG_ERR, "poll failed; error:%d %s", errno, strerror(errno));
 			if (errno == EINVAL) {
-				close(fd);
+				close(vss_fd);
 				exit(EXIT_FAILURE);
 			}
 			else
 				continue;
 		}
 
-		len = recvfrom(fd, vss_recv_buffer, vss_recv_buffer_len, 0,
-				addr_p, &addr_l);
+		len = read(vss_fd, vss_msg, sizeof(struct hv_vss_msg));
 
-		if (len < 0) {
-			syslog(LOG_ERR, "recvfrom failed; pid:%u error:%d %s",
-					addr.nl_pid, errno, strerror(errno));
-			close(fd);
-			return -1;
-		}
-
-		if (addr.nl_pid) {
-			syslog(LOG_WARNING,
-				"Received packet from untrusted pid:%u",
-				addr.nl_pid);
-			continue;
+		if (len != sizeof(struct hv_vss_msg)) {
+			syslog(LOG_ERR, "read failed; error:%d %s",
+			       errno, strerror(errno));
+			close(vss_fd);
+			return EXIT_FAILURE;
 		}
 
-		incoming_msg = (struct nlmsghdr *)vss_recv_buffer;
-
-		if (incoming_msg->nlmsg_type != NLMSG_DONE)
-			continue;
-
-		incoming_cn_msg = (struct cn_msg *)NLMSG_DATA(incoming_msg);
-		vss_msg = (struct hv_vss_msg *)incoming_cn_msg->data;
 		op = vss_msg->vss_hdr.operation;
 		error =  HV_S_OK;
 
@@ -325,12 +234,14 @@ int main(int argc, char *argv[])
 			syslog(LOG_ERR, "Illegal op:%d\n", op);
 		}
 		vss_msg->error = error;
-		len = netlink_send(fd, incoming_cn_msg);
-		if (len < 0) {
-			syslog(LOG_ERR, "net_link send failed; error:%d %s",
-					errno, strerror(errno));
+		len = write(vss_fd, &error, sizeof(struct hv_vss_msg));
+		if (len != sizeof(struct hv_vss_msg)) {
+			syslog(LOG_ERR, "write failed; error: %d %s", errno,
+			       strerror(errno));
 			exit(EXIT_FAILURE);
 		}
 	}
 
+	close(vss_fd);
+	exit(0);
 }
-- 
1.9.3
