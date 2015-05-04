From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 05/15] dt-bindings: Document the STM32 reset bindings
Date: Mon, 4 May 2015 13:11:48 +0200
Message-ID: <CALszF6DpwfeaXRnOyyL+EJv2dYoGuUQtXZsiMisuaAj1_jCLFw@mail.gmail.com>
References: <1430410844-16062-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1430410844-16062-6-git-send-email-mcoquelin.stm32@gmail.com>
	<55433467.2010603@linaro.org>
	<CALszF6Bw900E9MtpaVmvkFxsrOODRkNg+RxRXz5V3WghHtsxbw@mail.gmail.com>
	<5544A069.5000808@linaro.org>
	<1430735320.3722.34.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430735320.3722.34.camel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Cc: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <gal>
List-Id: linux-api@vger.kernel.org

2015-05-04 12:28 GMT+02:00 Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>:
> Am Samstag, den 02.05.2015, 11:01 +0100 schrieb Daniel Thompson:
>> On 02/05/15 08:55, Maxime Coquelin wrote:
>> > 2015-05-01 10:08 GMT+02:00 Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>:
> [...]
>> >> Do you intend the clock driver to use the same compatible string (given it
>> >> is the same bit of hardware).
>> >>
>> >> If so, is it better to use st,stm32f4-rcc here? It seems unlikey to me that
>> >> the register layout of the PLLs and dividers can be the same on the f7 parts
>> >> (and later).
>> >
>> > I agree we need a compatible dedicate to f4 series for clocks, and
>> > maybe even one for f429 (to be checked).
>> > For the reset part, we don't have this need.
>> >
>> > So either we use only "st,stm32f4" as you suggest, or we can have both
>> > in device tree:
>> >
>> > rcc: reset@40023800 {
>> >      #reset-cells = <1>;
>> >      compatible = "st,stm32f4-rcc", "st,stm32-rcc";
>> >      reg = <0x40023800 0x400>;
>> > };
>> >
>> > What do you think?
>>
>> Having both makes sense. The reset driver probably doesn't care about
>> differences between F4 and F7 (I know very little about F7 but I can't
>> think of any obvious h/ware evolution that would confuse the current
>> reset driver).
>
> Seconded, this is exactly the way compatible string lists are supposed
> to be used.

Ok good, so we all agree.

I propose I keep "st,stm32-rcc" only for this series, as it does not
contain the clock driver.
The series adding the clock driver will add "st,stm32f4-rcc", or
"st,stm32f429-rcc" depending on clock driver needs.

Thanks,
Maxime

>
> [...]
>
> regards
> Philipp
>
