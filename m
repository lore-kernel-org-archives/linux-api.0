From: "Stalley, Sean" <sean.stalley@intel.com>
Subject: RE: [PATCH v5 0/4] PCI: Add support for PCI Enhanced Allocation
 "BARs"
Date: Wed, 7 Oct 2015 13:44:52 +0000
Message-ID: <5FE5E296BC647B42A2509AB982F88C1321D86B95@ORSMSX108.amr.corp.intel.com>
References: <1444175438-7443-1-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444175438-7443-1-git-send-email-ddaney.cavm@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rafal Milecki <zajec5@gmail.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "yinghai@kernel.org" <yinghai@kernel.org>, "rajatxjain@gmail.com" <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>
Cc: David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

[PATCH 3/4 & 4/4] Acked-by: Sean O. Stalley <sean.stalley@intel.com>

I won't be able to test it out until next week, but I like how it looks=
 :)

Thanks Again,
Sean

> -----Original Message-----
> From: David Daney [mailto:ddaney.cavm@gmail.com]
> Sent: Tuesday, October 06, 2015 4:51 PM
> To: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; Bjorn He=
lgaas;
> Michael S. Tsirkin; Rafa=B3 Mi=B3ecki; linux-api@vger.kernel.org; Sta=
lley, Sean;
> yinghai@kernel.org; rajatxjain@gmail.com; gong.chen@linux.intel.com
> Cc: David Daney
> Subject: [PATCH v5 0/4] PCI: Add support for PCI Enhanced Allocation
> "BARs"
>=20
> From: David Daney <david.daney@cavium.com>
>=20
> The original patches are from Sean O. Stalley. I made a few tweaks, b=
ut feel
> that it is substancially Sean's work, so I am keeping the patch set v=
ersion
> numbering scheme going.
>=20
> Tested on Cavium ThunderX system with 4 Root Complexes containing 50
> devices/bridges provisioned with EA.
>=20
> Here is Sean's description of the patches:
>=20
> PCI Enhanced Allocation is a new method of allocating MMIO & IO
> resources for PCI devices & bridges. It can be used instead of the tr=
aditional
> PCI method of using BARs.
>=20
> EA entries are hardware-initialized to a fixed address.
> Unlike BARs, regions described by EA are cannot be moved.
> Because of this, only devices which are permanently connected to the =
PCI
> bus can use EA. A removable PCI card must not use EA.
>=20
> This patchset adds support for using EA entries instead of BARs on Ro=
ot
> Complex Integrated Endpoints.
>=20
> The Enhanced Allocation ECN is publicly available here:
> https://www.pcisig.com/specifications/conventional/ECN_Enhanced_Alloc=
a
> tion_23_Oct_2014_Final.pdf
>=20
>=20
> Changes from V1:
> 	- Use generic PCI resource claim functions (instead of EA-specific
> functions)
> 	- Only add support for RCiEPs (instead of all devices).
> 	- Removed some debugging messages leftover from early testing.
>=20
> Changes from V2 (By David Daney):
> 	- Add ea_cap to struct pci_device, to aid in finding the EA capabili=
ty.
> 	- Factored EA entity decoding into a separate function.
> 	- Add functions to find EA entities by BEI or Property.
> 	- Add handling of EA provisioned bridges.
> 	- Add handling of EA SRIOV BARs.
> 	- Try to assign proper resource parent so that SRIOV device creation
> can occur.
>=20
> Changes from V3 (By David Daney):
> 	- Discarded V3 changes and started over fresh based on Sean's V2.
> 	- Add more support/checking for Entry Properties.
> 	- Allow EA behind bridges.
> 	- Rewrite some error messages.
> 	- Add patch 3/5 to prevent resizing, and better handle
>           assigning, of fixed EA resources.
> 	- Add patch 4/5 to handle EA provisioned SRIOV devices.
> 	- Add patch 5/5 to handle EA provisioned bridges.
>=20
> Changes from V4 (By David Daney):
> 	- Drop patch 5/5 to handle EA provisioned bridges.
> 	- Drop cases for bridge resources in 2/5.
> 	- Drop unnecessary fallback resource parent handling in 3/5
> 	- Small code formatting improvements.
>=20
> David Daney (2):
>   PCI: Handle IORESOURCE_PCI_FIXED when sizing and assigning resource=
s.
>   PCI: Handle Enhanced Allocation (EA) capability for SRIOV devices.
>=20
> Sean O. Stalley (2):
>   PCI: Add Enhanced Allocation register entries
>   PCI: Add support for Enhanced Allocation devices
>=20
>  drivers/pci/iov.c             |  11 ++-
>  drivers/pci/pci.c             | 189
> ++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h             |   1 +
>  drivers/pci/probe.c           |   3 +
>  drivers/pci/setup-bus.c       |  50 ++++++++++-
>  include/uapi/linux/pci_regs.h |  44 +++++++++-
>  6 files changed, 292 insertions(+), 6 deletions(-)
>=20
> --
> 1.9.1
