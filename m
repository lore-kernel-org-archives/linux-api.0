From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 14/21] Drivers: hv: vss: convert to hv_utils_transport
Date: Thu,  9 Apr 2015 10:38:43 +0200
Message-ID: <1428568730-6030-15-git-send-email-vkuznets@redhat.com>
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

... to support both netlink and /dev/vmbus/hv_vss communication methods.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_snapshot.c | 52 +++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index ddb1cda..2c8c246 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -25,6 +25,7 @@
 #include <linux/hyperv.h>
 
 #include "hyperv_vmbus.h"
+#include "hv_utils_transport.h"
 
 #define VSS_MAJOR  5
 #define VSS_MINOR  0
@@ -58,9 +59,9 @@ static struct {
 
 static void vss_respond_to_host(int error);
 
-static struct cb_id vss_id = { CN_VSS_IDX, CN_VSS_VAL };
-static const char vss_name[] = "vss_kernel_module";
+static const char vss_devname[] = "vmbus/hv_vss";
 static __u8 *recv_buffer;
+static struct hvutil_transport *hvt;
 
 static void vss_send_op(struct work_struct *dummy);
 static void vss_timeout_func(struct work_struct *dummy);
@@ -88,12 +89,12 @@ static void vss_timeout_func(struct work_struct *dummy)
 			hv_vss_onchannelcallback);
 }
 
-static void
-vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
+static int vss_on_msg(void *msg, int len)
 {
-	struct hv_vss_msg *vss_msg;
+	struct hv_vss_msg *vss_msg = (struct hv_vss_msg *)msg;
 
-	vss_msg = (struct hv_vss_msg *)msg->data;
+	if (len != sizeof(*vss_msg))
+		return -EINVAL;
 
 	/*
 	 * Don't process registration messages if we're in the middle of
@@ -101,7 +102,7 @@ vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	 */
 	if (vss_transaction.state > HVUTIL_READY &&
 	    vss_msg->vss_hdr.operation == VSS_OP_REGISTER)
-		return;
+		return -EINVAL;
 
 	if (vss_transaction.state == HVUTIL_DEVICE_INIT &&
 	    vss_msg->vss_hdr.operation == VSS_OP_REGISTER) {
@@ -119,8 +120,9 @@ vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	} else {
 		/* This is a spurious call! */
 		pr_warn("VSS: Transaction not active\n");
-		return;
+		return -EINVAL;
 	}
+	return 0;
 }
 
 
@@ -128,27 +130,20 @@ static void vss_send_op(struct work_struct *dummy)
 {
 	int op = vss_transaction.msg->vss_hdr.operation;
 	int rc;
-	struct cn_msg *msg;
 	struct hv_vss_msg *vss_msg;
 
 	/* The transaction state is wrong. */
 	if (vss_transaction.state != HVUTIL_HOSTMSG_RECEIVED)
 		return;
 
-	msg = kzalloc(sizeof(*msg) + sizeof(*vss_msg), GFP_ATOMIC);
-	if (!msg)
+	vss_msg = kzalloc(sizeof(*vss_msg), GFP_KERNEL);
+	if (!vss_msg)
 		return;
 
-	vss_msg = (struct hv_vss_msg *)msg->data;
-
-	msg->id.idx =  CN_VSS_IDX;
-	msg->id.val = CN_VSS_VAL;
-
 	vss_msg->vss_hdr.operation = op;
-	msg->len = sizeof(struct hv_vss_msg);
 
 	vss_transaction.state = HVUTIL_USERSPACE_REQ;
-	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
+	rc = hvutil_transport_send(hvt, vss_msg, sizeof(*vss_msg));
 	if (rc) {
 		pr_warn("VSS: failed to communicate to the daemon: %d\n", rc);
 		if (cancel_delayed_work_sync(&vss_timeout_work)) {
@@ -157,7 +152,7 @@ static void vss_send_op(struct work_struct *dummy)
 		}
 	}
 
-	kfree(msg);
+	kfree(vss_msg);
 
 	return;
 }
@@ -308,14 +303,16 @@ void hv_vss_onchannelcallback(void *context)
 
 }
 
+static void vss_on_reset(void)
+{
+	if (cancel_delayed_work_sync(&vss_timeout_work))
+		vss_respond_to_host(HV_E_FAIL);
+	vss_transaction.state = HVUTIL_DEVICE_INIT;
+}
+
 int
 hv_vss_init(struct hv_util_service *srv)
 {
-	int err;
-
-	err = cn_add_callback(&vss_id, vss_name, vss_cn_callback);
-	if (err)
-		return err;
 	recv_buffer = srv->recv_buffer;
 
 	/*
@@ -326,13 +323,18 @@ hv_vss_init(struct hv_util_service *srv)
 	 */
 	vss_transaction.state = HVUTIL_DEVICE_INIT;
 
+	hvt = hvutil_transport_init(vss_devname, CN_VSS_IDX, CN_VSS_VAL,
+				    vss_on_msg, vss_on_reset);
+	if (!hvt)
+		return -EFAULT;
+
 	return 0;
 }
 
 void hv_vss_deinit(void)
 {
 	vss_transaction.state = HVUTIL_DEVICE_DYING;
-	cn_del_callback(&vss_id);
 	cancel_delayed_work_sync(&vss_timeout_work);
 	cancel_work_sync(&vss_send_op_work);
+	hvutil_transport_destroy(hvt);
 }
-- 
1.9.3
