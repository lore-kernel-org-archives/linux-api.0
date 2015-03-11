From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 05/21] Drivers: hv: vss: process deferred messages when
 we complete the transaction
Date: Wed, 11 Mar 2015 14:29:18 +0100
Message-ID: <1426080574-9011-6-git-send-email-vkuznets@redhat.com>
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

In theory, the host is not supposed to issue any requests before be reply to
the previous one. In KVP we, however, support the following scenarios:
1) A message was received before userspace daemon registered;
2) A message was received while the previous one is still being processed.
In VSS we support only the former. Add support for the later, use
hv_poll_channel() to do the job.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_snapshot.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index c1a3604..4bb9b1c 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -47,6 +47,7 @@ static struct {
 	struct vmbus_channel *recv_channel; /* chn we got the request */
 	u64 recv_req_id; /* request ID. */
 	struct hv_vss_msg  *msg; /* current message */
+	void *vss_context; /* for the channel callback */
 } vss_transaction;
 
 
@@ -73,6 +74,9 @@ static void vss_timeout_func(struct work_struct *dummy)
 	 */
 	pr_warn("VSS: timeout waiting for daemon to reply\n");
 	vss_respond_to_host(HV_E_FAIL);
+
+	hv_poll_channel(vss_transaction.vss_context,
+			hv_vss_onchannelcallback);
 }
 
 static void
@@ -85,13 +89,12 @@ vss_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 	if (vss_msg->vss_hdr.operation == VSS_OP_REGISTER) {
 		pr_info("VSS daemon registered\n");
 		vss_transaction.active = false;
-		if (vss_transaction.recv_channel != NULL)
-			hv_vss_onchannelcallback(vss_transaction.recv_channel);
-		return;
-
 	}
 	if (cancel_delayed_work_sync(&vss_timeout_work))
 		vss_respond_to_host(vss_msg->error);
+
+	hv_poll_channel(vss_transaction.vss_context,
+			hv_vss_onchannelcallback);
 }
 
 
@@ -198,9 +201,10 @@ void hv_vss_onchannelcallback(void *context)
 		 * We will defer processing this callback once
 		 * the current transaction is complete.
 		 */
-		vss_transaction.recv_channel = channel;
+		vss_transaction.vss_context = context;
 		return;
 	}
+	vss_transaction.vss_context = NULL;
 
 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
 			 &requestid);
-- 
1.9.3
