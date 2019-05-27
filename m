From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 0/3] add thermal/power management features for FPGA DFL drivers
Date: Mon, 27 May 2019 14:06:53 +0800
Message-ID: <1558937216-12742-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, jdelvare@suse.com, linux@roeck-us.net, linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

This patchset adds thermal and power management features for FPGA DFL
drivers. Both patches are using hwmon as userspace interfaces.
Actually this patchset is splitted from patchset [1].

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

v2 version patch could be found here [2] - thermal, [3] - power.

Please note that this patchset needs to be applied on top of patchset [4].

Thanks!

[1] https://lkml.org/lkml/2019/4/29/227
[2] https://lkml.org/lkml/2019/4/29/211
[3] https://lkml.org/lkml/2019/4/29/213
[4] https://lkml.org/lkml/2019/5/27/11

Wu Hao (2):
  fpga: dfl: fme: add thermal management support
  fpga: dfl: fme: add power management support

Xu Yilun (1):
  Documentation: fpga: dfl: add descriptions for thermal/power
    management interfaces

 Documentation/ABI/testing/sysfs-platform-dfl-fme | 131 +++++++
 Documentation/fpga/dfl.txt                       |   9 +
 drivers/fpga/Kconfig                             |   2 +-
 drivers/fpga/dfl-fme-main.c                      | 426 +++++++++++++++++++++++
 4 files changed, 567 insertions(+), 1 deletion(-)

-- 
1.8.3.1
