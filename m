From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFCv2 11/21] Drivers: hv: fcopy: switch to using the hvutil_device_state state machine
Date: Wed, 11 Mar 2015 14:29:24 +0100
Message-ID: <1426080574-9011-12-git-send-email-vkuznets@redhat.com>
References: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426080574-9011-1-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Radim Krcmar <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

... from using 3 different state variables: fcopy_transaction.active, opened,
and in_hand_shake.

State transitions are:
-> HVUTIL_DEVICE_INIT when driver loads or on device release
-> HVUTIL_READY if the handshake was successful
-> HVUTIL_HOSTMSG_RECEIVED when there is a non-negotiation message from the host
-> HVUTIL_USERSPACE_REQ after userspace daemon read the message
   -> HVUTIL_USERSPACE_RECV after/if userspace has replied
-> HVUTIL_READY after we respond to the host
-> HVUTIL_DEVICE_DYING on driver unload

In hv_fcopy_onchannelcallback() process ICMSGTYPE_NEGOTIATE messages even when
the userspace daemon is disconnected, otherwise we can make the host think
we don't support FCOPY and disable the service completely.

Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/hv/hv_fcopy.c | 70 ++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index c14f0f4..a501301 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -47,15 +47,10 @@
  * ensure this by serializing packet processing in this driver - we do not
  * read additional packets from the VMBUs until the current packet is fully
  * handled.
- *
- * The transaction "active" state is set when we receive a request from the
- * host and we cleanup this state when the transaction is completed - when we
- * respond to the host with our response. When the transaction active state is
- * set, we defer handling incoming packets.
  */
 
 static struct {
-	bool active; /* transaction status - active or not */
+	int state;   /* hvutil_device_state */
 	int recv_len; /* number of bytes received. */
 	struct hv_fcopy_hdr  *fcopy_msg; /* current message */
 	struct hv_start_fcopy  message; /*  sent to daemon */
@@ -65,14 +60,6 @@ static struct {
 	struct semaphore read_sema;
 } fcopy_transaction;
 
-static bool opened; /* currently device opened */
-
-/*
- * Before we can accept copy messages from the host, we need
- * to handshake with the user level daemon. This state tracks
- * if we are in the handshake phase.
- */
-static bool in_hand_shake = true;
 static void fcopy_send_data(void);
 static void fcopy_respond_to_host(int error);
 static void fcopy_timeout_func(struct work_struct *dummy);
@@ -87,6 +74,10 @@ static void fcopy_timeout_func(struct work_struct *dummy)
 	 */
 	fcopy_respond_to_host(HV_E_FAIL);
 
+	/* Transaction is finished, reset the state. */
+	if (fcopy_transaction.state > HVUTIL_READY)
+		fcopy_transaction.state = HVUTIL_READY;
+
 	/* In the case the user-space daemon crashes, hangs or is killed, we
 	 * need to down the semaphore, otherwise, after the daemon starts next
 	 * time, the obsolete data in fcopy_transaction.message or
@@ -118,10 +109,9 @@ static int fcopy_handle_handshake(u32 version)
 	}
 	pr_info("FCP: user-mode registering done. Daemon version: %d\n",
 		version);
-	fcopy_transaction.active = false;
+	fcopy_transaction.state = HVUTIL_READY;
 	hv_poll_channel(fcopy_transaction.fcopy_context,
 			hv_fcopy_onchannelcallback);
-	in_hand_shake = false;
 	return 0;
 }
 
@@ -191,8 +181,6 @@ fcopy_respond_to_host(int error)
 	channel = fcopy_transaction.recv_channel;
 	req_id = fcopy_transaction.recv_req_id;
 
-	fcopy_transaction.active = false;
-
 	icmsghdr = (struct icmsg_hdr *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
 
@@ -220,7 +208,7 @@ void hv_fcopy_onchannelcallback(void *context)
 	int util_fw_version;
 	int fcopy_srv_version;
 
-	if (fcopy_transaction.active) {
+	if (fcopy_transaction.state > HVUTIL_READY) {
 		/*
 		 * We will defer processing this callback once
 		 * the current transaction is complete.
@@ -252,12 +240,18 @@ void hv_fcopy_onchannelcallback(void *context)
 		 * transaction; note transactions are serialized.
 		 */
 
-		fcopy_transaction.active = true;
 		fcopy_transaction.recv_len = recvlen;
 		fcopy_transaction.recv_channel = channel;
 		fcopy_transaction.recv_req_id = requestid;
 		fcopy_transaction.fcopy_msg = fcopy_msg;
 
+		if (fcopy_transaction.state < HVUTIL_READY) {
+			/* Userspace is not registered yet */
+			fcopy_respond_to_host(HV_E_FAIL);
+			return;
+		}
+		fcopy_transaction.state = HVUTIL_HOSTMSG_RECEIVED;
+
 		/*
 		 * Send the information to the user-level daemon.
 		 */
@@ -290,10 +284,10 @@ static ssize_t fcopy_read(struct file *file, char __user *buf,
 
 	/*
 	 * The channel may be rescinded and in this case, we will wakeup the
-	 * the thread blocked on the semaphore and we will use the opened
-	 * state to correctly handle this case.
+	 * the thread blocked on the semaphore and we will use the state to
+	 * correctly handle this case.
 	 */
-	if (!opened)
+	if (fcopy_transaction.state != HVUTIL_HOSTMSG_RECEIVED)
 		return -ENODEV;
 
 	operation = fcopy_transaction.fcopy_msg->operation;
@@ -312,6 +306,8 @@ static ssize_t fcopy_read(struct file *file, char __user *buf,
 	if (copy_to_user(buf, src, copy_size))
 		return -EFAULT;
 
+	fcopy_transaction.state = HVUTIL_USERSPACE_REQ;
+
 	return copy_size;
 }
 
@@ -326,18 +322,23 @@ static ssize_t fcopy_write(struct file *file, const char __user *buf,
 	if (copy_from_user(&response, buf, sizeof(int)))
 		return -EFAULT;
 
-	if (in_hand_shake) {
+	if (fcopy_transaction.state == HVUTIL_DEVICE_INIT) {
 		if (fcopy_handle_handshake(response))
 			return -EINVAL;
 		return sizeof(int);
 	}
 
+	if (fcopy_transaction.state != HVUTIL_USERSPACE_REQ)
+		return -EINVAL;
+
 	/*
 	 * Complete the transaction by forwarding the result
 	 * to the host. But first, cancel the timeout.
 	 */
-	if (cancel_delayed_work_sync(&fcopy_timeout_work))
+	if (cancel_delayed_work_sync(&fcopy_timeout_work)) {
+		fcopy_transaction.state = HVUTIL_USERSPACE_RECV;
 		fcopy_respond_to_host(response);
+		fcopy_transaction.state = HVUTIL_READY;
 		hv_poll_channel(fcopy_transaction.fcopy_context,
 				hv_fcopy_onchannelcallback);
 	}
@@ -352,13 +353,9 @@ static int fcopy_open(struct inode *inode, struct file *f)
 	 * really an extension of this driver. We can have only
 	 * active open at a time.
 	 */
-	if (opened)
+	if (fcopy_transaction.state != HVUTIL_DEVICE_INIT)
 		return -EBUSY;
 
-	/*
-	 * The daemon is alive; setup the state.
-	 */
-	opened = true;
 	return 0;
 }
 
@@ -375,8 +372,7 @@ static int fcopy_release(struct inode *inode, struct file *f)
 	/*
 	 * The daemon has exited; reset the state.
 	 */
-	in_hand_shake = true;
-	opened = false;
+	fcopy_transaction.state = HVUTIL_DEVICE_INIT;
 
 	if (cancel_delayed_work_sync(&fcopy_timeout_work)) {
 		/* We haven't up()-ed the semaphore(very rare)? */
@@ -410,13 +406,6 @@ static void fcopy_dev_deinit(void)
 {
 
 	/*
-	 * The device is going away - perhaps because the
-	 * host has rescinded the channel. Setup state so that
-	 * user level daemon can gracefully exit if it is blocked
-	 * on the read semaphore.
-	 */
-	opened = false;
-	/*
 	 * Signal the semaphore as the device is
 	 * going away.
 	 */
@@ -434,7 +423,7 @@ int hv_fcopy_init(struct hv_util_service *srv)
 	 * Defer processing channel callbacks until the daemon
 	 * has registered.
 	 */
-	fcopy_transaction.active = true;
+	fcopy_transaction.state = HVUTIL_DEVICE_INIT;
 	sema_init(&fcopy_transaction.read_sema, 0);
 
 	return fcopy_dev_init();
@@ -442,6 +431,7 @@ int hv_fcopy_init(struct hv_util_service *srv)
 
 void hv_fcopy_deinit(void)
 {
+	fcopy_transaction.state = HVUTIL_DEVICE_DYING;
 	cancel_delayed_work_sync(&fcopy_timeout_work);
 	fcopy_dev_deinit();
 }
-- 
1.9.3
