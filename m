From: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
Date: Mon, 30 Mar 2009 16:41:27 +0200
Message-ID: <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
References: <49D071A8.4010703@petalogix.com> <200903301558.10598.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <200903301558.10598.arnd@arndb.de>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: michal.simek@petalogix.com, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2009 at 15:58, Arnd Bergmann <arnd@arndb.de> wrote:
> diff --git a/include/asm-generic/types.h b/include/asm-generic/types.h
> new file mode 100644
> index 0000000..5841716
> --- /dev/null
> +++ b/include/asm-generic/types.h
> @@ -0,0 +1,56 @@
> +#ifndef __ASM_GENERIC_TYPES_H
> +#define __ASM_GENERIC_TYPES_H
> +
> +/*
> + * int-ll64 is used on all 32 bit architectures and on x86-64,
> + * so use it as a reasonable default.
> + */
> +#include <asm-generic/int-ll64.h>
> +

Most 64-bit archs have been migrated to ll64 by now.
Alpha, ia64, and mips64 are the remaining exceptions.

> +/*
> + * DMA addresses may be larger than pointers, but not smaller.
> + * Do not define the dma64_addr_t type, which never really
> + * worked.
> + */
> +#if defined(CONFIG_64BIT) || defined(CONFIG_PHYS_64BIT)
> +typedef u64 dma_addr_t;
> +#else
> +typedef u32 dma_addr_t;
> +#endif /* 64 bit DMA pointer */

Is there any specific reason why dma_addr_t is in <asm/types.h>, while
phys_addr_t is in
<linux/types.h>?

Furthermore, CONFIG_PHYS_64BIT is used on PPC only. Probably it should be
replaced by CONFIG_PHYS_ADDR_T_64BIT, which is always set if CONFIG_64BIT,
so the #ifdef above becomes even simpler?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
