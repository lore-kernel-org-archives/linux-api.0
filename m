From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 00/12] FPGA DFL updates
Date: Tue, 23 Jul 2019 12:51:23 +0800
Message-ID: <1563857495-26692-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

Hi Greg

This is v3 patchset which adds more features to FPGA DFL. This patchset
is made on top of patch[1] and 5.3-rc1 tree. Documentation patch for DFL
is added back to this patchset

Main changes from v2:
  - update kernel version/date in sysfs doc (patch #4, #5, #8, #10, #11).
  - add back Documentation patch (patch #12).

Main changes from v1:
  - remove DRV/MODULE_VERSION modifications. (patch #1, #3, #4, #6)
  - remove argsz from new ioctls. (patch #2)
  - replace sysfs_create/remove_* with device_add/remove_* for sysfs entries.
    (patch #5, #8, #11)

[1] [PATCH] fpga: dfl: use driver core functions, not sysfs ones.
    https://lkml.org/lkml/2019/7/4/36

Wu Hao (12):
  fpga: dfl: fme: support 512bit data width PR
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
  Documentation: fpga: dfl: add descriptions for virtualization and new
    interfaces.

 Documentation/ABI/testing/sysfs-platform-dfl-fme  |  98 ++++++
 Documentation/ABI/testing/sysfs-platform-dfl-port | 104 ++++++
 Documentation/fpga/dfl.rst                        | 105 ++++++
 drivers/fpga/Makefile                             |   3 +-
 drivers/fpga/dfl-afu-error.c                      | 225 +++++++++++++
 drivers/fpga/dfl-afu-main.c                       | 328 +++++++++++++++++-
 drivers/fpga/dfl-afu.h                            |   7 +
 drivers/fpga/dfl-fme-error.c                      | 385 ++++++++++++++++++++++
 drivers/fpga/dfl-fme-main.c                       |  93 +++++-
 drivers/fpga/dfl-fme-mgr.c                        | 110 ++++++-
 drivers/fpga/dfl-fme-pr.c                         |  50 ++-
 drivers/fpga/dfl-fme.h                            |   7 +-
 drivers/fpga/dfl-pci.c                            |  39 +++
 drivers/fpga/dfl.c                                | 166 +++++++++-
 drivers/fpga/dfl.h                                |  54 ++-
 include/uapi/linux/fpga-dfl.h                     |  19 ++
 16 files changed, 1722 insertions(+), 71 deletions(-)
 create mode 100644 drivers/fpga/dfl-afu-error.c
 create mode 100644 drivers/fpga/dfl-fme-error.c

-- 
1.8.3.1
