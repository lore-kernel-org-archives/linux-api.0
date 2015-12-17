From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] vfio-pci: Allow to mmap MSI-X table if EEH is
 supported
Date: Thu, 17 Dec 2015 14:41:39 -0700
Message-ID: <1450388499.2674.153.camel@redhat.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1449823994-3356-4-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1450296869.2674.62.camel@redhat.com> <5672906C.5010708@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5672906C.5010708-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yongji xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-12-17 at 18:37 +0800, yongji xie wrote:
>=20
> On 2015/12/17 4:14, Alex Williamson wrote:
> > On Fri, 2015-12-11 at 16:53 +0800, Yongji Xie wrote:
> > > Current vfio-pci implementation disallows to mmap MSI-X table in
> > > case that user get to touch this directly.
> > >=20
> > > However, EEH mechanism could ensure that a given pci device
> > > can only shoot the MSIs assigned for its PE and guest kernel also
> > > would not write to MSI-X table in pci_enable_msix() because
> > > para-virtualization on PPC64 platform. So MSI-X table is safe to
> > > access directly from the guest with EEH mechanism enabled.
> > The MSI-X table is paravirtualized on vfio in general and interrupt
> > remapping theoretically protects against errant interrupts, so why
> > is
> > this PPC64 specific?=C2=A0=C2=A0We have the same safeguards on x86 =
if we want
> > to
> > decide they're sufficient.=C2=A0=C2=A0Offhand, the only way I can t=
hink that
> > a
> > device can touch the MSI-X table is via backdoors or p2p DMA with
> > another device.
> Maybe I didn't make my point clear. The reasons why we can mmap MSI-X
> table on PPC64 are=EF=BC=9A
>=20
> 1. EEH mechanism could ensure that a given pci device can only shoot
> the MSIs assigned for its PE. So it would not do harm to other memory
> space when the guest write a garbage MSI-X address/data to the vector
> table
> if we passthough MSI-X tables to guest.

Interrupt remapping does the same on x86.

> 2. The guest kernel would not write to MSI-X table on PPC64 platform
> when device drivers call pci_enable_msix() to initialize MSI-X
> interrupts.

This is irrelevant to the vfio API. =C2=A0vfio is a userspace driver
interface, QEMU is just one possible consumer of the interface. =C2=A0E=
ven
in the case of PPC64 & QEMU, the guest is still capable of writing to
the vector table, it just probably won't.

> So I think it is safe to mmap/passthrough MSI-X table on PPC64
> platform.
> And I'm not sure whether other architectures can ensure these two=20
> points.=C2=A0

There is another consideration, which is the API exposed to the user.
=C2=A0vfio currently enforces interrupt setup through ioctls by making =
the
PCI mechanisms for interrupt programming inaccessible through the
device regions. =C2=A0Ignoring that you are only focused on PPC64 with =
QEMU,
does it make sense for the vfio API to allow a user to manipulate
interrupt programming in a way that not only will not work, but in a
way that we expect to fail and require error isolation to recover from?
=C2=A0I can't say I'm fully convinced that a footnote in the documentat=
ion
is sufficient for that. =C2=A0Thanks,

Alex
