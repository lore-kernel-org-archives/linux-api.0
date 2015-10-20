From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v6 1/5] PCI: Handle IORESOURCE_PCI_FIXED when sizing resources.
Date: Tue, 20 Oct 2015 16:04:38 -0700
Message-ID: <1445382282-2396-2-git-send-email-ddaney.cavm@gmail.com>
References: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com
Cc: David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The new Enhanced Allocation (EA) capability support (patches to
follow) creates resources with the IORESOURCE_PCI_FIXED set. Since
these resources cannot be relocated or resized, their alignment is not
really defined, and it is therefore not specified.  This causes a
problem in pbus_size_mem() where resources with unspecified alignment
are disabled.

So, in pbus_size_mem() skip IORESOURCE_PCI_FIXED resources, instead of
disabling them.

Acked-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/pci/setup-bus.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 508cc56..4dfef10 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1037,9 +1037,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			struct resource *r = &dev->resource[i];
 			resource_size_t r_size;
 
-			if (r->parent || ((r->flags & mask) != type &&
-					  (r->flags & mask) != type2 &&
-					  (r->flags & mask) != type3))
+			if (r->parent || (r->flags | IORESOURCE_PCI_FIXED) ||
+			    ((r->flags & mask) != type &&
+			     (r->flags & mask) != type2 &&
+			     (r->flags & mask) != type3))
 				continue;
 			r_size = resource_size(r);
 #ifdef CONFIG_PCI_IOV
-- 
1.9.1
