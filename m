From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v4 05/15] dt-bindings: Document the STM32 reset bindings
Date: Wed, 1 Apr 2015 11:32:17 -0500
Message-ID: <CAL_Jsq++ojQOeP1RBOQffOJKzW+M=ygpWaB=ryZ7APbtgZSVzQ@mail.gmail.com>
References: <1427819096-31109-1-git-send-email-mcoquelin.stm32@gmail.com> <1427819096-31109-6-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1427819096-31109-6-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, pmeerw@pmeerw.net, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, andy.shevchenko@gmail.com, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 31, 2015 at 11:24 AM, Maxime Coquelin
<mcoquelin.stm32@gmail.com> wrote:
> This adds documentation of device tree bindings for the
> STM32 reset controller.
>
> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>

Nothing really new here.

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  .../devicetree/bindings/reset/st,stm32-rcc.txt     | 107 +++++++++++++++++++++
>  1 file changed, 107 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>
> diff --git a/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
> new file mode 100644
> index 0000000..e2e2f25
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
> @@ -0,0 +1,107 @@
> +STMicroelectronics STM32 Peripheral Reset Controller
> +====================================================
> +
> +The RCC IP is both a reset and a clock controller. This documentation only
> +document the reset part.
> +
> +Please also refer to reset.txt in this directory for common reset
> +controller binding usage.
> +
> +Required properties:
> +- compatible: Should be "st,stm32-rcc"
> +- reg: should be register base and length as documented in the
> +  datasheet
> +- #reset-cells: 1, see below
> +
> +example:
> +
> +rcc: reset@40023800 {
> +       #reset-cells = <1>;
> +       compatible = "st,stm32-rcc";
> +       reg = <0x40023800 0x400>;
> +};
> +
> +Specifying softreset control of devices
> +=======================================
> +
> +Device nodes should specify the reset channel required in their "resets"
> +property, containing a phandle to the reset device node and an index specifying
> +which channel to use.
> +The index is the bit number within the RCC registers bank, starting from RCC
> +base address.
> +It is calculated as: index = register_offset / 4 * 32 + bit_offset.
> +Where bit_offset is the bit offset within the register.
> +For example, for CRC reset:
> +  crc = AHB1RSTR_offset / 4 * 32 + CRCRST_bit_offset = 0x10 / 4 * 32 + 12 = 140
> +
> +example:
> +
> +       timer2 {
> +               resets                  = <&rcc 256>;
> +       };
> +
> +List of valid indices for STM32F429:
> + - gpioa: 128
> + - gpiob: 129
> + - gpioc: 130
> + - gpiod: 131
> + - gpioe: 132
> + - gpiof: 133
> + - gpiog: 134
> + - gpioh: 135
> + - gpioi: 136
> + - gpioj: 137
> + - gpiok: 138
> + - crc: 140
> + - dma1: 149
> + - dma2: 150
> + - dma2d: 151
> + - ethmac: 153
> + - otghs: 157
> + - dcmi: 160
> + - cryp: 164
> + - hash: 165
> + - rng: 166
> + - otgfs: 167
> + - fmc: 192
> + - tim2: 256
> + - tim3: 257
> + - tim4: 258
> + - tim5: 259
> + - tim6: 260
> + - tim7: 261
> + - tim12: 262
> + - tim13: 263
> + - tim14: 264
> + - wwdg: 267
> + - spi2: 270
> + - spi3: 271
> + - uart2: 273
> + - uart3: 274
> + - uart4: 275
> + - uart5: 276
> + - i2c1: 277
> + - i2c2: 278
> + - i2c3: 279
> + - can1: 281
> + - can2: 282
> + - pwr: 284
> + - dac: 285
> + - uart7: 286
> + - uart8: 287
> + - tim1: 288
> + - tim8: 289
> + - usart1: 292
> + - usart6: 293
> + - adc: 296
> + - sdio: 299
> + - spi1: 300
> + - spi4: 301
> + - syscfg: 302
> + - tim9: 304
> + - tim10: 305
> + - tim11: 306
> + - spi5: 308
> + - spi6: 309
> + - sai1: 310
> + - ltdc: 314
> --
> 1.9.1
>
