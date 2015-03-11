From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 08/21] Drivers: hv: util: introduce state machine for
 util drivers
Date: Wed, 11 Mar 2015 14:29:21 +0100
Message-ID: <1426080574-9011-9-git-send-email-vkuznets@redhat.com>
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

KVP/VSS/FCOPY drivers work in fully serialized mode: we wait till userspace
daemon registers, wait for a message from the host, send this message to the
daemon, get the reply, send it back to host, wait for another message.
Introduce enum hvutil_device_state to represend this state in all 3 drivers.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hyperv_vmbus.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 177dbec..62efcce 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -724,4 +724,13 @@ static inline void hv_poll_channel(struct vmbus_channel *channel,
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
