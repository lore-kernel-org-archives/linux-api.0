From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v3 00/21] Intel FPGA Device Drivers
Date: Mon, 27 Nov 2017 14:42:07 +0800
Message-ID: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: atull@kernel.org, mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luwei.kang@intel.com, yi.z.zhang@intel.com, hao.wu@intel.com
List-Id: linux-api@vger.kernel.org

Hi All,

Here is v3 patch-series adding drivers for Intel FPGA devices.

The Intel FPGA driver provides interfaces for userspace applications to
configure, enumerate, open, and access FPGA accelerators on platforms
equipped with Intel(R) PCIe based FPGA solutions and enables system
level management functions such as FPGA partial reconfiguration, power
management and virtualization. It also provides a common framework to
support FPGA devices which implement Device Feature List (DFL) and feature
devices under DFL for better code reuse.

This patch series only adds the basic functions for FPGA accelerators and
partial reconfiguration. Patches for more functions, e.g power management
and virtualization, will be submitted after this series gets reviewed.

Patch 1: add a document for Intel FPGA driver overview, including the HW
architecture, driver organization, device enumeration, virtualization and
opens.

Patch 2: add region_id for fpga_image_info data structure, which allows
driver to pass region id information to fpga-mgr for FPGA reconfiguration
function. (Used by Patch 13)

Patch 3: add a 'status' sysfs interface to fpga-mgr class, it reflects
the status of the fpga-mgr including reconfiguration errors. (Used by
Patch 14)

Patch 4-7: add FPGA device feature list support, it provides common
enumeration interfaces which creates container device (FPGA base region)
and all feature devices by walking through all the 'Device Feature Lists'
provided low level drivers.

Patch 8-9: implement Intel FPGA PCIe device driver. It locates all 'Device
Feature Lists' in PCIe device memory and invokes common interfaces from
above device feature list framework to finish the enumeration.

Patch 10-13: implement FPGA Management Engine (FME) driver. It's a
platform driver matching with the FME platform device created by above
device feature list framework during enumeration. Sysfs and device file
ioctls are exposed as user interfaces to allow partial reconfiguration
to Accelerated Function Units (AFUs) from user space applications.

Patch 14-16: implement FPGA manager/bridge/region platform drivers for
Intel FPGA Management Engine (FME). These platform drivers match with
platform devices created by above FME driver, they use the generic
fpga-mgr/bridge/region class infrastructure to implement FPGA partial
reconfiguration function.

Patch 17-21: implement FPGA Accelerated Function Unit (AFU) driver.
It's a platform driver matching with AFU platform device created by above
device feature list framework during enumeration. It provides user
interfaces to expose the AFU MMIO region, map/unmap dma buffer, and
control the port which AFU connects to.

Changes from v2:
- Split common enumeration code from pcie driver to a separated module
  which for device feature list support.
- Drop fpga-dev class and switch to use fpga base region as container.
- Update the intel-fpga.txt documentation for new driver organization.
- Rename feature device drivers for future code reuse.
- Rebase code due to fpga APIs changes
- replace bitfields with marco and shift.
- fix typos, checkpatch issue and other comments.

Changes from v1:

- Use GPLv2 license instead of Dual BSD/GPL.
- Move the code to drivers/fpga folder.
- Update the intel-fpga.txt documentation for new driver organization.
- Add documentation for new sysfs interfaces.
- Switch to use common fpga-region interface for partial reconfiguration
  (PR) function in FME. It creates fpga-region/fpga-mgr/fpga-bridge
  platform devices and leave the implementation to their platform drivers.
- Add platform drivers for FME fpga-mgr/bridge/region platform devices.
- Fix kbuild warnings, typos and other comments.

This patch series depends on the below patchset from Alan Tull.
[PATCH v2 0/5] fpga: don't use drvdata in common fpga code[1]

[1] https://marc.info/?l=linux-fpga&m=151077942606263&w=2

Kang Luwei (3):
  fpga: dfl: add FPGA Management Engine driver basic framework
  fpga: dfl: fme: add header sub feature support
  fpga: dfl: fme: add partial reconfiguration sub feature support

Wu Hao (15):
  docs: fpga: add a document for Intel FPGA driver overview
  fpga: mgr: add region_id to fpga_image_info
  fpga: mgr: add status for fpga-manager
  fpga: add device feature list support
  fpga: dfl: add chardev support for feature devices
  fpga: dfl: adds fpga_cdev_find_port
  fpga: intel-dfl-pci: add enumeration for feature devices
  fpga: dfl: fme: add FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls
    support
  fpga: dfl: add fpga manager platform driver for FME
  fpga: dfl: add fpga bridge platform driver for FME
  fpga: dfl: add fpga region platform driver for FME
  fpga: dfl: add FPGA Accelerated Function Unit driver basic framework
  fpga: dfl: afu: add header sub feature support
  fpga: dfl: afu: add FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls
    support
  fpga: dfl: afu: add FPGA_PORT_DMA_MAP/UNMAP ioctls support

Xiao Guangrong (2):
  fpga: dfl: add feature device infrastructure
  fpga: dfl: afu: add user afu sub feature support

Zhang Yi (1):
  fpga: add Intel FPGA DFL PCIe device

 Documentation/ABI/testing/sysfs-class-fpga-manager |   10 +
 .../ABI/testing/sysfs-platform-fpga-dfl-afu        |   16 +
 .../ABI/testing/sysfs-platform-fpga-dfl-fme        |   21 +
 .../ABI/testing/sysfs-platform-fpga-dfl-fme-mgr    |    8 +
 Documentation/fpga/intel-fpga.txt                  |  261 +++++
 Documentation/ioctl/ioctl-number.txt               |    1 +
 drivers/fpga/Kconfig                               |   71 ++
 drivers/fpga/Makefile                              |   14 +
 drivers/fpga/dfl-afu-dma-region.c                  |  465 +++++++++
 drivers/fpga/dfl-afu-main.c                        |  478 +++++++++
 drivers/fpga/dfl-afu-region.c                      |  127 +++
 drivers/fpga/dfl-afu.h                             |   72 ++
 drivers/fpga/dfl-fme-main.c                        |  275 +++++
 drivers/fpga/dfl-fme-pr.c                          |  492 +++++++++
 drivers/fpga/dfl-fme.h                             |   57 ++
 drivers/fpga/fpga-dfl-fme-br.c                     |   87 ++
 drivers/fpga/fpga-dfl-fme-mgr.c                    |  318 ++++++
 drivers/fpga/fpga-dfl-fme-region.c                 |   92 ++
 drivers/fpga/fpga-dfl.c                            | 1068 ++++++++++++++++++++
 drivers/fpga/fpga-dfl.h                            |  511 ++++++++++
 drivers/fpga/fpga-mgr.c                            |   28 +
 drivers/fpga/intel-dfl-pci.c                       |  324 ++++++
 include/linux/fpga/fpga-mgr.h                      |   19 +
 include/uapi/linux/fpga-dfl.h                      |  178 ++++
 24 files changed, 4993 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-fpga-dfl-afu
 create mode 100644 Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme
 create mode 100644 Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr
 create mode 100644 Documentation/fpga/intel-fpga.txt
 create mode 100644 drivers/fpga/dfl-afu-dma-region.c
 create mode 100644 drivers/fpga/dfl-afu-main.c
 create mode 100644 drivers/fpga/dfl-afu-region.c
 create mode 100644 drivers/fpga/dfl-afu.h
 create mode 100644 drivers/fpga/dfl-fme-main.c
 create mode 100644 drivers/fpga/dfl-fme-pr.c
 create mode 100644 drivers/fpga/dfl-fme.h
 create mode 100644 drivers/fpga/fpga-dfl-fme-br.c
 create mode 100644 drivers/fpga/fpga-dfl-fme-mgr.c
 create mode 100644 drivers/fpga/fpga-dfl-fme-region.c
 create mode 100644 drivers/fpga/fpga-dfl.c
 create mode 100644 drivers/fpga/fpga-dfl.h
 create mode 100644 drivers/fpga/intel-dfl-pci.c
 create mode 100644 include/uapi/linux/fpga-dfl.h

-- 
1.8.3.1
