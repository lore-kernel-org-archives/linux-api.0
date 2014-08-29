From: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Subject: [PATCH 06/13] powerpc/iommu: Move tce_xxx callbacks from ppc_md to iommu_table
Date: Fri, 29 Aug 2014 17:59:09 +1000
Message-ID: <1409299156-618-7-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cbe-oss-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This adds a iommu_table_ops struct and puts pointer to it into
the iommu_table struct. This moves tce_build/tce_free/tce_get/tce_flush
callbacks from ppc_md to the new struct where they really belong to.

This adds an extra @ops parameter to iommu_init_table() to make sure
that we do not leave any IOMMU table without iommu_table_ops. @it_ops is
initialized in the very beginning as iommu_init_table() calls
iommu_table_clear() and the latter uses callbacks already.

This does s/tce_build/set/, s/tce_free/clear/ and removes "tce_" prefixes
for better readability.

This removes tce_xxx_rm handlers from ppc_md as well but does not add
them to iommu_table_ops, this will be done later if we decide to support
TCE hypercalls in real mode.

This always uses tce_buildmulti_pSeriesLP/tce_buildmulti_pSeriesLP as
callbacks for pseries. This changes "multi" callbacks to fall back to
tce_build_pSeriesLP/tce_free_pSeriesLP if FW_FEATURE_MULTITCE is not
present. The reason for this is we still have to support "multitce=off"
boot parameter in disable_multitce() and we do not want to walk through
all IOMMU tables in the system and replace "multi" callbacks with single
ones.

Signed-off-by: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
---
 arch/powerpc/include/asm/iommu.h            | 20 +++++++++++-
 arch/powerpc/include/asm/machdep.h          | 25 ---------------
 arch/powerpc/kernel/iommu.c                 | 50 ++++++++++++++++-------------
 arch/powerpc/kernel/vio.c                   |  5 ++-
 arch/powerpc/platforms/cell/iommu.c         |  9 ++++--
 arch/powerpc/platforms/pasemi/iommu.c       |  8 +++--
 arch/powerpc/platforms/powernv/pci-ioda.c   |  4 +--
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  3 +-
 arch/powerpc/platforms/powernv/pci.c        | 24 ++++----------
 arch/powerpc/platforms/powernv/pci.h        |  1 +
 arch/powerpc/platforms/pseries/iommu.c      | 42 +++++++++++++-----------
 arch/powerpc/sysdev/dart_iommu.c            | 13 ++++----
 12 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 2b0b01d..c725e4a 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -43,6 +43,22 @@
 extern int iommu_is_off;
 extern int iommu_force_on;
 
+struct iommu_table_ops {
+	int (*set)(struct iommu_table *tbl,
+			long index, long npages,
+			unsigned long uaddr,
+			enum dma_data_direction direction,
+			struct dma_attrs *attrs);
+	void (*clear)(struct iommu_table *tbl,
+			long index, long npages);
+	unsigned long (*get)(struct iommu_table *tbl, long index);
+	void (*flush)(struct iommu_table *tbl);
+};
+
+/* These are used by VIO */
+extern struct iommu_table_ops iommu_table_lpar_multi_ops;
+extern struct iommu_table_ops iommu_table_pseries_ops;
+
 /*
  * IOMAP_MAX_ORDER defines the largest contiguous block
  * of dma space we can get.  IOMAP_MAX_ORDER = 13
@@ -77,6 +93,7 @@ struct iommu_table {
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *it_group;
 #endif
+	struct iommu_table_ops *it_ops;
 };
 
 /* Pure 2^n version of get_order */
@@ -106,7 +123,8 @@ extern void iommu_free_table(struct iommu_table *tbl, const char *node_name);
  * structure
  */
 extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
-					    int nid);
+					    int nid,
+					    struct iommu_table_ops *ops);
 
 struct spapr_tce_iommu_ops;
 #ifdef CONFIG_IOMMU_API
diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index b125cea..1fc824d 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -65,31 +65,6 @@ struct machdep_calls {
 	 * destroyed as well */
 	void		(*hpte_clear_all)(void);
 
-	int		(*tce_build)(struct iommu_table *tbl,
-				     long index,
-				     long npages,
-				     unsigned long uaddr,
-				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs);
-	void		(*tce_free)(struct iommu_table *tbl,
-				    long index,
-				    long npages);
-	unsigned long	(*tce_get)(struct iommu_table *tbl,
-				    long index);
-	void		(*tce_flush)(struct iommu_table *tbl);
-
-	/* _rm versions are for real mode use only */
-	int		(*tce_build_rm)(struct iommu_table *tbl,
-				     long index,
-				     long npages,
-				     unsigned long uaddr,
-				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs);
-	void		(*tce_free_rm)(struct iommu_table *tbl,
-				    long index,
-				    long npages);
-	void		(*tce_flush_rm)(struct iommu_table *tbl);
-
 	void __iomem *	(*ioremap)(phys_addr_t addr, unsigned long size,
 				   unsigned long flags, void *caller);
 	void		(*iounmap)(volatile void __iomem *token);
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index cd80867..678fee8 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -323,11 +323,11 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 	ret = entry << tbl->it_page_shift;	/* Set the return dma address */
 
 	/* Put the TCEs in the HW table */
-	build_fail = ppc_md.tce_build(tbl, entry, npages,
+	build_fail = tbl->it_ops->set(tbl, entry, npages,
 				      (unsigned long)page &
 				      IOMMU_PAGE_MASK(tbl), direction, attrs);
 
-	/* ppc_md.tce_build() only returns non-zero for transient errors.
+	/* tbl->it_ops->set() only returns non-zero for transient errors.
 	 * Clean up the table bitmap in this case and return
 	 * DMA_ERROR_CODE. For all other errors the functionality is
 	 * not altered.
@@ -338,8 +338,8 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 	}
 
 	/* Flush/invalidate TLB caches if necessary */
-	if (ppc_md.tce_flush)
-		ppc_md.tce_flush(tbl);
+	if (tbl->it_ops->flush)
+		tbl->it_ops->flush(tbl);
 
 	/* Make sure updates are seen by hardware */
 	mb();
@@ -409,7 +409,7 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	if (!iommu_free_check(tbl, dma_addr, npages))
 		return;
 
-	ppc_md.tce_free(tbl, entry, npages);
+	tbl->it_ops->clear(tbl, entry, npages);
 
 	spin_lock_irqsave(&(pool->lock), flags);
 	bitmap_clear(tbl->it_map, free_entry, npages);
@@ -425,8 +425,8 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	 * not do an mb() here on purpose, it is not needed on any of
 	 * the current platforms.
 	 */
-	if (ppc_md.tce_flush)
-		ppc_md.tce_flush(tbl);
+	if (tbl->it_ops->flush)
+		tbl->it_ops->flush(tbl);
 }
 
 int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
@@ -496,7 +496,7 @@ int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 			    npages, entry, dma_addr);
 
 		/* Insert into HW table */
-		build_fail = ppc_md.tce_build(tbl, entry, npages,
+		build_fail = tbl->it_ops->set(tbl, entry, npages,
 					      vaddr & IOMMU_PAGE_MASK(tbl),
 					      direction, attrs);
 		if(unlikely(build_fail))
@@ -535,8 +535,8 @@ int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 	}
 
 	/* Flush/invalidate TLB caches if necessary */
-	if (ppc_md.tce_flush)
-		ppc_md.tce_flush(tbl);
+	if (tbl->it_ops->flush)
+		tbl->it_ops->flush(tbl);
 
 	DBG("mapped %d elements:\n", outcount);
 
@@ -601,8 +601,8 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 	 * do not do an mb() here, the affected platforms do not need it
 	 * when freeing.
 	 */
-	if (ppc_md.tce_flush)
-		ppc_md.tce_flush(tbl);
+	if (tbl->it_ops->flush)
+		tbl->it_ops->flush(tbl);
 }
 
 static void iommu_table_clear(struct iommu_table *tbl)
@@ -614,17 +614,17 @@ static void iommu_table_clear(struct iommu_table *tbl)
 	 */
 	if (!is_kdump_kernel() || is_fadump_active()) {
 		/* Clear the table in case firmware left allocations in it */
-		ppc_md.tce_free(tbl, tbl->it_offset, tbl->it_size);
+		tbl->it_ops->clear(tbl, tbl->it_offset, tbl->it_size);
 		return;
 	}
 
 #ifdef CONFIG_CRASH_DUMP
-	if (ppc_md.tce_get) {
+	if (tbl->it_ops->get) {
 		unsigned long index, tceval, tcecount = 0;
 
 		/* Reserve the existing mappings left by the first kernel. */
 		for (index = 0; index < tbl->it_size; index++) {
-			tceval = ppc_md.tce_get(tbl, index + tbl->it_offset);
+			tceval = tbl->it_ops->get(tbl, index + tbl->it_offset);
 			/*
 			 * Freed TCE entry contains 0x7fffffffffffffff on JS20
 			 */
@@ -650,7 +650,8 @@ static void iommu_table_clear(struct iommu_table *tbl)
  * Build a iommu_table structure.  This contains a bit map which
  * is used to manage allocation of the tce space.
  */
-struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
+struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid,
+		struct iommu_table_ops *ops)
 {
 	unsigned long sz;
 	static int welcomed = 0;
@@ -658,6 +659,9 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	unsigned int i;
 	struct iommu_pool *p;
 
+	BUG_ON(!ops);
+	tbl->it_ops = ops;
+
 	/* number of bytes needed for the bitmap */
 	sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
 
@@ -949,8 +953,8 @@ EXPORT_SYMBOL_GPL(iommu_tce_direction);
 void iommu_flush_tce(struct iommu_table *tbl)
 {
 	/* Flush/invalidate TLB caches if necessary */
-	if (ppc_md.tce_flush)
-		ppc_md.tce_flush(tbl);
+	if (tbl->it_ops->flush)
+		tbl->it_ops->flush(tbl);
 
 	/* Make sure updates are seen by hardware */
 	mb();
@@ -961,7 +965,7 @@ int iommu_tce_clear_param_check(struct iommu_table *tbl,
 		unsigned long ioba, unsigned long tce_value,
 		unsigned long npages)
 {
-	/* ppc_md.tce_free() does not support any value but 0 */
+	/* tbl->it_ops->clear() does not support any value but 0 */
 	if (tce_value)
 		return -EINVAL;
 
@@ -1009,9 +1013,9 @@ unsigned long iommu_clear_tce(struct iommu_table *tbl, unsigned long entry)
 
 	spin_lock(&(pool->lock));
 
-	oldtce = ppc_md.tce_get(tbl, entry);
+	oldtce = tbl->it_ops->get(tbl, entry);
 	if (oldtce & (TCE_PCI_WRITE | TCE_PCI_READ))
-		ppc_md.tce_free(tbl, entry, 1);
+		tbl->it_ops->clear(tbl, entry, 1);
 	else
 		oldtce = 0;
 
@@ -1058,10 +1062,10 @@ int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
 
 	spin_lock(&(pool->lock));
 
-	oldtce = ppc_md.tce_get(tbl, entry);
+	oldtce = tbl->it_ops->get(tbl, entry);
 	/* Add new entry if it is not busy */
 	if (!(oldtce & (TCE_PCI_WRITE | TCE_PCI_READ)))
-		ret = ppc_md.tce_build(tbl, entry, 1, hwaddr, direction, NULL);
+		ret = tbl->it_ops->set(tbl, entry, 1, hwaddr, direction, NULL);
 
 	spin_unlock(&(pool->lock));
 
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 5bfdab9..c61ce7a 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1196,7 +1196,10 @@ static struct iommu_table *vio_build_iommu_table(struct vio_dev *dev)
 	tbl->it_type = TCE_VB;
 	tbl->it_blocksize = 16;
 
-	return iommu_init_table(tbl, -1);
+	return iommu_init_table(tbl, -1,
+			firmware_has_feature(FW_FEATURE_LPAR) ?
+			&iommu_table_lpar_multi_ops :
+			&iommu_table_pseries_ops);
 }
 
 /**
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 2b90ff8..f6254f7 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -465,6 +465,11 @@ static inline u32 cell_iommu_get_ioid(struct device_node *np)
 	return *ioid;
 }
 
+static struct iommu_table_ops cell_iommu_ops = {
+	.set = tce_build_cell,
+	.clear = tce_free_cell
+};
+
 static struct iommu_window * __init
 cell_iommu_setup_window(struct cbe_iommu *iommu, struct device_node *np,
 			unsigned long offset, unsigned long size,
@@ -492,7 +497,7 @@ cell_iommu_setup_window(struct cbe_iommu *iommu, struct device_node *np,
 		(offset >> window->table.it_page_shift) + pte_offset;
 	window->table.it_size = size >> window->table.it_page_shift;
 
-	iommu_init_table(&window->table, iommu->nid);
+	iommu_init_table(&window->table, iommu->nid, &cell_iommu_ops);
 
 	pr_debug("\tioid      %d\n", window->ioid);
 	pr_debug("\tblocksize %ld\n", window->table.it_blocksize);
@@ -1199,8 +1204,6 @@ static int __init cell_iommu_init(void)
 	/* Setup various ppc_md. callbacks */
 	ppc_md.pci_dma_dev_setup = cell_pci_dma_dev_setup;
 	ppc_md.dma_get_required_mask = cell_dma_get_required_mask;
-	ppc_md.tce_build = tce_build_cell;
-	ppc_md.tce_free = tce_free_cell;
 
 	if (!iommu_fixed_disabled && cell_iommu_fixed_mapping_init() == 0)
 		goto bail;
diff --git a/arch/powerpc/platforms/pasemi/iommu.c b/arch/powerpc/platforms/pasemi/iommu.c
index 2e576f2..eac33f4 100644
--- a/arch/powerpc/platforms/pasemi/iommu.c
+++ b/arch/powerpc/platforms/pasemi/iommu.c
@@ -132,6 +132,10 @@ static void iobmap_free(struct iommu_table *tbl, long index,
 	}
 }
 
+static struct iommu_table_ops iommu_table_iobmap_ops = {
+	.set = iobmap_build,
+	.clear  = iobmap_free
+};
 
 static void iommu_table_iobmap_setup(void)
 {
@@ -151,7 +155,7 @@ static void iommu_table_iobmap_setup(void)
 	 * Should probably be 8 (64 bytes)
 	 */
 	iommu_table_iobmap.it_blocksize = 4;
-	iommu_init_table(&iommu_table_iobmap, 0);
+	iommu_init_table(&iommu_table_iobmap, 0, &iommu_table_iobmap_ops);
 	pr_debug(" <- %s\n", __func__);
 }
 
@@ -250,8 +254,6 @@ void __init iommu_init_early_pasemi(void)
 
 	ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_pasemi;
 	ppc_md.pci_dma_bus_setup = pci_dma_bus_setup_pasemi;
-	ppc_md.tce_build = iobmap_build;
-	ppc_md.tce_free  = iobmap_free;
 	set_pci_dma_ops(&dma_iommu_ops);
 }
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 8cb2f31..296f49b 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1087,7 +1087,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 				 TCE_PCI_SWINV_FREE   |
 				 TCE_PCI_SWINV_PAIR);
 	}
-	iommu_init_table(tbl, phb->hose->node);
+	iommu_init_table(tbl, phb->hose->node, &pnv_iommu_ops);
 	iommu_register_group(tbl, pe, &pnv_pci_ioda1_ops,
 			phb->hose->global_number, pe->pe_number);
 
@@ -1231,7 +1231,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 				8);
 		tbl->it_type |= (TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE);
 	}
-	iommu_init_table(tbl, phb->hose->node);
+	iommu_init_table(tbl, phb->hose->node, &pnv_iommu_ops);
 	iommu_register_group(tbl, pe, &pnv_pci_ioda2_ops,
 			phb->hose->global_number, pe->pe_number);
 
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index b79066d..ea97414 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -87,7 +87,8 @@ static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
 					 struct pci_dev *pdev)
 {
 	if (phb->p5ioc2.iommu_table.it_map == NULL) {
-		iommu_init_table(&phb->p5ioc2.iommu_table, phb->hose->node);
+		iommu_init_table(&phb->p5ioc2.iommu_table, phb->hose->node,
+				&pnv_iommu_ops);
 		iommu_register_group(&phb->p5ioc2.iommu_table,
 				NULL, NULL,
 				pci_domain_nr(phb->hose->bus), phb->opal_id);
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 6ffac79..deddcad 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -677,18 +677,11 @@ static unsigned long pnv_tce_get(struct iommu_table *tbl, long index)
 	return ((u64 *)tbl->it_base)[index - tbl->it_offset];
 }
 
-static int pnv_tce_build_rm(struct iommu_table *tbl, long index, long npages,
-			    unsigned long uaddr,
-			    enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
-{
-	return pnv_tce_build(tbl, index, npages, uaddr, direction, attrs, true);
-}
-
-static void pnv_tce_free_rm(struct iommu_table *tbl, long index, long npages)
-{
-	pnv_tce_free(tbl, index, npages, true);
-}
+struct iommu_table_ops pnv_iommu_ops = {
+	.set = pnv_tce_build_vm,
+	.clear = pnv_tce_free_vm,
+	.get = pnv_tce_get,
+};
 
 void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 			       void *tce_mem, u64 tce_size,
@@ -722,7 +715,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 		return NULL;
 	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
 				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K);
-	iommu_init_table(tbl, hose->node);
+	iommu_init_table(tbl, hose->node, &pnv_iommu_ops);
 	iommu_register_group(tbl, NULL, NULL, pci_domain_nr(hose->bus), 0);
 
 	/* Deal with SW invalidated TCEs when needed (BML way) */
@@ -865,11 +858,6 @@ void __init pnv_pci_init(void)
 
 	/* Configure IOMMU DMA hooks */
 	ppc_md.pci_dma_dev_setup = pnv_pci_dma_dev_setup;
-	ppc_md.tce_build = pnv_tce_build_vm;
-	ppc_md.tce_free = pnv_tce_free_vm;
-	ppc_md.tce_build_rm = pnv_tce_build_rm;
-	ppc_md.tce_free_rm = pnv_tce_free_rm;
-	ppc_md.tce_get = pnv_tce_get;
 	ppc_md.pci_probe_mode = pnv_pci_probe_mode;
 	set_pci_dma_ops(&dma_iommu_ops);
 
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index 095db43..cf68c4b 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -223,6 +223,7 @@ extern struct pci_ops pnv_pci_ops;
 #ifdef CONFIG_EEH
 extern struct pnv_eeh_ops ioda_eeh_ops;
 #endif
+extern struct iommu_table_ops pnv_iommu_ops;
 
 void pnv_pci_dump_phb_diag_data(struct pci_controller *hose,
 				unsigned char *log_buff);
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index b95f8cf..9a7364f 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -193,7 +193,7 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	int ret = 0;
 	unsigned long flags;
 
-	if (npages == 1) {
+	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE)) {
 		return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
 		                           direction, attrs);
 	}
@@ -285,6 +285,9 @@ static void tce_freemulti_pSeriesLP(struct iommu_table *tbl, long tcenum, long n
 {
 	u64 rc;
 
+	if (!firmware_has_feature(FW_FEATURE_MULTITCE))
+		return tce_free_pSeriesLP(tbl, tcenum, npages);
+
 	rc = plpar_tce_stuff((u64)tbl->it_index, (u64)tcenum << 12, 0, npages);
 
 	if (rc && printk_ratelimit()) {
@@ -460,7 +463,6 @@ static int tce_setrange_multi_pSeriesLP_walk(unsigned long start_pfn,
 	return tce_setrange_multi_pSeriesLP(start_pfn, num_pfn, arg);
 }
 
-
 #ifdef CONFIG_PCI
 static void iommu_table_setparms(struct pci_controller *phb,
 				 struct device_node *dn,
@@ -546,6 +548,12 @@ static void iommu_table_setparms_lpar(struct pci_controller *phb,
 	tbl->it_size = size >> tbl->it_page_shift;
 }
 
+struct iommu_table_ops iommu_table_pseries_ops = {
+	.set = tce_build_pSeries,
+	.clear = tce_free_pSeries,
+	.get = tce_get_pseries
+};
+
 static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 {
 	struct device_node *dn;
@@ -615,7 +623,8 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 			   pci->phb->node);
 
 	iommu_table_setparms(pci->phb, dn, tbl);
-	pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
+	pci->iommu_table = iommu_init_table(tbl, pci->phb->node,
+			&iommu_table_pseries_ops);
 	iommu_register_group(tbl, NULL, NULL, pci_domain_nr(bus), 0);
 
 	/* Divide the rest (1.75GB) among the children */
@@ -626,6 +635,11 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 	pr_debug("ISA/IDE, window size is 0x%llx\n", pci->phb->dma_window_size);
 }
 
+struct iommu_table_ops iommu_table_lpar_multi_ops = {
+	.set = tce_buildmulti_pSeriesLP,
+	.clear = tce_freemulti_pSeriesLP,
+	.get = tce_get_pSeriesLP
+};
 
 static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 {
@@ -660,7 +674,8 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 				   ppci->phb->node);
 		iommu_table_setparms_lpar(ppci->phb, pdn, tbl, dma_window);
-		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node);
+		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node,
+				&iommu_table_lpar_multi_ops);
 		iommu_register_group(tbl, NULL, NULL, pci_domain_nr(bus), 0);
 		pr_debug("  created table: %p\n", ppci->iommu_table);
 	}
@@ -687,7 +702,8 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 				   phb->node);
 		iommu_table_setparms(phb, dn, tbl);
-		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
+		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node,
+				&iommu_table_pseries_ops);
 		iommu_register_group(tbl, NULL, NULL,
 				pci_domain_nr(phb->bus), 0);
 		set_iommu_table_base_and_group(&dev->dev,
@@ -1105,7 +1121,8 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 				   pci->phb->node);
 		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window);
-		pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
+		pci->iommu_table = iommu_init_table(tbl, pci->phb->node,
+				&iommu_table_lpar_multi_ops);
 		iommu_register_group(tbl, NULL, NULL,
 				pci_domain_nr(pci->phb->bus), 0);
 		pr_debug("  created table: %p\n", pci->iommu_table);
@@ -1297,22 +1314,11 @@ void iommu_init_early_pSeries(void)
 		return;
 
 	if (firmware_has_feature(FW_FEATURE_LPAR)) {
-		if (firmware_has_feature(FW_FEATURE_MULTITCE)) {
-			ppc_md.tce_build = tce_buildmulti_pSeriesLP;
-			ppc_md.tce_free	 = tce_freemulti_pSeriesLP;
-		} else {
-			ppc_md.tce_build = tce_build_pSeriesLP;
-			ppc_md.tce_free	 = tce_free_pSeriesLP;
-		}
-		ppc_md.tce_get   = tce_get_pSeriesLP;
 		ppc_md.pci_dma_bus_setup = pci_dma_bus_setup_pSeriesLP;
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_pSeriesLP;
 		ppc_md.dma_set_mask = dma_set_mask_pSeriesLP;
 		ppc_md.dma_get_required_mask = dma_get_required_mask_pSeriesLP;
 	} else {
-		ppc_md.tce_build = tce_build_pSeries;
-		ppc_md.tce_free  = tce_free_pSeries;
-		ppc_md.tce_get   = tce_get_pseries;
 		ppc_md.pci_dma_bus_setup = pci_dma_bus_setup_pSeries;
 		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_pSeries;
 	}
@@ -1330,8 +1336,6 @@ static int __init disable_multitce(char *str)
 	    firmware_has_feature(FW_FEATURE_LPAR) &&
 	    firmware_has_feature(FW_FEATURE_MULTITCE)) {
 		printk(KERN_INFO "Disabling MULTITCE firmware feature\n");
-		ppc_md.tce_build = tce_build_pSeriesLP;
-		ppc_md.tce_free	 = tce_free_pSeriesLP;
 		powerpc_firmware_features &= ~FW_FEATURE_MULTITCE;
 	}
 	return 1;
diff --git a/arch/powerpc/sysdev/dart_iommu.c b/arch/powerpc/sysdev/dart_iommu.c
index 9e5353f..27721f5 100644
--- a/arch/powerpc/sysdev/dart_iommu.c
+++ b/arch/powerpc/sysdev/dart_iommu.c
@@ -286,6 +286,12 @@ static int __init dart_init(struct device_node *dart_node)
 	return 0;
 }
 
+static struct iommu_table_ops iommu_dart_ops = {
+	.set = dart_build,
+	.clear = dart_free,
+	.flush = dart_flush,
+};
+
 static void iommu_table_dart_setup(void)
 {
 	iommu_table_dart.it_busno = 0;
@@ -298,7 +304,7 @@ static void iommu_table_dart_setup(void)
 	iommu_table_dart.it_base = (unsigned long)dart_vbase;
 	iommu_table_dart.it_index = 0;
 	iommu_table_dart.it_blocksize = 1;
-	iommu_init_table(&iommu_table_dart, -1);
+	iommu_init_table(&iommu_table_dart, -1, &iommu_dart_ops);
 
 	/* Reserve the last page of the DART to avoid possible prefetch
 	 * past the DART mapped area
@@ -386,11 +392,6 @@ void __init iommu_init_early_dart(void)
 	if (dart_init(dn) != 0)
 		goto bail;
 
-	/* Setup low level TCE operations for the core IOMMU code */
-	ppc_md.tce_build = dart_build;
-	ppc_md.tce_free  = dart_free;
-	ppc_md.tce_flush = dart_flush;
-
 	/* Setup bypass if supported */
 	if (dart_is_u4)
 		ppc_md.dma_set_mask = dart_dma_set_mask;
-- 
2.0.0
