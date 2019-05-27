From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 1/3] Documentation: fpga: dfl: add descriptions for thermal/power management interfaces
Date: Mon, 27 May 2019 14:06:54 +0800
Message-ID: <1558937216-12742-2-git-send-email-hao.wu@intel.com>
References: <1558937216-12742-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1558937216-12742-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, jdelvare@suse.com, linux@roeck-us.net, linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

From: Xu Yilun <yilun.xu@intel.com>

This patch add introductions to thermal/power interfaces. They are
implemented as hwmon sysfs interfaces by thermal/power private
feature drivers.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Wu Hao <hao.wu@intel.com>
---
 Documentation/fpga/dfl.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/fpga/dfl.txt b/Documentation/fpga/dfl.txt
index 9e912a0..d377e36 100644
--- a/Documentation/fpga/dfl.txt
+++ b/Documentation/fpga/dfl.txt
@@ -109,6 +109,15 @@ More functions are exposed through sysfs
      performance counters sysfs interfaces allow user to use different counters
      to get performance data.
 
+ Power management (dfl_fme_power hwmon)
+     power management hwmon sysfs interfaces allow user to read power management
+     information (power consumption, thresholds, threshold status, limits, etc.)
+     and and configure power thresholds for different throttling levels.
+
+ Thermal management (dfl_fme_thermal hwmon)
+     thermal management hwmon sysfs interfaces allow user to read thermal
+     management information (current temperature, thresholds, threshold status,
+     etc.).
 
 FIU - PORT
 ==========
-- 
1.8.3.1
