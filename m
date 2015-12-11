From: Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC PATCH 0/3] vfio-pci: Allow to mmap sub-page MMIO BARs and MSI-X table on PPC64 platform
Date: Fri, 11 Dec 2015 16:53:11 +0800
Message-ID: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Current vfio-pci implementation disallows to mmap
sub-page(size < PAGE_SIZE) MMIO BARs and MSI-X table. This is because
sub-page BARs' mmio page may be shared with other BARs and MSI-X table
should not be accessed directly from the guest for security reasons.

But these would cause some performance issues for mmio accesses in guest
when vfio passthrough sub-page BARs or BARs containing MSI-X table on
PPC64 platform. This is because PAGE_SIZE is 64KB by default on PPC64
platform and the big page may easily hit the sub-page MMIO
BARs' unmmapping and cause the unmmaping of the mmio page which
MSI-X table locate in, which lead to mmio emulation in host.

For sub-page MMIO BARs' unmmapping, this patch set enforces all MMIO
BARs to be page aligned on PPC64 platform so that sub-page BAR's mmio
page would not be shared with other BARs. Then we can mmap sub-page
MMIO BARs in vfio-pci driver if all MMIO BARs are page aligned.

For MSI-X table's unmmapping, we think MSI-X table is safe to access
directly from the guest with EEH mechanism enabled which can ensure that
a given pci device can only shoot the MSIs assigned for its PE. So
we add support for mmapping MSI-X table in vfio-pci driver if EEH is
supported.

With this patch set applied, we can get almost 100% improvement on
performance for mmio accesses when we passthrough sub-page BARs in
our test.

The last two patches in the patch set can be used by qemu to:
	- Add support for a VFIO-PCI ioctl to indicate that platform
	  support all PCI BARs are page aligned.
	- Add support for a VFIO-PCI ioctl to indicate that platform
	  support mmapping MSI-X table.

Yongji Xie (3):
  powerpc/pci: Enforce all MMIO BARs to be page aligned
  vfio-pci: Allow to mmap sub-page MMIO BARs if all MMIO BARs are page aligned
  vfio-pci: Allow to mmap MSI-X table if EEH is supported

 arch/powerpc/kernel/pci-common.c    |   10 +++++++++-
 drivers/vfio/pci/vfio_pci.c         |   15 +++++++++++++--
 drivers/vfio/pci/vfio_pci_private.h |   10 ++++++++++
 include/uapi/linux/vfio.h           |    4 ++++
 4 files changed, 36 insertions(+), 3 deletions(-)

-- 
1.7.9.5
