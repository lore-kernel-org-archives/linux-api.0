From: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH v4 0/5] PCI: Add support for PCI Enhanced Allocation "BARs"
Date: Mon, 05 Oct 2015 18:17:20 -0700
Message-ID: <56132120.3060900@gmail.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com> <CAE9FiQXT0ux42gQ+DhpVv2K=BR4jC++LmNdCSLiK4Wy0BhL=HQ@mail.gmail.com> <20151005230505.GD4821@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20151005230505.GD4821@sean.stalley.intel.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Sean O. Stalley" <sean.stalley@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, Rajat Jain <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On 10/05/2015 04:05 PM, Sean O. Stalley wrote:
> On Fri, Oct 02, 2015 at 08:16:48PM -0700, Yinghai Lu wrote:
>> On Fri, Oct 2, 2015 at 3:37 PM, David Daney <ddaney.cavm@gmail.com> =
wrote:
>>> From: David Daney <david.daney@cavium.com>
>>>
>>> PCI Enhanced Allocation is a new method of allocating MMIO & IO
>>> resources for PCI devices & bridges. It can be used instead
>>> of the traditional PCI method of using BARs.
>>>
>>> EA entries are hardware-initialized to a fixed address.
>>> Unlike BARs, regions described by EA are cannot be moved.
>>> Because of this, only devices which are permanently connected to
>>> the PCI bus can use EA. A removable PCI card must not use EA.
>>>
>>> The Enhanced Allocation ECN is publicly available here:
>>> https://www.pcisig.com/specifications/conventional/ECN_Enhanced_All=
ocation_23_Oct_2014_Final.pdf
>>
>> Looks like the EA will support more than just fixed address later.
>>
>> "Enhanced Allocation is an optional Conventional PCI Capability that
>> may be implemented by
>> Functions to indicate fixed (non reprogrammable) I/O and memory rang=
es
>> assigned to the
>> Function, as well as supporting new resource =E2=80=9Ctype=E2=80=9D =
definitions and
>> future extensibility to also
>> support reprogrammable allocations."
>>
>> so I would prefer to think more to make frame configurable to leave
>> space for that.
>>
>> Bjorn,
>>
>> I wonder if we need to revive the add-on resource support patchset
>> that i suggested couple years ago,
>> so we can extend it to support EA features.
>>
>> URL: https://lkml.org/lkml/2012/3/19/86
>>
>> Thanks
>>
>> Yinghai
>
> This might be useful for fixed resources as well.
>
> For some BEI values, EA allows for an arbitrary number of EA entries.

I think this is true only for BEI =3D 6 which is for type-1 config spac=
e=20
only (i.e. for bridges)

I am thinking about splitting out the bridge part of the patch set, as=20
my systems work fine without explicitly assigning bridge resources via=20
EA.  That would allow us to more forward with the patches that are less=
=20
controversial, and spend more time hashing out the proper approach to=20
take with bridges.

> For PF & VF resource ranges, it allows 2 ranges.

I don't really understand what you are saying here.  My reading of the=20
spec. is that BEI[0..5] are PF BARs and each may have any of the=20
properties that are allowed for normal BARs (io, memory-nonprefetchable=
,=20
memory-prefetchable).  BEI[9..14] are VF BARs, and likewise may have an=
y=20
of the properties that are alloed for normal VF bars=20
(memory-nonprefetchable, memory-prefetchable)

I guess in theory EA allows you to allocate 6 64-bit BARs, where you=20
would be limited to only 3 64-bit normal BARs


> (one below the 4GB boundry, and one above).
> I don't think the current pci_dev struct can handle that many resourc=
es.
>
> -Sean
>
