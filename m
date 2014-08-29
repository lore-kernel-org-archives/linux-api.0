From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 05/13] powerpc/iommu: Fix IOMMU ownership control functions
Date: Fri, 29 Aug 2014 17:59:08 +1000
Message-ID: <1409299156-618-6-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Alex Williamson <alex.williamson@redhat.com>, Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds missing locks in iommu_take_ownership()/
iommu_release_ownership().

This marks all pages busy in iommu_table::it_map in order to catch
errors if there is an attempt to use this table while ownership over it
is taken.

This only clears TCE content if there is no page marked busy in it_map.
Clearing must be done outside of the table locks as iommu_clear_tce()
called from iommu_clear_tces_and_put_pages() does this.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kernel/iommu.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index c2c8d9d..cd80867 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1126,33 +1126,55 @@ EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
 
 int iommu_take_ownership(struct iommu_table *tbl)
 {
-	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+	int ret = 0, bit0 = 0;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock(&tbl->pools[i].lock);
 
 	if (tbl->it_offset == 0)
-		clear_bit(0, tbl->it_map);
+		bit0 = test_and_clear_bit(0, tbl->it_map);
 
 	if (!bitmap_empty(tbl->it_map, tbl->it_size)) {
 		pr_err("iommu_tce: it_map is not empty");
-		return -EBUSY;
+		ret = -EBUSY;
+		if (bit0)
+			set_bit(0, tbl->it_map);
+	} else {
+		memset(tbl->it_map, 0xff, sz);
 	}
 
-	memset(tbl->it_map, 0xff, sz);
-	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 
-	return 0;
+	if (!ret)
+		iommu_clear_tces_and_put_pages(tbl, tbl->it_offset,
+				tbl->it_size);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_take_ownership);
 
 void iommu_release_ownership(struct iommu_table *tbl)
 {
-	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
 
 	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock(&tbl->pools[i].lock);
+
 	memset(tbl->it_map, 0, sz);
 
 	/* Restore bit#0 set by iommu_init_table() */
 	if (tbl->it_offset == 0)
 		set_bit(0, tbl->it_map);
+
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 }
 EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
-- 
2.0.0
