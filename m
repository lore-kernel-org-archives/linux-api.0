From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 05/18] reset: Add reset_controller_of_init() function
Date: Thu, 12 Mar 2015 22:08:13 +0100
Message-ID: <CALszF6AiZ_9Hgz36hyVTSWdtf06QxHnWKjNEjVdU7v7j8m1GiA@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<8729383.kvUZDm4dQz@wuerfel>
	<CALszF6BkTOLR+VNkRKfvEBG5ZyaYL+9fZ4EAPVu5b_imCvEQoQ@mail.gmail.com>
	<6773745.i9mx5zmPP4@wuerfel>
	<CAL_Jsq+_ridpAaUwpqo91xB6Ea1ctCWfYTYUrcZ=gB_0FiBD4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_Jsq+_ridpAaUwpqo91xB6Ea1ctCWfYTYUrcZ=gB_0FiBD4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P/iSf3S8Y7g3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2015-03-10 22:30 GMT+01:00 Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Tue, Mar 10, 2015 at 3:19 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>> On Tuesday 10 March 2015 16:28:44 Maxime Coquelin wrote:
>>> 2015-03-10 16:00 GMT+01:00 Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>:
>>> > On Friday 20 February 2015 19:01:04 Maxime Coquelin wrote:
>>> >> Some platforms need to initialize the reset controller before the timers.
>>> >>
>>> >> This patch introduces a reset_controller_of_init() function that can be
>>> >> called before the timers intialization.
>>> >>
>>> >> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> >>
>>> >
>>> > Not sure about this. It seems like the cleanest approach if we get
>>> > a lot of these, but then again it is probably very rare, and I'd
>>> > like to avoid adding such infrastructure if it's just for one
>>> > SoC. Could we add a hack in the machine initialization instead?
>>>
>>> Sun6i also need to initialize the reset controller early. Today, they
>>> hack the machine initialization.
>>> With two SoCs having the same need, what should we do?
>>
>> Good question, I'd like to hear some other opinions on this first.
>
> 2 is still far from the common case.
>
>>> > I think ideally this would be done in the boot loader before we
>>> > even start Linux, but I don't know if that's possible for you.
>>>
>>> From what I understand, the only constraint is to perform it after the
>>> clock is enabled.
>>> So this should be possible to do it in the bootloader, but it means
>>> also adding timers clocks ungating in the bootloader.
>>
>> Ungating the timer clock input seems like a reasonable thing to
>> do for the bootloader, I think a lot of platforms rely on this
>> elsewhere (but enough of them don't, which is why we have the
>> early clk init).
>
> +1
>
> If the bootloader is u-boot, then you need a timer anyway.

Ok, I moved it to the bootloader, and use the reset as optional in the
timer driver.

Thanks,
Maxime
>
> Rob
