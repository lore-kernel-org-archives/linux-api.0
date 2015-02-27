From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 2/3] Drivers: hv: vss: convert userspace/kernel
 communication to using char device
Date: Fri, 27 Feb 2015 17:14:24 +0100
Message-ID: <1425053665-635-3-git-send-email-vkuznets@redhat.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
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
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Userspace/kernel communication via netlink has a number of issues:
- It is hard for userspace to figure out if the kernel part was loaded or not
  and this fact can change as there is a way to enable/disable the service from
  host side. Racy daemon startup is also a problem.
- When the userspace daemon restarts/dies kernel part doesn't receive a
  notification.
- Netlink communication is not stable under heavy load.
- ...

Re-implement the communication using misc char device. Use ioctl to do
kernel/userspace version negotiation (doesn't make much sense at this moment
as we're breaking backwards compatibility but can be used in future). Read from
the device returns struct hv_vss_msg and userspace is supposed to reply with
__u32.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_snapshot.c    | 335 ++++++++++++++++++++++++++++++++------------
 include/uapi/linux/hyperv.h |   1 +
 tools/hv/hv_vss_daemon.c    | 141 ++++---------------
 3 files changed, 273 insertions(+), 204 deletions(-)

diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 9d5e0d1..b399758 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -20,9 +20,12 @@
 
 #include <linux/net.h>
 #include <linux/nls.h>
-#include <linux/connector.h>
+#include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/mutex.h>
 #include <linux/hyperv.h>
+#include <linux/miscdevice.h>
+#include <linux/poll.h>
 
 #define VSS_MAJOR  5
 #define VSS_MINOR  0
@@ -31,26 +34,36 @@
 #define VSS_USERSPACE_TIMEOUT (msecs_to_jiffies(10 * 1000))
 
 /*
- * Global state maintained for transaction that is being processed.
- * Note that only one transaction can be active at any point in time.
- *
- * This state is set when we receive a request from the host; we
- * cleanup this state when the transaction is completed - when we respond
- * to the host with the key value.
+ * Global state maintained for the device. Note that only one transaction can
+ * be active at any point in time.
  */
 
+enum vss_device_state {
+	VSS_DEVICE_INITIALIZING = 0, /* driver was loaded */
+	VSS_DEVICE_OPENED,           /* device was opened */
+	VSS_READY,                   /* userspace registered */
+	VSS_HOSTMSG_RECEIVED,        /* message from host was received */
+	VSS_USERMSG_READY,           /* message for userspace is ready */
+	VSS_USERSPACE_REQ,           /* request to userspace was sent */
+	VSS_USERSPACE_RECV,          /* reply from userspace was received */
+	VSS_DEVICE_DYING,            /* driver unload is in progress */
+};
+
 static struct {
-	bool active; /* transaction status - active or not */
+	int state; /* vss_device_state */
 	int recv_len; /* number of bytes received. */
 	struct vmbus_channel *recv_channel; /* chn we got the request */
 	u64 recv_req_id; /* request ID. */
-	struct hv_vss_msg  *msg; /* current message */
-} vss_transaction;
-
+	void *vss_context; /* for the channel callback */
+	int dm_reg_value; /* daemon version number */
+	struct mutex lock; /* syncronization */
+	struct hv_vss_msg user_msg; /* message to/from userspace */
+	struct hv_vss_msg host_msg; /* message to/from host */
+	wait_queue_head_t proc_list; /* waiting processes */
+} vss_device;
 
-static void vss_respond_to_host(int error);
+static void vss_respond_to_host(u32 error);
 
-static struct cb_id vss_id = { CN_VSS_IDX, CN_VSS_VAL };
 static const char vss_name[] = "vss_kernel_module";
 static __u8 *recv_buffer;
 
@@ -60,6 +73,23 @@ static void vss_timeout_func(struct work_struct *dummy);
 static DECLARE_DELAYED_WORK(vss_timeout_work, vss_timeout_func);
 static DECLARE_WORK(vss_send_op_work, vss_send_op);
 
+static int vss_handle_handshake(u32 op)
+{
+	vss_device.dm_reg_value = op;
+
+	return 0;
+}
+
+static void poll_channel(struct vmbus_channel *channel)
+{
+	if (channel->target_cpu != smp_processor_id())
+		smp_call_function_single(channel->target_cpu,
+					 hv_vss_onchannelcallback,
+					 channel, true);
+	else
+		hv_vss_onchannelcallback(channel);
+}
+
 /*
  * Callback when data is received from user mode.
  */
@@ -73,62 +103,27 @@ static void vss_timeout_func(struct work_struct *dummy)
 	vss_respond_to_host(HV_E_FAIL);
 }
 
-static void
-vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
-{
-	struct hv_vss_msg *vss_msg;
-
-	vss_msg = (struct hv_vss_msg *)msg->data;
-
-	if (vss_msg->vss_hdr.operation == VSS_OP_REGISTER) {
-		pr_info("VSS daemon registered\n");
-		vss_transaction.active = false;
-		if (vss_transaction.recv_channel != NULL)
-			hv_vss_onchannelcallback(vss_transaction.recv_channel);
-		return;
-
-	}
-	if (cancel_delayed_work_sync(&vss_timeout_work))
-		vss_respond_to_host(vss_msg->error);
-}
-
-
 static void vss_send_op(struct work_struct *dummy)
 {
-	int op = vss_transaction.msg->vss_hdr.operation;
-	int rc;
-	struct cn_msg *msg;
-	struct hv_vss_msg *vss_msg;
+	mutex_lock(&vss_device.lock);
 
-	msg = kzalloc(sizeof(*msg) + sizeof(*vss_msg), GFP_ATOMIC);
-	if (!msg)
+	if (vss_device.state != VSS_HOSTMSG_RECEIVED)
 		return;
 
-	vss_msg = (struct hv_vss_msg *)msg->data;
-
-	msg->id.idx =  CN_VSS_IDX;
-	msg->id.val = CN_VSS_VAL;
-
-	vss_msg->vss_hdr.operation = op;
-	msg->len = sizeof(struct hv_vss_msg);
+	memcpy(&vss_device.user_msg, &vss_device.host_msg,
+	       sizeof(struct hv_vss_msg));
 
-	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
-	if (rc) {
-		pr_warn("VSS: failed to communicate to the daemon: %d\n", rc);
-		if (cancel_delayed_work_sync(&vss_timeout_work))
-			vss_respond_to_host(HV_E_FAIL);
-	}
-	kfree(msg);
+	vss_device.state = VSS_USERMSG_READY;
+	wake_up_interruptible(&vss_device.proc_list);
 
+	mutex_unlock(&vss_device.lock);
 	return;
 }
 
 /*
  * Send a response back to the host.
  */
-
-static void
-vss_respond_to_host(int error)
+static void vss_respond_to_host(u32 error)
 {
 	struct icmsg_hdr *icmsghdrp;
 	u32	buf_len;
@@ -136,25 +131,13 @@ vss_respond_to_host(int error)
 	u64	req_id;
 
 	/*
-	 * If a transaction is not active; log and return.
-	 */
-
-	if (!vss_transaction.active) {
-		/*
-		 * This is a spurious call!
-		 */
-		pr_warn("VSS: Transaction not active\n");
-		return;
-	}
-	/*
 	 * Copy the global state for completing the transaction. Note that
 	 * only one transaction can be active at a time.
 	 */
 
-	buf_len = vss_transaction.recv_len;
-	channel = vss_transaction.recv_channel;
-	req_id = vss_transaction.recv_req_id;
-	vss_transaction.active = false;
+	buf_len = vss_device.recv_len;
+	channel = vss_device.recv_channel;
+	req_id = vss_device.recv_req_id;
 
 	icmsghdrp = (struct icmsg_hdr *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
@@ -173,6 +156,17 @@ vss_respond_to_host(int error)
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
 
+	/* We're ready to process next request, reset the device state */
+	if (vss_device.state == VSS_USERSPACE_RECV ||
+	    vss_device.state == VSS_USERSPACE_REQ)
+		vss_device.state = VSS_READY;
+	/*
+	 * Make sure device state was set before polling the channel as
+	 * processing can happen on a different CPU.
+	 */
+	smp_mb();
+
+	poll_channel(channel);
 }
 
 /*
@@ -186,19 +180,18 @@ void hv_vss_onchannelcallback(void *context)
 	u32 recvlen;
 	u64 requestid;
 	struct hv_vss_msg *vss_msg;
-
-
 	struct icmsg_hdr *icmsghdrp;
 	struct icmsg_negotiate *negop = NULL;
 
-	if (vss_transaction.active) {
+	if (vss_device.state > VSS_READY) {
 		/*
 		 * We will defer processing this callback once
 		 * the current transaction is complete.
 		 */
-		vss_transaction.recv_channel = channel;
+		vss_device.vss_context = channel;
 		return;
 	}
+	vss_device.vss_context = NULL;
 
 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
 			 &requestid);
@@ -221,11 +214,9 @@ void hv_vss_onchannelcallback(void *context)
 			 * transaction; note transactions are serialized.
 			 */
 
-			vss_transaction.recv_len = recvlen;
-			vss_transaction.recv_channel = channel;
-			vss_transaction.recv_req_id = requestid;
-			vss_transaction.active = true;
-			vss_transaction.msg = (struct hv_vss_msg *)vss_msg;
+			vss_device.recv_len = recvlen;
+			vss_device.recv_channel = channel;
+			vss_device.recv_req_id = requestid;
 
 			switch (vss_msg->vss_hdr.operation) {
 				/*
@@ -241,6 +232,15 @@ void hv_vss_onchannelcallback(void *context)
 				 */
 			case VSS_OP_FREEZE:
 			case VSS_OP_THAW:
+				if (vss_device.state != VSS_READY) {
+					/* Userspace daemon is not connected */
+					vss_respond_to_host(HV_E_FAIL);
+					return;
+				}
+
+				memcpy(&vss_device.host_msg, vss_msg,
+				       sizeof(struct hv_vss_msg));
+				vss_device.state = VSS_HOSTMSG_RECEIVED;
 				schedule_work(&vss_send_op_work);
 				schedule_delayed_work(&vss_timeout_work,
 						      VSS_USERSPACE_TIMEOUT);
@@ -275,14 +275,164 @@ void hv_vss_onchannelcallback(void *context)
 
 }
 
-int
-hv_vss_init(struct hv_util_service *srv)
+static int vss_op_open(struct inode *inode, struct file *f)
 {
-	int err;
+	if (vss_device.state != VSS_DEVICE_INITIALIZING)
+		return -EBUSY;
+	vss_device.state = VSS_DEVICE_OPENED;
+	return 0;
+}
 
-	err = cn_add_callback(&vss_id, vss_name, vss_cn_callback);
-	if (err)
-		return err;
+static int vss_op_release(struct inode *inode, struct file *f)
+{
+	vss_device.state = VSS_DEVICE_INITIALIZING;
+	return 0;
+}
+
+static ssize_t vss_op_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	int ret = 0;
+	u32 val32;
+
+	if (vss_device.state == VSS_DEVICE_DYING)
+		return -EFAULT;
+
+	if (count != sizeof(u32)) {
+		pr_warn("vss_op_write: invalid write len: %d (expected: %d)\n",
+			(int)count, (int)sizeof(u32));
+		return -EINVAL;
+	}
+
+	mutex_lock(&vss_device.lock);
+
+	if (vss_device.state == VSS_USERSPACE_REQ) {
+		if (!copy_from_user(&val32, buf, sizeof(u32))) {
+			vss_device.state = VSS_USERSPACE_RECV;
+			if (cancel_delayed_work_sync(&vss_timeout_work))
+				vss_respond_to_host(val32);
+			ret = sizeof(u32);
+		} else
+			ret = -EFAULT;
+	} else {
+		pr_warn("vss_op_write: invalid transaction state: %d\n",
+			vss_device.state);
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&vss_device.lock);
+	return ret;
+}
+
+static ssize_t vss_op_read(struct file *file, char __user *buf,
+			   size_t count, loff_t *ppos)
+{
+	ssize_t ret = 0;
+
+	if (vss_device.state == VSS_DEVICE_DYING)
+		return -EFAULT;
+
+	if (count != sizeof(struct hv_vss_msg)) {
+		pr_warn("vss_op_read: invalid read len: %d (expected: %d)\n",
+			(int)count, (int)sizeof(struct hv_vss_msg));
+		return -EINVAL;
+	}
+
+	if (wait_event_interruptible(vss_device.proc_list,
+				     vss_device.state == VSS_USERMSG_READY ||
+				     vss_device.state == VSS_DEVICE_DYING))
+		return -EFAULT;
+
+	if (vss_device.state != VSS_USERMSG_READY)
+		return -EFAULT;
+
+	mutex_lock(&vss_device.lock);
+
+	if (!copy_to_user(buf, &vss_device.user_msg,
+			  sizeof(struct hv_vss_msg))) {
+		vss_device.state = VSS_USERSPACE_REQ;
+		ret = sizeof(struct hv_vss_msg);
+	} else
+		ret = -EFAULT;
+
+	mutex_unlock(&vss_device.lock);
+	return ret;
+}
+
+static unsigned int vss_op_poll(struct file *file, poll_table *wait)
+{
+	if (vss_device.state == VSS_DEVICE_DYING)
+		return -EFAULT;
+
+	poll_wait(file, &vss_device.proc_list, wait);
+	if (vss_device.state == VSS_USERMSG_READY)
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static long vss_op_ioctl(struct file *fp,
+			 unsigned int cmd, unsigned long arg)
+{
+	long ret = 0;
+	void __user *argp = (void __user *)arg;
+	u32 val32;
+
+	if (vss_device.state == VSS_DEVICE_DYING)
+		return -EFAULT;
+
+	/* The only ioctl we have is registation */
+	if (vss_device.state != VSS_DEVICE_OPENED)
+		return -EINVAL;
+
+	mutex_lock(&vss_device.lock);
+
+	switch (cmd) {
+	case HYPERV_VSS_REGISTER:
+		if (copy_from_user(&val32, argp, sizeof(val32))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (!vss_handle_handshake(val32)) {
+			val32 = (u32)VSS_VERSION;
+			if (copy_to_user(argp, &val32, sizeof(val32))) {
+				ret = -EFAULT;
+				break;
+			}
+			vss_device.state = VSS_READY;
+			pr_info("VSS: user-mode registering done.\n");
+			if (vss_device.vss_context)
+				poll_channel(vss_device.vss_context);
+		} else
+			ret = -EINVAL;
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&vss_device.lock);
+	return ret;
+}
+
+static const struct file_operations vss_fops = {
+	.owner		= THIS_MODULE,
+	.read           = vss_op_read,
+	.write          = vss_op_write,
+	.release	= vss_op_release,
+	.open		= vss_op_open,
+	.poll		= vss_op_poll,
+	.unlocked_ioctl = vss_op_ioctl
+};
+
+static struct miscdevice vss_misc = {
+	.minor          = MISC_DYNAMIC_MINOR,
+	.name           = "vmbus/hv_vss",
+	.fops           = &vss_fops,
+};
+
+int hv_vss_init(struct hv_util_service *srv)
+{
 	recv_buffer = srv->recv_buffer;
 
 	/*
@@ -291,13 +441,20 @@ hv_vss_init(struct hv_util_service *srv)
 	 * Defer processing channel callbacks until the daemon
 	 * has registered.
 	 */
-	vss_transaction.active = true;
-	return 0;
+	vss_device.state = VSS_DEVICE_INITIALIZING;
+	init_waitqueue_head(&vss_device.proc_list);
+	mutex_init(&vss_device.lock);
+
+	return misc_register(&vss_misc);
 }
 
 void hv_vss_deinit(void)
 {
-	cn_del_callback(&vss_id);
+	vss_device.state = VSS_DEVICE_DYING;
+	/* Make sure nobody sees the old state */
+	smp_mb();
+	wake_up_interruptible(&vss_device.proc_list);
 	cancel_delayed_work_sync(&vss_timeout_work);
 	cancel_work_sync(&vss_send_op_work);
+	misc_deregister(&vss_misc);
 }
diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 80713a3..1939826 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -396,5 +396,6 @@ struct hv_kvp_ip_msg {
  * either KVP_OP_REGISTER or KVP_OP_REGISTER1.
  */
 #define HYPERV_KVP_REGISTER        _IOWR('v', 0, __u32)
+#define HYPERV_VSS_REGISTER        _IOWR('v', 0, __u32)
 
 #endif /* _UAPI_HYPERV_H */
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 5e63f70..d3f1fe9 100644
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
@@ -174,17 +136,13 @@ void print_usage(char *argv[])
 
 int main(int argc, char *argv[])
 {
-	int fd, len, nl_group;
-	int error;
-	struct cn_msg *message;
+	int vss_fd, len;
+	__u32 error;
 	struct pollfd pfd;
-	struct nlmsghdr *incoming_msg;
-	struct cn_msg	*incoming_cn_msg;
 	int	op;
-	struct hv_vss_msg *vss_msg;
-	char *vss_recv_buffer;
-	size_t vss_recv_buffer_len;
+	struct hv_vss_msg vss_msg[1];
 	int daemonize = 1, long_index = 0, opt;
+	__u32 daemon_ver = 1; /* No special meaning */
 
 	static struct option long_options[] = {
 		{"help",	no_argument,	   0,  'h' },
@@ -211,98 +169,50 @@ int main(int argc, char *argv[])
 	openlog("Hyper-V VSS", 0, LOG_USER);
 	syslog(LOG_INFO, "VSS starting; pid is:%d", getpid());
 
-	vss_recv_buffer_len = NLMSG_LENGTH(0) + sizeof(struct cn_msg) + sizeof(struct hv_vss_msg);
-	vss_recv_buffer = calloc(1, vss_recv_buffer_len);
-	if (!vss_recv_buffer) {
-		syslog(LOG_ERR, "Failed to allocate netlink buffers");
-		exit(EXIT_FAILURE);
-	}
+	vss_fd = open("/dev/vmbus/hv_vss", O_RDWR);
 
-	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
-	if (fd < 0) {
-		syslog(LOG_ERR, "netlink socket creation failed; error:%d %s",
-				errno, strerror(errno));
+	if (vss_fd < 0) {
+		syslog(LOG_ERR, "open /dev/vmbus/hv_vss failed; error: %d %s",
+			errno, strerror(errno));
 		exit(EXIT_FAILURE);
 	}
-	addr.nl_family = AF_NETLINK;
-	addr.nl_pad = 0;
-	addr.nl_pid = 0;
-	addr.nl_groups = 0;
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
-		exit(EXIT_FAILURE);
-	}
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
-
-	len = netlink_send(fd, message);
-	if (len < 0) {
-		syslog(LOG_ERR, "netlink_send failed; error:%d %s", errno, strerror(errno));
-		close(fd);
+	if (ioctl(vss_fd, HYPERV_VSS_REGISTER, &daemon_ver)) {
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
+		if (len != sizeof(struct hv_vss_msg)) {
+			syslog(LOG_ERR, "read failed; error:%d %s",
+			       errno, strerror(errno));
 
-		if (addr.nl_pid) {
-			syslog(LOG_WARNING,
-				"Received packet from untrusted pid:%u",
-				addr.nl_pid);
-			continue;
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
 
@@ -324,13 +234,14 @@ int main(int argc, char *argv[])
 		default:
 			syslog(LOG_ERR, "Illegal op:%d\n", op);
 		}
-		vss_msg->error = error;
-		len = netlink_send(fd, incoming_cn_msg);
-		if (len < 0) {
-			syslog(LOG_ERR, "net_link send failed; error:%d %s",
-					errno, strerror(errno));
+
+		if (write(vss_fd, &error, sizeof(__u32)) != sizeof(__u32)) {
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
