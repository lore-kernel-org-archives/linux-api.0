From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 0/5] PCI: Add support for PCI Enhanced Allocation "BARs"
Date: Mon, 5 Oct 2015 09:49:42 -0700
Message-ID: <5612AA26.90607@caviumnetworks.com>
References: <1443825476-26880-1-git-send-email-ddaney.cavm@gmail.com> <CAE9FiQXT0ux42gQ+DhpVv2K=BR4jC++LmNdCSLiK4Wy0BhL=HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE9FiQXT0ux42gQ+DhpVv2K=BR4jC++LmNdCSLiK4Wy0BhL=HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Sean O. Stalley" <sean.stalley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rajat Jain <rajatxjain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/02/2015 08:16 PM, Yinghai Lu wrote:
> On Fri, Oct 2, 2015 at 3:37 PM, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>
>> PCI Enhanced Allocation is a new method of allocating MMIO & IO
>> resources for PCI devices & bridges. It can be used instead
>> of the traditional PCI method of using BARs.
>>
>> EA entries are hardware-initialized to a fixed address.
>> Unlike BARs, regions described by EA are cannot be moved.
>> Because of this, only devices which are permanently connected to
>> the PCI bus can use EA. A removable PCI card must not use EA.
>>
>> The Enhanced Allocation ECN is publicly available here:
>> https://www.pcisig.com/specifications/conventional/ECN_Enhanced_Allo=
cation_23_Oct_2014_Final.pdf
>
> Looks like the EA will support more than just fixed address later.
>
> "Enhanced Allocation is an optional Conventional PCI Capability that
> may be implemented by
> Functions to indicate fixed (non reprogrammable) I/O and memory range=
s
> assigned to the
> Function, as well as supporting new resource =E2=80=9Ctype=E2=80=9D d=
efinitions and
> future extensibility to also
> support reprogrammable allocations."
>
> so I would prefer to think more to make frame configurable to leave
> space for that.

I disagree.  Currently we know of no use case other than devices with=20
fixed address BARs and bridges to buses containing such devices.

Since we have no idea what these future types of EA entries might look=20
like, it is impossible to design a framework to handle them.  Since we=20
cannot design the framework, it seems like insisting on the creation of=
=20
a framework is the equivalent of refusing to handle EA.

We have today, actual hardware with configuration space that contains=20
the EA entries defined by the specification.  We know how to handle=20
these, it can be done with this patch set.

I have no objection to changing the patches so that they fit better wit=
h=20
the core PCI code.  In fact, I fully expect to do so based on feedback =
I=20
receive.

=46or the record the general idea is this:  IORESOURCE_PCI_FIXED alread=
y=20
does almost exactly what we need for EA, there are only a couple of=20
places where we need to fix things for it to work well with the=20
pci-host-generic driver.  If we fix these few issues with=20
IORESOURCE_PCI_FIXED, then EA is supported.  It also makes doing simila=
r=20
things by setting the IORESOURCE_PCI_FIXED in a "header" fixup.  I don'=
t=20
think it make sense to invent an additional flag for fixed EA resources=
,=20
as it would just be a duplicate of IORESOURCE_PCI_FIXED.

David Daney

>
> Bjorn,
>
> I wonder if we need to revive the add-on resource support patchset
> that i suggested couple years ago,
> so we can extend it to support EA features.
>
> URL: https://lkml.org/lkml/2012/3/19/86
>
> Thanks
>
> Yinghai
>
