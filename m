From: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Doc:ABI/testing: Fix typo in sysfs-bus-fcoe
Date: Sat, 20 Jun 2015 11:17:20 +0900
Message-ID: <1434766640-23799-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch fix some spelling typo in sysfs-bus-fcoe

Signed-off-by: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-bus-fcoe | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-fcoe b/Documentation/ABI/testing/sysfs-bus-fcoe
index 21640ea..657df13 100644
--- a/Documentation/ABI/testing/sysfs-bus-fcoe
+++ b/Documentation/ABI/testing/sysfs-bus-fcoe
@@ -32,7 +32,7 @@ Description:	'FCoE Controller' instances on the fcoe bus.
 
 Attributes:
 
-	fcf_dev_loss_tmo: Device loss timeout peroid (see below). Changing
+	fcf_dev_loss_tmo: Device loss timeout period (see below). Changing
 			  this value will change the dev_loss_tmo for all
 			  FCFs discovered by this controller.
 
@@ -61,7 +61,7 @@ Attributes:
 	lesb/err_block:   Link Error Status Block (LESB) block error count.
 
 	lesb/fcs_error:   Link Error Status Block (LESB) Fibre Channel
-			  Serivces error count.
+			  Services error count.
 
 Notes: ctlr_X (global increment starting at 0)
 
@@ -85,7 +85,7 @@ Attributes:
 		     fabric.
 
 	selected:    1 indicates that the switch has been selected for use;
-		     0 indicates that the swich will not be used.
+		     0 indicates that the switch will not be used.
 
 	fc_map:      The Fibre Channel MAP
 
@@ -93,7 +93,7 @@ Attributes:
 
 	mac:         The FCF's MAC address
 
-	fka_peroid:  The FIP Keep-Alive peroid
+	fka_period:  The FIP Keep-Alive period
 
 	fabric_state: The internal kernel state
 		      "Unknown" - Initialization value
@@ -101,9 +101,9 @@ Attributes:
 		      "Connected" - Host is connected to the FCF
 		      "Deleted" - FCF is being removed from the system
 
-	dev_loss_tmo: The device loss timeout peroid for this FCF.
+	dev_loss_tmo: The device loss timeout period for this FCF.
 
-Notes: A device loss infrastructre similar to the FC Transport's
+Notes: A device loss infrastructure similar to the FC Transport's
        is present in fcoe_sysfs. It is nice to have so that a
        link flapping adapter doesn't continually advance the count
        used to identify the discovered FCF. FCFs will exist in a
-- 
2.4.4.408.g16da57c
