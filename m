From: Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: Re: [PATCH 2/5] vfio: introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Tue, 21 Oct 2014 14:17:48 +0200
Message-ID: <CAG8rG2wK+E-sS-CG3sxwftkvr2Lq8uKhZSNuBUJRKURrtSF=nQ@mail.gmail.com>
References: <1413205748-6300-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205748-6300-3-git-send-email-a.motakis@virtualopensystems.com> <1413840583.4202.111.camel@ul30vt.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413840583.4202.111.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>, Linux IOMMU <iommu@lists.linux-foundation.org>, Will Deacon <will.deacon@arm.com>, VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, Kim Phillips <kim.phillips@freescale.com>, Marc Zyngier <marc.zyngier@arm.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 11:29 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-13 at 15:09 +0200, Antonios Motakis wrote:
>> We introduce the VFIO_DMA_MAP_FLAG_NOEXEC flag to the VFIO dma map call,
>> and expose its availability via the capability VFIO_DMA_NOEXEC_IOMMU.
>> This way the user can control whether the XN flag will be set on the
>> requested mappings. The IOMMU_NOEXEC flag needs to be available for all
>> the IOMMUs of the container used.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  include/uapi/linux/vfio.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 6612974..111b5e8 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -29,6 +29,7 @@
>>   * capability is subject to change as groups are added or removed.
>>   */
>>  #define VFIO_DMA_CC_IOMMU            4
>> +#define VFIO_DMA_NOEXEC_IOMMU                5
>>
>>  /* Check if EEH is supported */
>>  #define VFIO_EEH                     5
>                                     ^^
> 5 is still already used.  Feel free to convert to enum so we stop making
> this mistake.

Oops :) will do.

>
>> @@ -401,6 +402,7 @@ struct vfio_iommu_type1_dma_map {
>>       __u32   flags;
>>  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)              /* readable from device */
>>  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)     /* writable from device */
>> +#define VFIO_DMA_MAP_FLAG_NOEXEC (1 << 2)    /* not executable from device */
>>       __u64   vaddr;                          /* Process virtual address */
>>       __u64   iova;                           /* IO virtual address */
>>       __u64   size;                           /* Size of mapping (bytes) */
>
>
>



-- 
Antonios Motakis
Virtual Open Systems
