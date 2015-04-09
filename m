From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v3 21/21] Drivers: hv: utils: unify driver registration reporting
Date: Thu,  9 Apr 2015 10:38:50 +0200
Message-ID: <1428568730-6030-22-git-send-email-vkuznets@redhat.com>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, Radim Krcmar <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

... and move it to debug level as normally daemons write to syslog themselves
and these kernel messages are useless.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv_fcopy.c    | 3 +--
 drivers/hv/hv_kvp.c      | 3 ++-
 drivers/hv/hv_snapshot.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index b7b528c..b50dd33 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -107,8 +107,7 @@ static int fcopy_handle_handshake(u32 version)
 		 */
 		return -EINVAL;
 	}
-	pr_info("FCP: user-mode registering done. Daemon version: %d\n",
-		version);
+	pr_debug("FCP: userspace daemon ver. %d registered\n", version);
 	fcopy_transaction.state = HVUTIL_READY;
 	hv_poll_channel(fcopy_transaction.fcopy_context,
 			hv_fcopy_onchannelcallback);
diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index baa1208..d85798d 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -150,7 +150,8 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 	/*
 	 * We have a compatible daemon; complete the handshake.
 	 */
-	pr_info("KVP: user-mode registering done.\n");
+	pr_debug("KVP: userspace daemon ver. %d registered\n",
+		 KVP_OP_REGISTER);
 	kvp_register(dm_reg_value);
 	kvp_transaction.state = HVUTIL_READY;
 
diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
index ee1762b..815405f 100644
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -113,7 +113,7 @@ static int vss_handle_handshake(struct hv_vss_msg *vss_msg)
 		return -EINVAL;
 	}
 	vss_transaction.state = HVUTIL_READY;
-	pr_info("VSS daemon registered\n");
+	pr_debug("VSS: userspace daemon ver. %d registered\n", dm_reg_value);
 	return 0;
 }
 
-- 
1.9.3
