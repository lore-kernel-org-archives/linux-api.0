From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/2] PCI: Add support for Enhanced Allocation devices
Date: Wed, 23 Sep 2015 15:27:44 -0700
Message-ID: <1443047264-4003-3-git-send-email-sean.stalley@intel.com>
References: <1443047264-4003-1-git-send-email-sean.stalley@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443047264-4003-1-git-send-email-sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add support for devices using Enhanced Allocation entries instead of BARs.
This patch allows the kernel to parse the EA Extended Capability structure
in PCI configspace and claim the BAR-equivalent resources.

Signed-off-by: Sean O. Stalley <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/pci/pci.c   | 174 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |   1 +
 drivers/pci/probe.c |   3 +
 3 files changed, 178 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6a9a111..bdf5d37 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2148,6 +2148,180 @@ void pci_pm_init(struct pci_dev *dev)
 	}
 }
 
+static unsigned long pci_ea_set_flags(struct pci_dev *dev, u8 prop)
+{
+	unsigned long flags = IORESOURCE_PCI_FIXED;
+
+	switch (prop) {
+	case PCI_EA_P_MEM:
+		flags |= IORESOURCE_MEM;
+		break;
+	case PCI_EA_P_MEM_PREFETCH:
+		flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		break;
+	case PCI_EA_P_IO:
+		flags |= IORESOURCE_IO;
+		break;
+	default:
+		return 0;
+	}
+
+	return flags;
+}
+
+static struct resource *pci_ea_get_resource(struct pci_dev *dev, u8 bei)
+{
+	if (bei <= PCI_STD_RESOURCE_END)
+		return &dev->resource[bei];
+	else if (bei == PCI_EA_BEI_ROM)
+		return &dev->resource[PCI_ROM_RESOURCE];
+	else
+		return NULL;
+}
+
+/* Read an Enhanced Allocation (EA) entry */
+static int pci_ea_read(struct pci_dev *dev, int offset)
+{
+	struct resource *res;
+	int ent_offset = offset;
+	int ent_size;
+	resource_size_t start;
+	resource_size_t end;
+	unsigned long flags;
+	u32 dw0;
+	u32 base;
+	u32 max_offset;
+	bool support_64 = (sizeof(resource_size_t) >= 8);
+
+	pci_read_config_dword(dev, ent_offset, &dw0);
+	ent_offset += 4;
+
+	/* Entry size field indicates DWORDs after 1st */
+	ent_size = ((dw0 & PCI_EA_ES) + 1) << 2;
+
+	if (!(dw0 & PCI_EA_ENABLE)) /* Entry not enabled */
+		goto out;
+
+	res = pci_ea_get_resource(dev, PCI_EA_BEI(dw0));
+	if (!res) {
+		dev_err(&dev->dev, "%s: Unsupported EA entry BEI\n", __func__);
+		goto out;
+	}
+
+	/* Try to use primary properties, otherwise fall back to secondary */
+	flags = pci_ea_set_flags(dev, PCI_EA_PP(dw0));
+	if (!flags)
+		flags = pci_ea_set_flags(dev, PCI_EA_SP(dw0));
+
+	if (!flags) {
+		dev_err(&dev->dev, "%s: Entry EA properties not supported\n",
+			__func__);
+		goto out;
+	}
+
+	/* Read Base */
+	pci_read_config_dword(dev, ent_offset, &base);
+	start = (base & PCI_EA_FIELD_MASK);
+	ent_offset += 4;
+
+	/* Read MaxOffset */
+	pci_read_config_dword(dev, ent_offset, &max_offset);
+	ent_offset += 4;
+
+	/* Read Base MSBs (if 64-bit entry) */
+	if (base & PCI_EA_IS_64) {
+		u32 base_upper;
+
+		pci_read_config_dword(dev, ent_offset, &base_upper);
+		ent_offset += 4;
+
+		flags |= IORESOURCE_MEM_64;
+
+		/* entry starts above 32-bit boundary, can't use */
+		if (!support_64 && base_upper)
+			goto out;
+
+		if (support_64)
+			start |= ((u64)base_upper << 32);
+	}
+
+	dev_dbg(&dev->dev, "%s: start = %pa\n", __func__, &start);
+
+	end = start + (max_offset | 0x03);
+
+	/* Read MaxOffset MSBs (if 64-bit entry) */
+	if (max_offset & PCI_EA_IS_64) {
+		u32 max_offset_upper;
+
+		pci_read_config_dword(dev, ent_offset, &max_offset_upper);
+		ent_offset += 4;
+
+		flags |= IORESOURCE_MEM_64;
+
+		/* entry too big, can't use */
+		if (!support_64 && max_offset_upper)
+			goto out;
+
+		if (support_64)
+			end += ((u64)max_offset_upper << 32);
+	}
+
+	dev_dbg(&dev->dev, "%s: end = %pa\n", __func__, &end);
+
+	if (end < start) {
+		dev_err(&dev->dev, "EA Entry crosses address boundary\n");
+		goto out;
+	}
+
+	if (ent_size != ent_offset - offset) {
+		dev_err(&dev->dev, "EA entry size does not match length read\n"
+			"(Entry Size:%u Length Read:%u)\n",
+			ent_size, ent_offset - offset);
+		goto out;
+	}
+
+	res->name = pci_name(dev);
+	res->start = start;
+	res->end = end;
+	res->flags = flags;
+
+out:
+	return offset + ent_size;
+}
+
+/* Enhanced Allocation Initalization */
+void pci_ea_init(struct pci_dev *dev)
+{
+	int ea;
+	u8 num_ent;
+	int offset;
+	int i;
+
+	/* find PCI EA capability in list */
+	ea = pci_find_capability(dev, PCI_CAP_ID_EA);
+	if (!ea)
+		return;
+
+	/* Only Support EA for RCiEPs */
+	if (!pci_is_root_bus(dev->bus))
+		return;
+
+	/* determine the number of entries */
+	pci_bus_read_config_byte(dev->bus, dev->devfn, ea + PCI_EA_NUM_ENT,
+					&num_ent);
+	num_ent &= PCI_EA_NUM_ENT_MASK;
+
+	offset = ea + PCI_EA_FIRST_ENT;
+
+	/* Skip DWORD 2 for type 1 functions */
+	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE)
+		offset += 4;
+
+	/* parse each EA entry */
+	for (i = 0; i < num_ent; ++i)
+		offset = pci_ea_read(dev, offset);
+}
+
 static void pci_add_saved_cap(struct pci_dev *pci_dev,
 	struct pci_cap_saved_state *new_cap)
 {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 24ba9dc..a160733 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -78,6 +78,7 @@ bool pci_dev_keep_suspended(struct pci_dev *dev);
 void pci_config_pm_runtime_get(struct pci_dev *dev);
 void pci_config_pm_runtime_put(struct pci_dev *dev);
 void pci_pm_init(struct pci_dev *dev);
+void pci_ea_init(struct pci_dev *dev);
 void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 void pci_free_cap_save_buffers(struct pci_dev *dev);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0b2be17..4293eec 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1598,6 +1598,9 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 
 static void pci_init_capabilities(struct pci_dev *dev)
 {
+	/* Enhanced Allocation */
+	pci_ea_init(dev);
+
 	/* MSI/MSI-X list */
 	pci_msi_init_pci_dev(dev);
 
-- 
1.9.1
