From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 1/3] Drivers: hv: kvp: convert userspace/kernel communication to using char device
Date: Fri, 27 Feb 2015 17:14:23 +0100
Message-ID: <1425053665-635-2-git-send-email-vkuznets@redhat.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org
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
as we're breaking backwards compatibility but can be used in future).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_kvp.c         | 396 +++++++++++++++++++++++++++-----------------
 include/uapi/linux/hyperv.h |   8 +
 tools/hv/hv_kvp_daemon.c    | 187 ++++-----------------
 3 files changed, 287 insertions(+), 304 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index beb8105..8078b1a 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -22,12 +22,16 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/net.h>
 #include <linux/nls.h>
-#include <linux/connector.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/mutex.h>
 #include <linux/hyperv.h>
+#include <linux/miscdevice.h>
+#include <linux/poll.h>
 
+#include <linux/uaccess.h>
 
 /*
  * Pre win8 version numbers used in ws2008 and ws 2008 r2 (win7)
@@ -45,46 +49,41 @@
 #define WIN8_SRV_VERSION     (WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
 
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
 
+enum kvp_device_state {
+	KVP_DEVICE_INITIALIZING = 0, /* driver was loaded */
+	KVP_DEVICE_OPENED,           /* device was opened */
+	KVP_READY,                   /* userspace was registered */
+	KVP_HOSTMSG_RECEIVED,        /* message from host was received */
+	KVP_USERMSG_READY,           /* message for userspace is ready */
+	KVP_USERSPACE_REQ,           /* request to userspace was sent */
+	KVP_USERSPACE_RECV,          /* reply from userspace was received */
+	KVP_DEVICE_DYING,            /* driver unload is in progress */
+};
+
 static struct {
-	bool active; /* transaction status - active or not */
+	int state; /* kvp_device_state */
 	int recv_len; /* number of bytes received. */
-	struct hv_kvp_msg  *kvp_msg; /* current message */
 	struct vmbus_channel *recv_channel; /* chn we got the request */
 	u64 recv_req_id; /* request ID. */
 	void *kvp_context; /* for the channel callback */
-} kvp_transaction;
-
-/*
- * Before we can accept KVP messages from the host, we need
- * to handshake with the user level daemon. This state tracks
- * if we are in the handshake phase.
- */
-static bool in_hand_shake = true;
-
-/*
- * This state maintains the version number registered by the daemon.
- */
-static int dm_reg_value;
+	int dm_reg_value; /* daemon version number */
+	struct mutex lock; /* syncronization */
+	struct hv_kvp_msg user_msg; /* message to/from userspace */
+	struct hv_kvp_msg host_msg; /* message to/from host */
+	wait_queue_head_t proc_list; /* waiting processes */
+} kvp_device;
 
 static void kvp_send_key(struct work_struct *dummy);
-
-
-static void kvp_respond_to_host(struct hv_kvp_msg *msg, int error);
+static void kvp_respond_to_host(int error);
 static void kvp_work_func(struct work_struct *dummy);
-static void kvp_register(int);
 
 static DECLARE_DELAYED_WORK(kvp_work, kvp_work_func);
 static DECLARE_WORK(kvp_sendkey_work, kvp_send_key);
 
-static struct cb_id kvp_id = { CN_KVP_IDX, CN_KVP_VAL };
 static const char kvp_name[] = "kvp_kernel_module";
 static u8 *recv_buffer;
 /*
@@ -92,31 +91,8 @@ static u8 *recv_buffer;
  * As part of this registration, pass the LIC version number.
  * This number has no meaning, it satisfies the registration protocol.
  */
-#define HV_DRV_VERSION           "3.1"
-
-static void
-kvp_register(int reg_value)
-{
-
-	struct cn_msg *msg;
-	struct hv_kvp_msg *kvp_msg;
-	char *version;
-
-	msg = kzalloc(sizeof(*msg) + sizeof(struct hv_kvp_msg), GFP_ATOMIC);
+#define HV_DRV_VERSION           31
 
-	if (msg) {
-		kvp_msg = (struct hv_kvp_msg *)msg->data;
-		version = kvp_msg->body.kvp_register.version;
-		msg->id.idx =  CN_KVP_IDX;
-		msg->id.val = CN_KVP_VAL;
-
-		kvp_msg->kvp_hdr.operation = reg_value;
-		strcpy(version, HV_DRV_VERSION);
-		msg->len = sizeof(struct hv_kvp_msg);
-		cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
-		kfree(msg);
-	}
-}
 static void
 kvp_work_func(struct work_struct *dummy)
 {
@@ -124,7 +100,7 @@ kvp_work_func(struct work_struct *dummy)
 	 * If the timer fires, the user-mode component has not responded;
 	 * process the pending transaction.
 	 */
-	kvp_respond_to_host(NULL, HV_E_FAIL);
+	kvp_respond_to_host(HV_E_FAIL);
 }
 
 static void poll_channel(struct vmbus_channel *channel)
@@ -138,36 +114,26 @@ static void poll_channel(struct vmbus_channel *channel)
 }
 
 
-static int kvp_handle_handshake(struct hv_kvp_msg *msg)
+static int kvp_handle_handshake(u32 op)
 {
-	int ret = 1;
+	int ret = 0;
 
-	switch (msg->kvp_hdr.operation) {
+	switch (op) {
 	case KVP_OP_REGISTER:
-		dm_reg_value = KVP_OP_REGISTER;
+		kvp_device.dm_reg_value = KVP_OP_REGISTER;
 		pr_info("KVP: IP injection functionality not available\n");
 		pr_info("KVP: Upgrade the KVP daemon\n");
 		break;
 	case KVP_OP_REGISTER1:
-		dm_reg_value = KVP_OP_REGISTER1;
+		kvp_device.dm_reg_value = KVP_OP_REGISTER1;
 		break;
 	default:
 		pr_info("KVP: incompatible daemon\n");
 		pr_info("KVP: KVP version: %d, Daemon version: %d\n",
-			KVP_OP_REGISTER1, msg->kvp_hdr.operation);
-		ret = 0;
+			KVP_OP_REGISTER1, op);
+		ret = 1;
 	}
 
-	if (ret) {
-		/*
-		 * We have a compatible daemon; complete the handshake.
-		 */
-		pr_info("KVP: user-mode registering done.\n");
-		kvp_register(dm_reg_value);
-		kvp_transaction.active = false;
-		if (kvp_transaction.kvp_context)
-			poll_channel(kvp_transaction.kvp_context);
-	}
 	return ret;
 }
 
@@ -176,25 +142,11 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
  * Callback when data is received from user mode.
  */
 
-static void
-kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
+static void kvp_userwrite_callback(void)
 {
-	struct hv_kvp_msg *message;
+	struct hv_kvp_msg *message = &kvp_device.user_msg;
 	struct hv_kvp_msg_enumerate *data;
-	int	error = 0;
-
-	message = (struct hv_kvp_msg *)msg->data;
-
-	/*
-	 * If we are negotiating the version information
-	 * with the daemon; handle that first.
-	 */
-
-	if (in_hand_shake) {
-		if (kvp_handle_handshake(message))
-			in_hand_shake = false;
-		return;
-	}
+	int error = 0;
 
 	/*
 	 * Based on the version of the daemon, we propagate errors from the
@@ -203,7 +155,7 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 
 	data = &message->body.kvp_enum_data;
 
-	switch (dm_reg_value) {
+	switch (kvp_device.dm_reg_value) {
 	case KVP_OP_REGISTER:
 		/*
 		 * Null string is used to pass back error condition.
@@ -226,10 +178,9 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	 * to the host. But first, cancel the timeout.
 	 */
 	if (cancel_delayed_work_sync(&kvp_work))
-		kvp_respond_to_host(message, error);
+		kvp_respond_to_host(error);
 }
 
-
 static int process_ob_ipinfo(void *in_msg, void *out_msg, int op)
 {
 	struct hv_kvp_msg *in = in_msg;
@@ -337,32 +288,21 @@ static void process_ib_ipinfo(void *in_msg, void *out_msg, int op)
 	}
 }
 
-
-
-
 static void
 kvp_send_key(struct work_struct *dummy)
 {
-	struct cn_msg *msg;
-	struct hv_kvp_msg *message;
-	struct hv_kvp_msg *in_msg;
-	__u8 operation = kvp_transaction.kvp_msg->kvp_hdr.operation;
-	__u8 pool = kvp_transaction.kvp_msg->kvp_hdr.pool;
+	struct hv_kvp_msg *message = &kvp_device.user_msg;
+	struct hv_kvp_msg *in_msg = &kvp_device.host_msg;
+	__u8 operation = in_msg->kvp_hdr.operation;
+	__u8 pool = in_msg->kvp_hdr.pool;
 	__u32 val32;
 	__u64 val64;
-	int rc;
 
-	msg = kzalloc(sizeof(*msg) + sizeof(struct hv_kvp_msg) , GFP_ATOMIC);
-	if (!msg)
-		return;
-
-	msg->id.idx =  CN_KVP_IDX;
-	msg->id.val = CN_KVP_VAL;
+	mutex_lock(&kvp_device.lock);
 
-	message = (struct hv_kvp_msg *)msg->data;
+	memset(message, 0, sizeof(struct hv_kvp_msg));
 	message->kvp_hdr.operation = operation;
 	message->kvp_hdr.pool = pool;
-	in_msg = kvp_transaction.kvp_msg;
 
 	/*
 	 * The key/value strings sent from the host are encoded in
@@ -446,15 +386,10 @@ kvp_send_key(struct work_struct *dummy)
 			break;
 	}
 
-	msg->len = sizeof(struct hv_kvp_msg);
-	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
-	if (rc) {
-		pr_debug("KVP: failed to communicate to the daemon: %d\n", rc);
-		if (cancel_delayed_work_sync(&kvp_work))
-			kvp_respond_to_host(message, HV_E_FAIL);
-	}
+	kvp_device.state = KVP_USERMSG_READY;
+	wake_up_interruptible(&kvp_device.proc_list);
 
-	kfree(msg);
+	mutex_unlock(&kvp_device.lock);
 
 	return;
 }
@@ -463,10 +398,10 @@ kvp_send_key(struct work_struct *dummy)
  * Send a response back to the host.
  */
 
-static void
-kvp_respond_to_host(struct hv_kvp_msg *msg_to_host, int error)
+static void kvp_respond_to_host(int error)
 {
 	struct hv_kvp_msg  *kvp_msg;
+	struct hv_kvp_msg  *msg_to_host = &kvp_device.user_msg;
 	struct hv_kvp_exchg_msg_value  *kvp_data;
 	char	*key_name;
 	char	*value;
@@ -479,26 +414,13 @@ kvp_respond_to_host(struct hv_kvp_msg *msg_to_host, int error)
 	int ret;
 
 	/*
-	 * If a transaction is not active; log and return.
-	 */
-
-	if (!kvp_transaction.active) {
-		/*
-		 * This is a spurious call!
-		 */
-		pr_warn("KVP: Transaction not active\n");
-		return;
-	}
-	/*
 	 * Copy the global state for completing the transaction. Note that
 	 * only one transaction can be active at a time.
 	 */
 
-	buf_len = kvp_transaction.recv_len;
-	channel = kvp_transaction.recv_channel;
-	req_id = kvp_transaction.recv_req_id;
-
-	kvp_transaction.active = false;
+	buf_len = kvp_device.recv_len;
+	channel = kvp_device.recv_channel;
+	req_id = kvp_device.recv_req_id;
 
 	icmsghdrp = (struct icmsg_hdr *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
@@ -528,7 +450,8 @@ kvp_respond_to_host(struct hv_kvp_msg *msg_to_host, int error)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr) +
 			sizeof(struct icmsg_hdr)];
 
-	switch (kvp_transaction.kvp_msg->kvp_hdr.operation) {
+
+	switch (kvp_device.host_msg.kvp_hdr.operation) {
 	case KVP_OP_GET_IP_INFO:
 		ret = process_ob_ipinfo(msg_to_host,
 				 (struct hv_kvp_ip_msg *)kvp_msg,
@@ -586,6 +509,17 @@ response_done:
 
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
+
+	/* We're ready to process next request, reset the device state */
+	if (kvp_device.state == KVP_USERSPACE_RECV ||
+	    kvp_device.state == KVP_USERSPACE_REQ)
+		kvp_device.state = KVP_READY;
+	/*
+	 * Make sure device state was set before polling the channel as
+	 * processing can happen on a different CPU.
+	 */
+	smp_mb();
+
 	poll_channel(channel);
 }
 
@@ -612,14 +546,15 @@ void hv_kvp_onchannelcallback(void *context)
 	int util_fw_version;
 	int kvp_srv_version;
 
-	if (kvp_transaction.active) {
+	if (kvp_device.state > KVP_READY) {
 		/*
 		 * We will defer processing this callback once
 		 * the current transaction is complete.
 		 */
-		kvp_transaction.kvp_context = context;
+		kvp_device.kvp_context = channel;
 		return;
 	}
+	kvp_device.kvp_context = NULL;
 
 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 4, &recvlen,
 			 &requestid);
@@ -661,11 +596,19 @@ void hv_kvp_onchannelcallback(void *context)
 			 * transaction; note transactions are serialized.
 			 */
 
-			kvp_transaction.recv_len = recvlen;
-			kvp_transaction.recv_channel = channel;
-			kvp_transaction.recv_req_id = requestid;
-			kvp_transaction.active = true;
-			kvp_transaction.kvp_msg = kvp_msg;
+			kvp_device.recv_len = recvlen;
+			kvp_device.recv_channel = channel;
+			kvp_device.recv_req_id = requestid;
+
+			if (kvp_device.state != KVP_READY) {
+				/* Userspace daemon is not connected, fail. */
+				kvp_respond_to_host(HV_E_FAIL);
+				return;
+			}
+
+			kvp_device.state = KVP_HOSTMSG_RECEIVED;
+			memcpy(&kvp_device.host_msg, kvp_msg,
+			       sizeof(struct hv_kvp_msg));
 
 			/*
 			 * Get the information from the
@@ -690,17 +633,166 @@ void hv_kvp_onchannelcallback(void *context)
 				       recvlen, requestid,
 				       VM_PKT_DATA_INBAND, 0);
 	}
+}
+
+static int kvp_op_open(struct inode *inode, struct file *f)
+{
+	if (kvp_device.state != KVP_DEVICE_INITIALIZING)
+		return -EBUSY;
+	kvp_device.state = KVP_DEVICE_OPENED;
+	return 0;
+}
+
+static int kvp_op_release(struct inode *inode, struct file *f)
+{
+	kvp_device.state = KVP_DEVICE_INITIALIZING;
+	return 0;
+}
+
+static ssize_t kvp_op_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	int ret = 0;
+
+	if (kvp_device.state == KVP_DEVICE_DYING)
+		return -EFAULT;
+
+	if (count != sizeof(struct hv_kvp_msg)) {
+		pr_warn("kvp_op_write: invalid write len: %d (expected: %d)\n",
+			(int)count, (int)sizeof(struct hv_kvp_msg));
+		return -EINVAL;
+	}
 
+	mutex_lock(&kvp_device.lock);
+
+	if (kvp_device.state == KVP_USERSPACE_REQ) {
+		if (!copy_from_user(&kvp_device.user_msg, buf,
+				    sizeof(struct hv_kvp_msg))) {
+			kvp_device.state = KVP_USERSPACE_RECV;
+			kvp_userwrite_callback();
+			ret = sizeof(struct hv_kvp_msg);
+		} else
+			ret = -EFAULT;
+	} else {
+		pr_warn("kvp_op_write: invalid transaction state: %d\n",
+			kvp_device.state);
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&kvp_device.lock);
+	return ret;
 }
 
+static ssize_t kvp_op_read(struct file *file, char __user *buf,
+			   size_t count, loff_t *ppos)
+{
+	ssize_t ret = 0;
+
+	if (kvp_device.state == KVP_DEVICE_DYING)
+		return -EFAULT;
+
+	if (count != sizeof(struct hv_kvp_msg)) {
+		pr_warn("kvp_op_read: invalid read len: %d (expected: %d)\n",
+			(int)count, (int)sizeof(struct hv_kvp_msg));
+		return -EINVAL;
+	}
+
+	if (wait_event_interruptible(kvp_device.proc_list,
+				     kvp_device.state == KVP_USERMSG_READY ||
+				     kvp_device.state == KVP_DEVICE_DYING))
+		return -EFAULT;
+
+	if (kvp_device.state != KVP_USERMSG_READY)
+		return -EFAULT;
+
+	mutex_lock(&kvp_device.lock);
+
+	if (!copy_to_user(buf, &kvp_device.user_msg,
+			  sizeof(struct hv_kvp_msg))) {
+		kvp_device.state = KVP_USERSPACE_REQ;
+		ret = sizeof(struct hv_kvp_msg);
+	} else
+		ret = -EFAULT;
+
+	mutex_unlock(&kvp_device.lock);
+	return ret;
+}
+
+static unsigned int kvp_op_poll(struct file *file, poll_table *wait)
+{
+	if (kvp_device.state == KVP_DEVICE_DYING)
+		return -EFAULT;
+
+	poll_wait(file, &kvp_device.proc_list, wait);
+	if (kvp_device.state == KVP_USERMSG_READY)
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static long kvp_op_ioctl(struct file *fp,
+			 unsigned int cmd, unsigned long arg)
+{
+	long ret = 0;
+	void __user *argp = (void __user *)arg;
+	u32 val32;
+
+	if (kvp_device.state == KVP_DEVICE_DYING)
+		return -EFAULT;
+
+	/* The only ioctl we have is registation */
+	if (kvp_device.state != KVP_DEVICE_OPENED)
+		return -EINVAL;
+
+	mutex_lock(&kvp_device.lock);
+
+	switch (cmd) {
+	case HYPERV_KVP_REGISTER:
+		if (copy_from_user(&val32, argp, sizeof(val32))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (!kvp_handle_handshake(val32)) {
+			val32 = (u32)HV_DRV_VERSION;
+			if (copy_to_user(argp, &val32, sizeof(val32))) {
+				ret = -EFAULT;
+				break;
+			}
+			kvp_device.state = KVP_READY;
+			pr_info("KVP: user-mode registering done.\n");
+			if (kvp_device.kvp_context)
+				poll_channel(kvp_device.kvp_context);
+		} else
+			ret = -EINVAL;
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&kvp_device.lock);
+	return ret;
+}
+
+static const struct file_operations kvp_fops = {
+	.owner		= THIS_MODULE,
+	.read           = kvp_op_read,
+	.write          = kvp_op_write,
+	.release	= kvp_op_release,
+	.open		= kvp_op_open,
+	.poll		= kvp_op_poll,
+	.unlocked_ioctl = kvp_op_ioctl
+};
+
+static struct miscdevice kvp_misc = {
+	.minor          = MISC_DYNAMIC_MINOR,
+	.name           = "vmbus/hv_kvp",
+	.fops           = &kvp_fops,
+};
+
 int
 hv_kvp_init(struct hv_util_service *srv)
 {
-	int err;
-
-	err = cn_add_callback(&kvp_id, kvp_name, kvp_cn_callback);
-	if (err)
-		return err;
 	recv_buffer = srv->recv_buffer;
 
 	/*
@@ -709,14 +801,20 @@ hv_kvp_init(struct hv_util_service *srv)
 	 * Defer processing channel callbacks until the daemon
 	 * has registered.
 	 */
-	kvp_transaction.active = true;
+	kvp_device.state = KVP_DEVICE_INITIALIZING;
+	init_waitqueue_head(&kvp_device.proc_list);
+	mutex_init(&kvp_device.lock);
 
-	return 0;
+	return misc_register(&kvp_misc);
 }
 
 void hv_kvp_deinit(void)
 {
-	cn_del_callback(&kvp_id);
+	kvp_device.state = KVP_DEVICE_DYING;
+	/* Make sure nobody sees the old state */
+	smp_mb();
+	wake_up_interruptible(&kvp_device.proc_list);
 	cancel_delayed_work_sync(&kvp_work);
 	cancel_work_sync(&kvp_sendkey_work);
+	misc_deregister(&kvp_misc);
 }
diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index bb1cb73..80713a3 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -26,6 +26,7 @@
 #define _UAPI_HYPERV_H
 
 #include <linux/uuid.h>
+#include <linux/types.h>
 
 /*
  * Framework version for util services.
@@ -389,4 +390,11 @@ struct hv_kvp_ip_msg {
 	struct hv_kvp_ipaddr_value      kvp_ip_val;
 } __attribute__((packed));
 
+/*
+ * Userspace registration ioctls. Userspace daemons are supposed to pass their
+ * version as a parameter and get driver version back. KVP daemon supplies
+ * either KVP_OP_REGISTER or KVP_OP_REGISTER1.
+ */
+#define HYPERV_KVP_REGISTER        _IOWR('v', 0, __u32)
+
 #endif /* _UAPI_HYPERV_H */
diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 408bb07..0c3cac7 100644
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
@@ -44,6 +43,7 @@
 #include <dirent.h>
 #include <net/if.h>
 #include <getopt.h>
+#include <sys/ioctl.h>
 
 /*
  * KVP protocol: The user mode component first registers with the
@@ -79,9 +79,6 @@ enum {
 	DNS
 };
 
-static struct sockaddr_nl addr;
-static int in_hand_shake = 1;
-
 static char *os_name = "";
 static char *os_major = "";
 static char *os_minor = "";
@@ -1387,34 +1384,6 @@ kvp_get_domain_name(char *buffer, int length)
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
@@ -1425,23 +1394,18 @@ void print_usage(char *argv[])
 
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
+	__u32 daemon_ver = (__u32)KVP_OP_REGISTER1;
 
 	static struct option long_options[] = {
 		{"help",	no_argument,	   0,  'h' },
@@ -1468,12 +1432,14 @@ int main(int argc, char *argv[])
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
@@ -1489,100 +1455,44 @@ int main(int argc, char *argv[])
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
-	hv_msg->kvp_hdr.operation = KVP_OP_REGISTER1;
-	message->ack = 0;
-	message->len = sizeof(struct hv_kvp_msg);
-
-	len = netlink_send(fd, message);
-	if (len < 0) {
-		syslog(LOG_ERR, "netlink_send failed; error: %d %s", errno, strerror(errno));
-		close(fd);
+	if (ioctl(kvp_fd, HYPERV_KVP_REGISTER, &daemon_ver)) {
+		syslog(LOG_ERR, "registration to kernel failed; error: %d %s",
+		       errno, strerror(errno));
+		close(kvp_fd);
 		exit(EXIT_FAILURE);
 	}
 
-	pfd.fd = fd;
+	syslog(LOG_INFO, "KVP LIC Version: %d", daemon_ver);
+
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
-
-			if (saved_errno == ENOBUFS) {
-				syslog(LOG_ERR, "receive error: ignored");
-				continue;
-			}
+		len = read(kvp_fd, hv_msg, sizeof(struct hv_kvp_msg));
 
-			close(fd);
-			return -1;
-		}
+		if (len != sizeof(struct hv_kvp_msg)) {
+			syslog(LOG_ERR, "read failed; error:%d %s",
+			       errno, strerror(errno));
 
-		if (addr.nl_pid) {
-			syslog(LOG_WARNING, "Received packet from untrusted pid:%u",
-					addr.nl_pid);
-			continue;
+			close(kvp_fd);
+			return EXIT_FAILURE;
 		}
 
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
@@ -1592,24 +1502,6 @@ int main(int argc, char *argv[])
 		pool = hv_msg->kvp_hdr.pool;
 		hv_msg->error = HV_S_OK;
 
-		if ((in_hand_shake) && (op == KVP_OP_REGISTER1)) {
-			/*
-			 * Driver is registering with us; stash away the version
-			 * information.
-			 */
-			in_hand_shake = 0;
-			p = (char *)hv_msg->body.kvp_register.version;
-			lic_version = malloc(strlen(p) + 1);
-			if (lic_version) {
-				strcpy(lic_version, p);
-				syslog(LOG_INFO, "KVP LIC Version: %s",
-					lic_version);
-			} else {
-				syslog(LOG_ERR, "malloc failed");
-			}
-			continue;
-		}
-
 		switch (op) {
 		case KVP_OP_GET_IP_INFO:
 			kvp_ip_val = &hv_msg->body.kvp_ip_val;
@@ -1702,7 +1594,6 @@ int main(int argc, char *argv[])
 			goto kvp_done;
 		}
 
-		hv_msg = (struct hv_kvp_msg *)incoming_cn_msg->data;
 		key_name = (char *)hv_msg->body.kvp_enum_data.data.key;
 		key_value = (char *)hv_msg->body.kvp_enum_data.data.value;
 
@@ -1753,31 +1644,17 @@ int main(int argc, char *argv[])
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
