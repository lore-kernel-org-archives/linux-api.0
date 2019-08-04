From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 00/12] FPGA DFL updates
Date: Sun,  4 Aug 2019 18:20:10 +0800
Message-ID: <1564914022-3710-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, mdf@kernel.org, linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, atull@kernel.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

Hi Greg,

This is v4 patchset which adds more features to FPGA DFL. The avx512
partial reconfiguration support patch is dropped for now as need
to address some opens first.

Main changes from v3:
  - drop avx512 partail reconfiguration patch for now.
  - split dfl_fpga_cdev_config_port to 2 functions *_release/assign_port
    (#1).
  - split __dfl_fpga_cdev_config_port_vf into 2 functions with locking
    added (#2).
  - improve description in sysfs doc to avoid misunderstanding (#3).
  - switch to boolean in sysfs entry store function (#3).
  - remove dev_dbg in init/uinit callback function (#7, #9, #11).
  - remove uinit callback which does does nothing (#8, #9)

Main changes from v2:
  - update kernel version/date in sysfs doc (patch #4, #5, #8, #10, #11).
  - add back Documentation patch (patch #12).

Main changes from v1:
  - remove DRV/MODULE_VERSION modifications. (patch #1, #3, #4, #6)
  - remove argsz from new ioctls. (patch #2)
  - replace sysfs_create/remove_* with device_add/remove_* for sysfs entries.
    (patch #5, #8, #11)

Wu Hao (12):
  fpga: dfl: fme: add DFL_FPGA_FME_PORT_RELEASE/ASSIGN ioctl support.
  fpga: dfl: pci: enable SRIOV support.
  fpga: dfl: afu: add AFU state related sysfs interfaces
  fpga: dfl: afu: add userclock sysfs interfaces.
  fpga: dfl: add id_table for dfl private feature driver
  fpga: dfl: afu: export __port_enable/disable function.
  fpga: dfl: afu: add error reporting support.
  fpga: dfl: make uinit callback optional
  fpga: dfl: afu: add STP (SignalTap) support
  fpga: dfl: fme: add capability sysfs interfaces
  fpga: dfl: fme: add global error reporting support
  Documentation: fpga: dfl: add descriptions for virtualization and new
    interfaces.

 Documentation/ABI/testing/sysfs-platform-dfl-fme  |  98 ++++++
 Documentation/ABI/testing/sysfs-platform-dfl-port | 106 ++++++
 Documentation/fpga/dfl.rst                        | 105 ++++++
 drivers/fpga/Makefile                             |   3 +-
 drivers/fpga/dfl-afu-error.c                      | 221 +++++++++++++
 drivers/fpga/dfl-afu-main.c                       | 319 +++++++++++++++++-
 drivers/fpga/dfl-afu.h                            |   7 +
 drivers/fpga/dfl-fme-error.c                      | 381 ++++++++++++++++++++++
 drivers/fpga/dfl-fme-main.c                       | 105 +++++-
 drivers/fpga/dfl-fme-pr.c                         |   7 +-
 drivers/fpga/dfl-fme.h                            |   5 +-
 drivers/fpga/dfl-pci.c                            |  36 ++
 drivers/fpga/dfl.c                                | 216 +++++++++++-
 drivers/fpga/dfl.h                                |  54 ++-
 include/uapi/linux/fpga-dfl.h                     |  18 +
 15 files changed, 1640 insertions(+), 41 deletions(-)
 create mode 100644 drivers/fpga/dfl-afu-error.c
 create mode 100644 drivers/fpga/dfl-fme-error.c

-- 
1.8.3.1
