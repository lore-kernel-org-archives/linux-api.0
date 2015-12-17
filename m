From: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] vfio-pci: Allow to mmap MSI-X table if EEH is
 supported
Date: Fri, 18 Dec 2015 09:48:21 +1100
Message-ID: <1450392501.5445.11.camel@kernel.crashing.org>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1449823994-3356-4-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1450296869.2674.62.camel@redhat.com> <5672906C.5010708@linux.vnet.ibm.com>
	 <1450388499.2674.153.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450388499.2674.153.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, yongji xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-12-17 at 14:41 -0700, Alex Williamson wrote:
> > So I think it is safe to mmap/passthrough MSI-X table on PPC64
> > platform.
> > And I'm not sure whether other architectures can ensure these two=C2=
=A0
> > points.=C2=A0
>=20
> There is another consideration, which is the API exposed to the user.
> =C2=A0vfio currently enforces interrupt setup through ioctls by makin=
g the
> PCI mechanisms for interrupt programming inaccessible through the
> device regions. =C2=A0Ignoring that you are only focused on PPC64 wit=
h QEMU,
> does it make sense for the vfio API to allow a user to manipulate
> interrupt programming in a way that not only will not work, but in a
> way that we expect to fail and require error isolation to recover fro=
m?
> =C2=A0I can't say I'm fully convinced that a footnote in the document=
ation
> is sufficient for that. =C2=A0Thanks,

Well, one could argue that the "isolation" provided by qemu here is
fairly weak anyway ;-)

I mean. .. how do you know the device doesn't have a backdoor path into
that table via some other MMIO registers anyway ?

In any case, the HW isolation on platforms like pseries means that the
worst the guest can do si shoot itself in the foot. Big deal. On the
other hand, not bothering with intercepting the table has benefits,
such as reducing the memory region clutter, but also removing all the
massive performacne problems we see because adapters have critical
registers in the same 64K page as the MSI-X table.

So I don't think there is any question here that we *need* that
functionality in power. The filtering of the table by Qemu doesn't
provide any practical benefit, it just gets in the way.

Cheers,
Ben.
