From: Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] iio: doc: fix typo
Date: Thu, 30 Apr 2015 16:36:22 +0200
Message-ID: <1430404582-13115-1-git-send-email-martink@posteo.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jic23@kernel.org, irina.tirdea@intel.com
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
List-Id: linux-api@vger.kernel.org

Since we have deviceX, we don't need accelX. This has no users as of now, so
correcting this is no problem.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---

That's really just a question now. If I'm wrong, sorry for the noise.

 Documentation/ABI/testing/sysfs-bus-iio | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 3befcb1..efd1334 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -1119,7 +1119,7 @@ Description:
 		This attribute is used to read the amount of quadrature error
 		present in the device at a given time.
 
-What:		/sys/.../iio:deviceX/in_accelX_power_mode
+What:		/sys/.../iio:deviceX/in_accel_power_mode
 KernelVersion:	3.11
 Contact:	linux-iio@vger.kernel.org
 Description:
-- 
2.1.4
