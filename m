From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v7 00/29] FPGA Device Feature List (DFL) Device Drivers
Date: Mon, 9 Jul 2018 11:34:20 -0500
Message-ID: <CANk1AXQ0crNX2u_=XLEakhhfO8dcTED0OO6fHU10uAx0yOJewg@mail.gmail.com>
References: <1530320016-24712-1-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530320016-24712-1-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wu Hao <hao.wu@intel.com>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 29, 2018 at 7:53 PM, Wu Hao <hao.wu@intel.com> wrote:
> Hi All,
>
> Here is v7 patch-series adding drivers for FPGA DFL devices.

Hi Greg,

Could you please take this v7 patchset for 4.19?

Alan

>
> This patch series provides a common framework to support FPGA Device
> Feature List (DFL) and also feature dev drivers under this DFL framework
> to provide interfaces for userspace applications to configure, enumerate,
> open and access FPGA accelerators on DFL based FPGA device and enables
> system level management functions such as FPGA partial reconfiguration,
> power management and virtualization.
>
> This patch series only adds the basic functions for FPGA accelerators and
> partial reconfiguration. Patches for more functions, e.g. power management
> and virtualization, will be submitted after this series gets reviewed.
>
> Note this patch series is only verified on DFL based Intel(R) FPGA PCIe
> devices (e.g. Intel Server Platform with In-package FPGA and Intel FPGA
> PCIe Acceleration Cards).
>
> Patch 1: add a document for FPGA DFL framework driver overview, including
> Device Feature List (DFL) introduction, the HW architecture, driver
> organization, device enumeration and opens.
>
> Patch 2: add region_id for fpga_image_info data structure, which allows
> driver to pass region id information to fpga-mgr for FPGA reconfiguration
> function. (Used by Patch 17)
>
> Patch 3: add a 'status' sysfs interface to fpga-mgr class, it reflects
> the status of the fpga-mgr including reconfiguration errors. (Used by
> Patch 18)
>
> Patch 4-5: add compat_id support in fpga manager and region, this compat
> id is used for compatibility check before further actions (e.g. partial
> reconfiguration). (Used by Patch 19 and 22)
>
> Patch 6-11: add FPGA device feature list support, it provides common
> enumeration interfaces which creates container device (FPGA base region)
> and all feature devices by walking through all the 'Device Feature Lists'
> provided low level drivers. A global list is added to DFL framework to
> manage port ops from different ports.
>
> Patch 12-13: implement FPGA PCIe device driver. It locates all 'Device
> Feature Lists' in PCIe device memory and invokes common interfaces from
> above device feature list framework to finish the enumeration.
>
> Patch 14-17: implement FPGA Management Engine (FME) driver. It's a
> platform driver matching with the FME platform device created by above
> device feature list framework during enumeration. Sysfs and device file
> ioctls are exposed as user interfaces to allow partial reconfiguration
> to Accelerated Function Units (AFUs) from user space applications.
>
> Patch 18-22: implement FPGA manager/bridge/region platform drivers for
> Intel FPGA Management Engine (FME). These platform drivers match with
> platform devices created by above FME driver, they use the generic
> fpga-mgr/bridge/region class infrastructure to implement FPGA partial
> reconfiguration function.
>
> Patch 23-28: implement FPGA Accelerated Function Unit (AFU) driver.
> It's a platform driver matching with AFU platform device created by above
> device feature list framework during enumeration. It provides user
> interfaces to expose the AFU MMIO region, map/unmap dma buffer and
> control the port which AFU connects to.
>
> Patch 29: add a entry in MAINTAINERS for this FPGA DFL drivers patchset.
>
> Changes from v6:
> - Improve Kconfig description, fix typos and other comments.
> - Update target kernelversion in sysfs doc.
> - Fix issues reported by kbuild.
> - Simplify pcie driver by using pcim_xxx functions.
>
> Changes from v5:
> - Improve functions/APIs naming per suggestion from Alan Tull.
> - Improve DFL framework code and comments to simplify the work for adding
>   a new feature device support.
> - Correct the time in copyright and fix other comments from Alan Tull.
> - Add a entry in MAINTAINERS for this FPGA DFL drivers patchset.
>
> Changes from v4:
> - Update the dfl.txt documentation, remove descriptions for the APIs and
>   features which are not implemented in this patch series.
> - Add DFL_ / dfl_ prefix for APIs and data structure, to avoid directly
>   using fpga_xxx as definition.
> - Use "static region" and "PR bistream" instead of "blue bitstream" and
>   "green bistream" in description to avoid misunderstanding.
> - Fix building issues caused by BIT() on 64bit register definition and
>   missing correct header file for readq and writeq.
> - Remove port specific code in DFL framework and introduce port ops
>   support to resolve the dependency issue between FME driver module and
>   Port driver module. (more details in Patch 8).
> - Add compat id to fpga manager, as in case some hardware implements the
>   compat id in fpga manager's register, not register belongs to fpga region
>   and it's value is shared by all related fpga regions.
> - Pass mapped ioaddr to fme manager platform device from dfl-fme-pr via
>   pdata.
> - Fix other comments from Alan and Moritze, including description
>   improvement, coding style issue and etc.
>
> Changes from v3:
> - Fix SPDX license issue.
> - Rename documentation to dfl.txt, add introduction for Device Feature List
>   (DFL) and re-organize the content.
> - Rename to FPGA Device Feature List (DFL) drivers from Intel FPGA device
>   drivers for better reuse purposes. Unified driver and files to dfl-*.*
> - Remove static feature_info table from common enumeration code and switch
>   to use feature id for sub feature driver matching.
> - Remove next_afu register checking for AFU from common enumeration code.
> - Remove interface_id sysfs for dfl-fme-mgr and use per fpga-region
>   compat_id instead. (new patch 13, 15, 19).
> - Add more comments for driver data structures and functions.
> - Fix typos, issues in debug message/commit message and other places.
>
> Changes from v2:
> - Split common enumeration code from pcie driver to a separated module
>   which for device feature list support.
> - Drop fpga-dev class and switch to use fpga base region as container.
> - Update the intel-fpga.txt documentation for new driver organization.
> - Rename feature device drivers for future code reuse.
> - Rebase code due to fpga APIs changes
> - replace bitfields with marco and shift.
> - fix typos, checkpatch issue and other comments.
>
> Changes from v1:
> - Use GPLv2 license instead of Dual BSD/GPL.
> - Move the code to drivers/fpga folder.
> - Update the intel-fpga.txt documentation for new driver organization.
> - Add documentation for new sysfs interfaces.
> - Switch to use common fpga-region interface for partial reconfiguration
>   (PR) function in FME. It creates fpga-region/fpga-mgr/fpga-bridge
>   platform devices and leave the implementation to their platform drivers.
> - Add platform drivers for FME fpga-mgr/bridge/region platform devices.
> - Fix kbuild warnings, typos and other comments.
>
> Kang Luwei (3):
>   fpga: dfl: add FPGA Management Engine driver basic framework
>   fpga: dfl: fme: add header sub feature support
>   fpga: dfl: fme: add partial reconfiguration sub feature support
>
> Wu Hao (23):
>   docs: fpga: add a document for FPGA Device Feature List (DFL)
>     Framework Overview
>   fpga: mgr: add region_id to fpga_image_info
>   fpga: mgr: add status for fpga-manager
>   fpga: mgr: add compat_id support
>   fpga: region: add compat_id support
>   fpga: add device feature list support
>   fpga: dfl: add chardev support for feature devices
>   fpga: dfl: add dfl_fpga_cdev_find_port
>   fpga: dfl: add dfl_fpga_port_ops support.
>   fpga: dfl: add dfl_fpga_check_port_id function.
>   fpga: dfl-pci: add enumeration for feature devices
>   fpga: dfl: fme: add DFL_FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls
>     support
>   fpga: dfl: add fpga manager platform driver for FME
>   fpga: dfl: fme-mgr: add compat_id support
>   fpga: dfl: add fpga bridge platform driver for FME
>   fpga: dfl: add fpga region platform driver for FME
>   fpga: dfl: fme-region: add support for compat_id
>   fpga: dfl: add FPGA Accelerated Function Unit driver basic framework
>   fpga: dfl: afu: add port ops support
>   fpga: dfl: afu: add header sub feature support
>   fpga: dfl: afu: add DFL_FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls
>     support
>   fpga: dfl: afu: add DFL_FPGA_PORT_DMA_MAP/UNMAP ioctls support
>   MAINTAINERS: add entry for FPGA DFL drivers
>
> Xiao Guangrong (2):
>   fpga: dfl: add feature device infrastructure
>   fpga: dfl: afu: add afu sub feature support
>
> Zhang Yi (1):
>   fpga: add FPGA DFL PCIe device driver
>
>  Documentation/ABI/testing/sysfs-class-fpga-manager |   24 +
>  Documentation/ABI/testing/sysfs-class-fpga-region  |    9 +
>  Documentation/ABI/testing/sysfs-platform-dfl-fme   |   23 +
>  Documentation/ABI/testing/sysfs-platform-dfl-port  |   16 +
>  Documentation/fpga/dfl.txt                         |  285 ++++++
>  Documentation/ioctl/ioctl-number.txt               |    1 +
>  MAINTAINERS                                        |    8 +
>  drivers/fpga/Kconfig                               |   68 ++
>  drivers/fpga/Makefile                              |   14 +
>  drivers/fpga/dfl-afu-dma-region.c                  |  463 +++++++++
>  drivers/fpga/dfl-afu-main.c                        |  636 ++++++++++++
>  drivers/fpga/dfl-afu-region.c                      |  166 ++++
>  drivers/fpga/dfl-afu.h                             |  100 ++
>  drivers/fpga/dfl-fme-br.c                          |  114 +++
>  drivers/fpga/dfl-fme-main.c                        |  279 ++++++
>  drivers/fpga/dfl-fme-mgr.c                         |  349 +++++++
>  drivers/fpga/dfl-fme-pr.c                          |  479 +++++++++
>  drivers/fpga/dfl-fme-pr.h                          |   84 ++
>  drivers/fpga/dfl-fme-region.c                      |   89 ++
>  drivers/fpga/dfl-fme.h                             |   38 +
>  drivers/fpga/dfl-pci.c                             |  243 +++++
>  drivers/fpga/dfl.c                                 | 1044 ++++++++++++++++++++
>  drivers/fpga/dfl.h                                 |  410 ++++++++
>  drivers/fpga/fpga-mgr.c                            |   28 +
>  drivers/fpga/fpga-region.c                         |   22 +
>  include/linux/fpga/fpga-mgr.h                      |   24 +
>  include/linux/fpga/fpga-region.h                   |    2 +
>  include/uapi/linux/fpga-dfl.h                      |  179 ++++
>  28 files changed, 5197 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-region
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-dfl-fme
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-dfl-port
>  create mode 100644 Documentation/fpga/dfl.txt
>  create mode 100644 drivers/fpga/dfl-afu-dma-region.c
>  create mode 100644 drivers/fpga/dfl-afu-main.c
>  create mode 100644 drivers/fpga/dfl-afu-region.c
>  create mode 100644 drivers/fpga/dfl-afu.h
>  create mode 100644 drivers/fpga/dfl-fme-br.c
>  create mode 100644 drivers/fpga/dfl-fme-main.c
>  create mode 100644 drivers/fpga/dfl-fme-mgr.c
>  create mode 100644 drivers/fpga/dfl-fme-pr.c
>  create mode 100644 drivers/fpga/dfl-fme-pr.h
>  create mode 100644 drivers/fpga/dfl-fme-region.c
>  create mode 100644 drivers/fpga/dfl-fme.h
>  create mode 100644 drivers/fpga/dfl-pci.c
>  create mode 100644 drivers/fpga/dfl.c
>  create mode 100644 drivers/fpga/dfl.h
>  create mode 100644 include/uapi/linux/fpga-dfl.h
>
> --
> 1.8.3.1
>
