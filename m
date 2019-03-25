From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH 00/17] add new features for FPGA DFL drivers
Date: Mon, 25 Mar 2019 11:07:27 +0800
Message-ID: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

This patchset adds more features support for FPGA Device Feature List
(DFL) drivers, including PR enhancement, virtualization support based
on PCIe SRIOV, private features to Port, private features to FME, and
enhancement to DFL framework. Please refer to details in below list.

Patch 1: A bug fixing to current dfl-fme-mgr driver.
Patch 2-3: add 512bit data width PR support.
Patch 4-6: add virtualization support based on PCIe SRIOV.
Patch 7-8: add new AFU state and userclock related sysfs to dfl-afu.
Patch 9-10: enhancement to DFL framework in order to support id_table.
Patch 11: add error reporting private feature support to dfl-afu.
Patch 12: add STP (SignalTap) private feature support to dfl-afu.
Patch 13: add capability sysfs interfaces to dfl-fme.
Patch 14: add thermal management private feature support to dfl-fme.
Patch 15: add power management private feature support to dfl-fme.
Patch 16: add global error reporitng private feature support to dfl-fme.
Patch 17: add performance reporting support to dfl-fme.

Wu Hao (17):
  fpga: dfl-fme-mgr: fix FME_PR_INTFC_ID register address.
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
  fpga: dfl: fme: add thermal management support
  fpga: dfl: fme: add power management support
  fpga: dfl: fme: add global error reporting support
  fpga: dfl: fme: add performance reporting support

 Documentation/ABI/testing/sysfs-platform-dfl-fme  | 279 +++++++
 Documentation/ABI/testing/sysfs-platform-dfl-port |  94 +++
 Documentation/fpga/dfl.txt                        | 115 +++
 drivers/fpga/Makefile                             |   4 +-
 drivers/fpga/dfl-afu-error.c                      | 225 +++++
 drivers/fpga/dfl-afu-main.c                       | 335 +++++++-
 drivers/fpga/dfl-afu.h                            |   7 +
 drivers/fpga/dfl-fme-error.c                      | 390 +++++++++
 drivers/fpga/dfl-fme-main.c                       | 583 ++++++++++++-
 drivers/fpga/dfl-fme-mgr.c                        |  79 +-
 drivers/fpga/dfl-fme-perf.c                       | 950 ++++++++++++++++++++++
 drivers/fpga/dfl-fme-pr.c                         |  64 +-
 drivers/fpga/dfl-fme.h                            |   9 +-
 drivers/fpga/dfl-pci.c                            |  40 +
 drivers/fpga/dfl.c                                | 170 +++-
 drivers/fpga/dfl.h                                |  56 +-
 include/uapi/linux/fpga-dfl.h                     |  32 +
 17 files changed, 3355 insertions(+), 77 deletions(-)
 create mode 100644 drivers/fpga/dfl-afu-error.c
 create mode 100644 drivers/fpga/dfl-fme-error.c
 create mode 100644 drivers/fpga/dfl-fme-perf.c

-- 
2.7.4
