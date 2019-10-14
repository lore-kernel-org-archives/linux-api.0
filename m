From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v7 1/3] Documentation: fpga: dfl: add descriptions for thermal/power management interfaces
Date: Mon, 14 Oct 2019 13:42:01 +0800
Message-ID: <1571031723-12101-2-git-send-email-hao.wu@intel.com>
References: <1571031723-12101-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1571031723-12101-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-hwmon@vger.kernel.org, linux@roeck-us.net, jdelvare@suse.com, gregkh@linuxfoundation.org, Xu Yilun <yilun.xu@intel.com>, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

From: Xu Yilun <yilun.xu@intel.com>

This patch add introductions to thermal/power interfaces. They are
implemented as hwmon sysfs interfaces by thermal/power private
feature drivers.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
---
 Documentation/fpga/dfl.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/fpga/dfl.rst b/Documentation/fpga/dfl.rst
index 6fa483f..094fc8a 100644
--- a/Documentation/fpga/dfl.rst
+++ b/Documentation/fpga/dfl.rst
@@ -108,6 +108,16 @@ More functions are exposed through sysfs
      error reporting sysfs interfaces allow user to read errors detected by the
      hardware, and clear the logged errors.
 
+ Power management (dfl_fme_power hwmon)
+     power management hwmon sysfs interfaces allow user to read power management
+     information (power consumption, thresholds, threshold status, limits, etc.)
+     and configure power thresholds for different throttling levels.
+
+ Thermal management (dfl_fme_thermal hwmon)
+     thermal management hwmon sysfs interfaces allow user to read thermal
+     management information (current temperature, thresholds, threshold status,
+     etc.).
+
 
 FIU - PORT
 ==========
-- 
1.8.3.1
