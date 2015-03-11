From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFCv2 16/21] Drivers: hv: kvp: convert to hv_utils_transport
Date: Wed, 11 Mar 2015 14:29:29 +0100
Message-ID: <1426080574-9011-17-git-send-email-vkuznets@redhat.com>
References: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426080574-9011-1-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Radim Krcmar <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

 ... to support both netlink and /dev/vmbus/hv_kvp communication methods.

Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/hv/hv_kvp.c | 91 +++++++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 49 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index a70d202..baa1208 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -29,6 +29,7 @@
 #include <linux/hyperv.h>
 
 #include "hyperv_vmbus.h"
+#include "hv_utils_transport.h"
 
 /*
  * Pre win8 version numbers used in ws2008 and ws 2008 r2 (win7)
@@ -83,9 +84,9 @@ static void kvp_register(int);
 static DECLARE_DELAYED_WORK(kvp_timeout_work, kvp_timeout_func);
 static DECLARE_WORK(kvp_sendkey_work, kvp_send_key);
 
-static struct cb_id kvp_id = { CN_KVP_IDX, CN_KVP_VAL };
-static const char kvp_name[] = "kvp_kernel_module";
+static const char kvp_devname[] = "vmbus/hv_kvp";
 static u8 *recv_buffer;
+static struct hvutil_transport *hvt;
 /*
  * Register the kernel component with the user-level daemon.
  * As part of this registration, pass the LIC version number.
@@ -97,23 +98,18 @@ static void
 kvp_register(int reg_value)
 {
 
-	struct cn_msg *msg;
 	struct hv_kvp_msg *kvp_msg;
 	char *version;
 
-	msg = kzalloc(sizeof(*msg) + sizeof(struct hv_kvp_msg), GFP_ATOMIC);
+	kvp_msg = kzalloc(sizeof(*kvp_msg), GFP_KERNEL);
 
-	if (msg) {
-		kvp_msg = (struct hv_kvp_msg *)msg->data;
+	if (kvp_msg) {
 		version = kvp_msg->body.kvp_register.version;
-		msg->id.idx =  CN_KVP_IDX;
-		msg->id.val = CN_KVP_VAL;
-
 		kvp_msg->kvp_hdr.operation = reg_value;
 		strcpy(version, HV_DRV_VERSION);
-		msg->len = sizeof(struct hv_kvp_msg);
-		cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
-		kfree(msg);
+
+		hvutil_transport_send(hvt, kvp_msg, sizeof(*kvp_msg));
+		kfree(kvp_msg);
 	}
 }
 
@@ -135,8 +131,6 @@ static void kvp_timeout_func(struct work_struct *dummy)
 
 static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 {
-	int ret = 1;
-
 	switch (msg->kvp_hdr.operation) {
 	case KVP_OP_REGISTER:
 		dm_reg_value = KVP_OP_REGISTER;
@@ -150,18 +144,17 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 		pr_info("KVP: incompatible daemon\n");
 		pr_info("KVP: KVP version: %d, Daemon version: %d\n",
 			KVP_OP_REGISTER1, msg->kvp_hdr.operation);
-		ret = 0;
+		return -EINVAL;
 	}
 
-	if (ret) {
-		/*
-		 * We have a compatible daemon; complete the handshake.
-		 */
-		pr_info("KVP: user-mode registering done.\n");
-		kvp_register(dm_reg_value);
-		kvp_transaction.state = HVUTIL_READY;
-	}
-	return ret;
+	/*
+	 * We have a compatible daemon; complete the handshake.
+	 */
+	pr_info("KVP: user-mode registering done.\n");
+	kvp_register(dm_reg_value);
+	kvp_transaction.state = HVUTIL_READY;
+
+	return 0;
 }
 
 
@@ -169,14 +162,14 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
  * Callback when data is received from user mode.
  */
 
-static void
-kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
+static int kvp_on_msg(void *msg, int len)
 {
-	struct hv_kvp_msg *message;
+	struct hv_kvp_msg *message = (struct hv_kvp_msg *)msg;
 	struct hv_kvp_msg_enumerate *data;
 	int	error = 0;
 
-	message = (struct hv_kvp_msg *)msg->data;
+	if (len < sizeof(*message))
+		return -EINVAL;
 
 	/*
 	 * If we are negotiating the version information
@@ -184,13 +177,13 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	 */
 
 	if (kvp_transaction.state < HVUTIL_READY) {
-		kvp_handle_handshake(message);
-		return;
+		return kvp_handle_handshake(message);
 	}
 
 	/* We didn't send anything to userspace so the reply is spurious */
 	if (kvp_transaction.state < HVUTIL_USERSPACE_REQ)
-		return;
+		return -EINVAL;
+
 	kvp_transaction.state = HVUTIL_USERSPACE_RECV;
 
 	/*
@@ -228,6 +221,8 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		hv_poll_channel(kvp_transaction.kvp_context,
 				hv_kvp_onchannelcallback);
 	}
+
+	return 0;
 }
 
 
@@ -344,7 +339,6 @@ static void process_ib_ipinfo(void *in_msg, void *out_msg, int op)
 static void
 kvp_send_key(struct work_struct *dummy)
 {
-	struct cn_msg *msg;
 	struct hv_kvp_msg *message;
 	struct hv_kvp_msg *in_msg;
 	__u8 operation = kvp_transaction.kvp_msg->kvp_hdr.operation;
@@ -357,14 +351,7 @@ kvp_send_key(struct work_struct *dummy)
 	if (kvp_transaction.state != HVUTIL_HOSTMSG_RECEIVED)
 		return;
 
-	msg = kzalloc(sizeof(*msg) + sizeof(struct hv_kvp_msg) , GFP_ATOMIC);
-	if (!msg)
-		return;
-
-	msg->id.idx =  CN_KVP_IDX;
-	msg->id.val = CN_KVP_VAL;
-
-	message = (struct hv_kvp_msg *)msg->data;
+	message = kzalloc(sizeof(*message), GFP_KERNEL);
 	message->kvp_hdr.operation = operation;
 	message->kvp_hdr.pool = pool;
 	in_msg = kvp_transaction.kvp_msg;
@@ -451,9 +438,8 @@ kvp_send_key(struct work_struct *dummy)
 			break;
 	}
 
-	msg->len = sizeof(struct hv_kvp_msg);
 	kvp_transaction.state = HVUTIL_USERSPACE_REQ;
-	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
+	rc = hvutil_transport_send(hvt, message, sizeof(*message));
 	if (rc) {
 		pr_debug("KVP: failed to communicate to the daemon: %d\n", rc);
 		if (cancel_delayed_work_sync(&kvp_timeout_work)) {
@@ -462,7 +448,7 @@ kvp_send_key(struct work_struct *dummy)
 		}
 	}
 
-	kfree(msg);
+	kfree(message);
 
 	return;
 }
@@ -694,14 +680,16 @@ void hv_kvp_onchannelcallback(void *context)
 
 }
 
+static void kvp_on_reset(void)
+{
+	if (cancel_delayed_work_sync(&kvp_timeout_work))
+		kvp_respond_to_host(NULL, HV_E_FAIL);
+	kvp_transaction.state = HVUTIL_DEVICE_INIT;
+}
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
@@ -712,13 +700,18 @@ hv_kvp_init(struct hv_util_service *srv)
 	 */
 	kvp_transaction.state = HVUTIL_DEVICE_INIT;
 
+	hvt = hvutil_transport_init(kvp_devname, CN_KVP_IDX, CN_KVP_VAL,
+				    kvp_on_msg, kvp_on_reset);
+	if (!hvt)
+		return -EFAULT;
+
 	return 0;
 }
 
 void hv_kvp_deinit(void)
 {
 	kvp_transaction.state = HVUTIL_DEVICE_DYING;
-	cn_del_callback(&kvp_id);
 	cancel_delayed_work_sync(&kvp_timeout_work);
 	cancel_work_sync(&kvp_sendkey_work);
+	hvutil_transport_destroy(hvt);
 }
-- 
1.9.3
