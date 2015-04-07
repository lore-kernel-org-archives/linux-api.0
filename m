From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v6 09/15] dt-bindings: Document the STM32 USART bindings
Date: Tue, 7 Apr 2015 14:26:56 -0500
Message-ID: <CAL_JsqKiCDrwNq6CiWZvE0kiFT3v9sxvrrK62-JBRMSCvB5PHQ@mail.gmail.com>
References: <1428424234-28572-1-git-send-email-mcoquelin.stm32@gmail.com> <1428424234-28572-10-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1428424234-28572-10-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 7, 2015 at 11:30 AM, Maxime Coquelin
<mcoquelin.stm32@gmail.com> wrote:
> This adds documentation of device tree bindings for the
> STM32 USART
>
> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  .../devicetree/bindings/serial/st,stm32-usart.txt  | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt
>
> diff --git a/Documentation/devicetree/bindings/serial/st,stm32-usart.txt b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
> new file mode 100644
> index 0000000..8480a76
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
> @@ -0,0 +1,32 @@
> +* STMicroelectronics STM32 USART
> +
> +Required properties:
> +- compatible: Can be either "st,stm32-usart" or "st,stm32-uart" depending on
> +whether the device supports synchronous mode.
> +- reg: The address and length of the peripheral registers space
> +- interrupts: The interrupt line of the USART instance
> +- clocks: The input clock of the USART instance
> +
> +Optional properties:
> +- pinctrl: The reference on the pins configuration
> +- auto-flow-control: bool flag to enable hardware flow control.
> +
> +Examples:
> +usart4: serial@40004c00 {
> +       compatible = "st,stm32-uart";
> +       reg = <0x40004c00 0x400>;
> +       interrupts = <52>;
> +       clocks = <&clk_pclk1>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_usart4>;
> +};
> +
> +usart2: serial@40004400 {
> +       compatible = "st,stm32-usart", "st,stm32-uart";
> +       reg = <0x40004400 0x400>;
> +       interrupts = <38>;
> +       clocks = <&clk_pclk1>;
> +       auto-flow-control;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_usart2 &pinctrl_usart2_rtscts>;
> +};
> --
> 1.9.1
>
