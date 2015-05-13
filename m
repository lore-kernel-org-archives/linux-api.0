From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Wed, 13 May 2015 18:37:46 +0200
Message-ID: <2282066.NWoIT9ZyLc@wuerfel>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com> <11310179.epfRucfQKB@wuerfel> <CALszF6DHazhN6+hGShyrmqtMrPod0hdb8mHAwK-GWfRxXzy7wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALszF6DHazhN6+hGShyrmqtMrPod0hdb8mHAwK-GWfRxXzy7wQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian
List-Id: linux-api@vger.kernel.org

On Wednesday 13 May 2015 18:29:05 Maxime Coquelin wrote:
> 2015-05-13 17:28 GMT+02:00 Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>:
> > On Wednesday 13 May 2015 16:20:34 Daniel Thompson wrote:
> >>
> >> That would suit me very well (although is the 0x20/0x40 not the 8 that
> >> we would need in the middle column).
> >
> > We don't normally use register offsets in DT. The number 8 here instead
> > would indicate block 8, where each block is four bytes wide. Using the
> > same index here for reset and clock would also help readability.
> 
> My view is that it makes the bindings usage very complex.
> Also, it implies we have a specific compatible for stm32f429, whereas
> we didn't need with my earlier proposals.
> Indeed, the reset driver will need to know the offset of every reset
> registers, because:
>   1. The AHB registers start at RCC offset 0x10 (up to 0x18)
>   2. The APB registers start at RCC offset 0x20 (up to 0x24).
> We have a gap between AHB and APB registers, so how do we map the
> index for the block you propose?
> Should the gap be considered as a block, or we should skip it?
>
> I'm afraid it will not be straightforward for a reset user to
> understand how to use this bindings.
> 
> Either my v7 or v8 versions would have made possible to use a single
> compatible for STM32 series.
> If we stick with one of these, we could even think to have a "generic"
> reset driver, as it could be compatible with sunxi driver bindings.

We should definitely try to use the same compatible string for all of
them, and make a binding that is easy to use.

I haven't fully understood the requirements for the various parts that
are involved here. My understanding so far was that the driver could
use the index from the first cell and compute

	void __iomem *reset_reg = rcc_base + 0x10 + 4 * index;
	void __iomem *clock_reg = rcc_base + 0x30 + 4 * index;

Are there parts that need something else? If the 0x10 offset is
different, we probably want a different compatible string, and I'd
consider it a different part at that point. If there are chips
that do not spread the clock from the reset by exactly 256 bits,
we could add a DT property in the rcc node for that.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
