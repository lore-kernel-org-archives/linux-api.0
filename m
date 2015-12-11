From: Jonas Gorski <jogo@openwrt.org>
Subject: Re: [PATCH linux-next (v3) 1/3] MIPS: bcm963xx: Add Broadcom BCM963xx
 board nvram data structure
Date: Sat, 12 Dec 2015 00:29:53 +0100
Message-ID: <CAOiHx=nrZdvezkyLi0kfvZ6Rp3YtechtP=J2orpUsVkXvA_6HQ@mail.gmail.com>
References: <566B460F.1040603@simon.arlott.org.uk> <CAOiHx=m3cXTePDjH04Yoz3wQO9Ta9jSn=JrkfNgphoPcQVaGXg@mail.gmail.com>
 <566B4D34.9040707@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566B4D34.9040707@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Cc: David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>, Ralf Baechle <ralf@linux-mips.org>, Kevin Cernekee <cernekee@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, MTD Maling List <linux-mtd@lists.infradead.org>, bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>, MIPS Mailing List <linux-mips@linux-mips.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Dec 11, 2015 at 11:24 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
> On 11/12/15 22:02, Jonas Gorski wrote:
>> Hi,
>>
>> On Fri, Dec 11, 2015 at 10:54 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
>>> Broadcom BCM963xx boards have multiple nvram variants across different
>>> SoCs with additional checksum fields added whenever the size of the
>>> nvram was extended.
>>>
>>> Add this structure as a header file so that multiple drivers and userspace
>>> can use it.
>>>
>>> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
>>> ---
>>> v3: Fix includes/type names, add comments explaining the nvram struct.
>>>
>>> v2: Use external struct bcm963xx_nvram definition for bcm963268part.
>>>
>>>  MAINTAINERS                         |  1 +
>>>  include/uapi/linux/bcm963xx_nvram.h | 53 +++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 54 insertions(+)
>>>  create mode 100644 include/uapi/linux/bcm963xx_nvram.h
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 6b6d4e2e..abf18b4 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -2393,6 +2393,7 @@ F:        drivers/irqchip/irq-bcm63*
>>>  F:     drivers/irqchip/irq-bcm7*
>>>  F:     drivers/irqchip/irq-brcmstb*
>>>  F:     include/linux/bcm63xx_wdt.h
>>> +F:     include/uapi/linux/bcm963xx_nvram.h
>>>
>>>  BROADCOM TG3 GIGABIT ETHERNET DRIVER
>>>  M:     Prashant Sreedharan <prashant@broadcom.com>
>>> diff --git a/include/uapi/linux/bcm963xx_nvram.h b/include/uapi/linux/bcm963xx_nvram.h
>>> new file mode 100644
>>> index 0000000..2dcb307
>>> --- /dev/null
>>> +++ b/include/uapi/linux/bcm963xx_nvram.h
>>
>> Why uapi? The nvram layout isn't really enforced to be that way, and
>> at least Huawei uses a modified one on some devices (in case you
>> wondered why bcm63xx doesn't fail a crc32-"broken" one), so IMHO it
>> should be kept for in-kernel use only.
>
> Because Florian suggested include/uapi/linux/bcm963xx_nvram.h; I could
> move it to include/linux/ instead if this is preferred.
>
>>> @@ -0,0 +1,53 @@
>>> +#ifndef _UAPI__LINUX_BCM963XX_NVRAM_H__
>>> +#define _UAPI__LINUX_BCM963XX_NVRAM_H__
>>> +
>>> +#include <linux/types.h>
>>> +#include <linux/if_ether.h>
>>> +
>>> +/*
>>> + * Broadcom BCM963xx SoC board nvram data structure.
>>> + *
>>> + * The nvram structure varies in size depending on the SoC board version. Use
>>> + * the appropriate minimum BCM963XX_NVRAM_*_SIZE define for the information
>>> + * you need instead of sizeof(struct bcm963xx_nvram) as this may change.
>>> + *
>>> + * The "version" field value maps directly to the size and checksum names, e.g.
>>> + * version 4 uses "checksum_v4" and the data is BCM963XX_NVRAM_V4_SIZE bytes.
>>> + *
>>> + * Do not use the __reserved fields, especially not as an offset for CRC
>>> + * calculations (use BCM963XX_NVRAM_*_SIZE instead). These may be removed or
>>> + * repositioned.

Because I just saw that: Nobody will read that. ;p

>>> + */
>>> +
>>> +#define BCM963XX_NVRAM_V4_SIZE         300
>>> +#define BCM963XX_NVRAM_V5_SIZE         1024
>>> +#define BCM963XX_NVRAM_V6_SIZE         BCM963XX_NVRAM_V5_SIZE
>>> +#define BCM963XX_NVRAM_V7_SIZE         3072
>>> +
>>> +#define BCM963XX_NVRAM_NR_PARTS                5
>>> +
>>> +struct bcm963xx_nvram {
>>> +       __u32   version;
>>> +       char    bootline[256];
>>> +       char    name[16];
>>> +       __u32   main_tp_number;
>>> +       __u32   psi_size;
>>> +       __u32   mac_addr_count;
>>> +       __u8    mac_addr_base[ETH_ALEN];
>>> +       __u8    __reserved1[2];
>>> +       __u32   checksum_v4;
>>> +
>>> +       __u8    __reserved2[292];
>>> +       __u32   nand_part_offset[BCM963XX_NVRAM_NR_PARTS];
>>> +       __u32   nand_part_size[BCM963XX_NVRAM_NR_PARTS];
>>> +       __u8    __reserved3[388];
>>> +       union {
>>> +               __u32   checksum_v5;
>>> +               __u32   checksum_v6;
>>> +       };
>>
>> what's the point of this union? Both are the same size and have the
>> same function.
>
> For convenience when deciding which size of nvram to use.
>
> The mach-bcm63xx code uses the V5 definitions because it supports
> checksums at the v4 and v5 sizes.
>
> The bcm963xxpart code uses the V6 definitions because that's what my
> board has and I can't tell if the nand_part values are valid in version
> 5 or if they were only added in version 6.

But you don't have a

union {
        __u32   checksum_v1;
        __u32   checksum_v2;
        __u32   checksum_v3;
        __u32   checksum_v4;
};

so this seems inconsistent. Maybe just call these checksum_v4 /
checksum_1k / checksum_3k?

>
>>> +
>>> +       __u8    __reserved4[2044];
>>> +       __u32   checksum_v7;

FWIW, this seems to be only present on secure boot enabled BCM963268
boards or so, so isn't really a v7 checksum, but a signature present
nvram extended checksum. on != 63268 boards with a v7 nvram this won't
exist.

>>> +} __packed;
>>
>> Why is it __packed? there are no unaligned members, so it should work
>> fine without this (and it did for bcm63xx).
>
> I could remove it, but as soon as someone adds an unaligned member but
> forgets to add __packed it's going to break.

Broadcom doesn't use __packed  either, so one can assume anything with
alignment requirements will be aligned.

>
> There are unaligned members in some of the __reserved areas, like this
> one:
>
> #define NVRAM_GPON_SERIAL_NUMBER_LEN    13
> #define NVRAM_GPON_PASSWORD_LEN         11
>
>     char gponSerialNumber[NVRAM_GPON_SERIAL_NUMBER_LEN];
>     char gponPassword[NVRAM_GPON_PASSWORD_LEN];

char is size 1, it can never be unaligned (as relevant for __packed).
And together they are a multiple of 4, so anything following will be
correctly aligned again.


Jonas
