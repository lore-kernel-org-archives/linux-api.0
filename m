From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] PCI: Add support for Enhanced Allocation devices
Date: Thu, 20 Aug 2015 09:59:07 -0700
Message-ID: <1440089947-2839-3-git-send-email-sean.stalley@intel.com>
References: <1440089947-2839-1-git-send-email-sean.stalley@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440089947-2839-1-git-send-email-sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add support for devices using Enhanced Allocation entries instead of BARs.
This patch allows the kernel to parse the EA Extended Capability structure
in PCI configspace and claim the BAR-equivalent resources.

Signed-off-by: Sean O. Stalley <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/pci/pci.c   | 219 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h   |   1 +
 drivers/pci/probe.c |   3 +
 3 files changed, 223 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0008c95..c8217a8 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2134,6 +2134,225 @@ void pci_pm_init(struct pci_dev *dev)
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
+		dev_warn(&dev->dev, "%s: Property type %x not supported\n",
+			__func__, prop);
+		return 0;
+	}
+
+	return flags;
+}
+
+static struct resource *pci_ea_get_parent_resource(struct pci_dev *dev,
+					struct resource *res)
+{
+	struct resource *parent;
+
+	parent = pci_find_parent_resource(dev, res);
+	if (parent)
+		return parent;
+
+	/* for resources not claimed by a bridge */
+	if (res->flags & IORESOURCE_MEM)
+		return &iomem_resource;
+
+	if (res->flags & IORESOURCE_IO)
+		return &ioport_resource;
+
+	return NULL;
+}
+
+/* claim the memory for this device in the proper location */
+static void pci_ea_claim_resource(struct pci_dev *dev, struct resource *res)
+{
+	struct resource *parent;
+	struct resource *conflict;
+
+	parent = pci_ea_get_parent_resource(dev, res);
+	if (!parent) {
+		dev_warn(&dev->dev, "can't find parent resource for EA entry %s %pR\n",
+			res->name, res);
+		return;
+	}
+
+	/* claim the appropriate resource */
+	conflict = request_resource_conflict(parent, res);
+	if (conflict) {
+		dev_warn(&dev->dev, "can't claim EA entry %s %pR: address conflict with %s %pR\n",
+			 res->name, res, conflict->name, conflict);
+	}
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
+	if (!(dw0 & PCI_EA_ENABLE)) {
+		dev_err(&dev->dev, "%s: Entry not enabled\n", __func__);
+		goto out;
+	}
+
+	res = pci_ea_get_resource(dev, PCI_EA_BEI(dw0));
+	if (!res) {
+		dev_err(&dev->dev, "%s: Unsupported EA entry BEI\n", __func__);
+		goto out;
+	}
+
+	flags = pci_ea_set_flags(dev, PCI_EA_PP(dw0));
+	if (!flags)
+		flags = pci_ea_set_flags(dev, PCI_EA_SP(dw0));
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
+	pci_ea_claim_resource(dev, res);
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
+	dev_dbg(&dev->dev, "%s: capability found!\n", __func__);
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
+		/* TODO: Support fixed bus numbers */
+
+	for (i = 0; i < num_ent; ++i) {
+		/* parse each EA entry */
+		dev_dbg(&dev->dev, "%s: parsing entry %i...\n", __func__, i);
+		offset = pci_ea_read(dev, offset);
+	}
+}
+
 static void pci_add_saved_cap(struct pci_dev *pci_dev,
 	struct pci_cap_saved_state *new_cap)
 {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4ff0ff1..92fbef0 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -76,6 +76,7 @@ bool pci_dev_keep_suspended(struct pci_dev *dev);
 void pci_config_pm_runtime_get(struct pci_dev *dev);
 void pci_config_pm_runtime_put(struct pci_dev *dev);
 void pci_pm_init(struct pci_dev *dev);
+void pci_ea_init(struct pci_dev *dev);
 void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 void pci_free_cap_save_buffers(struct pci_dev *dev);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cefd636..4cadf35 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1522,6 +1522,9 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 
 static void pci_init_capabilities(struct pci_dev *dev)
 {
+	/* Enhanced Allocation */
+	pci_ea_init(dev);
+
 	/* MSI/MSI-X list */
 	pci_msi_init_pci_dev(dev);
 
-- 
1.9.1
