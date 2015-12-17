From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 2/3] vfio-pci: Allow to mmap sub-page MMIO BARs if
 all MMIO BARs are page aligned
Date: Thu, 17 Dec 2015 14:46:44 -0700
Message-ID: <1450388804.2674.158.camel@redhat.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1449823994-3356-3-git-send-email-xyjxie@linux.vnet.ibm.com>
	 <1450296276.2674.55.camel@redhat.com> <56728DC8.20803@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <56728DC8.20803@linux.vnet.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: yongji xie <xyjxie@linux.vnet.ibm.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, warrier@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

On Thu, 2015-12-17 at 18:26 +0800, yongji xie wrote:
>=20
> On 2015/12/17 4:04, Alex Williamson wrote:
> > On Fri, 2015-12-11 at 16:53 +0800, Yongji Xie wrote:
> > > Current vfio-pci implementation disallows to mmap
> > > sub-page(size < PAGE_SIZE) MMIO BARs because these BARs' mmio
> > > page
> > > may be shared with other BARs.
> > >=20
> > > But we should allow to mmap these sub-page MMIO BARs if all MMIO
> > > BARs
> > > are page aligned which leads the BARs' mmio page would not be
> > > shared
> > > with other BARs.
> > >=20
> > > This patch adds support for this case and we also add a
> > > VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED flag to notify userspace that
> > > platform supports all MMIO BARs to be page aligned.
> > >=20
> > > Signed-off-by: Yongji Xie <xyjxie@linux.vnet.ibm.com>
> > > ---
> > > =C2=A0 drivers/vfio/pci/vfio_pci.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A010 +++++++++-
> > > =C2=A0 drivers/vfio/pci/vfio_pci_private.h |=C2=A0=C2=A0=C2=A0=C2=
=A05 +++++
> > > =C2=A0 include/uapi/linux/vfio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A02 ++
> > > =C2=A0 3 files changed, 16 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/vfio/pci/vfio_pci.c
> > > b/drivers/vfio/pci/vfio_pci.c
> > > index 32b88bd..dbcad99 100644
> > > --- a/drivers/vfio/pci/vfio_pci.c
> > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > @@ -443,6 +443,9 @@ static long vfio_pci_ioctl(void *device_data,
> > > =C2=A0=C2=A0		if (vdev->reset_works)
> > > =C2=A0=C2=A0			info.flags |=3D VFIO_DEVICE_FLAGS_RESET;
> > > =C2=A0=20
> > > +		if (vfio_pci_bar_page_aligned())
> > > +			info.flags |=3D
> > > VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED;
> > > +
> > > =C2=A0=C2=A0		info.num_regions =3D VFIO_PCI_NUM_REGIONS;
> > > =C2=A0=C2=A0		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
> > > =C2=A0=20
> > > @@ -479,7 +482,8 @@ static long vfio_pci_ioctl(void *device_data,
> > > =C2=A0=C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0VFIO_REGION_INFO_FL=
AG_WRIT
> > > E;
> > > =C2=A0=C2=A0			if (IS_ENABLED(CONFIG_VFIO_PCI_MMAP) &&
> > > =C2=A0=C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0pci_resource_flags(pdev,
> > > info.index) &
> > > -			=C2=A0=C2=A0=C2=A0=C2=A0IORESOURCE_MEM && info.size >=3D
> > > PAGE_SIZE)
> > > +			=C2=A0=C2=A0=C2=A0=C2=A0IORESOURCE_MEM && (info.size >=3D
> > > PAGE_SIZE ||
> > > +			=C2=A0=C2=A0=C2=A0=C2=A0vfio_pci_bar_page_aligned()))
> > > =C2=A0=C2=A0				info.flags |=3D
> > > VFIO_REGION_INFO_FLAG_MMAP;
> > > =C2=A0=C2=A0			break;
> > > =C2=A0=C2=A0		case VFIO_PCI_ROM_REGION_INDEX:
> > > @@ -855,6 +859,10 @@ static int vfio_pci_mmap(void *device_data,
> > > struct vm_area_struct *vma)
> > > =C2=A0=C2=A0		return -EINVAL;
> > > =C2=A0=20
> > > =C2=A0=C2=A0	phys_len =3D pci_resource_len(pdev, index);
> > > +
> > > +	if (vfio_pci_bar_page_aligned())
> > > +		phys_len =3D PAGE_ALIGN(phys_len);
> > > +
> > > =C2=A0=C2=A0	req_len =3D vma->vm_end - vma->vm_start;
> > > =C2=A0=C2=A0	pgoff =3D vma->vm_pgoff &
> > > =C2=A0=C2=A0		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) -
> > > 1);
> > > diff --git a/drivers/vfio/pci/vfio_pci_private.h
> > > b/drivers/vfio/pci/vfio_pci_private.h
> > > index 0e7394f..319352a 100644
> > > --- a/drivers/vfio/pci/vfio_pci_private.h
> > > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > > @@ -69,6 +69,11 @@ struct vfio_pci_device {
> > > =C2=A0 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev)=
 ||
> > > is_msix(vdev)))
> > > =C2=A0 #define irq_is(vdev, type) (vdev->irq_type =3D=3D type)
> > > =C2=A0=20
> > > +static inline bool vfio_pci_bar_page_aligned(void)
> > > +{
> > > +	return IS_ENABLED(CONFIG_PPC64);
> > > +}
> > I really dislike this.=C2=A0=C2=A0This is a problem for any archite=
cture that
> > runs on larger pages, and even an annoyance on 4k hosts.=C2=A0=C2=A0=
Why are
> > we
> > only solving it for PPC64?
> Yes, I know it's a problem for other architectures. But I'm not sure
> if=20
> other archs prefer
> to enforce the alignment of all BARs to be at least PAGE_SIZE which=20
> would result in
> some waste of address space.
>=20
> So I just propose a prototype and add PPC64 support here. And other=20
> archs could decide
> to use it or not by themselves.
> > Can't we do something similar in the core PCI code and detect it?
> So you mean we can do it like this:
>=20
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index d390fc1..f46c04d 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -320,6 +320,11 @@ static inline resource_size_t=20
> pci_resource_alignment(struct pci_dev *dev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return resource=
_alignment(res);
> =C2=A0 }
>=20
> +static inline bool pci_bar_page_aligned(void)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return IS_ENABLED(CONFIG_P=
PC64);
> +}
> +
> =C2=A0 void pci_enable_acs(struct pci_dev *dev);
>=20
> =C2=A0 struct pci_dev_reset_methods {
>=20
> or add a config option to indicate that PCI MMIO BARs should be page=20
> aligned?=C2=A0

Yes, I'm thinking of a boot commandline option, maybe one that PPC64
can default to enabled if it chooses to. =C2=A0The problem is not uniqu=
e to
PPC64 and the solution should not be unique either. =C2=A0I don't want =
to
need to revisit this for ARM, which we know is going to be similarly
afflicted. =C2=A0Thanks,

Alex
