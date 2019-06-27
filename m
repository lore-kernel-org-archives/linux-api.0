From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 0/3] add thermal/power management features for FPGA DFL drivers
Date: Thu, 27 Jun 2019 12:53:35 +0800
Message-ID: <1561611218-5800-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-hwmon@vger.kernel.org, jdelvare@suse.com, linux@roeck-us.net, atull@kernel.org, gregkh@linuxfoundation.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

This patchset adds thermal and power management features for FPGA DFL
drivers. Both patches are using hwmon as userspace interfaces.

Main changes from v3:
 - use HWMON_CHANNEL_INFO.

Main changes from v2:
 - switch to standard hwmon APIs for thermal hwmon:
     temp1_alarm        --> temp1_max
     temp1_alarm_status --> temp1_max_alarm
     temp1_crit_status  --> temp1_crit_alarm
     temp1_alarm_policy --> temp1_max_policy
 - switch to standard hwmon APIs for power hwmon:
     power1_cap         --> power1_max
     power1_cap_status  --> power1_max_alarm
     power1_crit_status --> power1_crit_alarm

Please note that this patchset is generated on top of this patchset.
[PATCH v4 00/15] add new features for FPGA DFL drivers
 - https://lkml.org/lkml/2019/6/27/29

Wu Hao (2):
  fpga: dfl: fme: add thermal management support
  fpga: dfl: fme: add power management support

Xu Yilun (1):
  Documentation: fpga: dfl: add descriptions for thermal/power
    management interfaces

 Documentation/ABI/testing/sysfs-platform-dfl-fme | 131 ++++++++
 Documentation/fpga/dfl.txt                       |  10 +
 drivers/fpga/Kconfig                             |   2 +-
 drivers/fpga/dfl-fme-main.c                      | 408 +++++++++++++++++++++++
 4 files changed, 550 insertions(+), 1 deletion(-)

-- 
1.8.3.1
