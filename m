From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v4 5/5] PCI: Handle Enhanced Allocation (EA) capability for bridges
Date: Fri,  2 Oct 2015 15:37:56 -0700
Message-ID: <1443825476-26880-6-git-send-email-ddaney.cavm@gmail.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com
Cc: David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

From: David Daney <david.daney@cavium.com>

PCI bridges may have their properties be specified via EA entries.

Extend the EA parser to extract the bridge resources, and modify
pci_read_bridge_{io,mmio,mmio_pref}() to use resources previously
obtained via EA.

Save the offset to the EA capability in struct pci_dev, and use it to
easily find the EA bridge subordinate and secondary bus numbers.

When assigning the bridge resources a couple of changes are required
so that the EA obtained IORESOURCE_PCI_FIXED are not resized, and
correctly linked into the resource tree.

1) In pbus_size_mem() do not attempt to resize the bridge resources if
   they are marked as IORESOURCE_PCI_FIXED.

2) In pci_bus_alloc_from_region()for IORESOURCE_PCI_FIXED resources, just
   try to request the resource as is, without attempting to resize it.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/pci/bus.c       |  7 +++++++
 drivers/pci/pci.c       | 13 +++++++++++++
 drivers/pci/probe.c     | 31 +++++++++++++++++++++++++++++--
 drivers/pci/setup-bus.c |  3 +++
 include/linux/pci.h     |  1 +
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 6fbd3f2..0556b33 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -153,6 +153,13 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 		    !(res->flags & IORESOURCE_PREFETCH))
 			continue;
 
+		if (res->flags & IORESOURCE_PCI_FIXED) {
+			/* Cannot change it, just try to claim it. */
+			if (request_resource(r, res))
+				continue;
+			return 0;
+		}
+
 		avail = *r;
 		pci_clip_resource_to_region(bus, &avail, region);
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6750edf..c857632 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2183,6 +2183,17 @@ static struct resource *pci_ea_get_resource(struct pci_dev *dev, u8 bei, u8 prop
 		 (prop == PCI_EA_P_VIRT_MEM || prop == PCI_EA_P_VIRT_MEM_PREFETCH))
 		return &dev->resource[PCI_IOV_RESOURCES + bei - PCI_EA_BEI_VF_BAR0];
 #endif
+	else if (bei == PCI_EA_BEI_BRIDGE)
+		switch (prop) {
+		case PCI_EA_P_BRIDGE_IO:
+			return &dev->resource[PCI_BRIDGE_RESOURCES + 0];
+		case PCI_EA_P_BRIDGE_MEM:
+			return &dev->resource[PCI_BRIDGE_RESOURCES + 1];
+		case PCI_EA_P_BRIDGE_MEM_PREFETCH:
+			return &dev->resource[PCI_BRIDGE_RESOURCES + 2];
+		default:
+			return NULL;
+		}
 	else if (bei == PCI_EA_BEI_ROM)
 		return &dev->resource[PCI_ROM_RESOURCE];
 	else
@@ -2321,6 +2332,8 @@ void pci_ea_init(struct pci_dev *dev)
 	if (!ea)
 		return;
 
+	dev->ea_cap = ea;
+
 	/* determine the number of entries */
 	pci_bus_read_config_byte(dev->bus, dev->devfn, ea + PCI_EA_NUM_ENT,
 					&num_ent);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4293eec..e4bcb0b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -348,6 +348,10 @@ static void pci_read_bridge_io(struct pci_bus *child)
 	}
 
 	res = child->resource[0];
+	if (res->flags & IORESOURCE_PCI_FIXED) {
+		dev_dbg(&dev->dev, "  bridge window %pR (fixed)\n", res);
+		return;
+	}
 	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
 	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
 	base = (io_base_lo & io_mask) << 8;
@@ -380,6 +384,10 @@ static void pci_read_bridge_mmio(struct pci_bus *child)
 	struct resource *res;
 
 	res = child->resource[1];
+	if (res->flags & IORESOURCE_PCI_FIXED) {
+		dev_dbg(&dev->dev, "  bridge window %pR (fixed)\n", res);
+		return;
+	}
 	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
 	base = ((unsigned long) mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
@@ -403,6 +411,10 @@ static void pci_read_bridge_mmio_pref(struct pci_bus *child)
 	struct resource *res;
 
 	res = child->resource[2];
+	if (res->flags & IORESOURCE_PCI_FIXED) {
+		dev_dbg(&dev->dev, "  bridge window %pR (fixed)\n", res);
+		return;
+	}
 	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
 	base64 = (mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
@@ -801,8 +813,23 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 
 	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
 	primary = buses & 0xFF;
-	secondary = (buses >> 8) & 0xFF;
-	subordinate = (buses >> 16) & 0xFF;
+	if (dev->ea_cap) {
+		u32 dw1;
+
+		pci_read_config_dword(dev, dev->ea_cap + 4, &dw1);
+		if (dw1 & 0xFF)
+			secondary = dw1 & 0xFF;
+		else
+			secondary = (buses >> 8) & 0xFF;
+
+		if ((dw1 >> 8) & 0xFF)
+			subordinate = (dw1 >> 8) & 0xFF;
+		else
+			subordinate = (buses >> 16) & 0xFF;
+	} else {
+		secondary = (buses >> 8) & 0xFF;
+		subordinate = (buses >> 16) & 0xFF;
+	}
 
 	dev_dbg(&dev->dev, "scanning [bus %02x-%02x] behind bridge, pass %d\n",
 		secondary, subordinate, pass);
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8f9ed9b..8b8cc32 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1086,6 +1086,9 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 		}
 	}
 
+	if (b_res->flags & IORESOURCE_PCI_FIXED)
+		return 0;
+
 	min_align = calculate_mem_align(aligns, max_order);
 	min_align = max(min_align, window_alignment(bus, b_res->flags));
 	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b505b50..a8a177c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -384,6 +384,7 @@ struct pci_dev {
 	phys_addr_t rom; /* Physical address of ROM if it's not from the BAR */
 	size_t romlen; /* Length of ROM if it's not from the BAR */
 	char *driver_override; /* Driver name to force a match */
+	u8		ea_cap; /* Enhanced Allocation capability offset */
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
-- 
1.9.1
