From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] vfio-pci: Allow to mmap MSI-X table if EEH is
 supported
Date: Wed, 16 Dec 2015 13:14:29 -0700
Message-ID: <1450296869.2674.62.camel@redhat.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1449823994-3356-4-git-send-email-xyjxie@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449823994-3356-4-git-send-email-xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-12-11 at 16:53 +0800, Yongji Xie wrote:
> Current vfio-pci implementation disallows to mmap MSI-X table in
> case that user get to touch this directly.
>=20
> However, EEH mechanism could ensure that a given pci device
> can only shoot the MSIs assigned for its PE and guest kernel also
> would not write to MSI-X table in pci_enable_msix() because
> para-virtualization on PPC64 platform. So MSI-X table is safe to
> access directly from the guest with EEH mechanism enabled.

The MSI-X table is paravirtualized on vfio in general and interrupt
remapping theoretically protects against errant interrupts, so why is
this PPC64 specific? =C2=A0We have the same safeguards on x86 if we wan=
t to
decide they're sufficient. =C2=A0Offhand, the only way I can think that=
 a
device can touch the MSI-X table is via backdoors or p2p DMA with
another device.

> This patch adds support for this case and allow to mmap MSI-X
> table if EEH is supported on PPC64 platform.
>=20
> And we also add a VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP flag to notify
> userspace that it's safe to mmap MSI-X table.
>=20
> Signed-off-by: Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
> =C2=A0drivers/vfio/pci/vfio_pci.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A05 ++++-
> =C2=A0drivers/vfio/pci/vfio_pci_private.h |=C2=A0=C2=A0=C2=A0=C2=A05 =
+++++
> =C2=A0include/uapi/linux/vfio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 ++
> =C2=A03 files changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.=
c
> index dbcad99..85d9980 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -446,6 +446,9 @@ static long vfio_pci_ioctl(void *device_data,
> =C2=A0		if (vfio_pci_bar_page_aligned())
> =C2=A0			info.flags |=3D VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED;
> =C2=A0
> +		if (vfio_msix_table_mmap_enabled())
> +			info.flags |=3D VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP;
> +
> =C2=A0		info.num_regions =3D VFIO_PCI_NUM_REGIONS;
> =C2=A0		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
> =C2=A0
> @@ -871,7 +874,7 @@ static int vfio_pci_mmap(void *device_data, struc=
t vm_area_struct *vma)
> =C2=A0	if (phys_len < PAGE_SIZE || req_start + req_len > phys_len)
> =C2=A0		return -EINVAL;
> =C2=A0
> -	if (index =3D=3D vdev->msix_bar) {
> +	if (index =3D=3D vdev->msix_bar && !vfio_msix_table_mmap_enabled())=
 {
> =C2=A0		/*
> =C2=A0		=C2=A0* Disallow mmaps overlapping the MSI-X table; users don=
't
> =C2=A0		=C2=A0* get to touch this directly.=C2=A0=C2=A0We could find =
somewhere
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/v=
fio_pci_private.h
> index 319352a..835619e 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -74,6 +74,11 @@ static inline bool vfio_pci_bar_page_aligned(void)
> =C2=A0	return IS_ENABLED(CONFIG_PPC64);
> =C2=A0}
> =C2=A0
> +static inline bool vfio_msix_table_mmap_enabled(void)
> +{
> +	return IS_ENABLED(CONFIG_EEH);
> +}

I really dislike these.

> +
> =C2=A0extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
> =C2=A0extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
> =C2=A0
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 1fc8066..289e662 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -173,6 +173,8 @@ struct vfio_device_info {
> =C2=A0#define VFIO_DEVICE_FLAGS_AMBA=C2=A0=C2=A0(1 << 3)	/* vfio-amba=
 device */
> =C2=A0/* Platform support all PCI MMIO BARs to be page aligned */
> =C2=A0#define VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED	(1 << 4)
> +/* Platform support mmapping PCI MSI-X vector table */
> +#define VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP	(1 << 5)

Again, not sure why this is on the device versus the region, but I'd
prefer to investigate whether we can handle this with the sparse mmap
capability (or lack of) in the capability chains I proposed[1]. Thanks,

Alex

[1]=C2=A0https://lkml.org/lkml/2015/11/23/748

> =C2=A0	__u32	num_regions;	/* Max region index + 1 */
> =C2=A0	__u32	num_irqs;	/* Max IRQ index + 1 */
> =C2=A0};
