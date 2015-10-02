From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v4 0/5] PCI: Add support for PCI Enhanced Allocation "BARs"
Date: Fri,  2 Oct 2015 15:37:51 -0700
Message-ID: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, linux-api@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>, yinghai@kernel.org, rajatxjain@gmail.com, gong.chen@linux.intel.com
Cc: David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

From: David Daney <david.daney@cavium.com>

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

David Daney (3):
  PCI: Handle IORESOURCE_PCI_FIXED when sizing and assigning resources.
  PCI: Handle Enhanced Allocation (EA) capability for SRIOV devices.
  PCI: Handle Enhanced Allocation (EA) capability for bridges

Sean O. Stalley (2):
  PCI: Add Enhanced Allocation register entries
  PCI: Add support for Enhanced Allocation devices

 drivers/pci/bus.c             |   7 ++
 drivers/pci/iov.c             |  11 ++-
 drivers/pci/pci.c             | 202 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h             |   1 +
 drivers/pci/probe.c           |  34 ++++++-
 drivers/pci/setup-bus.c       |  63 ++++++++++++-
 include/linux/pci.h           |   1 +
 include/uapi/linux/pci_regs.h |  44 ++++++++-
 8 files changed, 355 insertions(+), 8 deletions(-)

-- 
1.9.1
