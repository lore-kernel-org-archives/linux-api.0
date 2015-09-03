From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] PCI: Add support for Enhanced Allocation devices
Date: Wed, 2 Sep 2015 17:29:38 -0700
Message-ID: <20150903002938.GA6334@sean.stalley.intel.com>
References: <1440089947-2839-1-git-send-email-sean.stalley@intel.com>
 <1440089947-2839-3-git-send-email-sean.stalley@intel.com>
 <CAE9FiQUQacSJXPqv9GQJ4AF0TN7uxcBiAYHVbHwvFhEfWgWKHg@mail.gmail.com>
 <20150902174612.GA2700@sean.stalley.intel.com>
 <CAErSpo4qZ9AXskyo86gXG1cb3AqCn-HB05nj7qT9wovZdLt2Tg@mail.gmail.com>
 <20150902200127.GA3347@sean.stalley.intel.com>
 <20150902212159.GC829@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150902212159.GC829-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rajat Jain <rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 02, 2015 at 04:21:59PM -0500, Bjorn Helgaas wrote:
> On Wed, Sep 02, 2015 at 01:01:27PM -0700, Sean O. Stalley wrote:
> > On Wed, Sep 02, 2015 at 02:25:50PM -0500, Bjorn Helgaas wrote:
> > > On Wed, Sep 2, 2015 at 12:46 PM, Sean O. Stalley <sean.stalley@in=
tel.com> wrote:
> > >=20
> > > > Would it be better to modify pci_claim_resource() to support EA=
 instead of adding pci_ea_claim_resource()?
> > > > That way, EA entries would be claimed at the same time as tradi=
tional BARs.
> > >=20
> > > Yes, I think so.
> >=20
> > Ok, I'll make it work this way in the next patchset.
> >=20
> > > Why wouldn't pci_claim_resource() work as-is for EA?  I see that
> > > pci_ea_get_parent_resource() defaults to iomem_resource or
> > > ioport_resource if we don't find a parent, but I don't understand=
 why
> > > that's necessary.
> >=20
> > EA resources may (or may not) be in the parent's range[1].
> > If the parent doesn't describe this range, we want to default to th=
e top-level resource.
> > Other than that case, I think pci_claim_resource would work as-is.
> >=20
> > -Sean
> >=20
> > [1] From the EA ECN:
> > For a bridge function that is permitted to implement EA based on th=
e rules above, it is
> > permitted, but not required, for the bridge function to use EA mech=
anisms to indicate
> > resource ranges that are located behind the bridge Function (see Se=
ction 6.9.1.2).
>=20
> [BTW, in EA ECN 23_Oct_2014_Final, this text is in sec 6.9, not 6.9.1=
=2E2]
>=20
> I agree that it implies EA resources need not be in the parent's *EA*
> range.  But I would read it as saying "a bridge can use either the
> usual window registers or EA to indicate resources forwarded
> downstream."
>=20
> What happens in the following case?
>=20
> =C2=A0 00:00.0: PCI bridge to [bus 01]
> =C2=A0 00:00.0: =C2=A0 bridge window [mem 0x80000000-0x8fffffff]
> =C2=A0 01:00.0: EA 0: [mem 0x90000000-0x9000ffff]
>
> The 00:00.0 bridge knows nothing about EA. =C2=A0The 01:00.0 EA devic=
e has
> a fixed region at 0x90000000. =C2=A0The ECN says:
>=20
>   System firmware/software must comprehend that such bridge functions
>   [those that are permitted to implement EA] are not required to
>   indicate inclusively all resources behind the bridge, and as a
>   result system firmware/software must make a complete search of all
>   functions behind the bridge to comprehend the resources used by
>   those functions.
>=20

The intention of this line was to indicate that EA regions are not requ=
ired
to be inside of the Base+Limit window.

If an EA device is connected below a bridge, that bridge must be aware =
of EA.
It is assumed that the bridge is aware of the fixed EA regions below it=
,
so system software doesn't need to program the window to include them.

This is part of the reason why EA devices must be permanently connected
(to make sure it doesn't end up behind an old bridge).
Re-reading the spec, I can see that this requirement isn't explicitly s=
tated.

> A bridge was never required to indicate, e.g., via its window
> registers, anything about the resources behind it.  Software always
> had to search behind the bridge and look at all the downstream BARs.
> What's new here is that software now has to look for downstream EA
> entries in addition to BARs, and the EA entries are at fixed
> addresses.
>=20
> My question is what the implication is for address routing performed
> by the bridge.  The EA ECN doesn't mention any changes there, so I
> assume it is software's responsibility to reprogram the 00:00.0 mem
> window so it includes [mem 0x90000000-0x9000ffff].

The Base+Limit window is not required to include EA regions.
	In the example shown in in Figure 6-1, the bridge above Bus N [...]
	is permitted to not indicate the resources used by the two functions
	in =E2=80=9CSi component C=E2=80=9D

Before, all the BAR regions would be inside the window range.
The Base+Limit "indicated" the Range of all the BARs behind the bridge.
Once the window was set, system software could avoid an address collisi=
on
with every device on the bus by avoiding the window.

BAR-equivalent EA regions aren't required to be inside the Base+Limit w=
indow,
which is why System firmware/software must search all the functions beh=
ind a bus
to avoid address collisions.

> If software does have to reprogram that window, the normal
> pci_claim_resource() should work.  If it doesn't have to reprogram th=
e
> window, and there's some magical way for 01:00.0 to work even though
> we don't route address space to it, I suspect we'll need significantl=
y
> more changes than just pci_ea_claim_resource(), because then 00:00.0
> is really not a PCI bridge any more.
>=20
> Bjorn

-Sean
