From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 00/22] Intel FPGA Device Drivers
Date: Mon, 26 Jun 2017 09:51:56 +0800
Message-ID: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi All,

Here is v2 patch-series adding drivers for Intel FPGA devices.

The Intel FPGA driver provides interfaces for userspace applications to
configure, enumerate, open, and access FPGA accelerators on platforms
equipped with Intel(R) PCIe based FPGA solutions and enables system
level management functions such as FPGA partial reconfiguration, power
management and virtualization.

This patch series only adds the basic functions for FPGA accelerators and
partial reconfiguration. Patches for more functions, e.g power management
and virtualization, will be submitted after this series gets reviewed.

This patch series depends on Alan Tull's patch set v2 on FPGA region
support w/o device tree (see [1]).

Patch 1: add a document for Intel FPGA driver overview, including the HW
architecture, driver organization, device enumeration, virtualization and
opens.

Patch 2: introduce a fpga-dev class. It's used in below Intel FPGA PCIe
device driver, to represent a FPGA device on the system, and all actual
feature devices should be registered as child nodes of this container
fpga-dev device.

Patch 3: remove OF dependency for fpga bridge. allow fpga bridge class to
be used in non device tree case.

Patch 4: add region_id for fpga_image_info data structure, which allows
driver to pass region id information to fpga-mgr for FPGA reconfiguration
function.

Patch 5: add a 'status' sysfs interface to fpga-mgr class, it reflects
the status of the fpga-mgr including reconfiguration errors.

Patch 6-10: implement Intel FPGA PCIe device driver. It walks through the
'Device Feature List' in the PCI Bar, creates the container fpga-dev as
parent and platform devices as children for the feature devices it found.

Patch 11-14: implement Intel FPGA Management Engine (FME) driver. It's a
platform driver matching with the FME platform device created by above
PCIe driver. Sysfs and device file ioctls are exposed as user interfaces
to allow partial reconfiguration to Accelerated Function Units (AFUs) from
user space applications.

Patch 15-17: implement FPGA manager/bridge/region platform drivers for
Intel FPGA Management Engine (FME). These platform drivers match with
platform devices created by above FME driver, they use the generic
fpga-mgr/bridge/region class infrastructure to implement FPGA partial
reconfiguration function.

Patch 18-22: implement Intel FPGA Accelerated Function Unit (AFU) driver.
It's a platform driver matching with AFU platform device created by above
PCIe driver. It provides user interfaces to expose the AFU MMIO region,
map/unmap dma buffer, and control the port which AFU connects to.


Changes from v1:

- Use GPLv2 license instead of Dual BSD/GPL.
- Move the code to drivers/fpga folder.
- Update the intel-fpga.txt documentation for new driver organization.
- Add documentation for new sysfs interfacesa.
- Switch to use common fpga-region interface for partial reconfiguration
  (PR) function in FME. It creates fpga-region/fpga-mgr/fpga-bridge
  platform devices and leave the implementation to their platform drivers.
- Add platform drivers for FME fpga-mgr/bridge/region platform devices.
- Fix kbuild warnings, typos and other comments.

[1] http://marc.info/?l=linux-kernel&m=149269778606030&w=2

Kang Luwei (3):
  fpga: intel: add FPGA Management Engine driver basic framework
  fpga: intel: fme: add header sub feature support
  fpga: intel: fme: add partial reconfiguration sub feature support

Wu Hao (14):
  docs: fpga: add a document for Intel FPGA driver overview
  fpga: add FPGA device framework
  fpga: bridge: remove OF dependency for fpga-bridge
  fpga: mgr: add region_id to fpga_image_info
  fpga: mgr: add status for fpga-mgr
  fpga: intel: pcie: adds fpga_for_each_port callback for fme device
  fpga: intel: fme: add FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls
    support
  fpga: intel: add fpga manager platform driver for FME
  fpga: intel: add fpga bridge platform driver for FME
  fpga: intel: add fpga region platform driver for FME
  fpga: intel: add FPGA Accelerated Function Unit driver basic framework
  fpga: intel: afu: add header sub feature support
  fpga: intel: afu add FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls
    support
  fpga: intel: afu: add FPGA_PORT_DMA_MAP/UNMAP ioctls support

Xiao Guangrong (4):
  fpga: intel: pcie: parse feature list and create platform device for
    features.
  fpga: intel: pcie: add chardev support for feature devices
  fpga: intel: add feature device infrastructure
  fpga: intel: afu: add user afu sub feature support

Zhang Yi (1):
  fpga: intel: add FPGA PCIe device driver

 Documentation/ABI/testing/sysfs-class-fpga-dev     |    5 +
 Documentation/ABI/testing/sysfs-class-fpga-manager |   10 +
 .../ABI/testing/sysfs-platform-intel-fpga-afu      |   16 +
 .../ABI/testing/sysfs-platform-intel-fpga-fme      |   19 +
 .../ABI/testing/sysfs-platform-intel-fpga-fme-mgr  |    8 +
 Documentation/fpga/intel-fpga.txt                  |  256 +++++
 Documentation/ioctl/ioctl-number.txt               |    1 +
 drivers/fpga/Kconfig                               |   73 +-
 drivers/fpga/Makefile                              |   16 +
 drivers/fpga/fpga-dev.c                            |  118 +++
 drivers/fpga/fpga-mgr.c                            |   24 +
 drivers/fpga/intel-afu-dma-region.c                |  372 ++++++++
 drivers/fpga/intel-afu-main.c                      |  469 +++++++++
 drivers/fpga/intel-afu-region.c                    |  127 +++
 drivers/fpga/intel-afu.h                           |   70 ++
 drivers/fpga/intel-feature-dev.c                   |  272 ++++++
 drivers/fpga/intel-feature-dev.h                   |  515 ++++++++++
 drivers/fpga/intel-fme-main.c                      |  265 ++++++
 drivers/fpga/intel-fme-pr.c                        |  494 ++++++++++
 drivers/fpga/intel-fme.h                           |   57 ++
 drivers/fpga/intel-fpga-fme-br.c                   |   77 ++
 drivers/fpga/intel-fpga-fme-mgr.c                  |  307 ++++++
 drivers/fpga/intel-fpga-fme-region.c               |   91 ++
 drivers/fpga/intel-pcie.c                          | 1003 ++++++++++++++++++++
 include/linux/fpga/fpga-dev.h                      |   31 +
 include/linux/fpga/fpga-mgr.h                      |   10 +
 include/uapi/linux/intel-fpga.h                    |  175 ++++
 27 files changed, 4880 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-dev
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-fpga-afu
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-fpga-fme
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-fpga-fme-mgr
 create mode 100644 Documentation/fpga/intel-fpga.txt
 create mode 100644 drivers/fpga/fpga-dev.c
 create mode 100644 drivers/fpga/intel-afu-dma-region.c
 create mode 100644 drivers/fpga/intel-afu-main.c
 create mode 100644 drivers/fpga/intel-afu-region.c
 create mode 100644 drivers/fpga/intel-afu.h
 create mode 100644 drivers/fpga/intel-feature-dev.c
 create mode 100644 drivers/fpga/intel-feature-dev.h
 create mode 100644 drivers/fpga/intel-fme-main.c
 create mode 100644 drivers/fpga/intel-fme-pr.c
 create mode 100644 drivers/fpga/intel-fme.h
 create mode 100644 drivers/fpga/intel-fpga-fme-br.c
 create mode 100644 drivers/fpga/intel-fpga-fme-mgr.c
 create mode 100644 drivers/fpga/intel-fpga-fme-region.c
 create mode 100644 drivers/fpga/intel-pcie.c
 create mode 100644 include/linux/fpga/fpga-dev.h
 create mode 100644 include/uapi/linux/intel-fpga.h

-- 
1.8.3.1
