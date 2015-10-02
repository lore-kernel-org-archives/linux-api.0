From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v4 4/5] PCI: Handle Enhanced Allocation (EA) capability for SRIOV devices.
Date: Fri,  2 Oct 2015 15:37:55 -0700
Message-ID: <1443825476-26880-5-git-send-email-ddaney.cavm@gmail.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com
Cc: David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

From: David Daney <david.daney@cavium.com>

SRIOV BARs can be specified via EA entries.  Extend the EA parser to
extract the SRIOV BAR resources, and modify sriov_init() to use
resources previously obtained via EA.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/pci/iov.c | 11 +++++++++--
 drivers/pci/pci.c |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ee0ebff..c789e68 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -436,8 +436,15 @@ found:
 	nres = 0;
 	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
 		res = &dev->resource[i + PCI_IOV_RESOURCES];
-		bar64 = __pci_read_base(dev, pci_bar_unknown, res,
-					pos + PCI_SRIOV_BAR + i * 4);
+		/*
+		 * If it is already FIXED, don't change it, something
+		 * (perhaps EA or header fixups) wants it this way.
+		 */
+		if (res->flags & IORESOURCE_PCI_FIXED)
+			bar64 = (res->flags & IORESOURCE_MEM_64) ? 1 : 0;
+		else
+			bar64 = __pci_read_base(dev, pci_bar_unknown, res,
+						pos + PCI_SRIOV_BAR + i * 4);
 		if (!res->flags)
 			continue;
 		if (resource_size(res) & (PAGE_SIZE - 1)) {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 54a0a98..6750edf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2178,6 +2178,11 @@ static struct resource *pci_ea_get_resource(struct pci_dev *dev, u8 bei, u8 prop
 {
 	if (bei <= PCI_EA_BEI_BAR5 && prop <= PCI_EA_P_IO)
 		return &dev->resource[bei];
+#ifdef CONFIG_PCI_IOV
+	else if (bei >= PCI_EA_BEI_VF_BAR0 && bei <= PCI_EA_BEI_VF_BAR5 &&
+		 (prop == PCI_EA_P_VIRT_MEM || prop == PCI_EA_P_VIRT_MEM_PREFETCH))
+		return &dev->resource[PCI_IOV_RESOURCES + bei - PCI_EA_BEI_VF_BAR0];
+#endif
 	else if (bei == PCI_EA_BEI_ROM)
 		return &dev->resource[PCI_ROM_RESOURCE];
 	else
-- 
1.9.1
