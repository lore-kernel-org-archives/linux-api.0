From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Wed, 13 May 2015 15:27:31 +0200
Message-ID: <3125409.QXbEmPolyh@wuerfel>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com> <CALszF6CS8Q9DWX+ERtu=k=Bzr1-25N3oZQyWyxDZBF3an4nFKQ@mail.gmail.com> <55534A5D.6050904@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <55534A5D.6050904@linaro.org>
Sender: linux-gpio-owner@vger.kernel.org
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>, Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <u.kleine-koenig@pengutronix.de>, Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-api@vger.kernel.org

On Wednesday 13 May 2015 13:58:05 Daniel Thompson wrote:
> On 13/05/15 12:45, Maxime Coquelin wrote:
> > 2015-05-12 23:21 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> >> On Saturday 09 May 2015 09:53:56 Maxime Coquelin wrote:
> >>> +#include  <dt-bindings/mfd/stm32f4-rcc.h>
> >>> +
> >>>
> >>
> >> Can you find a way to avoid this dependency?
> >>
> >> Maybe you can change the bindings so that the numbers you pass as
> >> arguments to the reset and clock specifiers reflect the numbers that
> >> the hardware use?
> >
> > If I understand correctly, you prefer the way I did in v7 [0]?

Yes, that looks better. I would probably not list all the possible
values in the binding though, when the intention is to use the
hardware specific values, and being able to reuse the binding
and driver for variations of the same chip.

> > Note that doing that won't break the DT binary compatibility, as the
> > raw reset values, or the ones from defines are the same.
> >
> > Daniel, could you share an example of the bindings you would use for the clocks?
> 
> For the most cases, where there is a clock gate just before the 
> peripheral it looks pretty much like the reset driver and I use the bit 
> offset of the clock gating bit as the index.

Is this bit always the same index as the one for the reset driver?

> However there are a couple of clocks without gating just before the 
> clock reaches the peripheral:
> 
> 1. A hard coded /8. I think this will have to be given a synthetic
>     number.

If this is just a divider, why not use a separate DT node for that,
like this:

        clock {
                compatible = "fixed-factor-clock";
                clocks = <&parentclk>;
                #clock-cells = <0>;
                clock-div = <8>;
                clock-mult = <1>;
        };

No need to assign a number for this.

> 2. Ungated dividers. For these I am using the bit offset of the LSB of
>     the mux field.

Do these ones also come with resets?

> So I think there is only one value that is completely unrelated to the 
> hardware and will use a magic constant instead.
> 
> I had planned to macros similar to the STM32F4_AxB_RESET() family of 
> macros in both clk driver and DT in order to reuse the bit layouts from 
> dt-bindings/mfd/stm32f4-rcc.h .
> 
> Normal case would have looked like this:
> 
>                 timer3: timer@40000000 {
>                         compatible = "st,stm32-timer";
>                         reg = <0x40000000 0x400>;
>                         interrupts = <28>;
>                         resets = <&rcc STM32F4_APB1_RESET(TIM3)>;
>                         clocks = <&rcc STM32F4_APB1_CLK(TIM3)>;
>                         status = "disabled";
>                 };
> 
> Without the macros it looks like this:
> 
>                 timer3: timer@40000000 {
>                         compatible = "st,stm32-timer";
>                         reg = <0x40000000 0x400>;
>                         interrupts = <28>;
>                         resets = <&rcc 257>;
>                         clocks = <&rcc 513>;
>                         status = "disabled";
>                 };
> 
> However we could perhaps be more literate even if we don't use the macros?
> 
>                 timer3: timer@40000000 {
>                         compatible = "st,stm32-timer";
>                         reg = <0x40000000 0x400>;
>                         interrupts = <28>;
>                         resets = <&rcc ((0x20*8) + 1)>;
>                         clocks = <&rcc ((0x40*8) + 1)>;
>                         status = "disabled";
>                 };

How about #address-cells = <2>, so you can do

		resets = <&rcc 8 1>;
		clocks = <&rcc 8 1>;

with the first cell being an index for the block and the second cell the
bit number within that block.

	Arnd
