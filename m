From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 00/15] add new features for FPGA DFL drivers
Date: Thu, 27 Jun 2019 12:44:40 +0800
Message-ID: <1561610695-5414-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, yilun.xu@intel.com, hao.wu@intel.com, gregkh@linuxfoundation.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

This patchset adds more features support for FPGA Device Feature List
(DFL) drivers, including PR enhancement, virtualization support based
on PCIe SRIOV, private features of Port, private features of FME, and
enhancement to DFL framework. Please refer to details in below list.

Main changes from v3:
 - split performance reporting support into another patchset for
   better review.

Main changes from v2:
 - move thermal/power management private feature support to another
   patchset, including hwmon patches and related documentation update.
 - update sysfs doc for kernel version and date.
 - replace scnprintf to sprintf for sysfs interfaces.
 - fix comments for performance reporting support. (patch #16)

Main changes from v1:
 - split the clean up code in a separated patch (patch #2)
 - add cpu_feature_enabled check for AVX512 code (patch #4)
 - improve sysfs return values and also sysfs doc (patch #12 #17)
 - create a hwmon for thermal management sysfs interfaces (patch #15)
 - create a hwmon for power management sysfs interfaces (patch #16)
 - update docmentation according to above changes (patch #5)
 - improve sysfs doc for performance reporting support (patch #18)

Wu Hao (15):
  fpga: dfl-fme-mgr: fix FME_PR_INTFC_ID register address.
  fpga: dfl: fme: remove copy_to_user() in ioctl for PR
  fpga: dfl: fme: align PR buffer size per PR datawidth
  fpga: dfl: fme: support 512bit data width PR
  Documentation: fpga: dfl: add descriptions for virtualization and new
    interfaces.
  fpga: dfl: fme: add DFL_FPGA_FME_PORT_RELEASE/ASSIGN ioctl support.
  fpga: dfl: pci: enable SRIOV support.
  fpga: dfl: afu: add AFU state related sysfs interfaces
  fpga: dfl: afu: add userclock sysfs interfaces.
  fpga: dfl: add id_table for dfl private feature driver
  fpga: dfl: afu: export __port_enable/disable function.
  fpga: dfl: afu: add error reporting support.
  fpga: dfl: afu: add STP (SignalTap) support
  fpga: dfl: fme: add capability sysfs interfaces
  fpga: dfl: fme: add global error reporting support

 Documentation/ABI/testing/sysfs-platform-dfl-fme  |  98 ++++++
 Documentation/ABI/testing/sysfs-platform-dfl-port | 104 ++++++
 Documentation/fpga/dfl.txt                        | 101 ++++++
 drivers/fpga/Makefile                             |   3 +-
 drivers/fpga/dfl-afu-error.c                      | 225 +++++++++++++
 drivers/fpga/dfl-afu-main.c                       | 330 ++++++++++++++++++-
 drivers/fpga/dfl-afu.h                            |   7 +
 drivers/fpga/dfl-fme-error.c                      | 385 ++++++++++++++++++++++
 drivers/fpga/dfl-fme-main.c                       | 120 ++++++-
 drivers/fpga/dfl-fme-mgr.c                        | 117 ++++++-
 drivers/fpga/dfl-fme-pr.c                         |  65 ++--
 drivers/fpga/dfl-fme.h                            |   7 +-
 drivers/fpga/dfl-pci.c                            |  40 +++
 drivers/fpga/dfl.c                                | 169 +++++++++-
 drivers/fpga/dfl.h                                |  54 ++-
 include/uapi/linux/fpga-dfl.h                     |  32 ++
 16 files changed, 1777 insertions(+), 80 deletions(-)
 create mode 100644 drivers/fpga/dfl-afu-error.c
 create mode 100644 drivers/fpga/dfl-fme-error.c

-- 
1.8.3.1
