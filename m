From: yongji xie <xyjxie@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 3/3] vfio-pci: Allow to mmap MSI-X table if EEH is
 supported
Date: Thu, 17 Dec 2015 18:37:32 +0800
Message-ID: <5672906C.5010708@linux.vnet.ibm.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
 <1449823994-3356-4-git-send-email-xyjxie@linux.vnet.ibm.com>
 <1450296869.2674.62.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450296869.2674.62.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, warrier@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org



On 2015/12/17 4:14, Alex Williamson wrote:
> On Fri, 2015-12-11 at 16:53 +0800, Yongji Xie wrote:
>> Current vfio-pci implementation disallows to mmap MSI-X table in
>> case that user get to touch this directly.
>>
>> However, EEH mechanism could ensure that a given pci device
>> can only shoot the MSIs assigned for its PE and guest kernel also
>> would not write to MSI-X table in pci_enable_msix() because
>> para-virtualization on PPC64 platform. So MSI-X table is safe to
>> access directly from the guest with EEH mechanism enabled.
> The MSI-X table is paravirtualized on vfio in general and interrupt
> remapping theoretically protects against errant interrupts, so why is
> this PPC64 specific?  We have the same safeguards on x86 if we want t=
o
> decide they're sufficient.  Offhand, the only way I can think that a
> device can touch the MSI-X table is via backdoors or p2p DMA with
> another device.
Maybe I didn't make my point clear. The reasons why we can mmap MSI-X
table on PPC64 are=EF=BC=9A

1. EEH mechanism could ensure that a given pci device can only shoot
the MSIs assigned for its PE. So it would not do harm to other memory
space when the guest write a garbage MSI-X address/data to the vector t=
able
if we passthough MSI-X tables to guest.

2. The guest kernel would not write to MSI-X table on PPC64 platform
when device drivers call pci_enable_msix() to initialize MSI-X interrup=
ts.

So I think it is safe to mmap/passthrough MSI-X table on PPC64 platform=
=2E
And I'm not sure whether other architectures can ensure these two=20
points. Thanks.

Regards
Yongji Xie
>> This patch adds support for this case and allow to mmap MSI-X
>> table if EEH is supported on PPC64 platform.
>>
>> And we also add a VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP flag to notify
>> userspace that it's safe to mmap MSI-X table.
>>
>> Signed-off-by: Yongji Xie <xyjxie@linux.vnet.ibm.com>
>> ---
>>   drivers/vfio/pci/vfio_pci.c         |    5 ++++-
>>   drivers/vfio/pci/vfio_pci_private.h |    5 +++++
>>   include/uapi/linux/vfio.h           |    2 ++
>>   3 files changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci=
=2Ec
>> index dbcad99..85d9980 100644
>> --- a/drivers/vfio/pci/vfio_pci.c
>> +++ b/drivers/vfio/pci/vfio_pci.c
>> @@ -446,6 +446,9 @@ static long vfio_pci_ioctl(void *device_data,
>>   		if (vfio_pci_bar_page_aligned())
>>   			info.flags |=3D VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED;
>>  =20
>> +		if (vfio_msix_table_mmap_enabled())
>> +			info.flags |=3D VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP;
>> +
>>   		info.num_regions =3D VFIO_PCI_NUM_REGIONS;
>>   		info.num_irqs =3D VFIO_PCI_NUM_IRQS;
>>  =20
>> @@ -871,7 +874,7 @@ static int vfio_pci_mmap(void *device_data, stru=
ct vm_area_struct *vma)
>>   	if (phys_len < PAGE_SIZE || req_start + req_len > phys_len)
>>   		return -EINVAL;
>>  =20
>> -	if (index =3D=3D vdev->msix_bar) {
>> +	if (index =3D=3D vdev->msix_bar && !vfio_msix_table_mmap_enabled()=
) {
>>   		/*
>>   		 * Disallow mmaps overlapping the MSI-X table; users don't
>>   		 * get to touch this directly.  We could find somewhere
>> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/=
vfio_pci_private.h
>> index 319352a..835619e 100644
>> --- a/drivers/vfio/pci/vfio_pci_private.h
>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>> @@ -74,6 +74,11 @@ static inline bool vfio_pci_bar_page_aligned(void=
)
>>   	return IS_ENABLED(CONFIG_PPC64);
>>   }
>>  =20
>> +static inline bool vfio_msix_table_mmap_enabled(void)
>> +{
>> +	return IS_ENABLED(CONFIG_EEH);
>> +}
> I really dislike these.
>
>> +
>>   extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
>>   extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
>>  =20
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 1fc8066..289e662 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -173,6 +173,8 @@ struct vfio_device_info {
>>   #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>>   /* Platform support all PCI MMIO BARs to be page aligned */
>>   #define VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED	(1 << 4)
>> +/* Platform support mmapping PCI MSI-X vector table */
>> +#define VFIO_DEVICE_FLAGS_PCI_MSIX_MMAP	(1 << 5)
> Again, not sure why this is on the device versus the region, but I'd
> prefer to investigate whether we can handle this with the sparse mmap
> capability (or lack of) in the capability chains I proposed[1]. Thank=
s,
>
> Alex
>
> [1] https://lkml.org/lkml/2015/11/23/748
>
Good idea! I wiil investigate it. Thanks.

Regards
Yongji Xie
>>   	__u32	num_regions;	/* Max region index + 1 */
>>   	__u32	num_irqs;	/* Max IRQ index + 1 */
>>   };
