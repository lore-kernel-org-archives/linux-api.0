From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 20/21] Drivers: hv: fcopy: full handshake support
Date: Thu,  9 Apr 2015 10:38:49 +0200
Message-ID: <1428568730-6030-21-git-send-email-vkuznets@redhat.com>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428568730-6030-1-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Radim Krcmar <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Introduce FCOPY_VERSION_1 to support kernel replying to the negotiation
message with its own version.

Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/hv/hv_fcopy.c       | 16 +++++++++++++++-
 include/uapi/linux/hyperv.h |  3 ++-
 tools/hv/hv_fcopy_daemon.c  | 15 +++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index 6a8ec9f..b7b528c 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -62,6 +62,10 @@ static DECLARE_WORK(fcopy_send_work, fcopy_send_data);
 static const char fcopy_devname[] = "vmbus/hv_fcopy";
 static u8 *recv_buffer;
 static struct hvutil_transport *hvt;
+/*
+ * This state maintains the version number registered by the daemon.
+ */
+static int dm_reg_value;
 
 static void fcopy_timeout_func(struct work_struct *dummy)
 {
@@ -81,8 +85,18 @@ static void fcopy_timeout_func(struct work_struct *dummy)
 
 static int fcopy_handle_handshake(u32 version)
 {
+	u32 our_ver = FCOPY_CURRENT_VERSION;
+
 	switch (version) {
-	case FCOPY_CURRENT_VERSION:
+	case FCOPY_VERSION_0:
+		/* Daemon doesn't expect us to reply */
+		dm_reg_value = version;
+		break;
+	case FCOPY_VERSION_1:
+		/* Daemon expects us to reply with our own version */
+		if (hvutil_transport_send(hvt, &our_ver, sizeof(our_ver)))
+			return -EFAULT;
+		dm_reg_value = version;
 		break;
 	default:
 		/*
diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 66c76df..e4c0a35 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -105,7 +105,8 @@ struct hv_vss_msg {
  */
 
 #define FCOPY_VERSION_0 0
-#define FCOPY_CURRENT_VERSION FCOPY_VERSION_0
+#define FCOPY_VERSION_1 1
+#define FCOPY_CURRENT_VERSION FCOPY_VERSION_1
 #define W_MAX_PATH 260
 
 enum hv_fcopy_op {
diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
index 9445d8f..5480e4e 100644
--- a/tools/hv/hv_fcopy_daemon.c
+++ b/tools/hv/hv_fcopy_daemon.c
@@ -137,6 +137,8 @@ int main(int argc, char *argv[])
 	int version = FCOPY_CURRENT_VERSION;
 	char *buffer[4096 * 2];
 	struct hv_fcopy_hdr *in_msg;
+	int in_handshake = 1;
+	__u32 kernel_modver;
 
 	static struct option long_options[] = {
 		{"help",	no_argument,	   0,  'h' },
@@ -191,6 +193,19 @@ int main(int argc, char *argv[])
 			syslog(LOG_ERR, "pread failed: %s", strerror(errno));
 			exit(EXIT_FAILURE);
 		}
+
+		if (in_handshake) {
+			if (len != sizeof(kernel_modver)) {
+				syslog(LOG_ERR, "invalid version negotiation");
+				exit(EXIT_FAILURE);
+			}
+			kernel_modver = *(__u32 *)buffer;
+			in_handshake = 0;
+			syslog(LOG_INFO, "HV_FCOPY: kernel module version: %d",
+			       kernel_modver);
+			continue;
+		}
+
 		in_msg = (struct hv_fcopy_hdr *)buffer;
 
 		switch (in_msg->operation) {
-- 
1.9.3
