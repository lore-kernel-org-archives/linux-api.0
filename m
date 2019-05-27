From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 00/16] add new features for FPGA DFL drivers
Date: Mon, 27 May 2019 13:22:10 +0800
Message-ID: <1558934546-12171-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

This patchset adds more features support for FPGA Device Feature List
(DFL) drivers, including PR enhancement, virtualization support based
on PCIe SRIOV, private features to Port, private features to FME, and
enhancement to DFL framework. Please refer to details in below list.

This patchset is created on top of these patches from Alan.
[PATCH 0/4] patches for FPGA - https://lkml.org/lkml/2019/5/9/1002

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

Wu Hao (16):
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
  fpga: dfl: fme: add performance reporting support

 Documentation/ABI/testing/sysfs-platform-dfl-fme  | 191 +++++
 Documentation/ABI/testing/sysfs-platform-dfl-port | 104 +++
 Documentation/fpga/dfl.txt                        | 105 +++
 drivers/fpga/Makefile                             |   4 +-
 drivers/fpga/dfl-afu-error.c                      | 225 +++++
 drivers/fpga/dfl-afu-main.c                       | 330 +++++++-
 drivers/fpga/dfl-afu.h                            |   7 +
 drivers/fpga/dfl-fme-error.c                      | 385 +++++++++
 drivers/fpga/dfl-fme-main.c                       | 124 ++-
 drivers/fpga/dfl-fme-mgr.c                        | 117 ++-
 drivers/fpga/dfl-fme-perf.c                       | 962 ++++++++++++++++++++++
 drivers/fpga/dfl-fme-pr.c                         |  65 +-
 drivers/fpga/dfl-fme.h                            |   9 +-
 drivers/fpga/dfl-pci.c                            |  40 +
 drivers/fpga/dfl.c                                | 170 +++-
 drivers/fpga/dfl.h                                |  56 +-
 include/uapi/linux/fpga-dfl.h                     |  32 +
 17 files changed, 2846 insertions(+), 80 deletions(-)
 create mode 100644 drivers/fpga/dfl-afu-error.c
 create mode 100644 drivers/fpga/dfl-fme-error.c
 create mode 100644 drivers/fpga/dfl-fme-perf.c

-- 
1.8.3.1
