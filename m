From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v6 0/5] PCI: Add support for PCI Enhanced Allocation "BARs"
Date: Tue, 20 Oct 2015 16:04:37 -0700
Message-ID: <1445382282-2396-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

The original patches are from Sean O. Stalley. I made a few tweaks,
but feel that it is substancially Sean's work, so I am keeping the
patch set version numbering scheme going.

Tested on Cavium ThunderX system with 4 Root Complexes containing 50
devices/bridges provisioned with EA.

Here is Sean's description of the patches:

PCI Enhanced Allocation is a new method of allocating MMIO & IO
resources for PCI devices & bridges. It can be used instead
of the traditional PCI method of using BARs.

EA entries are hardware-initialized to a fixed address.
Unlike BARs, regions described by EA are cannot be moved.
Because of this, only devices which are permanently connected to
the PCI bus can use EA. A removable PCI card must not use EA.

This patchset adds support for using EA entries instead of BARs
on Root Complex Integrated Endpoints.

The Enhanced Allocation ECN is publicly available here:
https://www.pcisig.com/specifications/conventional/ECN_Enhanced_Allocation_23_Oct_2014_Final.pdf


Changes from V1:
	- Use generic PCI resource claim functions (instead of EA-specific functions)
	- Only add support for RCiEPs (instead of all devices).
	- Removed some debugging messages leftover from early testing.

Changes from V2 (By David Daney):
	- Add ea_cap to struct pci_device, to aid in finding the EA capability.
	- Factored EA entity decoding into a separate function.
	- Add functions to find EA entities by BEI or Property.
	- Add handling of EA provisioned bridges.
	- Add handling of EA SRIOV BARs.
	- Try to assign proper resource parent so that SRIOV device creation can occur.

Changes from V3 (By David Daney):
	- Discarded V3 changes and started over fresh based on Sean's V2.
	- Add more support/checking for Entry Properties.
	- Allow EA behind bridges.
	- Rewrite some error messages.
	- Add patch 3/5 to prevent resizing, and better handle
          assigning, of fixed EA resources.
	- Add patch 4/5 to handle EA provisioned SRIOV devices.
	- Add patch 5/5 to handle EA provisioned bridges.

Changes from V4 (By David Daney):
	- Drop patch 5/5 to handle EA provisioned bridges.
	- Drop cases for bridge resources in 2/5.
	- Drop unnecessary fallback resource parent handling in 3/5
	- Small code formatting improvements.

Changes from V5: (By David Daney) cosmetic only, as requested by Bjorn Helgaas:
	- Split previous 3/4 into two patches, which are now 1/5 and 2/5
	- Improve indentation of register definitions.
	- Renamed PCI_EA_P_VIRT_MEM* to PCI_EA_P_VF_MEM*
	- Remove use of BIT() macro from register definitions.
	- Changed debug messages when probing EA entries to be like this:
.
.
.
pci 0002:01:00.0: [177d:a01e] type 00 class 0x020000
pci 0002:01:00.0: EA - BEI  0, Prop 0x00: [mem 0x843000000000-0x84303fffffff 64bit]
pci 0002:01:00.0: EA - BEI  4, Prop 0x00: [mem 0x843060000000-0x8430600fffff 64bit]
pci 0002:01:00.0: EA - BEI  9, Prop 0x04: [mem 0x8430a0000000-0x8430a01fffff 64bit]
pci 0002:01:00.0: EA - BEI 13, Prop 0x04: [mem 0x8430e0000000-0x8430e01fffff 64bit]
pci 0002:01:00.0: VF(n) BAR0 space: [mem 0x8430a0000000-0x8430afffffff 64bit] (contains BAR0 for 128 VFs)
pci 0002:01:00.0: VF(n) BAR4 space: [mem 0x8430e0000000-0x8430efffffff 64bit] (contains BAR4 for 128 VFs)
.
.
.
pci 0004:21:00.0: [1a03:2000] type 00 class 0x030000
pci 0004:21:00.0: reg 0x10: [mem 0x881010000000-0x881010ffffff]
pci 0004:21:00.0: reg 0x14: [mem 0x881011000000-0x88101101ffff]
pci 0004:21:00.0: reg 0x18: [io  0x0000-0x007f]
pci 0004:21:00.0: supports D1 D2
.
.
.

BEI and Prop values are represented as decimal and hexadecimal
respectively to match the EA specification.

David Daney (3):
  PCI: Handle IORESOURCE_PCI_FIXED when sizing resources.
  PCI: Handle IORESOURCE_PCI_FIXED when assigning resources.
  PCI: Handle Enhanced Allocation (EA) capability for SRIOV devices.

Sean O. Stalley (2):
  PCI: Add Enhanced Allocation register entries
  PCI: Add support for Enhanced Allocation devices

 drivers/pci/iov.c             |  11 ++-
 drivers/pci/pci.c             | 183 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h             |   1 +
 drivers/pci/probe.c           |   3 +
 drivers/pci/setup-bus.c       |  50 +++++++++++-
 include/uapi/linux/pci_regs.h |  44 +++++++++-
 6 files changed, 286 insertions(+), 6 deletions(-)

-- 
1.9.1
