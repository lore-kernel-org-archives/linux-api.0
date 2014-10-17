From: WANG Chao <chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Documentation/ABI/testing/sysfs-ibft: fix a typo
Date: Fri, 17 Oct 2014 16:47:26 +0800
Message-ID: <1413535647-17801-1-git-send-email-chaowang@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Correct a sentence in Documentation/ABI/testing/sysfs-ibft.

Signed-off-by: WANG Chao <chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-ibft | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-ibft b/Documentation/ABI/testing/sysfs-ibft
index c2b7d11..cac3930 100644
--- a/Documentation/ABI/testing/sysfs-ibft
+++ b/Documentation/ABI/testing/sysfs-ibft
@@ -20,4 +20,4 @@ Date:		November 2007
 Contact:	Konrad Rzeszutek <ketuzsezr-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org>
 Description:	The /sys/firmware/ibft/ethernetX directory will contain
 		files that expose the iSCSI Boot Firmware Table NIC data.
-		This can this can the IP address, MAC, and gateway of the NIC.
+		Usually this contains the IP address, MAC, and gateway of the NIC.
-- 
1.9.3
