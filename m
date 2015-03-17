From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 05/15] dt-bindings: Document the STM32 reset bindings
Date: Tue, 17 Mar 2015 18:13:48 +0100
Message-ID: <CALszF6DDvjy6-5kzQ3B4JiNocTZPoFdMTvFqii0diTm2kC96xw@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-6-git-send-email-maxime.coquelin@st.com>
	<1426236654.3083.19.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426236654.3083.19.camel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab@os>
List-Id: linux-api@vger.kernel.org

Hi Philipp,

2015-03-13 9:50 GMT+01:00 Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>:
> Hi Maxime,
>
> Am Donnerstag, den 12.03.2015, 22:55 +0100 schrieb Maxime Coquelin:
>> From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> This adds documentation of device tree bindings for the
>> STM32 reset controller.
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  .../devicetree/bindings/reset/st,stm32-rcc.txt     | 102 +++++++++++++++++++++
>>  1 file changed, 102 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>> new file mode 100644
>> index 0000000..962f961
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>> @@ -0,0 +1,102 @@
>> +STMicroelectronics STM32 Peripheral Reset Controller
>> +====================================================
>> +
>> +The RCC IP is both a reset and a clock controller. This documentation only
>> +document the reset part.
>> +
>> +Please also refer to reset.txt in this directory for common reset
>> +controller binding usage.
>> +
>> +Required properties:
>> +- compatible: Should be "st,stm32-rcc"
>> +- reg: should be register base and length as documented in the
>> +  datasheet
>> +- #reset-cells: 1, see below
>> +
>> +example:
>> +
>> +rcc: reset@40023800 {
>> +     #reset-cells = <1>;
>> +     compatible = "st,stm32-rcc";
>> +     reg = <0x40023800 0x400>;
>> +};
>> +
>> +Specifying softreset control of devices
>> +=======================================
>> +
>> +Device nodes should specify the reset channel required in their "resets"
>> +property, containing a phandle to the reset device node and an index specifying
>> +which channel to use.
>
> Using a single value as index is ok, but it should be documented how
> this corresponds to the register and bit offsets in the reference
> manual.
> Maybe add a comment that the index is in fact the register offset / 4 *
> 32 + bit offset in that register and that not all registers are
> dedicated to the rest controller? Otherwise it is confusing (to me at
> least) that the indices start at some arbitrary value.

I agree to better document it. Are you ok with:

The index is the bit number within the RCC registers bank, starting from RCC
base address.
It is calculated as: index = register_offset / 4 * 32 + bit_offset.
Where bit_offset is the bit offset within the register.
For example, for CRC reset:
  crc = AHB1RSTR_offset / 4 * 32 + CRCRST_bit_offset = 0x10 / 4 * 32 + 12 = 140


>
>> +example:
>> +
>> +     timer2 {
>> +             resets                  = <&rcc 256>;
>> +     };
>> +
>> +List of indexes for STM32F429:
>
> "List of valid indices", to point out that any other index is invalid?

Right, it will be changed in v4.

>
>> + - gpioa: 128
>
> I had to look at the RM0090 Reference manual V8.0, Chapter 6, "Reset and
> clock control for STM32F42xx and STM32F43xxx (RCC)" to see that the
> reset registers indeed start at 0x10 (RCC_AHB1RSTR), ...
>
>> + - gpiob: 129
>> + - gpioc: 130
>> + - gpiod: 131
>> + - gpioe: 132
>> + - gpiof: 133
>> + - gpiog: 134
>> + - gpioh: 135
>> + - gpioi: 136
>> + - gpioj: 137
>> + - gpiok: 138
>> + - crc: 140
>> + - dma1: 149
>> + - dma2: 150
>> + - dma2d: 151
>> + - ethmac: 153
>> + - otghs: 157
>> + - dcmi: 160
>> + - cryp: 164
>> + - hash: 165
>> + - rng: 166
>> + - otgfs: 167
>> + - fmc: 192
>> + - tim2: 256
>> + - tim3: 257
>> + - tim4: 258
>> + - tim5: 259
>> + - tim6: 260
>> + - tim7: 261
>> + - tim12: 262
>> + - tim13: 263
>> + - tim14: 264
>> + - wwdg: 267
>> + - spi2: 270
>> + - spi3: 271
>> + - uart2: 273
>> + - uart3: 274
>> + - uart4: 275
>> + - uart5: 276
>> + - i2c1: 277
>> + - i2c2: 278
>> + - i2c3: 279
>> + - can1: 281
>> + - can2: 282
>> + - pwr: 284
>> + - dac: 285
>> + - uart7: 286
>> + - uart8: 287
>> + - tim1: 288
>> + - tim8: 289
>> + - usart1: 292
>> + - usart6: 293
>> + - adc: 296
>> + - sdio: 299
>> + - spi1: 300
>> + - spi4: 301
>> + - syscfg: 302
>> + - tim9: 304
>> + - tim10: 305
>> + - tim11: 306
>> + - spi5: 308
>> + - spi6: 309
>> + - sai1: 310
>> + - ltdc: 31
>
> That last one should say "ltdc: 314", right?
Thanks for catching this!
Just fixed it, it will be in v4.

Kind regards,
Maxime

>
> regards
> Philipp
>
