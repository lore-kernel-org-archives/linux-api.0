From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v3 2/2] PCI: Add support for Enhanced Allocation devices
Date: Mon, 28 Sep 2015 17:10:39 -0700
Message-ID: <1443485439-12081-3-git-send-email-ddaney.cavm@gmail.com>
References: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com
Cc: David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

From: "Sean O. Stalley" <sean.stalley@intel.com>

Add support for devices using Enhanced Allocation entries instead of BARs.
This patch allows the kernel to parse the EA Extended Capability structure
in PCI configspace and claim the BAR-equivalent resources.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
[david.daney@cavium.com: Added support for bridges and SRIOV]
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/pci/iov.c       |  15 ++-
 drivers/pci/pci.c       | 278 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h       |   4 +
 drivers/pci/probe.c     |  42 +++++++-
 drivers/pci/setup-bus.c |   3 +
 include/linux/pci.h     |   1 +
 6 files changed, 339 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ee0ebff..c034575 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -435,9 +435,20 @@ found:
 
 	nres = 0;
 	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
+		int ea_bar = pci_ea_find_ent_with_bei(dev,
+						      i + PCI_EA_BEI_VF_BAR0);
+
 		res = &dev->resource[i + PCI_IOV_RESOURCES];
-		bar64 = __pci_read_base(dev, pci_bar_unknown, res,
-					pos + PCI_SRIOV_BAR + i * 4);
+
+		if (ea_bar > 0) {
+			if (pci_ea_decode_ent(dev, ea_bar, res))
+				continue;
+			bar64 = (res->flags & IORESOURCE_MEM_64) ? 1 : 0;
+		} else {
+			bar64 = __pci_read_base(dev, pci_bar_unknown, res,
+						pos + PCI_SRIOV_BAR + i * 4);
+		}
+
 		if (!res->flags)
 			continue;
 		if (resource_size(res) & (PAGE_SIZE - 1)) {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6a9a111..7c60b16 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2148,6 +2148,284 @@ void pci_pm_init(struct pci_dev *dev)
 	}
 }
 
+static unsigned long pci_ea_set_flags(struct pci_dev *dev, u8 prop)
+{
+	unsigned long flags = IORESOURCE_PCI_FIXED | IORESOURCE_SIZEALIGN;
+
+	switch (prop) {
+	case PCI_EA_P_MEM:
+	case PCI_EA_P_VIRT_MEM:
+	case PCI_EA_P_BRIDGE_MEM:
+		flags |= IORESOURCE_MEM;
+		break;
+	case PCI_EA_P_MEM_PREFETCH:
+	case PCI_EA_P_VIRT_MEM_PREFETCH:
+	case PCI_EA_P_BRIDGE_MEM_PREFETCH:
+		flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		break;
+	case PCI_EA_P_IO:
+	case PCI_EA_P_BRIDGE_IO:
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
+int pci_ea_decode_ent(struct pci_dev *dev, int offset, struct resource *res)
+{
+	struct resource *r;
+	int i;
+	unsigned long mask;
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
+	mask = IORESOURCE_IO | IORESOURCE_MEM | IORESOURCE_PREFETCH;
+	pci_bus_for_each_resource(dev->bus, r, i) {
+		if (!r)
+			continue;
+		if ((r->flags & mask) == (flags & mask) &&
+		    resource_contains(r, res)) {
+			request_resource(r, res);
+			break;
+		}
+	}
+	if (!res->parent) {
+		if (flags & IORESOURCE_IO)
+			res->parent = &ioport_resource;
+		else
+			res->parent =  &iomem_resource;
+	}
+	return 0;
+out:
+	return -EINVAL;
+}
+
+static int pci_ea_find_ent_with_x(struct pci_dev *dev,
+				  bool (*matcher)(u32, int), int m)
+{
+	int ent_offset;
+	u8 num_ent;
+	u32 dw0;
+
+	if (!dev->ea_cap)
+		return -ENOENT;
+
+	/* determine the number of entries */
+	pci_read_config_byte(dev, dev->ea_cap + PCI_EA_NUM_ENT, &num_ent);
+	num_ent &= PCI_EA_NUM_ENT_MASK;
+
+	ent_offset = dev->ea_cap + PCI_EA_FIRST_ENT;
+	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE)
+		ent_offset += 4;
+
+	while (num_ent) {
+		pci_read_config_dword(dev, ent_offset, &dw0);
+
+		if (matcher(dw0, m))
+			return ent_offset;
+
+		/* Entry size field indicates DWORDs after 1st */
+		ent_offset += ((dw0 & PCI_EA_ES) + 1) << 2;
+		num_ent--;
+	}
+	return -ENOENT;
+}
+
+static bool pci_ea_match_prop(u32 dw0, int prop)
+{
+	return PCI_EA_PP(dw0) == prop || PCI_EA_SP(dw0) == prop;
+}
+
+int pci_ea_find_ent_with_prop(struct pci_dev *dev, int prop)
+{
+	return pci_ea_find_ent_with_x(dev, pci_ea_match_prop, prop);
+}
+
+static bool pci_ea_match_bei(u32 dw0, int bei)
+{
+	return PCI_EA_BEI(dw0) == bei;
+}
+
+int pci_ea_find_ent_with_bei(struct pci_dev *dev, int bei)
+{
+	return pci_ea_find_ent_with_x(dev, pci_ea_match_bei, bei);
+}
+
+/* Read an Enhanced Allocation (EA) entry */
+static int pci_ea_read(struct pci_dev *dev, int offset)
+{
+	struct resource *res;
+	int ent_offset = offset;
+	int ent_size;
+	u32 dw0;
+
+	pci_read_config_dword(dev, ent_offset, &dw0);
+	ent_offset += 4;
+
+	/* Entry size field indicates DWORDs after 1st */
+	ent_size = ((dw0 & PCI_EA_ES) + 1) << 2;
+
+	switch (PCI_EA_PP(dw0)) {
+	case PCI_EA_P_MEM:
+	case PCI_EA_P_MEM_PREFETCH:
+	case PCI_EA_P_IO:
+		break;
+	default:
+		switch (PCI_EA_SP(dw0)) {
+		case PCI_EA_P_MEM:
+		case PCI_EA_P_MEM_PREFETCH:
+		case PCI_EA_P_IO:
+			break;
+		default:
+			goto out;
+		}
+	}
+	if (!(dw0 & PCI_EA_ENABLE)) /* Entry not enabled */
+		goto out;
+
+	res = pci_ea_get_resource(dev, PCI_EA_BEI(dw0));
+	if (!res) {
+		dev_err(&dev->dev, "%s: Unsupported EA entry BEI\n", __func__);
+		goto out;
+	}
+
+	pci_ea_decode_ent(dev, offset, res);
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
+	dev->ea_cap = ea;
+
+	/* determine the number of entries */
+	pci_read_config_byte(dev, ea + PCI_EA_NUM_ENT, &num_ent);
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
index 24ba9dc..80542ac 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -78,6 +78,10 @@ bool pci_dev_keep_suspended(struct pci_dev *dev);
 void pci_config_pm_runtime_get(struct pci_dev *dev);
 void pci_config_pm_runtime_put(struct pci_dev *dev);
 void pci_pm_init(struct pci_dev *dev);
+void pci_ea_init(struct pci_dev *dev);
+int pci_ea_decode_ent(struct pci_dev *dev, int offset, struct resource *res);
+int pci_ea_find_ent_with_prop(struct pci_dev *dev, int prop);
+int pci_ea_find_ent_with_bei(struct pci_dev *dev, int prop);
 void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 void pci_free_cap_save_buffers(struct pci_dev *dev);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 0b2be17..52ae57d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -338,6 +338,7 @@ static void pci_read_bridge_io(struct pci_bus *child)
 	unsigned long io_mask, io_granularity, base, limit;
 	struct pci_bus_region region;
 	struct resource *res;
+	int ea_ent;
 
 	io_mask = PCI_IO_RANGE_MASK;
 	io_granularity = 0x1000;
@@ -348,6 +349,12 @@ static void pci_read_bridge_io(struct pci_bus *child)
 	}
 
 	res = child->resource[0];
+	ea_ent = pci_ea_find_ent_with_prop(dev, PCI_EA_P_BRIDGE_IO);
+	if (ea_ent > 0 && !pci_ea_decode_ent(dev, ea_ent, res)) {
+		dev_dbg(&dev->dev, "  bridge window %pR via EA\n", res);
+		return;
+	}
+
 	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
 	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
 	base = (io_base_lo & io_mask) << 8;
@@ -378,8 +385,14 @@ static void pci_read_bridge_mmio(struct pci_bus *child)
 	unsigned long base, limit;
 	struct pci_bus_region region;
 	struct resource *res;
+	int ea_ent;
 
 	res = child->resource[1];
+	ea_ent = pci_ea_find_ent_with_prop(dev, PCI_EA_P_BRIDGE_MEM);
+	if (ea_ent > 0 && !pci_ea_decode_ent(dev, ea_ent, res)) {
+		dev_dbg(&dev->dev, "  bridge window %pR via EA\n", res);
+		return;
+	}
 	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
 	base = ((unsigned long) mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
@@ -401,8 +414,14 @@ static void pci_read_bridge_mmio_pref(struct pci_bus *child)
 	pci_bus_addr_t base, limit;
 	struct pci_bus_region region;
 	struct resource *res;
+	int ea_ent;
 
 	res = child->resource[2];
+	ea_ent = pci_ea_find_ent_with_prop(dev, PCI_EA_P_BRIDGE_MEM_PREFETCH);
+	if (ea_ent > 0 && !pci_ea_decode_ent(dev, ea_ent, res)) {
+		dev_dbg(&dev->dev, "  bridge window %pR via EA\n", res);
+		return;
+	}
 	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
 	base64 = (mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
@@ -801,8 +820,24 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 
 	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
 	primary = buses & 0xFF;
-	secondary = (buses >> 8) & 0xFF;
-	subordinate = (buses >> 16) & 0xFF;
+	if (dev->ea_cap) {
+		u32 sdw;
+
+		pci_read_config_dword(dev, dev->ea_cap + 4, &sdw);
+		if (sdw & 0xFF)
+			secondary = sdw & 0xFF;
+		else
+			secondary = (buses >> 8) & 0xFF;
+
+		sdw >>= 8;
+		if (sdw & 0xFF)
+			subordinate = sdw & 0xFF;
+		else
+			subordinate = (buses >> 16) & 0xFF;
+	} else {
+		secondary = (buses >> 8) & 0xFF;
+		subordinate = (buses >> 16) & 0xFF;
+	}
 
 	dev_dbg(&dev->dev, "scanning [bus %02x-%02x] behind bridge, pass %d\n",
 		secondary, subordinate, pass);
@@ -1598,6 +1633,9 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 
 static void pci_init_capabilities(struct pci_dev *dev)
 {
+	/* Enhanced Allocation */
+	pci_ea_init(dev);
+
 	/* MSI/MSI-X list */
 	pci_msi_init_pci_dev(dev);
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 508cc56..1158c71 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1026,6 +1026,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	if (!b_res)
 		return -ENOSPC;
 
+	if (b_res->flags & IORESOURCE_PCI_FIXED)
+		return 0; /* Fixed from EA, we cannot change it */
+
 	memset(aligns, 0, sizeof(aligns));
 	max_order = 0;
 	size = 0;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b505b50..41b85ed 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -384,6 +384,7 @@ struct pci_dev {
 	phys_addr_t rom; /* Physical address of ROM if it's not from the BAR */
 	size_t romlen; /* Length of ROM if it's not from the BAR */
 	char *driver_override; /* Driver name to force a match */
+	u8		ea_cap;		/* Enhanced Allocation capability offset */
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
-- 
1.9.1
