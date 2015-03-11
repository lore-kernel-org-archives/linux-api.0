From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 02/21] Drivers: hv: kvp: reset kvp_context
Date: Wed, 11 Mar 2015 14:29:15 +0100
Message-ID: <1426080574-9011-3-git-send-email-vkuznets@redhat.com>
References: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426080574-9011-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, Radim Krcmar <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

We set kvp_context when we want to postpone receiving a packet from vmbus due
to the previous transaction being unfinished. We, however, never reset this
state, all consequent kvp_respond_to_host() calls will result in poll_channel()
calling hv_kvp_onchannelcallback(). This doesn't cause real issues as:
1) Host is supposed to serialize transactions as well
2) If no message is pending vmbus_recvpacket() will return 0 recvlen.
This is just a cleanup.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_kvp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index a414c83..caa467d 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -621,6 +621,7 @@ void hv_kvp_onchannelcallback(void *context)
 		kvp_transaction.kvp_context = context;
 		return;
 	}
+	kvp_transaction.kvp_context = NULL;
 
 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 4, &recvlen,
 			 &requestid);
-- 
1.9.3
