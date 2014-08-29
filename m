From: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Subject: [PATCH 00/13] powerpc/iommu/vfio: Enable Dynamic DMA windows
Date: Fri, 29 Aug 2014 17:59:03 +1000
Message-ID: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cbe-oss-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This enables PAPR defined feature called Dynamic DMA windows (DDW).

Each Partitionable Endpoint (IOMMU group) has a separate DMA window on
a PCI bus where devices are allows to perform DMA. By default there is
1 or 2GB window allocated at the host boot time and these windows are
used when an IOMMU group is passed to the userspace (guest). These windows
are mapped at zero offset on a PCI bus.

Hi-speed devices may suffer from limited size of this window. On the host
side a TCE bypass mode is enabled on POWER8 CPU which implements
direct mapping of the host memory to a PCI bus at 1<<59.

For the guest, PAPR defines a DDW RTAS API which allows the pseries guest
to query the hypervisor if it supports DDW and what are the parameters
of possible windows.

Currently POWER8 supports 2 DMA windows per PE - already mentioned and used
small 32bit window and 64bit window which can only start from 1<<59 and
can support various page sizes.

This patchset reworks PPC IOMMU code and adds necessary structures
to extend it to support big windows.

When the guest detectes the feature and the PE is capable of 64bit DMA,
it does:
1. query to hypervisor about number of available windows and page masks;
2. creates a window with the biggest possible page size (current guests can do
64K or 16MB TCEs);
3. maps the entire guest RAM via H_PUT_TCE* hypercalls
4. switches dma_ops to direct_dma_ops on the selected PE.

Once this is done, H_PUT_TCE is not called anymore and the guest gets
maximum performance.


Please comment. Thanks!


Alexey Kardashevskiy (13):
  powerpc/iommu: Check that TCE page size is equal to it_page_size
  powerpc/powernv: Make invalidate() a callback
  powerpc/spapr: vfio: Implement spapr_tce_iommu_ops
  powerpc/powernv: Convert/move set_bypass() callback to
    take_ownership()
  powerpc/iommu: Fix IOMMU ownership control functions
  powerpc/iommu: Move tce_xxx callbacks from ppc_md to iommu_table
  powerpc/powernv: Do not set "read" flag if direction==DMA_NONE
  powerpc/powernv: Release replaced TCE
  powerpc/pseries/lpar: Enable VFIO
  powerpc/powernv: Implement Dynamic DMA windows (DDW) for IODA
  vfio: powerpc/spapr: Move locked_vm accounting to helpers
  vfio: powerpc/spapr: Use it_page_size
  vfio: powerpc/spapr: Enable Dynamic DMA windows

 arch/powerpc/include/asm/iommu.h            |  35 ++-
 arch/powerpc/include/asm/machdep.h          |  25 --
 arch/powerpc/include/asm/tce.h              |  37 +++
 arch/powerpc/kernel/iommu.c                 | 213 +++++++++------
 arch/powerpc/kernel/vio.c                   |   5 +-
 arch/powerpc/platforms/cell/iommu.c         |   9 +-
 arch/powerpc/platforms/pasemi/iommu.c       |   8 +-
 arch/powerpc/platforms/powernv/pci-ioda.c   | 233 +++++++++++++++--
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |   4 +-
 arch/powerpc/platforms/powernv/pci.c        | 113 +++++---
 arch/powerpc/platforms/powernv/pci.h        |  15 +-
 arch/powerpc/platforms/pseries/iommu.c      |  77 ++++--
 arch/powerpc/sysdev/dart_iommu.c            |  13 +-
 drivers/vfio/vfio_iommu_spapr_tce.c         | 384 +++++++++++++++++++++++-----
 include/uapi/linux/vfio.h                   |  25 +-
 15 files changed, 925 insertions(+), 271 deletions(-)

-- 
2.0.0
