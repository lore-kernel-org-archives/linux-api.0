From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 09/21] Drivers: hv: kvp: switch to using the
 hvutil_device_state state machine
Date: Wed, 11 Mar 2015 14:29:22 +0100
Message-ID: <1426080574-9011-10-git-send-email-vkuznets@redhat.com>
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

... from using 2 different state variables: kvp_transaction.active and
in_hand_shake.

State transitions are:
-> HVUTIL_DEVICE_INIT when driver loads or on device release
-> HVUTIL_READY if the handshake was successful
-> HVUTIL_HOSTMSG_RECEIVED when there is a non-negotiation message from the host
-> HVUTIL_USERSPACE_REQ after we sent the message to the userspace daemon
   -> HVUTIL_USERSPACE_RECV after/if the userspace daemon has replied
-> HVUTIL_READY after we respond to the host
-> HVUTIL_DEVICE_DYING on driver unload

In hv_kvp_onchannelcallback() process ICMSGTYPE_NEGOTIATE messages even when
the userspace daemon is disconnected, otherwise we can make the host think
we don't support KVP and disable the service completely.

Unfortunately there is no good way we can figure out that the userspace daemon
has died (unless we start treating all timeouts as such). In case the daemon
restarts we skip the negotiation procedure (so the daemon is supposed to has
the same version). This behavior is unchanged from in_handshake approach.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_kvp.c | 87 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 38 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 14c62e2..a70d202 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -46,16 +46,21 @@
 #define WIN8_SRV_VERSION     (WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
 
 /*
- * Global state maintained for transaction that is being processed.
- * Note that only one transaction can be active at any point in time.
+ * Global state maintained for transaction that is being processed. For a class
+ * of integration services, including the "KVP service", the specified protocol
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
 	struct hv_kvp_msg  *kvp_msg; /* current message */
 	struct vmbus_channel *recv_channel; /* chn we got the request */
@@ -64,13 +69,6 @@ static struct {
 } kvp_transaction;
 
 /*
- * Before we can accept KVP messages from the host, we need
- * to handshake with the user level daemon. This state tracks
- * if we are in the handshake phase.
- */
-static bool in_hand_shake = true;
-
-/*
  * This state maintains the version number registered by the daemon.
  */
 static int dm_reg_value;
@@ -126,6 +124,13 @@ static void kvp_timeout_func(struct work_struct *dummy)
 	 * process the pending transaction.
 	 */
 	kvp_respond_to_host(NULL, HV_E_FAIL);
+
+	/* Transaction is finished, reset the state. */
+	if (kvp_transaction.state > HVUTIL_READY)
+		kvp_transaction.state = HVUTIL_READY;
+
+	hv_poll_channel(kvp_transaction.kvp_context,
+			hv_kvp_onchannelcallback);
 }
 
 static int kvp_handle_handshake(struct hv_kvp_msg *msg)
@@ -154,9 +159,7 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 		 */
 		pr_info("KVP: user-mode registering done.\n");
 		kvp_register(dm_reg_value);
-		kvp_transaction.active = false;
-		hv_poll_channel(kvp_transaction.kvp_context,
-				hv_kvp_onchannelcallback);
+		kvp_transaction.state = HVUTIL_READY;
 	}
 	return ret;
 }
@@ -180,12 +183,16 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	 * with the daemon; handle that first.
 	 */
 
-	if (in_hand_shake) {
-		if (kvp_handle_handshake(message))
-			in_hand_shake = false;
+	if (kvp_transaction.state < HVUTIL_READY) {
+		kvp_handle_handshake(message);
 		return;
 	}
 
+	/* We didn't send anything to userspace so the reply is spurious */
+	if (kvp_transaction.state < HVUTIL_USERSPACE_REQ)
+		return;
+	kvp_transaction.state = HVUTIL_USERSPACE_RECV;
+
 	/*
 	 * Based on the version of the daemon, we propagate errors from the
 	 * daemon differently.
@@ -215,8 +222,12 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	 * Complete the transaction by forwarding the key value
 	 * to the host. But first, cancel the timeout.
 	 */
-	if (cancel_delayed_work_sync(&kvp_timeout_work))
+	if (cancel_delayed_work_sync(&kvp_timeout_work)) {
 		kvp_respond_to_host(message, error);
+		kvp_transaction.state = HVUTIL_READY;
+		hv_poll_channel(kvp_transaction.kvp_context,
+				hv_kvp_onchannelcallback);
+	}
 }
 
 
@@ -342,6 +353,10 @@ kvp_send_key(struct work_struct *dummy)
 	__u64 val64;
 	int rc;
 
+	/* The transaction state is wrong. */
+	if (kvp_transaction.state != HVUTIL_HOSTMSG_RECEIVED)
+		return;
+
 	msg = kzalloc(sizeof(*msg) + sizeof(struct hv_kvp_msg) , GFP_ATOMIC);
 	if (!msg)
 		return;
@@ -437,11 +452,14 @@ kvp_send_key(struct work_struct *dummy)
 	}
 
 	msg->len = sizeof(struct hv_kvp_msg);
+	kvp_transaction.state = HVUTIL_USERSPACE_REQ;
 	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
 	if (rc) {
 		pr_debug("KVP: failed to communicate to the daemon: %d\n", rc);
-		if (cancel_delayed_work_sync(&kvp_timeout_work))
+		if (cancel_delayed_work_sync(&kvp_timeout_work)) {
 			kvp_respond_to_host(message, HV_E_FAIL);
+			kvp_transaction.state = HVUTIL_READY;
+		}
 	}
 
 	kfree(msg);
@@ -469,17 +487,6 @@ kvp_respond_to_host(struct hv_kvp_msg *msg_to_host, int error)
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
@@ -488,8 +495,6 @@ kvp_respond_to_host(struct hv_kvp_msg *msg_to_host, int error)
 	channel = kvp_transaction.recv_channel;
 	req_id = kvp_transaction.recv_req_id;
 
-	kvp_transaction.active = false;
-
 	icmsghdrp = (struct icmsg_hdr *)
 			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
 
@@ -576,7 +581,6 @@ response_done:
 
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
-	hv_poll_channel(channel, hv_kvp_onchannelcallback);
 }
 
 /*
@@ -602,7 +606,7 @@ void hv_kvp_onchannelcallback(void *context)
 	int util_fw_version;
 	int kvp_srv_version;
 
-	if (kvp_transaction.active) {
+	if (kvp_transaction.state > HVUTIL_READY) {
 		/*
 		 * We will defer processing this callback once
 		 * the current transaction is complete.
@@ -655,9 +659,15 @@ void hv_kvp_onchannelcallback(void *context)
 			kvp_transaction.recv_len = recvlen;
 			kvp_transaction.recv_channel = channel;
 			kvp_transaction.recv_req_id = requestid;
-			kvp_transaction.active = true;
 			kvp_transaction.kvp_msg = kvp_msg;
 
+			if (kvp_transaction.state < HVUTIL_READY) {
+				/* Userspace is not registered yet */
+				kvp_respond_to_host(NULL, HV_E_FAIL);
+				return;
+			}
+			kvp_transaction.state = HVUTIL_HOSTMSG_RECEIVED;
+
 			/*
 			 * Get the information from the
 			 * user-mode component.
@@ -700,13 +710,14 @@ hv_kvp_init(struct hv_util_service *srv)
 	 * Defer processing channel callbacks until the daemon
 	 * has registered.
 	 */
-	kvp_transaction.active = true;
+	kvp_transaction.state = HVUTIL_DEVICE_INIT;
 
 	return 0;
 }
 
 void hv_kvp_deinit(void)
 {
+	kvp_transaction.state = HVUTIL_DEVICE_DYING;
 	cn_del_callback(&kvp_id);
 	cancel_delayed_work_sync(&kvp_timeout_work);
 	cancel_work_sync(&kvp_sendkey_work);
-- 
1.9.3
