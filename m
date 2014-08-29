From: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Subject: [PATCH 08/13] powerpc/powernv: Release replaced TCE
Date: Fri, 29 Aug 2014 17:59:11 +1000
Message-ID: <1409299156-618-9-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cbe-oss-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

At the moment writing new TCE value to the IOMMU table fails with EBUSY
if there is a valid entry already. However PAPR specification allows
the guest to write new TCE value without clearing it first.

Another problem this patch is addressing is the use of pool locks for
external IOMMU users such as VFIO. The pool locks are to protect
DMA page allocator rather than entries and since the host kernel does
not control what pages are in use, there is no point in pool locks and
exchange()+put_page(oldtce) is sufficient to avoid possible races.

This adds an exchange() callback to iommu_table_ops which does the same
thing as set() plus it returns replaced TCE(s) so the caller can release
the pages afterwards.

This makes iommu_tce_build() put pages returned by exchange().

This replaces iommu_clear_tce() with iommu_tce_build which now
can call exchange() with TCE==NULL (i.e. clear).

This preserves permission bits in TCE in iommu_put_tce_user_mode().

This removes use of pool locks for external IOMMU uses.

This disables external IOMMU use (i.e. VFIO) for IOMMUs which do not
implement exchange() callback. Therefore the "powernv" platform is
the only supported one after this patch.

Signed-off-by: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
---
 arch/powerpc/include/asm/iommu.h     |  8 +++--
 arch/powerpc/kernel/iommu.c          | 62 ++++++++++++------------------------
 arch/powerpc/platforms/powernv/pci.c | 40 +++++++++++++++++++++++
 3 files changed, 67 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index c725e4a..8e0537d 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -49,6 +49,12 @@ struct iommu_table_ops {
 			unsigned long uaddr,
 			enum dma_data_direction direction,
 			struct dma_attrs *attrs);
+	int (*exchange)(struct iommu_table *tbl,
+			long index, long npages,
+			unsigned long uaddr,
+			unsigned long *old_tces,
+			enum dma_data_direction direction,
+			struct dma_attrs *attrs);
 	void (*clear)(struct iommu_table *tbl,
 			long index, long npages);
 	unsigned long (*get)(struct iommu_table *tbl, long index);
@@ -209,8 +215,6 @@ extern int iommu_tce_put_param_check(struct iommu_table *tbl,
 		unsigned long ioba, unsigned long tce);
 extern int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
 		unsigned long hwaddr, enum dma_data_direction direction);
-extern unsigned long iommu_clear_tce(struct iommu_table *tbl,
-		unsigned long entry);
 extern int iommu_clear_tces_and_put_pages(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
 extern int iommu_put_tce_user_mode(struct iommu_table *tbl,
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 678fee8..39ccce7 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1006,43 +1006,11 @@ int iommu_tce_put_param_check(struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_put_param_check);
 
-unsigned long iommu_clear_tce(struct iommu_table *tbl, unsigned long entry)
-{
-	unsigned long oldtce;
-	struct iommu_pool *pool = get_pool(tbl, entry);
-
-	spin_lock(&(pool->lock));
-
-	oldtce = tbl->it_ops->get(tbl, entry);
-	if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ))
-		tbl->it_ops->clear(tbl, entry, 1);
-	else
-		oldtce = 0;
-
-	spin_unlock(&(pool->lock));
-
-	return oldtce;
-}
-EXPORT_SYMBOL_GPL(iommu_clear_tce);
-
 int iommu_clear_tces_and_put_pages(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages)
 {
-	unsigned long oldtce;
-	struct page *page;
-
 	for ( ; pages; --pages, ++entry) {
-		oldtce = iommu_clear_tce(tbl, entry);
-		if (!oldtce)
-			continue;
-
-		page = pfn_to_page(oldtce >> PAGE_SHIFT);
-		WARN_ON(!page);
-		if (page) {
-			if (oldtce & TCE_PCI_WRITE)
-				SetPageDirty(page);
-			put_page(page);
-		}
+		iommu_tce_build(tbl, entry, 0, DMA_NONE);
 	}
 
 	return 0;
@@ -1056,18 +1024,19 @@ EXPORT_SYMBOL_GPL(iommu_clear_tces_and_put_pages);
 int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
 		unsigned long hwaddr, enum dma_data_direction direction)
 {
-	int ret = -EBUSY;
+	int ret;
 	unsigned long oldtce;
-	struct iommu_pool *pool = get_pool(tbl, entry);
 
-	spin_lock(&(pool->lock));
+	ret = tbl->it_ops->exchange(tbl, entry, 1, hwaddr, &oldtce,
+			direction, NULL);
 
-	oldtce = tbl->it_ops->get(tbl, entry);
-	/* Add new entry if it is not busy */
-	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
-		ret = tbl->it_ops->set(tbl, entry, 1, hwaddr, direction, NULL);
+	if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)) {
+		struct page *pg = pfn_to_page(__pa(oldtce) >> PAGE_SHIFT);
 
-	spin_unlock(&(pool->lock));
+		if (oldtce & TCE_PCI_WRITE)
+			SetPageDirty(pg);
+		put_page(pg);
+	}
 
 	/* if (unlikely(ret))
 		pr_err("iommu_tce: %s failed on hwaddr=%lx ioba=%lx kva=%lx ret=%d\n",
@@ -1111,6 +1080,7 @@ int iommu_put_tce_user_mode(struct iommu_table *tbl, unsigned long entry,
 	}
 
 	hwaddr = (unsigned long) page_address(page) + offset;
+	hwaddr |= tce & (TCE_PCI_READ | TCE_PCI_WRITE);
 
 	ret = iommu_tce_build(tbl, entry, hwaddr, direction);
 	if (ret)
@@ -1133,6 +1103,16 @@ int iommu_take_ownership(struct iommu_table *tbl)
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
 	int ret = 0, bit0 = 0;
 
+	/*
+	 * VFIO does not control TCE entries allocation and the guest
+	 * can write new TCEs on top of existing ones so iommu_tce_build()
+	 * must be able to release old pages. This functionality
+	 * requires exchange() callback defined so if it is not
+	 * implemented, we disallow taking ownership over the table.
+	 */
+	if (!tbl->it_ops->exchange)
+		return -EINVAL;
+
 	spin_lock_irqsave(&tbl->large_pool.lock, flags);
 	for (i = 0; i < tbl->nr_pools; i++)
 		spin_lock(&tbl->pools[i].lock);
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index ab79e2d..fd1ecc8 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -662,6 +662,45 @@ static int pnv_tce_build_vm(struct iommu_table *tbl, long index, long npages,
 			false);
 }
 
+static int pnv_tce_xchg_vm(struct iommu_table *tbl, long index,
+			   long npages,
+			   unsigned long uaddr, unsigned long *old_tces,
+			   enum dma_data_direction direction,
+			   struct dma_attrs *attrs)
+{
+	u64 rpn, proto_tce;
+	__be64 *tcep, *tces;
+	long i;
+
+	switch (direction) {
+	case DMA_BIDIRECTIONAL:
+	case DMA_FROM_DEVICE:
+		proto_tce = TCE_PCI_READ | TCE_PCI_WRITE;
+		break;
+	case DMA_TO_DEVICE:
+		proto_tce = TCE_PCI_READ;
+		break;
+	default:
+		proto_tce = 0;
+		break;
+	}
+
+	tces = tcep = ((__be64 *)tbl->it_base) + index - tbl->it_offset;
+	rpn = __pa(uaddr) >> tbl->it_page_shift;
+
+	for (i = 0; i < npages; i++) {
+		unsigned long oldtce = xchg(tcep, cpu_to_be64(proto_tce |
+				(rpn++ << tbl->it_page_shift)));
+
+		old_tces[i] = (unsigned long) __va(oldtce);
+		tcep++;
+	}
+
+	pnv_tce_invalidate(tbl, tces, tcep - 1, false);
+
+	return 0;
+}
+
 static void pnv_tce_free(struct iommu_table *tbl, long index, long npages,
 		bool rm)
 {
@@ -687,6 +726,7 @@ static unsigned long pnv_tce_get(struct iommu_table *tbl, long index)
 
 struct iommu_table_ops pnv_iommu_ops = {
 	.set = pnv_tce_build_vm,
+	.exchange = pnv_tce_xchg_vm,
 	.clear = pnv_tce_free_vm,
 	.get = pnv_tce_get,
 };
-- 
2.0.0
