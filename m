From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] vfio-pci: Allow to mmap MSI-X table if EEH is
 supported
Date: Thu, 17 Dec 2015 14:06:54 -0700
Message-ID: <1450386414.2674.129.camel@redhat.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1449823994-3356-4-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1450296869.2674.62.camel@redhat.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1CBEF1BC@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CBEF1BC-VkEWCZq2GCInGFn1LkZF6NBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>
Cc: "nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org" <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, "paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-12-17 at 10:08 +0000, David Laight wrote:
> > The MSI-X table is paravirtualized on vfio in general and interrupt
> > remapping theoretically protects against errant interrupts, so why
> > is
> > this PPC64 specific? We have the same safeguards on x86 if we want
> > to
> > decide they're sufficient. Offhand, the only way I can think that a
> > device can touch the MSI-X table is via backdoors or p2p DMA with
> > another device.
>=20
> Is this all related to the statements in the PCI(e) spec that the
> MSI-X table and Pending bit array should in their own BARs?
> (ISTR it even suggests a BAR each.)
>=20
> Since the MSI-X table exists in device memory/registers there is
> nothing to stop the device modifying the table contents (or even
> ignoring the contents and writing address+data pairs that are known
> to reference the CPUs MSI-X interrupt generation logic).
>=20
> We've an fpga based PCIe slave that has some additional PCIe slaves
> (associated with the interrupt generation logic) that are currently
> next to the PBA (which is 8k from the MSI-X table).
> If we can't map the PBA we can't actually raise any interrupts.
> The same would be true if page size is 64k and mapping the MSI-X
> table banned.
>=20
> Do we need to change our PCIe slave address map so we don't need
> to access anything in the same page (which might be 64k were we to
> target large ppc - which we don't at the moment) as both the
> MSI-X table and the PBA?
>=20
> I'd also note that being able to read the MSI-X table is a useful
> diagnostic that the relevant interrupts are enabled properly.

Yes, the spec requirement is that MSI-X structures must reside in a 4k
aligned area that doesn't overlap with other configuration registers
for the device. =C2=A0It's only an advisement to put them into their ow=
n
BAR, and 4k clearly wasn't as forward looking as we'd hope. =C2=A0Vfio
doesn't particularly care about the PBA, but if it resides in the same
host PAGE_SIZE area as the MSI-X vector table, you currently won't be
able to get to it. =C2=A0Most devices are not at all dependent on the P=
BA
for any sort of functionality.

It's really more correct to say that both the vector table and PBA are
emulated by QEMU than paravirtualized. =C2=A0Only PPC64 has the guest O=
S
taking a paravirtual path to program the vector table, everyone else
attempts to read/write to the device MMIO space, which gets trapped and
emulated in QEMU. =C2=A0This is why the QEMU side patch has further ugl=
y
hacks to mess with the ordering of MemoryRegions since even if we can
access and mmap the MSI-X vector table, we'll still trap into QEMU for
emulation.

How exactly does the ability to map the PBA affect your ability to
raise an interrupt? =C2=A0I can only think that maybe you're writing PB=
A
bits to clear them, but the spec indicates that software should never
write to the PBA, only read, and that writes are undefined. =C2=A0So th=
at
would be very non-standard, QEMU drops writes, they don't even make it
to the hardware. =C2=A0Thanks,

Alex
