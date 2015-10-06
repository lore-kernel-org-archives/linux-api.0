From: "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH v4 0/5] PCI: Add support for PCI Enhanced Allocation
 "BARs"
Date: Tue, 6 Oct 2015 08:47:47 -0700
Message-ID: <20151006154747.GA2559@sean.stalley.intel.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
 <CAE9FiQXT0ux42gQ+DhpVv2K=BR4jC++LmNdCSLiK4Wy0BhL=HQ@mail.gmail.com>
 <20151005230505.GD4821@sean.stalley.intel.com>
 <56132120.3060900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56132120.3060900@gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, linux-api@vger.kernel.org, Rajat Jain <rajatxjain@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, David Daney <david.daney@cavium.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 05, 2015 at 06:17:20PM -0700, David Daney wrote:
> On 10/05/2015 04:05 PM, Sean O. Stalley wrote:
> >On Fri, Oct 02, 2015 at 08:16:48PM -0700, Yinghai Lu wrote:
> >>On Fri, Oct 2, 2015 at 3:37 PM, David Daney <ddaney.cavm@gmail.com>=
 wrote:
> >>>From: David Daney <david.daney@cavium.com>
> >>>
> >>>PCI Enhanced Allocation is a new method of allocating MMIO & IO
> >>>resources for PCI devices & bridges. It can be used instead
> >>>of the traditional PCI method of using BARs.
> >>>
> >>>EA entries are hardware-initialized to a fixed address.
> >>>Unlike BARs, regions described by EA are cannot be moved.
> >>>Because of this, only devices which are permanently connected to
> >>>the PCI bus can use EA. A removable PCI card must not use EA.
> >>>
> >>>The Enhanced Allocation ECN is publicly available here:
> >>>https://www.pcisig.com/specifications/conventional/ECN_Enhanced_Al=
location_23_Oct_2014_Final.pdf
> >>
> >>Looks like the EA will support more than just fixed address later.
> >>
> >>"Enhanced Allocation is an optional Conventional PCI Capability tha=
t
> >>may be implemented by
> >>Functions to indicate fixed (non reprogrammable) I/O and memory ran=
ges
> >>assigned to the
> >>Function, as well as supporting new resource =E2=80=9Ctype=E2=80=9D=
 definitions and
> >>future extensibility to also
> >>support reprogrammable allocations."
> >>
> >>so I would prefer to think more to make frame configurable to leave
> >>space for that.
> >>
> >>Bjorn,
> >>
> >>I wonder if we need to revive the add-on resource support patchset
> >>that i suggested couple years ago,
> >>so we can extend it to support EA features.
> >>
> >>URL: https://lkml.org/lkml/2012/3/19/86
> >>
> >>Thanks
> >>
> >>Yinghai
> >
> >This might be useful for fixed resources as well.
> >
> >For some BEI values, EA allows for an arbitrary number of EA entries=
=2E
>=20
> I think this is true only for BEI =3D 6 which is for type-1 config
> space only (i.e. for bridges)

It's true for a BEI of 6 or 7.

=46rom the ECN (specifically section 6.9.1.3):

Rules for use of BEI field:
	...
	It is permitted for an arbitrary number of entries to assign a BEI of =
6 or 7.

> I am thinking about splitting out the bridge part of the patch set,
> as my systems work fine without explicitly assigning bridge
> resources via EA.  That would allow us to more forward with the
> patches that are less controversial, and spend more time hashing out
> the proper approach to take with bridges.

I like this idea. Adding support for Endpoints will be much simpler tha=
n
bridges.

>=20
> >For PF & VF resource ranges, it allows 2 ranges.
>=20
> I don't really understand what you are saying here.  My reading of
> the spec. is that BEI[0..5] are PF BARs and each may have any of the
> properties that are allowed for normal BARs (io,
> memory-nonprefetchable, memory-prefetchable).  BEI[9..14] are VF
> BARs, and likewise may have any of the properties that are alloed
> for normal VF bars (memory-nonprefetchable, memory-prefetchable)


=46rom the ECN (specifically section 6.9.1.3):

Rules for use of BEI field:
=2E..

=46or Memory or I/O BARs where the Primary or Secondary Property is 00h=
, 01h or
02h, it is permitted to assign the same BEI in the range of 0-5 once fo=
r a range where
Base + MaxOffset is below 4GB, and again for a range where Base + MaxOf=
fset is
greater than 4GB; It is not otherwise permitted to assign the same BEI =
in the range 0-
5 for more than one entry.

=46or Virtual Function BARs where the Primary or Secondary Property is =
03h or 04h it
is permitted to assign the same BEI in the range of 0-5 once for a rang=
e where Base +
MaxOffset is below 4GB, and again for a range where Base + MaxOffset is=
 greater
than 4GB; It is not otherwise permitted to assign the same BEI in the r=
ange 0-5 for
more than one VF entry.

(Theres a typo in the VF rule. I think the '0-5' range should be '9-14'=
 for VFs)

> I guess in theory EA allows you to allocate 6 64-bit BARs, where you
> would be limited to only 3 64-bit normal BARs

I guess so, I never thought about that.

> >(one below the 4GB boundry, and one above).
> >I don't think the current pci_dev struct can handle that many resour=
ces.
> >
> >-Sean
> >

Let me know if you want any help with the patchset. I'll do what I can.
I'm in today, but I'm out Wed-Fri this week.

-Sean
