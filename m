From: "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 0/5] PCI: Add support for PCI Enhanced Allocation
 "BARs"
Date: Mon, 5 Oct 2015 16:05:05 -0700
Message-ID: <20151005230505.GD4821@sean.stalley.intel.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com>
 <CAE9FiQXT0ux42gQ+DhpVv2K=BR4jC++LmNdCSLiK4Wy0BhL=HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQXT0ux42gQ+DhpVv2K=BR4jC++LmNdCSLiK4Wy0BhL=HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rajat Jain <rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 02, 2015 at 08:16:48PM -0700, Yinghai Lu wrote:
> On Fri, Oct 2, 2015 at 3:37 PM, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
> > From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >
> > PCI Enhanced Allocation is a new method of allocating MMIO & IO
> > resources for PCI devices & bridges. It can be used instead
> > of the traditional PCI method of using BARs.
> >
> > EA entries are hardware-initialized to a fixed address.
> > Unlike BARs, regions described by EA are cannot be moved.
> > Because of this, only devices which are permanently connected to
> > the PCI bus can use EA. A removable PCI card must not use EA.
> >
> > The Enhanced Allocation ECN is publicly available here:
> > https://www.pcisig.com/specifications/conventional/ECN_Enhanced_All=
ocation_23_Oct_2014_Final.pdf
>=20
> Looks like the EA will support more than just fixed address later.
>=20
> "Enhanced Allocation is an optional Conventional PCI Capability that
> may be implemented by
> Functions to indicate fixed (non reprogrammable) I/O and memory range=
s
> assigned to the
> Function, as well as supporting new resource =E2=80=9Ctype=E2=80=9D d=
efinitions and
> future extensibility to also
> support reprogrammable allocations."
>=20
> so I would prefer to think more to make frame configurable to leave
> space for that.
>=20
> Bjorn,
>=20
> I wonder if we need to revive the add-on resource support patchset
> that i suggested couple years ago,
> so we can extend it to support EA features.
>=20
> URL: https://lkml.org/lkml/2012/3/19/86
>=20
> Thanks
>=20
> Yinghai

This might be useful for fixed resources as well.

=46or some BEI values, EA allows for an arbitrary number of EA entries.
=46or PF & VF resource ranges, it allows 2 ranges.
(one below the 4GB boundry, and one above).
I don't think the current pci_dev struct can handle that many resources=
=2E

-Sean
