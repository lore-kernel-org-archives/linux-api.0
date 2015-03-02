From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v4 1/5] vfio: implement iommu driver capabilities with an enum
Date: Mon,  2 Mar 2015 17:58:23 +0100
Message-ID: <1425315507-29661-2-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1425315507-29661-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: iommu@lists.linux-foundation.org, kvmarm@lists.cs.columbia.edu
Cc: "open list:VFIO DRIVER" <kvm@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, tech@virtualopensystems.com
List-Id: linux-api@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Currently a VFIO driver's IOMMU capabilities are encoded as a series of
numerical defines. Replace this with an enum for future maintainability.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 include/uapi/linux/vfio.h | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 82889c3..5fb3d46 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -19,22 +19,20 @@
 
 /* Kernel & User level defines for VFIO IOCTLs. */
 
-/* Extensions */
-
-#define VFIO_TYPE1_IOMMU		1
-#define VFIO_SPAPR_TCE_IOMMU		2
-#define VFIO_TYPE1v2_IOMMU		3
 /*
- * IOMMU enforces DMA cache coherence (ex. PCIe NoSnoop stripping).  This
- * capability is subject to change as groups are added or removed.
+ * Capabilities exposed by the VFIO IOMMU driver. Some capabilities are subject
+ * to change as groups are added or removed.
  */
-#define VFIO_DMA_CC_IOMMU		4
-
-/* Check if EEH is supported */
-#define VFIO_EEH			5
+enum vfio_iommu_cap {
+	VFIO_TYPE1_IOMMU = 1,
+	VFIO_SPAPR_TCE_IOMMU = 2,
+	VFIO_TYPE1v2_IOMMU = 3,
+	VFIO_DMA_CC_IOMMU = 4,		/* IOMMU enforces DMA cache coherence
+					   (ex. PCIe NoSnoop stripping) */
+	VFIO_EEH = 5,			/* Check if EEH is supported */
+	VFIO_TYPE1_NESTING_IOMMU = 6,	/* Two-stage IOMMU, implies v2  */
+};
 
-/* Two-stage IOMMU */
-#define VFIO_TYPE1_NESTING_IOMMU	6	/* Implies v2 */
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the
-- 
2.3.1
