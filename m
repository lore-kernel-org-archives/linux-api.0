From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 00/21] api review for libnd (nvdimm sub-system)
Date: Thu, 28 May 2015 20:57:04 -0400
Message-ID: <20150529005536.3482.48349.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patchset has been through a few review cycles on linux-kernel,
linux-acpi, and linux-nvdimm, but Christoph noted [1] that it has not
garnered suitable feedback from linux-api denizens.  In particular the
ioctl implementation in patch5 needs someone skilled at spotting
problematic ioctl formats to take a look.

It is important to note, for an api focused review, that this kernel
sub-system comes with a corresponding userspace api available here:

   https://github.com/pmem/ndctl

libndctl wraps and provides helpers for both ioctl and sysfs entry
points to libnd.  The libndctl api is of course subject to change until
the kernel components are upstream.  Overview documentation for both the
kernel userspace implementations is available in patch21, but feel free
to ping me with questions.  The additional documents at
http://pmem.io/documents/ give backing details and motivations for the
ioctl command set.  In short, the ioctls allow userspace to pass
commands to ACPI _DSMs (device specific methods) for the NVDIMM devices
in a system.  They are primarily used for managing a configuration data
region on each device.  The configuration data region allows for
provisioning media capacity between the BLK and PMEM use cases.

I'm sending this only to linux-api this time around as those other lists
and reviewers already have 4 copies of the patches, and the review
feedback has mostly died off on those threads.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000923.html

Thanks in advance for the review!

---

[RFC PATCH 01/21] e820, efi: add ACPI 6.0 persistent memory types
[RFC PATCH 02/21] libnd, nfit: initial libnd infrastructure and NFIT support
[RFC PATCH 03/21] libnd: control character device and libnd bus sysfs attributes
[RFC PATCH 04/21] libnd, nfit: dimm/memory-devices
[RFC PATCH 05/21] libnd: control (ioctl) messages for libnd bus and dimm devices
[RFC PATCH 06/21] libnd, nd_dimm: dimm driver and base libnd device-driver infrastructure
[RFC PATCH 07/21] libnd, nfit: regions (block-data-window, persistent memory, volatile memory)
[RFC PATCH 08/21] libnd: support for legacy (non-aliasing) nvdimms
[RFC PATCH 09/21] libnd, nd_pmem: add libnd support to the pmem driver
[RFC PATCH 10/21] pmem: Dynamically allocate partition numbers
[RFC PATCH 11/21] libnd, nfit: add interleave-set state-tracking infrastructure
[RFC PATCH 12/21] libnd: namespace indices: read and validate
[RFC PATCH 13/21] libnd: pmem label sets and namespace instantiation.
[RFC PATCH 14/21] libnd: blk labels and namespace instantiation
[RFC PATCH 15/21] libnd: write pmem label set
[RFC PATCH 16/21] libnd: write blk label set
[RFC PATCH 17/21] libnd: infrastructure for btt devices
[RFC PATCH 18/21] nd_btt: atomic sector updates
[RFC PATCH 19/21] libnd, nfit, nd_blk: driver for BLK-mode access persistent memory
[RFC PATCH 20/21] nfit-test: manufactured NFITs for interface development
[RFC PATCH 21/21] libnd: Non-Volatile Devices

 Documentation/blockdev/btt.txt    |  273 ++++++
 Documentation/blockdev/libnd.txt  |  804 +++++++++++++++++
 MAINTAINERS                       |   39 +
 arch/arm64/kernel/efi.c           |    1 
 arch/ia64/kernel/efi.c            |    4 
 arch/x86/Kconfig                  |    4 
 arch/x86/boot/compressed/eboot.c  |    4 
 arch/x86/include/uapi/asm/e820.h  |    1 
 arch/x86/kernel/e820.c            |   28 +
 arch/x86/kernel/pmem.c            |   92 +-
 arch/x86/platform/efi/efi.c       |    3 
 drivers/acpi/Kconfig              |   27 +
 drivers/acpi/Makefile             |    1 
 drivers/acpi/nfit.c               | 1474 ++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h               |  163 ++++
 drivers/block/Kconfig             |   13 
 drivers/block/Makefile            |    2 
 drivers/block/nd/Kconfig          |  101 ++
 drivers/block/nd/Makefile         |   29 +
 drivers/block/nd/blk.c            |  252 +++++
 drivers/block/nd/btt.c            | 1438 +++++++++++++++++++++++++++++++
 drivers/block/nd/btt.h            |  186 ++++
 drivers/block/nd/btt_devs.c       |  443 ++++++++++
 drivers/block/nd/bus.c            |  770 +++++++++++++++++
 drivers/block/nd/core.c           |  472 ++++++++++
 drivers/block/nd/dimm.c           |  115 +++
 drivers/block/nd/dimm_devs.c      |  516 +++++++++++
 drivers/block/nd/label.c          |  922 ++++++++++++++++++++
 drivers/block/nd/label.h          |  143 +++
 drivers/block/nd/namespace_devs.c | 1702 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h     |  111 ++
 drivers/block/nd/nd.h             |  257 ++++++
 drivers/block/nd/pmem.c           |  107 ++
 drivers/block/nd/region.c         |  189 ++++
 drivers/block/nd/region_devs.c    |  667 +++++++++++++++
 drivers/block/nd/test/Makefile    |    5 
 drivers/block/nd/test/iomap.c     |  151 +++
 drivers/block/nd/test/nfit.c      | 1171 +++++++++++++++++++++++++
 drivers/block/nd/test/nfit_test.h |   28 +
 include/linux/efi.h               |    3 
 include/linux/libnd.h             |  129 +++
 include/linux/nd.h                |   98 ++
 include/uapi/linux/Kbuild         |    1 
 include/uapi/linux/ndctl.h        |  199 ++++
 44 files changed, 13049 insertions(+), 89 deletions(-)
 create mode 100644 Documentation/blockdev/btt.txt
 create mode 100644 Documentation/blockdev/libnd.txt
 create mode 100644 drivers/acpi/nfit.c
 create mode 100644 drivers/acpi/nfit.h
 create mode 100644 drivers/block/nd/Kconfig
 create mode 100644 drivers/block/nd/Makefile
 create mode 100644 drivers/block/nd/blk.c
 create mode 100644 drivers/block/nd/btt.c
 create mode 100644 drivers/block/nd/btt.h
 create mode 100644 drivers/block/nd/btt_devs.c
 create mode 100644 drivers/block/nd/bus.c
 create mode 100644 drivers/block/nd/core.c
 create mode 100644 drivers/block/nd/dimm.c
 create mode 100644 drivers/block/nd/dimm_devs.c
 create mode 100644 drivers/block/nd/label.c
 create mode 100644 drivers/block/nd/label.h
 create mode 100644 drivers/block/nd/namespace_devs.c
 create mode 100644 drivers/block/nd/nd-private.h
 create mode 100644 drivers/block/nd/nd.h
 rename drivers/block/{pmem.c => nd/pmem.c} (70%)
 create mode 100644 drivers/block/nd/region.c
 create mode 100644 drivers/block/nd/region_devs.c
 create mode 100644 drivers/block/nd/test/Makefile
 create mode 100644 drivers/block/nd/test/iomap.c
 create mode 100644 drivers/block/nd/test/nfit.c
 create mode 100644 drivers/block/nd/test/nfit_test.h
 create mode 100644 include/linux/libnd.h
 create mode 100644 include/linux/nd.h
 create mode 100644 include/uapi/linux/ndctl.h
