From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 2/3] vfio-pci: Allow to mmap sub-page MMIO BARs if
 all MMIO BARs are page aligned
Date: Wed, 16 Dec 2015 13:04:36 -0700
Message-ID: <1450296276.2674.55.camel@redhat.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1449823994-3356-3-git-send-email-xyjxie@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449823994-3356-3-git-send-email-xyjxie@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yongji Xie <xyjxie@linux.vnet.ibm.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, warrier@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

On Fri, 2015-12-11 at 16:53 +0800, Yongji Xie wrote:
> Current vfio-pci implementation disallows to mmap
> sub-page(size < PAGE_SIZE) MMIO BARs because these BARs' mmio page
> may be shared with other BARs.
>=20
> But we should allow to mmap these sub-page MMIO BARs if all MMIO BARs
> are page aligned which leads the BARs' mmio page would not be shared
> with other BARs.
>=20
> This patch adds support for this case and we also add a
> VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED flag to notify userspace that
> platform supports all MMIO BARs to be page aligned.
>=20
> Signed-off-by: Yongji Xie <xyjxie@linux.vnet.ibm.com>
> ---
> =C2=A0drivers/vfio/pci/vfio_pci.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A010 +++++++++-
> =C2=A0drivers/vfio/pci/vfio_pci_private.h |=C2=A0=C2=A0=C2=A0=C2=A05 =
+++++
> =C2=A0include/uapi/linux/vfio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 ++
> =C2=A03 files changed, 16 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c
> b/drivers/vfio/pci/vfio_pci.c
> index 32b88bd..dbcad99 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -443,6 +443,9 @@ static long vfio_pci_ioctl(void *device_data,
> =C2=A0		if (vdev->reset_works)
> =C2=A0			info.flags |=3D VFIO_DEVICE_FLAGS_RESET;
> =C2=A0
> +		if (vfio_pci_bar_page_aligned())
> +			info.flags |=3D
> VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED;
> +
> =C2=A0		info.num_regions =3D VFIO_PCI_NUM_REGIONS;
> =C2=A0		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
> =C2=A0
> @@ -479,7 +482,8 @@ static long vfio_pci_ioctl(void *device_data,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0VFIO_REGION_INFO_FLAG_WRITE;
> =C2=A0			if (IS_ENABLED(CONFIG_VFIO_PCI_MMAP) &&
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0pci_resource_flags(pdev, info.index)=
 &
> -			=C2=A0=C2=A0=C2=A0=C2=A0IORESOURCE_MEM && info.size >=3D
> PAGE_SIZE)
> +			=C2=A0=C2=A0=C2=A0=C2=A0IORESOURCE_MEM && (info.size >=3D
> PAGE_SIZE ||
> +			=C2=A0=C2=A0=C2=A0=C2=A0vfio_pci_bar_page_aligned()))
> =C2=A0				info.flags |=3D
> VFIO_REGION_INFO_FLAG_MMAP;
> =C2=A0			break;
> =C2=A0		case VFIO_PCI_ROM_REGION_INDEX:
> @@ -855,6 +859,10 @@ static int vfio_pci_mmap(void *device_data,
> struct vm_area_struct *vma)
> =C2=A0		return -EINVAL;
> =C2=A0
> =C2=A0	phys_len =3D pci_resource_len(pdev, index);
> +
> +	if (vfio_pci_bar_page_aligned())
> +		phys_len =3D PAGE_ALIGN(phys_len);
> +
> =C2=A0	req_len =3D vma->vm_end - vma->vm_start;
> =C2=A0	pgoff =3D vma->vm_pgoff &
> =C2=A0		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> diff --git a/drivers/vfio/pci/vfio_pci_private.h
> b/drivers/vfio/pci/vfio_pci_private.h
> index 0e7394f..319352a 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -69,6 +69,11 @@ struct vfio_pci_device {
> =C2=A0#define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) ||
> is_msix(vdev)))
> =C2=A0#define irq_is(vdev, type) (vdev->irq_type =3D=3D type)
> =C2=A0
> +static inline bool vfio_pci_bar_page_aligned(void)
> +{
> +	return IS_ENABLED(CONFIG_PPC64);
> +}

I really dislike this. =C2=A0This is a problem for any architecture tha=
t
runs on larger pages, and even an annoyance on 4k hosts. =C2=A0Why are =
we
only solving it for PPC64? =C2=A0Can't we do something similar in the c=
ore
PCI code and detect it?

> +
> =C2=A0extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
> =C2=A0extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
> =C2=A0
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 751b69f..1fc8066 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -171,6 +171,8 @@ struct vfio_device_info {
> =C2=A0#define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci
> device */
> =C2=A0#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform
> device */
> =C2=A0#define VFIO_DEVICE_FLAGS_AMBA=C2=A0=C2=A0(1 << 3)	/* vfio-amba=
 device
> */
> +/* Platform support all PCI MMIO BARs to be page aligned */
> +#define VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED	(1 << 4)
> =C2=A0	__u32	num_regions;	/* Max region index + 1 */
> =C2=A0	__u32	num_irqs;	/* Max IRQ index + 1 */
> =C2=A0};

Why is this on the device info, shouldn't it be per region? =C2=A0Do we=
 even
need a flag or can we just set the existing mmap flag with the
clarification that sub-host page size regions can mmap an entire host-
page aligned, sized area in the documentation? =C2=A0Thanks,

Alex
