From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 3/3] Drivers: hv: fcopy: make it consistent with vss/kvp
Date: Fri, 27 Feb 2015 17:14:25 +0100
Message-ID: <1425053665-635-4-git-send-email-vkuznets@redhat.com>
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

Re-implement fcopy in a consistent with "Drivers: hv: vss/kvp: convert
userspace/kernel communication to using char device" way.

In particular:
- Implement "state machine" for the driver instead of 3 separate syncronization
  variables ('fcopy_transaction.active', 'fcopy_transaction.read_sema', 'opened')
- Use ioctl for kernel/userspace version negotiation.
- Support poll() operation.
- Set .owner = THIS_MODULE to prevent kernel crash if the module if being
  unloaded while there is an active file descriptior in userspace.
- Use __u32 instead of int in userspace replies as it matches icmsg_hdr.status.
- Other minor changes to make drivers code look alike.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_fcopy.c       | 395 ++++++++++++++++++++++++++------------------
 include/uapi/linux/hyperv.h |   1 +
 tools/hv/hv_fcopy_daemon.c  |  48 ++++--
 3 files changed, 264 insertions(+), 180 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index cd453e4..05c3580 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
+#include <linux/poll.h>
 
 #include "hyperv_vmbus.h"
 
@@ -35,6 +36,8 @@
 #define WIN8_SRV_MINOR		1
 #define WIN8_SRV_VERSION	(WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
 
+#define MAX_FCOPY_CHSIZE (PAGE_SIZE * 2)
+
 /*
  * Global state maintained for transaction that is being processed.
  * For a class of integration services, including the "file copy service",
@@ -47,36 +50,37 @@
  * ensure this by serializing packet processing in this driver - we do not
  * read additional packets from the VMBUs until the current packet is fully
  * handled.
- *
- * The transaction "active" state is set when we receive a request from the
- * host and we cleanup this state when the transaction is completed - when we
- * respond to the host with our response. When the transaction active state is
- * set, we defer handling incoming packets.
  */
 
+enum fcopy_device_state {
+	FCOPY_DEVICE_INITIALIZING = 0, /* driver was loaded */
+	FCOPY_DEVICE_OPENED,           /* device was opened */
+	FCOPY_READY,                   /* userspace registered */
+	FCOPY_HOSTMSG_RECEIVED,        /* message from host was received */
+	FCOPY_USERMSG_READY,           /* message for userspace is ready */
+	FCOPY_USERSPACE_REQ,           /* request to userspace was sent */
+	FCOPY_USERSPACE_RECV,          /* reply from userspace was received */
+	FCOPY_DEVICE_DYING,            /* driver unload is in progress */
+};
+
 static struct {
-	bool active; /* transaction status - active or not */
+	int state; /* fcopy device state */
 	int recv_len; /* number of bytes received. */
-	struct hv_fcopy_hdr  *fcopy_msg; /* current message */
-	struct hv_start_fcopy  message; /*  sent to daemon */
 	struct vmbus_channel *recv_channel; /* chn we got the request */
 	u64 recv_req_id; /* request ID. */
 	void *fcopy_context; /* for the channel callback */
-	struct semaphore read_sema;
-} fcopy_transaction;
-
-static bool opened; /* currently device opened */
+	int dm_reg_value; /* daemon version number */
+	struct mutex lock; /* syncronization */
+	u8 user_msg[MAX_FCOPY_CHSIZE]; /* message to userspace */
+	u8 host_msg[MAX_FCOPY_CHSIZE]; /* message to/from host */
+	wait_queue_head_t proc_list; /* waiting processes */
+} fcopy_device;
 
-/*
- * Before we can accept copy messages from the host, we need
- * to handshake with the user level daemon. This state tracks
- * if we are in the handshake phase.
- */
-static bool in_hand_shake = true;
-static void fcopy_send_data(void);
 static void fcopy_respond_to_host(int error);
 static void fcopy_work_func(struct work_struct *dummy);
+static void fcopy_send_op(struct work_struct *dummy);
 static DECLARE_DELAYED_WORK(fcopy_work, fcopy_work_func);
+static DECLARE_WORK(fcopy_send_op_work, fcopy_send_op);
 static u8 *recv_buffer;
 
 static void fcopy_work_func(struct work_struct *dummy)
@@ -86,22 +90,22 @@ static void fcopy_work_func(struct work_struct *dummy)
 	 * process the pending transaction.
 	 */
 	fcopy_respond_to_host(HV_E_FAIL);
+}
 
-	/* In the case the user-space daemon crashes, hangs or is killed, we
-	 * need to down the semaphore, otherwise, after the daemon starts next
-	 * time, the obsolete data in fcopy_transaction.message or
-	 * fcopy_transaction.fcopy_msg will be used immediately.
-	 *
-	 * NOTE: fcopy_read() happens to get the semaphore (very rare)? We're
-	 * still OK, because we've reported the failure to the host.
-	 */
-	if (down_trylock(&fcopy_transaction.read_sema))
-		;
-
+static void poll_channel(struct vmbus_channel *channel)
+{
+	if (channel->target_cpu != smp_processor_id())
+		smp_call_function_single(channel->target_cpu,
+					 hv_fcopy_onchannelcallback,
+					 channel, true);
+	else
+		hv_fcopy_onchannelcallback(channel);
 }
 
 static int fcopy_handle_handshake(u32 version)
 {
+	int ret = 0;
+
 	switch (version) {
 	case FCOPY_CURRENT_VERSION:
 		break;
@@ -112,23 +116,19 @@ static int fcopy_handle_handshake(u32 version)
 		 * deal with, we will be backward compatible.
 		 * We will add this code when needed.
 		 */
-		return -EINVAL;
+		ret = -EINVAL;
 	}
-	pr_info("FCP: user-mode registering done. Daemon version: %d\n",
-		version);
-	fcopy_transaction.active = false;
-	if (fcopy_transaction.fcopy_context)
-		hv_fcopy_onchannelcallback(fcopy_transaction.fcopy_context);
-	in_hand_shake = false;
 	return 0;
 }
 
-static void fcopy_send_data(void)
+static void fcopy_send_op(struct work_struct *dummy)
 {
-	struct hv_start_fcopy *smsg_out = &fcopy_transaction.message;
-	int operation = fcopy_transaction.fcopy_msg->operation;
+	struct hv_start_fcopy *smsg_out;
+	struct hv_do_fcopy *dmsg_out;
 	struct hv_start_fcopy *smsg_in;
 
+	mutex_lock(&fcopy_device.lock);
+
 	/*
 	 * The  strings sent from the host are encoded in
 	 * in utf16; convert it to utf8 strings.
@@ -140,11 +140,14 @@ static void fcopy_send_data(void)
 	 * that the strings can be properly terminated!
 	 */
 
-	switch (operation) {
+	switch (((struct hv_fcopy_hdr *)fcopy_device.host_msg)->operation) {
 	case START_FILE_COPY:
-		memset(smsg_out, 0, sizeof(struct hv_start_fcopy));
-		smsg_out->hdr.operation = operation;
-		smsg_in = (struct hv_start_fcopy *)fcopy_transaction.fcopy_msg;
+		memset(&fcopy_device.user_msg, 0,
+		       sizeof(struct hv_start_fcopy));
+
+		smsg_out = (struct hv_start_fcopy *)fcopy_device.user_msg;
+		smsg_out->hdr.operation = START_FILE_COPY;
+		smsg_in = (struct hv_start_fcopy *)fcopy_device.host_msg;
 
 		utf16s_to_utf8s((wchar_t *)smsg_in->file_name, W_MAX_PATH,
 				UTF16_LITTLE_ENDIAN,
@@ -159,9 +162,16 @@ static void fcopy_send_data(void)
 		break;
 
 	default:
+		dmsg_out = (struct hv_do_fcopy *)fcopy_device.user_msg;
+		memcpy(fcopy_device.user_msg, fcopy_device.host_msg,
+		       sizeof(struct hv_do_fcopy));
 		break;
 	}
-	up(&fcopy_transaction.read_sema);
+
+	fcopy_device.state = FCOPY_USERMSG_READY;
+	wake_up_interruptible(&fcopy_device.proc_list);
+
+	mutex_unlock(&fcopy_device.lock);
 	return;
 }
 
@@ -169,8 +179,7 @@ static void fcopy_send_data(void)
  * Send a response back to the host.
  */
 
-static void
-fcopy_respond_to_host(int error)
+static void fcopy_respond_to_host(int error)
 {
 	struct icmsg_hdr *icmsghdr;
 	u32 buf_len;
@@ -185,11 +194,9 @@ fcopy_respond_to_host(int error)
 	 * only be one active transaction at a time.
 	 */
 
-	buf_len = fcopy_transaction.recv_len;
-	channel = fcopy_transaction.recv_channel;
-	req_id = fcopy_transaction.recv_req_id;
-
-	fcopy_transaction.active = false;
+	buf_len = fcopy_device.recv_len;
+	channel = fcopy_device.recv_channel;
+	req_id = fcopy_device.recv_req_id;
 
 	icmsghdr = (struct icmsg_hdr *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
@@ -205,6 +212,20 @@ fcopy_respond_to_host(int error)
 	icmsghdr->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
+
+
+	/* We're ready to process next request, reset the device state */
+	if (fcopy_device.state == FCOPY_USERSPACE_RECV ||
+	    fcopy_device.state == FCOPY_USERSPACE_REQ)
+		fcopy_device.state = FCOPY_READY;
+
+	/*
+	 * Make sure device state was set before polling the channel as
+	 * processing can happen on a different CPU.
+	 */
+	smp_mb();
+
+	poll_channel(channel);
 }
 
 void hv_fcopy_onchannelcallback(void *context)
@@ -218,16 +239,17 @@ void hv_fcopy_onchannelcallback(void *context)
 	int util_fw_version;
 	int fcopy_srv_version;
 
-	if (fcopy_transaction.active) {
+	if (fcopy_device.state > FCOPY_READY) {
 		/*
 		 * We will defer processing this callback once
 		 * the current transaction is complete.
 		 */
-		fcopy_transaction.fcopy_context = context;
+		fcopy_device.fcopy_context = channel;
 		return;
 	}
+	fcopy_device.fcopy_context = NULL;
 
-	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
+	vmbus_recvpacket(channel, recv_buffer, MAX_FCOPY_CHSIZE, &recvlen,
 			 &requestid);
 	if (recvlen <= 0)
 		return;
@@ -235,6 +257,10 @@ void hv_fcopy_onchannelcallback(void *context)
 	icmsghdr = (struct icmsg_hdr *)&recv_buffer[
 			sizeof(struct vmbuspipe_hdr)];
 	if (icmsghdr->icmsgtype == ICMSGTYPE_NEGOTIATE) {
+		/*
+		 * Process negotiation even before usersace daemon is connected
+		 * as we can timeout othervise.
+		 */
 		util_fw_version = UTIL_FW_VERSION;
 		fcopy_srv_version = WIN8_SRV_VERSION;
 		vmbus_prep_negotiate_resp(icmsghdr, negop, recv_buffer,
@@ -249,17 +275,26 @@ void hv_fcopy_onchannelcallback(void *context)
 		 * transaction; note transactions are serialized.
 		 */
 
-		fcopy_transaction.active = true;
-		fcopy_transaction.recv_len = recvlen;
-		fcopy_transaction.recv_channel = channel;
-		fcopy_transaction.recv_req_id = requestid;
-		fcopy_transaction.fcopy_msg = fcopy_msg;
+		fcopy_device.recv_len = recvlen;
+		fcopy_device.recv_channel = channel;
+		fcopy_device.recv_req_id = requestid;
+
+		if (fcopy_device.state != FCOPY_READY) {
+			/* Userspace daemon is not connected, just fail. */
+			fcopy_respond_to_host(HV_E_FAIL);
+			return;
+		}
+
+		memcpy(fcopy_device.host_msg, fcopy_msg, recvlen -
+		       (sizeof(struct vmbuspipe_hdr) +
+			sizeof(struct icmsg_hdr)));
+		fcopy_device.state = FCOPY_HOSTMSG_RECEIVED;
 
 		/*
 		 * Send the information to the user-level daemon.
 		 */
+		schedule_work(&fcopy_send_op_work);
 		schedule_delayed_work(&fcopy_work, 5*HZ);
-		fcopy_send_data();
 		return;
 	}
 	icmsghdr->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
@@ -272,121 +307,170 @@ void hv_fcopy_onchannelcallback(void *context)
  * the payload.
  */
 
-static ssize_t fcopy_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
+static ssize_t fcopy_op_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
 {
-	void *src;
-	size_t copy_size;
-	int operation;
+	ssize_t ret = 0;
+	int copy_size;
+	struct hv_fcopy_hdr *hdr;
+
+	if (wait_event_interruptible(fcopy_device.proc_list,
+				     fcopy_device.state == FCOPY_USERMSG_READY
+				     ||
+				     fcopy_device.state == FCOPY_DEVICE_DYING))
+		return -EFAULT;
 
-	/*
-	 * Wait until there is something to be read.
-	 */
-	if (down_interruptible(&fcopy_transaction.read_sema))
-		return -EINTR;
+	if (fcopy_device.state != FCOPY_USERMSG_READY)
+		return -EFAULT;
 
-	/*
-	 * The channel may be rescinded and in this case, we will wakeup the
-	 * the thread blocked on the semaphore and we will use the opened
-	 * state to correctly handle this case.
-	 */
-	if (!opened)
-		return -ENODEV;
+	mutex_lock(&fcopy_device.lock);
 
-	operation = fcopy_transaction.fcopy_msg->operation;
+	hdr = (struct hv_fcopy_hdr *)fcopy_device.user_msg;
 
-	if (operation == START_FILE_COPY) {
-		src = &fcopy_transaction.message;
+	if (hdr->operation == START_FILE_COPY)
 		copy_size = sizeof(struct hv_start_fcopy);
-		if (count < copy_size)
-			return 0;
-	} else {
-		src = fcopy_transaction.fcopy_msg;
+	else
 		copy_size = sizeof(struct hv_do_fcopy);
-		if (count < copy_size)
-			return 0;
+
+	if (count < copy_size) {
+		pr_warn("fcopy_op_read: invalid read len: %d (expected: %d)\n",
+			(int)count, copy_size);
+		mutex_unlock(&fcopy_device.lock);
+		return -EINVAL;
 	}
-	if (copy_to_user(buf, src, copy_size))
-		return -EFAULT;
 
-	return copy_size;
+	if (!copy_to_user(buf, fcopy_device.user_msg, copy_size)) {
+		fcopy_device.state = FCOPY_USERSPACE_REQ;
+		ret = copy_size;
+	} else
+		ret = -EFAULT;
+
+	mutex_unlock(&fcopy_device.lock);
+	return ret;
 }
 
-static ssize_t fcopy_write(struct file *file, const char __user *buf,
-			size_t count, loff_t *ppos)
+static ssize_t fcopy_op_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
 {
-	int response = 0;
+	int ret = 0;
+	u32 val32;
 
-	if (count != sizeof(int))
-		return -EINVAL;
-
-	if (copy_from_user(&response, buf, sizeof(int)))
+	if (fcopy_device.state == FCOPY_DEVICE_DYING)
 		return -EFAULT;
 
-	if (in_hand_shake) {
-		if (fcopy_handle_handshake(response))
-			return -EINVAL;
-		return sizeof(int);
+	if (count != sizeof(u32)) {
+		pr_warn("fcopy_op_write: invalid write len: %d (expected: %d)\n",
+			(int)count, (int)sizeof(u32));
+		return -EINVAL;
 	}
 
-	/*
-	 * Complete the transaction by forwarding the result
-	 * to the host. But first, cancel the timeout.
-	 */
-	if (cancel_delayed_work_sync(&fcopy_work))
-		fcopy_respond_to_host(response);
+	mutex_lock(&fcopy_device.lock);
 
-	return sizeof(int);
+	if (fcopy_device.state == FCOPY_USERSPACE_REQ) {
+		if (!copy_from_user(&val32, buf, sizeof(u32))) {
+			fcopy_device.state = FCOPY_USERSPACE_RECV;
+			if (cancel_delayed_work_sync(&fcopy_work))
+				fcopy_respond_to_host(val32);
+			ret = sizeof(u32);
+		} else
+			ret = -EFAULT;
+	} else {
+		pr_warn("fcopy_op_write: invalid transaction state: %d\n",
+			fcopy_device.state);
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&fcopy_device.lock);
+	return ret;
 }
 
-static int fcopy_open(struct inode *inode, struct file *f)
+static int fcopy_op_open(struct inode *inode, struct file *f)
 {
 	/*
 	 * The user level daemon that will open this device is
 	 * really an extension of this driver. We can have only
 	 * active open at a time.
 	 */
-	if (opened)
+	if (fcopy_device.state != FCOPY_DEVICE_INITIALIZING)
 		return -EBUSY;
-
-	/*
-	 * The daemon is alive; setup the state.
-	 */
-	opened = true;
+	fcopy_device.state = FCOPY_DEVICE_OPENED;
 	return 0;
 }
 
-/* XXX: there are still some tricky corner cases, e.g.,
- * 1) In a SMP guest, when fcopy_release() runs between
- * schedule_delayed_work() and fcopy_send_data(), there is
- * still a chance an obsolete message will be queued.
- *
- * 2) When the fcopy daemon is running, if we unload the driver,
- * we'll notice a kernel oops when we kill the daemon later.
- */
-static int fcopy_release(struct inode *inode, struct file *f)
+static int fcopy_op_release(struct inode *inode, struct file *f)
 {
 	/*
 	 * The daemon has exited; reset the state.
 	 */
-	in_hand_shake = true;
-	opened = false;
-
-	if (cancel_delayed_work_sync(&fcopy_work)) {
-		/* We haven't up()-ed the semaphore(very rare)? */
-		if (down_trylock(&fcopy_transaction.read_sema))
-			;
-		fcopy_respond_to_host(HV_E_FAIL);
-	}
+	fcopy_device.state = FCOPY_DEVICE_INITIALIZING;
+	return 0;
+}
+
+static unsigned int fcopy_op_poll(struct file *file, poll_table *wait)
+{
+	if (fcopy_device.state == FCOPY_DEVICE_DYING)
+		return -EFAULT;
+
+	poll_wait(file, &fcopy_device.proc_list, wait);
+	if (fcopy_device.state == FCOPY_USERMSG_READY)
+		return POLLIN | POLLRDNORM;
 	return 0;
 }
 
+static long fcopy_op_ioctl(struct file *fp,
+			 unsigned int cmd, unsigned long arg)
+{
+	long ret = 0;
+	void __user *argp = (void __user *)arg;
+	u32 val32;
+
+	if (fcopy_device.state == FCOPY_DEVICE_DYING)
+		return -EFAULT;
+
+	/* The only ioctl we have is registation */
+	if (fcopy_device.state != FCOPY_DEVICE_OPENED)
+		return -EINVAL;
+
+	mutex_lock(&fcopy_device.lock);
+
+	switch (cmd) {
+	case HYPERV_FCOPY_REGISTER:
+		if (copy_from_user(&val32, argp, sizeof(val32))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (!fcopy_handle_handshake(val32)) {
+			/* No special meaning for userspace part for now. */
+			val32 = (u32)WIN8_SRV_VERSION;
+			if (copy_to_user(argp, &val32, sizeof(val32))) {
+				ret = -EFAULT;
+				break;
+			}
+			fcopy_device.state = FCOPY_READY;
+			pr_info("FCOPY: user-mode registering done.\n");
+			if (fcopy_device.fcopy_context)
+				poll_channel(fcopy_device.fcopy_context);
+		} else
+			ret = -EINVAL;
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	mutex_unlock(&fcopy_device.lock);
+	return ret;
+}
 
 static const struct file_operations fcopy_fops = {
-	.read           = fcopy_read,
-	.write          = fcopy_write,
-	.release	= fcopy_release,
-	.open		= fcopy_open,
+	.owner		= THIS_MODULE,
+	.read           = fcopy_op_read,
+	.write          = fcopy_op_write,
+	.release	= fcopy_op_release,
+	.open		= fcopy_op_open,
+	.poll		= fcopy_op_poll,
+	.unlocked_ioctl = fcopy_op_ioctl
 };
 
 static struct miscdevice fcopy_misc = {
@@ -395,29 +479,6 @@ static struct miscdevice fcopy_misc = {
 	.fops           = &fcopy_fops,
 };
 
-static int fcopy_dev_init(void)
-{
-	return misc_register(&fcopy_misc);
-}
-
-static void fcopy_dev_deinit(void)
-{
-
-	/*
-	 * The device is going away - perhaps because the
-	 * host has rescinded the channel. Setup state so that
-	 * user level daemon can gracefully exit if it is blocked
-	 * on the read semaphore.
-	 */
-	opened = false;
-	/*
-	 * Signal the semaphore as the device is
-	 * going away.
-	 */
-	up(&fcopy_transaction.read_sema);
-	misc_deregister(&fcopy_misc);
-}
-
 int hv_fcopy_init(struct hv_util_service *srv)
 {
 	recv_buffer = srv->recv_buffer;
@@ -428,14 +489,20 @@ int hv_fcopy_init(struct hv_util_service *srv)
 	 * Defer processing channel callbacks until the daemon
 	 * has registered.
 	 */
-	fcopy_transaction.active = true;
-	sema_init(&fcopy_transaction.read_sema, 0);
+	fcopy_device.state = FCOPY_DEVICE_INITIALIZING;
+	init_waitqueue_head(&fcopy_device.proc_list);
+	mutex_init(&fcopy_device.lock);
 
-	return fcopy_dev_init();
+	return misc_register(&fcopy_misc);
 }
 
 void hv_fcopy_deinit(void)
 {
+	fcopy_device.state = FCOPY_DEVICE_DYING;
+	/* Make sure nobody sees the old state */
+	smp_mb();
+	wake_up_interruptible(&fcopy_device.proc_list);
 	cancel_delayed_work_sync(&fcopy_work);
-	fcopy_dev_deinit();
+	cancel_work_sync(&fcopy_send_op_work);
+	misc_deregister(&fcopy_misc);
 }
diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 1939826..590a2f4 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -397,5 +397,6 @@ struct hv_kvp_ip_msg {
  */
 #define HYPERV_KVP_REGISTER        _IOWR('v', 0, __u32)
 #define HYPERV_VSS_REGISTER        _IOWR('v', 0, __u32)
+#define HYPERV_FCOPY_REGISTER      _IOWR('v', 0, __u32)
 
 #endif /* _UAPI_HYPERV_H */
diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index 9445d8f..2ae8196 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -18,19 +18,16 @@
 
 
 #include <sys/types.h>
-#include <sys/socket.h>
 #include <sys/poll.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
 #include <linux/types.h>
-#include <linux/kdev_t.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <string.h>
-#include <ctype.h>
 #include <errno.h>
 #include <linux/hyperv.h>
 #include <syslog.h>
-#include <sys/stat.h>
 #include <fcntl.h>
 #include <dirent.h>
 #include <getopt.h>
@@ -132,7 +129,8 @@ void print_usage(char *argv[])
 int main(int argc, char *argv[])
 {
 	int fcopy_fd, len;
-	int error;
+	__u32 error;
+	struct pollfd pfd;
 	int daemonize = 1, long_index = 0, opt;
 	int version = FCOPY_CURRENT_VERSION;
 	char *buffer[4096 * 2];
@@ -176,19 +174,33 @@ int main(int argc, char *argv[])
 	/*
 	 * Register with the kernel.
 	 */
-	if ((write(fcopy_fd, &version, sizeof(int))) != sizeof(int)) {
-		syslog(LOG_ERR, "Registration failed: %s", strerror(errno));
+	if (ioctl(fcopy_fd, HYPERV_FCOPY_REGISTER, &version)) {
+		syslog(LOG_ERR, "registration to kernel failed; error: %d %s",
+		       errno, strerror(errno));
+		close(fcopy_fd);
 		exit(EXIT_FAILURE);
 	}
 
+	pfd.fd = fcopy_fd;
+
 	while (1) {
-		/*
-		 * In this loop we process fcopy messages after the
-		 * handshake is complete.
-		 */
-		len = pread(fcopy_fd, buffer, (4096 * 2), 0);
+		pfd.events = POLLIN;
+		pfd.revents = 0;
+
+		if (poll(&pfd, 1, -1) < 0) {
+			syslog(LOG_ERR, "poll failed; error:%d %s", errno,
+			       strerror(errno));
+			if (errno == EINVAL) {
+				close(fcopy_fd);
+				exit(EXIT_FAILURE);
+			} else
+				continue;
+		}
+
+		len = read(fcopy_fd, buffer, (4096 * 2));
 		if (len < 0) {
-			syslog(LOG_ERR, "pread failed: %s", strerror(errno));
+			syslog(LOG_ERR, "read failed: %d %s", errno,
+			       strerror(errno));
 			exit(EXIT_FAILURE);
 		}
 		in_msg = (struct hv_fcopy_hdr *)buffer;
@@ -213,9 +225,13 @@ int main(int argc, char *argv[])
 
 		}
 
-		if (pwrite(fcopy_fd, &error, sizeof(int), 0) != sizeof(int)) {
-			syslog(LOG_ERR, "pwrite failed: %s", strerror(errno));
+		if (write(fcopy_fd, &error, sizeof(__u32)) != sizeof(__u32)) {
+			syslog(LOG_ERR, "write failed: %d %s", errno,
+			       strerror(errno));
 			exit(EXIT_FAILURE);
 		}
 	}
+
+	close(fcopy_fd);
+	exit(0);
 }
-- 
1.9.3
