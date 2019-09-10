From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v6 0/3] add thermal/power management features for FPGA DFL drivers
Date: Tue, 10 Sep 2019 13:50:37 +0800
Message-ID: <1568094640-4920-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-hwmon@vger.kernel.org, linux@roeck-us.net, jdelvare@suse.com, gregkh@linuxfoundation.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

Hi Mortiz and all,

This patchset adds thermal and power management features for FPGA DFL
drivers. Both patches are using hwmon as userspace interfaces.

As previous dfl patches have been merged, so I resubmit this one after
rebase and clean up, as dependency is resolved now.
(This patchset is generated against char-misc-next).

Please help with review to see if any comments, thank you very much!

Main changes from v5:
 - rebase and clean up (remove empty uinit function) per changes in recent
   merged dfl patches.
 - update date in sysfs doc.

Main changes from v4:
 - rebase due to Documentation format change (dfl.txt -> rst).
 - clamp threshold inputs for sysfs interfaces. (patch#3)
 - update sysfs doc to add more description for ltr sysfs interfaces.
   (patch#3)

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

Wu Hao (2):
  fpga: dfl: fme: add thermal management support
  fpga: dfl: fme: add power management support

Xu Yilun (1):
  Documentation: fpga: dfl: add descriptions for thermal/power
    management interfaces

 Documentation/ABI/testing/sysfs-platform-dfl-fme | 134 ++++++++
 Documentation/fpga/dfl.rst                       |  10 +
 drivers/fpga/Kconfig                             |   2 +-
 drivers/fpga/dfl-fme-main.c                      | 385 +++++++++++++++++++++++
 4 files changed, 530 insertions(+), 1 deletion(-)

-- 
1.8.3.1
