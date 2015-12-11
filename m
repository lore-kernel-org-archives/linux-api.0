From: Jonas Gorski <jogo-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH linux-next (v3) 1/3] MIPS: bcm963xx: Add Broadcom BCM963xx
 board nvram data structure
Date: Fri, 11 Dec 2015 23:02:56 +0100
Message-ID: <CAOiHx=m3cXTePDjH04Yoz3wQO9Ta9jSn=JrkfNgphoPcQVaGXg@mail.gmail.com>
References: <566B460F.1040603@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <566B460F.1040603-qdVf85lJwsCyrPCCpiK2c/XRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Simon Arlott <simon-A6De1vDTPLDsq35pWSNszA@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, MTD Maling List <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, bcm-kernel-feedback-list <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On Fri, Dec 11, 2015 at 10:54 PM, Simon Arlott <simon-A6De1vDTPLDsq35pWSNszA@public.gmane.org> wrote:
> Broadcom BCM963xx boards have multiple nvram variants across different
> SoCs with additional checksum fields added whenever the size of the
> nvram was extended.
>
> Add this structure as a header file so that multiple drivers and userspace
> can use it.
>
> Signed-off-by: Simon Arlott <simon-A6De1vDTPLDsq35pWSNszA@public.gmane.org>
> ---
> v3: Fix includes/type names, add comments explaining the nvram struct.
>
> v2: Use external struct bcm963xx_nvram definition for bcm963268part.
>
>  MAINTAINERS                         |  1 +
>  include/uapi/linux/bcm963xx_nvram.h | 53 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
>  create mode 100644 include/uapi/linux/bcm963xx_nvram.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b6d4e2e..abf18b4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2393,6 +2393,7 @@ F:        drivers/irqchip/irq-bcm63*
>  F:     drivers/irqchip/irq-bcm7*
>  F:     drivers/irqchip/irq-brcmstb*
>  F:     include/linux/bcm63xx_wdt.h
> +F:     include/uapi/linux/bcm963xx_nvram.h
>
>  BROADCOM TG3 GIGABIT ETHERNET DRIVER
>  M:     Prashant Sreedharan <prashant-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> diff --git a/include/uapi/linux/bcm963xx_nvram.h b/include/uapi/linux/bcm963xx_nvram.h
> new file mode 100644
> index 0000000..2dcb307
> --- /dev/null
> +++ b/include/uapi/linux/bcm963xx_nvram.h

Why uapi? The nvram layout isn't really enforced to be that way, and
at least Huawei uses a modified one on some devices (in case you
wondered why bcm63xx doesn't fail a crc32-"broken" one), so IMHO it
should be kept for in-kernel use only.

> @@ -0,0 +1,53 @@
> +#ifndef _UAPI__LINUX_BCM963XX_NVRAM_H__
> +#define _UAPI__LINUX_BCM963XX_NVRAM_H__
> +
> +#include <linux/types.h>
> +#include <linux/if_ether.h>
> +
> +/*
> + * Broadcom BCM963xx SoC board nvram data structure.
> + *
> + * The nvram structure varies in size depending on the SoC board version. Use
> + * the appropriate minimum BCM963XX_NVRAM_*_SIZE define for the information
> + * you need instead of sizeof(struct bcm963xx_nvram) as this may change.
> + *
> + * The "version" field value maps directly to the size and checksum names, e.g.
> + * version 4 uses "checksum_v4" and the data is BCM963XX_NVRAM_V4_SIZE bytes.
> + *
> + * Do not use the __reserved fields, especially not as an offset for CRC
> + * calculations (use BCM963XX_NVRAM_*_SIZE instead). These may be removed or
> + * repositioned.
> + */
> +
> +#define BCM963XX_NVRAM_V4_SIZE         300
> +#define BCM963XX_NVRAM_V5_SIZE         1024
> +#define BCM963XX_NVRAM_V6_SIZE         BCM963XX_NVRAM_V5_SIZE
> +#define BCM963XX_NVRAM_V7_SIZE         3072
> +
> +#define BCM963XX_NVRAM_NR_PARTS                5
> +
> +struct bcm963xx_nvram {
> +       __u32   version;
> +       char    bootline[256];
> +       char    name[16];
> +       __u32   main_tp_number;
> +       __u32   psi_size;
> +       __u32   mac_addr_count;
> +       __u8    mac_addr_base[ETH_ALEN];
> +       __u8    __reserved1[2];
> +       __u32   checksum_v4;
> +
> +       __u8    __reserved2[292];
> +       __u32   nand_part_offset[BCM963XX_NVRAM_NR_PARTS];
> +       __u32   nand_part_size[BCM963XX_NVRAM_NR_PARTS];
> +       __u8    __reserved3[388];
> +       union {
> +               __u32   checksum_v5;
> +               __u32   checksum_v6;
> +       };

what's the point of this union? Both are the same size and have the
same function.

> +
> +       __u8    __reserved4[2044];
> +       __u32   checksum_v7;
> +} __packed;

Why is it __packed? there are no unaligned members, so it should work
fine without this (and it did for bcm63xx).


Jonas
