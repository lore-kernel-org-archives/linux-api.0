From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 15/21] Drivers: hv: fcopy: convert to hv_utils_transport
Date: Wed, 11 Mar 2015 14:29:28 +0100
Message-ID: <1426080574-9011-16-git-send-email-vkuznets@redhat.com>
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

Unify the code with the recently introduced hv_utils_transport. Netlink
communication is disabled for fcopy.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_fcopy.c | 194 ++++++++++++--------------------------------------
 1 file changed, 46 insertions(+), 148 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index d1475e6..6a8ec9f 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -19,17 +19,13 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/semaphore.h>
-#include <linux/fs.h>
 #include <linux/nls.h>
 #include <linux/workqueue.h>
-#include <linux/cdev.h>
 #include <linux/hyperv.h>
 #include <linux/sched.h>
-#include <linux/uaccess.h>
-#include <linux/miscdevice.h>
 
 #include "hyperv_vmbus.h"
+#include "hv_utils_transport.h"
 
 #define WIN8_SRV_MAJOR		1
 #define WIN8_SRV_MINOR		1
@@ -53,18 +49,19 @@ static struct {
 	int state;   /* hvutil_device_state */
 	int recv_len; /* number of bytes received. */
 	struct hv_fcopy_hdr  *fcopy_msg; /* current message */
-	struct hv_start_fcopy  message; /*  sent to daemon */
 	struct vmbus_channel *recv_channel; /* chn we got the request */
 	u64 recv_req_id; /* request ID. */
 	void *fcopy_context; /* for the channel callback */
-	struct semaphore read_sema;
 } fcopy_transaction;
 
-static void fcopy_send_data(void);
 static void fcopy_respond_to_host(int error);
+static void fcopy_send_data(struct work_struct *dummy);
 static void fcopy_timeout_func(struct work_struct *dummy);
 static DECLARE_DELAYED_WORK(fcopy_timeout_work, fcopy_timeout_func);
+static DECLARE_WORK(fcopy_send_work, fcopy_send_data);
+static const char fcopy_devname[] = "vmbus/hv_fcopy";
 static u8 *recv_buffer;
+static struct hvutil_transport *hvt;
 
 static void fcopy_timeout_func(struct work_struct *dummy)
 {
@@ -78,17 +75,6 @@ static void fcopy_timeout_func(struct work_struct *dummy)
 	if (fcopy_transaction.state > HVUTIL_READY)
 		fcopy_transaction.state = HVUTIL_READY;
 
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
 	hv_poll_channel(fcopy_transaction.fcopy_context,
 			hv_fcopy_onchannelcallback);
 }
@@ -115,11 +101,13 @@ static int fcopy_handle_handshake(u32 version)
 	return 0;
 }
 
-static void fcopy_send_data(void)
+static void fcopy_send_data(struct work_struct *dummy)
 {
-	struct hv_start_fcopy *smsg_out = &fcopy_transaction.message;
+	struct hv_start_fcopy smsg_out;
 	int operation = fcopy_transaction.fcopy_msg->operation;
 	struct hv_start_fcopy *smsg_in;
+	void *out_src;
+	int rc, out_len;
 
 	/*
 	 * The  strings sent from the host are encoded in
@@ -134,26 +122,39 @@ static void fcopy_send_data(void)
 
 	switch (operation) {
 	case START_FILE_COPY:
-		memset(smsg_out, 0, sizeof(struct hv_start_fcopy));
-		smsg_out->hdr.operation = operation;
+		out_len = sizeof(struct hv_start_fcopy);
+		memset(&smsg_out, 0, out_len);
+		smsg_out.hdr.operation = operation;
 		smsg_in = (struct hv_start_fcopy *)fcopy_transaction.fcopy_msg;
 
 		utf16s_to_utf8s((wchar_t *)smsg_in->file_name, W_MAX_PATH,
 				UTF16_LITTLE_ENDIAN,
-				(__u8 *)smsg_out->file_name, W_MAX_PATH - 1);
+				(__u8 *)&smsg_out.file_name, W_MAX_PATH - 1);
 
 		utf16s_to_utf8s((wchar_t *)smsg_in->path_name, W_MAX_PATH,
 				UTF16_LITTLE_ENDIAN,
-				(__u8 *)smsg_out->path_name, W_MAX_PATH - 1);
+				(__u8 *)&smsg_out.path_name, W_MAX_PATH - 1);
 
-		smsg_out->copy_flags = smsg_in->copy_flags;
-		smsg_out->file_size = smsg_in->file_size;
+		smsg_out.copy_flags = smsg_in->copy_flags;
+		smsg_out.file_size = smsg_in->file_size;
+		out_src = &smsg_out;
 		break;
 
 	default:
+		out_src = fcopy_transaction.fcopy_msg;
+		out_len = fcopy_transaction.recv_len;
 		break;
 	}
-	up(&fcopy_transaction.read_sema);
+
+	fcopy_transaction.state = HVUTIL_USERSPACE_REQ;
+	rc = hvutil_transport_send(hvt, out_src, out_len);
+	if (rc) {
+		pr_debug("FCP: failed to communicate to the daemon: %d\n", rc);
+		if (cancel_delayed_work_sync(&fcopy_timeout_work)) {
+			fcopy_respond_to_host(HV_E_FAIL);
+			fcopy_transaction.state = HVUTIL_READY;
+		}
+	}
 	return;
 }
 
@@ -255,8 +256,8 @@ void hv_fcopy_onchannelcallback(void *context)
 		/*
 		 * Send the information to the user-level daemon.
 		 */
+		schedule_work(&fcopy_send_work);
 		schedule_delayed_work(&fcopy_timeout_work, 5*HZ);
-		fcopy_send_data();
 		return;
 	}
 	icmsghdr->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
@@ -264,69 +265,16 @@ void hv_fcopy_onchannelcallback(void *context)
 			VM_PKT_DATA_INBAND, 0);
 }
 
-/*
- * Create a char device that can support read/write for passing
- * the payload.
- */
-
-static ssize_t fcopy_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	void *src;
-	size_t copy_size;
-	int operation;
-
-	/*
-	 * Wait until there is something to be read.
-	 */
-	if (down_interruptible(&fcopy_transaction.read_sema))
-		return -EINTR;
-
-	/*
-	 * The channel may be rescinded and in this case, we will wakeup the
-	 * the thread blocked on the semaphore and we will use the state to
-	 * correctly handle this case.
-	 */
-	if (fcopy_transaction.state != HVUTIL_HOSTMSG_RECEIVED)
-		return -ENODEV;
-
-	operation = fcopy_transaction.fcopy_msg->operation;
-
-	if (operation == START_FILE_COPY) {
-		src = &fcopy_transaction.message;
-		copy_size = sizeof(struct hv_start_fcopy);
-		if (count < copy_size)
-			return 0;
-	} else {
-		src = fcopy_transaction.fcopy_msg;
-		copy_size = sizeof(struct hv_do_fcopy);
-		if (count < copy_size)
-			return 0;
-	}
-	if (copy_to_user(buf, src, copy_size))
-		return -EFAULT;
-
-	fcopy_transaction.state = HVUTIL_USERSPACE_REQ;
-
-	return copy_size;
-}
-
-static ssize_t fcopy_write(struct file *file, const char __user *buf,
-			size_t count, loff_t *ppos)
+/* Callback when data is received from userspace */
+static int fcopy_on_msg(void *msg, int len)
 {
-	int response = 0;
+	int *val = (int *)msg;
 
-	if (count != sizeof(int))
+	if (len != sizeof(int))
 		return -EINVAL;
 
-	if (copy_from_user(&response, buf, sizeof(int)))
-		return -EFAULT;
-
-	if (fcopy_transaction.state == HVUTIL_DEVICE_INIT) {
-		if (fcopy_handle_handshake(response))
-			return -EINVAL;
-		return sizeof(int);
-	}
+	if (fcopy_transaction.state == HVUTIL_DEVICE_INIT)
+		return fcopy_handle_handshake(*val);
 
 	if (fcopy_transaction.state != HVUTIL_USERSPACE_REQ)
 		return -EINVAL;
@@ -337,78 +285,24 @@ static ssize_t fcopy_write(struct file *file, const char __user *buf,
 	 */
 	if (cancel_delayed_work_sync(&fcopy_timeout_work)) {
 		fcopy_transaction.state = HVUTIL_USERSPACE_RECV;
-		fcopy_respond_to_host(response);
+		fcopy_respond_to_host(*val);
 		fcopy_transaction.state = HVUTIL_READY;
 		hv_poll_channel(fcopy_transaction.fcopy_context,
 				hv_fcopy_onchannelcallback);
 	}
 
-	return sizeof(int);
-}
-
-static int fcopy_open(struct inode *inode, struct file *f)
-{
-	/*
-	 * The user level daemon that will open this device is
-	 * really an extension of this driver. We can have only
-	 * active open at a time.
-	 */
-	if (fcopy_transaction.state != HVUTIL_DEVICE_INIT)
-		return -EBUSY;
-
 	return 0;
 }
 
-/* XXX: there are still some tricky corner cases, e.g.,
- * In an SMP guest, when fcopy_release() runs between
- * schedule_delayed_work() and fcopy_send_data(), there is
- * still a chance an obsolete message will be queued.
- */
-static int fcopy_release(struct inode *inode, struct file *f)
+static void fcopy_on_reset(void)
 {
 	/*
 	 * The daemon has exited; reset the state.
 	 */
 	fcopy_transaction.state = HVUTIL_DEVICE_INIT;
 
-	if (cancel_delayed_work_sync(&fcopy_timeout_work)) {
-		/* We haven't up()-ed the semaphore(very rare)? */
-		if (down_trylock(&fcopy_transaction.read_sema))
-			;
+	if (cancel_delayed_work_sync(&fcopy_timeout_work))
 		fcopy_respond_to_host(HV_E_FAIL);
-	}
-	return 0;
-}
-
-
-static const struct file_operations fcopy_fops = {
-	.owner          = THIS_MODULE,
-	.read           = fcopy_read,
-	.write          = fcopy_write,
-	.release	= fcopy_release,
-	.open		= fcopy_open,
-};
-
-static struct miscdevice fcopy_misc = {
-	.minor          = MISC_DYNAMIC_MINOR,
-	.name           = "vmbus/hv_fcopy",
-	.fops           = &fcopy_fops,
-};
-
-static int fcopy_dev_init(void)
-{
-	return misc_register(&fcopy_misc);
-}
-
-static void fcopy_dev_deinit(void)
-{
-
-	/*
-	 * Signal the semaphore as the device is
-	 * going away.
-	 */
-	up(&fcopy_transaction.read_sema);
-	misc_deregister(&fcopy_misc);
 }
 
 int hv_fcopy_init(struct hv_util_service *srv)
@@ -422,14 +316,18 @@ int hv_fcopy_init(struct hv_util_service *srv)
 	 * has registered.
 	 */
 	fcopy_transaction.state = HVUTIL_DEVICE_INIT;
-	sema_init(&fcopy_transaction.read_sema, 0);
 
-	return fcopy_dev_init();
+	hvt = hvutil_transport_init(fcopy_devname, 0, 0,
+				    fcopy_on_msg, fcopy_on_reset);
+	if (!hvt)
+		return -EFAULT;
+
+	return 0;
 }
 
 void hv_fcopy_deinit(void)
 {
 	fcopy_transaction.state = HVUTIL_DEVICE_DYING;
 	cancel_delayed_work_sync(&fcopy_timeout_work);
-	fcopy_dev_deinit();
+	hvutil_transport_destroy(hvt);
 }
-- 
1.9.3
