From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v7 05/15] dt-bindings: Document the STM32 reset bindings
Date: Mon, 4 May 2015 13:25:17 +0200
Message-ID: <CALszF6BTb0Ce6jfT5gY4eEtSep6+8XqOxu1LbpUXHmPYX9PmgQ@mail.gmail.com>
References: <1430410844-16062-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1430410844-16062-6-git-send-email-mcoquelin.stm32@gmail.com>
	<55433467.2010603@linaro.org>
	<CALszF6Bw900E9MtpaVmvkFxsrOODRkNg+RxRXz5V3WghHtsxbw@mail.gmail.com>
	<5544A069.5000808@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <5544A069.5000808@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Daniel Thompson <daniel.thompson@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linu>
List-Id: linux-api@vger.kernel.org

2015-05-02 12:01 GMT+02:00 Daniel Thompson <daniel.thompson@linaro.org>:
> On 02/05/15 08:55, Maxime Coquelin wrote:
>>
>> 2015-05-01 10:08 GMT+02:00 Daniel Thompson <daniel.thompson@linaro.org>:
>>>
>>> On 30/04/15 17:20, Maxime Coquelin wrote:
>>>>
>>>>
>>>> This adds documentation of device tree bindings for the
>>>> STM32 reset controller.
>>>>
>>>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
>>>> Acked-by: Rob Herring <robh@kernel.org>
>>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>>> ---
>>>>    .../devicetree/bindings/reset/st,stm32-rcc.txt     | 107
>>>> +++++++++++++++++++++
>>>>    1 file changed, 107 insertions(+)
>>>>    create mode 100644
>>>> Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>>>> b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>>>> new file mode 100644
>>>> index 0000000..c1b0f8d
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>>>> @@ -0,0 +1,107 @@
>>>> +STMicroelectronics STM32 Peripheral Reset Controller
>>>> +====================================================
>>>> +
>>>> +The RCC IP is both a reset and a clock controller. This documentation
>>>> only
>>>> +documents the reset part.
>>>> +
>>>> +Please also refer to reset.txt in this directory for common reset
>>>> +controller binding usage.
>>>> +
>>>> +Required properties:
>>>> +- compatible: Should be "st,stm32-rcc"
>>>> +- reg: should be register base and length as documented in the
>>>> +  datasheet
>>>> +- #reset-cells: 1, see below
>>>> +
>>>> +example:
>>>> +
>>>> +rcc: reset@40023800 {
>>>> +       #reset-cells = <1>;
>>>> +       compatible = "st,stm32-rcc";
>>>
>>>
>>>
>>> Do you intend the clock driver to use the same compatible string (given
>>> it
>>> is the same bit of hardware).
>>>
>>> If so, is it better to use st,stm32f4-rcc here? It seems unlikey to me
>>> that
>>> the register layout of the PLLs and dividers can be the same on the f7
>>> parts
>>> (and later).
>>
>>
>> I agree we need a compatible dedicate to f4 series for clocks, and
>> maybe even one for f429 (to be checked).
>> For the reset part, we don't have this need.
>>
>> So either we use only "st,stm32f4" as you suggest, or we can have both
>> in device tree:
>>
>> rcc: reset@40023800 {
>>      #reset-cells = <1>;
>>      compatible = "st,stm32f4-rcc", "st,stm32-rcc";
>>      reg = <0x40023800 0x400>;
>> };
>>
>> What do you think?
>
>
> Having both makes sense. The reset driver probably doesn't care about
> differences between F4 and F7 (I know very little about F7 but I can't think
> of any obvious h/ware evolution that would confuse the current reset
> driver).
>
>
>>>> +       reg = <0x40023800 0x400>;
>>>> +};
>>>> +
>>>> +Specifying softreset control of devices
>>>> +=======================================
>>>> +
>>>> +Device nodes should specify the reset channel required in their
>>>> "resets"
>>>> +property, containing a phandle to the reset device node and an index
>>>> specifying
>>>> +which channel to use.
>>>> +The index is the bit number within the RCC registers bank, starting
>>>> from
>>>> RCC
>>>> +base address.
>>>> +It is calculated as: index = register_offset / 4 * 32 + bit_offset.
>>>> +Where bit_offset is the bit offset within the register.
>>>> +For example, for CRC reset:
>>>> +  crc = AHB1RSTR_offset / 4 * 32 + CRCRST_bit_offset = 0x10 / 4 * 32 +
>>>> 12
>>>> = 140
>>>> +
>>>> +example:
>>>> +
>>>> +       timer2 {
>>>> +               resets                  = <&rcc 256>;
>>>> +       };
>>>> +
>>>> +List of valid indices for STM32F429:
>>>> + - gpioa: 128
>>>> + - gpiob: 129
>>>> ...
>>>> <snip>
>>>> ...
>>>> + - sai1: 310
>>>> + - ltdc: 314
>>>
>>>
>>>
>>> These numbers are stable for all STM32F4 family parts. Should this table
>>> go
>>> into a dt-bindings header file?
>>>
>>
>> This has already been discussed with Philipp and Arnd in earlier
>> versions of this series [0].
>> I initially created a header file, and we  decided going this way finally.
>
>
> Thanks for the link. I had overlooked that (I only really started paying
> attention at v5; I should probably have looked further back before
> commenting).
>
> However...
>
> Arnd's concerns about mergability of headers can also be met by using h/ware
> values in the header file can't there. To be honest my comment was pretty
> heavily influenced after having read a recent patch from Rob Herring (
> https://lkml.org/lkml/2015/5/1/14 ) which does exactly this.
>
> The main reason I got interested in having a header is that the reset bits
> and the clock gate bits are encoded using the same bit patterns so I
> wondering it we could express that only once.

Ok, I understand your need, and it makes sense.
The problem is that the values defined today cannot be re-used
directly for clocks.
Since the calculation is starting from rcc base, there is a 128 offset.

To re-use the same values, maybe we should create a mfd dt-binding header file.
It would contain the bits definition starting from 0, and  define
macros for both reset and clocks to add the offsets.

For example, includes/dt-bindings/mfd/stm32f4-rcc.h would look like:

#define GPIOA 0
#define GPIOB 1
...
#define LTDC 186

#define STM32F4_RESET(x) (x + 128)
#define STM32F4_CLOCK(x) (x + 384)

Then, in DT, a reset would be described like this:

timer2 {
    resets = <&rcc STM32F4_RESET(TIM2)>;
};

Phillip, Daniel, does that look acceptable to you?

Kind regards,
Maxime
>
> I guess it doesn't matter that much, especially given there is only one
> .dtsi file, and we can add a header later and remain binary compatible.
> However if the same number set does end up repeated in different .dtsi files
> I think that would motivate adding a header for F4 family.
>
>
> Daniel.
>
