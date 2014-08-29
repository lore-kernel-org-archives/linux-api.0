From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 13/13] vfio: powerpc/spapr: Enable Dynamic DMA windows
Date: Fri, 29 Aug 2014 17:59:16 +1000
Message-ID: <1409299156-618-14-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Alex Williamson <alex.williamson@redhat.com>, Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This defines and implements VFIO IOMMU API which lets the userspace
create and remove DMA windows.

This updates VFIO_IOMMU_SPAPR_TCE_GET_INFO to return the number of
available windows and page mask.

This adds VFIO_IOMMU_SPAPR_TCE_CREATE and VFIO_IOMMU_SPAPR_TCE_REMOVE
to allow the user space to create and remove window(s).

The VFIO IOMMU driver does basic sanity checks and calls corresponding
SPAPR TCE functions. At the moment only IODA2 (POWER8 PCI host bridge)
implements them.

This advertises VFIO_IOMMU_SPAPR_TCE_FLAG_DDW capability via
VFIO_IOMMU_SPAPR_TCE_GET_INFO.

This calls platform DDW reset() callback when IOMMU is being disabled
to reset the DMA configuration to its original state.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 135 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h           |  25 ++++++-
 2 files changed, 153 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 0dccbc4..b518891 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -190,18 +190,25 @@ static void tce_iommu_disable(struct tce_container *container)
 
 	container->enabled = false;
 
-	if (!container->grp || !current->mm)
+	if (!container->grp)
 		return;
 
 	data = iommu_group_get_iommudata(container->grp);
 	if (!data || !data->iommu_owner || !data->ops->get_table)
 		return;
 
-	tbl = data->ops->get_table(data, 0);
-	if (!tbl)
-		return;
+	if (current->mm) {
+		tbl = data->ops->get_table(data, 0);
+		if (tbl)
+			decrement_locked_vm(tbl);
 
-	decrement_locked_vm(tbl);
+		tbl = data->ops->get_table(data, 1);
+		if (tbl)
+			decrement_locked_vm(tbl);
+	}
+
+	if (data->ops->reset)
+		data->ops->reset(data);
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -243,7 +250,7 @@ static long tce_iommu_ioctl(void *iommu_data,
 				 unsigned int cmd, unsigned long arg)
 {
 	struct tce_container *container = iommu_data;
-	unsigned long minsz;
+	unsigned long minsz, ddwsz;
 	long ret;
 
 	switch (cmd) {
@@ -288,6 +295,28 @@ static long tce_iommu_ioctl(void *iommu_data,
 		info.dma32_window_size = tbl->it_size << tbl->it_page_shift;
 		info.flags = 0;
 
+		ddwsz = offsetofend(struct vfio_iommu_spapr_tce_info,
+				page_size_mask);
+
+		if (info.argsz == ddwsz) {
+			if (data->ops->query && data->ops->create &&
+					data->ops->remove) {
+				info.flags |= VFIO_IOMMU_SPAPR_TCE_FLAG_DDW;
+
+				ret = data->ops->query(data,
+						&info.current_windows,
+						&info.windows_available,
+						&info.page_size_mask);
+				if (ret)
+					return ret;
+			} else {
+				info.current_windows = 0;
+				info.windows_available = 0;
+				info.page_size_mask = 0;
+			}
+			minsz = ddwsz;
+		}
+
 		if (copy_to_user((void __user *)arg, &info, minsz))
 			return -EFAULT;
 
@@ -412,12 +441,106 @@ static long tce_iommu_ioctl(void *iommu_data,
 		tce_iommu_disable(container);
 		mutex_unlock(&container->lock);
 		return 0;
+
 	case VFIO_EEH_PE_OP:
 		if (!container->grp)
 			return -ENODEV;
 
 		return vfio_spapr_iommu_eeh_ioctl(container->grp,
 						  cmd, arg);
+
+	case VFIO_IOMMU_SPAPR_TCE_CREATE: {
+		struct vfio_iommu_spapr_tce_create create;
+		struct spapr_tce_iommu_group *data;
+		struct iommu_table *tbl;
+
+		if (WARN_ON(!container->grp))
+			return -ENXIO;
+
+		data = iommu_group_get_iommudata(container->grp);
+
+		minsz = offsetofend(struct vfio_iommu_spapr_tce_create,
+				start_addr);
+
+		if (copy_from_user(&create, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (create.argsz < minsz)
+			return -EINVAL;
+
+		if (create.flags)
+			return -EINVAL;
+
+		if (!data->ops->create || !data->iommu_owner)
+			return -ENOSYS;
+
+		BUG_ON(!data || !data->ops || !data->ops->remove);
+
+		ret = data->ops->create(data, create.page_shift,
+				create.window_shift, &tbl);
+		if (ret)
+			return ret;
+
+		ret = try_increment_locked_vm(tbl);
+		if (ret) {
+			data->ops->remove(data, tbl);
+			return ret;
+		}
+
+		create.start_addr = tbl->it_offset << tbl->it_page_shift;
+
+		if (copy_to_user((void __user *)arg, &create, minsz)) {
+			data->ops->remove(data, tbl);
+			decrement_locked_vm(tbl);
+			return -EFAULT;
+		}
+		mutex_lock(&container->lock);
+		++container->windows_num;
+		mutex_unlock(&container->lock);
+
+		return ret;
+	}
+	case VFIO_IOMMU_SPAPR_TCE_REMOVE: {
+		struct vfio_iommu_spapr_tce_remove remove;
+		struct spapr_tce_iommu_group *data;
+		struct iommu_table *tbl;
+
+		if (WARN_ON(!container->grp))
+			return -ENXIO;
+
+		data = iommu_group_get_iommudata(container->grp);
+
+		minsz = offsetofend(struct vfio_iommu_spapr_tce_remove,
+				start_addr);
+
+		if (copy_from_user(&remove, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (remove.argsz < minsz)
+			return -EINVAL;
+
+		if (remove.flags)
+			return -EINVAL;
+
+		if (!data->ops->remove || !data->iommu_owner)
+			return -ENOSYS;
+
+		tbl = spapr_tce_find_table(container, data, remove.start_addr);
+		if (!tbl)
+			return -EINVAL;
+
+		ret = data->ops->remove(data, tbl);
+		if (ret)
+			return ret;
+
+		decrement_locked_vm(tbl);
+
+		mutex_lock(&container->lock);
+		--container->windows_num;
+		mutex_unlock(&container->lock);
+
+		return 0;
+	}
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 6612974..e71a6ef 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -451,9 +451,13 @@ struct vfio_iommu_type1_dma_unmap {
  */
 struct vfio_iommu_spapr_tce_info {
 	__u32 argsz;
-	__u32 flags;			/* reserved for future use */
+	__u32 flags;
+#define VFIO_IOMMU_SPAPR_TCE_FLAG_DDW	1 /* Support dynamic windows */
 	__u32 dma32_window_start;	/* 32 bit window start (bytes) */
 	__u32 dma32_window_size;	/* 32 bit window size (bytes) */
+	__u32 current_windows;
+	__u32 windows_available;
+	__u32 page_size_mask;
 };
 
 #define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
@@ -489,6 +493,25 @@ struct vfio_eeh_pe_op {
 
 #define VFIO_EEH_PE_OP			_IO(VFIO_TYPE, VFIO_BASE + 21)
 
+struct vfio_iommu_spapr_tce_create {
+	__u32 argsz;
+	__u32 flags;
+	/* in */
+	__u32 page_shift;
+	__u32 window_shift;
+	/* out */
+	__u64 start_addr;
+};
+#define VFIO_IOMMU_SPAPR_TCE_CREATE	_IO(VFIO_TYPE, VFIO_BASE + 18)
+
+struct vfio_iommu_spapr_tce_remove {
+	__u32 argsz;
+	__u32 flags;
+	/* in */
+	__u64 start_addr;
+};
+#define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 19)
+
 /* ***************************************************************** */
 
 #endif /* _UAPIVFIO_H */
-- 
2.0.0
