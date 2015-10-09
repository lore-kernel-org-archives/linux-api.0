From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] coresight: etm3x: adding documentation for sysFS's cpu interface
Date: Fri,  9 Oct 2015 08:18:20 -0600
Message-ID: <1444400300-9670-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Supplementing ABI documentation with a description of the newly
added interface.

Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
index 67e3557bc4bf..924265a1295d 100644
--- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
+++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etm3x
@@ -245,6 +245,12 @@ KernelVersion:	3.19
 Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 Description: 	(RW) Define the event that controls the trigger.
 
+What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/cpu
+Date:		October 2015
+KernelVersion:	4.4
+Contact:	Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+Description:	(RO) Holds the cpu number this tracer is affined to.
+
 What:		/sys/bus/coresight/devices/<memory_map>.[etm|ptm]/mgmt/etmccr
 Date:		September 2015
 KernelVersion:	4.4
-- 
1.9.1
