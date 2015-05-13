From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Wed, 13 May 2015 18:54:10 +0200
Message-ID: <CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<11310179.epfRucfQKB@wuerfel>
	<CALszF6DHazhN6+hGShyrmqtMrPod0hdb8mHAwK-GWfRxXzy7wQ@mail.gmail.com>
	<2282066.NWoIT9ZyLc@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2282066.NWoIT9ZyLc@wuerfel>
Sender: linux-doc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc>
List-Id: linux-api@vger.kernel.org

2015-05-13 18:37 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 13 May 2015 18:29:05 Maxime Coquelin wrote:
>> 2015-05-13 17:28 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
>> > On Wednesday 13 May 2015 16:20:34 Daniel Thompson wrote:
>> >>
>> >> That would suit me very well (although is the 0x20/0x40 not the 8 that
>> >> we would need in the middle column).
>> >
>> > We don't normally use register offsets in DT. The number 8 here instead
>> > would indicate block 8, where each block is four bytes wide. Using the
>> > same index here for reset and clock would also help readability.
>>
>> My view is that it makes the bindings usage very complex.
>> Also, it implies we have a specific compatible for stm32f429, whereas
>> we didn't need with my earlier proposals.
>> Indeed, the reset driver will need to know the offset of every reset
>> registers, because:
>>   1. The AHB registers start at RCC offset 0x10 (up to 0x18)
>>   2. The APB registers start at RCC offset 0x20 (up to 0x24).
>> We have a gap between AHB and APB registers, so how do we map the
>> index for the block you propose?
>> Should the gap be considered as a block, or we should skip it?
>>
>> I'm afraid it will not be straightforward for a reset user to
>> understand how to use this bindings.
>>
>> Either my v7 or v8 versions would have made possible to use a single
>> compatible for STM32 series.
>> If we stick with one of these, we could even think to have a "generic"
>> reset driver, as it could be compatible with sunxi driver bindings.
>
> We should definitely try to use the same compatible string for all of
> them, and make a binding that is easy to use.
>
> I haven't fully understood the requirements for the various parts that
> are involved here. My understanding so far was that the driver could
> use the index from the first cell and compute
>
>         void __iomem *reset_reg = rcc_base + 0x10 + 4 * index;
>         void __iomem *clock_reg = rcc_base + 0x30 + 4 * index;

This calculation is true, but we have to take into account there is a
hole in the middle, between AHB3, and APB1 register:

AHB1RSTR : offset = 0x10, index = 0
AHB2RSTR : offset = 0x14, index = 1
AHB3RSTR : offset = 0x18, index = 2
<HOLE >     : offset = 0x1c, index = 3
APB1RSTR : offset = 0x20, index = 4
APB2RSTR : offset = 0x24, index = 5

So we have to carefully document this hole in the bindings, maybe by
listing indexes in the documentation?

>
> Are there parts that need something else? If the 0x10 offset is
> different, we probably want a different compatible string, and I'd
> consider it a different part at that point. If there are chips
> that do not spread the clock from the reset by exactly 256 bits,
> we could add a DT property in the rcc node for that.

I will check other chips, to see if this is valid generally.

Thanks for your feedback,
Maxime

>
>         Arnd
