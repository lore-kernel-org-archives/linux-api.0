From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 0/4] PCI: Add support for PCI Enhanced Allocation "BARs"
Date: Wed, 14 Oct 2015 09:26:09 -0700
Message-ID: <561E8221.7070701@caviumnetworks.com>
References: <1444175438-7443-1-git-send-email-ddaney.cavm@gmail.com> <5FE5E296BC647B42A2509AB982F88C1321D86B95@ORSMSX108.amr.corp.intel.com> <20151014161731.GA3029@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014161731.GA3029-KQ5zpJUXklQTH34CoL1+91DQ4js95KgL@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rafal Milecki <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/14/2015 09:17 AM, Sean O. Stalley wrote:
> Signed-off-by: Sean O. Stalley <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>

Thanks a lot Sean.

I think you cannot SOB if the patches are not flowing through you (as=20
may be the case for my two additions).  Perhaps a Tested-by: or=20
Acked-by: would be more appropriate.

> I tested it out with the QEMU EA Patches here:
> 	[https://lists.nongnu.org/archive/html/qemu-devel/2015-07/msg00348.h=
tml]
>
> Also, I found 1 trivial typo in the commit message of PATCH 1/4:
> 	"Signed-off-by: Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>"

Aargh!  I need to be more careful.

In any case, what should be the next course of action?

   A) I receive Tested-by/Acked-by from Sean, and resend the four patch=
es?

   B) Bjorn takes these as is, but fixes the headers as needed.

Bjorn, what do you think?

Thanks,
David Daney


>
> -Sean
>
> On Wed, Oct 07, 2015 at 06:44:52AM -0700, Stalley, Sean wrote:
>> [PATCH 3/4 & 4/4] Acked-by: Sean O. Stalley <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> I won't be able to test it out until next week, but I like how it lo=
oks :)
>>
>> Thanks Again,
>> Sean
>>
>>> -----Original Message-----
>>> From: David Daney [mailto:ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>>> Sent: Tuesday, October 06, 2015 4:51 PM
>>> To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bjorn =
Helgaas;
>>> Michael S. Tsirkin; Rafa=C5=82 Mi=C5=82ecki; linux-api-u79uwXL29TasMV2rI37PzA@public.gmane.org=
org; Stalley, Sean;
>>> yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
>>> Cc: David Daney
>>> Subject: [PATCH v5 0/4] PCI: Add support for PCI Enhanced Allocatio=
n
>>> "BARs"
>>>
>>> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>>
>>> The original patches are from Sean O. Stalley. I made a few tweaks,=
 but feel
>>> that it is substancially Sean's work, so I am keeping the patch set=
 version
>>> numbering scheme going.
>>>
>>> Tested on Cavium ThunderX system with 4 Root Complexes containing 5=
0
>>> devices/bridges provisioned with EA.
>>>
>>> Here is Sean's description of the patches:
>>>
>>> PCI Enhanced Allocation is a new method of allocating MMIO & IO
>>> resources for PCI devices & bridges. It can be used instead of the =
traditional
>>> PCI method of using BARs.
>>>
>>> EA entries are hardware-initialized to a fixed address.
>>> Unlike BARs, regions described by EA are cannot be moved.
>>> Because of this, only devices which are permanently connected to th=
e PCI
>>> bus can use EA. A removable PCI card must not use EA.
>>>
>>> This patchset adds support for using EA entries instead of BARs on =
Root
>>> Complex Integrated Endpoints.
>>>
>>> The Enhanced Allocation ECN is publicly available here:
>>> https://www.pcisig.com/specifications/conventional/ECN_Enhanced_All=
oca
>>> tion_23_Oct_2014_Final.pdf
>>>
>>>
>>> Changes from V1:
>>> 	- Use generic PCI resource claim functions (instead of EA-specific
>>> functions)
>>> 	- Only add support for RCiEPs (instead of all devices).
>>> 	- Removed some debugging messages leftover from early testing.
>>>
>>> Changes from V2 (By David Daney):
>>> 	- Add ea_cap to struct pci_device, to aid in finding the EA capabi=
lity.
>>> 	- Factored EA entity decoding into a separate function.
>>> 	- Add functions to find EA entities by BEI or Property.
>>> 	- Add handling of EA provisioned bridges.
>>> 	- Add handling of EA SRIOV BARs.
>>> 	- Try to assign proper resource parent so that SRIOV device creati=
on
>>> can occur.
>>>
>>> Changes from V3 (By David Daney):
>>> 	- Discarded V3 changes and started over fresh based on Sean's V2.
>>> 	- Add more support/checking for Entry Properties.
>>> 	- Allow EA behind bridges.
>>> 	- Rewrite some error messages.
>>> 	- Add patch 3/5 to prevent resizing, and better handle
>>>            assigning, of fixed EA resources.
>>> 	- Add patch 4/5 to handle EA provisioned SRIOV devices.
>>> 	- Add patch 5/5 to handle EA provisioned bridges.
>>>
>>> Changes from V4 (By David Daney):
>>> 	- Drop patch 5/5 to handle EA provisioned bridges.
>>> 	- Drop cases for bridge resources in 2/5.
>>> 	- Drop unnecessary fallback resource parent handling in 3/5
>>> 	- Small code formatting improvements.
>>>
>>> David Daney (2):
>>>    PCI: Handle IORESOURCE_PCI_FIXED when sizing and assigning resou=
rces.
>>>    PCI: Handle Enhanced Allocation (EA) capability for SRIOV device=
s.
>>>
>>> Sean O. Stalley (2):
>>>    PCI: Add Enhanced Allocation register entries
>>>    PCI: Add support for Enhanced Allocation devices
>>>
>>>   drivers/pci/iov.c             |  11 ++-
>>>   drivers/pci/pci.c             | 189
>>> ++++++++++++++++++++++++++++++++++++++++++
>>>   drivers/pci/pci.h             |   1 +
>>>   drivers/pci/probe.c           |   3 +
>>>   drivers/pci/setup-bus.c       |  50 ++++++++++-
>>>   include/uapi/linux/pci_regs.h |  44 +++++++++-
>>>   6 files changed, 292 insertions(+), 6 deletions(-)
>>>
>>> --
>>> 1.9.1
>>
