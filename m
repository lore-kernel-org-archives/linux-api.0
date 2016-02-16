From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Tue, 16 Feb 2016 16:17:31 +0100
Message-ID: <CACRpkdafDhT=1uJssVNAW+g05eXbRC1xUL+O0+SxcpdczUX0vQ@mail.gmail.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
	<1455617295-23736-10-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455617295-23736-10-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?Q?Pawe=C5=82_Moll?= <pawel.moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel@vger.k>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 16, 2016 at 11:08 AM, Vladimir Murzin
<vladimir.murzin-5wv7dgnIgG8@public.gmane.org> wrote:

> Application Notes 385 and 386 shares the same memory map and features
> except the CPU is used. AN385 is supplied with Cortex-M3 CPU and AN386
> is supplied with Cortex-M4.
>
> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
(...)
> +               fpgaio {
> +                       compatible = "syscon", "simple-mfd";
> +                       reg = <0x40028000 0x10>;
> +
> +                       led@0 {
> +                               compatible = "register-bit-led";
> +                               offset = <0x0>;
> +                               mask = <0x01>;
> +                               label = "userled:0";
> +                               linux,default-trigger = "heartbeat";
> +                               default-state = "on";
> +                       };
> +
> +                       led@1 {
> +                               compatible = "register-bit-led";
> +                               offset = <0x0>;
> +                               mask = <0x02>;
> +                               label = "userled:1";
> +                               linux,default-trigger = "usr";
> +                               default-state = "off";
> +                       };
> +               };

Thanks for using this. I worked hard to massage this into the
core.

Reviewed-by: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Yours,
Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
