From: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 08/21] Drivers: hv: util: introduce state machine for util drivers
Date: Thu,  9 Apr 2015 10:38:37 +0200
Message-ID: <1428568730-6030-9-git-send-email-vkuznets@redhat.com>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428568730-6030-1-git-send-email-vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
Cc: Haiyang Zhang <haiyangz-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Radim Krcmar <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

KVP/VSS/FCOPY drivers work in fully serialized mode: we wait till userspace
daemon registers, wait for a message from the host, send this message to the
daemon, get the reply, send it back to host, wait for another message.
Introduce enum hvutil_device_state to represend this state in all 3 drivers.

Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/hv/hyperv_vmbus.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 2f30456..138d663 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -755,4 +755,13 @@ static inline void hv_poll_channel(struct vmbus_channel *channel,
 		cb(channel);
 }
 
+enum hvutil_device_state {
+	HVUTIL_DEVICE_INIT = 0,  /* driver is loaded, waiting for userspace */
+	HVUTIL_READY,            /* userspace is registered */
+	HVUTIL_HOSTMSG_RECEIVED, /* message from the host was received */
+	HVUTIL_USERSPACE_REQ,    /* request to userspace was sent */
+	HVUTIL_USERSPACE_RECV,   /* reply from userspace was received */
+	HVUTIL_DEVICE_DYING,     /* driver unload is in progress */
+};
+
 #endif /* _HYPERV_VMBUS_H */
-- 
1.9.3
