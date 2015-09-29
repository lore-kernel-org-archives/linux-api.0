From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/2] PCI: Add support for PCI Enhanced Allocation "BARs"
Date: Mon, 28 Sep 2015 17:10:37 -0700
Message-ID: <1443485439-12081-1-git-send-email-ddaney.cavm@gmail.com>
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


Sean O. Stalley (2):
  PCI: Add Enhanced Allocation register entries
  PCI: Add support for Enhanced Allocation devices

 drivers/pci/iov.c             |  15 ++-
 drivers/pci/pci.c             | 278 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h             |   4 +
 drivers/pci/probe.c           |  42 ++++++-
 drivers/pci/setup-bus.c       |   3 +
 include/linux/pci.h           |   1 +
 include/uapi/linux/pci_regs.h |  42 ++++++-
 7 files changed, 380 insertions(+), 5 deletions(-)

-- 
1.9.1
