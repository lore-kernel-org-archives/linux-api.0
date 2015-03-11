From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 19/21] Drivers: hv: vss: full handshake support
Date: Wed, 11 Mar 2015 14:29:32 +0100
Message-ID: <1426080574-9011-20-git-send-email-vkuznets@redhat.com>
References: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, Radim Krcmar <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Introduce VSS_OP_REGISTER1 to support kernel replying to the negotiation
message with its own version.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_snapshot.c    | 49 ++++++++++++++++++++++++++++++++++-----------
 include/uapi/linux/hyperv.h |  5 +++++
 tools/hv/hv_vss_daemon.c    | 14 +++++++++++++
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 2c8c246..ee1762b 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -59,6 +59,11 @@ static struct {
 
 static void vss_respond_to_host(int error);
 
+/*
+ * This state maintains the version number registered by the daemon.
+ */
+static int dm_reg_value;
+
 static const char vss_devname[] = "vmbus/hv_vss";
 static __u8 *recv_buffer;
 static struct hvutil_transport *hvt;
@@ -89,6 +94,29 @@ static void vss_timeout_func(struct work_struct *dummy)
 			hv_vss_onchannelcallback);
 }
 
+static int vss_handle_handshake(struct hv_vss_msg *vss_msg)
+{
+	u32 our_ver = VSS_OP_REGISTER1;
+
+	switch (vss_msg->vss_hdr.operation) {
+	case VSS_OP_REGISTER:
+		/* Daemon doesn't expect us to reply */
+		dm_reg_value = VSS_OP_REGISTER;
+		break;
+	case VSS_OP_REGISTER1:
+		/* Daemon expects us to reply with our own version*/
+		if (hvutil_transport_send(hvt, &our_ver, sizeof(our_ver)))
+			return -EFAULT;
+		dm_reg_value = VSS_OP_REGISTER1;
+		break;
+	default:
+		return -EINVAL;
+	}
+	vss_transaction.state = HVUTIL_READY;
+	pr_info("VSS daemon registered\n");
+	return 0;
+}
+
 static int vss_on_msg(void *msg, int len)
 {
 	struct hv_vss_msg *vss_msg = (struct hv_vss_msg *)msg;
@@ -96,18 +124,15 @@ static int vss_on_msg(void *msg, int len)
 	if (len != sizeof(*vss_msg))
 		return -EINVAL;
 
-	/*
-	 * Don't process registration messages if we're in the middle of
-	 * a transaction processing.
-	 */
-	if (vss_transaction.state > HVUTIL_READY &&
-	    vss_msg->vss_hdr.operation == VSS_OP_REGISTER)
-		return -EINVAL;
-
-	if (vss_transaction.state == HVUTIL_DEVICE_INIT &&
-	    vss_msg->vss_hdr.operation == VSS_OP_REGISTER) {
-		pr_info("VSS daemon registered\n");
-		vss_transaction.state = HVUTIL_READY;
+	if (vss_msg->vss_hdr.operation == VSS_OP_REGISTER ||
+	    vss_msg->vss_hdr.operation == VSS_OP_REGISTER1) {
+		/*
+		 * Don't process registration messages if we're in the middle
+		 * of a transaction processing.
+		 */
+		if (vss_transaction.state > HVUTIL_READY)
+			return -EINVAL;
+		return vss_handle_handshake(vss_msg);
 	} else if (vss_transaction.state == HVUTIL_USERSPACE_REQ) {
 		vss_transaction.state = HVUTIL_USERSPACE_RECV;
 		if (cancel_delayed_work_sync(&vss_timeout_work)) {
diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index bb1cb73..66c76df 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -45,6 +45,11 @@
 
 #define VSS_OP_REGISTER 128
 
+/*
+  Daemon code with full handshake support.
+ */
+#define VSS_OP_REGISTER1 129
+
 enum hv_vss_op {
 	VSS_OP_CREATE = 0,
 	VSS_OP_DELETE,
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 135425a..f5db9f0 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -142,6 +142,8 @@ int main(int argc, char *argv[])
 	int	op;
 	struct hv_vss_msg vss_msg[1];
 	int daemonize = 1, long_index = 0, opt;
+	int in_handshake = 1;
+	__u32 kernel_modver;
 
 	static struct option long_options[] = {
 		{"help",	no_argument,	   0,  'h' },
@@ -205,6 +207,18 @@ int main(int argc, char *argv[])
 
 		len = read(vss_fd, vss_msg, sizeof(struct hv_vss_msg));
 
+		if (in_handshake) {
+			if (len != sizeof(kernel_modver)) {
+				syslog(LOG_ERR, "invalid version negotiation");
+				exit(EXIT_FAILURE);
+			}
+			kernel_modver = *(__u32 *)vss_msg;
+			in_handshake = 0;
+			syslog(LOG_INFO, "VSS: kernel module version: %d",
+			       kernel_modver);
+			continue;
+		}
+
 		if (len != sizeof(struct hv_vss_msg)) {
 			syslog(LOG_ERR, "read failed; error:%d %s",
 			       errno, strerror(errno));
-- 
1.9.3
