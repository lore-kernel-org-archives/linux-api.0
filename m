From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 09/15] dt-bindings: Document the STM32 USART bindings
Date: Fri, 3 Apr 2015 12:14:20 -0500
Message-ID: <CAL_JsqKioFc65Gng0FbOOBCspwxr1-bdy1kShKRM24XyALPmOw@mail.gmail.com>
References: <1428080481-18591-1-git-send-email-mcoquelin.stm32@gmail.com> <1428080481-18591-10-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428080481-18591-10-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh@linu>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 3, 2015 at 12:01 PM, Maxime Coquelin
<mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This adds documentation of device tree bindings for the
> STM32 USART
>
> Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  .../devicetree/bindings/serial/st,stm32-usart.txt  | 32 ++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt
>
> diff --git a/Documentation/devicetree/bindings/serial/st,stm32-usart.txt b/Documentation/devicetree/bindings/serial/st,stm32-usart.txt
> new file mode 100644
> index 0000000..090a3a4
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
> +- st,hw-flow-ctrl: bool flag to enable hardware flow control.

We already have "auto-flow-control" for 8250. Does that work for you?

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
> +       st,hw-flow-ctrl;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_usart2 &pinctrl_usart2_rtscts>;
> +};
> --
> 1.9.1
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
