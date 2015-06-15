From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [RFC v2 23/24] m68k/mac: Fix PRAM accessors
Date: Mon, 15 Jun 2015 10:23:17 +0200
Message-ID: <CAMuHMdWzKvWjAE3u54E4xewEDX+zJqEDEvRmO2twpeD2vmBzog@mail.gmail.com>
References: <20150614074607.242676098@telegraphics.com.au>
	<20150614074613.054681242@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150614074613.054681242-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux/m68k <linux-m68k-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Finn,

On Sun, Jun 14, 2015 at 9:46 AM, Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org> wrote:
> --- linux.orig/arch/m68k/mac/misc.c     2015-06-14 17:46:02.000000000 +1000
> +++ linux/arch/m68k/mac/misc.c  2015-06-14 17:46:03.000000000 +1000
> @@ -284,11 +287,31 @@ static void via_pram_command(int command
>
>  static unsigned char via_pram_read_byte(int offset)
>  {
> -       return 0;
> +       unsigned char temp;
> +       int addr = ((offset & 0xE0) << 3) | ((offset & 0x1F) << 2);

Can you please add #defines for the magic values?

> +
> +       /* Use RTC command 0x38 for XPRAM access, as per MESS source code */
> +       via_pram_command(addr | 0x3800 | 0x8001, &temp);

It seems 0x38 is already documented in <linux/pmu.h> (see below), or not (it's
shifted left by 8 bits?)?

> +
> +       return temp;
>  }
>
>  static void via_pram_write_byte(unsigned char data, int offset)
>  {
> +       unsigned char temp;
> +       int addr = ((offset & 0xE0) << 3) | ((offset & 0x1F) << 2);
> +
> +       /* Clear the write protect bit */
> +       temp = 0x55;
> +       via_pram_command(0x34 | 0x01, &temp);
> +
> +       /* Write the byte to XPRAM */
> +       temp = data;
> +       via_pram_command(0x3800 | 0x0001 | addr, &temp);
> +
> +       /* Set the write protect bit */
> +       temp = 0xD5;
> +       via_pram_command(0x34 | 0x01, &temp);

More magic values...

>  }
>
>  /*
> Index: linux/include/uapi/linux/pmu.h
> ===================================================================
> --- linux.orig/include/uapi/linux/pmu.h 2015-06-14 17:45:34.000000000 +1000
> +++ linux/include/uapi/linux/pmu.h      2015-06-14 17:46:03.000000000 +1000
> @@ -18,7 +18,9 @@
>  #define PMU_POWER_CTRL         0x11    /* control power of some devices */
>  #define PMU_ADB_CMD            0x20    /* send ADB packet */
>  #define PMU_ADB_POLL_OFF       0x21    /* disable ADB auto-poll */
> +#define PMU_WRITE_XPRAM                0x32    /* write eXtended Parameter RAM */
>  #define PMU_WRITE_NVRAM                0x33    /* write non-volatile RAM */
> +#define PMU_READ_XPRAM         0x3a    /* read eXtended Parameter RAM */
>  #define PMU_READ_NVRAM         0x3b    /* read non-volatile RAM */
>  #define PMU_SET_RTC            0x30    /* set real-time clock */
>  #define PMU_READ_RTC           0x38    /* read real-time clock */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
