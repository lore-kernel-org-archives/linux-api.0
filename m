From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 10/21] Drivers: hv: vss: switch to using the
 hvutil_device_state state machine
Date: Thu,  9 Apr 2015 10:38:39 +0200
Message-ID: <1428568730-6030-11-git-send-email-vkuznets@redhat.com>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
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

... from using kvp_transaction.active.

State transitions are:
-> HVUTIL_DEVICE_INIT when driver loads or on device release
-> HVUTIL_READY if the handshake was successful
-> HVUTIL_HOSTMSG_RECEIVED when there is a non-negotiation message from the host
-> HVUTIL_USERSPACE_REQ after we sent the message to the userspace daemon
   -> HVUTIL_USERSPACE_RECV after/if the userspace daemon has replied
-> HVUTIL_READY after we respond to the host
-> HVUTIL_DEVICE_DYING on driver unload

In hv_vss_onchannelcallback() process ICMSGTYPE_NEGOTIATE messages even when
the userspace daemon is disconnected, otherwise we can make the host think
we don't support VSS and disable the service completely.

Unfortunately there is no good way we can figure out that the userspace daemon
has died (unless we start treating all timeouts as such), add a protection
against processing new VSS_OP_REGISTER messages while being in the middle of a
transaction (HVUTIL_USERSPACE_REQ or HVUTIL_USERSPACE_RECV state).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_snapshot.c | 87 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 29 deletions(-)

diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 4bb9b1c..ddb1cda 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -33,16 +33,21 @@
 #define VSS_USERSPACE_TIMEOUT (msecs_to_jiffies(10 * 1000))
 
 /*
- * Global state maintained for transaction that is being processed.
- * Note that only one transaction can be active at any point in time.
+ * Global state maintained for transaction that is being processed. For a class
+ * of integration services, including the "VSS service", the specified protocol
+ * is a "request/response" protocol which means that there can only be single
+ * outstanding transaction from the host at any given point in time. We use
+ * this to simplify memory management in this driver - we cache and process
+ * only one message at a time.
  *
- * This state is set when we receive a request from the host; we
- * cleanup this state when the transaction is completed - when we respond
- * to the host with the key value.
+ * While the request/response protocol is guaranteed by the host, we further
+ * ensure this by serializing packet processing in this driver - we do not
+ * read additional packets from the VMBUs until the current packet is fully
+ * handled.
  */
 
 static struct {
-	bool active; /* transaction status - active or not */
+	int state;   /* hvutil_device_state */
 	int recv_len; /* number of bytes received. */
 	struct vmbus_channel *recv_channel; /* chn we got the request */
 	u64 recv_req_id; /* request ID. */
@@ -75,6 +80,10 @@ static void vss_timeout_func(struct work_struct *dummy)
 	pr_warn("VSS: timeout waiting for daemon to reply\n");
 	vss_respond_to_host(HV_E_FAIL);
 
+	/* Transaction is finished, reset the state. */
+	if (vss_transaction.state > HVUTIL_READY)
+		vss_transaction.state = HVUTIL_READY;
+
 	hv_poll_channel(vss_transaction.vss_context,
 			hv_vss_onchannelcallback);
 }
@@ -86,15 +95,32 @@ vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 
 	vss_msg = (struct hv_vss_msg *)msg->data;
 
-	if (vss_msg->vss_hdr.operation == VSS_OP_REGISTER) {
+	/*
+	 * Don't process registration messages if we're in the middle of
+	 * a transaction processing.
+	 */
+	if (vss_transaction.state > HVUTIL_READY &&
+	    vss_msg->vss_hdr.operation == VSS_OP_REGISTER)
+		return;
+
+	if (vss_transaction.state == HVUTIL_DEVICE_INIT &&
+	    vss_msg->vss_hdr.operation == VSS_OP_REGISTER) {
 		pr_info("VSS daemon registered\n");
-		vss_transaction.active = false;
+		vss_transaction.state = HVUTIL_READY;
+	} else if (vss_transaction.state == HVUTIL_USERSPACE_REQ) {
+		vss_transaction.state = HVUTIL_USERSPACE_RECV;
+		if (cancel_delayed_work_sync(&vss_timeout_work)) {
+			vss_respond_to_host(vss_msg->error);
+			/* Transaction is finished, reset the state. */
+			vss_transaction.state = HVUTIL_READY;
+			hv_poll_channel(vss_transaction.vss_context,
+					hv_vss_onchannelcallback);
+		}
+	} else {
+		/* This is a spurious call! */
+		pr_warn("VSS: Transaction not active\n");
+		return;
 	}
-	if (cancel_delayed_work_sync(&vss_timeout_work))
-		vss_respond_to_host(vss_msg->error);
-
-	hv_poll_channel(vss_transaction.vss_context,
-			hv_vss_onchannelcallback);
 }
 
 
@@ -105,6 +131,10 @@ static void vss_send_op(struct work_struct *dummy)
 	struct cn_msg *msg;
 	struct hv_vss_msg *vss_msg;
 
+	/* The transaction state is wrong. */
+	if (vss_transaction.state != HVUTIL_HOSTMSG_RECEIVED)
+		return;
+
 	msg = kzalloc(sizeof(*msg) + sizeof(*vss_msg), GFP_ATOMIC);
 	if (!msg)
 		return;
@@ -117,12 +147,16 @@ static void vss_send_op(struct work_struct *dummy)
 	vss_msg->vss_hdr.operation = op;
 	msg->len = sizeof(struct hv_vss_msg);
 
+	vss_transaction.state = HVUTIL_USERSPACE_REQ;
 	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
 	if (rc) {
 		pr_warn("VSS: failed to communicate to the daemon: %d\n", rc);
-		if (cancel_delayed_work_sync(&vss_timeout_work))
+		if (cancel_delayed_work_sync(&vss_timeout_work)) {
 			vss_respond_to_host(HV_E_FAIL);
+			vss_transaction.state = HVUTIL_READY;
+		}
 	}
+
 	kfree(msg);
 
 	return;
@@ -141,17 +175,6 @@ vss_respond_to_host(int error)
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
@@ -159,7 +182,6 @@ vss_respond_to_host(int error)
 	buf_len = vss_transaction.recv_len;
 	channel = vss_transaction.recv_channel;
 	req_id = vss_transaction.recv_req_id;
-	vss_transaction.active = false;
 
 	icmsghdrp = (struct icmsg_hdr *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
@@ -196,7 +218,7 @@ void hv_vss_onchannelcallback(void *context)
 	struct icmsg_hdr *icmsghdrp;
 	struct icmsg_negotiate *negop = NULL;
 
-	if (vss_transaction.active) {
+	if (vss_transaction.state > HVUTIL_READY) {
 		/*
 		 * We will defer processing this callback once
 		 * the current transaction is complete.
@@ -230,7 +252,6 @@ void hv_vss_onchannelcallback(void *context)
 			vss_transaction.recv_len = recvlen;
 			vss_transaction.recv_channel = channel;
 			vss_transaction.recv_req_id = requestid;
-			vss_transaction.active = true;
 			vss_transaction.msg = (struct hv_vss_msg *)vss_msg;
 
 			switch (vss_msg->vss_hdr.operation) {
@@ -247,6 +268,12 @@ void hv_vss_onchannelcallback(void *context)
 				 */
 			case VSS_OP_FREEZE:
 			case VSS_OP_THAW:
+				if (vss_transaction.state < HVUTIL_READY) {
+					/* Userspace is not registered yet */
+					vss_respond_to_host(HV_E_FAIL);
+					return;
+				}
+				vss_transaction.state = HVUTIL_HOSTMSG_RECEIVED;
 				schedule_work(&vss_send_op_work);
 				schedule_delayed_work(&vss_timeout_work,
 						      VSS_USERSPACE_TIMEOUT);
@@ -297,12 +324,14 @@ hv_vss_init(struct hv_util_service *srv)
 	 * Defer processing channel callbacks until the daemon
 	 * has registered.
 	 */
-	vss_transaction.active = true;
+	vss_transaction.state = HVUTIL_DEVICE_INIT;
+
 	return 0;
 }
 
 void hv_vss_deinit(void)
 {
+	vss_transaction.state = HVUTIL_DEVICE_DYING;
 	cn_del_callback(&vss_id);
 	cancel_delayed_work_sync(&vss_timeout_work);
 	cancel_work_sync(&vss_send_op_work);
-- 
1.9.3
