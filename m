From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: Removing __kernel_old_uid_t, git_t, dev_t
Date: Mon, 30 Mar 2009 17:17:56 +0200
Message-ID: <200903301717.57184.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com> <200903301558.10598.arnd@arndb.de> <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10f740e80903300741h387e6342veba0ccceea6714e9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert.uytterhoeven-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: michal.simek-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday 30 March 2009, Geert Uytterhoeven wrote:
> On Mon, Mar 30, 2009 at 15:58, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> > +/*
> > + * int-ll64 is used on all 32 bit architectures and on x86-64,
> > + * so use it as a reasonable default.
> > + */
> > +#include <asm-generic/int-ll64.h>
> > +
> 
> Most 64-bit archs have been migrated to ll64 by now.
> Alpha, ia64, and mips64 are the remaining exceptions.

Right, the comment is stale.

> > +/*
> > + * DMA addresses may be larger than pointers, but not smaller.
> > + * Do not define the dma64_addr_t type, which never really
> > + * worked.
> > + */
> > +#if defined(CONFIG_64BIT) || defined(CONFIG_PHYS_64BIT)
> > +typedef u64 dma_addr_t;
> > +#else
> > +typedef u32 dma_addr_t;
> > +#endif /* 64 bit DMA pointer */
> 
> Is there any specific reason why dma_addr_t is in <asm/types.h>, while
> phys_addr_t is in
> <linux/types.h>?

dma_addr_t is a big mess that was traditionally defined per
architecture, in lots of wrong ways, including the misconception
of dma64_addr_t. Sparc64 still uses a 32 bit dma_addr_t, possibly
because it always uses an IOMMU (?). It can save some space in
scatterlists, but might come back to bite us if someone tries
to build a sparc64 system with actual 64-bit DMA.

phys_addr_t is a new definition that was added last August (after
I did my patch) by Jeremy Fitzhardinge and is for DMA purposes.

> Furthermore, CONFIG_PHYS_64BIT is used on PPC only. Probably it should be
> replaced by CONFIG_PHYS_ADDR_T_64BIT, which is always set if CONFIG_64BIT,
> so the #ifdef above becomes even simpler?

Yes, they could be consolidated now, which would make the default
dma_addr_t the same as phys_addr_t, with the possible exception of
sparc64.

	Arnd <><
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
