From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v6 2/5] PCI: Handle IORESOURCE_PCI_FIXED when assigning resources.
Date: Tue, 20 Oct 2015 16:04:39 -0700
Message-ID: <1445382282-2396-3-git-send-email-ddaney.cavm@gmail.com>
References: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com
Cc: David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The new Enhanced Allocation (EA) capability support (patches to
follow) creates resources with the IORESOURCE_PCI_FIXED set.  During
resource assignment in pci_bus_assign_resources(),
IORESOURCE_PCI_FIXED resources are not given a parent.  This, in turn,
causes pci_enable_resources() to fail with a "not claimed" error.

So, In __pci_bus_assign_resources(), for IORESOURCE_PCI_FIXED resources,
try to request the resource from a parent bus.

Acked-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/pci/setup-bus.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 4dfef10..7239a2c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1341,6 +1341,47 @@ void pci_bus_size_bridges(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
+static void assign_fixed_resource_on_bus(struct pci_bus *b, struct resource *r)
+{
+	int i;
+	struct resource *parent_r;
+	unsigned long mask = IORESOURCE_IO | IORESOURCE_MEM |
+			     IORESOURCE_PREFETCH;
+
+	pci_bus_for_each_resource(b, parent_r, i) {
+		if (!parent_r)
+			continue;
+
+		if ((r->flags & mask) == (parent_r->flags & mask) &&
+		    resource_contains(parent_r, r))
+			request_resource(parent_r, r);
+	}
+}
+
+/*
+ * Try to assign any resources marked as IORESOURCE_PCI_FIXED, as they
+ * are skipped by pbus_assign_resources_sorted().
+ */
+static void pdev_assign_fixed_resources(struct pci_dev *dev)
+{
+	int i;
+
+	for (i = 0; i <  PCI_NUM_RESOURCES; i++) {
+		struct pci_bus *b;
+		struct resource *r = &dev->resource[i];
+
+		if (r->parent || !(r->flags & IORESOURCE_PCI_FIXED) ||
+		    !(r->flags & (IORESOURCE_IO | IORESOURCE_MEM)))
+			continue;
+
+		b = dev->bus;
+		while (b && !r->parent) {
+			assign_fixed_resource_on_bus(b, r);
+			b = b->parent;
+		}
+	}
+}
+
 void __pci_bus_assign_resources(const struct pci_bus *bus,
 				struct list_head *realloc_head,
 				struct list_head *fail_head)
@@ -1351,6 +1392,8 @@ void __pci_bus_assign_resources(const struct pci_bus *bus,
 	pbus_assign_resources_sorted(bus, realloc_head, fail_head);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		pdev_assign_fixed_resources(dev);
+
 		b = dev->subordinate;
 		if (!b)
 			continue;
-- 
1.9.1
