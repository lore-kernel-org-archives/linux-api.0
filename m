From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 0/5] PCI: Add support for PCI Enhanced Allocation
 "BARs"
Date: Wed, 21 Oct 2015 10:14:59 -0500
Message-ID: <20151021151459.GA1583@localhost>
References: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 04:04:37PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> The original patches are from Sean O. Stalley. I made a few tweaks,
> but feel that it is substancially Sean's work, so I am keeping the
> patch set version numbering scheme going.
> 
> Tested on Cavium ThunderX system with 4 Root Complexes containing 50
> devices/bridges provisioned with EA.
> 
> Here is Sean's description of the patches:
> 
> PCI Enhanced Allocation is a new method of allocating MMIO & IO
> resources for PCI devices & bridges. It can be used instead
> of the traditional PCI method of using BARs.
> 
> EA entries are hardware-initialized to a fixed address.
> Unlike BARs, regions described by EA are cannot be moved.
> Because of this, only devices which are permanently connected to
> the PCI bus can use EA. A removable PCI card must not use EA.
> 
> This patchset adds support for using EA entries instead of BARs
> on Root Complex Integrated Endpoints.
> 
> The Enhanced Allocation ECN is publicly available here:
> https://www.pcisig.com/specifications/conventional/ECN_Enhanced_Allocation_23_Oct_2014_Final.pdf
> 
> 
> Changes from V1:
> 	- Use generic PCI resource claim functions (instead of EA-specific functions)
> 	- Only add support for RCiEPs (instead of all devices).
> 	- Removed some debugging messages leftover from early testing.
> 
> Changes from V2 (By David Daney):
> 	- Add ea_cap to struct pci_device, to aid in finding the EA capability.
> 	- Factored EA entity decoding into a separate function.
> 	- Add functions to find EA entities by BEI or Property.
> 	- Add handling of EA provisioned bridges.
> 	- Add handling of EA SRIOV BARs.
> 	- Try to assign proper resource parent so that SRIOV device creation can occur.
> 
> Changes from V3 (By David Daney):
> 	- Discarded V3 changes and started over fresh based on Sean's V2.
> 	- Add more support/checking for Entry Properties.
> 	- Allow EA behind bridges.
> 	- Rewrite some error messages.
> 	- Add patch 3/5 to prevent resizing, and better handle
>           assigning, of fixed EA resources.
> 	- Add patch 4/5 to handle EA provisioned SRIOV devices.
> 	- Add patch 5/5 to handle EA provisioned bridges.
> 
> Changes from V4 (By David Daney):
> 	- Drop patch 5/5 to handle EA provisioned bridges.
> 	- Drop cases for bridge resources in 2/5.
> 	- Drop unnecessary fallback resource parent handling in 3/5
> 	- Small code formatting improvements.
> 
> Changes from V5: (By David Daney) cosmetic only, as requested by Bjorn Helgaas:
> 	- Split previous 3/4 into two patches, which are now 1/5 and 2/5
> 	- Improve indentation of register definitions.
> 	- Renamed PCI_EA_P_VIRT_MEM* to PCI_EA_P_VF_MEM*
> 	- Remove use of BIT() macro from register definitions.
> 	- Changed debug messages when probing EA entries to be like this:
> .
> .
> .
> pci 0002:01:00.0: [177d:a01e] type 00 class 0x020000
> pci 0002:01:00.0: EA - BEI  0, Prop 0x00: [mem 0x843000000000-0x84303fffffff 64bit]
> pci 0002:01:00.0: EA - BEI  4, Prop 0x00: [mem 0x843060000000-0x8430600fffff 64bit]
> pci 0002:01:00.0: EA - BEI  9, Prop 0x04: [mem 0x8430a0000000-0x8430a01fffff 64bit]
> pci 0002:01:00.0: EA - BEI 13, Prop 0x04: [mem 0x8430e0000000-0x8430e01fffff 64bit]
> pci 0002:01:00.0: VF(n) BAR0 space: [mem 0x8430a0000000-0x8430afffffff 64bit] (contains BAR0 for 128 VFs)
> pci 0002:01:00.0: VF(n) BAR4 space: [mem 0x8430e0000000-0x8430efffffff 64bit] (contains BAR4 for 128 VFs)
> .
> .
> .
> pci 0004:21:00.0: [1a03:2000] type 00 class 0x030000
> pci 0004:21:00.0: reg 0x10: [mem 0x881010000000-0x881010ffffff]
> pci 0004:21:00.0: reg 0x14: [mem 0x881011000000-0x88101101ffff]
> pci 0004:21:00.0: reg 0x18: [io  0x0000-0x007f]
> pci 0004:21:00.0: supports D1 D2
> .
> .
> .
> 
> BEI and Prop values are represented as decimal and hexadecimal
> respectively to match the EA specification.
> 
> David Daney (3):
>   PCI: Handle IORESOURCE_PCI_FIXED when sizing resources.
>   PCI: Handle IORESOURCE_PCI_FIXED when assigning resources.
>   PCI: Handle Enhanced Allocation (EA) capability for SRIOV devices.
> 
> Sean O. Stalley (2):
>   PCI: Add Enhanced Allocation register entries
>   PCI: Add support for Enhanced Allocation devices
> 
>  drivers/pci/iov.c             |  11 ++-
>  drivers/pci/pci.c             | 183 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h             |   1 +
>  drivers/pci/probe.c           |   3 +
>  drivers/pci/setup-bus.c       |  50 +++++++++++-
>  include/uapi/linux/pci_regs.h |  44 +++++++++-
>  6 files changed, 286 insertions(+), 6 deletions(-)

Applied to pci/enhanced-allocation for v4.4, thanks, David!

I tweaked a couple trivial things and added a couple almost trivial patches
on top.  Here are the additions; let me know if you see anything wrong.

Bjorn


commit 6457d085fade7d96a3aa6c5dca848fd82b4a4fa4
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Wed Oct 21 09:34:15 2015 -0500

    PCI: Make Enhanced Allocation bitmasks more obvious
    
    Expand bitmask #defines completely.  This puts the shift in the code
    instead of in the #define, but it makes it more obvious in the header file
    how fields in the register are laid out.
    
    No functional change.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 364f98b..e8330b6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2195,7 +2195,7 @@ static int pci_ea_read(struct pci_dev *dev, int offset)
 	int ent_size, ent_offset = offset;
 	resource_size_t start, end;
 	unsigned long flags;
-	u32 dw0, base, max_offset;
+	u32 dw0, bei, base, max_offset;
 	u8 prop;
 	bool support_64 = (sizeof(resource_size_t) >= 8);
 
@@ -2208,20 +2208,21 @@ static int pci_ea_read(struct pci_dev *dev, int offset)
 	if (!(dw0 & PCI_EA_ENABLE)) /* Entry not enabled */
 		goto out;
 
-	prop = PCI_EA_PP(dw0);
+	bei = (dw0 & PCI_EA_BEI) >> 4;
+	prop = (dw0 & PCI_EA_PP) >> 8;
+
 	/*
 	 * If the Property is in the reserved range, try the Secondary
 	 * Property instead.
 	 */
 	if (prop > PCI_EA_P_BRIDGE_IO && prop < PCI_EA_P_MEM_RESERVED)
-		prop = PCI_EA_SP(dw0);
+		prop = (dw0 & PCI_EA_SP) >> 16;
 	if (prop > PCI_EA_P_BRIDGE_IO)
 		goto out;
 
-	res = pci_ea_get_resource(dev, PCI_EA_BEI(dw0), prop);
+	res = pci_ea_get_resource(dev, bei, prop);
 	if (!res) {
-		dev_err(&dev->dev, "Unsupported EA entry BEI: %u\n",
-			PCI_EA_BEI(dw0));
+		dev_err(&dev->dev, "Unsupported EA entry BEI: %u\n", bei);
 		goto out;
 	}
 
@@ -2293,7 +2294,7 @@ static int pci_ea_read(struct pci_dev *dev, int offset)
 	res->end = end;
 	res->flags = flags;
 	dev_printk(KERN_DEBUG, &dev->dev, "EA - BEI %2u, Prop 0x%02x: %pR\n",
-		   PCI_EA_BEI(dw0), prop, res);
+		   bei, prop, res);
 out:
 	return offset + ent_size;
 }
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index f890876..1becea8 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -361,7 +361,7 @@
 #define PCI_EA_FIRST_ENT	4	/* First EA Entry in List */
 #define PCI_EA_FIRST_ENT_BRIDGE	8	/* First EA Entry for Bridges */
 #define  PCI_EA_ES		0x00000007 /* Entry Size */
-#define  PCI_EA_BEI(x)	(((x) >> 4) & 0xf) /* BAR Equivalent Indicator */
+#define  PCI_EA_BEI		0x000000f0 /* BAR Equivalent Indicator */
 /* 0-5 map to BARs 0-5 respectively */
 #define   PCI_EA_BEI_BAR0		0
 #define   PCI_EA_BEI_BAR5		5
@@ -372,8 +372,8 @@
 #define   PCI_EA_BEI_VF_BAR0		9
 #define   PCI_EA_BEI_VF_BAR5		14
 #define   PCI_EA_BEI_RESERVED		15	/* Reserved - Treat like ENI */
-#define  PCI_EA_PP(x)	(((x) >>  8) & 0xff)	/* Primary Properties */
-#define  PCI_EA_SP(x)	(((x) >> 16) & 0xff)	/* Secondary Properties */
+#define  PCI_EA_PP		0x0000ff00	/* Primary Properties */
+#define  PCI_EA_SP		0x00ff0000	/* Secondary Properties */
 #define   PCI_EA_P_MEM			0x00	/* Non-Prefetch Memory */
 #define   PCI_EA_P_MEM_PREFETCH		0x01	/* Prefetchable Memory */
 #define   PCI_EA_P_IO			0x02	/* I/O Space */

commit 6985dcc83d70f019523ba9ff499898261f33c937
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Wed Oct 21 09:53:39 2015 -0500

    PCI: Expand Enhanced Allocation BAR output
    
    An Enhanced Allocation Capability entry with BEI 0 fills in
    dev->resource[0] just like a real BAR 0 would, but non-EA experts might not
    connect "EA - BEI 0" with BAR 0.
    
    Decode the EA jargon a little bit, e.g., change this:
    
      pci 0002:01:00.0: EA - BEI  0, Prop 0x00: [mem 0x84300000-0x84303fff]
    
    to this:
    
      pci 0002:01:00.0: BAR 0: [mem 0x84300000-0x84303fff] (from Enhanced Allocation, properties 0x00)
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e8330b6..3a1454e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2293,8 +2293,20 @@ static int pci_ea_read(struct pci_dev *dev, int offset)
 	res->start = start;
 	res->end = end;
 	res->flags = flags;
-	dev_printk(KERN_DEBUG, &dev->dev, "EA - BEI %2u, Prop 0x%02x: %pR\n",
-		   bei, prop, res);
+
+	if (bei <= PCI_EA_BEI_BAR5)
+		dev_printk(KERN_DEBUG, &dev->dev, "BAR %d: %pR (from Enhanced Allocation, properties %#02x)\n",
+			   bei, res, prop);
+	else if (bei == PCI_EA_BEI_ROM)
+		dev_printk(KERN_DEBUG, &dev->dev, "ROM: %pR (from Enhanced Allocation, properties %#02x)\n",
+			   res, prop);
+	else if (bei >= PCI_EA_BEI_VF_BAR0 && bei <= PCI_EA_BEI_VF_BAR5)
+		dev_printk(KERN_DEBUG, &dev->dev, "VF BAR %d: %pR (from Enhanced Allocation, properties %#02x)\n",
+			   bei - PCI_EA_BEI_VF_BAR0, res, prop);
+	else
+		dev_printk(KERN_DEBUG, &dev->dev, "BEI %d res: %pR (from Enhanced Allocation, properties %#02x)\n",
+			   bei, res, prop);
+
 out:
 	return offset + ent_size;
 }
