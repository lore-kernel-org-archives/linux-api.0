From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/2] PCI: Add support for Enhanced Allocation devices
Date: Thu, 3 Sep 2015 09:46:54 -0500
Message-ID: <20150903144654.GF829@google.com>
References: <1440089947-2839-1-git-send-email-sean.stalley@intel.com>
 <1440089947-2839-3-git-send-email-sean.stalley@intel.com>
 <CAE9FiQUQacSJXPqv9GQJ4AF0TN7uxcBiAYHVbHwvFhEfWgWKHg@mail.gmail.com>
 <20150902174612.GA2700@sean.stalley.intel.com>
 <CAErSpo4qZ9AXskyo86gXG1cb3AqCn-HB05nj7qT9wovZdLt2Tg@mail.gmail.com>
 <20150902200127.GA3347@sean.stalley.intel.com>
 <20150902212159.GC829@google.com>
 <20150903002938.GA6334@sean.stalley.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150903002938.GA6334@sean.stalley.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Sean O. Stalley" <sean.stalley@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Rajat Jain <rajatxjain@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>, "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 02, 2015 at 05:29:38PM -0700, Sean O. Stalley wrote:
> On Wed, Sep 02, 2015 at 04:21:59PM -0500, Bjorn Helgaas wrote:
> > On Wed, Sep 02, 2015 at 01:01:27PM -0700, Sean O. Stalley wrote:
> > > On Wed, Sep 02, 2015 at 02:25:50PM -0500, Bjorn Helgaas wrote:
> > > > On Wed, Sep 2, 2015 at 12:46 PM, Sean O. Stalley <sean.stalley@=
intel.com> wrote:
> > > >=20
> > > > > Would it be better to modify pci_claim_resource() to support =
EA instead of adding pci_ea_claim_resource()?
> > > > > That way, EA entries would be claimed at the same time as tra=
ditional BARs.
> > > >=20
> > > > Yes, I think so.
> > >=20
> > > Ok, I'll make it work this way in the next patchset.
> > >=20
> > > > Why wouldn't pci_claim_resource() work as-is for EA?  I see tha=
t
> > > > pci_ea_get_parent_resource() defaults to iomem_resource or
> > > > ioport_resource if we don't find a parent, but I don't understa=
nd why
> > > > that's necessary.
> > >=20
> > > EA resources may (or may not) be in the parent's range[1].
> > > If the parent doesn't describe this range, we want to default to =
the top-level resource.
> > > Other than that case, I think pci_claim_resource would work as-is=
=2E
> > >=20
> > > -Sean
> > >=20
> > > [1] From the EA ECN:
> > > For a bridge function that is permitted to implement EA based on =
the rules above, it is
> > > permitted, but not required, for the bridge function to use EA me=
chanisms to indicate
> > > resource ranges that are located behind the bridge Function (see =
Section 6.9.1.2).
> >=20
> > [BTW, in EA ECN 23_Oct_2014_Final, this text is in sec 6.9, not 6.9=
=2E1.2]
> >=20
> > I agree that it implies EA resources need not be in the parent's *E=
A*
> > range.  But I would read it as saying "a bridge can use either the
> > usual window registers or EA to indicate resources forwarded
> > downstream."
> >=20
> > What happens in the following case?
> >=20
> > =C2=A0 00:00.0: PCI bridge to [bus 01]
> > =C2=A0 00:00.0: =C2=A0 bridge window [mem 0x80000000-0x8fffffff]
> > =C2=A0 01:00.0: EA 0: [mem 0x90000000-0x9000ffff]
> >
> > The 00:00.0 bridge knows nothing about EA. =C2=A0The 01:00.0 EA dev=
ice has
> > a fixed region at 0x90000000. =C2=A0The ECN says:
> >=20
> >   System firmware/software must comprehend that such bridge functio=
ns
> >   [those that are permitted to implement EA] are not required to
> >   indicate inclusively all resources behind the bridge, and as a
> >   result system firmware/software must make a complete search of al=
l
> >   functions behind the bridge to comprehend the resources used by
> >   those functions.
>=20
> The intention of this line was to indicate that EA regions are not re=
quired
> to be inside of the Base+Limit window.

It would be a lot nicer if the terminology here built on terminology
used in the original specs.  The P2P Bridge spec defines rules for
when a bridge forwards transactions between its primary and secondary
interfaces using Command register Enable bits and Base and Limit
registers.  It doesn't say anything about "indicating resources behind
the bridge."

> If an EA device is connected below a bridge, that bridge must be awar=
e of EA.
> It is assumed that the bridge is aware of the fixed EA regions below =
it,
> so system software doesn't need to program the window to include them=
=2E

Is the requirement that every bridge upstream of an EA device must be
aware of EA in the ECN somewhere?  What does it even mean for a bridge
to be "aware of EA"?  That it has an EA Capability?

The EA ECN doesn't change anything in the P2P bridge spec, so a bridge
that forwards EA regions not described by its Base/Limit registers
sounds like it would be non-conforming.

The EA ECN *does* say (end of sec 6.9) that Memory and I/O Space
enables still work, so I assume that if we clear those bits, a bridge
will not forward EA regions, and an endpoint will not respond to EA
regions.

AFAIK, config transaction forwarding is controlled only by the
Secondary and Subordinate Bus Number registers.  So I assume there's
no way to disable bridge forwarding of an EA Bus number range.

> This is part of the reason why EA devices must be permanently connect=
ed
> (to make sure it doesn't end up behind an old bridge).
> Re-reading the spec, I can see that this requirement isn't explicitly=
 stated.
>=20
> > A bridge was never required to indicate, e.g., via its window
> > registers, anything about the resources behind it.  Software always
> > had to search behind the bridge and look at all the downstream BARs=
=2E
> > What's new here is that software now has to look for downstream EA
> > entries in addition to BARs, and the EA entries are at fixed
> > addresses.
> >=20
> > My question is what the implication is for address routing performe=
d
> > by the bridge.  The EA ECN doesn't mention any changes there, so I
> > assume it is software's responsibility to reprogram the 00:00.0 mem
> > window so it includes [mem 0x90000000-0x9000ffff].
>=20
> The Base+Limit window is not required to include EA regions.
> 	In the example shown in in Figure 6-1, the bridge above Bus N [...]
> 	is permitted to not indicate the resources used by the two functions
> 	in =E2=80=9CSi component C=E2=80=9D
>=20
> Before, all the BAR regions would be inside the window range.
> The Base+Limit "indicated" the Range of all the BARs behind the bridg=
e.
> Once the window was set, system software could avoid an address colli=
sion
> with every device on the bus by avoiding the window.
>=20
> BAR-equivalent EA regions aren't required to be inside the Base+Limit=
 window,
> which is why System firmware/software must search all the functions b=
ehind a bus
> to avoid address collisions.
>=20
> > If software does have to reprogram that window, the normal
> > pci_claim_resource() should work.  If it doesn't have to reprogram =
the
> > window, and there's some magical way for 01:00.0 to work even thoug=
h
> > we don't route address space to it, I suspect we'll need significan=
tly
> > more changes than just pci_ea_claim_resource(), because then 00:00.=
0
> > is really not a PCI bridge any more.

Assuming the Memory Enable bit of an EA bridge affects the EA regions,
I think EA resources of devices behind the bridge should appear as
children of the bridge, not of iomem_resource.  I guess that means the
bridge should claim the EA regions it forwards.

Bjorn
