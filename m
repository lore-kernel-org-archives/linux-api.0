From: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Subject: [PATCH 10/13] powerpc/powernv: Implement Dynamic DMA windows (DDW) for IODA
Date: Fri, 29 Aug 2014 17:59:13 +1000
Message-ID: <1409299156-618-11-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cbe-oss-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

SPAPR defines an interface to create additional DMA windows dynamically.
"Dynamically" means that the window is not allocated before the guest
even started, the guest can request it later. In practice, existing linux
guests check for the capability and if it is there, they create and map
a DMA window as big as the entire guest RAM.

This adds 4 callbacks to the spapr_tce_iommu_ops struct:
1. query - ibm,query-pe-dma-window - returns number/size of windows
which can be created (one, any page size);

2. create - ibm,create-pe-dma-window - creates a window;

3. remove - ibm,remove-pe-dma-window - removes a window; removing
the default 32bit window is not allowed by this patch, this will be added
later if needed;

4. reset -  ibm,reset-pe-dma-window - reset the DMA windows configuration
to the default state; as the default window cannot be removed, it only
removes the additional window if it was created.

The next patch will add corresponding ioctls to VFIO SPAPR TCE driver to
provide necessary support to the userspace.

Signed-off-by: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
---
 arch/powerpc/include/asm/tce.h            |  22 +++++
 arch/powerpc/platforms/powernv/pci-ioda.c | 159 +++++++++++++++++++++++++++++-
 arch/powerpc/platforms/powernv/pci.h      |   1 +
 3 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/tce.h b/arch/powerpc/include/asm/tce.h
index e6355f9..23b0362 100644
--- a/arch/powerpc/include/asm/tce.h
+++ b/arch/powerpc/include/asm/tce.h
@@ -58,6 +58,28 @@ struct spapr_tce_iommu_ops {
 			int num);
 	void (*take_ownership)(struct spapr_tce_iommu_group *data,
 			bool enable);
+
+	/* Dynamic DMA window */
+	/* Page size flags for ibm,query-pe-dma-window */
+#define DDW_PGSIZE_4K       0x01
+#define DDW_PGSIZE_64K      0x02
+#define DDW_PGSIZE_16M      0x04
+#define DDW_PGSIZE_32M      0x08
+#define DDW_PGSIZE_64M      0x10
+#define DDW_PGSIZE_128M     0x20
+#define DDW_PGSIZE_256M     0x40
+#define DDW_PGSIZE_16G      0x80
+	long (*query)(struct spapr_tce_iommu_group *data,
+			__u32 *current_windows,
+			__u32 *windows_available,
+			__u32 *page_size_mask);
+	long (*create)(struct spapr_tce_iommu_group *data,
+			__u32 page_shift,
+			__u32 window_shift,
+			struct iommu_table **ptbl);
+	long (*remove)(struct spapr_tce_iommu_group *data,
+			struct iommu_table *tbl);
+	long (*reset)(struct spapr_tce_iommu_group *data);
 };
 
 struct spapr_tce_iommu_group {
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 296f49b..a6318cb 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1154,6 +1154,26 @@ static void pnv_pci_ioda2_setup_bypass_pe(struct pnv_phb *phb,
 	pnv_pci_ioda2_set_bypass(pe, true);
 }
 
+static struct iommu_table *pnv_ioda2_iommu_get_table(
+		struct spapr_tce_iommu_group *data,
+		int num)
+{
+	struct pnv_ioda_pe *pe = data->iommu_owner;
+
+	switch (num) {
+	case 0:
+		if (pe->tce32.table.it_size)
+			return &pe->tce32.table;
+		return NULL;
+	case 1:
+		if (pe->tce64.table.it_size)
+			return &pe->tce64.table;
+		return NULL;
+	default:
+		return NULL;
+	}
+}
+
 static void pnv_ioda2_take_ownership(struct spapr_tce_iommu_group *data,
 				     bool enable)
 {
@@ -1162,9 +1182,146 @@ static void pnv_ioda2_take_ownership(struct spapr_tce_iommu_group *data,
 	pnv_pci_ioda2_set_bypass(pe, !enable);
 }
 
+static long pnv_pci_ioda2_ddw_query(struct spapr_tce_iommu_group *data,
+		__u32 *current_windows,
+		__u32 *windows_available, __u32 *page_size_mask)
+{
+	struct pnv_ioda_pe *pe = data->iommu_owner;
+
+	*windows_available = 2;
+	*current_windows = 0;
+	if (pe->tce32.table.it_size) {
+		--*windows_available;
+		++*current_windows;
+	}
+	if (pe->tce64.table.it_size) {
+		--*windows_available;
+		++*current_windows;
+	}
+	*page_size_mask =
+		DDW_PGSIZE_4K |
+		DDW_PGSIZE_64K |
+		DDW_PGSIZE_16M;
+
+	return 0;
+}
+
+static long pnv_pci_ioda2_ddw_create(struct spapr_tce_iommu_group *data,
+		__u32 page_shift, __u32 window_shift,
+		struct iommu_table **ptbl)
+{
+	struct pnv_ioda_pe *pe = data->iommu_owner;
+	struct pnv_phb *phb = pe->phb;
+	struct page *tce_mem = NULL;
+	void *addr;
+	long ret;
+	unsigned long tce_table_size =
+			(1ULL << (window_shift - page_shift)) * 8;
+	unsigned order;
+	struct iommu_table *tbl64 = &pe->tce64.table;
+
+	if ((page_shift != 12) && (page_shift != 16) && (page_shift != 24))
+		return -EINVAL;
+
+	if (window_shift > (memory_hotplug_max() >> page_shift))
+		return -EINVAL;
+
+	if (pe->tce64.table.it_size && pe->tce32.table.it_size)
+		return -EBUSY;
+
+	tce_table_size = max(0x1000UL, tce_table_size);
+	order = get_order(tce_table_size);
+
+	pe_info(pe, "Setting up DDW at %llx..%llx ws=0x%x ps=0x%x table_size=0x%lx order=0x%x\n",
+			pe->tce_bypass_base,
+			pe->tce_bypass_base + (1ULL << window_shift) - 1,
+			window_shift, page_shift, tce_table_size, order);
+
+	tce_mem = alloc_pages_node(phb->hose->node, GFP_KERNEL, order);
+	if (!tce_mem) {
+		pe_err(pe, " Failed to allocate a DDW\n");
+		return -EFAULT;
+	}
+	addr = page_address(tce_mem);
+	memset(addr, 0, tce_table_size);
+
+	/* Configure HW */
+	ret = opal_pci_map_pe_dma_window(phb->opal_id,
+			pe->pe_number,
+			(pe->pe_number << 1) + 1, /* Window number */
+			1,
+			__pa(addr),
+			tce_table_size,
+			1 << page_shift);
+	if (ret) {
+		pe_err(pe, " Failed to configure 32-bit TCE table, err %ld\n",
+				ret);
+		return -EFAULT;
+	}
+
+	/* Setup linux iommu table */
+	pnv_pci_setup_iommu_table(tbl64, addr, tce_table_size,
+			pe->tce_bypass_base, page_shift);
+	pe->tce64.pe = pe;
+	pe->tce64.invalidate_fn = pnv_pci_ioda2_tce_invalidate;
+
+	/* Copy "invalidate" register address */
+	tbl64->it_index = pe->tce32.table.it_index;
+	tbl64->it_group = pe->tce32.table.it_group;
+	tbl64->it_type = TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE |
+			TCE_PCI_SWINV_PAIR;
+	tbl64->it_map = (void *) 0xDEADBEEF; /* poison */
+	tbl64->it_ops = pe->tce32.table.it_ops;
+
+	*ptbl = tbl64;
+
+	return 0;
+}
+
+static long pnv_pci_ioda2_ddw_remove(struct spapr_tce_iommu_group *data,
+		struct iommu_table *tbl)
+{
+	struct pnv_ioda_pe *pe = data->iommu_owner;
+	struct pnv_phb *phb = pe->phb;
+	long ret;
+
+	/* Only additional 64bit window removal is supported */
+	if ((tbl != &pe->tce64.table) || !pe->tce64.table.it_size)
+		return -EFAULT;
+
+	pe_info(pe, "Removing huge 64bit DMA window\n");
+
+	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
+
+	ret = opal_pci_map_pe_dma_window(phb->opal_id,
+			pe->pe_number,
+			(pe->pe_number << 1) + 1,
+			0/* levels */, 0/* table address */,
+			0/* table size */, 0/* page size */);
+	if (ret)
+		pe_warn(pe, "Unmapping failed, ret = %ld\n", ret);
+
+	free_pages(tbl->it_base, get_order(tbl->it_size << 3));
+	memset(&pe->tce64, 0, sizeof(pe->tce64));
+
+	return ret;
+}
+
+static long pnv_pci_ioda2_ddw_reset(struct spapr_tce_iommu_group *data)
+{
+	struct pnv_ioda_pe *pe = data->iommu_owner;
+
+	pe_info(pe, "Reset DMA windows\n");
+	return pnv_pci_ioda2_ddw_remove(data, &pe->tce64.table);
+}
+
 static struct spapr_tce_iommu_ops pnv_pci_ioda2_ops = {
-	.get_table = pnv_ioda1_iommu_get_table,
+	.get_table = pnv_ioda2_iommu_get_table,
 	.take_ownership = pnv_ioda2_take_ownership,
+	.query = pnv_pci_ioda2_ddw_query,
+	.create = pnv_pci_ioda2_ddw_create,
+	.remove = pnv_pci_ioda2_ddw_remove,
+	.reset = pnv_pci_ioda2_ddw_reset
 };
 
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index cf68c4b..9941800 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -66,6 +66,7 @@ struct pnv_ioda_pe {
 	int			tce32_segcount;
 	struct pnv_iommu_table	tce32;
 	phys_addr_t		tce_inval_reg_phys;
+	struct pnv_iommu_table	tce64;
 
 	/* 64-bit TCE bypass region */
 	bool			tce_bypass_enabled;
-- 
2.0.0
