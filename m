From: yongji xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] vfio-pci: Allow to mmap sub-page MMIO BARs if all
 MMIO BARs are page aligned
Date: Fri, 18 Dec 2015 16:23:50 +0800
Message-ID: <5673C296.8010403@linux.vnet.ibm.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
 <1449823994-3356-3-git-send-email-xyjxie@linux.vnet.ibm.com>
 <1450296276.2674.55.camel@redhat.com> <56728DC8.20803@linux.vnet.ibm.com>
 <1450388804.2674.158.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450388804.2674.158.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org, benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org, paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, warrier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nikunj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 2015/12/18 5:46, Alex Williamson wrote:
> On Thu, 2015-12-17 at 18:26 +0800, yongji xie wrote:
>> On 2015/12/17 4:04, Alex Williamson wrote:
>>> On Fri, 2015-12-11 at 16:53 +0800, Yongji Xie wrote:
>>>> Current vfio-pci implementation disallows to mmap
>>>> sub-page(size < PAGE_SIZE) MMIO BARs because these BARs' mmio
>>>> page
>>>> may be shared with other BARs.
>>>>
>>>> But we should allow to mmap these sub-page MMIO BARs if all MMIO
>>>> BARs
>>>> are page aligned which leads the BARs' mmio page would not be
>>>> shared
>>>> with other BARs.
>>>>
>>>> This patch adds support for this case and we also add a
>>>> VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED flag to notify userspace that
>>>> platform supports all MMIO BARs to be page aligned.
>>>>
>>>> Signed-off-by: Yongji Xie <xyjxie-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>>>> ---
>>>>    drivers/vfio/pci/vfio_pci.c         |   10 +++++++++-
>>>>    drivers/vfio/pci/vfio_pci_private.h |    5 +++++
>>>>    include/uapi/linux/vfio.h           |    2 ++
>>>>    3 files changed, 16 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/vfio/pci/vfio_pci.c
>>>> b/drivers/vfio/pci/vfio_pci.c
>>>> index 32b88bd..dbcad99 100644
>>>> --- a/drivers/vfio/pci/vfio_pci.c
>>>> +++ b/drivers/vfio/pci/vfio_pci.c
>>>> @@ -443,6 +443,9 @@ static long vfio_pci_ioctl(void *device_data,
>>>>    		if (vdev->reset_works)
>>>>    			info.flags |= VFIO_DEVICE_FLAGS_RESET;
>>>>    
>>>> +		if (vfio_pci_bar_page_aligned())
>>>> +			info.flags |=
>>>> VFIO_DEVICE_FLAGS_PCI_PAGE_ALIGNED;
>>>> +
>>>>    		info.num_regions = VFIO_PCI_NUM_REGIONS;
>>>>    		info.num_irqs = VFIO_PCI_NUM_IRQS;
>>>>    
>>>> @@ -479,7 +482,8 @@ static long vfio_pci_ioctl(void *device_data,
>>>>    				     VFIO_REGION_INFO_FLAG_WRIT
>>>> E;
>>>>    			if (IS_ENABLED(CONFIG_VFIO_PCI_MMAP) &&
>>>>    			    pci_resource_flags(pdev,
>>>> info.index) &
>>>> -			    IORESOURCE_MEM && info.size >=
>>>> PAGE_SIZE)
>>>> +			    IORESOURCE_MEM && (info.size >=
>>>> PAGE_SIZE ||
>>>> +			    vfio_pci_bar_page_aligned()))
>>>>    				info.flags |=
>>>> VFIO_REGION_INFO_FLAG_MMAP;
>>>>    			break;
>>>>    		case VFIO_PCI_ROM_REGION_INDEX:
>>>> @@ -855,6 +859,10 @@ static int vfio_pci_mmap(void *device_data,
>>>> struct vm_area_struct *vma)
>>>>    		return -EINVAL;
>>>>    
>>>>    	phys_len = pci_resource_len(pdev, index);
>>>> +
>>>> +	if (vfio_pci_bar_page_aligned())
>>>> +		phys_len = PAGE_ALIGN(phys_len);
>>>> +
>>>>    	req_len = vma->vm_end - vma->vm_start;
>>>>    	pgoff = vma->vm_pgoff &
>>>>    		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) -
>>>> 1);
>>>> diff --git a/drivers/vfio/pci/vfio_pci_private.h
>>>> b/drivers/vfio/pci/vfio_pci_private.h
>>>> index 0e7394f..319352a 100644
>>>> --- a/drivers/vfio/pci/vfio_pci_private.h
>>>> +++ b/drivers/vfio/pci/vfio_pci_private.h
>>>> @@ -69,6 +69,11 @@ struct vfio_pci_device {
>>>>    #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) ||
>>>> is_msix(vdev)))
>>>>    #define irq_is(vdev, type) (vdev->irq_type == type)
>>>>    
>>>> +static inline bool vfio_pci_bar_page_aligned(void)
>>>> +{
>>>> +	return IS_ENABLED(CONFIG_PPC64);
>>>> +}
>>> I really dislike this.  This is a problem for any architecture that
>>> runs on larger pages, and even an annoyance on 4k hosts.  Why are
>>> we
>>> only solving it for PPC64?
>> Yes, I know it's a problem for other architectures. But I'm not sure
>> if
>> other archs prefer
>> to enforce the alignment of all BARs to be at least PAGE_SIZE which
>> would result in
>> some waste of address space.
>>
>> So I just propose a prototype and add PPC64 support here. And other
>> archs could decide
>> to use it or not by themselves.
>>> Can't we do something similar in the core PCI code and detect it?
>> So you mean we can do it like this:
>>
>> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
>> index d390fc1..f46c04d 100644
>> --- a/drivers/pci/pci.h
>> +++ b/drivers/pci/pci.h
>> @@ -320,6 +320,11 @@ static inline resource_size_t
>> pci_resource_alignment(struct pci_dev *dev,
>>           return resource_alignment(res);
>>    }
>>
>> +static inline bool pci_bar_page_aligned(void)
>> +{
>> +       return IS_ENABLED(CONFIG_PPC64);
>> +}
>> +
>>    void pci_enable_acs(struct pci_dev *dev);
>>
>>    struct pci_dev_reset_methods {
>>
>> or add a config option to indicate that PCI MMIO BARs should be page
>> aligned?
> Yes, I'm thinking of a boot commandline option, maybe one that PPC64
> can default to enabled if it chooses to.  The problem is not unique to
> PPC64 and the solution should not be unique either.  I don't want to
> need to revisit this for ARM, which we know is going to be similarly
> afflicted.  Thanks,
>
> Alex
>
OK. I will try to fix it by adding a boot commandline option.
It seems to be better than adding a config option. Thanks

Regards
Yongji Xie
