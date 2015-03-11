From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFCv2 06/21] Drivers: hv: kvp: rename kvp_work -> kvp_timeout_work
Date: Wed, 11 Mar 2015 14:29:19 +0100
Message-ID: <1426080574-9011-7-git-send-email-vkuznets@redhat.com>
References: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426080574-9011-1-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Radim Krcmar <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

'kvp_work' (and kvp_work_func) is a misnomer as it sounds like we expect
this useful work to happen and in reality it is just an emergency escape when
timeout happens.

Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/hv/hv_kvp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 939c3e7..14c62e2 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -79,10 +79,10 @@ static void kvp_send_key(struct work_struct *dummy);
 
 
 static void kvp_respond_to_host(struct hv_kvp_msg *msg, int error);
-static void kvp_work_func(struct work_struct *dummy);
+static void kvp_timeout_func(struct work_struct *dummy);
 static void kvp_register(int);
 
-static DECLARE_DELAYED_WORK(kvp_work, kvp_work_func);
+static DECLARE_DELAYED_WORK(kvp_timeout_work, kvp_timeout_func);
 static DECLARE_WORK(kvp_sendkey_work, kvp_send_key);
 
 static struct cb_id kvp_id = { CN_KVP_IDX, CN_KVP_VAL };
@@ -118,8 +118,8 @@ kvp_register(int reg_value)
 		kfree(msg);
 	}
 }
-static void
-kvp_work_func(struct work_struct *dummy)
+
+static void kvp_timeout_func(struct work_struct *dummy)
 {
 	/*
 	 * If the timer fires, the user-mode component has not responded;
@@ -215,7 +215,7 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	 * Complete the transaction by forwarding the key value
 	 * to the host. But first, cancel the timeout.
 	 */
-	if (cancel_delayed_work_sync(&kvp_work))
+	if (cancel_delayed_work_sync(&kvp_timeout_work))
 		kvp_respond_to_host(message, error);
 }
 
@@ -440,7 +440,7 @@ kvp_send_key(struct work_struct *dummy)
 	rc = cn_netlink_send(msg, 0, 0, GFP_ATOMIC);
 	if (rc) {
 		pr_debug("KVP: failed to communicate to the daemon: %d\n", rc);
-		if (cancel_delayed_work_sync(&kvp_work))
+		if (cancel_delayed_work_sync(&kvp_timeout_work))
 			kvp_respond_to_host(message, HV_E_FAIL);
 	}
 
@@ -668,7 +668,7 @@ void hv_kvp_onchannelcallback(void *context)
 			 * user-mode not responding.
 			 */
 			schedule_work(&kvp_sendkey_work);
-			schedule_delayed_work(&kvp_work, 5*HZ);
+			schedule_delayed_work(&kvp_timeout_work, 5*HZ);
 
 			return;
 
@@ -708,6 +708,6 @@ hv_kvp_init(struct hv_util_service *srv)
 void hv_kvp_deinit(void)
 {
 	cn_del_callback(&kvp_id);
-	cancel_delayed_work_sync(&kvp_work);
+	cancel_delayed_work_sync(&kvp_timeout_work);
 	cancel_work_sync(&kvp_sendkey_work);
 }
-- 
1.9.3
