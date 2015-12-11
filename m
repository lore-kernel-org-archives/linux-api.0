From: Yongji Xie <xyjxie@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/3] vfio-pci: Allow to mmap sub-page MMIO BARs if all MMIO BARs are page aligned
Date: Fri, 11 Dec 2015 16:53:13 +0800
Message-ID: <1449823994-3356-3-git-send-email-xyjxie@linux.vnet.ibm.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: aik@ozlabs.ru, alex.williamson@redhat.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, warrier@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com, Yongji Xie <xyjxie@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

Current vfio-pci implementation disallows to mmap
sub-page(size < PAGE_SIZE) MMIO BARs because these BARs' mmio page
may be shared with other BARs.

But we should allow to mmap these sub-page MMIO BARs if all MMIO BARs
are page aligned which leads the BARs' mmio page would not be shared
with other BARs.

This patch adds support for this case and we also add a
VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED flag to notify userspace that
platform supports all MMIO BARs to be page aligned.

Signed-off-by: Yongji Xie <xyjxie@linux.vnet.ibm.com>
---
 drivers/vfio/pci/vfio_pci.c         |   10 +++++++++-
 drivers/vfio/pci/vfio_pci_private.h |    5 +++++
 include/uapi/linux/vfio.h           |    2 ++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 32b88bd..dbcad99 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -443,6 +443,9 @@ static long vfio_pci_ioctl(void *device_data,
 		if (vdev->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
+		if (vfio_pci_bar_page_aligned())
+			info.flags |= VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED;
+
 		info.num_regions = VFIO_PCI_NUM_REGIONS;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
@@ -479,7 +482,8 @@ static long vfio_pci_ioctl(void *device_data,
 				     VFIO_REGION_INFO_FLAG_WRITE;
 			if (IS_ENABLED(CONFIG_VFIO_PCI_MMAP) &&
 			    pci_resource_flags(pdev, info.index) &
-			    IORESOURCE_MEM && info.size >= PAGE_SIZE)
+			    IORESOURCE_MEM && (info.size >= PAGE_SIZE ||
+			    vfio_pci_bar_page_aligned()))
 				info.flags |= VFIO_REGION_INFO_FLAG_MMAP;
 			break;
 		case VFIO_PCI_ROM_REGION_INDEX:
@@ -855,6 +859,10 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	phys_len = pci_resource_len(pdev, index);
+
+	if (vfio_pci_bar_page_aligned())
+		phys_len = PAGE_ALIGN(phys_len);
+
 	req_len = vma->vm_end - vma->vm_start;
 	pgoff = vma->vm_pgoff &
 		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 0e7394f..319352a 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -69,6 +69,11 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
+static inline bool vfio_pci_bar_page_aligned(void)
+{
+	return IS_ENABLED(CONFIG_PPC64);
+}
+
 extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 751b69f..1fc8066 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -171,6 +171,8 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
 #define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
+/* Platform support all PCI MMIO BARs to be page aligned */
+#define VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED	(1 << 4)
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
1.7.9.5
