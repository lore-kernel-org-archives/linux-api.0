From: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Subject: [PATCH 12/13] vfio: powerpc/spapr: Use it_page_size
Date: Fri, 29 Aug 2014 17:59:15 +1000
Message-ID: <1409299156-618-13-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cbe-oss-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This makes use of the it_page_size from the iommu_table struct
as page size can differ.

This replaces missing IOMMU_PAGE_SHIFT macro in commented debug code
as recently introduced IOMMU_PAGE_XXX macros do not include
IOMMU_PAGE_SHIFT.

Signed-off-by: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index c9fac97..0dccbc4 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -36,7 +36,7 @@ static long try_increment_locked_vm(struct iommu_table *tbl)
 	if (!current || !current->mm)
 		return -ESRCH; /* process exited */
 
-	npages = (tbl->it_size << IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
+	npages = (tbl->it_size << tbl->it_page_shift) >> PAGE_SHIFT;
 
 	down_write(&current->mm->mmap_sem);
 	locked = current->mm->locked_vm + npages;
@@ -60,7 +60,7 @@ static void decrement_locked_vm(struct iommu_table *tbl)
 	if (!current || !current->mm)
 		return; /* process exited */
 
-	npages = (tbl->it_size << IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
+	npages = (tbl->it_size << tbl->it_page_shift) >> PAGE_SHIFT;
 
 	down_write(&current->mm->mmap_sem);
 	if (npages > current->mm->locked_vm)
@@ -284,8 +284,8 @@ static long tce_iommu_ioctl(void *iommu_data,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		info.dma32_window_start = tbl->it_offset << IOMMU_PAGE_SHIFT_4K;
-		info.dma32_window_size = tbl->it_size << IOMMU_PAGE_SHIFT_4K;
+		info.dma32_window_start = tbl->it_offset << tbl->it_page_shift;
+		info.dma32_window_size = tbl->it_size << tbl->it_page_shift;
 		info.flags = 0;
 
 		if (copy_to_user((void __user *)arg, &info, minsz))
@@ -318,10 +318,6 @@ static long tce_iommu_ioctl(void *iommu_data,
 				VFIO_DMA_MAP_FLAG_WRITE))
 			return -EINVAL;
 
-		if ((param.size & ~IOMMU_PAGE_MASK_4K) ||
-				(param.vaddr & ~IOMMU_PAGE_MASK_4K))
-			return -EINVAL;
-
 		/* iova is checked by the IOMMU API */
 		tce = param.vaddr;
 		if (param.flags & VFIO_DMA_MAP_FLAG_READ)
@@ -334,21 +330,25 @@ static long tce_iommu_ioctl(void *iommu_data,
 			return -ENXIO;
 		BUG_ON(!tbl->it_group);
 
+		if ((param.size & ~IOMMU_PAGE_MASK(tbl)) ||
+				(param.vaddr & ~IOMMU_PAGE_MASK(tbl)))
+			return -EINVAL;
+
 		ret = iommu_tce_put_param_check(tbl, param.iova, tce);
 		if (ret)
 			return ret;
 
-		for (i = 0; i < (param.size >> IOMMU_PAGE_SHIFT_4K); ++i) {
+		for (i = 0; i < (param.size >> tbl->it_page_shift); ++i) {
 			ret = iommu_put_tce_user_mode(tbl,
-					(param.iova >> IOMMU_PAGE_SHIFT_4K) + i,
+					(param.iova >> tbl->it_page_shift) + i,
 					tce);
 			if (ret)
 				break;
-			tce += IOMMU_PAGE_SIZE_4K;
+			tce += IOMMU_PAGE_SIZE(tbl);
 		}
 		if (ret)
 			iommu_clear_tces_and_put_pages(tbl,
-					param.iova >> IOMMU_PAGE_SHIFT_4K, i);
+					param.iova >> tbl->it_page_shift, i);
 
 		iommu_flush_tce(tbl);
 
@@ -379,23 +379,23 @@ static long tce_iommu_ioctl(void *iommu_data,
 		if (param.flags)
 			return -EINVAL;
 
-		if (param.size & ~IOMMU_PAGE_MASK_4K)
-			return -EINVAL;
-
 		tbl = spapr_tce_find_table(container, data, param.iova);
 		if (!tbl)
 			return -ENXIO;
 
+		if (param.size & ~IOMMU_PAGE_MASK(tbl))
+			return -EINVAL;
+
 		BUG_ON(!tbl->it_group);
 
 		ret = iommu_tce_clear_param_check(tbl, param.iova, 0,
-				param.size >> IOMMU_PAGE_SHIFT_4K);
+				param.size >> tbl->it_page_shift);
 		if (ret)
 			return ret;
 
 		ret = iommu_clear_tces_and_put_pages(tbl,
-				param.iova >> IOMMU_PAGE_SHIFT_4K,
-				param.size >> IOMMU_PAGE_SHIFT_4K);
+				param.iova >> tbl->it_page_shift,
+				param.size >> tbl->it_page_shift);
 		iommu_flush_tce(tbl);
 
 		return ret;
-- 
2.0.0
