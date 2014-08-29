From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 07/13] powerpc/powernv: Do not set "read" flag if direction==DMA_NONE
Date: Fri, 29 Aug 2014 17:59:10 +1000
Message-ID: <1409299156-618-8-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Alex Williamson <alex.williamson@redhat.com>, Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Normally a bitmap from the iommu_table is used to track what TCE entry
is in use. Since we are going to use iommu_table without its locks and
do xchg() instead, it becomes essential not to put bits which are not
implied in the direction flag.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index deddcad..ab79e2d 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -628,10 +628,18 @@ static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 	__be64 *tcep, *tces;
 	u64 rpn;
 
-	proto_tce = TCE_PCI_READ; // Read allowed
-
-	if (direction != DMA_TO_DEVICE)
-		proto_tce |= TCE_PCI_WRITE;
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
 
 	tces = tcep = ((__be64 *)tbl->it_base) + index - tbl->it_offset;
 	rpn = __pa(uaddr) >> tbl->it_page_shift;
-- 
2.0.0
