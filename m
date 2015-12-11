From: Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC PATCH 3/3] vfio-pci: Allow to mmap MSI-X table if EEH is supported
Date: Fri, 11 Dec 2015 16:53:14 +0800
Message-ID: <1449823994-3356-4-git-send-email-xyjxie@linux.vnet.ibm.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449823994-3356-1-git-send-email-xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Current vfio-pci implementation disallows to mmap MSI-X table in
case that user get to touch this directly.

However, EEH mechanism could ensure that a given pci device
can only shoot the MSIs assigned for its PE and guest kernel also
would not write to MSI-X table in pci_enable_msix() because
para-virtualization on PPC64 platform. So MSI-X table is safe to
access directly from the guest with EEH mechanism enabled.

This patch adds support for this case and allow to mmap MSI-X
table if EEH is supported on PPC64 platform.

And we also add a VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP flag to notify
userspace that it's safe to mmap MSI-X table.

Signed-off-by: Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/vfio/pci/vfio_pci.c         |    5 ++++-
 drivers/vfio/pci/vfio_pci_private.h |    5 +++++
 include/uapi/linux/vfio.h           |    2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index dbcad99..85d9980 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -446,6 +446,9 @@ static long vfio_pci_ioctl(void *device_data,
 		if (vfio_pci_bar_page_aligned())
 			info.flags |= VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED;
 
+		if (vfio_msix_table_mmap_enabled())
+			info.flags |= VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP;
+
 		info.num_regions = VFIO_PCI_NUM_REGIONS;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
@@ -871,7 +874,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	if (phys_len < PAGE_SIZE || req_start + req_len > phys_len)
 		return -EINVAL;
 
-	if (index == vdev->msix_bar) {
+	if (index == vdev->msix_bar && !vfio_msix_table_mmap_enabled()) {
 		/*
 		 * Disallow mmaps overlapping the MSI-X table; users don't
 		 * get to touch this directly.  We could find somewhere
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 319352a..835619e 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -74,6 +74,11 @@ static inline bool vfio_pci_bar_page_aligned(void)
 	return IS_ENABLED(CONFIG_PPC64);
 }
 
+static inline bool vfio_msix_table_mmap_enabled(void)
+{
+	return IS_ENABLED(CONFIG_EEH);
+}
+
 extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 1fc8066..289e662 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -173,6 +173,8 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 /* Platform support all PCI MMIO BARs to be page aligned */
 #define VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED	(1 << 4)
+/* Platform support mmapping PCI MSI-X vector table */
+#define VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP	(1 << 5)
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
1.7.9.5
