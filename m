From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Thu, 14 May 2015 18:34:15 +0200
Message-ID: <CALszF6AhwtYMfhpZjGJeHznteG0mG0_2qo1TcWw-z7anH3Lj4A@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
	<5553A608.9080402@linaro.org>
	<2672178.pv4FEQMD9D@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <2672178.pv4FEQMD9D@wuerfel>
Sender: linux-gpio-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Daniel Thompson <daniel.thompson@linaro.org>, Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@>
List-Id: linux-api@vger.kernel.org

2015-05-13 21:37 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 13 May 2015 20:29:12 Daniel Thompson wrote:
>> On 13/05/15 17:54, Maxime Coquelin wrote:
>> > 2015-05-13 18:37 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
>> >>
>> >> We should definitely try to use the same compatible string for all of
>> >> them, and make a binding that is easy to use.
>> >>
>> >> I haven't fully understood the requirements for the various parts that
>> >> are involved here. My understanding so far was that the driver could
>> >> use the index from the first cell and compute
>> >>
>> >>          void __iomem *reset_reg = rcc_base + 0x10 + 4 * index;
>> >>          void __iomem *clock_reg = rcc_base + 0x30 + 4 * index;
>> >
>> > This calculation is true, but we have to take into account there is a
>> > hole in the middle, between AHB3, and APB1 register:
>>
>> ... and equally importantly, only allows us to use hardware mappings for
>> the gated clocks.
>>
>> > AHB1RSTR : offset = 0x10, index = 0
>> > AHB2RSTR : offset = 0x14, index = 1
>> > AHB3RSTR : offset = 0x18, index = 2
>> > <HOLE >     : offset = 0x1c, index = 3
>> > APB1RSTR : offset = 0x20, index = 4
>> > APB2RSTR : offset = 0x24, index = 5
>> >
>> > So we have to carefully document this hole in the bindings, maybe by
>> > listing indexes in the documentation?
>>
>> The register set has PLL, mux and dividers in the registers at 0x00,
>> 0x04 and 0x08.
>>
>> Many of these clocks can be kept out of DT entirely because they are
>> only there to feed other parts of the clock tree. However some of the
>> dividers flow directly into cells that appear in device tree (such as
>> the systick) and so we need to be able to reference them.
>>
>> In other words the proposed mapping cannot allow us to express the
>> dividers properly (because the index would have to be negative):
>>    void __iomem *clock_reg = rcc_base + 0x30 + 4 * index;
>>
>> Thus I'd favour using different indexes for reset and clock bindings,
>> both using the naive mapping function:
>>    void __iomem *reg =  rcc_base + 4 * index
>>
>> I think that its so much easier to check against the datasheet like
>> that. Admittedly is we follow the block-of-4-bytes idiom we have to
>> divide a hex number by four but thats not so hard and we end up with:
>>
>>               resets = <&rcc  8 0>;
>>               clocks = <&rcc 16 0>;
>>
>> At the end of the day if we say we want to follow the datasheet, lets be
>> do it in the most direct way properly.

Daniel, I'm fine with your proposal.
Doing that, we can have a single compatible string for stm32 family,
even if the reset start offset change between two chips.

>>
>>
>> PS
>> I've written a custom lookup function to to get from the DT index to an
>> offset into the struct clk *array I'm using. That means I don't care
>> much about any big holes in the register space.
>
> How about using the first cell to indicate the type (pll, mux, div, gate)
> and the second cell for the number (between 0 and 256)? That way, the
> gates numbers would match the reset numbers, and your internal mapping
> function would look a bit nicer.

That's another option.
In this case, for reset, we will only need one cell, right?

Regards,
Maxime



>
>         Arnd
