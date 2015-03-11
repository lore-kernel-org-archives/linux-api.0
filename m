From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFCv2 01/21] Drivers: hv: util: move kvp/vss function
 declarations to hyperv_vmbus.h
Date: Wed, 11 Mar 2015 14:29:14 +0100
Message-ID: <1426080574-9011-2-git-send-email-vkuznets@redhat.com>
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

These declarations are internal to hv_util module and hv_fcopy_* declarations
already reside there.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_kvp.c       | 1 +
 drivers/hv/hv_snapshot.c  | 2 ++
 drivers/hv/hyperv_vmbus.h | 8 ++++++++
 include/linux/hyperv.h    | 8 --------
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index beb8105..a414c83 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -28,6 +28,7 @@
 #include <linux/workqueue.h>
 #include <linux/hyperv.h>
 
+#include "hyperv_vmbus.h"
 
 /*
  * Pre win8 version numbers used in ws2008 and ws 2008 r2 (win7)
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index 9d5e0d1..c1a3604 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -24,6 +24,8 @@
 #include <linux/workqueue.h>
 #include <linux/hyperv.h>
 
+#include "hyperv_vmbus.h"
+
 #define VSS_MAJOR  5
 #define VSS_MINOR  0
 #define VSS_VERSION    (VSS_MAJOR << 16 | VSS_MINOR)
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 44b1c94..0d85dd1 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -699,6 +699,14 @@ int vmbus_set_event(struct vmbus_channel *channel);
 
 void vmbus_on_event(unsigned long data);
 
+int hv_kvp_init(struct hv_util_service *);
+void hv_kvp_deinit(void);
+void hv_kvp_onchannelcallback(void *);
+
+int hv_vss_init(struct hv_util_service *);
+void hv_vss_deinit(void);
+void hv_vss_onchannelcallback(void *);
+
 int hv_fcopy_init(struct hv_util_service *);
 void hv_fcopy_deinit(void);
 void hv_fcopy_onchannelcallback(void *);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 5a2ba67..78cfd65 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1206,14 +1206,6 @@ extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *,
 					struct icmsg_negotiate *, u8 *, int,
 					int);
 
-int hv_kvp_init(struct hv_util_service *);
-void hv_kvp_deinit(void);
-void hv_kvp_onchannelcallback(void *);
-
-int hv_vss_init(struct hv_util_service *);
-void hv_vss_deinit(void);
-void hv_vss_onchannelcallback(void *);
-
 extern struct resource hyperv_mmio;
 
 /*
-- 
1.9.3
