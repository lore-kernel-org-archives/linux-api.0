From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 10/18] dt-bindings: Document the STM32 pin controller
Date: Fri, 6 Mar 2015 10:12:53 +0100
Message-ID: <CACRpkdaRuFE4Ja8pJEGKuf7yorkyjAHwB+KZn7yz60P+ZnyvOg@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-11-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424455277-29983-11-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 20, 2015 at 7:01 PM, Maxime Coquelin
<mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This adds documentation of device tree bindings for the
> STM32 pin controller.
>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
(...)
> +Pin controller node:
> +Required properies:
> +- compatible   : "st,stm32-pinctrl"
> +- #address-cells: The value of this property must be 1
> +- #size-cells  : The value of this property must be 1
> +- ranges       : defines mapping between pin controller node (parent) to
> +  gpio-bank node (children).
> +
> +GPIO controller/bank node:
> +Required properties:
> +- gpio-controller : Indicates this device is a GPIO controller
> +- #gpio-cells    : Should be two.
> +                       The first cell is the pin number
> +                       The second one is the polarity:
> +                               - 0 for active high
> +                               - 1 for active low
> +- reg            : The gpio address range, relative to the pinctrl range
> +- st,bank-name   : Should be a name string for this bank as specified in
> +  the datasheet

OK...

(...)
> +               ...
> +               pin-functions nodes follow...
> +       };
> +
> +Contents of function subnode node:
> +----------------------------------
> +
> +Required properties for pin configuration node:
> +- st,pins      : Child node with list of pins with configuration.

Don't use vendor prefix. Use the new standard notation, just "pins".
See Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

> +Below is the format of how each pin conf should look like.
> +
> +<bank offset altmode pull type speed>
> +
> +Every PIO is represented with 4 to 6 parameters.
> +Each parameter is explained as below.
> +
> +- bank   : Should be bank phandle to which this PIO belongs.
> +- offset  : Offset in the PIO bank.

No. Don't hardcode register offsets into the DTS files. This is
something the driver should know from the compatible string or
instance number, not by explicit reference.

> +- altmode : Should be mode or alternate function number associated this pin, as
> +described in the datasheet (IN, OUT, ALT0...ALT15, ANALOG)
> +- pull   : Should be either NO_PULL, PULL_UP or PULL_DOWN
> +- type   : Should be either PUSH_PULL or OPEN_DRAIN.
> +           Setting it is not needed for IN and ANALOG modes, or alternate
> +           functions acting as inputs.
> +- speed          : Value taken from the datasheet, depending on the function
> +(LOW_SPEED, MEDIUM_SPEED, FAST_SPEED, HIGH_SPEED)
> +           Setting it is not needed for IN and ANALOG modes, or alternate
> +           functions acting as inputs.

NACK. Make your Kconfig select GENERIC_PINCONF and use the
already existing generic pin configuration specifiers from the standard
bindings. Like bias-pull-up; etc.

This kind of custom pin config is a thing of the past.

> +usart1 {
> +       pinctrl_usart1: usart1-0 {
> +               st,pins {
> +                       tx = <&gpioa 9 ALT7 NO_PULL PUSH_PULL LOW_SPEED>;
> +                       rx = <&gpioa 10 ALT7 NO_PULL PUSH_PULL LOW_SPEED>;
> +               };
> +       };
> +};

You might have to use separate parameters for muxing and config
in your description.

Yours,
Linus Walleij
