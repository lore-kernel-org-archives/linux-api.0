From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 03/21] Drivers: hv: kvp: move poll_channel() to
 hyperv_vmbus.h
Date: Wed, 11 Mar 2015 14:29:16 +0100
Message-ID: <1426080574-9011-4-git-send-email-vkuznets@redhat.com>
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

..., make it inline and rename it to hv_poll_channel() so it can be reused
in other hv_util modules.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_kvp.c       | 17 +++--------------
 drivers/hv/hyperv_vmbus.h | 12 ++++++++++++
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index caa467d..939c3e7 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -128,17 +128,6 @@ kvp_work_func(struct work_struct *dummy)
 	kvp_respond_to_host(NULL, HV_E_FAIL);
 }
 
-static void poll_channel(struct vmbus_channel *channel)
-{
-	if (channel->target_cpu != smp_processor_id())
-		smp_call_function_single(channel->target_cpu,
-					 hv_kvp_onchannelcallback,
-					 channel, true);
-	else
-		hv_kvp_onchannelcallback(channel);
-}
-
-
 static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 {
 	int ret = 1;
@@ -166,8 +155,8 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 		pr_info("KVP: user-mode registering done.\n");
 		kvp_register(dm_reg_value);
 		kvp_transaction.active = false;
-		if (kvp_transaction.kvp_context)
-			poll_channel(kvp_transaction.kvp_context);
+		hv_poll_channel(kvp_transaction.kvp_context,
+				hv_kvp_onchannelcallback);
 	}
 	return ret;
 }
@@ -587,7 +576,7 @@ response_done:
 
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
-	poll_channel(channel);
+	hv_poll_channel(channel, hv_kvp_onchannelcallback);
 }
 
 /*
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 0d85dd1..177dbec 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -711,5 +711,17 @@ int hv_fcopy_init(struct hv_util_service *);
 void hv_fcopy_deinit(void);
 void hv_fcopy_onchannelcallback(void *);
 
+static inline void hv_poll_channel(struct vmbus_channel *channel,
+				   void (*cb)(void *))
+{
+	if (!channel)
+		return;
+
+	if (channel->target_cpu != smp_processor_id())
+		smp_call_function_single(channel->target_cpu,
+					 cb, channel, true);
+	else
+		cb(channel);
+}
 
 #endif /* _HYPERV_VMBUS_H */
-- 
1.9.3
