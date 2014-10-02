From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] Documentation: charger: max14577: Update the date of
 introducing ABI
Date: Thu, 02 Oct 2014 14:12:34 +0200
Message-ID: <1412251954-29912-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Update the date of introducing max14577 charger's ABI (fast_charge_timer
sysfs entry) to approximate date of kernel release which actually
introduces this.

The old date came from previous driver submissions.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-class-power | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index ad4fb90ab23d..909e7602c717 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -20,7 +20,7 @@ Description:
 		amended over time.
 
 What:		/sys/class/power_supply/max14577-charger/device/fast_charge_timer
-Date:		July 2014
+Date:		October 2014
 KernelVersion:	3.18.0
 Contact:	Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
 Description:
-- 
1.9.1
