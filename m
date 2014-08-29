From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 11/13] vfio: powerpc/spapr: Move locked_vm accounting to helpers
Date: Fri, 29 Aug 2014 17:59:14 +1000
Message-ID: <1409299156-618-12-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Alex Williamson <alex.williamson@redhat.com>, Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

There moves locked pages accounting to helpers.
Later they will be reused for Dynamic DMA windows (DDW).

While we are here, update the comment explaining why RLIMIT_MEMLOCK
might be required to be bigger than the guest RAM.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 71 +++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 1c1a9c4..c9fac97 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -29,6 +29,46 @@
 static void tce_iommu_detach_group(void *iommu_data,
 		struct iommu_group *iommu_group);
 
+static long try_increment_locked_vm(struct iommu_table *tbl)
+{
+	long ret = 0, locked, lock_limit, npages;
+
+	if (!current || !current->mm)
+		return -ESRCH; /* process exited */
+
+	npages = (tbl->it_size << IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+	locked = current->mm->locked_vm + npages;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
+		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
+				rlimit(RLIMIT_MEMLOCK));
+		ret = -ENOMEM;
+	} else {
+		current->mm->locked_vm += npages;
+	}
+	up_write(&current->mm->mmap_sem);
+
+	return ret;
+}
+
+static void decrement_locked_vm(struct iommu_table *tbl)
+{
+	long npages;
+
+	if (!current || !current->mm)
+		return; /* process exited */
+
+	npages = (tbl->it_size << IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
+
+	down_write(&current->mm->mmap_sem);
+	if (npages > current->mm->locked_vm)
+		npages = current->mm->locked_vm;
+	current->mm->locked_vm -= npages;
+	up_write(&current->mm->mmap_sem);
+}
+
 /*
  * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
  *
@@ -86,7 +126,6 @@ static void tce_iommu_take_ownership_notify(struct spapr_tce_iommu_group *data,
 static int tce_iommu_enable(struct tce_container *container)
 {
 	int ret = 0;
-	unsigned long locked, lock_limit, npages;
 	struct iommu_table *tbl;
 	struct spapr_tce_iommu_group *data;
 
@@ -120,24 +159,23 @@ static int tce_iommu_enable(struct tce_container *container)
 	 * Also we don't have a nice way to fail on H_PUT_TCE due to ulimits,
 	 * that would effectively kill the guest at random points, much better
 	 * enforcing the limit based on the max that the guest can map.
+	 *
+	 * Unfortunately at the moment it counts whole tables, no matter how
+	 * much memory the guest has. I.e. for 4GB guest and 4 IOMMU groups
+	 * each with 2GB DMA window, 8GB will be counted here. The reason for
+	 * this is that we cannot tell here the amount of RAM used by the guest
+	 * as this information is only available from KVM and VFIO is
+	 * KVM agnostic.
 	 */
 	tbl = data->ops->get_table(data, 0);
 	if (!tbl)
 		return -ENXIO;
 
-	down_write(&current->mm->mmap_sem);
-	npages = (tbl->it_size << IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
-	locked = current->mm->locked_vm + npages;
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
-		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
-				rlimit(RLIMIT_MEMLOCK));
-		ret = -ENOMEM;
-	} else {
-		current->mm->locked_vm += npages;
-		container->enabled = true;
-	}
-	up_write(&current->mm->mmap_sem);
+	ret = try_increment_locked_vm(tbl);
+	if (ret)
+		return ret;
+
+	container->enabled = true;
 
 	return ret;
 }
@@ -163,10 +201,7 @@ static void tce_iommu_disable(struct tce_container *container)
 	if (!tbl)
 		return;
 
-	down_write(&current->mm->mmap_sem);
-	current->mm->locked_vm -= (tbl->it_size <<
-			IOMMU_PAGE_SHIFT_4K) >> PAGE_SHIFT;
-	up_write(&current->mm->mmap_sem);
+	decrement_locked_vm(tbl);
 }
 
 static void *tce_iommu_open(unsigned long arg)
-- 
2.0.0
