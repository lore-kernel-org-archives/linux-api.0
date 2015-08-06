From: Cristina Opriceana <cristina.opriceana@gmail.com>
Subject: [PATCH v2] iio: Documentation: Add trigger name attribute ABI
 documentation
Date: Thu, 6 Aug 2015 14:17:53 +0300
Message-ID: <7d408fb8def6478565e30d01edcfc98d9cf42b48.1438859058.git.cristina.opriceana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jic23@kernel.org
Cc: daniel.baluta@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch adds an entry in ABI Documentation for the name attribute
issued when a trigger is created.

Signed-off-by: Cristina Opriceana <cristina.opriceana@gmail.com>
---
Changes in v2:
 - deviceX to deviceY, to avoid confusion
 - clearer description

 Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
index 5235e6c..0c1e843 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
+++ b/Documentation/ABI/testing/sysfs-bus-iio-trigger-sysfs
@@ -9,3 +9,12 @@ Description:
 		automated testing or in situations, where other trigger methods
 		are not applicable. For example no RTC or spare GPIOs.
 		X is the IIO index of the trigger.
+
+What:		/sys/bus/iio/devices/triggerX/name
+KernelVersion:	2.6.39
+Contact:	linux-iio@vger.kernel.org
+Description:
+		The name attribute holds a description string for the current
+		trigger. In order to associate the trigger with an IIO device
+		one should write this name string to
+		/sys/bus/iio/devices/iio:deviceY/trigger/current_trigger.
-- 
1.9.1
