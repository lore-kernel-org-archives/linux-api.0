From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 16/18] ARM: dts: Introduce STM32F429 MCU
Date: Mon, 9 Mar 2015 15:39:47 +0100
Message-ID: <CACRpkdaW-OMgGfw8+ngia8AsmzRpW8z7922=dPpRGjgv79-gqw@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-17-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424455277-29983-17-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 20, 2015 at 7:01 PM, Maxime Coquelin
<mcoquelin.stm32@gmail.com> wrote:

> The STMicrolectornics's STM32F419 MCU has the following main features:
>  - Cortex-M4 core running up to @180MHz
>  - 2MB internal flash, 256KBytes internal RAM
>  - FMC controller to connect SDRAM, NOR and NAND memories
>  - SD/MMC/SDIO support
>  - Ethernet controller
>  - USB OTFG FS & HS controllers
>  - I2C, SPI, CAN busses support
>  - Several 16 & 32 bits general purpose timers
>  - Serial Audio interface
>  - LCD controller
>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
(...)
> +       soc {
> +               usart1: usart@40011000 {
> +                       status = "okay";
> +               };
> +
> +               leds {
> +                       compatible = "gpio-leds";
> +                       red {
> +                               #gpio-cells = <2>;
> +                               label = "Front Panel LED";
> +                               gpios = <&gpiog 14 0>;
> +                               linux,default-trigger = "heartbeat";
> +                       };
> +                       green {
> +                               #gpio-cells = <2>;
> +                               gpios = <&gpiog 13 0>;
> +                               default-state = "off";
> +                       };
> +               };
> +       };

The LEDs are mounted on the board not the SoC, right?

So move them outside of the soc node, to the top level
of the DTS file.

Yours,
Linus Walleij
