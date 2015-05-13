From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Wed, 13 May 2015 18:29:05 +0200
Message-ID: <CALszF6DHazhN6+hGShyrmqtMrPod0hdb8mHAwK-GWfRxXzy7wQ@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<3125409.QXbEmPolyh@wuerfel>
	<55536BC2.30603@linaro.org>
	<11310179.epfRucfQKB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <11310179.epfRucfQKB@wuerfel>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc>
List-Id: linux-api@vger.kernel.org

2015-05-13 17:28 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 13 May 2015 16:20:34 Daniel Thompson wrote:
>> For the all reset bits:
>>
>>    clock idx = reset idx + 256
>>
>> The opposite is not true; the clock bits are a superset of the reset
>> bits (the reset bits act on cells but some cells have >1 clock).
>
> Ok, in that case, I would strongly recommend subtracting that 256
> offset keeping the numbers the same, to remove the function-type
> macros.
>
>> >> However there are a couple of clocks without gating just before the
>> >> clock reaches the peripheral:
>> >>
>> >> 1. A hard coded /8. I think this will have to be given a synthetic
>> >>      number.
>> >
>> > If this is just a divider, why not use a separate DT node for that,
>> > like this:
>> >
>> >          clock {
>> >                  compatible = "fixed-factor-clock";
>> >                  clocks = <&parentclk>;
>> >                  #clock-cells = <0>;
>> >                  clock-div = <8>;
>> >                  clock-mult = <1>;
>> >          };
>> >
>> > No need to assign a number for this.
>>
>> I'd wondered about doing that.
>>
>> It will certainly work but it seemed a bit odd to me to have one (really
>> tiny) part of the RCC cell included seperately in the platform
>> description whilst all the complicated bits end up aggregated into the
>> RCC cell.
>>
>> Is there much prior art that uses this type of trick to avoid having
>> magic numbers into the bindings?
>
> Are you sure that divider is actually part of the RCC?
>
>> >> 2. Ungated dividers. For these I am using the bit offset of the LSB of
>> >>      the mux field.
>> >
>> > Do these ones also come with resets?
>>
>> No. They mostly run to the core and its intimate peripherals (i.e. only
>> reset line comes from WDT).
>
> Ok.
>
>> >> So I think there is only one value that is completely unrelated to the
>> >> hardware and will use a magic constant instead.
>> >>
>> >> I had planned to macros similar to the STM32F4_AxB_RESET() family of
>> >> macros in both clk driver and DT in order to reuse the bit layouts from
>> >> dt-bindings/mfd/stm32f4-rcc.h .
>> >>
>> >> Normal case would have looked like this:
>> >>
>> >>                  timer3: timer@40000000 {
>> >>                          compatible = "st,stm32-timer";
>> >>                          reg = <0x40000000 0x400>;
>> >>                          interrupts = <28>;
>> >>                          resets = <&rcc STM32F4_APB1_RESET(TIM3)>;
>> >>                          clocks = <&rcc STM32F4_APB1_CLK(TIM3)>;
>> >>                          status = "disabled";
>> >>                  };
>> >>
>> >> Without the macros it looks like this:
>> >>
>> >>                  timer3: timer@40000000 {
>> >>                          compatible = "st,stm32-timer";
>> >>                          reg = <0x40000000 0x400>;
>> >>                          interrupts = <28>;
>> >>                          resets = <&rcc 257>;
>> >>                          clocks = <&rcc 513>;
>> >>                          status = "disabled";
>> >>                  };
>> >>
>> >> However we could perhaps be more literate even if we don't use the macros?
>> >>
>> >>                  timer3: timer@40000000 {
>> >>                          compatible = "st,stm32-timer";
>> >>                          reg = <0x40000000 0x400>;
>> >>                          interrupts = <28>;
>> >>                          resets = <&rcc ((0x20*8) + 1)>;
>> >>                          clocks = <&rcc ((0x40*8) + 1)>;
>> >>                          status = "disabled";
>> >>                  };
>> >
>> > How about #address-cells = <2>, so you can do
>> >
>> >             resets = <&rcc 8 1>;
>> >             clocks = <&rcc 8 1>;
>> >
>> > with the first cell being an index for the block and the second cell the
>> > bit number within that block.
>>
>> That would suit me very well (although is the 0x20/0x40 not the 8 that
>> we would need in the middle column).
>
> We don't normally use register offsets in DT. The number 8 here instead
> would indicate block 8, where each block is four bytes wide. Using the
> same index here for reset and clock would also help readability.

My view is that it makes the bindings usage very complex.
Also, it implies we have a specific compatible for stm32f429, whereas
we didn't need with my earlier proposals.
Indeed, the reset driver will need to know the offset of every reset
registers, because:
  1. The AHB registers start at RCC offset 0x10 (up to 0x18)
  2. The APB registers start at RCC offset 0x20 (up to 0x24).
We have a gap between AHB and APB registers, so how do we map the
index for the block you propose?
Should the gap be considered as a block, or we should skip it?

I'm afraid it will not be straightforward for a reset user to
understand how to use this bindings.

Either my v7 or v8 versions would have made possible to use a single
compatible for STM32 series.
If we stick with one of these, we could even think to have a "generic"
reset driver, as it could be compatible with sunxi driver bindings.

What is your view?

Kind regards,
Maxime

>
>         Arnd
