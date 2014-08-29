From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 03/13] powerpc/spapr: vfio: Implement spapr_tce_iommu_ops
Date: Fri, 29 Aug 2014 17:59:06 +1000
Message-ID: <1409299156-618-4-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Alex Williamson <alex.williamson@redhat.com>, Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Modern IBM POWERPC systems support multiple IOMMU tables per PE
so we need a more reliable way (compared to container_of()) to get
a PE pointer from the iommu_table struct pointer used in IOMMU functions.

At the moment IOMMU group data points to an iommu_table struct. This
introduces a spapr_tce_iommu_group struct which keeps an iommu_owner
and a spapr_tce_iommu_ops struct. For IODA, iommu_owner is a pointer to
the pnv_ioda_pe struct, for others it is still a pointer to
the iommu_table struct. The ops structs correspond to the type which
iommu_owner points to.

This defines a get_table() callback which returns an iommu_table
by its number.

As the IOMMU group data pointer points to variable type instead of
iommu_table, VFIO SPAPR TCE driver is updated to use the new type.
This changes the tce_container struct to store iommu_group instead of
iommu_table.

So, it was:
- iommu_table points to iommu_group via iommu_table::it_group;
- iommu_group points to iommu_table via iommu_group_get_iommudata();

now it is:
- iommu_table points to iommu_group via iommu_table::it_group;
- iommu_group points to spapr_tce_iommu_group via
iommu_group_get_iommudata();
- spapr_tce_iommu_group points to either (depending on .get_table()):
	- iommu_table;
	- pnv_ioda_pe;

This uses pnv_ioda1_iommu_get_table for both IODA1&2 but IODA2 will
have own pnv_ioda2_iommu_get_table soon and pnv_ioda1_iommu_get_table
will only be used for IODA1.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h            |   6 ++
 arch/powerpc/include/asm/tce.h              |  13 +++
 arch/powerpc/kernel/iommu.c                 |  35 ++++++-
 arch/powerpc/platforms/powernv/pci-ioda.c   |  31 +++++-
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |   1 +
 arch/powerpc/platforms/powernv/pci.c        |   2 +-
 arch/powerpc/platforms/pseries/iommu.c      |  10 +-
 drivers/vfio/vfio_iommu_spapr_tce.c         | 148 ++++++++++++++++++++++------
 8 files changed, 208 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 42632c7..84ee339 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -108,13 +108,19 @@ extern void iommu_free_table(struct iommu_table *tbl, const char *node_name);
  */
 extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
 					    int nid);
+
+struct spapr_tce_iommu_ops;
 #ifdef CONFIG_IOMMU_API
 extern void iommu_register_group(struct iommu_table *tbl,
+				 void *iommu_owner,
+				 struct spapr_tce_iommu_ops *ops,
 				 int pci_domain_number, unsigned long pe_num);
 extern int iommu_add_device(struct device *dev);
 extern void iommu_del_device(struct device *dev);
 #else
 static inline void iommu_register_group(struct iommu_table *tbl,
+					void *iommu_owner,
+					struct spapr_tce_iommu_ops *ops,
 					int pci_domain_number,
 					unsigned long pe_num)
 {
diff --git a/arch/powerpc/include/asm/tce.h b/arch/powerpc/include/asm/tce.h
index 743f36b..9f159eb 100644
--- a/arch/powerpc/include/asm/tce.h
+++ b/arch/powerpc/include/asm/tce.h
@@ -50,5 +50,18 @@
 #define TCE_PCI_READ		0x1		/* read from PCI allowed */
 #define TCE_VB_WRITE		0x1		/* write from VB allowed */
 
+struct spapr_tce_iommu_group;
+
+struct spapr_tce_iommu_ops {
+	struct iommu_table *(*get_table)(
+			struct spapr_tce_iommu_group *data,
+			int num);
+};
+
+struct spapr_tce_iommu_group {
+	void *iommu_owner;
+	struct spapr_tce_iommu_ops *ops;
+};
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_TCE_H */
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b378f78..1c5dae7 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -878,24 +878,53 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
  */
 static void group_release(void *iommu_data)
 {
-	struct iommu_table *tbl = iommu_data;
-	tbl->it_group = NULL;
+	kfree(iommu_data);
 }
 
+static struct iommu_table *spapr_tce_default_get_table(
+		struct spapr_tce_iommu_group *data, int num)
+{
+	struct iommu_table *tbl = data->iommu_owner;
+
+	switch (num) {
+	case 0:
+		if (tbl->it_size)
+			return tbl;
+		/* fallthru */
+	default:
+		return NULL;
+	}
+}
+
+static struct spapr_tce_iommu_ops spapr_tce_default_ops = {
+	.get_table = spapr_tce_default_get_table
+};
+
 void iommu_register_group(struct iommu_table *tbl,
+		void *iommu_owner, struct spapr_tce_iommu_ops *ops,
 		int pci_domain_number, unsigned long pe_num)
 {
 	struct iommu_group *grp;
 	char *name;
+	struct spapr_tce_iommu_group *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	data->iommu_owner = iommu_owner ? iommu_owner : tbl;
+	data->ops = ops ? ops : &spapr_tce_default_ops;
 
 	grp = iommu_group_alloc();
 	if (IS_ERR(grp)) {
 		pr_warn("powerpc iommu api: cannot create new group, err=%ld\n",
 				PTR_ERR(grp));
+		kfree(data);
 		return;
 	}
+
 	tbl->it_group = grp;
-	iommu_group_set_iommudata(grp, tbl, group_release);
+	iommu_group_set_iommudata(grp, data, group_release);
 	name = kasprintf(GFP_KERNEL, "domain%d-pe%lx",
 			pci_domain_number, pe_num);
 	if (!name)
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 136e765..2d32a1c 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/msi.h>
 #include <linux/memblock.h>
+#include <linux/iommu.h>
 
 #include <asm/sections.h>
 #include <asm/io.h>
@@ -988,6 +989,26 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 	}
 }
 
+static struct iommu_table *pnv_ioda1_iommu_get_table(
+		struct spapr_tce_iommu_group *data,
+		int num)
+{
+	struct pnv_ioda_pe *pe = data->iommu_owner;
+
+	switch (num) {
+	case 0:
+		if (pe->tce32.table.it_size)
+			return &pe->tce32.table;
+		/* fallthru */
+	default:
+		return NULL;
+	}
+}
+
+static struct spapr_tce_iommu_ops pnv_pci_ioda1_ops = {
+	.get_table = pnv_ioda1_iommu_get_table,
+};
+
 static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 				      struct pnv_ioda_pe *pe, unsigned int base,
 				      unsigned int segs)
@@ -1067,7 +1088,8 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 				 TCE_PCI_SWINV_PAIR);
 	}
 	iommu_init_table(tbl, phb->hose->node);
-	iommu_register_group(tbl, phb->hose->global_number, pe->pe_number);
+	iommu_register_group(tbl, pe, &pnv_pci_ioda1_ops,
+			phb->hose->global_number, pe->pe_number);
 
 	if (pe->pdev)
 		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
@@ -1137,6 +1159,10 @@ static void pnv_pci_ioda2_setup_bypass_pe(struct pnv_phb *phb,
 	pnv_pci_ioda2_set_bypass(&pe->tce32.table, true);
 }
 
+static struct spapr_tce_iommu_ops pnv_pci_ioda2_ops = {
+	.get_table = pnv_ioda1_iommu_get_table,
+};
+
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 				       struct pnv_ioda_pe *pe)
 {
@@ -1202,7 +1228,8 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 		tbl->it_type |= (TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE);
 	}
 	iommu_init_table(tbl, phb->hose->node);
-	iommu_register_group(tbl, phb->hose->global_number, pe->pe_number);
+	iommu_register_group(tbl, pe, &pnv_pci_ioda2_ops,
+			phb->hose->global_number, pe->pe_number);
 
 	if (pe->pdev)
 		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index 94ce348..b79066d 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -89,6 +89,7 @@ static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
 	if (phb->p5ioc2.iommu_table.it_map == NULL) {
 		iommu_init_table(&phb->p5ioc2.iommu_table, phb->hose->node);
 		iommu_register_group(&phb->p5ioc2.iommu_table,
+				NULL, NULL,
 				pci_domain_nr(phb->hose->bus), phb->opal_id);
 	}
 
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 97895d4..6ffac79 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -723,7 +723,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
 				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K);
 	iommu_init_table(tbl, hose->node);
-	iommu_register_group(tbl, pci_domain_nr(hose->bus), 0);
+	iommu_register_group(tbl, NULL, NULL, pci_domain_nr(hose->bus), 0);
 
 	/* Deal with SW invalidated TCEs when needed (BML way) */
 	swinvp = of_get_property(hose->dn, "linux,tce-sw-invalidate-info",
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 4642d6a..b95f8cf 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -616,7 +616,7 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 
 	iommu_table_setparms(pci->phb, dn, tbl);
 	pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
-	iommu_register_group(tbl, pci_domain_nr(bus), 0);
+	iommu_register_group(tbl, NULL, NULL, pci_domain_nr(bus), 0);
 
 	/* Divide the rest (1.75GB) among the children */
 	pci->phb->dma_window_size = 0x80000000ul;
@@ -661,7 +661,7 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 				   ppci->phb->node);
 		iommu_table_setparms_lpar(ppci->phb, pdn, tbl, dma_window);
 		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node);
-		iommu_register_group(tbl, pci_domain_nr(bus), 0);
+		iommu_register_group(tbl, NULL, NULL, pci_domain_nr(bus), 0);
 		pr_debug("  created table: %p\n", ppci->iommu_table);
 	}
 }
@@ -688,7 +688,8 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 				   phb->node);
 		iommu_table_setparms(phb, dn, tbl);
 		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
-		iommu_register_group(tbl, pci_domain_nr(phb->bus), 0);
+		iommu_register_group(tbl, NULL, NULL,
+				pci_domain_nr(phb->bus), 0);
 		set_iommu_table_base_and_group(&dev->dev,
 					       PCI_DN(dn)->iommu_table);
 		return;
@@ -1105,7 +1106,8 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 				   pci->phb->node);
 		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window);
 		pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
-		iommu_register_group(tbl, pci_domain_nr(pci->phb->bus), 0);
+		iommu_register_group(tbl, NULL, NULL,
+				pci_domain_nr(pci->phb->bus), 0);
 		pr_debug("  created table: %p\n", pci->iommu_table);
 	} else {
 		pr_debug("  found DMA window, table: %p\n", pci->iommu_table);
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 730b4ef..a8adfbd 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -43,17 +43,51 @@ static void tce_iommu_detach_group(void *iommu_data,
  */
 struct tce_container {
 	struct mutex lock;
-	struct iommu_table *tbl;
+	struct iommu_group *grp;
+	long windows_num;
 	bool enabled;
 };
 
+static struct iommu_table *spapr_tce_find_table(
+		struct tce_container *container,
+		struct spapr_tce_iommu_group *data,
+		phys_addr_t ioba)
+{
+	long i;
+	struct iommu_table *ret = NULL;
+
+	mutex_lock(&container->lock);
+	for (i = 0; i < container->windows_num; ++i) {
+		struct iommu_table *tbl = data->ops->get_table(data, i);
+
+		if (tbl) {
+			unsigned long entry = ioba >> tbl->it_page_shift;
+			unsigned long start = tbl->it_offset;
+			unsigned long end = start + tbl->it_size;
+
+			if ((start <= entry) && (entry < end)) {
+				ret = tbl;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&container->lock);
+
+	return ret;
+}
+
 static int tce_iommu_enable(struct tce_container *container)
 {
 	int ret = 0;
 	unsigned long locked, lock_limit, npages;
-	struct iommu_table *tbl = container->tbl;
+	struct iommu_table *tbl;
+	struct spapr_tce_iommu_group *data;
 
-	if (!container->tbl)
+	if (!container->grp)
+		return -ENXIO;
+
+	data = iommu_group_get_iommudata(container->grp);
+	if (!data || !data->iommu_owner || !data->ops->get_table)
 		return -ENXIO;
 
 	if (!current->mm)
@@ -80,6 +114,10 @@ static int tce_iommu_enable(struct tce_container *container)
 	 * that would effectively kill the guest at random points, much better
 	 * enforcing the limit based on the max that the guest can map.
 	 */
+	tbl = data->ops->get_table(data, 0);
+	if (!tbl)
+		return -ENXIO;
+
 	down_write(&current->mm->mmap_sem);
 	npages = (tbl->it_size << IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
 	locked = current->mm->locked_vm + npages;
@@ -89,7 +127,6 @@ static int tce_iommu_enable(struct tce_container *container)
 				rlimit(RLIMIT_MEMLOCK));
 		ret = -ENOMEM;
 	} else {
-
 		current->mm->locked_vm += npages;
 		container->enabled = true;
 	}
@@ -100,16 +137,27 @@ static int tce_iommu_enable(struct tce_container *container)
 
 static void tce_iommu_disable(struct tce_container *container)
 {
+	struct spapr_tce_iommu_group *data;
+	struct iommu_table *tbl;
+
 	if (!container->enabled)
 		return;
 
 	container->enabled = false;
 
-	if (!container->tbl || !current->mm)
+	if (!container->grp || !current->mm)
+		return;
+
+	data = iommu_group_get_iommudata(container->grp);
+	if (!data || !data->iommu_owner || !data->ops->get_table)
+		return;
+
+	tbl = data->ops->get_table(data, 0);
+	if (!tbl)
 		return;
 
 	down_write(&current->mm->mmap_sem);
-	current->mm->locked_vm -= (container->tbl->it_size <<
+	current->mm->locked_vm -= (tbl->it_size <<
 			IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
 	up_write(&current->mm->mmap_sem);
 }
@@ -129,6 +177,8 @@ static void *tce_iommu_open(unsigned long arg)
 
 	mutex_init(&container->lock);
 
+	container->windows_num = 1;
+
 	return container;
 }
 
@@ -136,11 +186,11 @@ static void tce_iommu_release(void *iommu_data)
 {
 	struct tce_container *container = iommu_data;
 
-	WARN_ON(container->tbl && !container->tbl->it_group);
+	WARN_ON(container->grp);
 	tce_iommu_disable(container);
 
-	if (container->tbl && container->tbl->it_group)
-		tce_iommu_detach_group(iommu_data, container->tbl->it_group);
+	if (container->grp)
+		tce_iommu_detach_group(iommu_data, container->grp);
 
 	mutex_destroy(&container->lock);
 
@@ -169,8 +219,17 @@ static long tce_iommu_ioctl(void *iommu_data,
 
 	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
 		struct vfio_iommu_spapr_tce_info info;
-		struct iommu_table *tbl = container->tbl;
+		struct iommu_table *tbl;
+		struct spapr_tce_iommu_group *data;
 
+		if (WARN_ON(!container->grp))
+			return -ENXIO;
+
+		data = iommu_group_get_iommudata(container->grp);
+		if (WARN_ON(!data || !data->iommu_owner || !data->ops))
+			return -ENXIO;
+
+		tbl = data->ops->get_table(data, 0);
 		if (WARN_ON(!tbl))
 			return -ENXIO;
 
@@ -194,13 +253,16 @@ static long tce_iommu_ioctl(void *iommu_data,
 	}
 	case VFIO_IOMMU_MAP_DMA: {
 		struct vfio_iommu_type1_dma_map param;
-		struct iommu_table *tbl = container->tbl;
+		struct iommu_table *tbl;
+		struct spapr_tce_iommu_group *data;
 		unsigned long tce, i;
 
-		if (!tbl)
+		if (WARN_ON(!container->grp))
 			return -ENXIO;
 
-		BUG_ON(!tbl->it_group);
+		data = iommu_group_get_iommudata(container->grp);
+		if (WARN_ON(!data || !data->iommu_owner || !data->ops))
+			return -ENXIO;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -225,6 +287,11 @@ static long tce_iommu_ioctl(void *iommu_data,
 		if (param.flags & VFIO_DMA_MAP_FLAG_WRITE)
 			tce |= TCE_PCI_WRITE;
 
+		tbl = spapr_tce_find_table(container, data, param.iova);
+		if (!tbl)
+			return -ENXIO;
+		BUG_ON(!tbl->it_group);
+
 		ret = iommu_tce_put_param_check(tbl, param.iova, tce);
 		if (ret)
 			return ret;
@@ -247,9 +314,14 @@ static long tce_iommu_ioctl(void *iommu_data,
 	}
 	case VFIO_IOMMU_UNMAP_DMA: {
 		struct vfio_iommu_type1_dma_unmap param;
-		struct iommu_table *tbl = container->tbl;
+		struct iommu_table *tbl;
+		struct spapr_tce_iommu_group *data;
 
-		if (WARN_ON(!tbl))
+		if (WARN_ON(!container->grp))
+			return -ENXIO;
+
+		data = iommu_group_get_iommudata(container->grp);
+		if (WARN_ON(!data || !data->iommu_owner || !data->ops))
 			return -ENXIO;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap,
@@ -268,6 +340,12 @@ static long tce_iommu_ioctl(void *iommu_data,
 		if (param.size & ~IOMMU_PAGE_MASK_4K)
 			return -EINVAL;
 
+		tbl = spapr_tce_find_table(container, data, param.iova);
+		if (!tbl)
+			return -ENXIO;
+
+		BUG_ON(!tbl->it_group);
+
 		ret = iommu_tce_clear_param_check(tbl, param.iova, 0,
 				param.size >> IOMMU_PAGE_SHIFT_4K);
 		if (ret)
@@ -293,10 +371,10 @@ static long tce_iommu_ioctl(void *iommu_data,
 		mutex_unlock(&container->lock);
 		return 0;
 	case VFIO_EEH_PE_OP:
-		if (!container->tbl || !container->tbl->it_group)
+		if (!container->grp)
 			return -ENODEV;
 
-		return vfio_spapr_iommu_eeh_ioctl(container->tbl->it_group,
+		return vfio_spapr_iommu_eeh_ioctl(container->grp,
 						  cmd, arg);
 	}
 
@@ -308,16 +386,16 @@ static int tce_iommu_attach_group(void *iommu_data,
 {
 	int ret;
 	struct tce_container *container = iommu_data;
-	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
+	struct iommu_table *tbl;
+	struct spapr_tce_iommu_group *data;
 
-	BUG_ON(!tbl);
 	mutex_lock(&container->lock);
 
 	/* pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
 			iommu_group_id(iommu_group), iommu_group); */
-	if (container->tbl) {
+	if (container->grp) {
 		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
-				iommu_group_id(container->tbl->it_group),
+				iommu_group_id(container->grp),
 				iommu_group_id(iommu_group));
 		ret = -EBUSY;
 	} else if (container->enabled) {
@@ -325,9 +403,16 @@ static int tce_iommu_attach_group(void *iommu_data,
 				iommu_group_id(iommu_group));
 		ret = -EBUSY;
 	} else {
+		data = iommu_group_get_iommudata(iommu_group);
+		if (WARN_ON(!data || !data->iommu_owner || !data->ops))
+			return -ENXIO;
+
+		tbl = data->ops->get_table(data, 0);
+		BUG_ON(!tbl);
+
 		ret = iommu_take_ownership(tbl);
 		if (!ret)
-			container->tbl = tbl;
+			container->grp = iommu_group;
 	}
 
 	mutex_unlock(&container->lock);
@@ -339,24 +424,31 @@ static void tce_iommu_detach_group(void *iommu_data,
 		struct iommu_group *iommu_group)
 {
 	struct tce_container *container = iommu_data;
-	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
+	struct iommu_table *tbl;
+	struct spapr_tce_iommu_group *data;
 
-	BUG_ON(!tbl);
 	mutex_lock(&container->lock);
-	if (tbl != container->tbl) {
+	if (iommu_group != container->grp) {
 		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
 				iommu_group_id(iommu_group),
-				iommu_group_id(tbl->it_group));
+				iommu_group_id(container->grp));
 	} else {
 		if (container->enabled) {
 			pr_warn("tce_vfio: detaching group #%u from enabled container, forcing disable\n",
-					iommu_group_id(tbl->it_group));
+					iommu_group_id(container->grp));
 			tce_iommu_disable(container);
 		}
 
 		/* pr_debug("tce_vfio: detaching group #%u from iommu %p\n",
 				iommu_group_id(iommu_group), iommu_group); */
-		container->tbl = NULL;
+		container->grp = NULL;
+
+		data = iommu_group_get_iommudata(iommu_group);
+		BUG_ON(!data || !data->iommu_owner || !data->ops);
+
+		tbl = data->ops->get_table(data, 0);
+		BUG_ON(!tbl);
+
 		iommu_release_ownership(tbl);
 	}
 	mutex_unlock(&container->lock);
-- 
2.0.0
